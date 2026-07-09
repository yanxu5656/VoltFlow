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
    load_store_items();
    load_sys_data();
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &TaskManager::onTick);
    m_timer->start(1000);
}

void TaskManager::init_db() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("voltflow_v3.db");
    if (db.open()) {
        QSqlQuery q;
        q.exec("CREATE TABLE IF NOT EXISTS user_tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, priority INTEGER, deadline DATETIME, review_type INTEGER, review_interval INTEGER, energy_reward INTEGER, is_rec INTEGER DEFAULT 0, status INTEGER DEFAULT 0)");
        q.exec("CREATE TABLE IF NOT EXISTS sys_recs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
        q.exec("CREATE TABLE IF NOT EXISTS store_items (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price INTEGER)");
        q.exec("CREATE TABLE IF NOT EXISTS sys_data (date_str TEXT PRIMARY KEY, current_energy INTEGER, weekly_energy INTEGER, total_energy INTEGER, tasks_added INTEGER, tasks_completed INTEGER)");
        q.exec("SELECT COUNT(*) FROM sys_recs");
        if (q.next() && q.value(0).toInt() == 0) {
            q.exec("INSERT INTO sys_recs (name) VALUES ('今日高效番茄钟专注')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('补充水分与核心拉伸')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('多维深度睡眠调理')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('核心极简代码结构重构')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('系统数据库边界压力测试')");
            q.exec("INSERT INTO sys_recs (name) VALUES ('每日流转趋势数据复盘')");
        }
        q.exec("SELECT COUNT(*) FROM store_items");
        if (q.next() && q.value(0).toInt() == 0) {
            q.exec("INSERT INTO store_items (name, price) VALUES ('高端护盾结界拓展包', 50)");
            q.exec("INSERT INTO store_items (name, price) VALUES ('午后深度唤醒咖啡因', 20)");
            q.exec("INSERT INTO store_items (name, price) VALUES ('周日全量核心注能加速卡', 80)");
        }
    }
}

void TaskManager::clearDatabase() {
    QSqlQuery q;
    q.exec("DELETE FROM user_tasks");
    q.exec("DELETE FROM sys_data");
    m_current_energy = 100;
    m_weekly_energy = 0;
    m_total_energy = 0;
    m_tasks_added = 0;
    m_tasks_completed = 0;
    save_sys_data();
    load_tasks();
    emit energyChanged();
    emit statsChanged();
    emit historicalEnergyChanged();
}

QVariantList TaskManager::historicalEnergy() const {
    QVariantList list;
    for (int i = 6; i >= 0; --i) {
        QString targetDate = m_current_time.addDays(-i).toString("yyyy-MM-dd");
        QSqlQuery q;
        q.prepare("SELECT current_energy FROM sys_data WHERE date_str = ?");
        q.addBindValue(targetDate);
        if (q.exec() && q.next()) {
            list.append(q.value(0).toInt());
        } else {
            list.append(0);
        }
    }
    return list;
}

void TaskManager::activateRecommendation(const QString &name) {
    addTask(name, 2, 24, 0, 0, 20, 1);
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
    }
    emit userTasksChanged();
}

void TaskManager::load_sys_recs() {
    m_sys_recs.clear();
    QSqlQuery q;
    if (q.exec("SELECT id, name FROM sys_recs ORDER BY RANDOM() LIMIT 4")) {
        while (q.next()) {
            QVariantMap rec;
            rec["id"] = q.value(0).toInt();
            rec["name"] = q.value(1).toString();
            m_sys_recs.append(rec);
        }
    }
    emit sysRecsChanged();
}

void TaskManager::load_store_items() {
    m_store_items.clear();
    QSqlQuery q;
    if (q.exec("SELECT id, name, price FROM store_items")) {
        while (q.next()) {
            QVariantMap item;
            item["id"] = q.value(0).toInt();
            item["name"] = q.value(1).toString();
            item["price"] = q.value(2).toInt();
            m_store_items.append(item);
        }
    }
    emit storeItemsChanged();
}

