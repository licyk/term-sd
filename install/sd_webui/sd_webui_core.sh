__term_sd_task_sys term_sd_mkdir "$sd_webui_parent_path"
__term_sd_task_sys cd "$sd_webui_parent_path"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/AUTOMATIC1111/stable-diffusion-webui "$sd_webui_parent_path" "$sd_webui_folder"
__term_sd_task_pre_core [ ! -d "$sd_webui_folder" ] && tmp_enable_proxy && term_sd_echo "检测到stable-diffusion-webui框架安装失败,已终止安装进程" && sleep 3 && return 1 || true # 防止继续进行安装导致文件散落,造成目录混乱
__term_sd_task_sys create_venv "$sd_webui_path"
__term_sd_task_sys enter_venv "$sd_webui_path"
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/sczhou/CodeFormer "$sd_webui_path"/repositories CodeFormer
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/salesforce/BLIP "$sd_webui_path"/repositories BLIP
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Stability-AI/stablediffusion "$sd_webui_path"/repositories stable-diffusion-stability-ai
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Stability-AI/generative-models "$sd_webui_path"/repositories generative-models
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/crowsonkb/k-diffusion "$sd_webui_path"/repositories k-diffusion
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets "$sd_webui_path"/repositories stable-diffusion-webui-assets
__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_pre_core install_pytorch # 安装pytorch
__term_sd_task_pre_core term_sd_watch term_sd_pip install git+$(git_format_repository_url ${github_mirror} https://github.com/openai/CLIP) --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
__term_sd_task_pre_core term_sd_watch term_sd_pip install -r "$sd_webui_path"/repositories/CodeFormer/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
__term_sd_task_pre_core term_sd_watch term_sd_pip install -r "$sd_webui_path"/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode # 安装stable-diffusion-webui的依赖
__term_sd_task_pre_core term_sd_echo "生成配置中"
__term_sd_task_pre_core sd_webui_config_file > "$sd_webui_path"/config.json
