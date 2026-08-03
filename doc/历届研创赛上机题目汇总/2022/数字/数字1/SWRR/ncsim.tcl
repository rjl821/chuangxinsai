database -open waves -into waves.shm -default -incsize 10000

probe -create testbench -depth 2 -all -tasks -memories -dynamic -functions -database waves
#probe -create testbench.swrr -depth 2 -all -tasks -memories -dynamic -functions -database waves
status

#run 20000ns
run
exit
     

