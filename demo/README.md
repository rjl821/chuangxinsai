# 数字 IC 前端流程 Demo

该工程用参数化有符号向量点积模块演示以下流程：

- VCS：普通 SystemVerilog testbench 和 UVM 1.2 testbench。
- Verdi：读取与 VCS 相同的 filelist，并打开 FSDB 波形。
- DVE：连接 `simv` 的交互式仿真 GUI，以及覆盖率 GUI。
- URG：手动合并多个测试的覆盖率数据库并生成 HTML/text 报告。
- SpyGlass：读取综合 filelist 执行 `lint/lint_rtl`，并可直接打开最近一次 lint 工程和结果。
- Design Compiler：读取综合 filelist，加载 SDC，使用 TSMC28 库综合。

所有工具输出均写入 `build/`。Makefile 不列任何 RTL 或 testbench 源文件名，源码、include 路径和编译顺序只由 filelist 管理。

## 目录结构

```text
demo/
├── Makefile
├── README.md
├── filelist/
│   ├── rtl.f                   # 仅可综合 RTL，供 DC/SpyGlass
│   ├── sv.f                    # RTL + 普通 SV testbench
│   └── uvm.f                   # RTL + UVM 1.2 testbench
├── rtl/
│   ├── vector_mac_params_pkg.sv # 设计参数文件
│   └── vector_mac.sv
├── tb/
│   ├── tb_vector_mac.sv
│   └── uvm/
│       ├── vector_mac_if.sv
│       ├── vector_mac_uvm_pkg.sv
│       └── tb_vector_mac_uvm.sv
├── constraints/
│   └── design.sdc
└── scripts/
    ├── dc.tcl
    └── spyglass.tcl
```

## Filelist 是唯一源码入口

三个 filelist 的职责如下：

| Filelist | 内容 | 使用者 |
| --- | --- | --- |
| `filelist/rtl.f` | 参数 package 和可综合 RTL | DC、SpyGlass |
| `filelist/sv.f` | 参数 package、RTL、普通 SV testbench | VCS、Verdi |
| `filelist/uvm.f` | 参数 package、RTL、interface、UVM package、UVM 顶层 | VCS、Verdi |

添加或删除源码时只修改对应 filelist，例如：

```text
+incdir+${DEMO_ROOT}/rtl
+incdir+${DEMO_ROOT}/rtl/include

${DEMO_ROOT}/rtl/vector_mac_params_pkg.sv
${DEMO_ROOT}/rtl/submodule.sv
${DEMO_ROOT}/rtl/vector_mac.sv
```

package、interface、被例化模块必须写在引用它们的文件之前。`+incdir+...` 只增加 `` `include `` 搜索目录，不会自动编译该目录中的源码。

Makefile 自动导出绝对路径 `DEMO_ROOT`，filelist 中的 `${DEMO_ROOT}` 由 Synopsys 工具展开，因此 SpyGlass 即使切换内部工作目录也能找到源码。工程移动后不需要修改绝对路径。

VCS 使用 `-F /absolute/path/filelist/sv.f`。大写 `-F` 与 `-f` 都表示读取 filelist，`-F` 还允许 filelist 位于其他目录并按 filelist 位置处理相对项；当前源码项经过 `${DEMO_ROOT}` 展开后都是绝对路径。Verdi 使用 `-f /absolute/path/filelist/sv.f`。两条命令都直接读 filelist，Makefile 不展开 RTL 文件。Verdi 从 `build/vcs/<mode>/sim/` 启动，因此 `verdiLog`、`novas.conf` 等运行文件也会留在 `build/`，不会写入 `filelist/`。

## 设计参数文件

默认位宽集中在 `rtl/vector_mac_params_pkg.sv`：

| package 常量 | 默认值 | 作用 |
| --- | ---: | --- |
| `VECTOR_MAC_DATA_W` | 16 | 单个输入操作数的有符号位宽 |
| `VECTOR_MAC_ACC_W` | 40 | 乘加累加器和输出位宽 |
| `VECTOR_MAC_LEN_W` | 8 | 长度计数的基础位宽；端口 `length` 实际为 `[LEN_W:0]` |

`vector_mac` 的 `DATA_W/ACC_W/LEN_W` 默认引用该 package，也仍然允许在实例化时用 `#(...)` 单独覆盖。修改参数 package 后，`rtl.f`、`sv.f` 和 `uvm.f` 都会以同一套默认参数重新编译。

## 快速运行

普通 SystemVerilog：

```bash
make sim TB_MODE=sv TEST_NAME=sv_smoke_test SEED=1
make sim_sv TEST_NAME=sv_random_test SEED=2
make run TB_MODE=sv TEST_NAME=sv_boundary_test SEED=3
```

