### How to extract data from your device?

1. Move the file from app to PC
```cmd
./adb -s emulator-5554 exec-out run-as com.example.welcome_app cat databases/20250509_040904_320.db > ~/Downloads/sample_database.db
```
cat databases/file_name.db > "wherever you want to store in your pc."

file_name is available in debug_console. 

2. Read the file using Python
db_reader.py