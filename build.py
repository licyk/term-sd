import os
from pathlib import Path
import argparse



def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument("--fix", default=False, help="将文件的换行符转换为 LF", action="store_true")
    parser.add_argument("--build", default=False, help = "生成 Dialog 列表和帮助列表", action="store_true")
    parser.add_argument("--sort", default=False, help = "对列表标签重新排序", action="store_true")
    parser.add_argument("--check", default=False, help = "检查是否包含重复的模型或插件", action="store_true")

    return parser.parse_args()


def get_content(file: str) -> list:
    content = []
    if not os.path.exists(file):
        print(f"{file} 未找到")
        return content

    with open(file, "r", encoding = "utf8") as f:
        # content = f.readlines()
        content = f.read().split("\n")

    return content


def write_content(content: list, path: str) -> None:
    if len(content) == 0:
        return

    with open(path, "w", encoding="utf8", newline="\n") as f:
        for item in content:
            f.write(item + "\n")


def build_extension_list(input_file: str, output_file: str) -> None:
    ori_content = get_content(input_file)
    content = []

    for line in ori_content:
        if line == "":
            continue

        if len(line.split()) < 5:
            print(f"{input_file} 出现元素缺失, 缺失元素的内容为: {line}")
            return

        point = line.split()[0]
        name = line.split()[2].split("/").pop()
        status = line.split()[4]
        text = f"{point} {name} {status}"
        content.append(text)

    write_content(content, output_file)


def build_sd_webui_extension_desc(input_file: str, output_file: str) -> None:
    ori_content = get_content(input_file)
    content = []

    content.append("Stable Diffusion WebUI 插件说明：")
    content.append("注：")
    content.append("1、有些插件因为年久失修，可能会出现兼容性问题。具体介绍请通过链接查看项目的说明")
    content.append("2、在名称右上角标 * 的为安装时默认勾选的插件")

    count = 0
    for line in ori_content:
        if line == "":
            continue

        if len(line.split()) < 7:
            print(f"{input_file} 出现元素缺失, 缺失元素的内容为: {line}")
            return

        count += 1
        link = line.split()[2]
        ext_name = link.split("/").pop()
        status = "*" if line.split()[4] == "ON" else ""
        desc = line.split()[6]
        text = f"\n{count}、{ext_name}{status}\n描述：{desc}\n链接：{link}"
        content.append(text)

    write_content(content, output_file)


def build_comfyui_extension_desc(input_file_1: str, input_file_2: str, output_file: str) -> None:
    ori_content_1 = get_content(input_file_1)
    ori_content_2 = get_content(input_file_2)
    content = []

    content.append("ComfyUI 插件 / 自定义节点说明：")
    content.append("注：")
    content.append("1、有些插件因为年久失修，可能会出现兼容性问题。具体介绍请通过链接查看项目的说明")
    content.append("2、在名称右上角标 * 的为安装时默认勾选的插件")

    # 插件
    content.append("\n插件：")
    count = 0
    for line in ori_content_1:
        if line == "":
            continue

        if len(line.split()) < 7:
            print(f"{input_file_1} 出现元素缺失, 缺失元素的内容为: {line}")
            return

        count += 1
        link = line.split()[2]
        ext_name = link.split("/").pop()
        status = "*" if line.split()[4] == "ON" else ""
        desc = line.split()[6]
        text = f"\n{count}、{ext_name}{status}\n描述：{desc}\n链接：{link}"
        content.append(text)

    # 自定义节点
    content.append("\n自定义节点：")
    count = 0
    for line in ori_content_2:
        if line == "":
            continue

        if len(line.split()) < 5:
            print(f"{input_file_2} 出现元素缺失, 缺失元素的内容为: {line}")
            return

        count += 1
        link = line.split()[2]
        ext_name = link.split("/").pop()
        status = "*" if line.split()[4] == "ON" else ""
        desc = line.split()[6]
        text = f"\n{count}、{ext_name}{status}\n描述：{desc}\n链接：{link}"
        content.append(text)

    write_content(content, output_file)


