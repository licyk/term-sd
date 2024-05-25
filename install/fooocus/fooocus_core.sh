__term_sd_task_sys term_sd_mkdir "$fooocus_parent_path"
__term_sd_task_sys cd "$fooocus_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/lllyasviel/Fooocus "$fooocus_parent_path" "$fooocus_folder"
__term_sd_task_sys is_sd_repo_exist "$fooocus_path"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys create_venv "$fooocus_path"
__term_sd_task_sys enter_venv "$fooocus_path"
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_pre_core install_python_package -r "$fooocus_path"/requirements_versions.txt
__term_sd_task_pre_core fooocus_lang_config_file > "$fooocus_path"/language/zh.json # 为fooocus添加翻译文件
__term_sd_task_pre_core fooocus_preset_file > "$fooocus_path"/presets/term_sd.json # 添加Term-SD风格的预设
