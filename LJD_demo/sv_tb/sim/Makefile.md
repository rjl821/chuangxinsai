# SV 工具流程说明

换设计时，先修改 `Makefile` 顶部用户配置区，再修改 filelist。Makefile 中不列 RTL 文件名。

## 需要替换的配置

- `DUT_TOP`：可综合 RTL 顶层，供 SpyGlass 和 DC 使用。
- `TB_TOP`：仿真顶层，供 VCS、Verdi 和 DVE 使用。
- `SIM_FILELIST`：完整仿真 filelist；VCS 和 Verdi 都直接读取它。
- `SYN_FILELIST`：只含可综合 RTL 的 filelist；SpyGlass 和 DC 直接读取它。
- `TEST_NAME/SEED/NUM_TRANS/VERBOSE`：test、随机种子和仿真参数。
- `CLOCK_*`、延迟比例、负载：DC 约束参数。
- `TECH_LIB/INPUT_DRIVE_CELL/EXTRA_LINK_LIBS`：TSMC28 库参数。

## 常用命令

```bash
make sim TEST_NAME=tb_smoke_test SEED=1
make run TEST_NAME=tb_directed_test SEED=2
make verdi TEST_NAME=tb_smoke_test SEED=1
make dve TEST_NAME=tb_smoke_test SEED=1
make lint
make dc
make mergecov
make dvecov
make verdicov
make clean
```

`sim` 会编译并运行；`run` 只复用已有 simv，适合回归。每个 test/seed 自动生成独立的 FSDB、日志和 VDB。

## 覆盖率与波形

`vcs` 和 `simv` 始终启用 `line+cond+fsm+tgl+branch+assert`。本机 `vlogan` 不接受 `-cm`，所以覆盖率在 `vcs` elaboration 阶段插桩。`make mergecov` 合并 `out/cov` 下所有单次运行 VDB，输出：

- `out/cov/merged.vdb`
- `out/coverage_report/dashboard.html`

Verdi 使用 `-sv -f files.f -ssf <FSDB> -top tb_top`，源码、include 和编译顺序与 VCS 完全一致。`make dve` 使用同一个 simv 进入 DVE GUI。

## DC 报告

除了全局 `timing_max.rpt` 和 `timing_min.rpt`，还生成 `timing_in2reg.rpt`、`timing_reg2reg.rpt`、`timing_reg2out.rpt` 和 `timing_in2out.rpt`。若设计中不存在某类路径，对应报告会显示没有可报告路径。

其余输出位于 `out/log`、`out/sim`、`out/spyglass`、`out/dc/reports` 和 `out/dc/outputs`。