def build_invokeai_custom_node_desc(input_file: str, output_file: str) ->None:
    ori_content = get_content(input_file)
    content = []

    content.append("InvokeAI 自定义节点说明：")
    content.append("注：")
    content.append("1、有些插件因为年久失修，可能会出现兼容性问题。具体介绍请通过链接查看项目的说明")
    content.append("2、在名称右上角标 * 的为安装时默认勾选的插件")

    count = 0
    for line in ori_content:
        if line == "":
            continue

        if len(line.split()) < 7:
            print(f"{input_file} 出现元素缺失, 缺失元素的内容为: {line}")
            return

        count += 1
        link = line.split()[2]
        ext_name = link.split("/").pop()
        status = "*" if line.split()[4] == "ON" else ""
        desc = line.split()[6]
        text = f"\n{count}、{ext_name}{status}\n描述：{desc}\n链接：{link}"
        content.append(text)

    write_content(content, output_file)


def build_model_list(input_file: str, output_file: str) -> None:
    ori_content = get_content(input_file)
    content = []

    for line in ori_content:
        if line == "":
            continue

        point = line.split()[0]
        name = line.split()[-2]
        status = line.split()[-1]
        text = f"{point} {name} {status}"
        content.append(text)

    write_content(content, output_file)


def sort_point(head_point: str, file: str) -> None:
    ori_content = get_content(file)
    content = []

    count = 0
    for line in ori_content:
        if line == "":
            continue

        count += 1
        line = line.split()
        line[0] = f"{head_point}{count}"
        text = " ".join(line)

        content.append(text)

    write_content(content, file)


def dos2unix(input_file: str) -> None:
    with open(input_file, "r", encoding="utf8") as file:
        content = file.read()

    content = content.replace("\r\n", "\n")

    with open(input_file, "w", encoding="utf8", newline="\n") as file:
        file.write(content)


def get_all_file(directory):
    import os
    file_list = []
    for dirname, _, filenames in os.walk(directory):
        for filename in filenames:
            file_list.append(os.path.join(dirname, filename))
    return file_list


def detect_uplicate(list_type: str,file: str) -> None:
    content = get_content(file)

    if list_type == "model":
        list_column = 2
    elif list_type == "extension":
        list_column = 2

    point_1 = 0
    point_2 = 0
    for i in content:
        point_1 += 1
        point_2 = 0
        for j in content:
            point_2 += 1
            if i == j:
                continue
            if point_1 > point_2:
                continue
            if len(i.split()) >= list_column and len(j.split()) >= list_column and i.split()[list_column] == j.split()[list_column]:
                print(f"{file} 存在重复{'模型' if list_type == 'model' else '插件'}, 在 {i.split()[0]} 和 {j.split()[0]}")
                print(f"重复内容: {i.split()[list_column]}")


