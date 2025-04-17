__term_sd_task_sys term_sd_mkdir "${LORA_SCRIPTS_PARENT_PATH}"
__term_sd_task_sys cd "${LORA_SCRIPTS_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/Akegarasu/lora-scripts "${LORA_SCRIPTS_PARENT_PATH}" "${LORA_SCRIPTS_FOLDER}"
__term_sd_task_sys is_sd_repo_exist "${LORA_SCRIPTS_ROOT_PATH}"
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/hanamizuki-ai/lora-gui-dist "${LORA_SCRIPTS_ROOT_PATH}" frontend # lora-scripts 前端
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/Akegarasu/dataset-tag-editor "${LORA_SCRIPTS_ROOT_PATH}"/mikazuki dataset-tag-editor # 标签编辑器
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_sys cd "${LORA_SCRIPTS_ROOT_PATH}"
__term_sd_task_pre_core git_init_submodule "${LORA_SCRIPTS_ROOT_PATH}" # 初始化 Git 子模块
__term_sd_task_pre_core create_venv "${LORA_SCRIPTS_ROOT_PATH}"
__term_sd_task_sys enter_venv "${LORA_SCRIPTS_ROOT_PATH}"
__term_sd_task_pre_core install_pytorch # 安装 PyTorch
__term_sd_task_pre_core install_python_package -r "${LORA_SCRIPTS_ROOT_PATH}"/requirements.txt # lora-scripts 依赖
__term_sd_task_sys cd ..
