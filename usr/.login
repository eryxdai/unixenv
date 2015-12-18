#!/bin/sh


echo "remote login:"

function find_path() {
    declare -a paths=("${!1}")
    filename=$2
    for path in ${paths[@]}
    do
        fullpath=${path}/${filename}
        if [ -f "${fullpath}" ]; then
            echo ${fullpath}
            break
        fi
    done
}

bin_paths=(/usr/local/bin ~/bin)

####################################################
# check .colorfile
####################################################
color_filename=".colorfile"
color_file=$(find_path bin_paths[@] ${color_filename})
if [ -z "${color_file}" ]; then
	echo "color file "${color_file}" does not exist"
	exit 1
fi
source ${color_file}

####################################################
# check .remote_hosts.txt
####################################################
host_filename=".remote_hosts.txt"
host_file=$(find_path bin_paths[@] ${host_filename})
if [ -z "${host_file}" ]; then
	echo "host file "$host_file" does not exist"
	exit 1
fi

####################################################
# display hosts
####################################################
function add_color(){
	line=$1
	cbeg=$2
	cend=${Color_Off}
	ret=${cbeg}${line}${cend}
	echo ${ret}
}

index=1
while IFS='\n' read line
do
    oldIFS="${IFS}"
    IFS=$'\t'
    fields=(${line})

    format="%6s  %50s  %-35s  %s"
    out=$(printf ${format} ${index} ${fields[@]})
    if [[ "${out}" == *"jet blue"* ]]; then
        out=$(add_color ${out} ${Blue})
    elif [[ "${out}" == *"CENTRAL"* ]]; then
        out=$(add_color ${out} ${Red})
    elif [[ "${out}" == *"WEST"* ]]; then
        out=$(add_color ${out} ${Yellow})
    elif [[ "${out}" == *"EURO"* ]]; then
        out=$(add_color ${out} ${Purple})
    elif [[ "${out}" == *"---"* ]] || [[ "${out}" == *"610"* ]]; then
        out=$(add_color ${out} ${IGreen})
    fi

    # Mac
    if [[ $(uname) == "Darwin" ]]; then
        echo  "${out}"
    # Linux
    else
        echo -e "${out}"
    fi

    IFS=${oldIFS}
    index=$(((${index} + 1)))
done < ${host_file}

####################################################
# choose host
####################################################

# only get first column which is hostname
hosts=($(cat "$host_file" | sed 's/^[[:space:]]//' | tr $'\t' ' ' | cut -d ' ' -f 1))
num=$(wc -l "$host_file" | tr -s ' '  | cut -d ' ' -f 2 | tr -d '\n')

choice=0
time=30
time2=$(($time*2))
beg=$(date +"%s")
while [ -z "$choice" ] || [ 0 -ge "$choice" ] || [ $num -lt "$choice" ]
do
	echo "valid host index is from 1 to "$num
	read -t $time -p "please enter host index: " choice

	# check time
	end=$(date +"%s")
	diff=$(($end-$beg))
	if [ "$diff" -gt $time ];
	then
		echo "\nonly have "$time2" second to enter"
		exit 1
	fi

	if [ -z "$choice" ];
	then
		echo "\n"
	fi
done

chosen_host="${hosts[$(($choice-1))]}"
#######################################
# helper function
#get_hostname() {
#    echo ${chosen_host} | tr '[:space:]' ' ' | tr -s ' ' | cut -d ' ' -f 1
#}
#######################################
echo "\nhost: $choice $chosen_host\n" | grep '[^[:space:]]*$'

ssh $chosen_host
