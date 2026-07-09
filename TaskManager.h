#ifndef TASKMANAGER_H
#define TASKMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>
#include <QTimer>

class TaskManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList userTasks READ userTasks NOTIFY userTasksChanged)
    Q_PROPERTY(QVariantList sysRecs READ sysRecs NOTIFY sysRecsChanged)
    Q_PROPERTY(QVariantList storeItems READ storeItems NOTIFY storeItemsChanged)
    Q_PROPERTY(int currentEnergy READ currentEnergy NOTIFY energyChanged)
    Q_PROPERTY(bool isSuperCharged READ isSuperCharged NOTIFY energyChanged)
    Q_PROPERTY(int weeklyEnergy READ weeklyEnergy NOTIFY energyChanged)
    Q_PROPERTY(int totalEnergy READ totalEnergy NOTIFY energyChanged)
    Q_PROPERTY(int tasksAddedToday READ tasksAddedToday NOTIFY statsChanged)
    Q_PROPERTY(int taskCompletionRate READ taskCompletionRate NOTIFY statsChanged)
    Q_PROPERTY(QDateTime currentTime READ currentTime NOTIFY timeChanged)
    Q_PROPERTY(QVariantList historicalEnergy READ historicalEnergy NOTIFY historicalEnergyChanged)

public:
    explicit TaskManager(QObject *parent = nullptr);
    QVariantList userTasks() const { return m_user_tasks; }
    QVariantList sysRecs() const { return m_sys_recs; }
    QVariantList storeItems() const { return m_store_items; }
    int currentEnergy() const { return m_current_energy; }
    bool isSuperCharged() const { return m_current_energy > 100; }
    int weeklyEnergy() const { return m_weekly_energy; }
    int totalEnergy() const { return m_total_energy; }
    int tasksAddedToday() const { return m_tasks_added; }
    int taskCompletionRate() const {
        if (m_tasks_added == 0) return 0;
        return (m_tasks_completed * 100) / m_tasks_added;
    }
    QDateTime currentTime() const { return m_current_time; }
    QVariantList historicalEnergy() const;

    Q_INVOKABLE void addTask(const QString &name, int priority, int durationHours, int reviewType, int reviewInt, int reward, int isRec);
    Q_INVOKABLE void completeTask(int id);
    Q_INVOKABLE void removeTask(int id, bool isPool = false);
    Q_INVOKABLE void addRecPool(const QString &name);
    Q_INVOKABLE void addDemoTime(int hours);
    Q_INVOKABLE void clearDatabase();
    Q_INVOKABLE void activateRecommendation(const QString &name);
    Q_INVOKABLE void addStoreItem(const QString &name, int price);
    Q_INVOKABLE void removeStoreItem(int id);
    Q_INVOKABLE void buyItem(int id);

signals:
    void userTasksChanged();
    void sysRecsChanged();
    void storeItemsChanged();
    void energyChanged();
    void statsChanged();
    void timeChanged();
    void historicalEnergyChanged();
    void triggerShake(const QString &msg, bool isReview);

private slots:
    void onTick();

private:
    void init_db();
    void load_tasks();
    void load_sys_recs();
    void load_store_items();
    void load_sys_data();
    void save_sys_data();
    void check_reminders();

    QVariantList m_user_tasks;
    QVariantList m_sys_recs;
    QVariantList m_store_items;
    int m_current_energy = 100;
    int m_weekly_energy = 0;
    int m_total_energy = 0;
    int m_tasks_added = 0;
    int m_tasks_completed = 0;
    QDateTime m_current_time;
    QTimer *m_timer;
    int m_last_hour;
    QHash<int, QDateTime> m_last_reminded;
};

#endif