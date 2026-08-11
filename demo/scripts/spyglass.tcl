# 固定的 SpyGlass lint 流程。顶层与综合 filelist 从 Makefile 传入。
new_project [file join $::env(SPYGLASS_OUT) $::env(TOP).prj] -force
set_option top $::env(TOP)
set_option enableSV yes
set_option language_mode mixed
set_option define SYNTHESIS

# Keep the absolute sourcelist path in the saved project. The GUI opens the
# project from SPYGLASS_OUT, so a path relative to filelist/ would be invalid.
read_file -type sourcelist [file normalize $::env(SYN_FILELIST)]

current_goal $::env(SPYGLASS_GOAL)
run_goal
save_project
exit -force
