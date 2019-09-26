#!/bin/bash
function set_COS_All() {
           
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
#    NR_CPUS=16
    MSR_COS_BASE=0xC90
    for ((i=0;i<${NR_CPUS}; i+=1)); do
#        echo -n "[P${i}] COS="
        COSi=$((${MSR_COS_BASE} + ${i}))
        MSR_COSi=0x`echo "obase=16 ;$COSi"|bc`
        rdmsr -p ${i} ${MSR_COSi}
#        echo "rdmsr -p ${i} ${MSR_COSi}"
#        echo -n "     --> "
#        printf "%08x\n" ${CPS}
#        echo "wrmsr -p ${i} 0x${MSR_COSi} ${CPS[${i}]}"
        sudo wrmsr -p ${i} ${MSR_COSi} ${CPS[${i}]}
    done
}

set_COS_All $1 $1 $1 $1 $1 $1 $1 $1

for((i=0;i<$2;i++))
do
	{
		sudo ../memtest -m 4 -c 0 -i 100
	}
done > ../result/$3.log

#sudo bash test-cat1.sh $1 $2 > ./result/$3.log
cat ../result/$3.log | grep 'miss' > ../result/log$3.txt
cat ../result/$3.log | grep 'references' >> ../result/log$3.txt
cat ../result/$3.log | grep 'duration' >> ../result/log$3.txt
