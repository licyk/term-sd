#!/bin/bash
echo "######## ######## ########  ##     ##     ######  ########  "
echo "   ##    ##       ##     ## ###   ###    ##    ## ##     ## "
echo "   ##    ##       ##     ## #### ####    ##       ##     ## "
echo "   ##    ######   ########  ## ### ##     ######  ##     ## "
echo "   ##    ##       ##   ##   ##     ##          ## ##     ## "
echo "   ##    ##       ##    ##  ##     ##    ##    ## ##     ## "
echo "   ##    ######## ##     ## ##     ##     ######  ########  "
#使用figlet制作

echo "Term-SD初始化中......"
#################################################

#主界面部分

#设置启动时脚本路径
start_path=$(pwd)
#设置虚拟环境
venv_active="enable"
venv_info="启用"

#主界面
function mainmenu()
{
    cd $start_path #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    mainmenu_select=$(
		dialog --clear --title "Term-SD" --menu "请使用方向键和回车键进行操作\n当前虚拟环境状态:"$venv_info"" 20 60 10 \
      "0" "venv虚拟环境" \
			"1" "AUTOMATIC1111-stable-diffusion-webui" \
			"2" "ComfyUI" \
			"3" "InvokeAI" \
      "4" "lora-scripts" \
      "5" "更新脚本" \
      "6" "python镜像源" \
      "7" "关于" \
      "8" "退出" \
			3>&1 1>&2 2>&3 )


            if [ "${mainmenu_select}" == '1' ]; then #选择AUTOMATIC1111-stable-diffusion-webui
                a1111_sd_webui_option
            elif [ "${mainmenu_select}" == '2' ]; then #选择ComfyUI
                comfyui_option
            elif [ "${mainmenu_select}" == '3' ]; then #选择InvokeAI
                invokeai_option
            elif [ "${mainmenu_select}" == '4' ]; then #选择lora-scripts
                lora_scripts_option
            elif [ "${mainmenu_select}" == '5' ]; then #选择更新脚本
                update_option
            elif [ "${mainmenu_select}" == '6' ]; then #选择python镜像源
                set_proxy_option
            elif [ "${mainmenu_select}" == '7' ]; then #选择关于
                info_option
            elif [ "${mainmenu_select}" == '8' ]; then #选择退出
                exit
            elif [ "${mainmenu_select}" == '0' ]; then #选择venv虚拟环境
                venv_option
            else
            exit
            fi
            exit
}



#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{

    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录

        cd stable-diffusion-webui
        final_a1111_sd_webui_option=$(
    		dialog --clear --title "A1111-SD-Webui管理" --menu "请使用方向键和回车键对A1111-Stable-Diffusion-Webui进行操作" 20 60 10 \
	    		"1" "更新" \
    			"2" "卸载" \
	    		"3" "修复" \
          "4" "管理插件" \
          "5" "切换版本" \
          "6" "启动" \
          "7" "重新安装" \
          "8" "重新安装pytorch" \
          "9" "重新生成venv虚拟环境" \
	    		"0" "返回" \
	    		3>&1 1>&2 2>&3
	        )

	    if [ "${final_a1111_sd_webui_option}" == '1' ]; then
              echo "更新A1111-Stable-Diffusion-Webui中"
              git pull
              if [ $? = "0" ];then
                  dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新成功" 20 60
              else
                  dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新失败" 20 60
              fi
    	fi

	    if [ "${final_a1111_sd_webui_option}" == '2' ]; then
          if (dialog --clear --title "删除选项" --yesno "是否删除A1111-Stable-Diffusion-Webui" 20 60) then
            echo "删除A1111-Stable-Diffusion-Webui中"
            exit_venv
            cd ..
            rm -rfv ./stable-diffusion-webui
          fi
    	fi

	    if [ "${final_a1111_sd_webui_option}" == '3' ]; then
		        echo "将工作区、暂存取和HEAD保持一致"
            git checkout master
            git reset --hard HEAD
	    fi

	    if [ "${final_a1111_sd_webui_option}" == '4' ]; then
		    echo "管理插件"
        cd extensions
        extension_methon
	    fi

	    if [ "${final_a1111_sd_webui_option}" == '5' ]; then
		    echo "切换版本"
        git_checkout_manager
	    fi

      if [ "${final_a1111_sd_webui_option}" == '6' ]; then
        if [ -f "./term-sd-launch.sh" ]; then #找到启动脚本
          if (dialog --clear --title "stable-diffusion-webui管理" --yes-label "启动" --no-label "修改参数" --yesno "选择直接启动/修改启动参数" 20 60) then
              exec ./term-sd-launch.sh
              mainmenu
          else #修改启动脚本
              generate_a1111_sd_webui_launch
          fi
        else #找不到启动脚本,并启动脚本生成界面
          generate_a1111_sd_webui_launch
	      fi
      fi

	    if [ "${final_a1111_sd_webui_option}" == '7' ]; then
          if (dialog --clear --title "A1111-SD-Webui管理" --yesno "是否重新安装A1111-Stable-Diffusion-Webui" 20 60) then
            echo "重新安装A1111-Stable-Diffusion-Webui"
            cd ..
            exit_venv
            process_install_a1111_sd_webui
          fi
	    fi

	    if [ "${final_a1111_sd_webui_option}" == '8' ]; then
             pytorch_reinstall
    	fi

	    if [ "${final_a1111_sd_webui_option}" == '9' ]; then
             venv_generate
    	fi

	    if [ "${final_a1111_sd_webui_option}" == '0' ]; then
            mainmenu #回到主界面
	    fi

    else #找不到stable-diffusion-webui目录
        if (dialog --clear --title "A1111-SD-Webui管理" --yesno "检测到当前未安装A1111-Stable-Diffusion-Webui,是否进行安装" 20 60) then
            process_install_a1111_sd_webui
        else
            mainmenu
        fi
    fi
        mainmenu #处理完后返回插件管理界面

}

#comfyui选项
function comfyui_option()
{
    if [ -d "ComfyUI" ];then
        cd ComfyUI
        final_comfyui_option=$(
    		dialog --clear --title "ComfyUI管理" --menu "请使用方向键和回车键对ComfyUI进行操作" 20 60 10 \
	    		"1" "更新" \
    			"2" "卸载" \
	    		"3" "修复" \
          "4" "切换版本" \
          "5" "启动" \
          "6" "重新安装" \
          "7" "重新安装pytorch" \
          "8" "重新生成venv虚拟环境" \
	    		"0" "返回" \
	    		3>&1 1>&2 2>&3
	        )

	    if [ "${final_comfyui_option}" == '1' ]; then
              echo "更新ComfyUI中"
              git pull
              if [ $? = "0" ];then
                  dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新成功" 20 60
              else
                  dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新失败" 20 60
              fi
    	fi

	    if [ "${final_comfyui_option}" == '2' ]; then
          if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除ComfyUI" 20 60) then
            echo "删除ComfyUI中"
            exit_venv
            cd ..
            rm -rfv ./ComfyUI
          fi
    	fi

	    if [ "${final_comfyui_option}" == '3' ]; then
		    echo "将工作区、暂存取和HEAD保持一致"
            git reset --hard HEAD
	    fi

	    if [ "${final_comfyui_option}" == '4' ]; then
		        echo "切换版本"
            git_checkout_manager
	    fi

      if [ "${final_comfyui_option}" == '5' ]; then
		    if [ -f "./term-sd-launch.sh" ]; then #找到启动脚本
          if (dialog --clear --title "ComfyUI启动选择" --yes-label "启动" --no-label "修改参数" --yesno "选择直接启动/修改启动参数" 20 60) then
              exec ./term-sd-launch.sh
              mainmenu
          else
              generate_comfyui_launch
          fi
        else #找不到启动脚本,并启动脚本生成界面
          generate_comfyui_launch
        fi    
	    fi

	    if [ "${final_comfyui_option}" == '6' ]; then
          if (dialog --clear --title "ComfyUI管理" --yesno "是否重新安装ComfyUI" 20 60) then
            echo "重新安装ComfyUI"
            cd ..
            exit_venv
            process_install_comfyui
          fi
	    fi

	    if [ "${final_comfyui_option}" == '7' ]; then
              pytorch_reinstall
    	fi

	    if [ "${final_comfyui_option}" == '8' ]; then
              venv_generate
    	fi

	    if [ "${final_comfyui_option}" == '0' ]; then
            mainmenu #回到主界面
	    fi

    else
        if (dialog --clear --title "ComfyUI管理" --yesno "检测到当前未安装ComfyUI,是否进行安装" 20 60) then
            process_install_comfyui
        else
            mainmenu
        fi
    fi
        mainmenu #处理完后返回主界面界面
}


