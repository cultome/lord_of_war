require 'sqlite3'

DB = SQLite3::Database.new 'low.db'
DB.results_as_hash = true
