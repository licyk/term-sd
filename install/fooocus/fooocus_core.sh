__term_sd_task_sys term_sd_mkdir "${FOOOCUS_PARENT_PATH}"
__term_sd_task_sys cd "${FOOOCUS_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository https://github.com/lllyasviel/Fooocus "${FOOOCUS_PARENT_PATH}" "${FOOOCUS_FOLDER}"
__term_sd_task_sys is_sd_repo_exist "${FOOOCUS_PATH}"
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_pre_core create_venv "${FOOOCUS_PATH}"
__term_sd_task_sys enter_venv "${FOOOCUS_PATH}"
__term_sd_task_pre_core install_pytorch # 安装 PyTorch
__term_sd_task_pre_core install_python_package -r "${FOOOCUS_PATH}"/requirements_versions.txt
__term_sd_task_pre_core fooocus_lang_config_file > "${FOOOCUS_PATH}"/language/zh.json # 为 Fooocus 添加翻译文件
__term_sd_task_pre_core fooocus_preset_file > "${FOOOCUS_PATH}"/presets/term_sd.json # 添加 Term-SD 风格的预设
