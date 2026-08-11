# GUI mode or batch mode execution branch.
if {[info command guiIsActive]==""} {
  if {[info command verdiSetFont]==""} {
    run
  }
  echo "Verdi GUI mode"
  dump -add / -depth 0
} else {
  echo "DVE GUI mode"
  dump -add /tb_top -depth 0
  do ./tb_debug_wave.do
}
