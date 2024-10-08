__term_sd_task_pre_ext_1 term_sd_echo "下载 invoke_tipo 模型" # invoke_tipo(1.42g) ON
__term_sd_task_pre_ext_1 aria2_download https://huggingface.co/licyk/sd-extensions-model/resolve/main/z-tipo-extension/TIPO-500M_epoch5-F16.gguf "${INVOKEAI_PATH}"/invokeai/models/kgen
__term_sd_task_pre_ext_1 aria2_download https://huggingface.co/licyk/sd-extensions-model/resolve/main/z-tipo-extension/TIPO-200M-40Btok-F16.gguf "${INVOKEAI_PATH}"/invokeai/models/kgen