#InvokeAI选项
function invokeai_option()
{
  if [ -d "InvokeAI" ];then
        cd InvokeAI
        enter_venv
      if which invokeai > /dev/null ;then
        enter_venv
        final_invokeai_option=$(
    		dialog --clear --title "InvokeAI管理" --menu "请使用方向键和回车键对InvokeAI进行操作" 20 60 10 \
	    		"1" "更新" \
    			"2" "卸载" \
          "3" "启动" \
          "4" "重新安装" \
          "5" "重新生成venv虚拟环境" \
	    		"0" "返回" \
	    		3>&1 1>&2 2>&3
	        )

	        if [ "${final_invokeai_option}" == '1' ]; then
                 echo "更新InvokeAI中"
                 pip install --upgrade invokeai
         	fi

	        if [ "${final_invokeai_option}" == '2' ]; then
              if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI" 20 60) then
                echo "删除InvokeAI中"
                exit_venv
                cd ..
                rm -rfv ./InvokeAI
              fi
    	    fi

	        if [ "${final_invokeai_option}" == '3' ]; then
                generate_invokeai_launch
	        fi

	        if [ "${final_invokeai_option}" == '4' ]; then
              if (dialog --clear --title "InvokeAI管理" --yesno "是否重新安装InvokeAI" 20 60) then
                echo "重新安装InvokeAI"
                cd $start_path
                exit_venv
                process_install_invokeai
              fi
	        fi

	        if [ "${final_invokeai_option}" == '5' ]; then
                venv_generate
	        fi

	        if [ "${final_invokeai_option}" == '0' ]; then
                mainmenu #回到主界面
	        fi

      else 
          if (dialog --clear --title "InvokeAI管理" --yesno "检测到当前未安装InvokeAI,是否进行安装" 20 60) then
              cd $start_path
              process_install_invokeai
          else
              mainmenu
          fi
      fi
  else
        if (dialog --clear --title "InvokeAI管理" --yesno "检测到当前未安装InvokeAI,是否进行安装" 20 60) then
          process_install_invokeai
        else
          mainmenu
        fi
  fi
        mainmenu #处理完后返回主界面界面
}




#lora-scripts选项
function lora_scripts_option()
{
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        final_lora_scripts_option=$(
    		dialog --clear --title "lora-scripts管理" --menu "请使用方向键和回车键对lora-scripts进行操作" 20 60 10 \
	    		"1" "更新" \
    			"2" "卸载" \
	    		"3" "修复" \
          "4" "版本切换" \
          "5" "启动" \
          "6" "重新安装" \
          "7" "重新安装pytorch" \
          "8" '重新生成venv虚拟环境' \
	    		"0" "返回" \
	    		3>&1 1>&2 2>&3
	        )

	    if [ "${final_lora_scripts_option}" == '1' ]; then
              echo "更新lora-scripts中"
              git pull
              if [ $? = "0" ];then
                  dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新成功" 20 60
              else
                  dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新失败" 20 60
              fi
    	fi

	    if [ "${final_lora_scripts_option}" == '2' ]; then
          if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts" 20 60) then
            echo "删除lora-scripts中"
            exit_venv
            cd ..
            rm -rfv ./lora-scripts
          fi
    	fi

	    if [ "${final_lora_scripts_option}" == '3' ]; then
		        echo "将工作区、暂存取和HEAD保持一致"
            git reset --hard HEAD
	    fi

	    if [ "${final_lora_scripts_option}" == '4' ]; then
		        echo "切换版本"
            git_checkout_manager
	    fi

      if [ "${final_lora_scripts_option}" == '5' ]; then
		        enter_venv
            export HF_HOME=huggingface
            export PYTHONUTF8=1
            if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            python ./gui.py
            else
            python3 ./gui.py
            fi

            mainmenu
	    fi

	    if [ "${final_lora_scripts_option}" == '6' ]; then
          if (dialog --clear --title "lora-scripts管理" --yesno "是否重新安装lora_scripts" 20 60) then
             echo "重新安装lora_scripts"
             cd ..
             exit_venv
             process_install_lora_scripts
          fi
	    fi

	    if [ "${final_lora_scripts_option}" == '7' ]; then
              pytorch_reinstall
    	fi

	    if [ "${final_lora_scripts_option}" == '8' ]; then
              venv_generate
    	fi

	    if [ "${final_lora_scripts_option}" == '0' ]; then
            mainmenu #回到主界面
	    fi

    else
        if (dialog --clear --title "lora-scripts管理" --yesno "检测到当前未安装lora_scripts,是否进行安装" 20 60) then
            process_install_lora_scripts
        else
            mainmenu
        fi
    fi
        mainmenu #处理完后返回主界面界面
}




#启动脚本生成部分

