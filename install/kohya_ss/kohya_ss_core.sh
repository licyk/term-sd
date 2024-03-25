__term_sd_task_sys term_sd_mkdir "$kohya_ss_parent_path"
__term_sd_task_sys cd "$kohya_ss_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/bmaltais/kohya_ss "$kohya_ss_parent_path" "$kohya_ss_folder"
__term_sd_task_sys is_sd_repo_exist "$kohya_ss_path"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_sys create_venv "$kohya_ss_path"
__term_sd_task_sys enter_venv "$kohya_ss_path"
__term_sd_task_pre_core term_sd_mkdir "$kohya_ss_path"/output
__term_sd_task_pre_core term_sd_mkdir "$kohya_ss_path"/train
__term_sd_task_sys cd "$kohya_ss_folder"
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy bitsandbytes tensorflow tensorboard
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # 依赖列表中有"-e .",需要在kohya_ss目录中进行
__term_sd_task_pre_core term_sd_try term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade bitsandbytes
__term_sd_task_sys cd ..
