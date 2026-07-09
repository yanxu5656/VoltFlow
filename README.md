VoltFlow (伏流)
VoltFlow（伏流）是一款融合了游戏化电量注能机制、多维调度周期、自适应临期物理警告以及可拓展物资商店的现代桌面效率管理终端。

工程目录结构
Plaintext
VoltFlow/
├── CMakeLists.txt        # 构建配置文件，集成 Quick、Gui、Qml、Sql 链接模块
├── main.cpp              # 核心入口，注入 QT_QUICK_CONTROLS_STYLE="Basic" 
├── TaskManager.h         # C++ 后台逻辑中枢头文件（元对象属性绑定）
├── TaskManager.cpp       # 全量业务实现（SQLite 事务、跨天结算、随机抽取算法）
├── Main.qml              # 全局 ApplicationWindow 承载窗（物理晃动动画引擎）
├── View_Main.qml         # 主城舱 Dashboard 视图（六边形电池、Canvas趋势图、环绕气泡）
├── View_Task.qml         # 任务流投放舱视图（双轨监监视列表、发布模块、P1-P5规则板）
├── View_Set.qml          # 虚拟调度时间视图（时钟步进、整库重置、暗夜结算明细面板）
└── View_Store.qml        # 物资商店补给视图（购买小铺、商品上架下架管理中枢）
