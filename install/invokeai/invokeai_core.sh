__term_sd_task_sys term_sd_mkdir "${INVOKEAI_PARENT_PATH}"
__term_sd_task_sys cd "${INVOKEAI_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_sys term_sd_mkdir "${INVOKEAI_FOLDER}"
__term_sd_task_sys is_sd_repo_exist "${INVOKEAI_ROOT_PATH}"
__term_sd_task_pre_core create_venv "${INVOKEAI_ROOT_PATH}"
__term_sd_task_sys enter_venv "${INVOKEAI_ROOT_PATH}"
__term_sd_task_pre_core install_invokeai_process "${PYTORCH_TYPE}" # 安装 PyTorch
__term_sd_task_pre_core install_pypatchmatch_for_windows # 下载 PyPatchMatch
