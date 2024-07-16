__term_sd_task_sys term_sd_mkdir "${LORA_SCRIPTS_PARENT_PATH}"
__term_sd_task_sys cd "${LORA_SCRIPTS_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/Akegarasu/lora-scripts "${LORA_SCRIPTS_PARENT_PATH}" "${LORA_SCRIPTS_FOLDER}"
__term_sd_task_sys is_sd_repo_exist "${LORA_SCRIPTS_PATH}"
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/kohya-ss/sd-scripts "${LORA_SCRIPTS_PATH}" sd-scripts # lora-scripts 后端
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/hanamizuki-ai/lora-gui-dist "${LORA_SCRIPTS_PATH}" frontend # lora-scripts 前端
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/Akegarasu/dataset-tag-editor "${LORA_SCRIPTS_PATH}"/mikazuki dataset-tag-editor # 标签编辑器
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_sys cd "${LORA_SCRIPTS_FOLDER}"
__term_sd_task_pre_core git submodule init
__term_sd_task_pre_core git submodule update
__term_sd_task_sys create_venv
__term_sd_task_sys enter_venv
__term_sd_task_pre_core install_pytorch # 安装 PyTorch
__term_sd_task_sys cd sd-scripts
__term_sd_task_pre_core install_python_package --upgrade -r requirements.txt # sd-scripts 目录下还有个 _typos.toml, 在安装 requirements.txt  里的依赖时会指向这个文件
__term_sd_task_sys cd ..
__term_sd_task_pre_core install_python_package --upgrade -r requirements.txt # lora-scripts 安装依赖
__term_sd_task_pre_core install_python_package --upgrade bitsandbytes
__term_sd_task_sys cd ..
