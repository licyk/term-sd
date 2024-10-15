__term_sd_task_sys term_sd_mkdir "${KOHYA_SS_PARENT_PATH}"
__term_sd_task_sys cd "${KOHYA_SS_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/bmaltais/kohya_ss "${KOHYA_SS_PARENT_PATH}" "${KOHYA_SS_FOLDER}"
__term_sd_task_pre_core git_clone_repository --disable-submod https://github.com/kohya-ss/sd-scripts "${KOHYA_SS_PATH}" sd-scripts # kohya_ss 后端
__term_sd_task_sys cd "${KOHYA_SS_PATH}"
__term_sd_task_pre_core git_init_submodule "${KOHYA_SS_PATH}" # 初始化 Git 子模块
__term_sd_task_sys is_sd_repo_exist "${KOHYA_SS_PATH}"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_pre_core create_venv "${KOHYA_SS_PATH}"
__term_sd_task_sys enter_venv "${KOHYA_SS_PATH}"
__term_sd_task_pre_core term_sd_mkdir "${KOHYA_SS_PATH}"/output
__term_sd_task_pre_core term_sd_mkdir "${KOHYA_SS_PATH}"/train
__term_sd_task_pre_core install_pytorch # 安装 PyTorch
__term_sd_task_pre_core install_python_package -r "${KOHYA_SS_PATH}"/requirements.txt
__term_sd_task_pre_core install_python_package bitsandbytes -U
__term_sd_task_sys cd ..