#a1111-sd-webui启动脚本生成部分
function generate_a1111_sd_webui_launch()
{

#清空启动参数
        a1111_launch_option_1=""
        a1111_launch_option_2=""
        a1111_launch_option_3=""
        a1111_launch_option_4=""
        a1111_launch_option_5=""
        a1111_launch_option_6=""
        a1111_launch_option_7=""
        a1111_launch_option_8=""
        a1111_launch_option_9=""
        a1111_launch_option_10=""
        a1111_launch_option_11=""
        a1111_launch_option_12=""
        a1111_launch_option_13=""
        a1111_launch_option_14=""
        a1111_launch_option_15=""
        a1111_launch_option_16=""
        a1111_launch_option_17=""
        a1111_launch_option_18=""
        a1111_launch_option_19=""
        a1111_launch_option_20=""
        a1111_launch_option_21=""
        a1111_launch_option_22=""
        a1111_launch_option_23=""
        a1111_launch_option_24=""
        a1111_launch_option_25=""
        a1111_launch_option_26=""
        
#展示启动参数选项
    final_generate_a1111_sd_webui_launch_=$(dialog --clear --separate-output --notags --checklist "A1111-Stable-Diffusion-Webui启动参数选择" 20 60 10 \
        "1" "skip-torch-cuda-test" OFF \
        "2" "no-half" ON \
        "3" "no-half-vae" ON \
        "4" "medvram" OFF \
        "5" "lowvram" ON \
        "6" "lowram" OFF \
        "7" "enable-insecure-extension-access" ON \
        "8" "theme dark" ON \
        "9" "autolaunch" ON \
        "10" "xformers" ON \
        "11" "listen" ON \
        "12" "precision full" ON \
        "13" "force-enable-xformers" OFF \
        "14" "xformers-flash-attention" OFF \
        "15" "api" ON \
        "16" "ui-debug-mode" OFF \
        "17" "share" OFF \
        "18" "opt-split-attention-invokeai" OFF \
        "19" "opt-split-attention-v1" OFF \
        "20" "opt-sdp-attention" OFF \
        "21" "opt-sdp-no-mem-attention" OFF \
        "22" "disable-opt-split-attention" OFF \
        "23" "use-cpu all" OFF \
        "24" "opt-channelslast" OFF \
        "25" "gradio-queue" OFF \
        "26" "multiple" OFF \
   3>&1 1>&2 2>&3)


#根据菜单得到的数据设置变量
    if [ -z "$final_generate_a1111_sd_webui_launch_" ]; then
     echo "不选择启动参数"
    else
      for final_generate_a1111_sd_webui_launch in $final_generate_a1111_sd_webui_launch_; do
    case "$final_generate_a1111_sd_webui_launch" in
    "1")
      echo "skip-torch-cuda-test"
      a1111_launch_option_1="--skip-torch-cuda-test"
      ;;
    "2")
      echo "no-half"
      a1111_launch_option_2="--no-half"
      ;;
    "3")
      echo "no-half-vae"
      a1111_launch_option_3="--no-half-vae"
      ;;
    "4")
      echo "medvram"
      a1111_launch_option_4="--medvram"
      ;;
    "5")
      echo "lowvram"
      a1111_launch_option_5="--lowvram"
      ;;
    "6")
      echo "lowram"
      a1111_launch_option_6="--lowram"
      ;;
    "7")
      echo "enable-insecure-extension-access"
      a1111_launch_option_7="--enable-insecure-extension-access"
      ;;
    "8")
      echo "theme dark"
      a1111_launch_option_8="--theme dark"
      ;;
    "9")
      echo "autolaunch"
      a1111_launch_option_9="--autolaunch"
      ;;
    "10")
      echo "xformers"
      a1111_launch_option_10="--xformers"
      ;;
    "11")
      echo "listen"
      a1111_launch_option_11="--listen"
      ;;
    "12")
      echo "precision full"
      a1111_launch_option_12="--precision full"
      ;;
    "13")
      echo "force-enable-xformers"
      a1111_launch_option_13="--force-enable-xformers"
      ;;
    "14")
      echo "xformers-flash-attention"
      a1111_launch_option_14="--xformers-flash-attention"
      ;;
    "15")
      echo "api"
      a1111_launch_option_15="--api"
      ;;
    "16")
      echo "ui-debug-mode"
      a1111_launch_option_16="--ui-debug-mode"
      ;;
    "17")
      echo "share"
      a1111_launch_option_17="--share"
      ;;
    "18")
      echo "opt-split-attention-invokeai"
      a1111_launch_option_18="--opt-split-attention-invokeai"
      ;;
    "19")
      echo "opt-split-attention-v1"
      a1111_launch_option_19="--opt-split-attention-v1"
      ;;
    "20")
      echo "opt-sdp-attention"
      a1111_launch_option_20="--opt-sdp-attention"
      ;;
    "21")
      echo "opt-sdp-no-mem-attention"
      a1111_launch_option_21="--opt-sdp-no-mem-attention"
      ;;
    "22")
      echo "disable-opt-split-attention"
      a1111_launch_option_22="--disable-opt-split-attention"
      ;;
    "23")
      echo "use-cpu all"
      a1111_launch_option_23="--use-cpu all"
      ;;
    "24")
      echo "opt-channelslast"
      a1111_launch_option_24="--opt-channelslast"
      ;;
    "25")
      echo "gradio-queue"
      a1111_launch_option_25="--gradio-queue"
      ;;
    "26")
      echo "multiple"
      a1111_launch_option_26="--multiple"
      ;;
    *)
      echo "不选择启动参数" >&2
      exit 1
      ;;    
        esac
     done
    fi

#生成启动脚本
    rm -v ./term-sd-launch.sh
    echo "设置启动参数" "$a1111_launch_option_1" "$a1111_launch_option_2" "$a1111_launch_option_3" "$a1111_launch_option_4" "$a1111_launch_option_5" "$a1111_launch_option_6" "$a1111_launch_option_7" "$a1111_launch_option_8" "$a1111_launch_option_9" "$a1111_launch_option_10" "$a1111_launch_option_11" "$a1111_launch_option_12" "$a1111_launch_option_13" "$a1111_launch_option_14" "$a1111_launch_option_15" "$a1111_launch_option_16" "$a1111_launch_option_17" "$a1111_launch_option_18" "$a1111_launch_option_19" "$a1111_launch_option_20" "$a1111_launch_option_21" "$a1111_launch_option_22" "$a1111_launch_option_23" "$a1111_launch_option_24" "$a1111_launch_option_25" "$a1111_launch_option_26"
    echo "echo "进入venv虚拟环境"" >term-sd-launch.sh

    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
    echo "source ./venv/Scripts/activate" >>term-sd-launch.sh
    echo "python launch.py "$a1111_launch_option_1" "$a1111_launch_option_2" "$a1111_launch_option_3" "$a1111_launch_option_4" "$a1111_launch_option_5" "$a1111_launch_option_6" "$a1111_launch_option_7" "$a1111_launch_option_8" "$a1111_launch_option_9" "$a1111_launch_option_10" "$a1111_launch_option_11" "$a1111_launch_option_12" "$a1111_launch_option_13" "$a1111_launch_option_14" "$a1111_launch_option_15" "$a1111_launch_option_16" "$a1111_launch_option_17" "$a1111_launch_option_18" "$a1111_launch_option_19" "$a1111_launch_option_20" "$a1111_launch_option_21" "$a1111_launch_option_22" "$a1111_launch_option_23" "$a1111_launch_option_24" "$a1111_launch_option_25" "$a1111_launch_option_26"" >>term-sd-launch.sh
    else
    echo "source ./venv/bin/activate" >>term-sd-launch.sh
    echo "python3 launch.py "$a1111_launch_option_1" "$a1111_launch_option_2" "$a1111_launch_option_3" "$a1111_launch_option_4" "$a1111_launch_option_5" "$a1111_launch_option_6" "$a1111_launch_option_7" "$a1111_launch_option_8" "$a1111_launch_option_9" "$a1111_launch_option_10" "$a1111_launch_option_11" "$a1111_launch_option_12" "$a1111_launch_option_13" "$a1111_launch_option_14" "$a1111_launch_option_15" "$a1111_launch_option_16" "$a1111_launch_option_17" "$a1111_launch_option_18" "$a1111_launch_option_19" "$a1111_launch_option_20" "$a1111_launch_option_21" "$a1111_launch_option_22" "$a1111_launch_option_23" "$a1111_launch_option_24" "$a1111_launch_option_25" "$a1111_launch_option_26"" >>term-sd-launch.sh
    fi

    chmod u+x ./term-sd-launch.sh
    exec ./term-sd-launch.sh
    mainmenu
}


