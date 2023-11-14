__term_sd_task_sys term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/AUTOMATIC1111/stable-diffusion-webui
__term_sd_task_pre_core [ ! -d "./stable-diffusion-webui" ] && tmp_enable_proxy && term_sd_echo "检测到stable-diffusion-webui框架安装失败,已终止安装进程" && sleep 3 && return 1 || true #防止继续进行安装导致文件散落,造成目录混乱
__term_sd_task_sys cd ./stable-diffusion-webui
__term_sd_task_sys create_venv
__term_sd_task_sys enter_venv
__term_sd_task_sys cd ..
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/sczhou/CodeFormer stable-diffusion-webui/repositories CodeFormer
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/salesforce/BLIP stable-diffusion-webui/repositories BLIP
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Stability-AI/stablediffusion stable-diffusion-webui/repositories stable-diffusion-stability-ai
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/Stability-AI/generative-models stable-diffusion-webui/repositories generative-models
__term_sd_task_pre_core git_clone_repository ${github_mirror} https://github.com/crowsonkb/k-diffusion stable-diffusion-webui/repositories k-diffusion
__term_sd_task_pre_core [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ] && term_sd_watch term_sd_pip install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --default-timeout=100 --retries 5 || true
__term_sd_task_pre_core term_sd_watch term_sd_pip install git+$(git_format_repository_url ${github_mirror} https://github.com/openai/CLIP) --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --default-timeout=100 --retries 5
__term_sd_task_pre_core term_sd_watch term_sd_pip install -r ./stable-diffusion-webui/repositories/CodeFormer/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --default-timeout=100 --retries 5
__term_sd_task_pre_core term_sd_watch term_sd_pip install -r ./stable-diffusion-webui/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖
__term_sd_task_pre_core term_sd_echo "生成配置中"
__term_sd_task_pre_core echo "{" > ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "    \"quicksettings_list\": [" >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "        \"sd_model_checkpoint\"," >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "        \"sd_vae\"," >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "        \"CLIP_stop_at_last_layers\"" >> ./stable-diffusion-webui/config.json   
__term_sd_task_pre_core echo "    ]," >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "    \"save_to_dirs\": false," >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "    \"grid_save_to_dirs\": false," >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "    \"hires_fix_show_sampler\": true," >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "    \"CLIP_stop_at_last_layers\": 2" >> ./stable-diffusion-webui/config.json
__term_sd_task_pre_core echo "}" >> ./stable-diffusion-webui/config.json