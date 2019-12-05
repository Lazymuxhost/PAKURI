function config_banner()
{
    echo -e "${YELLOW}"
    echo -e "  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ "
    echo -e " ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ "
    echo -e " ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗"
    echo -e " ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║"
    echo -e " ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝"
    echo -e "  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ "
    echo -e "${NC}"
}

# Start Service
function service_start()
{
    systemctl start $1
}

# Stop Service
function service_stop()
{
    systemctl stop $1 
}

# Change CUI/GUI
function modeswitching()
{
    local mode
    local mode_v
    local key

    while :
    do
        mode=`systemctl get-default`
        if [ "graphical.target" = $mode ]; then
            mode_v="GUI"
        else
            mode_v="CUI"
        fi
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        echo -e "${RED_b}+---+"
        echo -e "| 2 | Mode Switching"
        echo -e "+---+${NC}"
        echo -e "-------------------- Now mode $mode_v -------------------"
        echo -e "${BLUE_b}+---+"
        echo -e "| 1 |:Switch CUI mode"
        echo -e "+---+"
        echo -e "${RED_b}+---+"
        echo -e "| 2 |:Switch GUI mode"
        echo -e "+---+"
        echo -e "${BLACK_b}+---+"
        echo -e "| 9 |:Back"
        echo -e "+---+"
        echo -e "${NC}"
        read -n 1 -s key
        clear
        config_banner
        date
        echo -e "-------------------- Now mode $mode_v -------------------"
        case "$key" in
            1 )
                echo -e "${BLUE_b}+---+"
                echo -e "| 1 |:Switch CUI mode"
                echo -e "+---+${NC}"
                echo -e "CUI mode enabled after reboot"
                systemctl set-default -f multi-user.target ;;
            2 )
                echo -e "${RED_b}+---+"
                echo -e "| 2 |:Switch GUI mode"
                echo -e "+---+${NC}"
                echo -e "GUI mode enabled after reboot"
                systemctl set-default -f graphical.target ;;
            9 )
                break ;;
            * ) 
                echo -e "error" ;;
        esac
        echo -e "Press any key to continue..."
        read
    done
}

# Config main menu
function config_manage()
{
    local key
    local flg_p

    while :
    do
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        if systemctl status postgresql|grep exited >/dev/null ;then
            echo -e "${BLUE_b}+---+"
            echo -e "| 1 | PpstgreSQL ${NC}[${GREEN_b}Running${NC}]"
            echo -e "${BLUE_b}+---+${NC}"
            flg_p=1
        else
            echo -e "${BLUE_b}+---+"
            echo -e "| 1 | PostgreSQL ${NC}[${RED_b}DOWN${NC}]"
            echo -e "${BLUE_b}+---+${NC}"
            flg_p=0
        fi
        echo -e "${RED_b}+---+"
        echo -e "| 2 | Mode Switching"
        echo -e "+---+"
        echo -e "${BLACK_b}+---+"
        echo -e "| 9 | Back"
        echo -e "+---+"
        echo -e "${NC}"
        read -n 1 -t 5 -s key
        clear
        config_banner
        date
        echo -e "------------------- Config Menu --------------------"
        case "$key" in
            1 )
                if [ $flg_p = 1 ];then
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | PpstgreSQL [${GREEN_b}Running${NC}]"
                    echo -e "${BLUE_b}+---+${NC}"
                    echo -e "Do you really want to ${RED_b}stop${NC}?"
                    echo -e "${GREEN_b}+---+         ${RED_b}+---+"
                    echo -e "${GREEN_b}| 1 | yes  ${NC}|  ${RED_b}| 2 | no"
                    echo -e "${GREEN_b}+---+         ${RED_b}+---+"
                    echo -e "${NC}"
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        service_stop postgresql
                    fi
                else
                    echo -e "${BLUE_b}+---+"
                    echo -e "| 1 | PostgreSQL [${RED_b}DOWN${NC}]"
                    echo -e "${BLUE_b}+---+${NC}"
                    echo -e "Do you really want to ${GREEN_b}start${NC}?"
                    echo -e "${GREEN_b}+---+         ${RED_b}+---+"
                    echo -e "${GREEN_b}| 1 | yes  ${NC}|  ${RED_b}| 2 | no"
                    echo -e "${GREEN_b}+---+         ${RED_b}+---+"
                    echo -e "${NC}"
                    read -n 1 -s ans
                    if [ $ans -eq 1 ];then
                        service_start postgresql
                    fi
                fi ;;
            2)
                modeswitching ;;
            9 )
                break ;;
            * )
                echo -e "error" ;;
        esac
    done
}