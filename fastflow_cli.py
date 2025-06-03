import os
import sys
import re

def kebab_to_title_case(s):
    return s.replace("_", " ").title()

def create_module(module_name, parent_module=None, base_path="lib/modules"):
    """Membuat struktur folder dan file untuk modul."""

    if parent_module:
        full_path = os.path.join(base_path, parent_module, module_name)
        base_name = f"{parent_module}_{module_name}"  # contoh: master_produk
    else:
        full_path = os.path.join(base_path, module_name)
        base_name = module_name

    subfolders = ["models", "views", "controllers", "services"]
    for sub in subfolders:
        os.makedirs(os.path.join(full_path, sub), exist_ok=True)

    files = [
        f"{base_name}_module.dart",
        f"models/{base_name}_model.dart",
        f"views/{base_name}_view.dart",
        f"controllers/{base_name}_controller.dart",
        f"services/{base_name}_service.dart"
    ]

    for file in files:
        file_path = os.path.join(full_path, file)
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                f.write(f"// {file}\n")

    print(f"✅ Modul '{base_name}' berhasil dibuat di '{full_path}'!")

    # Auto registrasi
    append_to_app_routes(module_name, parent_module)
    append_to_constants(module_name, parent_module)
    append_to_menu_json(module_name, parent_module)

def append_to_app_routes(module_name, parent_module=None):
    routes_path = "lib/routes/app_routes.dart"
    base_name = f"{parent_module}_{module_name}" if parent_module else module_name
    class_name = ''.join(x.capitalize() for x in base_name.split('_')) + "Module"
    import_path = f"../modules/{parent_module}/{module_name}/{base_name}_module.dart" if parent_module else f"../modules/{module_name}/{base_name}_module.dart"
    import_line = f"import '{import_path}';"
    module_line = f"    ...{class_name}.routes,"

    with open(routes_path, "r+", encoding="utf-8") as f:
        content = f.read()

        if import_line not in content:
            content = import_line + "\n" + content

        if module_line not in content:
            content = content.replace("static final routes = [", f"static final routes = [\n{module_line}")

        f.seek(0)
        f.write(content)
        f.truncate()

def append_to_constants(module_name, parent_module=None):
    const_path = "lib/routes/app_routes_constant.dart"
    base_name = f"{parent_module}_{module_name}" if parent_module else module_name
    const_name = base_name
    route_path = f'/{base_name}'
    const_line = f'  static const String {const_name} = "{route_path}";\n'

    with open(const_path, "r+", encoding="utf-8") as f:
        content = f.read()
        if const_line not in content:
            insert_index = content.find("// Maintenance")
            if insert_index == -1:
                insert_index = len(content)
            content = content[:insert_index] + const_line + content[insert_index:]
            f.seek(0)
            f.write(content)
            f.truncate()

def append_to_menu_json(module_name, parent_module=None):
    config_path = "lib/core/config/menu_config.dart"
    route = f"/{parent_module}_{module_name}" if parent_module else f"/{module_name}"
    title = kebab_to_title_case(module_name)
    section = "Master" if "master" in (parent_module or "") else "Transaksi"

    with open(config_path, "r+", encoding="utf-8") as f:
        content = f.read()

        section_pattern = f'"title": "{section}",\n\\s+"items": \\['
        match = re.search(section_pattern, content)

        if match:
            insert_pos = match.end()
            new_item = f'        {{ "title": "{title}", "icon": "list", "route": "{route}" }},\n'
            content = content[:insert_pos] + "\n" + new_item + content[insert_pos:]
            f.seek(0)
            f.write(content)
            f.truncate()

if __name__ == "__main__":
    args = sys.argv[1:]

    if not args:
        print("❌ Gunakan: python fastflow_cli.py <modul> [submodul]")
        sys.exit(1)

    if len(args) == 2:
        create_module(args[1], parent_module=args[0])
    else:
        create_module(args[0])
