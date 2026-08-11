# UVM 工具流程说明

本目录固定使用 Synopsys UVM 1.2。换设计时，先修改 `Makefile` 顶部用户配置区，再修改 filelist；Makefile 中不列 RTL 文件名。

## 需要替换的配置

- `DUT_TOP`：可综合 RTL 顶层，供 SpyGlass 和 DC 使用。
- `TB_TOP`：UVM 仿真顶层，供 VCS、Verdi 和 DVE 使用。
- `SIM_FILELIST`：完整 UVM 仿真 filelist；VCS 和 Verdi 都直接读取它。
- `SYN_FILELIST`：只含可综合 RTL 的 filelist；SpyGlass 和 DC 直接读取它。
- `TEST_NAME/SEED/VERB`：UVM test、随机种子和 verbosity。
- `CLOCK_*`、延迟比例、负载：DC 约束参数。
- `TECH_LIB/INPUT_DRIVE_CELL/EXTRA_LINK_LIBS`：TSMC28 库参数。

## 常用命令

```bash
make sim TEST_NAME=dut_smoke_test SEED=1
make run TEST_NAME=dut_smoke_test SEED=2
make verdi TEST_NAME=dut_smoke_test SEED=1
make dve TEST_NAME=dut_smoke_test SEED=1
make lint
make dc
make mergecov
make dvecov
make verdicov
make clean
```

`sim` 会编译并运行；`run` 只复用已有 simv，适合回归。当前 VCS 要先建立 UVM 1.2 的 `uvm_pkg`，因此 `comp` 中有两条 `vlogan`，第二条才读取用户 filelist。

## 覆盖率与波形

`vcs` 和 `simv` 始终启用 `line+cond+fsm+tgl+branch+assert`，并保留 UVM covergroup。`dut_cov_hier.config` 排除 UVM 库本身的代码覆盖率，对 DUT 完整采集 line/cond/fsm/tgl/branch；该文件格式不支持注释，所以说明集中写在这里。每个 test/seed 自动生成独立 FSDB、日志和 VDB。`make mergecov` 输出：

- `out/cov/merged.vdb`
- `out/coverage_report/dashboard.html`

Verdi 使用 `-sv -ntb_opts uvm-1.2 -f dut_top.f -ssf <FSDB> -top dut_tb`，直接读取与 VCS 相同的源码列表。`make dve` 使用同一个 UVM 1.2 simv 进入 DVE GUI。

## DC 报告

除了全局 `timing_max.rpt` 和 `timing_min.rpt`，还生成 `timing_in2reg.rpt`、`timing_reg2reg.rpt`、`timing_reg2out.rpt` 和 `timing_in2out.rpt`。若设计中不存在某类路径，对应报告会显示没有可报告路径。

其余输出位于 `out/log`、`out/sim`、`out/spyglass`、`out/dc/reports` 和 `out/dc/outputs`。
