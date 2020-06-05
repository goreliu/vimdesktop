#!/bin/zsh

all=$1
chn=$2

(($# == 2)) || {
    all=/mnt/c/mine/app/totalcmd/Totalcmd.inc
    chn=/mnt/c/mine/app/totalcmd/Language/Wcmd_chn.inc
}

cat $all | grep '^cm_' | sed 's/=\(.*\);.*/\n\1/g' > cmdlist.txt
cat $chn | iconv -f gbk -t utf-8 | grep '^[0-9]\+=' | sed "s/\r$//g" > chn.zsh

. ./chn.zsh

{
    echo -n '\xEF\xBB\xBF'
    echo TCCommand:

    while {read name; read pos} {
        [[ -n ${(P)pos} ]] && echo "    vim.Comment(\"<$name>\", \"${(P)pos}\")"
    } < cmdlist.txt

    cat <<EOF
return

SendPos(pos) {
    PostMessage, 1075, %pos%, 0, , ahk_class TTOTAL_CMD
}

EOF

    while {read name; read pos} {
        echo "<$name>:\n    SendPos($pos)\nreturn\n"
    } < cmdlist.txt
} > TCCommand.ahk

rm cmdlist.txt chn.zsh
