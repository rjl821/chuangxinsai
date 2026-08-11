# uvm_tb

这是从 `/home/ICer/project/LJD/uvm_tb` 迁入并接到当前 `vector_mac` RTL 的 UVM-lite 验证环境。DUT 源码仍保存在当前工程根目录的 `rtl/`，验证环境通过 `sim/dut_top.f` 引用。

常用命令：

```sh
cd uvm_tb/sim
make elab
make run
make run TESTNAME=dut_smoke_test SEED=123
make run TESTNAME=dut_rw_test
./run_regr.sh
make clean
```

移植或替换建议：

1. 替换或新增设计文件时，更新 `sim/dut_top.f`。
2. 如果 DUT 端口变化，修改 `tb/dut_tb.sv` 和 `agents/generic/generic_if.sv`。
3. 如果 transaction 含义变化，修改 `agents/generic/generic_transaction.sv`、driver、monitor、scoreboard 和 sequence。
4. 如果只改参考模型逻辑，优先修改 `env/dut_reference_model.sv`；如果只改比较逻辑，优先修改 `env/dut_scoreboard.sv`。
