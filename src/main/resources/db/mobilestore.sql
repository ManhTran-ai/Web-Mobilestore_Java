-- ============================================================
-- Mobile Store - Database Schema & Sample Data
-- Safe to run on existing database (preserves all existing data)
-- ============================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ============================================================
-- 1. Create missing tables (IF NOT EXISTS - won't affect existing)
-- ============================================================

-- users
CREATE TABLE IF NOT EXISTS users (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    password        VARCHAR(255)    NULL,
    username        VARCHAR(50)     NOT NULL,
    role_name       VARCHAR(20)     DEFAULT 'CUSTOMER',
    oauth_provider  VARCHAR(20)     NULL,
    oauth_id        VARCHAR(255)    NULL,
    email           VARCHAR(100)    NULL,
    shipping_address TEXT           NULL,
    customer_phone  VARCHAR(20)     NULL,
    note            TEXT            NULL,
    district_id     INT             NULL,
    ward_code       VARCHAR(20)     NULL,
    UNIQUE KEY UK_username (username),
    UNIQUE KEY UK_email (email),
    KEY idx_users_role (role_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- categories
CREATE TABLE IF NOT EXISTS categories (
    category_id    INT           AUTO_INCREMENT PRIMARY KEY,
    category_name  VARCHAR(100)  NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- products
CREATE TABLE IF NOT EXISTS products (
    product_id        INT           AUTO_INCREMENT PRIMARY KEY,
    manufacturer      VARCHAR(100)  NOT NULL,
    product_name      VARCHAR(255)  NOT NULL,
    product_condition VARCHAR(50)   NOT NULL,
    product_info     TEXT           NULL,
    category_id      INT           NOT NULL,
    discount         INT           DEFAULT 0,
    KEY idx_products_category (category_id),
    KEY idx_products_name (product_name(100)),
    CONSTRAINT FK_products_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- product_variants
CREATE TABLE IF NOT EXISTS product_variants (
    variant_id          INT           AUTO_INCREMENT PRIMARY KEY,
    product_id          INT           NOT NULL,
    color               VARCHAR(50)   NULL,
    storage             VARCHAR(20)   NULL,
    price               BIGINT        NOT NULL,
    quantity_in_stock   INT           NOT NULL DEFAULT 0,
    variant_image       VARCHAR(255)  NULL,
    KEY idx_variants_product (product_id),
    CONSTRAINT FK_variants_product FOREIGN KEY (product_id)
        REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- orders
CREATE TABLE IF NOT EXISTS orders (
    order_id           INT           AUTO_INCREMENT PRIMARY KEY,
    order_status       VARCHAR(30)   DEFAULT 'PENDING',
    order_date         DATETIME(6)   NULL,
    total_amount       BIGINT        NULL,
    user_id            INT           NULL,
    shipping_address   TEXT          NULL,
    customer_phone     VARCHAR(20)   NULL,
    note               TEXT          NULL,
    payment_method     VARCHAR(20)   DEFAULT 'CASH',
    payment_status     VARCHAR(20)   DEFAULT 'PENDING',
    vnp_transaction_id VARCHAR(100)  NULL,
    vnp_order_id       VARCHAR(100)  NULL,
    shipping_cost      DOUBLE        NULL,
    district_id        INT           NULL,
    ward_code          VARCHAR(20)   NULL,
    tracking_number    VARCHAR(100)  NULL,
    KEY idx_orders_user (user_id),
    KEY idx_orders_status (order_status),
    KEY idx_orders_date (order_date),
    CONSTRAINT FK_orders_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- order_details
CREATE TABLE IF NOT EXISTS order_details (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    price       DOUBLE    NULL,
    quantity    INT       NULL,
    order_id    INT       NOT NULL,
    variant_id  INT       NOT NULL,
    KEY idx_order_details_order (order_id),
    KEY idx_order_details_variant (variant_id),
    CONSTRAINT FK_details_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_details_variant FOREIGN KEY (variant_id)
        REFERENCES product_variants(variant_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- cart
CREATE TABLE IF NOT EXISTS cart (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    quantity    INT       NULL,
    variant_id  INT       NULL,
    user_id     INT       NULL,
    KEY idx_cart_user (user_id),
    KEY idx_cart_variant (variant_id),
    CONSTRAINT FK_cart_variant FOREIGN KEY (variant_id)
        REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    CONSTRAINT FK_cart_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- user_likes (wishlist)
CREATE TABLE IF NOT EXISTS user_likes (
    id           INT       AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT       NOT NULL,
    product_id   INT       NOT NULL,
    UNIQUE KEY UK_like (customer_id, product_id),
    KEY idx_likes_customer (customer_id),
    KEY idx_likes_product (product_id),
    CONSTRAINT FK_likes_customer FOREIGN KEY (customer_id)
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT FK_likes_product FOREIGN KEY (product_id)
        REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- password_reset_tokens
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    token       VARCHAR(255) NOT NULL,
    user_id     INT       NOT NULL,
    email       VARCHAR(255) NOT NULL,
    expires_at  DATETIME  NOT NULL,
    used        TINYINT(1) DEFAULT 0,
    created_at  DATETIME  DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY UK_reset_token (token),
    KEY idx_reset_user (user_id),
    CONSTRAINT FK_reset_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- slider_images
CREATE TABLE IF NOT EXISTS slider_images (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    image_url   VARCHAR(500) NOT NULL,
    is_active   TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. Add missing columns to existing tables
--    Uses conditional ALTER to avoid errors if column already exists
-- ============================================================

-- Add missing columns to users
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'district_id') = 0,
    'ALTER TABLE users ADD COLUMN district_id INT NULL AFTER note',
    'SELECT 1'
));
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'ward_code') = 0,
    'ALTER TABLE users ADD COLUMN ward_code VARCHAR(20) NULL AFTER district_id',
    'SELECT 1'
));
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add missing columns to orders
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'orders' AND COLUMN_NAME = 'shipping_cost') = 0,
    'ALTER TABLE orders ADD COLUMN shipping_cost DOUBLE NULL AFTER vnp_order_id',
    'SELECT 1'
));
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'orders' AND COLUMN_NAME = 'district_id') = 0,
    'ALTER TABLE orders ADD COLUMN district_id INT NULL AFTER shipping_cost',
    'SELECT 1'
));
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'orders' AND COLUMN_NAME = 'ward_code') = 0,
    'ALTER TABLE orders ADD COLUMN ward_code VARCHAR(20) NULL AFTER district_id',
    'SELECT 1'
));
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'orders' AND COLUMN_NAME = 'tracking_number') = 0,
    'ALTER TABLE orders ADD COLUMN tracking_number VARCHAR(100) NULL AFTER ward_code',
    'SELECT 1'
));
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ============================================================
-- 3. Insert sample data (ON DUPLICATE KEY UPDATE preserves existing)
-- ============================================================

