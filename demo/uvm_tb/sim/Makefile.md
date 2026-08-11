# UVM Makefile 说明

本文说明同级 `sim/Makefile` 的每个变量、每个 target，以及每个 `-xxx`/`+xxx` 选项。当前 Makefile 保留原始 VCS UVM-lite 执行逻辑：`prepare -> comp -> elab -> run`，其中 `comp` 先预编译 VCS 自带 UVM，再编译 RTL 和 TB。默认从 `uvm_tb/sim` 目录执行。

## User variables

- `export LC_ALL := C`
  固定 Makefile 子进程的 locale 为基础 `C` 环境，减少不同虚拟机缺少 UTF-8 locale 时的工具 warning。它不改变编译、elab、run 的执行路径。

- `export LANG := C`
  同上，固定语言环境。

- `export LANGUAGE :=`
  清空 GNU gettext 的语言优先级变量，避免覆盖 `LANG`。

- `TB = dut_tb`
  指定 testbench 顶层 module 名称。`elab` target 中通过 `-top $(TB)` 使用，`run` 中通过 `$(OUT)/obj/$(TB).simv` 找到仿真程序。

- `SEED = 1`
  默认随机种子。运行时通过 `+ntb_random_seed=$(SEED)` 传给 VCS/UVM。

- `GUI ?= 0`
  GUI 开关。默认 `0` 表示命令行 batch 仿真；`GUI=1` 使用 DVE；`GUI=verdi` 使用 Verdi FSDB 流程。`?=` 表示命令行指定时覆盖默认值。

- `COV ?= 1`
  覆盖率开关。默认打开代码覆盖率；命令行 `make elab COV=0` 或 `make run COV=0` 可关闭追加的代码覆盖率选项。

- `VERB ?= UVM_LOW`
  UVM 打印等级，运行时通过 `+UVM_VERBOSITY=$(VERB)` 传入。

- `OUT ?= out`
  输出根目录。编译日志、elab 日志、仿真日志、simv、覆盖率库都放在这个目录下。

- `TESTNAME ?= dut_smoke_test`
  默认 UVM test class 名称，运行时通过 `+UVM_TESTNAME=$(TESTNAME)` 传给 UVM factory。

- `DFILES += -f ./dut_top.f`
  DUT/RTL filelist。`-f` 表示让 `vlogan` 从 `sim/dut_top.f` 读取源文件列表；当前 `dut_top.f` 使用相对路径引用 `../../rtl/vector_mac_params_pkg.sv` 和 `../../rtl/vector_mac.sv`。