#comfyui启动脚本生成部分
function generate_comfyui_launch()
{

        comfyui_launch_option_1=""
        comfyui_launch_option_2=""
        comfyui_launch_option_3=""
        comfyui_launch_option_4=""
        comfyui_launch_option_5=""
        comfyui_launch_option_6=""
        comfyui_launch_option_7=""
        comfyui_launch_option_8=""
        comfyui_launch_option_9=""
        comfyui_launch_option_10=""
        comfyui_launch_option_11=""
        comfyui_launch_option_12=""
        comfyui_launch_option_13=""
        comfyui_launch_option_14=""

    final_generate_comfyui_launch_=$(dialog --clear --separate-output --notags --checklist "ComfyUI启动参数选择" 20 60 10 \
        "1" "listen" OFF \
        "2" "auto-launch" OFF \
        "3" "dont-upcast-attention" OFF \
        "4" "force-fp32" OFF\
        "5" "use-split-cross-attention" OFF \
        "6" "use-pytorch-cross-attention" OFF \
        "7" "disable-xformers" OFF \
        "8" "gpu-only" OFF \
        "9" "highvram" OFF \
        "10" "normalvram" OFF \
        "11" "lowvram" OFF \
        "12" "novram" OFF \
        "13" "cpu" OFF \
        "14" "quick-test-for-ci" OFF \
    3>&1 1>&2 2>&3)


    if [ -z "$final_generate_comfyui_launch_" ]; then
     echo "不选择启动参数"
    else
      for final_generate_comfyui_launch in $final_generate_comfyui_launch_; do
    case "$final_generate_comfyui_launch" in
    "1")
      echo "listen"
      comfyui_launch_option_1="--listen"
      ;;
    "2")
      echo "auto-launch"
      comfyui_launch_option_2="--auto-launch"
      ;;
    "3")
      echo "dont-upcast-attention"
      comfyui_launch_option_3="--dont-upcast-attention"
      ;;
    "4")
      echo "force-fp32"
      comfyui_launch_option_4="--force-fp32"
      ;;
    "5")
      echo "use-split-cross-attention"
      comfyui_launch_option_5="--use-split-cross-attention"
      ;;
    "6")
      echo "use-pytorch-cross-attention"
      comfyui_launch_option_6="--use-pytorch-cross-attention"
      ;;
    "7")
      echo "disable-xformers"
      comfyui_launch_option_7="--disable-xformers"
      ;;
    "8")
      echo "gpu-only"
      comfyui_launch_option_8="--gpu-only"
      ;;
    "9")
      echo "highvram"
      comfyui_launch_option_9="--highvram"
      ;;
    "10")
      echo "normalvram"
      comfyui_launch_option_10="--normalvram"
      ;;
    "11")
      echo "lowvram"
      comfyui_launch_option_11="--lowvram"
      ;;
    "12")
      echo "novram"
      comfyui_launch_option_12="--novram"
      ;;
    "13")
      echo "cpu"
      comfyui_launch_option_13="--cpu"
      ;;
    "14")
      echo "quick-test-for-ci"
      comfyui_launch_option_14="--quick-test-for-ci"
      ;;
    *)
      echo "不选择启动参数" >&2
      exit 1
      ;;    
        esac
     done
    fi

    rm -v ./term-sd-launch.sh
    echo "设置启动参数" "$comfyui_launch_option_1" "$comfyui_launch_option_2" "$comfyui_launch_option_3" "$comfyui_launch_option_4" "$comfyui_launch_option_5" "$comfyui_launch_option_6" "$comfyui_launch_option_7" "$comfyui_launch_option_8" "$comfyui_launch_option_9" "$comfyui_launch_option_10" "$comfyui_launch_option_11" "$comfyui_launch_option_12" "$comfyui_launch_option_13" "$comfyui_launch_option_14"
    echo "echo "进入venv虚拟环境"" >term-sd-launch.sh
    

    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
    echo "source ./venv/Scripts/activate" >>term-sd-launch.sh
    echo "python main.py "$comfyui_launch_option_1" "$comfyui_launch_option_2" "$comfyui_launch_option_3" "$comfyui_launch_option_4" "$comfyui_launch_option_5" "$comfyui_launch_option_6" "$comfyui_launch_option_7" "$comfyui_launch_option_8" "$comfyui_launch_option_9" "$comfyui_launch_option_10" "$comfyui_launch_option_11" "$comfyui_launch_option_12" "$comfyui_launch_option_13" "$comfyui_launch_option_14"" >>term-sd-launch.sh
    else
    echo "source ./venv/bin/activate" >>term-sd-launch.sh
    echo "python3 main.py "$comfyui_launch_option_1" "$comfyui_launch_option_2" "$comfyui_launch_option_3" "$comfyui_launch_option_4" "$comfyui_launch_option_5" "$comfyui_launch_option_6" "$comfyui_launch_option_7" "$comfyui_launch_option_8" "$comfyui_launch_option_9" "$comfyui_launch_option_10" "$comfyui_launch_option_11" "$comfyui_launch_option_12" "$comfyui_launch_option_13" "$comfyui_launch_option_14"" >>term-sd-launch.sh
    fi

    chmod u+x ./term-sd-launch.sh
    exec ./term-sd-launch.sh
    mainmenu
}


#invokeai启动脚本生成部分
function generate_invokeai_launch()
{

  invokeai_launch_option=$(
		dialog --clear --title "InvokeAI启动选项" --menu "请使用方向键和回车键选择启动参数" 20 60 10 \
      "1" "invokeai-configure" \
			"2" "invokeai" \
			"3" "invokeai --web" \
			"4" "invokeai-ti --gui" \
      "5" "invokeai-merge --gui" \
      "6" "返回" \
			3>&1 1>&2 2>&3 )

      if [ "${invokeai_launch_option}" == '1' ]; then 
          invokeai-configure
      elif [ "${invokeai_launch_option}" == '2' ]; then 
          invokeai
      elif [ "${invokeai_launch_option}" == '3' ]; then 
          invokeai --web
      elif [ "${invokeai_launch_option}" == '4' ]; then 
          invokeai-ti --gui
      elif [ "${invokeai_launch_option}" == '5' ]; then 
          invokeai-merge --gui
      elif [ "${invokeai_launch_option}" == '6' ]; then 
          mainmenu
      fi
    mainmenu
}


#term-sd更新选项
function update_option()
{
    if (dialog --clear --title "更新选项" --yes-label "是" --no-label "否" --yesno "更新时是否选择代理" 20 60) then
        aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
           cp -fv ./term-sd-update-tmp/term-sd.sh ./
           rm -rfv ./term-sd-update-tmp
	   chmod u+x term-sd.sh
           echo "更新完成，请重启Term-SD"
           exit
        else
           echo "更新失败"
        fi
    else
        aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
           cp -fv ./term-sd-update-tmp/term-sd.sh ./
           rm -rfv ./term-sd-update-tmp
	   chmod u+x term-sd.sh
           echo "更新完成，请重启Term-SD"
           exit
        else
           echo "更新失败"
        fi
    fi
    exit
}

#python镜像源选项
function set_proxy_option()
{
    if (dialog --clear --title "python镜像源选项" --yes-label "是" --no-label "否" --yesno "是否启用python镜像源" 20 60) then
        pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
        pip config set global.extra-index-url "https://mirror.sjtu.edu.cn/pytorch-wheels"
    else
        pip config unset global.index-url
        pip config unset global.extra-index-url
    fi
    mainmenu
}


