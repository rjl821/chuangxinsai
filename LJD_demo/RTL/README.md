# RTL

这里统一放设计代码。

当前示例：

- `dut_dummy.sv`：UVM 模板使用的示例 DUT，功能是 32-bit registered pass-through。
- `sv_dut_dummy.sv`：SV 模板使用的示例 DUT，功能是 valid/ready 加法器。
- `rtl.f`：RTL 编译 filelist，当前供需要统一 RTL filelist 的场景复用。

比赛时如果题目要求你实现新设计，优先替换或新增这里的 RTL 文件，然后更新 `rtl.f`。
