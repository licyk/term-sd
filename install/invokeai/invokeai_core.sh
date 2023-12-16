__term_sd_task_sys term_sd_mkdir "$invokeai_parent_path"
__term_sd_task_sys cd "$invokeai_parent_path"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys [ ! -d "$invokeai_path" ] && mkdir "$invokeai_path"
__term_sd_task_sys cd ./"$invokeai_path"
__term_sd_task_sys create_venv
__term_sd_task_sys enter_venv
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_pre_core term_sd_watch term_sd_pip install invokeai $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary
