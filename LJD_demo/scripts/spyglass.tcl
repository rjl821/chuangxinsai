# 固定 SpyGlass 流程。顶层和综合 filelist 由 Makefile 传入。
new_project [file join $::env(SPYGLASS_OUT) $::env(TOP).prj] -force
set_option top $::env(TOP)
set_option enableSV yes
set_option language_mode mixed
read_file -type sourcelist $::env(SYN_FILELIST)

current_goal lint/lint_rtl
run_goal
save_project
exit -force
