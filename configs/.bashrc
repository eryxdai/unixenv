echo "-------------------------------" >&2
echo "| read $(hostname):~/.bashrc " >&2
echo "-------------------------------" >&2
#################################################################################
# bash settings intro
#################################################################################
#1) /etc/profile: global settings for all users
#2) /etc/bashrc: global settings for openning bash (Ubuntu: /etc/bash.bashrc)
#
#
#3) login shell: correct in mac (terminal: current setting is login shell)
#execute /etc/profile
#IF ~/.bash_profile exists THEN
#    execute ~/.bash_profile
#ELSE
#    IF ~/.bash_login exist THEN
#        execute ~/.bash_login
#    ELSE
#        IF ~/.profile exist THEN
#            execute ~/.profile
#        END IF
#    END IF
#END IF
#
#4) non-login shell: corrent in mac (iterm: current setting is non-login shell)
#IF ~/.bashrc exists THEN
#    execute ~/.bashrc
#END IF


#################################################################################
#                                                                               #
#                             common settings                                   #
#                                                                               #
#################################################################################


#################################################################################
# Visual Settings
#################################################################################
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='4;31'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS=${LS_COLORS}:'di=0;33:ex=95:ln=91'


#################################################################################
# File System Alias
#################################################################################
alias ls="ls -F"
alias ll="ls -AlF"
alias cp="cp -i"
alias mv="mv -i"
alias aicanary="submit_canary --q tw_adindexer_canary_on_canary_tier"
alias afcanary="submit_canary --q tw_adfinder_canary_on_canary_tier"
alias mfcanary="submit_canary multifeed_aggregator_canary"
alias buckmf1="buck build multifeed/aggregator:aggregator_link"
alias buckmf2="buck build @mode/opt-clang multifeed/aggregator:aggregator_link"
alias buckaf="buck build @mode/opt-clang admarket/adfinder:adfinder"
alias buckai="buck build @mode/opt-clang admarket/adindexer:adindexer"
alias runmf="buck-out/gen/multifeed/aggregator/aggregator_link --smc_tiername=multifeed.aggregator_dev-yuxuandai --smc_server_port=4010 --min_timing=0 --ranking_debug=1 --print_stats --minloglevel=0 --logtofiles --log_dir=/home/yuxuandai/logs --vmodule=BoulderStoryRanker=3"
alias runaf="ADFINDER_BIN=buck-out/opt-clang/gen/admarket/adfinder/adfinder admarket/adfinder/scripts/dev_af_run.sh"
alias runai="ADINDEXER_BIN=buck-out/opt-clang/gen/admarket/adindexer/adindexer admarket/adindexer/scripts/dev_adind_run.sh"
alias folkmf="mf_forker -s dev9130.prn1.facebook.com:4010 -q 20 -d 120 -r prn"


#################################################################################
# Path Settings
#################################################################################
function check_add_path() {
    dir_path=$1
    if [ ! -d "${dir_path}" ]; then
#        echo "${dir_path} does not exist." >&2
        return 1
    fi
    if [ "*${dir_path}*" == ${PATH} ]; then
        echo "PATH has already contained {dir_path}." >&2
        return 1
    fi
    export PATH=${PATH}:${dir_path}
}

path_list=(/usr/local/bin ~/bin)
for to_add in ${path_list[@]}
do
    check_add_path ${to_add}
done


#################################################################################
#                                                                               #
#                        Darwin Linux settings                                  #
#                                                                               #
#################################################################################


#################################################################################
# Color settings
#################################################################################
color_file_paths=(/usr/local/bin ~/bin)
color_filename=".colorfile"
for color_file in ${color_file_paths[@]}
do
    fullpath=${color_file}/${color_filename}
    if [ -f ${fullpath} ]; then
        source ${fullpath}
        break
    fi
done
# useage # helper function to print how to apply color


#################################################################################
# Visual Settings
#################################################################################
function parse_git_branch() {
    branch_name=$(git branch 2> /dev/null | grep '\*' | cut -d ' ' -f2)
    bookmark_name=$(hg bookmark 2> /dev/null | grep '\*' | cut -d ' ' -f3)
    commit_info=$(hg sl 2> /dev/null | grep @.* -o | tr -s ' ')
    if [ ! -z "${branch_name}" ]; then
        echo  " (git: ${branch_name})"
    elif [ ! -z "${bookmark_name}" ]; then
        echo  " (hg: ${bookmark_name})"
    elif [ ! -z "${commit_info}" ]; then
        echo "  (hg -> ${commit_info})"
    else
        echo ""
    fi
}

function set_env_mac() {
#    echo "use mac settings" >&2

    if [ $(id -u) -eq 0 ]; then
        # you are root, set red colour prompt
        echo "in root"
        PS1="[ \[${Red}\]\\u\[${Color_Off}\]@💻 🚫 : \\w ]"
    else
        # normal
        PS1="[ \[${Blue}\]\\u\[${Color_Off}\]@:💻  \\w\[${Purple}\]\$(parse_git_branch)\[${Color_Off}\] ]$ "
    fi

#   # all python version will refer to this path if it's added
#   # workaround: add site-packages to .pth file under python2.7, so sys.path has this path
#    export PYTHONPATH="/opt/homebrew/lib/python2.7/site-packages/:$PYTHONPATH"

#    # java related env
    export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_131`
    export CLASSPATH="/usr/local/lib:$CLASSPATH"
#######################################
#   conda
    export PATH="/Users/yuxuandai/miniconda2/bin:$PATH"
    source activate python35
    echo "source activate python35" >&2
#######################################

}

function set_env_linux() {
#   echo "use linux settings" >&2

    # source default dev box settings which is located in backup dir
    source ~/backupdir/home/yuxuandai/.bashrc

    if [ $(id -u) -eq 0 ]; then
        # you are root, set red colour prompt
        PS1="[ \[${Red}\]\\u\[${Color_Off}\]@\\h: \\w ]"
    elif [ "$(whoami)" == "yuxuandai" ]; then
        # yuxuandai
        yroot_name=""
        if [ ! -z "${YROOT_NAME}" ]; then
            yroot_name="(${YROOT_NAME}) "
        fi
        PS1="[ \[${Yellow}\]${yroot_name}\[${Color_Off}\]\[${Blue}\]\\u\[${Color_Off}\]@\[${BIWhite}\]\\h\[${Color_Off}\]: \\w\[${Purple}\]\$(parse_git_branch)\[${Color_Off}\] ]$ "
    fi

    alias ls="ls -F --color"
    alias ll="ls -AlF --color"
}

function set_hadoop_env() {
    if [ -z "${HADOOP}" ] || [ -z "${HADOOP_PREFIX}" ]; then
        return 1
    fi
    alias hls="hadoop fs -ls"
    alias htext="hadoop fs -text"
    alias hget="hadoop fs -get"
    alias hput="hadoop fs -put"
    alias hmv="hadoop fs -mv"
    alias hchmod="hadoop fs -chmod"
    alias hcp="hadoop fs -cp"

}


if [ "$(uname)" == "Darwin" ]; then
    set_env_mac
elif [ "$(uname)" == "Linux" ]; then
    set_env_linux
fi

set_hadoop_env
