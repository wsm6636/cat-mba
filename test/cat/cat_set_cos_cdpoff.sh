sudo pqos -R l3cdp-off
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
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