- `VFILES += ...`
  显式列出的验证环境入口文件，包括 `generic_if.sv`、`generic_pkg.sv`、`dut_pkg.sv`、`dut_tb.sv`。package 内部的 class 文件通过 `` `include`` 展开。

- `VCOMP_INC = ...`
  `vlogan` include 搜索路径集合。

- `+incdir+../agents/generic`
  从 `sim` 目录向上一级进入 `agents/generic`，查找 generic agent 内部 include 文件。

- `+incdir+..`、`+incdir+../cfg`、`+incdir+../env`、`+incdir+../tb`、`+incdir+../tests`、`+incdir+../seq_lib`
  从 `sim` 目录向上一级查找验证环境根目录、配置、环境、顶层、test、sequence 文件。

- `+incdir+../../rtl`
  从 `sim` 目录向上两级进入当前工程的 `rtl` 目录，查找 RTL 头文件或被 DUT include 的文件。

## VCOMP

`VCOMP = vlogan ...` 是编译命令模板，`comp` target 会调用两次。

- `vlogan`
  VCS 的 Verilog/SystemVerilog 编译器。

- `-full64`
  使用 64-bit 工具链。

- `-ntb_opts uvm-1.2`
  打开 VCS Native Testbench 支持，并使用 VCS 自带的 UVM 1.2。

- `-sverilog`
  按 SystemVerilog 语法解析源文件。

- `-timescale=1ns/1ps`
  为没有显式 `timescale` 的文件指定默认时间单位 `1ns`、时间精度 `1ps`。

- `-debug_access+class`
  保留 class 级调试访问能力，便于调试 UVM object/component。

- `-debug_region+lib`
  对库区域也保留调试信息，方便 UVM 库相关调试。

- `-nc`
  non-conversational 模式，适合 Makefile 批处理，不进入交互提示。

- `-l $(OUT)/log/vcomp.log`
  将编译日志写入 `out/log/vcomp.log`。

- `$(VCOMP_INC)`
  展开为全部 `+incdir+...` include 搜索路径。

## ELAB

`ELAB = vcs ...` 是 elaboration/link 命令模板。

- `vcs`
  VCS elaboration/link 工具，用于生成可执行仿真程序。

- `-full64`
  使用 64-bit elaboration/link。

- `-ntb_opts uvm-1.2`
  elaboration 阶段继续启用同一套 UVM 版本。

- `-debug_acc+all`
  保留更完整的层次、信号、class 调试访问能力，便于 GUI、波形和调试。

- `-Mdir=$(OUT)/obj/csrc`
  指定 VCS 生成的中间 C/C++ 文件目录，避免污染当前目录。

- `-l $(OUT)/log/elab.log`
  将 elaboration/link 日志写入 `out/log/elab.log`。

- `-sim_res=1ps`
  设置仿真时间分辨率为 `1ps`。

`elab` target 会在 `$(ELAB)` 后追加：

- `-top $(TB)`
  指定仿真顶层，默认 `dut_tb`。

- `-o $(OUT)/obj/$(TB).simv`
  指定生成的仿真可执行文件路径。

## RUN

`RUN = $(OUT)/obj/$(TB).simv ...` 是运行命令模板。

- `$(OUT)/obj/$(TB).simv`
  执行 `elab` 生成的仿真程序。

- `-l $(OUT)/sim/$(CM_NAME).log`
  将仿真日志写入 `out/sim/<test>_<seed>.log`。

- `+ntb_random_seed=$(SEED)`
  设置 VCS/UVM 随机种子。

- `+UVM_TESTNAME=$(TESTNAME)`
  指定要运行的 UVM test class。

- `+UVM_VERBOSITY=$(VERB)`
  指定 UVM 打印等级。

## Coverage variables

- `COV_OPTS = -full64 -dir $(CM_DIR)`
  覆盖率查看/合并工具共用选项。

- `-full64`
  使用 64-bit coverage 工具。

- `-dir $(CM_DIR)`
  指定覆盖率数据库目录。

- `CM_DIR ?= $(OUT)/cov.vdb`
  默认覆盖率数据库目录。

- `CM_NAME ?= $(TESTNAME)_$(SEED)`
  单次仿真的覆盖率 test 名，也用于仿真日志和 FSDB 文件名。

## GUI branches

当 `GUI=1`：

- `RUN += -gui=dve -ucli -do $(SIMRUNFILE)`
  在运行命令后追加 DVE GUI 相关参数。

- `-gui=dve`
  用 DVE GUI 启动仿真。

- `-ucli`
  启用 VCS UCLI 命令接口。

- `-do $(SIMRUNFILE)`
  运行 `dut_sim_run.do` 脚本，用于 GUI 模式下执行 run 或添加波形。

当 `GUI=verdi`：

- `VCOMP += -P ...novas.tab ...pli.a`
  编译阶段链接 Verdi/Novas PLI 表和库。

- `ELAB += -P ...novas.tab ...pli.a`
  elaboration 阶段继续链接同一套 PLI。

- `-P $(VERDI_HOME)/share/PLI/VCS/LINUX64/novas.tab`
  指定 Verdi PLI table。

- `$(VERDI_HOME)/share/PLI/VCS/LINUX64/pli.a`
  指定 Verdi PLI 静态库。

- `RUN += -ucli -do $(VERDIRUNFILE)`
  运行时通过自动生成的 UCLI 脚本打开 FSDB dump。

- `RUN_DEPS = $(VERDIRUNFILE)`
  `make run GUI=verdi` 前先生成 Verdi UCLI 脚本。

- `RUN_POST = verdi -ssf $(OUT)/sim/$(CM_NAME).fsdb -nologo &`
  仿真结束后用 Verdi 打开生成的 FSDB。

- `-ssf`
  指定要打开的 FSDB 波形文件。

- `-nologo`
  启动 Verdi 时不打印 logo。

## Coverage branch

当 `COV=1`：

- `ELAB += -cm line+cond+fsm+tgl+branch -cm_dir $(CM_DIR) -cm_hier dut_cov_hier.config`
  elaboration 阶段打开代码覆盖率并指定覆盖率层次配置。

- `RUN += -cm line+cond+fsm+tgl+branch -covg_cont_on_error -cm_dir $(CM_DIR) -cm_name $(CM_NAME)`
  run 阶段采集代码覆盖率，并给本次仿真命名。

- `-cm line+cond+fsm+tgl+branch`
  打开 line 行覆盖率、cond 条件覆盖率、fsm 状态机覆盖率、tgl toggle 覆盖率、branch 分支覆盖率。

- `-cm_dir $(CM_DIR)`
  指定覆盖率数据库目录。

- `-cm_hier dut_cov_hier.config`
  指定覆盖率层次配置文件。

- `-covg_cont_on_error`
  covergroup 相关错误出现时尽量继续仿真，避免单个覆盖率问题直接中断。

- `-cm_name $(CM_NAME)`
  指定当前 run 的覆盖率 test 名。

## Targets

- `prepare`
  创建 `$(OUT)/work`、`$(OUT)/log`、`$(OUT)/sim`、`$(OUT)/obj`。

- `$(VERDIRUNFILE): prepare FORCE`
  生成 `out/obj/verdi_run.do`。脚本内容包含 `$fsdbDumpfile`、`$fsdbDumpvars` 和 `run`，用于 Verdi FSDB dump。

- `FORCE:`
  空 target，用于强制每次重新生成 `$(VERDIRUNFILE)`。

- `comp: prepare`
  先执行 `prepare`，再执行两条编译命令。

- 第一条 `$(VCOMP)`
  不带用户源码，作用是让当前 VCS 环境先处理 `-ntb_opts uvm-1.2` 对应的 UVM package。

- 第二条 `$(VCOMP) $(DFILES) $(VFILES)`
  编译 `dut_top.f` 中的 RTL 和 `VFILES` 中列出的 UVM TB 入口文件。

- `elab: comp`
  先完成编译，再执行 `$(ELAB) -top $(TB) -o $(OUT)/obj/$(TB).simv` 生成仿真程序。

- `run: $(RUN_DEPS)`
  执行 `$(RUN)`。当 `GUI=verdi` 时，先生成 `$(VERDIRUNFILE)`，仿真后执行 `$(RUN_POST)`。

- `mergecov`
  执行 `urg -format both $(COV_OPTS) -show ratios`，合并/生成覆盖率报告。

- `-format both`
  URG 同时生成文本和 HTML 格式报告。

- `-show ratios`
  在报告中显示覆盖率比例。

- `dvecov`
  执行 `dve $(COV_OPTS)`，用 DVE 打开覆盖率数据库。

- `verdicov`
  执行 `verdi -cov -covdir $(CM_DIR)`，用 Verdi coverage 模式打开覆盖率数据库。

- `-cov`
  启动 Verdi 覆盖率模式。

- `-covdir $(CM_DIR)`
  指定 Verdi 要打开的覆盖率数据库目录。

- `htmlcov`
  执行 `firefox urgReport/dashboard.html`，打开 URG 生成的 HTML 首页。

- `clean`
  删除 `out`、`AN.DB`、`DVEfiles`、`csrc`、`*.simv`、`*.vdb`、`*.log*`、`*.vpd`、`*.fsdb`、`urgReport`、`verdiLog` 等 VCS/Verdi/DVE 生成物，不删除源码和 Makefile。