#term-sd版本信息
function info_option()
{
    dialog --clear --title "关于" --msgbox "Term-SD是基于终端显示的管理器,可以对项目进行简单的管理  \n
支持的项目如下: \n
1、AUTOMATIC1111-stable-diffusion-webui \n
2、ComfyUI \n
3、InvokeAI \n
4、lora-scripts \n
(项目都主要基于stable-diffusion)\n
\n
使用说明：\n
1、使用方向键、Tab键、Enter进行选择，Space键勾选或取消选项 \n
Ctrl+C可中断指令的运行 \n
2、安装项目的路径和Term-SD脚本所在路径相同，方便管理\n
3、若项目使用了venv虚拟环境，移动项目到新的路径后需要使用Term-SD的“重新生成venv虚拟环境”功能，才能使venv虚拟环境正常工作\n
4、若更新项目失败时，可使用“修复”功能，再重新更新\n
5、Term-SD只能实现简单的安装，管理功能，若要导入模型等操作需手动在文件管理器上操作
\n
建议保持启用虚拟环境，因为不同项目对软件包的版本要求不同\n
若没有设置过python镜像源，推荐在\"python镜像源\"进行设置\n
\n
该脚本的编写参考了https://gitee.com/skymysky/linux \n
脚本在理论上支持全平台(Windows平台需安装msys2,Android平台需要安装Termux)\n
\n
stable-diffusion相关链接：\n
https://huggingface.co/\n
https://civitai.com/\n
https://www.bilibili.com/read/cv22159609\n
\n
\n
by licyk\
(◍•ᴗ•◍)" 20 60

    #返回主菜单  
    mainmenu
}

#################################################

#venv虚拟环境处理


function venv_option()
{
    if (dialog --clear --title "venv虚拟环境" --yes-label "启用" --no-label "禁用" --yesno "是否启用venv虚拟环境,默认为启用状态,推荐启用" 20 60) then
        venv_active="enable"
        venv_info="启用"
        echo "启用虚拟环境"
    else
        venv_active="disable"
        venv_info="禁用"
        echo "禁用虚拟环境"
    fi
    mainmenu
}

function venv_generate()
{
    if [ "$venv_active" = "enable" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "系统为windows"
            echo "创建venv虚拟环境"
            python -m venv venv
        else
            echo "系统为$(uname -o)"
            echo "创建venv虚拟环境"
            python3 -m venv venv
        fi
    else
      echo "忽略创建venv虚拟环境"
    fi
}

function enter_venv()
{
  if [ "$venv_active" = "enable" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "系统为windows"
            echo "进入venv虚拟环境"
            source ./venv/Scripts/activate
        else
            echo "系统为$(uname -o)"
            echo "进入venv虚拟环境"
            source ./venv/bin/activate
        fi
  else
    echo "忽略进入venv虚拟环境"
  fi
}

function exit_venv()
{
  echo "退出venv虚拟环境"
  deactivate
}


#################################################

#安装部分

#安装前代理选择
function proxy_option()
{
python_proxy=""
extra_python_proxy=""
github_proxy=""
force_pip=""

final_proxy_options=$(dialog --clear --separate-output --notags --title "代理选择" --checklist "请选择代理，强制使用pip一般情况下不选" 20 60 10 \
  "1" "启用python镜像源" ON \
  "2" "启用github代理" ON \
  "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)


if [ -z "$final_proxy_options" ]; then
  echo "不选择代理"
else
  for final_proxy_option in $final_proxy_options; do
    case "$final_proxy_option" in
    "1")
      echo "设置python镜像源"
      python_proxy="-i https://mirror.sjtu.edu.cn/pypi/web/simple"
      extra_python_proxy="-f https://mirror.sjtu.edu.cn/pytorch-wheels"
      ;;
    "2")
      echo "设置github代理"
      github_proxy="https://ghproxy.com/"
      ;;
    "3")
      echo "强制使用pip"
      force_pip="--break-system-packages"
      ;;
    *)
      echo "不选择代理" >&2
      exit 1
      ;;
    esac
  done
fi
}


#pytorch安装选择
function python_dep_install()
{
  final_python_dep_install=$(
		dialog --clear --title "pytorch安装" --menu "请使用方向键和回车键选择安装的pytorch版本" 20 60 10 \
			"1" "Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
			"2" "Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
			"3" "Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
			"4" "Torch 2.0.1(CUDA11.8)+xFormers 0.020" \
      "5" "Torch 2.0.1+RoCM 5.4.2" \
      "6" "跳过安装" \
			3>&1 1>&2 2>&3
	)

	if [ "${final_python_dep_install}" == '1' ]; then
        echo "安装Torch 1.12.1(CUDA11.3)+xFormers 0.014"
        ins_pytorch="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
	elif [ "${final_python_dep_install}" == '2' ]; then
        echo "安装Torch 1.13.1(CUDA11.7)+xFormers 0.016"
        ins_pytorch="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
	elif [ "${final_python_dep_install}" == '3' ]; then
		    echo "开始安装Torch 2.0.0(CUDA11.8)+xFormers 0.018"
        ins_pytorch="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
	elif [ "${final_python_dep_install}" == '4' ]; then
        echo "开始安装Torch 2.0.1(CUDA11.8)+xFormers 0.020"
        ins_pytorch="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.20"
  elif [ "${final_python_dep_install}" == '5' ]; then
        echo "开始安装Torch 0.15.0+RoCM 5.4.2"
        ins_pytorch="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2"
  elif [ "${final_python_dep_install}" == '6' ]; then
        echo "跳过安装"
        ins_pytorch=""
    fi
}



