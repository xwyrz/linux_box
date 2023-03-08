#!/bin/bash

# 定义颜色文本
red='\033[0;31m'
clr='\033[0m'

echo -e "${red}欢迎使用服务器配置脚本${clr}"

while :
do
    echo -e "\n请选择您要执行的操作："
    echo "1) 安装 BBR"
    echo "2) 调整保留分区大小"
    echo -e "${red}0) 退出脚本${clr}"
    read choice
    
    case $choice in
        1)
            echo -e "net.core.default_qdisc=fq\nnet.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p
            ;;
        2)
            largest_device=$(df -h | awk '$1 ~ "^/dev/" { print $1,$2 }' | sort -nrk 2 | awk 'NR==1 {print $1}')
            tune2fs -r 10 $largest_device
            ;;
        0)
            echo -e "\n${red}再见！${clr}\n"
            exit
            ;;
        *)
            echo -e "\n${red}无效的选项，请再试一次。${clr}\n"
            ;;
    esac
done