UVM 1.2：

```bash
make sim TB_MODE=uvm TEST_NAME=vector_mac_smoke_test SEED=1
make sim_uvm TEST_NAME=vector_mac_random_test SEED=2
make run TB_MODE=uvm TEST_NAME=vector_mac_boundary_test SEED=3
```

GUI、覆盖率、静态检查和综合：

```bash
make verdi TB_MODE=sv TEST_NAME=sv_smoke_test SEED=1
make verdi TB_MODE=uvm TEST_NAME=vector_mac_smoke_test SEED=1
make dve TB_MODE=sv TEST_NAME=sv_smoke_test SEED=1
make dve TB_MODE=uvm TEST_NAME=vector_mac_smoke_test SEED=1

make cov_merge TB_MODE=sv
make cov_merge TB_MODE=uvm
make dvecov TB_MODE=sv
make verdicov TB_MODE=uvm

make lint
make lint_gui
make dc
make all
make clean
```

`sim` 每次执行编译、elaboration 和运行；`run` 只复用已存在的同一 `TB_MODE` 的 `simv`，适合用不同 `TEST_NAME/SEED` 连续回归。SV 与 UVM 的编译目录完全隔离。

`make lint` 创建或刷新 `build/spyglass/vector_mac.prj` 并保存 lint 结果。随后执行 `make lint_gui` 会直接打开这个已有工程及其 `lint/lint_rtl` goal，不会重新执行 lint。若工程文件不存在，命令会提示先运行 `make lint`，而不会打开空白 SpyGlass 窗口。

## 可指定的 test_name

普通 SV test 通过 `+TEST_NAME=...` 传入：

| `TEST_NAME` | 内容 |
| --- | --- |
| `sv_smoke_test` | 长度 0、1、8、16 的基本自检 |
| `sv_boundary_test` | 集中检查长度 0、1、最大值 16 |
| `sv_random_test` | 随机执行 20 个长度为 0 到 16 的测试 |

UVM test 通过标准的 `+UVM_TESTNAME=...` 传入：

| `TEST_NAME` | UVM 1.2 class | 内容 |
| --- | --- | --- |
| `vector_mac_smoke_test` | `uvm_test` 派生类 | 长度 0、1、8、16 的基本自检 |
| `vector_mac_boundary_test` | `uvm_test` 派生类 | 边界长度检查 |
| `vector_mac_random_test` | `uvm_test` 派生类 | 20 个随机长度测试 |

两套 testbench 都会随机插入输入空拍和输出 back-pressure，并比较有符号点积结果。未知测试名会直接报错，不会静默运行默认测试。

## 工具环境

Makefile 不设置 `VERDI_HOME`，也不包含 Verdi 安装目录。运行前只需在 shell 环境中配置好 Verdi，使下面的命令能返回当前版本的可执行文件：

```bash
command -v verdi
```

`make verdi` 和 `make verdicov` 直接通过 `PATH` 调用 `verdi`。VCS elaboration 所需的 `novas.tab` 和 `pli.a` 也会根据 `command -v verdi` 的结果自动定位到同一套 Verdi 安装下的 `share/PLI/VCS/linux64/`，因此切换 Verdi 版本后无需修改 Makefile。外部环境即使设置了 `VERDI_HOME` 也不会被 Makefile 覆盖。

## Makefile 全部可配置参数

下面列出用户可能从 Makefile 或命令行覆盖的全部参数。

### 设计、仿真与工具参数

| Make 变量 | 默认值 | 作用 |
| --- | --- | --- |
| `DUT_TOP` | `vector_mac` | 可综合设计顶层，供 DC/SpyGlass |
| `TB_MODE` | `sv` | 选择 `sv` 或 `uvm` 流程 |
| `SV_TB_TOP` | `tb_vector_mac` | 普通 SV 仿真顶层 |
| `UVM_TB_TOP` | `tb_vector_mac_uvm` | UVM 仿真顶层 |
| `SYN_FILELIST` | `filelist/rtl.f` | 综合和 lint filelist |
| `SV_SIM_FILELIST` | `filelist/sv.f` | 普通 SV 仿真 filelist |
| `UVM_FILELIST` | `filelist/uvm.f` | UVM 1.2 仿真 filelist |
| `TEST_NAME` | 随 `TB_MODE` 变化 | 本次运行的 SV test 名或 UVM test class 名 |
| `SEED` | `2026` | VCS/UVM 随机种子，也是 VDB/FSDB 名的一部分 |
| `UVM_VERBOSITY` | `UVM_LOW` | UVM 日志等级，如 `UVM_NONE/LOW/MEDIUM/HIGH/FULL/DEBUG` |
| `CLOCK_PERIOD_NS` | `10.0` | 仿真时钟周期，同时传给 SDC，单位 ns |
| `SPYGLASS_GOAL` | `lint/lint_rtl` | `make lint` 执行且 `make lint_gui` 打开的 SpyGlass goal；两者必须保持一致 |
| `BUILD_DIR` | `build` | 全部生成文件根目录 |
| `DEMO_ROOT` | 自动等于工程根目录 | Makefile 导出的内部环境变量，供 filelist 形成绝对源码路径；通常不要手动设置 |

