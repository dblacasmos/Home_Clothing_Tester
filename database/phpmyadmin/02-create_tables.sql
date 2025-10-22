-- Crear base de datos de configuración de phpMyAdmin
CREATE DATABASE IF NOT EXISTS phpmyadmin DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE phpmyadmin;

CREATE TABLE IF NOT EXISTS pma__bookmark (
    id INT AUTO_INCREMENT PRIMARY KEY,
    db_name VARCHAR(64) NOT NULL,
    table_name VARCHAR(64) NOT NULL,
    bookmark VARCHAR(64) NOT NULL,
    query TEXT NOT NULL,
    UNIQUE KEY (db_name, table_name, bookmark)
);

CREATE TABLE IF NOT EXISTS pma__relation (
    master_db VARCHAR(64) NOT NULL,
    master_table VARCHAR(64) NOT NULL,
    master_field VARCHAR(64) NOT NULL,
    foreign_db VARCHAR(64) NOT NULL,
    foreign_table VARCHAR(64) NOT NULL,
    foreign_field VARCHAR(64) NOT NULL,
    display_field VARCHAR(64),
    PRIMARY KEY (master_db, master_table, master_field)
);

CREATE TABLE IF NOT EXISTS pma__table_info (
    db_name VARCHAR(64) NOT NULL,
    table_name VARCHAR(64) NOT NULL,
    display_field VARCHAR(64),
    PRIMARY KEY (db_name, table_name)
);

CREATE TABLE IF NOT EXISTS pma__table_coords (
    db_name VARCHAR(64) NOT NULL,
    table_name VARCHAR(64) NOT NULL,
    pdf_page_number INT NOT NULL DEFAULT 0,
    x INT NOT NULL,
    y INT NOT NULL,
    PRIMARY KEY (db_name, table_name, pdf_page_number)
);

CREATE TABLE IF NOT EXISTS pma__pdf_pages (
    db_name VARCHAR(64) NOT NULL,
    page_number INT NOT NULL,
    page_descr VARCHAR(50) NOT NULL,
    PRIMARY KEY (db_name, page_number)
);

CREATE TABLE IF NOT EXISTS pma__column_info (
    db_name VARCHAR(64) NOT NULL,
    table_name VARCHAR(64) NOT NULL,
    column_name VARCHAR(64) NOT NULL,
    comment TEXT,
    mimetype VARCHAR(255),
    transformation VARCHAR(255),
    transformation_options TEXT,
    PRIMARY KEY (db_name, table_name, column_name)
);

CREATE TABLE IF NOT EXISTS pma__history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL,
    db VARCHAR(64) NOT NULL,
    table_name VARCHAR(64),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sql_query TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__recent (
    username VARCHAR(64) NOT NULL,
    tables TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__favorite (
    username VARCHAR(64) NOT NULL,
    tables TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__users (
    username VARCHAR(64) NOT NULL,
    usergroup VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__usergroups (
    usergroup VARCHAR(64) NOT NULL,
    tab VARCHAR(64) NOT NULL,
    allowed TINYINT(1) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS pma__navigationhiding (
    username VARCHAR(64) NOT NULL,
    item_name VARCHAR(64) NOT NULL,
    item_type VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__savedsearches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL,
    db_name VARCHAR(64) NOT NULL,
    search_name VARCHAR(64) NOT NULL,
    search_data TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__central_columns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    type TEXT NOT NULL,
    length TEXT,
    collation TEXT,
    is_nullable TINYINT(1) NOT NULL DEFAULT 1,
    default_value TEXT,
    extra TEXT,
    comment TEXT
);

CREATE TABLE IF NOT EXISTS pma__designer_settings (
    username VARCHAR(64) NOT NULL,
    settings_data TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS pma__export_templates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL,
    export_type VARCHAR(10) NOT NULL,
    template_name VARCHAR(64) NOT NULL,
    template_data TEXT NOT NULL
);