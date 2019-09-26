#!/bin/bash
function set_COS_All() {      
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
    MSR_COS_CDP_BASE=0xC90
    for ((i=0;i<${NR_CPUS}; i+=1)); do
	let "n=${i}<<1"
#	echo -n "[P${i}] COS_DATA="
	COSi_DATA=$((${MSR_COS_CDP_BASE} + ${n}))
	MSR_COSi_DATA=0x`echo "obase=16 ;$COSi_DATA"|bc`
	rdmsr -p ${i} ${MSR_COSi_DATA}
#	echo "rdmsr -p ${i} ${MSR_COSi_DATA}"

#	echo -n "COS_CODE="
	COSi_CODE=$((${MSR_COS_CDP_BASE} + ${n} +1))
        MSR_COSi_CODE=0x`echo "obase=16 ;$COSi_CODE"|bc`
        rdmsr -p ${i} ${MSR_COSi_CODE}
#        echo "rdmsr -p ${i} ${MSR_COSi_CODE}"

#	echo -n "     --> "
#        printf "%08x\n" ${CPS}
#        echo "wrmsr -p ${i} ${MSR_COSi_DATA} ${CPS[${i}]}"
        sudo wrmsr -p ${i} ${MSR_COSi_DATA} ${CPS[${i}]}
#        echo "wrmsr -p ${i} ${MSR_COSi_CODE} ${CPS[${i}]}"
        sudo wrmsr -p ${i} ${MSR_COSi_CODE} ${CPS[${i}]}
    done
}

set_COS_All $1 $1 $1 $1 $1 $1 $1 $1

for((i=0;i<$2;i++))
do
	{
		sudo ../memtest -m 7 -c 0 -i 100
	}
done > ../result/$3.log

#sudo bash test-cat1.sh $1 $2 > ./result/$3.log
cat ../result/$3.log | grep 'miss' > ../result/log$3.txt
cat ../result/$3.log | grep 'references' >> ../result/log$3.txt
cat ../result/$3.log | grep 'duration' >> ../result/log$3.txt
