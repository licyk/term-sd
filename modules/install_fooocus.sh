#!/bin/bash

# Fooocus安装
install_fooocus()
{
    local install_cmd
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/fooocus_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/fooocus_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "Fooocus 安装"
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "Fooocus安装进度:[$cmd_point/$cmd_sum]"
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/fooocus_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))

            if [ -z "$(echo "$(cat "$start_path/term-sd/task/fooocus_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                term_sd_exec_cmd # 执行命令
            else
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                true
            fi

            if [ $? = 0 ];then
                term_sd_task_cmd_revise "$start_path/term-sd/task/fooocus_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
            else
                if [ $term_sd_install_mode = 0 ];then
                    term_sd_echo "安装命令执行失败,终止安装程序"
                    term_sd_tmp_enable_proxy # 恢复代理
                    term_sd_pause
                    dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus安装结果" --ok-label "确认" --msgbox "Fooocus安装进程执行失败,请重试" $term_sd_dialog_height $term_sd_dialog_width
                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "Fooocus安装结束"
        rm -f "$start_path/term-sd/task/fooocus_install.sh" # 删除任务文件
        rm -f "$start_path/term-sd/task/cache.sh"
        term_sd_print_line
        dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus安装结果" --ok-label "确认" --msgbox "Fooocus安装结束,选择确定进入管理界面" $term_sd_dialog_height $term_sd_dialog_width
        fooocus_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否安装Fooocus?" # 安装确认
        if [ $? = 0 ];then
            term_sd_print_line "Fooocus 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/fooocus_install.sh" # 环境变量
            cat "$start_path/term-sd/install/fooocus/fooocus_core.sh" >> "$start_path/term-sd/task/fooocus_install.sh" # 核心组件
            echo "" >> "$start_path/term-sd/task/fooocus_install.sh"
            if [ $use_modelscope_model = 1 ];then
                cat "$start_path/term-sd/install/fooocus/fooocus_hf_model.sh" >> "$start_path/term-sd/task/fooocus_install.sh" # 模型
            else
                cat "$start_path/term-sd/install/fooocus/fooocus_ms_model.sh" >> "$start_path/term-sd/task/fooocus_install.sh" # 模型
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装Fooocus"

            cmd_sum=$(( $(cat "$start_path/term-sd/task/fooocus_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
            do
                term_sd_echo "Fooocus安装进度:[$cmd_point/$cmd_sum]"
                install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/fooocus_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))
                
                if [ -z "$(echo "$(cat "$start_path/term-sd/task/fooocus_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                    echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                    term_sd_exec_cmd # 执行命令
                else
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                    true
                fi

                if [ $? = 0 ];then
                    term_sd_task_cmd_revise "$start_path/term-sd/task/fooocus_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
                else
                    if [ $term_sd_install_mode = 0 ];then
                        term_sd_echo "安装命令执行失败,终止安装程序"
                        term_sd_tmp_enable_proxy # 恢复代理
                        term_sd_pause
                        dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus安装结果" --ok-label "确认" --msgbox "Fooocus安装进程执行失败,请重试" $term_sd_dialog_height $term_sd_dialog_width
                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "Fooocus安装结束"
            rm -f "$start_path/term-sd/task/fooocus_install.sh" # 删除任务文件
            rm -f "$start_path/term-sd/task/cache.sh"
            term_sd_print_line
            dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus安装结果" --ok-label "确认" --msgbox "Fooocus安装结束,选择确定进入管理界面" $term_sd_dialog_height $term_sd_dialog_width
            fooocus_manager # 进入管理界面
        fi
    fi
}

# fooocus翻译配置文件
# 翻译来源:https://github.com/lllyasviel/Fooocus/issues/757
fooocus_lang_config_file()
{
    cat<<EOF
{
    "Preview": "预览",
    "Gallery": "相册",
    "Generate": "生成",
    "Skip": "跳过",
    "Stop": "停止",
    "Input Image": "图生图",
    "Advanced": "高级设置",
    "Upscale or Variation": "放大或重绘",
    "Image Prompt": "参考图",
    "Inpaint or Outpaint (beta)": "内部重绘或外部扩展（测试版）",
    "Drag above image to here": "将图像拖到这里",
    "Upscale or Variation:": "放大或重绘：",
    "Disabled": "禁用",
    "Vary (Subtle)": "变化（微妙）",
    "Vary (Strong)": "变化（强烈）",
    "Upscale (1.5x)": "放大（1.5倍）",
    "Upscale (2x)": "放大（2倍）",
    "Upscale (Fast 2x)": "快速放大（2倍）",
    "\ud83d\udcd4 Document": "\uD83D\uDCD4 说明文档",
    "Image": "图像",
    "Stop At": "停止于",
    "Weight": "权重",
    "Type": "类型",
    "PyraCanny": "边缘检测",
    "CPDS": "深度结构检测",
    "* \"Image Prompt\" is powered by Fooocus Image Mixture Engine (v1.0.1).": "* \"图生图\"由 Fooocus 图像混合引擎提供支持（v1.0.1）。",
    "The scaler multiplied to positive ADM (use 1.0 to disable).": "正向 ADM 的缩放倍数（使用 1.0 禁用）。",
    "The scaler multiplied to negative ADM (use 1.0 to disable).": "反向 ADM 的缩放倍数（使用 1.0 禁用）。",
    "When to end the guidance from positive/negative ADM.": "何时结束来自正向/反向 ADM 的指导。",
    "Similar to the Control Mode in A1111 (use 0.0 to disable).": "类似于SD WebUI中的控制模式（使用 0.0 禁用）。",
    "Outpaint Expansion (": "外部扩展 (",
    "Outpaint": "外部重绘",
    "Left": "向左扩展",
    "Right": "向右扩展",
    "Top": "向上扩展",
    "Bottom": "向下扩展",
    "* \"Inpaint or Outpaint\" is powered by the sampler \"DPMPP Fooocus Seamless 2M SDE Karras Inpaint Sampler\" (beta)": "* \"内部填充或外部填充\"由 \"DPMPP Fooocus Seamless 2M SDE Karras Inpaint Sampler\"（测试版）采样器提供支持",
    "Setting": "设置",
    "Style": "样式",
    "Performance": "性能",
    "Speed": "速度",
    "Quality": "质量",
    "Aspect Ratios": "宽高比",
    "896\u00d71152": "896\u00d71152",
    "width \u00d7 height": "宽 \u00d7 高",
    "704\u00d71408": "704\u00d71408",
    "704\u00d71344": "704\u00d71344",
    "768\u00d71344": "768\u00d71344",
    "768\u00d71280": "768\u00d71280",
    "832\u00d71216": "832\u00d71216",
    "832\u00d71152": "832\u00d71152",
    "896\u00d71088": "896\u00d71088",
    "960\u00d71088": "960\u00d71088",
    "960\u00d71024": "960\u00d71024",
    "1024\u00d71024": "1024\u00d71024",
    "1024\u00d7960": "1024\u00d7960",
    "1088\u00d7960": "1088\u00d7960",
    "1088\u00d7896": "1088\u00d7896",
    "1152\u00d7832": "1152\u00d7832",
    "1216\u00d7832": "1216\u00d7832",
    "1280\u00d7768": "1280\u00d7768",
    "1344\u00d7768": "1344\u00d7768",
    "1344\u00d7704": "1344\u00d7704",
    "1408\u00d7704": "1408\u00d7704",
    "1472\u00d7704": "1472\u00d7704",
    "1536\u00d7640": "1536\u00d7640",
    "1600\u00d7640": "1600\u00d7640",
    "1664\u00d7576": "1664\u00d7576",
    "1728\u00d7576": "1728\u00d7576",
    "Image Number": "出图数量",
    "Negative Prompt": "反向提示词",
    "Describing what you do not want to see.": "描述你不想看到的内容。",
    "Random": "随机种子",
    "Seed": "种子",
    "\ud83d\udcda History Log": "\ud83D\uDCDA 历史记录",
    "Image Style": "图像风格",
    "Fooocus V2": "Fooocus V2",
    "Default (Slightly Cinematic)": "默认（轻微的电影感）",
    "Fooocus Masterpiece": "Fooocus-杰作",
    "Fooocus Photograph": "Fooocus-照片",
    "Fooocus Negative": "Fooocus-反向提示词",
    "SAI 3D Model": "SAI-3D模型",
    "SAI Analog Film": "SAI-模拟电影",
    "SAI Anime": "SAI-动漫",
    "SAI Cinematic": "SAI-电影片段",
    "SAI Comic Book": "SAI-漫画",
    "SAI Craft Clay": "SAI-工艺粘土",
    "SAI Digital Art": "SAI-数字艺术",
    "SAI Enhance": "SAI-增强",
    "SAI Fantasy Art": "SAI-奇幻艺术",
    "SAI Isometric": "SAI-等距风格",
    "SAI Line Art": "SAI-线条艺术",
    "SAI Lowpoly": "SAI-低多边形",
    "SAI Neonpunk": "SAI-霓虹朋克",
    "SAI Origami": "SAI-折纸",
    "SAI Photographic": "SAI-摄影",
    "SAI Pixel Art": "SAI-像素艺术",
    "SAI Texture": "SAI-纹理",
    "MRE Cinematic Dynamic": "MRE-史诗电影",
    "MRE Spontaneous Picture": "MRE-自发图片",
    "MRE Artistic Vision": "MRE-艺术视觉",
    "MRE Dark Dream": "MRE-黑暗梦境",
    "MRE Gloomy Art": "MRE-阴郁艺术",
    "MRE Bad Dream": "MRE-噩梦",
    "MRE Underground": "MRE-阴森地下",
    "MRE Surreal Painting": "MRE-超现实主义绘画",
    "MRE Dynamic Illustration": "MRE-动态插画",
    "MRE Undead Art": "MRE-遗忘艺术家作品",
    "MRE Elemental Art": "MRE-元素艺术",
    "MRE Space Art": "MRE-空间艺术",
    "MRE Ancient Illustration": "MRE-古代插图",
    "MRE Brave Art": "MRE-勇敢艺术",
    "MRE Heroic Fantasy": "MRE-英雄幻想",
    "MRE Dark Cyberpunk": "MRE-黑暗赛博朋克",
    "MRE Lyrical Geometry": "MRE-抒情几何抽象画",
    "MRE Sumi E Symbolic": "MRE-墨绘长笔画",
    "MRE Sumi E Detailed": "MRE-精细墨绘画",
    "MRE Manga": "MRE-日本漫画",
    "MRE Anime": "MRE-日本动画片",
    "MRE Comic": "MRE-成人漫画书插画",
    "Ads Advertising": "广告-广告",
    "Ads Automotive": "广告-汽车",
    "Ads Corporate": "广告-企业品牌",
    "Ads Fashion Editorial": "广告-时尚编辑",
    "Ads Food Photography": "广告-美食摄影",
    "Ads Gourmet Food Photography": "广告-美食摄影",
    "Ads Luxury": "广告-奢侈品",
    "Ads Real Estate": "广告-房地产",
    "Ads Retail": "广告-零售",
    "Artstyle Abstract": "艺术风格-抽象",
    "Artstyle Abstract Expressionism": "艺术风格-抽象表现主义",
    "Artstyle Art Deco": "艺术风格-装饰艺术",
    "Artstyle Art Nouveau": "艺术风格-新艺术",
    "Artstyle Constructivist": "艺术风格-构造主义",
    "Artstyle Cubist": "艺术风格-立体主义",
    "Artstyle Expressionist": "艺术风格-表现主义",
    "Artstyle Graffiti": "艺术风格-涂鸦",
    "Artstyle Hyperrealism": "艺术风格-超写实主义",
    "Artstyle Impressionist": "艺术风格-印象派",
    "Artstyle Pointillism": "艺术风格-点彩派",
    "Artstyle Pop Art": "艺术风格-波普艺术",
    "Artstyle Psychedelic": "艺术风格-迷幻",
    "Artstyle Renaissance": "艺术风格-文艺复兴",
    "Artstyle Steampunk": "艺术风格-蒸汽朋克",
    "Artstyle Surrealist": "艺术风格-超现实主义",
    "Artstyle Typography": "艺术风格-字体设计",
    "Artstyle Watercolor": "艺术风格-水彩",
    "Futuristic Biomechanical": "未来主义-生物机械",
    "Futuristic Biomechanical Cyberpunk": "未来主义-生物机械-赛博朋克",
    "Futuristic Cybernetic": "未来主义-人机融合",
    "Futuristic Cybernetic Robot": "未来主义-人机融合-机器人",
    "Futuristic Cyberpunk Cityscape": "未来主义-赛博朋克城市",
    "Futuristic Futuristic": "未来主义-未来主义",
    "Futuristic Retro Cyberpunk": "未来主义-复古赛博朋克",
    "Futuristic Retro Futurism": "未来主义-复古未来主义",
    "Futuristic Sci Fi": "未来主义-科幻",
    "Futuristic Vaporwave": "未来主义-蒸汽波",
    "Game Bubble Bobble": "游戏-泡泡龙",
    "Game Cyberpunk Game": "游戏-赛博朋克游戏",
    "Game Fighting Game": "游戏-格斗游戏",
    "Game Gta": "游戏-侠盗猎车手",
    "Game Mario": "游戏-马里奥",
    "Game Minecraft": "游戏-我的世界",
    "Game Pokemon": "游戏-宝可梦",
    "Game Retro Arcade": "游戏-复古街机",
    "Game Retro Game": "游戏-复古游戏",
    "Game Rpg Fantasy Game": "游戏-角色扮演幻想游戏",
    "Game Strategy Game": "游戏-策略游戏",
    "Game Streetfighter": "游戏-街头霸王",
    "Game Zelda": "游戏-塞尔达传说",
    "Misc Architectural": "其他-建筑",
    "Misc Disco": "其他-迪斯科",
    "Misc Dreamscape": "其他-梦境",
    "Misc Dystopian": "其他-反乌托邦",
    "Misc Fairy Tale": "其他-童话故事",
    "Misc Gothic": "其他-哥特风",
    "Misc Grunge": "其他-垮掉的",
    "Misc Horror": "其他-恐怖",
    "Misc Kawaii": "其他-可爱",
    "Misc Lovecraftian": "其他-洛夫克拉夫特",
    "Misc Macabre": "其他-恐怖",
    "Misc Manga": "其他-漫画",
    "Misc Metropolis": "其他-大都市",
    "Misc Minimalist": "其他-极简主义",
    "Misc Monochrome": "其他-单色",
    "Misc Nautical": "其他-航海",
    "Misc Space": "其他-太空",
    "Misc Stained Glass": "其他-彩色玻璃",
    "Misc Techwear Fashion": "其他-科技时尚",
    "Misc Tribal": "其他-部落",
    "Misc Zentangle": "其他-禅绕画",
    "Papercraft Collage": "手工艺-拼贴",
    "Papercraft Flat Papercut": "手工艺-平面剪纸",
    "Papercraft Kirigami": "手工艺-切纸",
    "Papercraft Paper Mache": "手工艺-纸浆塑造",
    "Papercraft Paper Quilling": "手工艺-纸艺卷轴",
    "Papercraft Papercut Collage": "手工艺-剪纸拼贴",
    "Papercraft Papercut Shadow Box": "手工艺-剪纸影箱",
    "Papercraft Stacked Papercut": "手工艺-层叠剪纸",
    "Papercraft Thick Layered Papercut": "手工艺-厚层剪纸",
    "Photo Alien": "摄影-外星人",
    "Photo Film Noir": "摄影-黑色电影",
    "Photo Glamour": "摄影-魅力",
    "Photo Hdr": "摄影-高动态范围",
    "Photo Iphone Photographic": "摄影-苹果手机摄影",
    "Photo Long Exposure": "摄影-长曝光",
    "Photo Neon Noir": "摄影-霓虹黑色",
    "Photo Silhouette": "摄影-轮廓",
    "Photo Tilt Shift": "摄影-移轴",
    "Cinematic Diva": "电影女主角",
    "Abstract Expressionism": "抽象表现主义",
    "Academia": "学术",
    "Action Figure": "动作人偶",
    "Adorable 3D Character": "可爱的3D角色",
    "Adorable Kawaii": "可爱的卡哇伊",
    "Art Deco": "装饰艺术",
    "Art Nouveau": "新艺术，美丽艺术",
    "Astral Aura": "星体光环",
    "Avant Garde": "前卫",
    "Baroque": "巴洛克",
    "Bauhaus Style Poster": "包豪斯风格海报",
    "Blueprint Schematic Drawing": "蓝图示意图",
    "Caricature": "漫画",
    "Cel Shaded Art": "卡通渲染",
    "Character Design Sheet": "角色设计表",
    "Classicism Art": "古典主义艺术",
    "Color Field Painting": "色彩领域绘画",
    "Colored Pencil Art": "彩色铅笔艺术",
    "Conceptual Art": "概念艺术",
    "Constructivism": "建构主义",
    "Cubism": "立体主义",
    "Dadaism": "达达主义",
    "Dark Fantasy": "黑暗奇幻",
    "Dark Moody Atmosphere": "黑暗忧郁气氛",
    "Dmt Art Style": "迷幻艺术风格",
    "Doodle Art": "涂鸦艺术",
    "Double Exposure": "双重曝光",
    "Dripping Paint Splatter Art": "滴漆飞溅艺术",
    "Expressionism": "表现主义",
    "Faded Polaroid Photo": "褪色的宝丽来照片",
    "Fauvism": "野兽派",
    "Flat 2d Art": "平面 2D 艺术",
    "Fortnite Art Style": "堡垒之夜艺术风格",
    "Futurism": "未来派",
    "Glitchcore": "故障核心",
    "Glo Fi": "光明高保真",
    "Googie Art Style": "古吉艺术风格",
    "Graffiti Art": "涂鸦艺术",
    "Harlem Renaissance Art": "哈莱姆文艺复兴艺术",
    "High Fashion": "高级时装",
    "Idyllic": "田园诗般",
    "Impressionism": "印象派",
    "Infographic Drawing": "信息图表绘图",
    "Ink Dripping Drawing": "滴墨绘画",
    "Japanese Ink Drawing": "日式水墨画",
    "Knolling Photography": "规律摆放摄影",
    "Light Cheery Atmosphere": "轻松愉快的气氛",
    "Logo Design": "标志设计",
    "Luxurious Elegance": "奢华优雅",
    "Macro Photography": "微距摄影",
    "Mandola Art": "曼陀罗艺术",
    "Marker Drawing": "马克笔绘图",
    "Medievalism": "中世纪主义",
    "Minimalism": "极简主义",
    "Neo Baroque": "新巴洛克",
    "Neo Byzantine": "新拜占庭",
    "Neo Futurism": "新未来派",
    "Neo Impressionism": "新印象派",
    "Neo Rococo": "新洛可可",
    "Neoclassicism": "新古典主义",
    "Op Art": "欧普艺术",
    "Ornate And Intricate": "华丽而复杂",
    "Pencil Sketch Drawing": "铅笔素描",
    "Pop Art 2": "流行艺术2",
    "Rococo": "洛可可",
    "Silhouette Art": "剪影艺术",
    "Simple Vector Art": "简单矢量艺术",
    "Sketchup": "草图",
    "Steampunk 2": "赛博朋克2",
    "Surrealism": "超现实主义",
    "Suprematism": "至上主义",
    "Terragen": "地表风景",
    "Tranquil Relaxing Atmosphere": "宁静轻松的氛围",
    "Sticker Designs": "贴纸设计",
    "Vibrant Rim Light": "生动的边缘光",
    "Volumetric Lighting": "体积照明",
    "Watercolor 2": "水彩2",
    "Whimsical And Playful": "异想天开、俏皮",
    "Model": "模型",
    "Base Model (SDXL only)": "基础模型（只支持SDXL）",
    "sd_xl_base_1.0_0.9vae.safetensors": "基础模型 sd_xl_base_1.0_0.9vae",
    "bluePencilXL_v009.safetensors": "动漫模型 bluePencilXL_v009",
    "bluePencilXL_v050.safetensors": "动漫模型 bluePencilXL_v050",
    "DreamShaper_8_pruned.safetensors": "2.5D模型 DreamShaper_8_pruned",
    "realisticStockPhoto_v10.safetensors": "现实模型 realisticStockPhoto_v10",
    "realisticVisionV51_v51VAE.safetensors": "现实模型 realisticVisionV51_v51VAE",
    "sd_xl_refiner_1.0_0.9vae.safetensors": "精修模型 sd_xl_refiner_1.0_0.9vae",
    "Refiner (SDXL or SD 1.5)": "精修模型 （支持SDXL 或 SD 1.5）",
    "None": "无",
    "LoRAs": "LoRAs模型",
    "SDXL LoRA 1": "SDXL LoRA 1",
    "sd_xl_offset_example-lora_1.0.safetensors": "sd_xl_offset_example-lora_1.0 官方示例lora",
    "3d_render_style_xl.safetensors": "3d_render_style_xl 3D渲染风格模型",
    "Bloodstained-XL-V1.safetensors": "Bloodstained-XL-V1 血色污染模型",
    "SDXL_FILM_PHOTOGRAPHY_STYLE_BetaV0.4.safetensors": "SDXL_FILM_PHOTOGRAPHY_STYLE_BetaV0.4 电影剧照模型",
    "SDXL LoRA 2": "SDXL LoRA 2",
    "SDXL LoRA 3": "SDXL LoRA 3",
    "SDXL LoRA 4": "SDXL LoRA 4",
    "SDXL LoRA 5": "SDXL LoRA 5",
    "Refresh": "Refresh",
    "\ud83d\udd04 Refresh All Files": "\ud83d\udd04 刷新全部文件",
    "Sampling Sharpness": "采样清晰度",
    "Higher value means image and texture are sharper.": "值越大，图像和纹理越清晰。",
    "Guidance Scale": "提示词引导系数",
    "Higher value means style is cleaner, vivider, and more artistic.": "提示词作用的强度，值越大，风格越干净、生动、更具艺术感。",
    "Developer Debug Mode": "开发者调试模式",
    "Developer Debug Tools": "开发者调试工具",
    "Positive ADM Guidance Scaler": "正向ADM引导系数",
    "The scaler multiplied to positive ADM (use 1.0 to disable). ": "正向ADM引导的倍率 （使用1.0以禁用）。 ",
    "Negative ADM Guidance Scaler": "负向ADM引导系数",
    "The scaler multiplied to negative ADM (use 1.0 to disable). ": "负向ADM引导的倍率（使用1.0以禁用）。 ",
    "ADM Guidance End At Step": "ADM引导结束步长",
    "When to end the guidance from positive/negative ADM. ": "正向/负向ADM结束引导的时间。 ",
    "Refiner swap method": "Refiner精炼模型交换方式",
    "joint": "joint联合",
    "separate": "separate分离",
    "vae": "vae变分自编码器",
    "CFG Mimicking from TSNR": "从TSNR模拟CFG",
    "Enabling Fooocus's implementation of CFG mimicking for TSNR (effective when real CFG > mimicked CFG).": "启用Fooocus的TSNR模拟CFG的功能（当真实的CFG大于模拟的CFG时生效）。",
    "Sampler": "采样器",
    "dpmpp_2m_sde_gpu": "dpmpp_2m_sde_gpu",
    "Only effective in non-inpaint mode.": "仅在非重绘模式下有效。",
    "euler": "euler",
    "euler_ancestral": "euler_ancestral",
    "heun": "heun",
    "dpm_2": "dpm_2",
    "dpm_2_ancestral": "dpm_2_ancestral",
    "lms": "lms",
    "dpm_fast": "dpm_fast",
    "dpm_adaptive": "dpm_adaptive",
    "dpmpp_2s_ancestral": "dpmpp_2s_ancestral",
    "dpmpp_sde": "dpmpp_sde",
    "dpmpp_sde_gpu": "dpmpp_sde_gpu",
    "dpmpp_2m": "dpmpp_2m",
    "dpmpp_2m_sde": "dpmpp_2m_sde",
    "dpmpp_3m_sde": "dpmpp_3m_sde",
    "dpmpp_3m_sde_gpu": "dpmpp_3m_sde_gpu",
    "ddpm": "ddpm",
    "ddim": "ddim",
    "uni_pc": "uni_pc",
    "uni_pc_bh2": "uni_pc_bh2",
    "Scheduler": "调度器",
    "karras": "karras",
    "Scheduler of Sampler.": "采样器的调度器。",
    "normal": "normal",
    "exponential": "exponential",
    "sgm_uniform": "sgm_uniform",
    "simple": "simple",
    "ddim_uniform": "ddim_uniform",
    "Forced Overwrite of Sampling Step": "强制覆盖采样步长",
    "Set as -1 to disable. For developer debugging.": "设为-1以禁用。用于开发者调试。",
    "Forced Overwrite of Refiner Switch Step": "强制重写精炼器开关步数",
    "Forced Overwrite of Generating Width": "强制覆盖生成宽度",
    "Set as -1 to disable. For developer debugging. Results will be worse for non-standard numbers that SDXL is not trained on.": "设为-1以禁用。用于开发者调试。对于SDXL没有训练过的非标准数字，结果会差。",
    "Forced Overwrite of Generating Height": "强制覆盖生成高度",
    "Forced Overwrite of Denoising Strength of \"Vary\"": "强制覆盖 \"变化\"的去噪强度",
    "Set as negative number to disable. For developer debugging.": "设为负数以禁用。用于开发者调试。",
    "Forced Overwrite of Denoising Strength of \"Upscale\"": "强制覆盖 \"放大\"去噪强度",
    "Inpaint Engine": "Inpaint 重绘引擎",
    "v1": "v1",
    "Version of Fooocus inpaint model": "inpaint 重绘模型的版本选择",
    "v2.5": "v2.5",
    "Control Debug": "控制调试",
    "Debug Preprocessors": "调试预处理器",
    "Mixing Image Prompt and Vary/Upscale": "混合图生图和变化/放大",
    "Mixing Image Prompt and Inpaint": "混合图生图和重绘",
    "Softness of ControlNet": "ControlNet柔和度",
    "Similar to the Control Mode in A1111 (use 0.0 to disable). ": "类似于SD WebUI中的控制模式（使用0.0来禁用）。 ",
    "Canny": "Canny 边缘检测算法",
    "Canny Low Threshold": "Canny 最低阈值",
    "Canny High Threshold": "Canny 最高阈值",
    "FreeU": "FreeU 提示词精准性优化",
    "Enabled": "启用",
    "B1": "B1",
    "B2": "B2",
    "S1": "S1",
    "S2": "S2",
    "Type prompt here.": "在这里输入提示词（支持简单中文词，请用英文逗号分隔）",
    "4Guofeng4XL_v10RealBeta.safetensors": "国风真人模型 4Guofeng4XL_v10RealBeta",
    "4Guofeng4XL_v1125D.safetensors": "国风动漫模型 4Guofeng4XL_v1125D",
    "SDXLRonghua_v30.safetensors": "国风容华 SDXLRonghua_v30",
    "wheel": "滚轮",
    "Zoom canvas": "画布缩放",
    "Adjust brush size": "调整笔刷尺寸",
    "Reset zoom": "画布复位",
    "Fullscreen mode": "全屏模式",
    "Move canvas": "移动画布",
    "Overlap": "图层重叠"
}
EOF
}