void TaskManager::load_sys_data() {
    QString today = m_current_time.toString("yyyy-MM-dd");
    QSqlQuery q;
    if (!q.prepare("SELECT current_energy, weekly_energy, total_energy, tasks_added, tasks_completed FROM sys_data WHERE date_str = ?")) return;
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
    emit historicalEnergyChanged();
}

void TaskManager::save_sys_data() {
    QString today = m_current_time.toString("yyyy-MM-dd");
    QSqlQuery q;
    if (!q.prepare("REPLACE INTO sys_data (date_str, current_energy, weekly_energy, total_energy, tasks_added, tasks_completed) VALUES (?, ?, ?, ?, ?, ?)")) return;
    q.addBindValue(today);
    q.addBindValue(m_current_energy);
    q.addBindValue(m_weekly_energy);
    q.addBindValue(m_total_energy);
    q.addBindValue(m_tasks_added);
    q.addBindValue(m_tasks_completed);
    if (q.exec()) {
        emit historicalEnergyChanged();
    }
}

void TaskManager::addTask(const QString &name, int priority, int durationHours, int reviewType, int reviewInt, int reward, int isRec) {
    if (name.isEmpty()) return;
    QDateTime deadline = m_current_time.addSecs(durationHours * 3600);
    QSqlQuery q;
    if (!q.prepare("INSERT INTO user_tasks (name, priority, deadline, review_type, review_interval, energy_reward, is_rec, status) VALUES (?, ?, ?, ?, ?, ?, ?, 0)")) return;
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
    if (!q.prepare("INSERT INTO sys_recs (name) VALUES (?)")) return;
    q.addBindValue(name);
    if (q.exec()) load_sys_recs();
}

void TaskManager::addStoreItem(const QString &name, int price) {
    if (name.isEmpty()) return;
    QSqlQuery q;
    if (!q.prepare("INSERT INTO store_items (name, price) VALUES (?, ?)")) return;
    q.addBindValue(name);
    q.addBindValue(price);
    if (q.exec()) {
        load_store_items();
    }
}

void TaskManager::removeStoreItem(int id) {
    QSqlQuery q;
    if (!q.prepare("DELETE FROM store_items WHERE id = ?")) return;
    q.addBindValue(id);
    if (q.exec()) {
        load_store_items();
    }
}

void TaskManager::buyItem(int id) {
    QSqlQuery q;
    if (!q.prepare("SELECT price FROM store_items WHERE id = ?")) return;
    q.addBindValue(id);
    if (q.exec() && q.next()) {
        int price = q.value(0).toInt();
        if (m_current_energy >= price) {
            m_current_energy -= price;
            m_weekly_energy = qMax(0, m_weekly_energy - price);
            m_total_energy = qMax(0, m_total_energy - price);
            save_sys_data();
            emit energyChanged();
        }
    }
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
    if (m_timer->interval() == 1000) {
        m_current_time = m_current_time.addSecs(1);
    }
    emit timeChanged();
    int currentHour = m_current_time.time().hour();
    if (currentHour != m_last_hour) {
        if (currentHour == 7) {
            m_current_energy = 100;
        } else {
            m_current_energy = qMax(0, m_current_energy - 10);
        }
        if (currentHour == 0) {
            int settled_energy = m_current_energy;
            if (m_current_energy > 100) {
                settled_energy = m_current_energy * m_current_energy / 100;
            }
            m_weekly_energy += settled_energy;
            m_total_energy += settled_energy;
            m_tasks_added = 0;
            m_tasks_completed = 0;
            load_sys_recs();
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
        if (priority == 5) {
            intervalHours = 1;
        } else if (priority == 4) {
            intervalHours = 3;
        } else if (priority == 3) {
            intervalHours = 6;
        } else if (priority == 2) {
            intervalHours = 12;
        }
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