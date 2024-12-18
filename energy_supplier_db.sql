CREATE DATABASE IF NOT EXISTS energy_supplier_db;

USE energy_supplier_db;

-- Address Table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_name VARCHAR(255) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    state VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Customer Table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(50),
    status ENUM('active', 'inactive') DEFAULT 'active',
    address_id INT NOT NULL,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Product Table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_type ENUM('electricity', 'gas') DEFAULT 'electricity' NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Account Table
CREATE TABLE account (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_number VARCHAR(50) UNIQUE,
    created_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','closed','suspended') DEFAULT 'active',
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Contract Table
CREATE TABLE contract (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    product_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    contract_status ENUM('active', 'terminated', 'pending') DEFAULT 'active',
    FOREIGN KEY (account_id) REFERENCES account(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bill Table
CREATE TABLE bill (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    billing_period_start DATE NOT NULL,
    billing_period_end DATE NOT NULL,
    bill_issue_date DATE NOT NULL,
    bill_due_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    bill_status ENUM('issued', 'paid', 'overdue') DEFAULT 'issued',
    FOREIGN KEY (account_id) REFERENCES account(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bill Item Table
CREATE TABLE bill_item (
    bill_item_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    description VARCHAR(256) NOT NULL,
    quantity DECIMAL(8,4) NOT NULL,
    unit_price DECIMAL(10,4) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES bill(bill_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payment Table
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('bank_transfer', 'credit_card') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    confirmation_number VARCHAR(100),
    FOREIGN KEY (bill_id) REFERENCES bill(bill_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Insert into address
INSERT INTO address (street_name, postal_code, state, country)
VALUES ('123 Main St', '12345', 'Stateville', 'Countryland');

-- Insert into customer
INSERT INTO customer (first_name, last_name, date_of_birth, email, phone_number, status, address_id)
VALUES ('John', 'Doe', '1985-05-15', 'john.doe@example.com', '555-1234', 'active', 1);

-- Insert into product
INSERT INTO product (product_name, product_type)
VALUES ('Residential Electricity', 'electricity');

-- Insert into account
INSERT INTO account (customer_id, account_number, status)
VALUES (1, 'ACC1001', 'active');

-- Insert into contract
INSERT INTO contract (account_id, product_id, start_date, contract_status)
VALUES (1, 1, '2024-01-01', 'active');

-- Insert into bill
INSERT INTO bill (account_id, billing_period_start, billing_period_end, bill_issue_date, bill_due_date, total_amount, bill_status)
VALUES (1, '2024-01-01', '2024-01-31', '2024-02-01', '2024-02-15', 100.00, 'issued');

-- Insert into bill_item
INSERT INTO bill_item (bill_id, description, quantity, unit_price)
VALUES (1, 'Electricity Usage January', 1000.0000, 0.10);

-- Insert into payment
INSERT INTO payment (bill_id, payment_method, amount, confirmation_number)
VALUES (1, 'credit_card', 100.00, 'CONF123456');

