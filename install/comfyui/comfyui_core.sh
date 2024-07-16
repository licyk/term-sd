__term_sd_task_sys term_sd_mkdir "${COMFYUI_PARENT_PATH}"
__term_sd_task_sys cd "${COMFYUI_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository https://github.com/comfyanonymous/ComfyUI "${COMFYUI_PARENT_PATH}" "${COMFYUI_FOLDER}"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_sys is_sd_repo_exist "${COMFYUI_PATH}"
__term_sd_task_sys create_venv "${COMFYUI_PATH}"
__term_sd_task_sys enter_venv "${COMFYUI_PATH}"
__term_sd_task_pre_core install_pytorch # 安装 PyTorch
__term_sd_task_pre_core install_python_package -r "${COMFYUI_PATH}"/requirements.txt
