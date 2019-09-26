#!/bin/bash

function set_MBA_All() {      
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
    MSR_MBA_BASE=0xD50
    for ((i=0;i<${NR_CPUS}; i+=1)); do
#	echo -n "[P${i}] MBA="
	MBAi=$((${MSR_MBA_BASE} + ${i}))
	MSR_MBAi=0x`echo "obase=16 ;$MBAi"|bc`
	rdmsr -p ${i} ${MSR_MBAi}
#	echo "rdmsr -p ${i} ${MSR_MBAi}"
#	echo -n "     --> "
	CPSi=0x`echo "obase=16 ;(100-${CPS[${i}]})"|bc`
#        echo "wrmsr -p ${i} ${MSR_MBAi} ${CPSi}"
        sudo wrmsr -p ${i} ${MSR_MBAi} ${CPSi}
    done
}


set_MBA_All $1 $1 $1 $1 $1 $1 $1 $1

for((i=0;i<$2;i++))
do
	{
		sudo ../memtest -m 800 -c 0 -i 1
	}
done > ../result/$3.log

#sudo bash test-cat1.sh $1 $2 > ./result/$3.log
cat ../result/$3.log | grep 'miss' > ../result/log$3.txt
cat ../result/$3.log | grep 'references' >> ../result/log$3.txt
cat ../result/$3.log | grep 'duration' >> ../result/log$3.txt
cat ../result/$3.log | grep 'bandwidth' >> ../result/log$3.txt
