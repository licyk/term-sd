__term_sd_task_sys term_sd_mkdir "$lora_scripts_parent_path"
__term_sd_task_sys cd "$lora_scripts_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Akegarasu/lora-scripts "$lora_scripts_parent_path" "$lora_scripts_folder"
__term_sd_task_sys is_sd_repo_exist "$lora_scripts_path"
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
__term_sd_task_pre_core install_python_package --upgrade -r requirements.txt # sd-scripts目录下还有个_typos.toml,在安装requirements.txt里的依赖时会指向这个文件
__term_sd_task_sys cd ..
__term_sd_task_pre_core install_python_package --upgrade -r requirements.txt # lora-scripts安装依赖
__term_sd_task_pre_core install_python_package --upgrade bitsandbytes
__term_sd_task_sys cd ..
