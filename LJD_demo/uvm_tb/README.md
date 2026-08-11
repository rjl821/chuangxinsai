# uvm_tb

这是从 `example_uvm` 整理出的 UVM-lite 验证模板。设计代码统一放在 `../RTL`，验证环境内不再保存 DUT 源码。

常用命令：

```sh
cd sim
make sim
make verdi
make dve
make lint
make dc
make run TEST_NAME=dut_smoke_test SEED=123
./run_regr.sh
make mergecov
make clean
```

考试快速替换建议：

1. 在 `../RTL` 中替换或新增设计文件，并更新 `sim/dut_top.f`。
2. 如果 DUT 端口变化，修改 `tb/dut_tb.sv` 和 `agents/generic/generic_if.sv`。
3. 如果 transaction 含义变化，修改 `agents/generic/generic_transaction.sv`、driver、monitor、scoreboard 和 sequence。
4. 如果只改参考检查逻辑，优先修改 `env/dut_scoreboard.sv`。
