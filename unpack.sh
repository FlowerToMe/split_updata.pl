#!/usr/bin/env bash
# Created by 弱弱的胖橘猫丷
# March 17, 2017

trap "" SIGTSTP

LocalPATH=$(dirname $(readlink -f "$0"))

# Color control
N="\033[1;36m"
F="\033[0;31m"
T="\033[0m"
W="\033[0;33m"

function Show_usage() {
    printf "\n"
    printf "$N Automated processing script$T\n"
    printf "$N Created by 弱弱的胖橘猫丷$T\n"
    printf "$N https://github.com/flowertome$T\n"
    printf "\n"
    printf "$W Usage: unpack --[options] [path]\n$T"
    printf "\n"
    printf "$W  -a 'file' Add update.zip to the project directory\n$T"
    printf "$W  -b  Break update.app\n$T"
    printf "$W  -c  Clear cache files after decomposition$T\n"
    printf "\n"
}

add_file(){
    cp $FILE $LocalPATH/update.zip 1>/dev/null 2>/dev/null

    if [ "$Breakdownz" = "1" ]; then
        Breakdown
        return 0
    fi
}

Breakdown() {
    if [ ! -f "$LocalPATH/update.zip" ]; then
        printf "$F Please put update.zip under this folder.\n$T"
        exit 1
    fi

    unzip $FILE "UPDATE.APP" -d $LocalPATH/TEMPDIR/ 1>/dev/null 2>/dev/null

    if [ ! -x "$LocalPATH/splitupdate" ]; then
        chmod a+rx $LocalPATH/splitupdate 1>/dev/null 2>/dev/null
    fi

    ./splitupdate $LocalPATH/TEMPDIR/UPDATE.APP

    if [ "$Cleanup" = "1" ]; then
        Cleanup
        return 0
    fi
}

Cleanup() {
    if [ ! -d "$LocalPATH/output" ]; then
        mkdir $LocalPATH/output 1>/dev/null 2>/dev/null
    fi

    find $LocalPATH/TEMPDIR/ -iname "*.*" ! -name "UPDATE.APP" -exec mv {} $LocalPATH/output/ \;

    rm -rf $LocalPATH/TEMPDIR
}

while getopts "a:bch" arg; do
  case $arg in
      h)
            Show_usage
      ;;
      a)
        if [ ! -f "$OPTARG" ]; then
            printf "$F $OPTARG: No such file or directory.\n$T"
            exit 1
        else
            FILE="$OPTARG"
            add_file
        fi
      ;;
      b)
            Breakdownz=1
            Breakdown
      ;;
      c)
            Cleanup=1
            Cleanup
      ;;
      *)
            printf "$F Execute 'unpack -h' for view more information.\n$T"
            exit 1
      ;;
  esac
done