-- Categories
INSERT INTO categories (category_id, category_name) VALUES
    (1, 'Mobile'),
    (2, 'Tablet')
ON DUPLICATE KEY UPDATE category_name = VALUES(category_name);

-- Products
INSERT INTO products (product_id, manufacturer, product_name, product_condition, product_info, category_id, discount) VALUES
    (10, 'APPLE', 'iPhone 17 Pro', 'Mới', 'iPhone 17 – Chip A19 Pro manh me, man hinh Super Retina XDR 6.3", camera 48MP, pin 4500mAh, sac nhanh USB-C.', 1, 20),
    (11, 'APPLE', 'iPhone 15 Pro', 'Mới', '', 1, 30),
    (12, 'APPLE', 'iPhone XR',    'Mới', '', 1, 50),
    (13, 'APPLE', 'iPhone 11',    'Mới', '', 1, 60),
    (14, 'APPLE', 'iPhone 13',   'Mới', '', 1, 30),
    (15, 'APPLE', 'iPhone 14',   'Mới', '', 1, 20),
    (16, 'APPLE', 'iPhone 14 Pro', 'Mới', '', 1, 0),
    (17, 'APPLE', 'iPhone 15',    'Mới', '', 1, 0),
    (18, 'APPLE', 'iPhone 15 Pro Max', 'Mới', '', 1, 0),
    (19, 'APPLE', 'iPhone 16',    'Mới', '', 1, 0),
    (20, 'APPLE', 'iPhone 16 Plus', 'Mới', '', 1, 0),
    (21, 'APPLE', 'iPhone 17',    'Mới', '', 1, 0),
    (23, 'APPLE', 'iPad Gen 10',  'Mới', '', 2, 0),
    (24, 'APPLE', 'iPad Air 5 M1', 'Mới', '', 2, 0),
    (25, 'APPLE', 'iPad Gen 9',   'Mới', '', 2, 0),
    (26, 'APPLE', 'iPad Pro M4',  'Mới', '', 2, 0),
    (27, 'APPLE', 'iPad Air M2',  'Mới', '', 2, 0),
    (28, 'APPLE', 'iPad mini 7',  'Mới', '', 2, 0),
    (29, 'APPLE', 'iPad mini 6',  'Mới', '', 2, 0),
    (30, 'APPLE', 'iPhone 12',    'Mới', '', 1, 0),
    (31, 'APPLE', 'iPhone 16e',   'Mới', '', 1, 0),
    (32, 'APPLE', 'iPad M4 Pro',  'Mới', '', 2, 0),
    (33, 'APPLE', 'iPad M5 Pro',  'Mới', '', 2, 0)