### DC 约束与库参数

| Make 变量 | 默认值 | 作用 |
| --- | ---: | --- |
| `CLOCK_NAME` | `core_clk` | SDC 中创建的时钟名称 |
| `CLOCK_PORT` | `clk` | 主时钟输入端口 |
| `ASYNC_RESET_PORT` | `rst_n` | 异步复位端口，用于设置 false path |
| `NO_INPUT_DELAY_PORTS` | `clk rst_n` | 不施加普通 input delay/驱动单元的输入端口 |
| `INPUT_DELAY_RATIO` | 0.20 | input delay 占时钟周期的比例 |
| `OUTPUT_DELAY_RATIO` | 0.20 | output delay 占时钟周期的比例 |
| `SETUP_UNCERTAINTY_RATIO` | 0.05 | setup uncertainty 占时钟周期的比例 |
| `HOLD_UNCERTAINTY_NS` | 0.0 | hold uncertainty，单位 ns |
| `OUTPUT_LOAD_PF` | 0.02 | 所有输出端口的负载，库时间单位下通常解释为 pF，必须核对 `.db` 单位 |
| `MAX_TRANSITION_RATIO` | 0.10 | 最大转换时间占周期的比例 |
| `TECH_LIB` | TSMC28 TT `.db` | DC target library |
| `INPUT_DRIVE_CELL` | `INVD1BWP12T40P140` | 模拟上游输入驱动能力的库单元 |
| `EXTRA_LINK_LIBS` | 空 | SRAM、乘法器、IO 等额外 `.db`，空格分隔 |

### 覆盖率合并参数

| Make 变量 | 默认值 | 作用 |
| --- | --- | --- |
| `COV_INPUTS` | 当前模式 `cov/*.vdb` | URG 要合并的运行 VDB 列表；自动排除 `merged.vdb` |
| `MERGED_CM_DIR` | `cov/merged.vdb` | 合并后的覆盖率库路径，也是 GUI 默认打开路径 |
| `COV_REPORT` | `coverage_report` | URG HTML/text 报告目录 |

指定部分数据库手动合并。只列 test VDB 即可，Makefile 会自动先加入 elaboration 生成的 `obj/compile.vdb` 作为完整 design coverage model：

```bash
make cov_merge TB_MODE=sv \
  COV_INPUTS="build/vcs/sv/cov/sv_smoke_test_1.vdb build/vcs/sv/cov/sv_random_test_2.vdb"
```

## 覆盖率配置

`CM_TYPES` 固定为：

```text
line+cond+fsm+tgl+branch+assert
```

| 覆盖率类型 | 含义 |
| --- | --- |
| `line` | 可执行语句/行是否执行 |
| `cond` | 布尔子条件的 0/1 组合是否出现 |
| `fsm` | 状态和状态转换是否覆盖 |
| `tgl` | bit 是否发生 0->1 和 1->0 翻转 |
| `branch` | `if/case` 等控制分支是否执行 |
| `assert` | SVA property/assert 的成功、失败和尝试情况 |

SV 和 UVM testbench 还定义了长度 covergroup。covergroup 是 SystemVerilog 功能覆盖，不需要加入 `-cm` 类型字符串；VCS 编译 covergroup 后会将其写入同一 VDB。

覆盖率必须在 elaboration 时插桩，因此 `-cm` 位于 `vcs` 命令，而不是本机不接受该选项的 `vlogan` 命令。运行时再次给 `simv -cm ...`，并用 `-cm_dir/-cm_name` 将每个 test/seed 写入独立数据库。

单次运行结果示例：

```text
build/vcs/sv/cov/sv_smoke_test_1.vdb
build/vcs/sv/sim/sv_smoke_test_1.fsdb
build/vcs/sv/sim/sv_smoke_test_1.log
```

合并结果：

```text
build/vcs/sv/cov/merged.vdb
build/vcs/sv/coverage_report/dashboard.html
```

## VCS 参数逐项说明

本节完整列出本工程命令行实际使用的所有 VCS/vlogan/simv 参数。它不是 VCS 产品全部选项的复制；全部产品选项应以安装版本的 `vcs -help` 和 Synopsys 文档为准。

### vlogan 编译参数

