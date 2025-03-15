import os

def create_structure(base_path):
    structure = {
        "lib": [
            "core/config", "core/services", "core/utils", "core/themes",
            "modules/auth/models", "modules/auth/views", "modules/auth/controllers", "modules/auth/services",
            "modules/home/models", "modules/home/views", "modules/home/controllers", "modules/home/services",
            "modules/transaction/models", "modules/transaction/views", "modules/transaction/controllers", "modules/transaction/services",
            "widgets", "routes", "data/models", "data/providers", "data/database"
        ],
        "lib/files": [
            "app.dart", "main.dart",
            "core/constants.dart", "routes/app_routes.dart",
            "modules/auth/auth_module.dart", "modules/home/home_module.dart", "modules/transaction/transaction_module.dart"
        ]
    }

    for folder in structure["lib"]:
        os.makedirs(os.path.join(base_path, folder), exist_ok=True)
    
    for file in structure["lib/files"]:
        file_path = os.path.join(base_path, file)
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                f.write("// $file\n")

    print("✅ Struktur FastFlow Flutter berhasil dibuat!")

if __name__ == "__main__":
    base_path = os.path.join(os.getcwd(), "lib")
    create_structure(base_path)