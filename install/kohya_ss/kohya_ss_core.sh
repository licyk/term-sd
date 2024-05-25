__term_sd_task_sys term_sd_mkdir "$kohya_ss_parent_path"
__term_sd_task_sys cd "$kohya_ss_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/bmaltais/kohya_ss "$kohya_ss_parent_path" "$kohya_ss_folder"
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/kohya-ss/sd-scripts "$kohya_ss_path" sd-scripts # kohya_ss后端
__term_sd_task_sys cd "$kohya_ss_folder"
__term_sd_task_pre_core git submodule init
__term_sd_task_pre_core git submodule update
__term_sd_task_sys is_sd_repo_exist "$kohya_ss_path"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys create_venv "$kohya_ss_path"
__term_sd_task_sys enter_venv "$kohya_ss_path"
__term_sd_task_pre_core term_sd_mkdir "$kohya_ss_path"/output
__term_sd_task_pre_core term_sd_mkdir "$kohya_ss_path"/train
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_sys cd sd-scripts
__term_sd_task_pre_core install_python_package --upgrade -r requirements.txt # 依赖列表中有"-e .",需要在kohya_ss目录中进行
__term_sd_task_sys cd ..
__term_sd_task_pre_core install_python_package --upgrade -r requirements.txt
__term_sd_task_pre_core install_python_package --upgrade bitsandbytes
__term_sd_task_sys cd ..
