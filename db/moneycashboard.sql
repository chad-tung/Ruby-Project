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
    user_id INT8 REFERENCES users(id),
    initial FLOAT,
    remaining FLOAT
);

CREATE TABLE categories (
    id SERIAL8 PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE limits (
    id SERIAL8 PRIMARY KEY,
    user_id INT8 REFERENCES users(id),
    category_id INT8 REFERENCES categories(id),
    percentage FLOAT
);

CREATE TABLE vendors (
    id SERIAL8 PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE transactions (
    id SERIAL8 PRIMARY KEY,
    user_id INT8 REFERENCES users(id),
    category_id INT8 REFERENCES categories(id),
    vendor_id INT8 REFERENCES vendors(id),
    purchase_date DATE,
    amount_spent FLOAT
);
