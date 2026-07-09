// 任务与能量核心管理实现文件：处理免提醒推荐任务存储及动态核心结算
#include "TaskManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantMap>

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
    db.setDatabaseName("voltflow.db");
    if (db.open()) {
        QSqlQuery q;
        q.exec("CREATE TABLE IF NOT EXISTS user_tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, priority INTEGER, deadline DATETIME, review_type INTEGER, review_interval INTEGER, energy_reward INTEGER, is_rec INTEGER DEFAULT 0, status INTEGER DEFAULT 0)");
        q.exec("CREATE TABLE IF NOT EXISTS sys_recs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
        q.exec("CREATE TABLE IF NOT EXISTS sys_data (date_str TEXT PRIMARY KEY, current_energy INTEGER, weekly_energy INTEGER, total_energy INTEGER, tasks_added INTEGER, tasks_completed INTEGER)");

        q.exec("SELECT COUNT(*) FROM sys_recs");
        if (q.next() && q.value(0).toInt() == 0) {
            q.exec("INSERT INTO sys_recs (name) VALUES ('今日高效番茄钟专注')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('补充水分与核心拉伸')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('多维深度睡眠调理')");
        }
    }
}

void TaskManager::load_tasks() {
    m_user_tasks.clear();
    QSqlQuery q("SELECT id, name, priority, deadline, review_type, review_interval, energy_reward, is_rec FROM user_tasks WHERE status = 0");
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
    emit userTasksChanged();
}

void TaskManager::load_sys_recs() {
    m_sys_recs.clear();
    QSqlQuery q("SELECT id, name FROM sys_recs");
    while (q.next()) {
        QVariantMap rec;
        rec["id"] = q.value(0).toInt();
        rec["name"] = q.value(1).toString();
        m_sys_recs.append(rec);
    }
    emit sysRecsChanged();
}

void TaskManager::load_sys_data() {
    QString today = m_current_time.toString("yyyy-MM-dd");
    QSqlQuery q;
    q.prepare("SELECT current_energy, weekly_energy, total_energy, tasks_added, tasks_completed FROM sys_data WHERE date_str = :d");
    q.bindValue(":d", today);
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
    q.prepare("REPLACE INTO sys_data (date_str, current_energy, weekly_energy, total_energy, tasks_added, tasks_completed) VALUES (:d, :ce, :we, :te, :ta, :tc)");
    q.bindValue(":d", today);
    q.bindValue(":ce", m_current_energy);
    q.bindValue(":we", m_weekly_energy);
    q.bindValue(":te", m_total_energy);
    q.bindValue(":ta", m_tasks_added);
    q.bindValue(":tc", m_tasks_completed);
    q.exec();
}

void TaskManager::addTask(const QString &name, int priority, const QDateTime &deadline, int reviewType, int reviewInt, int reward, int isRec) {
    if (name.isEmpty()) return;
    QSqlQuery q;
    q.prepare("INSERT INTO user_tasks (name, priority, deadline, review_type, review_interval, energy_reward, is_rec) VALUES (?, ?, ?, ?, ?, ?, ?)");
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
    }
}

void TaskManager::addRecPool(const QString &name) {
    if (name.isEmpty()) return;
    QSqlQuery q;
    q.prepare("INSERT INTO sys_recs (name) VALUES (?)");
    q.addBindValue(name);
    if (q.exec()) load_sys_recs();
}

void TaskManager::completeTask(int id) {
    QSqlQuery q;
    q.prepare("SELECT energy_reward FROM user_tasks WHERE id = ? AND status = 0");
    q.addBindValue(id);
    if (q.exec() && q.next()) {
        m_current_energy += q.value(0).toInt();
        m_tasks_completed++;
        QSqlQuery u;
        u.prepare("UPDATE user_tasks SET status = 1 WHERE id = ?");
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
        q.prepare("DELETE FROM sys_recs WHERE id = ?");
        q.addBindValue(id);
        if (q.exec()) load_sys_recs();
    } else {
        q.prepare("DELETE FROM user_tasks WHERE id = ?");
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
            // 每小时固定掉电，但如果是系统推荐任务未完不触发额外惩罚
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
        if (t["is_rec"].toInt() == 1) continue; // 🌟 核心：推荐任务跳过一切到期与弹窗提醒逻辑

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