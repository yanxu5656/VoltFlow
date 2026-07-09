// 任务与能量核心管理实现文件：升级独立版本数据库，加入全链路安全校验防静默失败
#include "TaskManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantMap>
#include <QDebug>

TaskManager::TaskManager(QObject *parent) : QObject(parent) {
    m_current_time = QDateTime::currentDateTime();
    m_last_hour = m_current_time.time().hour();
    init_db();
    load_tasks();
    load_sys_recs();
    load_sys_data();
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &TaskManager::onTick);
    m_timer->start(1000);
}

void TaskManager::init_db() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    // 💡 核心绝招：升级为 v3 专属数据库名，强制在用户电脑里开辟全新干净的表结构，绕过旧文件残留
    db.setDatabaseName("voltflow_v3.db");
    if (db.open()) {
        QSqlQuery q;
        if (!q.exec("CREATE TABLE IF NOT EXISTS user_tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, priority INTEGER, deadline DATETIME, review_type INTEGER, review_interval INTEGER, energy_reward INTEGER, is_rec INTEGER DEFAULT 0, status INTEGER DEFAULT 0)")) {
            qDebug() << "创建 user_tasks 表失败:" << q.lastError().text();
        }
        if (!q.exec("CREATE TABLE IF NOT EXISTS sys_recs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)")) {
            qDebug() << "创建 sys_recs 表失败:" << q.lastError().text();
        }
        if (!q.exec("CREATE TABLE IF NOT EXISTS sys_data (date_str TEXT PRIMARY KEY, current_energy INTEGER, weekly_energy INTEGER, total_energy INTEGER, tasks_added INTEGER, tasks_completed INTEGER)")) {
            qDebug() << "创建 sys_data 表失败:" << q.lastError().text();
        }

        q.exec("SELECT COUNT(*) FROM sys_recs");
        if (q.next() && q.value(0).toInt() == 0) {
            q.exec("INSERT INTO sys_recs (name) VALUES ('今日高效番茄钟专注')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('补充水分与核心拉伸')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('多维深度睡眠调理')");
        }
    } else {
        qDebug() << "无法连接或打开本地 SQLite 核心文件:" << db.lastError().text();
    }
}

void TaskManager::load_tasks() {
    m_user_tasks.clear();
    QSqlQuery q;
    if (q.exec("SELECT id, name, priority, deadline, review_type, review_interval, energy_reward, is_rec FROM user_tasks WHERE status = 0")) {
        while (q.next()) {
            QVariantMap task;
            task["id"] = q.value(0).toInt();
            task["name"] = q.value(1).toString();
            task["priority"] = q.value(2).toInt();
            task["deadline"] = q.value(3).toDateTime();
            task["review_type"] = q.value(4).toInt();
            task["review_interval"] = q.value(5).toInt();
            task["energy_reward"] = q.value(6).toInt();
            task["is_rec"] = q.value(7).toInt();
            m_user_tasks.append(task);
        }
    } else {
        qDebug() << "载入活动任务失败:" << q.lastError().text();
    }
    emit userTasksChanged();
}

void TaskManager::load_sys_recs() {
    m_sys_recs.clear();
    QSqlQuery q;
    if (q.exec("SELECT id, name FROM sys_recs")) {
        while (q.next()) {
            QVariantMap rec;
            rec["id"] = q.value(0).toInt();
            rec["name"] = q.value(1).toString();
            m_sys_recs.append(rec);
        }
    } else {
        qDebug() << "载入系统池失败:" << q.lastError().text();
    }
    emit sysRecsChanged();
}

void TaskManager::load_sys_data() {
    QString today = m_current_time.toString("yyyy-MM-dd");
    QSqlQuery q;
    // 💡 增加安全 prepare 拦截
    if (!q.prepare("SELECT current_energy, weekly_energy, total_energy, tasks_added, tasks_completed FROM sys_data WHERE date_str = ?")) {
        qDebug() << "加载系统日志预处理失败:" << q.lastError().text();
        return;
    }
    q.addBindValue(today);
    if (q.exec() && q.next()) {
        m_current_energy = q.value(0).toInt();
        m_weekly_energy = q.value(1).toInt();
        m_total_energy = q.value(2).toInt();
        m_tasks_added = q.value(3).toInt();
        m_tasks_completed = q.value(4).toInt();
    } else {
        m_current_energy = 100;
        m_tasks_added = 0;
        m_tasks_completed = 0;
        save_sys_data();
    }
    emit energyChanged();
    emit statsChanged();
}

void TaskManager::save_sys_data() {
    QString today = m_current_time.toString("yyyy-MM-dd");
    QSqlQuery q;
    // 💡 增加安全 prepare 拦截
    if (!q.prepare("REPLACE INTO sys_data (date_str, current_energy, weekly_energy, total_energy, tasks_added, tasks_completed) VALUES (?, ?, ?, ?, ?, ?)")) {
        qDebug() << "保存系统日志预处理失败:" << q.lastError().text();
        return;
    }
    q.addBindValue(today);
    q.addBindValue(m_current_energy);
    q.addBindValue(m_weekly_energy);
    q.addBindValue(m_total_energy);
    q.addBindValue(m_tasks_added);
    q.addBindValue(m_tasks_completed);
    if (!q.exec()) {
        qDebug() << "同步系统核心历史数据失败:" << q.lastError().text();
    }
}

