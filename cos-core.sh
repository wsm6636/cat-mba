#!bin/bash
NR_CPUS=8
for((i=0;i<${NR_CPUS}; i+=1));do
	pqos -a "llc:$i=$i"
done
