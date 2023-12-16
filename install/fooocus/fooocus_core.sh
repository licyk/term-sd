__term_sd_task_sys term_sd_mkdir "$fooocus_parent_path"
__term_sd_task_sys cd "$fooocus_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/lllyasviel/Fooocus "$fooocus_parent_path" "$fooocus_folder"
__term_sd_task_sys [ ! -d "$fooocus_folder" ] && term_sd_tmp_enable_proxy && term_sd_echo "检测到"Fooocus"框架安装失败,已终止安装进程" && sleep 3 && return 1 || true # 防止继续进行安装导致文件散落,造成目录混乱
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/comfyanonymous/ComfyUI "$fooocus_folder"/repositories ComfyUI-from-StabilityAI-Official
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys cd "$fooocus_folder"
__term_sd_task_sys create_venv
__term_sd_task_sys enter_venv
__term_sd_task_sys cd ..
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_pre_core term_sd_watch term_sd_pip install -r "$fooocus_folder"/requirements_versions.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
