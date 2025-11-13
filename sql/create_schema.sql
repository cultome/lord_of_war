PRAGMA foreign_keys = ON;

-- Users

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL
);

-- Products

CREATE TABLE IF NOT EXISTS batteries (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS firing_modes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS imgs (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS licenses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS makers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS types (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS capacities (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS fps_ranges (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS gearboxes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS hop_ups (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS inner_barrels (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS magazines (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS motors (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS outer_barrels (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS speeds (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS systems (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS thread_directions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS products (
  id TEXT PRIMARY KEY,
  search_corpus TEXT NOT NULL,
  title TEXT NOT NULL,
  url TEXT NOT NULL,
  description TEXT,
  price DECIMAL,
  capacity_id TEXT,
  category_id TEXT,
  fps_range_id TEXT,
  gearbox_id TEXT,
  hop_up_id TEXT,
  inner_barrel_id TEXT,
  magazine_id TEXT,
  motor_id TEXT,
  outer_barrel_id TEXT,
  speed_id TEXT,
  system_id TEXT,
  thread_direction_id TEXT,
  FOREIGN KEY (capacity_id) REFERENCES capacities(id)
  FOREIGN KEY (category_id) REFERENCES categories(id)
  FOREIGN KEY (fps_range_id) REFERENCES fps_ranges(id)
  FOREIGN KEY (gearbox_id) REFERENCES gearboxes(id)
  FOREIGN KEY (hop_up_id) REFERENCES hop_ups(id)
  FOREIGN KEY (inner_barrel_id) REFERENCES inner_barrels(id)
  FOREIGN KEY (magazine_id) REFERENCES magazines(id)
  FOREIGN KEY (motor_id) REFERENCES motors(id)
  FOREIGN KEY (outer_barrel_id) REFERENCES outer_barrels(id)
  FOREIGN KEY (speed_id) REFERENCES speeds(id)
  FOREIGN KEY (system_id) REFERENCES systems(id)
  FOREIGN KEY (thread_direction_id) REFERENCES thread_directions(id)
);

CREATE TABLE IF NOT EXISTS products_batteries (
  product_id TEXT NOT NULL,
  battery_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (battery_id) REFERENCES batteries(id)
);

CREATE TABLE IF NOT EXISTS products_firing_modes (
  product_id TEXT NOT NULL,
  firing_mode_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (firing_mode_id) REFERENCES firing_modes(id)
);

CREATE TABLE IF NOT EXISTS products_imgs (
  product_id TEXT NOT NULL,
  img_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (img_id) REFERENCES imgs(id)
);

CREATE TABLE IF NOT EXISTS products_licenses (
  product_id TEXT NOT NULL,
  license_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (license_id) REFERENCES licenses(id)
);

CREATE TABLE IF NOT EXISTS products_makers (
  product_id TEXT NOT NULL,
  maker_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (maker_id) REFERENCES makers(id)
);

CREATE TABLE IF NOT EXISTS products_types (
  product_id TEXT NOT NULL,
  type_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (type_id) REFERENCES types(id)
);

-- Favs

CREATE TABLE IF NOT EXISTS favs (
  product_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Events

CREATE TABLE IF NOT EXISTS events (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  place_name TEXT,
  place_url TEXT,
  datetime DATETIME NOT NULL,
  desc BLOB,
  created_by TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (created_by ) REFERENCES users(id)
);

-- Listing
CREATE TABLE IF NOT EXISTS listings (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  desc TEXT,
  price DECIMAL,
  search_corpus TEXT NOT NULL,
  category_id TEXT,
  created_by TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (created_by ) REFERENCES users(id)
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS listings_imgs (
  listing_id TEXT NOT NULL,
  img_id TEXT NOT NULL,
  FOREIGN KEY (listing_id) REFERENCES listings(id)
  FOREIGN KEY (img_id) REFERENCES imgs(id)
);
