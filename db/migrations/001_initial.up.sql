CREATE TABLE demo_accounts (
  id bigint PRIMARY KEY,
  email text NOT NULL
);

CREATE TABLE demo_profiles (
  id bigint PRIMARY KEY,
  display_name text NOT NULL
);

CREATE TABLE demo_settings (
  id bigint PRIMARY KEY,
  value text NOT NULL
);

INSERT INTO demo_settings (id, value) VALUES (1, 'base');

CREATE TABLE demo_customers (
  id bigint PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE demo_purchases (
  id bigint PRIMARY KEY,
  customer_id bigint NOT NULL
);