if __name__ == "__main__":
    root_path = os.path.dirname(os.path.abspath(__file__))
    os.chdir(root_path)
    print(f"脚本路径: {root_path}")
    args = get_args()

    if args.sort:
        print("排序头标签")
        sort_point("__term_sd_task_pre_model_", "install/sd_webui/sd_webui_hf_model.sh")
        sort_point("__term_sd_task_pre_model_", "install/sd_webui/sd_webui_ms_model.sh")

        sort_point("__term_sd_task_pre_model_", "install/comfyui/comfyui_hf_model.sh")
        sort_point("__term_sd_task_pre_model_", "install/comfyui/comfyui_ms_model.sh")

        sort_point("__term_sd_task_pre_model_", "install/fooocus/fooocus_hf_model.sh")
        sort_point("__term_sd_task_pre_model_", "install/fooocus/fooocus_ms_model.sh")

        sort_point("__term_sd_task_pre_model_", "install/invokeai/invokeai_hf_model.sh")
        sort_point("__term_sd_task_pre_model_", "install/invokeai/invokeai_ms_model.sh")

        sort_point("__term_sd_task_pre_model_", "install/lora_scripts/lora_scripts_hf_model.sh")
        sort_point("__term_sd_task_pre_model_", "install/lora_scripts/lora_scripts_ms_model.sh")

        sort_point("__term_sd_task_pre_model_", "install/kohya_ss/kohya_ss_hf_model.sh")
        sort_point("__term_sd_task_pre_model_", "install/kohya_ss/kohya_ss_ms_model.sh")

        sort_point("__term_sd_task_pre_ext_", "install/sd_webui/sd_webui_extension.sh")
        sort_point("__term_sd_task_pre_ext_", "install/comfyui/comfyui_custom_node.sh")
        sort_point("__term_sd_task_pre_ext_", "install/comfyui/comfyui_extension.sh")
        sort_point("__term_sd_task_pre_ext_", "install/invokeai/invokeai_custom_node.sh")


    if args.build:
        print("构建 Dialog 列表")
        build_extension_list("install/sd_webui/sd_webui_extension.sh", "install/sd_webui/dialog_sd_webui_extension.sh")
        build_extension_list("install/comfyui/comfyui_custom_node.sh", "install/comfyui/dialog_comfyui_custom_node.sh")
        build_extension_list("install/comfyui/comfyui_extension.sh", "install/comfyui/dialog_comfyui_extension.sh")
        build_extension_list("install/invokeai/invokeai_custom_node.sh", "install/invokeai/dialog_invokeai_custom_node.sh")

        build_sd_webui_extension_desc("install/sd_webui/sd_webui_extension.sh", "help/sd_webui_extension_description.md")
        build_comfyui_extension_desc("install/comfyui/comfyui_extension.sh", "install/comfyui/comfyui_custom_node.sh", "help/comfyui_extension_description.md")
        build_invokeai_custom_node_desc("install/invokeai/invokeai_custom_node.sh", "help/invokeai_custom_node_description.md")

        build_model_list("install/sd_webui/sd_webui_hf_model.sh", "install/sd_webui/dialog_sd_webui_hf_model.sh")
        build_model_list("install/sd_webui/sd_webui_ms_model.sh", "install/sd_webui/dialog_sd_webui_ms_model.sh")

        build_model_list("install/comfyui/comfyui_hf_model.sh", "install/comfyui/dialog_comfyui_hf_model.sh")
        build_model_list("install/comfyui/comfyui_ms_model.sh", "install/comfyui/dialog_comfyui_ms_model.sh")

        build_model_list("install/fooocus/fooocus_hf_model.sh", "install/fooocus/dialog_fooocus_hf_model.sh")
        build_model_list("install/fooocus/fooocus_ms_model.sh", "install/fooocus/dialog_fooocus_ms_model.sh")

        build_model_list("install/invokeai/invokeai_hf_model.sh", "install/invokeai/dialog_invokeai_hf_model.sh")
        build_model_list("install/invokeai/invokeai_ms_model.sh", "install/invokeai/dialog_invokeai_ms_model.sh")

        build_model_list("install/lora_scripts/lora_scripts_hf_model.sh", "install/lora_scripts/dialog_lora_scripts_hf_model.sh")
        build_model_list("install/lora_scripts/lora_scripts_ms_model.sh", "install/lora_scripts/dialog_lora_scripts_ms_model.sh")
        
        build_model_list("install/kohya_ss/kohya_ss_hf_model.sh", "install/kohya_ss/dialog_kohya_ss_hf_model.sh")
        build_model_list("install/kohya_ss/kohya_ss_ms_model.sh", "install/kohya_ss/dialog_kohya_ss_ms_model.sh")


    if args.fix:
        print("将所有文件的换行符转换为 LF")
        file_list = []
        for dir in ["extra", "config", "help", "install", "modules", "task", "python_modules"]:
            file_list += get_all_file(dir)
        for file in file_list:
            dos2unix(file)
        dos2unix("term-sd.sh")
        dos2unix("build.sh")
        dos2unix("README.md")


    if args.sort:
        print("查找重复模型 / 插件列表")
        detect_uplicate("model", "install/sd_webui/sd_webui_hf_model.sh")
        detect_uplicate("model", "install/sd_webui/sd_webui_ms_model.sh")

        detect_uplicate("model", "install/comfyui/comfyui_hf_model.sh")
        detect_uplicate("model", "install/comfyui/comfyui_ms_model.sh")

        detect_uplicate("model", "install/fooocus/fooocus_hf_model.sh")
        detect_uplicate("model", "install/fooocus/fooocus_ms_model.sh")

        detect_uplicate("model", "install/invokeai/invokeai_hf_model.sh")
        detect_uplicate("model", "install/invokeai/invokeai_ms_model.sh")

        detect_uplicate("model", "install/lora_scripts/lora_scripts_hf_model.sh")
        detect_uplicate("model", "install/lora_scripts/lora_scripts_ms_model.sh")

        detect_uplicate("model", "install/kohya_ss/kohya_ss_hf_model.sh")
        detect_uplicate("model", "install/kohya_ss/kohya_ss_ms_model.sh")

        detect_uplicate("extension", "install/sd_webui/sd_webui_extension.sh")
        detect_uplicate("extension", "install/comfyui/comfyui_custom_node.sh")
        detect_uplicate("extension", "install/comfyui/comfyui_extension.sh")
        detect_uplicate("extension", "install/invokeai/invokeai_custom_node.sh")
