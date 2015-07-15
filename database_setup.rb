DB = SQLite3::Database.new("petstore.db")

DB.execute("CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY, type TEXT);")

DB.execute("CREATE TABLE IF NOT EXISTS locations (id INTEGER PRIMARY KEY, name TEXT, address TEXT, retail INTEGER);")

DB.execute("CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, category_id INTEGER, location_id INTEGER, name TEXT, cost FLOAT, quantity INTEGER);")

DB.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, email TEXT, password TEXT, auth_level INTEGER)")

DB.results_as_hash = true