__term_sd_task_sys term_sd_mkdir "${SD_WEBUI_PARENT_PATH}"
__term_sd_task_sys cd "${SD_WEBUI_PARENT_PATH}"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository "${SD_WEBUI_REPO}" "${SD_WEBUI_PARENT_PATH}" "${SD_WEBUI_FOLDER}"
__term_sd_task_sys is_sd_repo_exist "${SD_WEBUI_PATH}"
__term_sd_task_pre_core switch_sd_webui_branch "${SD_WEBUI_BRANCH}"
__term_sd_task_pre_core create_venv "${SD_WEBUI_PATH}"
__term_sd_task_sys enter_venv "${SD_WEBUI_PATH}"
__term_sd_task_pre_core install_sd_webui_component
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_pre_core install_pytorch # 安装 PyTorch
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core install_python_package git+$(git_format_repository_url ${GITHUB_MIRROR} https://github.com/openai/CLIP)
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理, 避免一些不必要的网络减速
__term_sd_task_pre_core install_sd_webui_requirement
__term_sd_task_pre_core term_sd_echo "生成配置中"
__term_sd_task_pre_core set_sd_webui_normal_config