#automatic1111-webui插件选择
function a1111_sd_webui_extension_option()
{

  #清空插件选择
  extension_1=""  
  extension_2=""  
  extension_3=""  
  extension_4=""  
  extension_5=""  
  extension_6=""  
  extension_7=""  
  extension_8=""  
  extension_9=""  
  extension_10=""  
  extension_11=""  
  extension_12=""  
  extension_13=""  
  extension_14=""  
  extension_15=""  
  extension_16=""  
  extension_17=""  
  extension_18=""  
  extension_19=""  
  extension_20=""  
  extension_21=""  
  extension_22=""  
  extension_23=""  
  extension_24=""  
  extension_25=""  
  extension_26=""  
  extension_27=""  
  extension_28=""  
  extension_29=""  
  extension_30=""  
  extension_31=""  
  extension_32=""  
  extension_33=""  
  extension_34=""  


  final_extension_options=$(dialog --separate-output --notags --checklist "A1111-Stable-Diffusion-Webui插件选择" 20 60 10 \
  "1" "kohya-config-webui" ON \
  "2" "sd-webui-additional-networks" ON \
  "3" "a1111-sd-webui-tagcomplete" ON \
  "4" "multidiffusion-upscaler-for-automatic1111" ON \
  "5" "sd-dynamic-thresholding" ON \
  "6" "sd-webui-cutoff" ON \
  "7" "sd-webui-model-converter" ON \
  "8" "sd-webui-supermerger" ON \
  "9" "stable-diffusion-webui-localization-zh_CN" ON \
  "10" "stable-diffusion-webui-wd14-tagger" ON \
  "11" "sd-webui-regional-prompter" ON \
  "12" "stable-diffusion-webui-baidu-netdisk" ON \
  "13" "stable-diffusion-webui-anti-burn" ON \
  "14" "loopback_scaler" ON \
  "15" "latentcoupleregionmapper" ON \
  "16" "ultimate-upscale-for-automatic1111" ON \
  "17" "deforum-for-automatic1111" ON \
  "18" "stable-diffusion-webui-images-browser" ON \
  "19" "stable-diffusion-webui-huggingface" ON \
  "20" "sd-civitai-browser" ON \
  "21" "sd-webui-additional-networks" ON \
  "22" "openpose-editor" ON \
  "23" "sd-webui-depth-lib" ON \
  "24" "posex" ON \
  "25" "sd-webui-tunnels" ON \
  "26" "batchlinks-webui" ON \
  "27" "stable-diffusion-webui-catppuccin" ON \
  "28" "a1111-sd-webui-locon" ON \
  "29" "stable-diffusion-webui-rembg" ON \
  "30" "stable-diffusion-webui-two-shot" ON \
  "31" "sd-webui-lora-block-weight" ON \
  "32" "sd-face-editor" ON \
  "33" "sd-webui-segment-anything" ON \
  "34" "sd-webui-controlnet" ON \
   3>&1 1>&2 2>&3)


if [ -z "$final_extension_options" ]; then
  echo "不安装插件"
else
  for final_extension_option in $final_extension_options; do
    case "$final_extension_option" in
    "1")
      echo "安装kohya-config-webui"
      extension_1="https://github.com/WSH032/kohya-config-webui"
      ;;
    "2")
      echo "安装sd-webui-additional-networks"
      extension_2="https://github.com/kohya-ss/sd-webui-additional-networks"
      ;;
    "3")
      echo "安装a1111-sd-webui-tagcomplete"
      extension_3="https://github.com/DominikDoom/a1111-sd-webui-tagcomplete"
      ;;
    "4")
      echo "安装multidiffusion-upscaler-for-automatic1111"
      extension_4="https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111"
      ;;
    "5")
      echo "安装sd-dynamic-thresholding"
      extension_5="https://github.com/mcmonkeyprojects/sd-dynamic-thresholding"
      ;;
    "6")
      echo "安装sd-webui-cutoff"
      extension_6="https://github.com/hnmr293/sd-webui-cutoff"
      ;;
    "7")
      echo "安装sd-webui-model-converter"
      extension_7="https://github.com/Akegarasu/sd-webui-model-converter"
      ;;
    "8")
      echo "安装sd-webui-supermerger"
      extension_8="https://github.com/hako-mikan/sd-webui-supermerger"
      ;;
    "9")
      echo "安装stable-diffusion-webui-localization-zh_CN"
      extension_9="https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN"
      ;;
    "10")
      echo "安装stable-diffusion-webui-wd14-tagger"
      extension_10="https://github.com/tsukimiya/stable-diffusion-webui-wd14-tagger"
      ;;
    "11")
      echo "安装sd-webui-regional-prompter"
      extension_11="https://github.com/hako-mikan/sd-webui-regional-prompter"
      ;;
    "12")
      echo "安装stable-diffusion-webui-baidu-netdisk"
      extension_12="https://github.com/zanllp/stable-diffusion-webui-baidu-netdisk"
      ;;
    "13")
      echo "安装stable-diffusion-webui-anti-burn"
      extension_13="https://github.com/klimaleksus/stable-diffusion-webui-anti-burn"
      ;;
    "14")
      echo "安装loopback_scaler"
      extension_14="https://github.com/Elldreth/loopback_scaler.git"
      ;;
    "15")
      echo "安装latentcoupleregionmapper"
      extension_15="https://github.com/CodeZombie/latentcoupleregionmapper.git"
      ;;
    "16")
      echo "安装ultimate-upscale-for-automatic1111"
      extension_16="https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git"
      ;;
    "17")
      echo "安装deforum-for-automatic1111"
      extension_17="https://github.com/deforum-art/deforum-for-automatic1111-webui"
      ;;
    "18")
      echo "安装stable-diffusion-webui-images-browser"
      extension_18="https://github.com/AlUlkesh/stable-diffusion-webui-images-browser"
      ;;
    "19")
      echo "安装stable-diffusion-webui-huggingface"
      extension_19="https://github.com/camenduru/stable-diffusion-webui-huggingface"
      ;;
    "20")
      echo "安装sd-civitai-browser"
      extension_20="https://github.com/camenduru/sd-civitai-browser"
      ;;
    "21")
      echo "安装sd-webui-additional-networks"
      extension_21="https://github.com/kohya-ss/sd-webui-additional-networks"
      ;;
    "22")
      echo "安装openpose-editor"
      extension_22="https://github.com/camenduru/openpose-editor"
      ;;
    "23")
      echo "安装sd-webui-depth-lib"
      extension_23="https://github.com/jexom/sd-webui-depth-lib"
      ;;
    "24")
      echo "安装posex"
      extension_24="https://github.com/hnmr293/posex"
      ;;
    "25")
      echo "安装sd-webui-tunnels"
      extension_25="https://github.com/camenduru/sd-webui-tunnels"
      ;;
    "26")
      echo "安装batchlinks-webui"
      extension_26="https://github.com/etherealxx/batchlinks-webui"
      ;;
    "27")
      echo "安装stable-diffusion-webui-catppuccin"
      extension_27="https://github.com/camenduru/stable-diffusion-webui-catppuccin"
      ;;
    "28")
      echo "安装a1111-sd-webui-locon"
      extension_28="https://github.com/KohakuBlueleaf/a1111-sd-webui-locon"
      ;;
    "29")
      echo "安装stable-diffusion-webui-rembg"
      extension_29="https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg"
      ;;
    "30")
      echo "安装stable-diffusion-webui-two-shot"
      extension_30="https://github.com/ashen-sensored/stable-diffusion-webui-two-shot"
      ;;
    "31")
      echo "安装sd-webui-lora-block-weight"
      extension_31="https://github.com/hako-mikan/sd-webui-lora-block-weight"
      ;;
    "32")
      echo "安装sd-face-editor"
      extension_32="https://github.com/ototadana/sd-face-editor"
      ;;
    "33")
      echo "安装sd-webui-segment-anything"
      extension_33="https://github.com/continue-revolution/sd-webui-segment-anything.git"
      ;;
    "34")
      echo "安装sd-webui-controlnet"
      extension_34="https://github.com/Mikubill/sd-webui-controlnet"
      ;;
    *)
      echo "不安装插件" >&2
      exit 1
      ;;
    
    esac
  done
fi
}

#################################################

