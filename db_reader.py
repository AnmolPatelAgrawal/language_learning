import sqlite3

def list_tables(db_path):
    """
    Connects to an SQLite database and lists all tables.

    Args:
        db_path (str): The path to the SQLite database file.

    Returns:
        list: A list of table names, or None if an error occurs.
    """
    tables = []
    try:
        # Connect to the SQLite database
        # The connection will be automatically closed when exiting the 'with' block
        with sqlite3.connect(db_path) as conn:
            cursor = conn.cursor()

            # Query to get all table names from the sqlite_master table
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            
            # Fetch all results
            tables_data = cursor.fetchall()
            
            # Extract table names from the tuples
            tables = [table[0] for table in tables_data]
            
            print(f"Tables found in '{db_path}': {tables}")
            return tables

    except sqlite3.Error as e:
        print(f"SQLite error while listing tables: {e}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred while listing tables: {e}")
        return None

def read_table_data(db_path, table_name):
    """
    Reads all data from a specified table in an SQLite database.

    Args:
        db_path (str): The path to the SQLite database file.
        table_name (str): The name of the table to read from.
    """
    try:
        with sqlite3.connect(db_path) as conn:
            cursor = conn.cursor()

            # Secure way to build the query, though for table names, direct
            # insertion is often used. Be very careful if table_name comes
            # from untrusted input.
            # For this example, we assume table_name is safe.
            query = f"SELECT * FROM {table_name}"
            print(f"\nExecuting query: {query} on table '{table_name}'")
            cursor.execute(query)

            # Get column names
            column_names = [description[0] for description in cursor.description]
            print(f"Columns: {column_names}")

            # Fetch all rows from the table
            rows = cursor.fetchall()

            if not rows:
                print(f"No data found in table '{table_name}'.")
                return

            print(f"\nData from table '{table_name}':")
            for i, row in enumerate(rows):
                print(f"Row {i+1}: {row}")
                # You can also print it in a more structured way:
                # for col_name, value in zip(column_names, row):
                #     print(f"  {col_name}: {value}")
                # print("-" * 20)


    except sqlite3.Error as e:
        # Handle specific errors like "no such table"
        if "no such table" in str(e).lower():
            print(f"SQLite error: Table '{table_name}' does not exist in '{db_path}'.")
        else:
            print(f"SQLite error while reading table '{table_name}': {e}")
    except Exception as e:
        print(f"An unexpected error occurred while reading table '{table_name}': {e}")

# --- Example Usage ---
if __name__ == "__main__":
    # Replace 'your_database_file.db' with the actual path to your .db file
    # For example, if your file is in the same directory as the script:
    # db_file = "sample_database.db" 
    # Or provide a full path:
    # db_file = "/path/to/your/sample_database.db"
    # db_file = "C:\\Users\\YourUser\\Downloads\\sample_database.db"
    
    db_file = "sample.db" # <<< CHANGE THIS TO YOUR ACTUAL DB FILE PATH

    print(f"Attempting to read database: {db_file}")

    # 1. List all tables in the database
    available_tables = list_tables(db_file)

    # 2. If tables exist, try reading data from one of them
    if available_tables:
        # Replace 'your_table_name' with the actual table name you want to read
        # For example, if your Flutter app created a 'game_results' table:
        table_to_read = "game_results" # <<< CHANGE THIS IF YOUR TABLE NAME IS DIFFERENT

        if table_to_read in available_tables:
            read_table_data(db_file, table_to_read)
        else:
            print(f"\nTable '{table_to_read}' not found in the database.")
            if available_tables:
                print(f"Perhaps you meant one of these: {available_tables}")
    else:
        print(f"Could not retrieve table list from '{db_file}'. Ensure the path is correct and it's a valid SQLite file.")