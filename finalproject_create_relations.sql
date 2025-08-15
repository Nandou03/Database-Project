CREATE TABLE Payment_method (
    payment_method_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(payment_method_id GLOB 'PAY[0-9]*'),
    payment_method_name VARCHAR(255) NOT NULL CHECK(payment_method_name IN ('Credit Card', 'Debit Card', 'Cash', 'PayPal')),
    payment_method_is_active VARCHAR(255) NOT NULL CHECK(payment_method_is_active IN ('Available', 'Not Available'))
);


CREATE TABLE Category (
    category_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(category_id GLOB 'CAT[0-9]*'),
    category_name VARCHAR(255) NOT NULL CHECK(category_name IN ('Pet Supplies', 'Health and Wellness', 'Pet Hygiene'))
);


CREATE TABLE Supplier (
    supplier_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(supplier_id GLOB 'SUP[0-9]*-*[0-9]*'),
    supplier_name VARCHAR(255) NOT NULL,
    supplier_contact_person VARCHAR(255) NOT NULL,
    supplier_phone_number VARCHAR(16) NOT NULL,
    supplier_email VARCHAR(255) NOT NULL CHECK(supplier_email LIKE '%@%'),
    supplier_address VARCHAR(255) NOT NULL
);

CREATE TABLE Employee (
    employee_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(employee_id GLOB 'EMP[0-9]*'),
    employee_first_name VARCHAR(255) NOT NULL,
    employee_last_name VARCHAR(255) NOT NULL,
    employee_position VARCHAR(255) NOT NULL,
    employee_hire_date TEXT NOT NULL CHECK (employee_hire_date LIKE '____-__-__') ,
    employee_salary DECIMAL(6, 2) NOT NULL CHECK(employee_salary >= 0),
    employee_contact_info VARCHAR(255) NOT NULL,
    employee_address VARCHAR(255) NOT NULL,
    employee_status VARCHAR(255) NOT NULL CHECK(employee_status IN ('Active', 'Inactive')),
    employee_employee_id VARCHAR(255),
    FOREIGN KEY (employee_employee_id) REFERENCES Employee(employee_id)
);


CREATE TABLE Client (
    client_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(client_id GLOB 'CLI[0-9]*'),
    client_first_name VARCHAR(255) NOT NULL,
    client_last_name VARCHAR(255) NOT NULL,
    client_email VARCHAR(255) NOT NULL CHECK(client_email LIKE '%@%'),
    client_phone_number VARCHAR(16) NOT NULL,
    client_address VARCHAR(255) NOT NULL
);


CREATE TABLE Product (
    product_sku VARCHAR(255) PRIMARY KEY NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description VARCHAR(255),
    product_price DECIMAL(6, 2) NOT NULL CHECK(product_price >= 0),
    product_piece_of_measurement VARCHAR(255),
    product_pet_specie VARCHAR(255) NOT NULL CHECK(product_pet_specie IN ('Dog', 'Cat', 'Bird', 'Reptile', 'Fish')),
    product_stock INTEGER NOT NULL,
    category_category_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (category_category_id) REFERENCES Category(category_id)
);


CREATE TABLE Inventory (
    inventory_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(inventory_id GLOB 'INV[0-9]*-*[0-9]*'),
    inventory_quantity_change INTEGER NOT NULL,
    inventory_movement_type VARCHAR(255) NOT NULL CHECK(inventory_movement_type IN ('Purchase', 'Return')),
    inventory_movement_date TEXT NOT NULL CHECK(inventory_movement_date LIKE '____-__-__ __:__:__'),
    product_product_sku VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_product_sku) REFERENCES Product(product_sku)
);


CREATE TABLE Supplier_purchase (
    supplier_purchase_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(supplier_purchase_id GLOB 'SP[0-9]*'),
    supplier_purchase_date TEXT NOT NULL CHECK (supplier_purchase_date LIKE '____-__-__'),
    supplier_purchase_amount DECIMAL(10, 2) NOT NULL CHECK(supplier_purchase_amount >= 0),
    supplier_supplier_id VARCHAR(255) NOT NULL,
    employee_employee_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (supplier_supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (employee_employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE Order_made (
	order_made_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(order_made_id GLOB 'ORD[0-9]*'),
    order_made_date TEXT NOT NULL CHECK(order_made_date LIKE '____-__-__ __:__:__'),
    order_made_status VARCHAR(255) NOT NULL CHECK(order_made_status IN ('Completed', 'Canceled')),
    order_made_total_amount DECIMAL(6, 2) NOT NULL CHECK(order_made_total_amount >= 0),
    client_client_id VARCHAR(255) NOT NULL,
    employee_employee_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (client_client_id) REFERENCES Client(client_id),
    FOREIGN KEY (employee_employee_id) REFERENCES Employee(employee_id)
);


CREATE TABLE Order_detail (
    order_detail_id VARCHAR(255) PRIMARY KEY NOT NULL CHECK(order_detail_id GLOB 'DET[0-9]*'),
    order_detail_quantity INTEGER NOT NULL CHECK(order_detail_quantity >= 0),
    order_detail_unit_cost DECIMAL(6, 2) NOT NULL CHECK(order_detail_unit_cost >= 0),
    product_product_sku VARCHAR(255) NOT NULL,
    order_made_order_made_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_product_sku) REFERENCES Product(product_sku),
    FOREIGN KEY (order_made_order_made_id) REFERENCES Order_made(order_made_id)
 );
 

CREATE TABLE Product_supplier_purchase (
    product_product_sku VARCHAR(255) NOT NULL,
    supplier_purchase_supplier_purchase_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (product_product_sku, supplier_purchase_supplier_purchase_id),
    FOREIGN KEY (product_product_sku) REFERENCES Product(product_sku),
    FOREIGN KEY (supplier_purchase_supplier_purchase_id) REFERENCES Supplier_purchase(supplier_purchase_id)
);


CREATE TABLE Client_payment_method (
    client_client_id VARCHAR(255) NOT NULL,
    payment_method_payment_method_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_client_id, payment_method_payment_method_id),
    FOREIGN KEY (client_client_id) REFERENCES Client(client_id),
    FOREIGN KEY (payment_method_payment_method_id) REFERENCES Payment_Method(payment_method_id)
);


CREATE INDEX idx_order_made_id ON Order_made(order_made_id);
CREATE INDEX idx_product_sku ON Product(product_sku);
CREATE INDEX idx_order_detail_product_sku ON Order_detail(product_product_sku);
CREATE INDEX idx_order_detail_order_made_id ON Order_detail(order_made_order_made_id);
CREATE INDEX idx_payment_method_id ON Payment_Method(payment_method_id);
CREATE INDEX idx_supplier_purchase_id ON Supplier_purchase(supplier_purchase_id);
CREATE INDEX idx_client_payment_method ON Client_payment_method(client_client_id, payment_method_payment_method_id);
