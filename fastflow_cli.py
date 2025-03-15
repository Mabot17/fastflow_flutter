import os
import sys

def create_module(module_name, parent_module=None, base_path="lib/modules"):
    """Membuat struktur folder untuk modul utama atau submodul."""
    
    # Tentukan path sesuai input
    if parent_module:
        full_path = os.path.join(base_path, parent_module, module_name)
        base_name = f"{parent_module}_{module_name}"  # Misal: master_produk
    else:
        full_path = os.path.join(base_path, module_name)
        base_name = module_name  # Misal: pos

    subfolders = ["models", "views", "controllers", "services"]

    for sub in subfolders:
        os.makedirs(os.path.join(full_path, sub), exist_ok=True)

    # Buat file dart sesuai struktur
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

    print(f"✅ Modul '{module_name}' berhasil dibuat di '{full_path}'!")

if __name__ == "__main__":
    args = sys.argv[1:]

    if not args:
        print("❌ Gunakan perintah: python fastflow_cli.py <modul> [submodul]")
        sys.exit(1)

    if len(args) == 2:
        create_module(args[1], parent_module=args[0])  # Submodul
    else:
        create_module(args[0])  # Modul utama
