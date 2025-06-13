import os
import sys
import re

def kebab_to_title_case(s):
    return s.replace("_", " ").title()

def create_module(module_name, parent_module=None, base_path="lib/modules"):
    if parent_module:
        full_path = os.path.join(base_path, parent_module, module_name)
        base_name = f"{parent_module}_{module_name}"
    else:
        full_path = os.path.join(base_path, module_name)
        base_name = module_name

    os.makedirs(full_path, exist_ok=True)
    subfolders = ["models", "views", "controllers", "services"]
    for sub in subfolders:
        os.makedirs(os.path.join(full_path, sub), exist_ok=True)

    # Generate files with content
    generate_module_file(full_path, base_name)
    generate_controller_file(full_path, base_name)
    generate_view_file(full_path, base_name)
    generate_empty_file(os.path.join(full_path, f"services/{base_name}_service.dart"))
    generate_empty_file(os.path.join(full_path, f"models/{base_name}_model.dart"))

    print(f"✅ Modul '{base_name}' berhasil dibuat di '{full_path}'!")

    # Auto registrasi
    append_to_app_routes(module_name, parent_module)
    append_to_constants(module_name, parent_module)
    append_to_menu_json(module_name, parent_module)

def generate_module_file(path, base_name):
    class_name = ''.join(x.capitalize() for x in base_name.split('_')) + "Module"
    route_const = base_name
    content = f"""import 'package:get/get.dart';
import 'views/{base_name}_view.dart';
import 'controllers/{base_name}_controller.dart';
import 'package:fastflow_flutter/routes/app_routes_constant.dart';

class {class_name} {{
  static final routes = [
    GetPage(
      name: AppRoutesConstants.{route_const},
      page: () => {base_name.title().replace('_', '')}View(),
      binding: BindingsBuilder(() {{
        Get.put({base_name.title().replace('_', '')}Controller());
      }}),
    ),
  ];
}}
"""
    write_file(os.path.join(path, f"{base_name}_module.dart"), content)

def generate_controller_file(path, base_name):
    class_name = base_name.title().replace('_', '') + "Controller"
    content = f"""import 'dart:convert';
import 'package:get/get.dart';
import 'package:fastflow_flutter/core/services/storage_service.dart';

class {class_name} extends GetxController {{
  final StorageService _storage = StorageService();
}}
"""
    write_file(os.path.join(path, f"controllers/{base_name}_controller.dart"), content)

def generate_view_file(path, base_name):
    class_name = base_name.title().replace('_', '') + "View"
    controller_class = base_name.title().replace('_', '') + "Controller"
    content = f"""import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/{base_name}_controller.dart';

class {class_name} extends StatelessWidget {{
  final {controller_class} controller = Get.find<{controller_class}>();

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(title: Text('{kebab_to_title_case(base_name)}')),
      body: Center(child: Text('Ini adalah halaman {kebab_to_title_case(base_name)}')),
    );
  }}
}}
"""
    write_file(os.path.join(path, f"views/{base_name}_view.dart"), content)

def generate_empty_file(file_path):
    write_file(file_path, "// Auto-generated file\n")

def write_file(path, content):
    if not os.path.exists(path):
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)

def append_to_app_routes(module_name, parent_module=None):
    routes_path = "lib/routes/app_routes.dart"
    base_name = f"{parent_module}_{module_name}" if parent_module else module_name
    class_name = ''.join(x.capitalize() for x in base_name.split('_')) + "Module"
    import_path = f"../modules/{parent_module}/{module_name}/{base_name}_module.dart" if parent_module else f"../modules/{module_name}/{base_name}_module.dart"
    import_line = f"import '{import_path}';"
    module_line = f"    ...{class_name}.routes,"

    if not os.path.exists(routes_path):
        print(f"❌ File {routes_path} tidak ditemukan!")
        return

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
    const_line = f'  static const String {base_name} = "/{base_name}";\n'

    if not os.path.exists(const_path):
        print(f"❌ File {const_path} tidak ditemukan!")
        return

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

    if not os.path.exists(config_path):
        print(f"❌ File {config_path} tidak ditemukan!")
        return

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