void TaskManager::addTask(const QString &name, int priority, int durationHours, int reviewType, int reviewInt, int reward, int isRec) {
    if (name.isEmpty()) return;

    QDateTime deadline = m_current_time.addSecs(durationHours * 3600);
    QSqlQuery q;

    // 💡 换用高包容度、绝对对齐的顺序问号语法，并且对 prepare 的执行状态进行前置严格拦截
    if (!q.prepare("INSERT INTO user_tasks (name, priority, deadline, review_type, review_interval, energy_reward, is_rec, status) "
                   "VALUES (?, ?, ?, ?, ?, ?, ?, 0)")) {
        qDebug() << "【核心警报】SQL 预处理(prepare)失败，原因:" << q.lastError().text();
        return; // 发现表结构不对马上拦截，决不盲目允许往下执行 exec 产生混淆报错
    }

    // 7个参数，严格对应上面的7个问号
    q.addBindValue(name);
    q.addBindValue(priority);
    q.addBindValue(deadline);
    q.addBindValue(reviewType);
    q.addBindValue(reviewInt);
    q.addBindValue(reward);
    q.addBindValue(isRec);

    if (q.exec()) {
        m_tasks_added++;
        save_sys_data();
        emit statsChanged();
        load_tasks();
    } else {
        qDebug() << "SQL 执行投放物理任务失败，原因:" << q.lastError().text();
    }
}

void TaskManager::addRecPool(const QString &name) {
    if (name.isEmpty()) return;
    QSqlQuery q;
    if (!q.prepare("INSERT INTO sys_recs (name) VALUES (?)")) return;
    q.addBindValue(name);
    if (q.exec()) load_sys_recs();
}

void TaskManager::completeTask(int id) {
    QSqlQuery q;
    if (!q.prepare("SELECT energy_reward FROM user_tasks WHERE id = ? AND status = 0")) return;
    q.addBindValue(id);
    if (q.exec() && q.next()) {
        m_current_energy += q.value(0).toInt();
        m_tasks_completed++;
        QSqlQuery u;
        if (!u.prepare("UPDATE user_tasks SET status = 1 WHERE id = ?")) return;
        u.addBindValue(id);
        u.exec();
        save_sys_data();
        emit energyChanged();
        emit statsChanged();
        load_tasks();
    }
}

void TaskManager::removeTask(int id, bool isPool) {
    QSqlQuery q;
    if (isPool) {
        if (!q.prepare("DELETE FROM sys_recs WHERE id = ?")) return;
        q.addBindValue(id);
        if (q.exec()) load_sys_recs();
    } else {
        if (!q.prepare("DELETE FROM user_tasks WHERE id = ?")) return;
        q.addBindValue(id);
        if (q.exec()) load_tasks();
    }
}

void TaskManager::addDemoTime(int hours) {
    m_current_time = m_current_time.addSecs(hours * 3600);
    emit timeChanged();
    onTick();
}

void TaskManager::onTick() {
    if (m_timer->interval() == 1000) m_current_time = m_current_time.addSecs(1);
    int currentHour = m_current_time.time().hour();
    if (currentHour != m_last_hour) {
        if (currentHour == 7) {
            m_current_energy = 100;
        } else {
            m_current_energy = qMax(0, m_current_energy - 10);
        }
        if (currentHour == 0) {
            m_weekly_energy += m_current_energy;
            m_total_energy += m_current_energy;
            m_tasks_added = 0;
            m_tasks_completed = 0;
            save_sys_data();
            emit statsChanged();
        }
        m_last_hour = currentHour;
        save_sys_data();
        emit energyChanged();
    }
    check_reminders();
}

void TaskManager::check_reminders() {
    for (int i = 0; i < m_user_tasks.size(); ++i) {
        QVariantMap t = m_user_tasks[i].toMap();
        if (t["is_rec"].toInt() == 1) continue;

        int id = t["id"].toInt();
        QString name = t["name"].toString();
        int priority = t["priority"].toInt();
        QDateTime dl = t["deadline"].toDateTime();
        int revType = t["review_type"].toInt();
        int revInt = t["review_interval"].toInt();

        int intervalHours = 24;
        if (priority == 5) intervalHours = 1;
        else if (priority == 4) intervalHours = 3;
        else if (priority == 3) intervalHours = 6;
        else if (priority == 2) intervalHours = 12;

        if (m_current_time.secsTo(dl) > 0) {
            if (!m_last_reminded.contains(id) || m_last_reminded[id].secsTo(m_current_time) >= intervalHours * 3600) {
                m_last_reminded[id] = m_current_time;
                emit triggerShake("任务临期: " + name, false);
            }
        }
        if (revType > 0 && revInt > 0) {
            if (m_current_time.time().second() % 30 == 0) {
                emit triggerShake("复习提醒: " + name, true);
            }
        }
    }
}