ON DUPLICATE KEY UPDATE
    manufacturer = VALUES(manufacturer),
    product_name = VALUES(product_name),
    product_condition = VALUES(product_condition),
    product_info = VALUES(product_info),
    category_id = VALUES(category_id),
    discount = VALUES(discount);

-- Product Variants
INSERT INTO product_variants (variant_id, product_id, color, storage, price, quantity_in_stock, variant_image) VALUES
    (1,  10, 'Natural Titanium', '128GB', 12000000,  5, 'images/products/e0dd45b7-58e3-4382-8612-ff268fe06921.png'),
    (9,  11, 'Natural Titanium', '128GB', 25000000,  3, 'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),
    (10, 11, 'Blue Titanium',    '128GB', 25000000,  3, 'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),
    (11, 11, 'White Titanium',   '128GB', 25000000,  2, 'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),
    (12, 11, 'Black Titanium',  '128GB', 25000000,  2, 'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),
    (13, 12, 'Black',           '64GB',   7000000, 20, 'images/products/01d57027-ac66-4333-9098-38ee7861c181.png'),
    (14, 12, 'White',           '64GB',   7000000, 15, 'images/products/01d57027-ac66-4333-9098-38ee7861c181.png'),
    (15, 12, 'Blue',            '64GB',   7000000, 15, 'images/products/01d57027-ac66-4333-9098-38ee7861c181.png'),
    (16, 13, 'Black',           '64GB',   9000000, 20, 'images/products/2ff2f283-7386-4e96-a91c-6d89ef259bbe.png'),
    (17, 13, 'White',           '64GB',   9000000, 15, 'images/products/2ff2f283-7386-4e96-a91c-6d89ef259bbe.png'),
    (18, 13, 'Green',           '64GB',   9000000, 15, 'images/products/2ff2f283-7386-4e96-a91c-6d89ef259bbe.png'),
    (19, 14, 'Midnight',        '128GB', 13000000, 15, 'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),
    (20, 14, 'Starlight',       '128GB', 13000000, 10, 'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),
    (21, 14, 'Blue',            '128GB', 13000000,  8, 'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),
    (22, 14, 'Pink',            '128GB', 13000000,  7, 'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),
    (23, 14, 'Midnight',        '256GB', 15500000,  5, 'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),
    (24, 15, 'Midnight',        '128GB', 15000000,  8, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (25, 15, 'Purple',          '128GB', 15000000,  8, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (26, 15, 'Blue',           '128GB', 15000000,  7, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (27, 15, 'Starlight',       '128GB', 15000000,  7, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (28, 15, 'Midnight',       '256GB', 18000000,  5, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (29, 15, 'Purple',          '256GB', 18000000,  5, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (30, 15, 'Blue',           '256GB', 18000000,  4, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (31, 15, 'Yellow',         '256GB', 18000000,  3, 'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),
    (32, 16, 'Deep Purple',     '128GB', 19000000, 10, 'images/products/51319fad-853d-4cd3-9f65-2da560db816a.png'),
    (33, 16, 'Gold',            '128GB', 19000000,  8, 'images/products/51319fad-853d-4cd3-9f65-2da560db816a.png'),
    (34, 16, 'Silver',          '128GB', 19000000,  7, 'images/products/51319fad-853d-4cd3-9f65-2da560db816a.png'),
    (35, 17, 'Black',           '128GB', 18000000, 10, 'images/products/0b7a70ec-43ce-48d4-b1f4-acf7a28b2ab3.png'),
    (36, 17, 'Pink',            '128GB', 18000000, 10, 'images/products/0b7a70ec-43ce-48d4-b1f4-acf7a28b2ab3.png'),
    (37, 17, 'Green',           '128GB', 18000000, 10, 'images/products/0b7a70ec-43ce-48d4-b1f4-acf7a28b2ab3.png'),
    (38, 18, 'Natural Titanium', '256GB', 28000000,  8, 'images/products/33aca89a-fbc1-4921-829c-4e5b9137d9eb.png'),
    (39, 18, 'Blue Titanium',   '256GB', 28000000,  7, 'images/products/33aca89a-fbc1-4921-829c-4e5b9137d9eb.png'),
    (40, 18, 'White Titanium', '256GB', 28000000,  5, 'images/products/33aca89a-fbc1-4921-829c-4e5b9137d9eb.png'),
    (41, 19, 'Black',           '128GB', 22000000, 15, 'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),
    (42, 19, 'White',           '128GB', 22000000, 15, 'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),
    (43, 19, 'Blue',            '128GB', 22000000, 10, 'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),
    (44, 19, 'Teal',            '128GB', 22000000, 10, 'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),
    (45, 20, 'Black',           '128GB', 24000000, 10, 'images/products/5a37c593-51bf-4b7b-adbc-d0bfcd620f8e.png'),
    (46, 20, 'White',           '128GB', 24000000, 10, 'images/products/5a37c593-51bf-4b7b-adbc-d0bfcd620f8e.png'),
    (47, 20, 'Blue',            '128GB', 24000000, 10, 'images/products/5a37c593-51bf-4b7b-adbc-d0bfcd620f8e.png'),
    (48, 21, 'Black',           '128GB', 26000000, 30, 'images/products/37d3c899-1025-4bc7-9ee8-7be45be18952.png'),
    (49, 21, 'White',           '128GB', 26000000, 25, 'images/products/1ecdc28a-6a10-4bec-a7d6-6ad8a89af80a.png'),
    (50, 21, 'Blue',            '128GB', 26000000, 25, 'images/products/09dea404-f0c6-444e-b1f0-9578f30c96f6.png'),
    (51, 21, 'Teal',            '128GB', 26000000, 20, 'images/products/1ecdc28a-6a10-4bec-a7d6-6ad8a89af80a.png'),
    (52, 23, 'Silver',          '64GB',  10500000, 20, 'images/products/b6dc74a6-da46-467d-aaa5-533b18c859fa.png'),
    (53, 23, 'Blue',            '64GB',  10500000, 20, 'images/products/b6dc74a6-da46-467d-aaa5-533b18c859fa.png'),
    (54, 24, 'Space Gray',      '64GB',  14500000, 10, 'images/products/0af0a633-b612-4218-b042-ef822e99264f.png'),
    (55, 24, 'Starlight',      '64GB',  14500000,  7, 'images/products/0af0a633-b612-4218-b042-ef822e99264f.png'),
    (56, 24, 'Blue',            '64GB',  14500000,  5, 'images/products/0af0a633-b612-4218-b042-ef822e99264f.png'),
    (57, 25, 'Space Gray',      '64GB',   7500000, 25, 'images/products/de33773e-bc38-46c8-a7f0-cd1e7e71d655.png'),
    (58, 25, 'Silver',          '64GB',   7500000, 25, 'images/products/de33773e-bc38-46c8-a7f0-cd1e7e71d655.png'),
    (59, 26, 'Silver',          '256GB', 29000000,  7, 'images/products/prom4.png'),
    (60, 26, 'Space Black',     '256GB', 29000000,  7, 'images/products/prom4.png'),
    (61, 27, 'Space Gray',      '128GB', 17000000,  8, 'images/products/0c334961-a3e2-4b40-93f1-b45bce5ce52a.png'),
    (62, 27, 'Starlight',       '128GB', 17000000,  5, 'images/products/0c334961-a3e2-4b40-93f1-b45bce5ce52a.png'),
    (63, 27, 'Blue',            '128GB', 17000000,  5, 'images/products/0c334961-a3e2-4b40-93f1-b45bce5ce52a.png'),
    (64, 28, 'Space Gray',      '128GB', 15000000, 10, 'images/products/mini7.png'),
    (65, 28, 'Starlight',       '128GB', 15000000,  9, 'images/products/mini7.png'),
    (66, 29, 'Space Gray',      '64GB',  25000000, 15, 'images/products/mini_6.png'),
    (67, 29, 'Purple',          '64GB',  25000000, 13, 'images/products/mini_6.png'),
    (68, 30, 'Blue',            '64GB',  12500000, 10, 'images/products/12.png'),
    (69, 30, 'Black',           '64GB',  12500000,  8, 'images/products/12.png'),
    (70, 30, 'White',           '64GB',  12500000,  8, 'images/products/12.png'),
    (71, 31, 'Black',           '128GB', 15000000,  4, 'images/products/16e.png'),
    (72, 31, 'White',           '128GB', 15000000,  4, 'images/products/16e.png'),
    (73, 31, 'Red',             '128GB', 15000000,  4, 'images/products/16e.png'),
    (74, 32, 'Silver',          '256GB', 50000000, 50, 'images/products/4eef0b69-5658-4014-b9ff-d65881d378b3.png'),
    (75, 32, 'Space Black',     '256GB', 50000000, 50, 'images/products/4eef0b69-5658-4014-b9ff-d65881d378b3.png'),
    (76, 33, 'Silver',          '128GB', 20000000, 20, 'images/products/07fb6758-a24f-4993-8141-92dcbe635838.png'),
    (77, 33, 'Space Black',     '128GB', 20000000, 25, 'images/products/07fb6758-a24f-4993-8141-92dcbe635838.png'),
    (78, 10, 'Blue Titanium',   '128GB', 12000000, 10, 'images/products/96aee917-a333-496d-94e3-4a30eb4c2930.png')
ON DUPLICATE KEY UPDATE
    color = VALUES(color),
    storage = VALUES(storage),
    price = VALUES(price),
    quantity_in_stock = VALUES(quantity_in_stock),
    variant_image = VALUES(variant_image);

-- Users
INSERT INTO users (id, password, username, role_name, oauth_provider, oauth_id, email, shipping_address, customer_phone, note, district_id, ward_code) VALUES
    (5, '$2a$10$342ro1UObsU/8YP0Dy1HNOQ92Fxy3hYI/KLTc0ygh7j5Q6NyeIyP6', 'levantai',   'ADMIN',     NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
    (6, '$2a$10$w0KzLYHDgs5PI0Q4r3BjRu9RM3UbNa4IHSnfIb74KrHsTAlOnRfzW', 'manh',       'CUSTOMER',  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
    (7, '$2a$10$bj4SkPMUK3jTJ7FD.9blzeYmCo.bUF5vd1wJVh2ldpIxQ8F5DHetG', 'hung',       'CUSTOMER',  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
    (8, NULL, 'tai1', 'CUSTOMER', 'google', '116054212909485433236', 'levantai066@gmail.com', NULL, NULL, NULL, NULL, NULL),
    (9, NULL, 'tai2', 'CUSTOMER', 'google', '110613103348013667969', '23130283@st.hcmuaf.edu.vn', NULL, NULL, NULL, NULL, NULL),
    (13,'$2a$10$KmcjsGN/04htrhRedfIIO.RqacQC3kU9NuhK0Dk84F6P0z7ifEP4K', 'manh1', 'CUSTOMER', NULL, NULL, 'manht7000@gmail.com', NULL, NULL, NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE
    password = COALESCE(NULLIF(VALUES(password), password), password),
    username = VALUES(username),
    role_name = VALUES(role_name),
    oauth_provider = VALUES(oauth_provider),
    oauth_id = VALUES(oauth_id),
    email = VALUES(email),
    shipping_address = COALESCE(VALUES(shipping_address), shipping_address),
    customer_phone = COALESCE(VALUES(customer_phone), customer_phone),
    note = COALESCE(VALUES(note), note),
    district_id = COALESCE(VALUES(district_id), district_id),
    ward_code = COALESCE(VALUES(ward_code), ward_code);

-- Slider Images
INSERT INTO slider_images (id, image_url, is_active) VALUES
    (1, 'images/slider/slider-iphone16.jpg', 1),
    (2, 'images/slider/slider-ipad.jpg', 1),
    (3, 'images/slider/slider-sale.jpg', 1),
    (4, 'images/slider/slider-watch.jpg', 1),
    (5, 'images/slider/slider-new.jpg', 1)
ON DUPLICATE KEY UPDATE
    image_url = VALUES(image_url),
    is_active = VALUES(is_active);
