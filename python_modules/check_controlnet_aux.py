try:
    import controlnet_aux  # noqa: F401

    success = True
except:
    success = False

if not success:
    from importlib.metadata import requires

    try:
        invokeai_requires = requires("invokeai")
    except:
        invokeai_requires = []

    controlnet_aux_ver = None

    for req in invokeai_requires:
        if req.startswith("controlnet-aux=="):
            controlnet_aux_ver = req.split(";")[0].strip()
            break


if success:
    print(None)
else:
    if controlnet_aux_ver is None:
        print("controlnet_aux")
    else:
        print(controlnet_aux_ver)