#a1111-sd-webui安装处理部分
function process_install_a1111_sd_webui()
{

  #安装前的准备
  proxy_option #代理选择
  python_dep_install #pytorch选择
  a1111_sd_webui_extension_option #插件选择

  #开始安装插件
  echo "开始安装stable-diffusion-webui"
  git clone "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

  cd ./stable-diffusion-webui
  venv_generate
  enter_venv
  cd ..

  pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip
  mkdir ./stable-diffusion-webui/repositories
  git clone "$github_proxy"https://github.com/CompVis/stable-diffusion.git ./stable-diffusion-webui/repositories/stable-diffusion
  git clone "$github_proxy"https://github.com/CompVis/taming-transformers.git ./stable-diffusion-webui/repositories/taming-transformers
  git clone "$github_proxy"https://github.com/sczhou/CodeFormer.git ./stable-diffusion-webui/repositories/CodeFormer
  git clone "$github_proxy"https://github.com/salesforce/BLIP.git ./stable-diffusion-webui/repositories/BLIP
  git clone "$github_proxy"https://github.com/Stability-AI/stablediffusion.git/ ./stable-diffusion-webui/repositories/stable-diffusion-stability-ai
  pip install git+"$github_proxy"https://github.com/crowsonkb/k-diffusion.git --prefer-binary $python_proxy $force_pip
  pip install git+"$github_proxy"https://github.com/TencentARC/GFPGAN.git --prefer-binary $python_proxy $force_pip

  cd ./stable-diffusion-webui/repositories/CodeFormer/
  pip install -r requirements.txt --prefer-binary $python_proxy $force_pip
  cd $start_path

  pip install -U numpy  --prefer-binary $python_proxy $force_pip
  pip install git+"$github_proxy"https://github.com/openai/CLIP.git --prefer-binary $python_proxy $force_pip
  pip install git+"$github_proxy"https://github.com/mlfoundations/open_clip.git --prefer-binary $python_proxy $force_pip

  cd ./stable-diffusion-webui
  pip install -r requirements.txt  --prefer-binary $python_proxy $force_pip #安装stable-diffusion-webui的依赖
  cd ..
  
  sed -i -e 's/\"sd_model_checkpoint\"\,/\"sd_model_checkpoint\,sd_vae\,CLIP_stop_at_last_layers\"\,/g' ./stable-diffusion-webui/modules/shared.py
  #sed -i -e 's/\"sd_model_checkpoint\"\,/\"sd_model_checkpoint\,sd_vae\,CLIP_stop_at_last_layers\,cross_attention_optimization\,token_merging_ratio\,token_merging_ratio_img2img\,token_merging_ratio_hr\,show_progress_type\"\,/g' ./stable-diffusion-webui/modules/shared.py
  git clone "$github_proxy"$extension_1 ./stable-diffusion-webui/extensions/kohya-config-webui
  git clone "$github_proxy"$extension_2 ./stable-diffusion-webui/extensions/sd-webui-additional-networks
  git clone "$github_proxy"$extension_3 ./stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
  git clone "$github_proxy"$extension_4 ./stable-diffusion-webui/extensions/multidiffusion-upscaler-for-automatic1111
  git clone "$github_proxy"$extension_5 ./stable-diffusion-webui/extensions/sd-dynamic-thresholding
  git clone "$github_proxy"$extension_6 ./stable-diffusion-webui/extensions/sd-webui-cutoff
  git clone "$github_proxy"$extension_7 ./stable-diffusion-webui/extensions/sd-webui-model-converter
  git clone "$github_proxy"$extension_8 ./stable-diffusion-webui/extensions/sd-webui-supermerger
  git clone "$github_proxy"$extension_9 ./stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_CN
  git clone "$github_proxy"$extension_10 ./stable-diffusion-webui/extensions/stable-diffusion-webui-wd14-tagger
  git clone "$github_proxy"$extension_11 ./stable-diffusion-webui/extensions/sd-webui-regional-prompter
  git clone "$github_proxy"$extension_12 ./stable-diffusion-webui/extensions/stable-diffusion-webui-baidu-netdisk
  git clone "$github_proxy"$extension_13 ./stable-diffusion-webui/extensions/stable-diffusion-webui-anti-burn
  git clone "$github_proxy"$extension_14 ./stable-diffusion-webui/extensions/loopback_scaler
  git clone "$github_proxy"$extension_15 ./stable-diffusion-webui/extensions/latentcoupleregionmapper
  git clone "$github_proxy"$extension_16 ./stable-diffusion-webui/extensions/ultimate-upscale-for-automatic1111
  git clone "$github_proxy"$extension_17 ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
  git clone "$github_proxy"$extension_18 ./stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
  git clone "$github_proxy"$extension_19 ./stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
  git clone "$github_proxy"$extension_20 ./stable-diffusion-webui/extensions/sd-civitai-browser
  git clone "$github_proxy"$extension_21 ./stable-diffusion-webui/extensions/sd-webui-additional-networks
  git clone "$github_proxy"$extension_22 ./stable-diffusion-webui/extensions/openpose-editor
  git clone "$github_proxy"$extension_23 ./stable-diffusion-webui/extensions/sd-webui-depth-lib
  git clone "$github_proxy"$extension_24 ./stable-diffusion-webui/extensions/posex
  git clone "$github_proxy"$extension_25 ./stable-diffusion-webui/extensions/sd-webui-tunnels
  git clone "$github_proxy"$extension_26 ./stable-diffusion-webui/extensions/batchlinks-webui
  git clone "$github_proxy"$extension_27 ./stable-diffusion-webui/extensions/stable-diffusion-webui-catppuccin
  git clone "$github_proxy"$extension_28 ./stable-diffusion-webui/extensions/a1111-sd-webui-locon
  git clone "$github_proxy"$extension_29 ./stable-diffusion-webui/extensions/stable-diffusion-webui-rembg
  git clone "$github_proxy"$extension_30 ./stable-diffusion-webui/extensions/stable-diffusion-webui-two-shot
  git clone "$github_proxy"$extension_31 ./stable-diffusion-webui/extensions/sd-webui-lora-block-weight
  git clone "$github_proxy"$extension_32 ./stable-diffusion-webui/extensions/sd-face-editor
  git clone "$github_proxy"$extension_33 ./stable-diffusion-webui/extensions/sd-webui-segment-anything
  git clone "$github_proxy"$extension_34 ./stable-diffusion-webui/extensions/sd-webui-controlnet
  aria2c https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt -d ./stable-diffusion-webui/models/Stable-diffusion -o sd-v1-4.ckpt
  aria2c https://huggingface.co/embed/upscale/resolve/main/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
  git clone https://huggingface.co/embed/negative ./stable-diffusion-webui/embeddings/negative
  git clone https://huggingface.co/embed/lora ./stable-diffusion-webui/models/Lora/positive

 if [ "$extension_34" = "https://github.com/Mikubill/sd-webui-controlnet" ]; then #安装controlnet时再下载相关模型
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
  aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth
  fi
  exit_venv
}



#comfyui安装处理部分
function process_install_comfyui()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择

    #开始安装comfyui
    echo "开始安装comfyui"
    git clone "$github_proxy"https://github.com/comfyanonymous/ComfyUI.git
    cd ./ComfyUI
    venv_generate
    enter_venv
    cd ..
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip
    cd ./ComfyUI
    pip install -r requirements.txt  --prefer-binary $python_proxy $force_pip
    cd ..
    aria2c https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt -d ./ComfyUI/models/checkpoints/ -o sd-v1-4.ckpt
    exit_venv
}


#invokeai安装处理部分
function process_install_invokeai()
{
    #安装前准备
    proxy_option
    pip_install_methon=$(dialog --clear --title "pip安装模式选择" --yes-label "确认" --no-cancel --menu "选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装为InvokeAI官方推荐安装方式,但速度较慢" 20 60 10 \
	  "1" "常规安装(setup.py)" \
	  "2" "标准构建安装(--use-pep517)" \
	  3>&1 1>&2 2>&3 )
	    if [ $pip_install_methon = "1" ];then
		    echo "使用常规安装"
        pip_install_methon_select=""
	    else
		    echo "使用标准构建安装"
        pip_install_methon_select="--use-pep517"
	    fi

    #开始安装invokeai
    echo "开始安装invokeai"
    mkdir InvokeAI
    cd ./InvokeAI
    venv_generate
    enter_venv
    pip install invokeai $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select
    exit_venv
}