| 参数 | 作用 |
| --- | --- |
| `-full64` | 使用 64-bit 编译流程 |
| `-sverilog` | 按 SystemVerilog 解析源文件 |
| `-timescale=1ns/1ps` | 为未自行声明 `` `timescale `` 的源文件指定时间单位/精度 |
| `-kdb` | 生成 Verdi KDB 调试数据库所需信息 |
| `-debug_access+all` | 保留全部调试访问能力，包括信号读取、force、deposit 等；会增加编译时间和数据库体积 |
| `-nc` | suppress copyright banner，减少日志头部输出 |
| `-ntb_opts uvm-1.2` | 仅 UVM 模式使用；选择 VCS 自带 UVM 1.2 库、宏和 DPI 支持 |
| `-F <filelist>` | 直接读取 filelist，并相对 filelist 目录解释其中的相对路径 |
| `-l <compile.log>` | 将编译消息同时写入指定日志 |

UVM 模式先执行一次不带用户 filelist 的 `vlogan -ntb_opts uvm-1.2`，建立本机 VCS T-2022.06 的 `uvm_pkg`；第二次 `vlogan` 才通过 `-F uvm.f` 编译用户设计和 testbench。

### vcs elaboration 参数

| 参数 | 作用 |
| --- | --- |
| `-full64` | 生成 64-bit `simv` |
| `-ntb_opts uvm-1.2` | UVM 模式下用 UVM 1.2 完成 elaboration/link |
| `-kdb` | 生成/连接 Verdi KDB 数据 |
| `-debug_access+all` | 在 elaborated design 中保留完整调试能力 |
| `-sim_res=1ps` | 设置仿真全局最小时间分辨率为 1 ps |
| `-Mdir=<dir>` | 指定增量编译和 C/C++ 生成目录 `csrc` |
| `-P <novas.tab> <pli.a>` | 注册并链接 Verdi FSDB PLI，使 `$fsdbDumpfile/$fsdbDumpvars` 可用 |
| `-cm line+cond+fsm+tgl+branch+assert` | 对六类代码/断言覆盖率插桩 |
| `-cm_dir <compile.vdb>` | 指定 elaboration 阶段的覆盖率数据库位置；运行时会改写到 test 专属 VDB |
| `-top <TB_TOP>` | 显式指定仿真顶层，避免误选其他未例化 module |
| `-o <SIMV>` | 指定生成的仿真可执行文件路径 |
| `-l <elab.log>` | 保存 elaboration/link 日志 |

### simv 运行参数和 plusarg

以 `-` 开头的是 `simv` 选项，以 `+` 开头的是 testbench/UVM plusarg：

| 参数 | 作用 |
| --- | --- |
| `+ntb_random_seed=<SEED>` | 设置 VCS constrained-random/UVM 随机种子 |
| `+TEST_NAME=<name>` | 普通 SV testbench 读取的 test 名 |
| `+UVM_TESTNAME=<class>` | UVM factory 创建并运行的 `uvm_test` class 名 |
| `+UVM_VERBOSITY=<level>` | UVM report verbosity |
| `+CLOCK_PERIOD_NS=<ns>` | 两套 testbench 读取的仿真时钟周期 |
| `+FSDB=<path>` | 两套 testbench 读取的 FSDB 输出路径 |
| `-cm <types>` | 启用 elaboration 时已经插入的覆盖率监测类型 |
| `-cm_dir <test.vdb>` | 指定本次运行 VDB 目录 |
| `-cm_name <test_seed>` | 设置数据库中的测试名称，便于 URG 区分运行 |
| `-covg_cont_on_error` | covergroup 采样错误时继续仿真并记录错误，避免第一个覆盖率错误终止整个回归 |
| `-l <sim.log>` | 保存本次运行日志 |
| `-gui=dve` | 仅 `make dve` 使用；连接 `simv` 并启动 DVE 交互 GUI |

## URG 覆盖率合并参数

`make cov_merge` 使用的全部参数如下：

| 参数 | 作用 |
| --- | --- |
| `VCS_USE_MALLOC=1` | 使用 VCS 建议的内存分配路径，提升大 VDB 合并时的兼容性 |
| `urg -full64` | 启动 64-bit URG |
| `-dir <compile.vdb> <test.vdb...>` | 先输入包含完整 design model 的编译 VDB，再输入一个或多个运行 VDB |
| `-dbname <name>` | 设置合并数据库名称/输出位置 |
| `-report <dir>` | 指定覆盖率报告目录 |
| `-format both` | 同时生成 HTML 和 text 报告 |
| `-show ratios` | 报告中显示 covered/total 比例 |
| `-show tests` | 报告中显示每个测试对覆盖率的贡献 |

## Verdi 参数逐项说明

本节完整列出 Makefile 实际传给 Verdi 的参数。

### 源码与波形模式

| 参数 | 作用 |
| --- | --- |
| `-sv` | 启用 SystemVerilog 语法解析 |
| `-ntb_opts uvm-1.2` | 仅 UVM 模式使用，使 Verdi 正确解析 VCS UVM 1.2 环境 |
| `-f <sv.f|uvm.f>` | 直接读取与 VCS 对应的完整仿真 filelist |
| `-top <TB_TOP>` | 指定 Verdi 设计顶层 |
| `-ssf <FSDB>` | 加载本次 test/seed 生成的 FSDB 波形文件 |
| `-nologo` | 不显示启动 logo/splash |

`make verdi` 依赖 `sim`，所以会先生成对应 FSDB。命令末尾的 shell `&` 只是让 GUI 在后台运行，不是 Verdi 参数。

### 覆盖率模式

| 参数 | 作用 |
| --- | --- |
| `-cov` | 以覆盖率分析模式启动 Verdi |
| `-covdir <merged.vdb>` | 打开 URG 合并后的覆盖率数据库 |

`make verdicov` 只打开 `make cov_merge` 产生的完整 merged VDB，不应直接把单个 test VDB 作为 `MERGED_CM_DIR`。单个运行 VDB 可能只包含 test data，没有完整 design coverage model。

Verdi coverage 从独立目录 `build/vcs/<mode>/cov_gui/` 启动，并额外使用：

| 参数或环境变量 | 作用 |
| --- | --- |
| `VCS_USE_MALLOC=1` | 让 vdCov 使用系统兼容的内存分配路径。Verdi T-2022.06 使用默认 `libsnpsmalloc.so` 枚举 merged VDB 中的 test 时可能发生非法释放并触发段错误；该变量同时也是本工程运行 URG 时采用的兼容设置 |
| `-guiConf <cov_gui/verdi_cov.conf>` | 单独保存覆盖率 GUI 配置，避免读取工程根目录或普通波形 Verdi 留下的 `novas.conf` |
| `-logdir <cov_gui/vdCovLog>` | 将 vdCov 日志、崩溃诊断和运行记录固定写入当前仿真模式的构建目录 |

`VCS_USE_MALLOC=1` 写在 `verdi` 命令前，只对本次 coverage GUI 进程生效，不会修改用户 shell 的全局环境。此次段错误的堆栈位于 `libsnpsmalloc.so` 和 `libucapi.so`，数据库日志同时明确显示 design 已加载成功；因此根因是 T-2022.06 默认内存分配器的兼容性问题，不是 `-covdir` 语法错误，也不是 merged VDB 缺少 design model。

`verdicov` 会先检查 `MERGED_CM_DIR` 是否存在，不存在时提示执行对应 `TB_MODE` 的 `make cov_merge`。SV 和 UVM 使用各自独立的 `cov_gui/`，不会互相复用 GUI 状态。独立 `-guiConf` 与工作目录用于隔离 GUI 状态和日志，但真正避免本次 `libsnpsmalloc.so` 崩溃的是 `VCS_USE_MALLOC=1`。

## DVE 参数逐项说明

`make dve` 不是离线打开 FSDB，而是用 `simv -gui=dve` 启动可控制仿真运行的 GUI，因此它同时接收上文列出的所有 simv plusarg 和覆盖率参数。DVE 专用参数只有：

| 参数 | 作用 |
| --- | --- |
| `-gui=dve` | 从 `simv` 启动 DVE，支持断点、单步、run/stop、force 和波形观察 |

合并覆盖率 GUI 使用；DVE 也从同一个独立 `cov_gui/` 工作目录启动：

| 参数 | 作用 |
| --- | --- |
| `dve -full64` | 启动 64-bit DVE |
| `-cov` | 进入覆盖率模式 |
| `-covdir <merged.vdb>` | 打开合并覆盖率库 |

## SpyGlass lint 与 GUI 参数

`make lint` 通过 `scripts/spyglass.tcl` 创建工程、读取 `SYN_FILELIST`、执行 `SPYGLASS_GOAL` 并保存工程。默认工程路径由 `BUILD_DIR` 和 `DUT_TOP` 组合而成：

```text
build/spyglass/vector_mac.prj
```

批处理 lint 使用的配置如下：

| 参数或 Tcl 命令 | 作用 |
| --- | --- |
| `spyglass -shell -tcl scripts/spyglass.tcl` | 以 shell/Tcl 模式执行 lint 脚本，不启动 GUI |
| `new_project <DUT_TOP>.prj -force` | 创建工程；同名工程存在时刷新工程配置 |
| `set_option top <DUT_TOP>` | 指定可综合设计顶层 |
| `set_option enableSV yes` | 启用 SystemVerilog 解析 |
| `set_option language_mode mixed` | 允许工程按混合 Verilog/SystemVerilog 语言模式解析 |
| `set_option define SYNTHESIS` | lint 解析时定义 `SYNTHESIS` 宏，用于屏蔽仅仿真代码 |
| `read_file -type sourcelist <绝对路径/rtl.f>` | 直接读取 `SYN_FILELIST`；源码名称、include 路径和编译顺序都来自 filelist。绝对路径会保存到 `.prj`，保证 GUI 从 `build/spyglass/` 打开工程时仍能找到 filelist |
| `current_goal <SPYGLASS_GOAL>` | 选择要运行的检查目标，默认 `lint/lint_rtl` |
| `run_goal` | 执行当前 goal |
| `save_project` | 将工程配置与本次运行信息保存到 `.prj` |
| `exit -force` | 批处理完成后退出 SpyGlass shell |

`make lint_gui` 使用的 GUI 命令行参数如下：

| 参数 | 作用 |
| --- | --- |
| `spyglass` | 不带 `-batch` 或 `-shell`，因此启动 SpyGlass Console GUI |
| `-project <build/spyglass/vector_mac.prj>` | 加载最近一次 `make lint` 保存的工程，而不是新建空工程 |
| `-goals "lint/lint_rtl"` | 在 GUI 中载入指定 goal；GUI 模式只加载列表中的第一个 goal，本工程默认与批处理运行的 goal 相同 |

GUI 的标准输出和错误输出写入 `build/spyglass/lint_gui.log`。`lint_gui` 不依赖 `lint`，这是为了保留并快速查看刚刚跑完的结果；需要更新分析结果时先重新执行 `make lint`。

## 当前 DC 约束如何计算

`constraints/design.sdc` 使用 Makefile 传入的值：

```tcl
create_clock -name $CLOCK_NAME -period $CLOCK_PERIOD_NS [get_ports $CLOCK_PORT]

