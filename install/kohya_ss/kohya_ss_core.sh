__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/bmaltais/kohya_ss
__term_sd_task_pre_core [ ! -d "./kohya_ss" ] && tmp_enable_proxy && term_sd_echo "检测到kohya_ss框架安装失败,已终止安装进程" && sleep 3 && return 1 || true # 防止继续进行安装导致文件散落,造成目录混乱
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys cd ./kohya_ss
__term_sd_task_sys create_venv
__term_sd_task_sys enter_venv
__term_sd_task_pre_core [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ] && term_sd_watch term_sd_pip install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary || true
__term_sd_task_pre_core term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy bitsandbytes tensorflow tensorboard
__term_sd_task_pre_core term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # kohya_ss安装依赖
__term_sd_task_sys cd ..
