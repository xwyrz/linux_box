#!/bin/bash

#定义颜色文本
red='\033[0;31m'
clr='\033[0m'

echo -e "${red}欢迎使用服务器配置脚本${clr}"

while :
do
    echo -e "\n请选择您要执行的操作："
    echo "1) 安装BBR"
    echo "2) 调整保留分区大小"
    echo "3) 开放所有端口"
    echo -e "${red}0) 退出脚本${clr}"
    read choice

    case $choice in
        1)
            echo -e "正在安装BBR，请稍等..."
            #安装BBR
            sudo modprobe tcp_bbr
            echo "tcp_bbr" | sudo tee --append /etc/modules-load.d/modules.conf
            echo "net.core.default_qdisc=fq" | sudo tee --append /etc/sysctl.conf
            echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee --append /etc/sysctl.conf
            sudo sysctl -p
            echo -e "${red}BBR安装成功！${clr}"
            ;;
        2)
            largest_device=$(df -h | awk '$1 ~ "^/dev/" { print $1,$2 }' | sort -nrk 2 | awk 'NR==1 {print $1}')
            tune2fs -r 10 $largest_device
            echo -e "${red}已成功调整保留分区大小！${clr}"
            ;;
        3) 
            echo -e "${red}警告：开放所有端口存在安全风险，请谨慎操作！${clr}"
            echo -e "您确定要开放所有端口吗？(y/n)"
            read answer
            if [ "$answer" == "y" ] || [ "$answer" == "Y" ]
            then
                echo -e "${red}正在开放所有端口...${clr}"
                sudo iptables -P INPUT ACCEPT
                sudo iptables -P FORWARD ACCEPT
                sudo iptables -P OUTPUT ACCEPT
                sudo iptables -F
                echo -e "${red}所有端口已成功开放！${clr}"
            else
                echo -e "${red}操作已取消。${clr}"
            fi
            ;;
        0)
            echo -e "\n${red}再见！${clr}\n"
            exit
            ;;
        *)
            echo -e "\n${red}无效的选项，请重试。${clr}\n"
            ;;
    esac
done
