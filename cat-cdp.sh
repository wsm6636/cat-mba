pqos -R l3cdp-on
function get_MSR_COS() {
    run_core=$1
    msr_cos_cdp_base=0xC90
    cos_data=$(( ${msr_cos_cdp_base} + (${run_core}<<1) )) 
    cos_code=$(( ${msr_cos_cdp_base} + (${run_core}<<1)+1 ))
    run_msr_cos_data=0x`echo "obase=16 ;$cos_data"|bc`
    echo "${run_msr_cos_data}"
    run_msr_cos_code=0x`echo "obase=16 ;$cos_code"|bc`
    echo "${run_msr_cos_code}"
}
#echo $(($(get_MSR_COS 1)==0xC91)) #1
function set_COS_DATA() {      
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
    MSR_COS_CDP_BASE=0xC90
    for ((i=0;i<${NR_CPUS}; i+=1)); do
	let "n=${i}<<1"
	echo -n "[P${i}] COS_DATA="
	COSi_DATA=$((${MSR_COS_CDP_BASE} + ${n}))
	MSR_COSi_DATA=0x`echo "obase=16 ;$COSi_DATA"|bc`
	rdmsr -p ${i} ${MSR_COSi_DATA}
	echo "rdmsr -p ${i} ${MSR_COSi_DATA}"

	echo -n "     --> "
        printf "%08x\n" ${CPS}
        echo "wrmsr -p ${i} ${MSR_COSi_DATA} ${CPS[${i}]}"
        sudo wrmsr -p ${i} ${MSR_COSi_DATA} ${CPS[${i}]}
	
	done
}


function set_COS_CODE() {
    strCPS="$@"
    #echo $strCPS
    declare -a CPS
    IFS=' ' read -ra CPS <<<$strCPS
    NR_CPUS=8
    MSR_COS_CDP_BASE=0xC90
    for ((i=0;i<${NR_CPUS}; i+=1)); do
        let "n=${i}<<1"
        echo -n "COS_CODE="
        COSi_CODE=$((${MSR_COS_CDP_BASE} + ${n} +1))
        MSR_COSi_CODE=0x`echo "obase=16 ;$COSi_CODE"|bc`
        rdmsr -p ${i} ${MSR_COSi_CODE}
        echo "rdmsr -p ${i} ${MSR_COSi_CODE}"

        echo -n "     --> "
        printf "%08x\n" ${CPS}
        echo "wrmsr -p ${i} ${MSR_COSi_CODE} ${CPS[${i}]}"
        sudo wrmsr -p ${i} ${MSR_COSi_CODE} ${CPS[${i}]}
    done
}

#set_COS_All 0x1 0x1 0x1 0x1 0x1 0x1 0x1 0x1
set_COS_DATA 0xf0 0xf0 0xf0 0xf0 0xf0 0xf0 0xf0 0xf0
set_COS_CODE 0x3 0x3 0x3 0x3 0x3 0x3 0x3 0x3

:<<!
set_COS_DATA 0xf0 
set_COS_CODE 0x3 

set_COS_DATA 0xf0
set_COS_CODE 0x3

set_COS_DATA 0xf0
set_COS_CODE 0x3

set_COS_DATA 0xf0
set_COS_CODE 0x3

set_COS_DATA 0xf0
set_COS_CODE 0x3

set_COS_DATA 0xf0
set_COS_CODE 0x3

set_COS_DATA 0xf0
set_COS_CODE 0x3

set_COS_DATA 0xf0
set_COS_CODE 0x3
!
