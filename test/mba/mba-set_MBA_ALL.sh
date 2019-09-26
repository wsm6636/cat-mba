#function get_MSR_MBA() {
#    run_core=$1
#    msr_mba_base=0xD50
#    mba=$((${msr_mba_base} + ${run_core}))
#    run_msr_mba=0x`echo "obase=16 ;$mba"|bc`
#    echo "${run_msr_mba}"
#}

#function set_MBA_All() {      
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
    MSR_MBA_BASE=0xD50
    for ((i=0;i<${NR_CPUS}; i+=1)); do
	echo -n "[P${i}] MBA="
	MBAi=$((${MSR_MBA_BASE} + ${i}))
	MSR_MBAi=0x`echo "obase=16 ;$MBAi"|bc`
	rdmsr -p ${i} ${MSR_MBAi}
	echo "rdmsr -p ${i} ${MSR_MBAi}"
	echo -n "     --> "
	CPSi=0x`echo "obase=16 ;(100-${CPS[${i}]})"|bc`
        echo "wrmsr -p ${i} ${MSR_MBAi} ${CPSi}"
        sudo wrmsr -p ${i} ${MSR_MBAi} ${CPSi}
    done
#}


#function set_MSR_MBA() {      
#    core="$1"
#    mba="$2"
#    MSR_MBA_BASE=0xD50
	
#    echo -n "[P$1] MBA="
#    MBAi=$((${MSR_MBA_BASE} + $1))
#    MBA=`echo "obase=10; $MBAi"|bc`
#    MSR_MBAi=0x`echo "obase=16 ;$MBAi"|bc`
#    rdmsr -p $1 ${MSR_MBAi}
#    echo "rdmsr -p $1 ${MSR_MBAi}"
#    echo -n "     --> "
#    let "p=100-$2"
#    CPSi=0x`echo "obase=16 ;${p}"|bc`
#    CPSi=0x`echo "obase=16 ;$2"|bc`
#    echo "wrmsr -p $1 ${MSR_MBAi} ${CPSi}"
#    sudo wrmsr -p $1 ${MSR_MBAi} ${CPSi}
#}

#set_MBA_All 10 20 30 40 50 60 70 80
#get_MSR_MBA
#set_MSR_MBA 0 10

#90%
#set_MBA_All 90 90 90 90 90 90 90 90
#80%
#set_MBA_All 80 80 80 80 80 80 80 80
#70%
#set_MBA_All 70 70 70 70 70 70 70 70
#60%
#set_MBA_All 60 60 60 60 60 60 60 60
#50%
#set_MBA_All 50 50 50 50 50 50 50 50
#40%
#set_MBA_All 40 40 40 40 40 40 40 40
#30%
#set_MBA_All 30 30 30 30 30 30 30 30
#20%
#set_MBA_All 20 20 20 20 20 20 20 20
#10%
#set_MBA_All 10 10 10 10 10 10 10 10
