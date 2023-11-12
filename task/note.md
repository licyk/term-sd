# Term-SD定义的命令队列标识
# __term_sd_task_ 可识别的关键字
# Term-SD队列命令格式
# <标识关键字> <命令>
# 在执行的过程，Term-SD将会把标识去除，得到命令

# Term-SD执行安装任务时的标识
# __term_sd_task_sys Term-SD一定执行命令的标识
# __term_sd_task_pre Term-SD待执行命令的标识，执行完成后修改为__term_sd_task_done
# __term_sd_task_done Term-SD已执行命令的标识

# Term-SD对模型，插件的标识
# __term_sd_task_pre_model 表示模型
# __term_sd_task_pre_ext_1 表示插件(也可以标识插件所属的模型)


# 执行完成后将变成如下的标识
# __term_sd_task_done_model
# __term_sd_task_done_ext
# ...

# Term-SD队列命令格式例子
# 模型
# __term_sd_task_pre_model aria https://huggingface.co/xxxxxxx -d ./ssss/sss -o file.pt
# __term_sd_task_pre_model get_modelscope_model 123/345/456 ./qwer
# 插件
# __term_sd_task_pre_ext_1 git_clone_repository <链接格式> <原链接> <下载路径>