#lora-scipts安装处理部分
function process_install_lora_scripts()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择

    #参考lora-scripts里的install.bash写的
    echo "开始安装lora-scipts"
    git clone "$github_proxy"https://github.com/Akegarasu/lora-scripts.git
    git clone "$github_proxy"https://github.com/kohya-ss/sd-scripts.git ./lora-scripts/sd-scripts
    git clone "$github_proxy"https://github.com/hanamizuki-ai/lora-gui-dist ./lora-scripts/frontend
    cd ./lora-scripts
    venv_generate
    enter_venv
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip
    cd ./sd-scripts
    pip install $python_proxy $extra_python_proxy $force_pip --upgrade -r requirements.txt
    cd ..
    pip install --upgrade $python_proxy $extra_python_proxy $force_pip lion-pytorch lycoris-lora dadaptation fastapi uvicorn wandb
    aria2c https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt -d ./sd-models/ -o model.ckpt
    exit_venv
}


#选择重新安装pytorch
function pytorch_reinstall()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择

    #开始安装pytorch
    venv_generate
    enter_venv
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip
}

#################################################

#插件管理部分(目前只有a1111-sd-webui用到)

#插件的安装或管理选项(该部分最先被调用)
function extension_methon()
{

#功能选择界面
final_extension_methon=$(
		dialog --clear --title "插件管理" --menu "请使用方向键和回车键进行操作" 20 60 10 \
			"1" "安装" \
			"2" "管理" \
			"3" "返回" \
			3>&1 1>&2 2>&3 )


            if [ "${final_extension_methon}" == '1' ]; then #选择安装
            extension_install
            elif [ "${final_extension_methon}" == '2' ]; then #选择管理
            extension_manager
            elif [ "${final_extension_methon}" == '3' ]; then #选择返回
            mainmenu
            else #选择dialog下面的取消按钮
            mainmenu
            fi
            extension_methon
}



#插件管理界面
function extension_manager()
{
        cd $start_path/stable-diffusion-webui/extensions #回到原来的插件目录
        dir_list=$(ls -l  | awk -F ' ' ' { print $9 " " $6 $7 } ') #当前目录文件和文件夹信息

        extension_selection=$(dialog --clear --title "插件管理" \
                          --menu "使用上下键选择要操作的插件并回车确认" 20 60 10 \
                           $dir_list \
                           3>&1 1>&2 2>&3)

        if [[ -d "$extension_selection" ]]; then  # 选择文件夹
            cd $extension_selection
            operate_extension #调用operate_extension函数处理插件
        elif [[ -f "$extension_selection" ]]; then
            extension_manager #留在当前目录
        else
            extension_methon #返回功能选择界面
        fi
            extension_methon
}


#插件安装模块
function extension_install()
{
    extension_address=$(dialog --clear --title "插件安装" --inputbox "输入插件的github或其他下载地址" 10 60 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        git clone $extension_address
    else
        extension_methon
    fi
}

#插件处理模块
function operate_extension() 
{
	final_operate_extension=$(
		dialog --clear --title "操作选择" --menu "请使用方向键和回车键选择对该插件进行的操作" 20 60 10 \
			"1" "更新" \
			"2" "卸载" \
			"3" "修复" \
      "4" "版本切换" \
			"0" "返回" \
			3>&1 1>&2 2>&3
	)

	if [ "${final_operate_extension}" == '1' ]; then
        echo "更新"$extension_selection"中"
        git pull
        echo "更新完毕"
	elif [ "${final_operate_extension}" == '2' ]; then
      if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除该插件" 20 60) then
        echo "删除"$extension_selection"插件中"
        cd ..
        rm -rfv ./$extension_selection
      fi
	elif [ "${final_operate_extension}" == '3' ]; then
		    echo "将工作区、暂存取和HEAD保持一致"
        git reset --hard HEAD
	elif [ "${final_operate_extension}" == '4' ]; then
	    	echo "运行版本切换模块"
        git_checkout_manager
	elif [ "${final_operate_extension}" == '0' ]; then
        echo 
    fi
}

#版本切换模块
function git_checkout_manager()
{
    commit_lists=$(git log --date=short --pretty=format:"%H %cd" | awk -F  ' ' ' {print $1 " " $2} ')

    commit_selection=$(dialog --clear --title "版本管理" \
                          --menu "使用上下键选择要切换的版本并回车确认" 20 60 10 \
                           $commit_lists \
                           3>&1 1>&2 2>&3)

    if [ "$?" = "0" ];then
    git checkout $commit_selection 
    echo 切换到"$commit_selection"版本
    fi
}



##########################################################

#启动程序部分

#显示版本信息
function term_sd_version()
{
  if [ $(uname -o) = "Msys" ];then #为了兼容windows系统

dialog --clear --title "版本信息" --msgbox "系统:$(uname -o) \n
Term-SD:0.1.2 \n
python:$(python --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
pip:$(pip --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
aria2:$(aria2c --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
git:$(git --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
dialog:$(dialog --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
\n
提示: \n
使用方向键、Tab键、Enter进行选择，Space键勾选或取消选项 \n
Ctrl+C可中断指令的运行 \n
第一次使用Term-SD时先在主界面选择“关于”查看使用说明" 20 60

  else

    dialog --clear --title "版本信息" --msgbox "系统:$(uname -o) \n
Term-SD:0.1.2 \n
python3:$(python --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
pip:$(pip --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
aria2:$(aria2c --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
git:$(git --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
dialog:$(dialog --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
\n
提示: \n
使用方向键、Tab键、Enter进行选择，Space键勾选或取消选项 \n
Ctrl+C可中断指令的运行 \n
第一次使用Term-SD时先在主界面选择“关于”查看使用说明" 20 60

  fi
  mainmenu
}
#判断系统是否安装必须使用的软件


if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
echo "检测依赖软件是否安装"
if which dialog > /dev/null ;then
  echo "系统已安装dialog"
  if which aria2c > /dev/null ;then
    echo "系统已安装aria2"
    if which python > /dev/null;then
      echo "系统已安装python"
      if which git > /dev/null;then
        echo "系统已安装git"
        if which pip > /dev/null;then
          echo "系统已安装pip"
          echo "Term-SD初始化完成"
	        echo "启动Term-SD中......"
          term_sd_version
        else
          echo "未安装pip,请安装后重试"
          exit
        fi
      else 
        echo "未安装git,请安装后重试"
        exit
      fi
    else
      echo "未安装python,请安装后重试"
      exit
    fi
  else
    echo "未安装aria2,请安装后重试"
    exit
  fi
else
  echo "未安装dialog,请安装后重试"
  exit
fi
else
echo "检测依赖软件是否安装"
if which dialog > /dev/null ;then
  echo "系统已安装dialog"
  if which aria2c > /dev/null ;then
    echo "系统已安装aria2"
    if which python3 > /dev/null;then
      echo "系统已安装python"
      if which git > /dev/null;then
        echo "系统已安装git"
        if which pip > /dev/null;then
          echo "系统已安装pip"
          echo "Term-SD初始化完成"
	        echo "启动Term-SD中......"
          term_sd_version
        else
          echo "未安装pip,请安装后重试"
          exit
        fi
      else 
        echo "未安装git,请安装后重试"
        exit
      fi
    else
      echo "未安装python,请安装后重试"
      exit
    fi
  else
    echo "未安装aria2,请安装后重试"
    exit
  fi
else
  echo "未安装dialog,请安装后重试"
  exit
fi
fi