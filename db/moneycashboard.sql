DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS limits;
DROP TABLE IF EXISTS budgets;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL8 PRIMARY KEY,
    name VARCHAR(255),
    goals VARCHAR(255)
);

CREATE TABLE budgets (
    id SERIAL8 PRIMARY KEY,
    user_id INT8 REFERENCES users(id) ON DELETE CASCADE,
    initial FLOAT,
    remaining FLOAT
);

CREATE TABLE categories (
    id SERIAL8 PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE limits (
    id SERIAL8 PRIMARY KEY,
    user_id INT8 REFERENCES users(id) ON DELETE CASCADE,
    category_id INT8 REFERENCES categories(id) ON DELETE CASCADE,
    percentage FLOAT
);

CREATE TABLE vendors (
    id SERIAL8 PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE transactions (
    id SERIAL8 PRIMARY KEY,
    user_id INT8 REFERENCES users(id) ON DELETE CASCADE,
    category_id INT8 REFERENCES categories(id) ON DELETE CASCADE,
    vendor_id INT8 REFERENCES vendors(id) ON DELETE CASCADE,
    purchase_date DATE,
    amount_spent FLOAT
);
