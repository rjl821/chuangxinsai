# sv_tb

Simple class-based SystemVerilog verification template.

## Commands

```sh
cd sim
make sim
make verdi
make dve
make lint
make dc
make run TEST_NAME=tb_directed_test
make run NUM_TRANS=200 SEED=123
make run VERBOSE=1
./run_regr.sh
make mergecov
make clean
```

## Fast Adaptation

For most small exam problems, edit only these files:

1. `../RTL/sv_dut_dummy.sv`
   Replace the example DUT logic with your design.

2. `tb/tb_transaction.sv`
   Update transaction fields if needed and update `calc_expected()`.

3. `tb/dut_if.sv` and `tb/tb_top.sv`
   Edit only when DUT ports or protocol change.

The current example verifies a valid/ready DUT that returns `a + b`.

## Structure

```text
../RTL/          shared design files
tb/              interface, transaction, generator, driver, monitor, scoreboard, env, tests, top
sim/Makefile     VCS、Verdi、SpyGlass、DC 统一入口
sim/Makefile.md  Makefile option notes
sim/files.f      compile filelist
sim/rtl.f        synthesis/lint filelist
sim/run_regr.sh  small regression wrapper
```
