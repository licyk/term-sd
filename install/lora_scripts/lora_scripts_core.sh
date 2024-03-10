__term_sd_task_sys term_sd_mkdir "$lora_scripts_parent_path"
__term_sd_task_sys cd "$lora_scripts_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Akegarasu/lora-scripts "$lora_scripts_parent_path" "$lora_scripts_folder"
__term_sd_task_pre_core [ ! -d "$lora_scripts_folder" ] && tmp_enable_proxy && term_sd_echo "检测到lora-scripts框架安装失败,已终止安装进程" && sleep 3 && return 1 || true # 防止继续进行安装导致文件散落,造成目录混乱
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/kohya-ss/sd-scripts "$lora_scripts_path" sd-scripts # lora-scripts后端
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/hanamizuki-ai/lora-gui-dist "$lora_scripts_path" frontend # lora-scripts前端
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Akegarasu/dataset-tag-editor "$lora_scripts_path"/mikazuki dataset-tag-editor # 标签编辑器
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys cd "$lora_scripts_folder"
__term_sd_task_pre_core git submodule init
__term_sd_task_pre_core git submodule update
__term_sd_task_sys create_venv
__term_sd_task_sys enter_venv
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_sys cd sd-scripts
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # sd-scripts目录下还有个_typos.toml,在安装requirements.txt里的依赖时会指向这个文件
__term_sd_task_sys cd ..
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # lora-scripts安装依赖
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade bitsandbytes
__term_sd_task_sys cd ..
