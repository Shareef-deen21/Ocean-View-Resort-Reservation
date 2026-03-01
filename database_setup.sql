-- ================================================================
--  OCEAN VIEW RESORT — MySQL Database Setup
--  Run this in MySQL Workbench or MySQL CLI:
--    source /path/to/database_setup.sql
-- ================================================================

CREATE DATABASE IF NOT EXISTS ocean_view_resort
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ocean_view_resort;

-- ── USERS (staff login) ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  full_name  VARCHAR(100) NOT NULL,
  role       VARCHAR(20)  NOT NULL DEFAULT 'STAFF',
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, full_name, role) VALUES
  ('admin', 'admin123',  'Admin Manager',    'ADMIN'),
  ('staff', 'staff123',  'Front Desk Staff',  'STAFF')
ON DUPLICATE KEY UPDATE username = username;

-- ── ROOMS ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rooms (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  room_number    VARCHAR(10)     NOT NULL UNIQUE,
  room_type      VARCHAR(30)     NOT NULL,
  rate_per_night DECIMAL(10,2)   NOT NULL,
  capacity       INT             NOT NULL DEFAULT 2,
  description    TEXT,
  status         VARCHAR(20)     NOT NULL DEFAULT 'AVAILABLE',
  floor_number   INT             NOT NULL DEFAULT 1
);

INSERT INTO rooms (room_number, room_type, rate_per_night, capacity, description, floor_number) VALUES
  ('101','STANDARD',   80.00, 2,'Comfortable standard room with garden view',    1),
  ('102','STANDARD',   80.00, 2,'Comfortable standard room with garden view',    1),
  ('103','STANDARD',   80.00, 2,'Comfortable standard room with garden view',    1),
  ('201','DELUXE',    130.00, 2,'Spacious deluxe room with city-view balcony',   2),
  ('202','DELUXE',    130.00, 2,'Spacious deluxe room with city-view balcony',   2),
  ('203','DELUXE',    130.00, 3,'Deluxe room with extra bed option',             2),
  ('301','OCEAN VIEW',160.00, 2,'Premium room with stunning ocean panorama',     3),
  ('302','OCEAN VIEW',160.00, 2,'Premium room with stunning ocean panorama',     3),
  ('401','FAMILY',    180.00, 4,'Large family room with two bedrooms',           4),
  ('402','FAMILY',    180.00, 5,'Extra-large family suite with living area',     4),
  ('501','SUITE',     200.00, 2,'Luxury suite with private jacuzzi & ocean view',5),
  ('502','SUITE',     200.00, 2,'Presidential suite with butler service',        5)
ON DUPLICATE KEY UPDATE room_number = room_number;

-- ── GUESTS ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS guests (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(150),
  phone       VARCHAR(20)  NOT NULL,
  address     TEXT,
  nationality VARCHAR(60),
  id_type     VARCHAR(30),
  id_number   VARCHAR(50),
  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- ── RESERVATIONS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reservations (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  reservation_number VARCHAR(20)   NOT NULL UNIQUE,
  guest_id           INT           NOT NULL,
  room_id            INT           NOT NULL,
  check_in_date      DATE          NOT NULL,
  check_out_date     DATE          NOT NULL,
  num_guests         INT           NOT NULL DEFAULT 1,
  total_amount       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status             VARCHAR(20)   NOT NULL DEFAULT 'CONFIRMED',
  special_requests   TEXT,
  created_at         TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  updated_at         TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (guest_id) REFERENCES guests(id),
  FOREIGN KEY (room_id)  REFERENCES rooms(id)
);

SELECT 'Database setup complete!' AS result;
SELECT COUNT(*) AS rooms_created FROM rooms;