set_clock_uncertainty -setup \
  [expr {$CLOCK_PERIOD_NS * $SETUP_UNCERTAINTY_RATIO}] \
  [get_clocks $CLOCK_NAME]
set_clock_uncertainty -hold $HOLD_UNCERTAINTY_NS [get_clocks $CLOCK_NAME]

set_input_delay  [expr {$CLOCK_PERIOD_NS * $INPUT_DELAY_RATIO}] ...
set_output_delay [expr {$CLOCK_PERIOD_NS * $OUTPUT_DELAY_RATIO}] ...
set_false_path -from [get_ports $ASYNC_RESET_PORT]
set_driving_cell -lib_cell $INPUT_DRIVE_CELL ...
set_load $OUTPUT_LOAD_PF [all_outputs]
set_max_transition [expr {$CLOCK_PERIOD_NS * $MAX_TRANSITION_RATIO}] [current_design]
```

默认周期 10 ns 时，input delay 为 2 ns、output delay 为 2 ns、setup uncertainty 为 0.5 ns、max transition 为 1 ns。这些只是教学预算，不是可直接用于流片的 sign-off 约束。

## DC 常用约束命令速查

### 对象查询与集合

| 命令 | 作用与示例 |
| --- | --- |
| `get_ports pattern` | 获取顶层端口，如 `[get_ports clk]`、`[get_ports data_*]` |
| `get_pins pattern` | 获取层次化实例 pin，如 `[get_pins u_core/reg_q*/D]` |
| `get_cells pattern` | 获取实例/单元，如 `[get_cells -hier *fifo*]` |
| `get_nets pattern` | 获取网络 |
| `get_clocks pattern` | 获取已创建的时钟对象 |
| `all_inputs` / `all_outputs` | 获取所有顶层输入/输出端口 |
| `all_registers` | 获取寄存器；可用 `-clock_pins/-data_pins/-output_pins` 选 pin |
| `get_object_name collection` | 将 DC collection 转成可打印名称 |
| `remove_from_collection A B` | 从集合 A 排除 B；本工程用它排除时钟/复位输入 |
| `filter_collection C expr` | 按属性过滤集合，如只保留 sequential cell |

DC 命令操作的是 collection，不应把多个对象随意拼成普通 Tcl 字符串。先保存 collection 再传给 `-from/-to`，能减少空集合和单词拆分问题。

### 时钟约束

| 命令 | 作用与关键点 |
| --- | --- |
| `create_clock -name CLK -period 10 [get_ports clk]` | 创建主时钟；默认波形是 `{0 5}` |
| `create_clock -waveform {0 4} ...` | 定义非 50% duty cycle 时钟 |
| `create_clock -name VCLK -period 10` | 不绑定端口时创建 virtual clock，常用于 IO delay 参考 |
| `create_generated_clock -source ... -divide_by 2 ...` | 描述分频、倍频、门控或相移生成时钟；不要用第二个无关 `create_clock` 代替有关联的 generated clock |
| `set_clock_uncertainty -setup/-hold value clocks` | 预留 jitter、skew 和建模裕量；setup/hold 通常分别设置 |
| `set_clock_latency -source/-late/-early value clocks` | 描述 source/network latency；综合阶段常为估计值，CTS 后由 propagated clock 替代 |
| `set_clock_transition value clocks` | 描述理想时钟源的边沿转换时间 |
| `set_propagated_clock clocks` | 使用时钟网络实际延迟；通常用于 CTS/布局布线后，不用于早期理想时钟综合 |
| `set_clock_groups -asynchronous -group A -group B` | 切断异步时钟域之间的时序分析；CDC 正确性仍需 CDC 工具检查 |
| `set_clock_groups -logically_exclusive ...` | 声明逻辑上不会同时到达的时钟，如 mux 模式 |
| `set_clock_groups -physically_exclusive ...` | 声明物理上不会同时存在的时钟，如不同测试/功能源 |

### 输入输出接口约束

| 命令 | 作用与关键点 |
| --- | --- |
| `set_input_delay -max/-min value -clock CLK ports` | 描述输入数据相对参考时钟到达芯片边界的最晚/最早时间；严谨项目应分别给 max 和 min |
| `set_output_delay -max/-min value -clock CLK ports` | 描述外部接收端 setup/hold 与板级延迟占用的输出预算 |
| `-clock_fall` | IO 数据相对下降沿采样时使用 |
| `-add_delay` | 同一端口叠加第二个边沿或第二个时钟约束时保留已有 delay |
| `set_driving_cell -lib_cell CELL ports` | 用真实库单元的非线性驱动模型描述输入 slew |
| `set_input_transition value ports` | 没有合适 driving cell 时直接指定输入 transition；通常不与 `set_driving_cell` 重复使用 |
| `set_load capacitance ports` | 设置输出端口负载电容 |
| `set_fanout_load value ports` | 使用库 fanout load 单位描述输出负载，精度通常低于实际电容 |

### 时序例外

| 命令 | 作用与风险 |
| --- | --- |
| `set_false_path -from/-through/-to ...` | 完全取消匹配路径的 setup/hold 分析；范围过大会掩盖真实违例，必须配合 `report_exceptions` 检查 |
| `set_multicycle_path N -setup ...` | 允许 setup 使用 N 个周期，适合协议明确保证多周期稳定的数据路径 |
| `set_multicycle_path N-1 -hold ...` | 通常与 setup multicycle 配套，把 hold 检查移回正确边沿；不能只写 setup 就结束 |
| `set_max_delay value -from/-to ...` | 对指定路径设置最大延迟，可覆盖默认时钟关系 |
| `set_min_delay value -from/-to ...` | 对指定路径设置最小延迟 |
| `set_disable_timing cell_or_pin` | 禁用某个 timing arc，常用于 mux 环路或特定库弧；需精确限定对象 |
| `set_case_analysis 0/1 ports_or_pins` | 固定模式、test enable、mux select，按指定工作模式消除不可达路径 |

异步复位的 assertion 可以设 false path，但 recovery/removal 不能因此被忽略。实际项目通常还要在 STA 场景中检查复位释放同步器，并用 CDC/RDC 工具检查跨域和复位域。

### 设计规则与优化控制

| 命令 | 作用与关键点 |
| --- | --- |
| `set_max_transition value objects` | 限制最大 slew；DC 会尝试加 buffer 或换大驱动单元 |
| `set_max_capacitance value objects` | 限制网络最大负载电容 |
| `set_max_fanout value objects` | 限制逻辑扇出；物理设计中仍需结合布局优化 |
| `set_dont_touch cells` | 禁止 DC 改动对象；过度使用会显著损害 QoR |
| `set_dont_use lib_cells` | 禁止映射到特定库单元，如不希望使用的低驱动或特殊单元 |
| `set_ideal_network nets_or_pins` | 将网络视为理想网络，适合综合早期的时钟/复位高扇出网；使用范围必须受控 |
| `group_path -name ... -from/-to ...` | 建立路径组并分别优化/报告，如 in2reg、reg2reg、reg2out |
| `set_operating_conditions ...` | 选择库 PVT corner；多 corner 场景通常由 MCMM/不同 scenario 管理 |

### 约束检查和报告

| 命令 | 作用 |
| --- | --- |
| `check_timing` | 查找未约束端点、缺失时钟、无输入延迟等时序建模问题 |
| `report_clock` | 检查时钟周期、波形和属性 |
| `report_timing -delay_type max/min` | 分别报告 setup/hold 路径 |
| `report_constraint -all_violators` | 汇总 max/min delay、transition、capacitance 等违例 |
| `report_exceptions` | 检查 false path、multicycle 等例外覆盖范围 |
| `report_disable_timing` | 检查被禁用的 timing arc |
| `report_case_analysis` | 检查 case analysis 固定值及传播结果 |

约束完成的最低检查标准不是“DC 能跑完”，而是 `check_timing` 没有意外的 unconstrained endpoint，所有 clock domain 关系都有明确含义，时序例外都能解释并审查。

## DC 输出与报告

报告位于 `build/dc/reports/`：

| 报告 | 内容 |
| --- | --- |
| `timing_max.rpt` | 全设计最差 setup 路径 |
| `timing_min.rpt` | 全设计最差 hold 路径 |
| `timing_in2reg.rpt` | 输入到寄存器 setup 路径 |
| `timing_reg2reg.rpt` | 寄存器到寄存器 setup 路径 |
| `timing_reg2out.rpt` | 寄存器到输出 setup 路径 |
| `timing_in2out.rpt` | 输入到输出组合路径 |
| `check_timing.rpt` | 时钟、未约束路径和时序完整性 |
| `constraints.rpt` | delay/transition/capacitance 违例 |
| `qor.rpt` | WNS、TNS、面积、单元数量汇总 |
| `area.rpt` | 层次化面积 |
| `power.rpt` | 未标注真实活动率时的估算功耗，不是 sign-off 功耗 |
| `resources.rpt` | 加法器、乘法器等推断资源 |
| `references.rpt` | 映射后标准单元引用统计 |
| `clocks.rpt` | 时钟定义 |
| `ports.rpt` | 顶层端口属性 |
| `check_design.rpt` | 连接、未驱动对象等设计检查 |

映射结果位于 `build/dc/outputs/`，包括 `${DUT_TOP}.ddc`、mapped Verilog、mapped SDC 和 SDF。

DC Presto 不直接展开 sourcelist 中的环境变量，因此 `dc.tcl` 会读取同一份 `rtl.f`，仅做 Tcl 变量替换并生成 `build/dc/rtl_resolved.f`，随后执行 `analyze -vcs -f rtl_resolved.f`。如果 analyze 失败，脚本会立即终止，避免误用 WORK 中的旧分析结果。

## 工艺库说明

默认使用 TSMC 28 nm HPC+ NLDM 标准单元库，corner 为 TT、0.8 V、25 C：

```text
/home/jjt/TSMC28/logic/tcbn28hpcplusbwp12t40p140_180a/AN61001_20180514/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140tt0p8v25c.db
```

不要把同目录下体积很小的多电压辅助库单独作为 target library。加入 SRAM、PLL、乘法器或其他 hard macro 后，将对应 `.db` 加入 `EXTRA_LINK_LIBS`，同时将仿真模型加入 `sv.f/uvm.f`，可综合模型或 black-box 声明按需要加入 `rtl.f`。

## 常见问题

### VCS 报 `libelf.so.1` 缺失

VCS 启动脚本在进入 `-full64` 流程前仍可能调用 32-bit 前端。如果日志显示 `vcs1: error while loading shared libraries: libelf.so.1`，需要安装与操作系统匹配的 32-bit libelf compatibility package，例如 RHEL/CentOS 系列通常是：

```bash
sudo yum install elfutils-libelf.i686
```

仅存在 `/usr/lib64/libelf.so.1` 不够，因为它是 64-bit 库，不能被 32-bit `vcs1` 加载。不要把 64-bit `.so` 强行软链接成 32-bit 库。

### Verdi 没有波形

先确认对应 `TEST_NAME/SEED/TB_MODE` 的 FSDB 存在，再用完全相同的三个参数执行 `make verdi`。Verdi 的默认 FSDB 路径由这三个值共同决定。

### `make run` 找不到 simv

`run` 只复用已有编译结果。先对同一个 `TB_MODE` 执行 `make elab` 或 `make sim`。SV 和 UVM 使用不同的 `build/vcs/<mode>/obj/simv`。

### 覆盖率合并没有输入

先运行至少一个测试，或者显式传入 `COV_INPUTS`。SV 与 UVM 的 VDB 默认分目录保存，应分别设置 `TB_MODE=sv` 和 `TB_MODE=uvm` 合并。

源码或覆盖率插桩范围变化后，旧 test VDB 与新的 `obj/compile.vdb` 可能出现 design shape mismatch。回归应在同一次 elaboration 后用 `make run` 产生全部 VDB；或者通过 `COV_INPUTS` 只选择与当前 `compile.vdb` 匹配的数据库。
