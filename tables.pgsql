CREATE DATABASE "Dealership"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;



CREATE TABLE Customer (
 cust_id           SERIAL PRIMARY KEY,
 first_name        VARCHAR(30) NOT NULL,
 last_name         VARCHAR(30) NOT NULL,
 address           VARCHAR(50),
 phone             VARCHAR(20),
 email             VARCHAR(50) NOT NULL,
);

CREATE TABLE Part (
 part_no           VARCHAR(50) PRIMARY KEY,
 part_name         VARCHAR(200) NOT NULL,
 part_desc         VARCHAR(200),
 part_price        DECIMAL(8,2) NOT NULL
);

CREATE TABLE Labor (
 labor_id           SERIAL PRIMARY KEY,
 labor_desc         VARCHAR(200) NOT NULL,
 labor_rate         DECIMAL(6, 2) NOT NULL
);

CREATE TABLE Mechanic (
 mech_id           SERIAL PRIMARY KEY,
 first_name        VARCHAR(30) NOT NULL,
 last_name         VARCHAR(30) NOT NULL,
 phone             VARCHAR(20),
 email             VARCHAR(100) NOT NULL
);

CREATE TABLE Sales_Person (
 emp_id            SERIAL PRIMARY KEY,
 first_name        VARCHAR(30) NOT NULL,
 last_name         VARCHAR(30) NOT NULL,
 email             VARCHAR(50) NOT NULL,
 phone             VARCHAR(20)
);

CREATE TABLE Vehicle (
 vin               VARCHAR(60) PRIMARY KEY,
 make              VARCHAR(30) NOT NULL,
 model             VARCHAR(30) NOT NULL,
 veh_year          VARCHAR(20) NOT NULL,
 body_style        VARCHAR(20) NOT NULL,
 color             VARCHAR(20) NOT NULL,
 price             DECIMAL(8,2) NOT NULL
);

CREATE TABLE Service_Invoice (
 invoice_no        SERIAL PRIMARY KEY,
 cust_id           INTEGER NOT NULL,
 vin               VARCHAR(60) NOT NULL,
 veh_make          VARCHAR(30),
 veh_model         VARCHAR(30),
 veh_year          VARCHAR(20),
 veh_lic_plate     VARCHAR(10),      
 mech_id           INTEGER NOT NULL,
 labor_total       DECIMAL(8,2),
 parts_total       DECIMAL(8,2),
 inv_total         DECIMAL(8,2),
 serv_date         TIMESTAMP,
 serv_status       VARCHAR(40),
                   FOREIGN KEY (vin) REFERENCES Vehicle(vin),
                   FOREIGN KEY (mech_id) REFERENCES Mechanic(mech_id)
                   FOREIGN KEY (cust_id) REFERENCES Customer(cust_id)
);

CREATE TABLE Svc_Inv_Detail (
 detail_id          SERIAL PRIMARY KEY,
 serv_inv_no        INTEGER NOT NULL,
 labor_id           INTEGER NOT NULL,
 labor_quant        INTEGER NOT NULL,
 part_no            VARCHAR(50) NOT NULL,
 part_quant         INTEGER NOT NULL,
                    FOREIGN KEY (serv_inv_no) REFERENCES Service_Invoice(invoice_no),
                    FOREIGN KEY (labor_id) REFERENCES Labor(labor_id),
                    FOREIGN KEY (part_no) REFERENCES Part(part_no)
);

CREATE TABLE Sales_Invoice (
 inv_id             SERIAL PRIMARY KEY,
 sale_date          TIMESTAMP,
 sale_amount        DECIMAL(8,2),
 vin                VARCHAR(60),
 emp_id             INTEGER,
 cust_id            INTEGER,
                    FOREIGN KEY (emp_id) REFERENCES Sales_Person(emp_id),
                    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
                    FOREIGN KEY (vin) REFERENCES Vehicle(vin)
);



CREATE OR REPLACE FUNCTION add_customer(
    _first_name     VARCHAR,
    _last_name      VARCHAR,
    _address        VARCHAR,
    _phone          VARCHAR,
    _email          VARCHAR
)
RETURNS void
AS $$
BEGIN
    INSERT INTO customer
    VALUES(_first_name, _last_name, _address,_phone,_email);
END;
$$
LANGUAGE plpgsql;


SELECT add_customer('John','Smith','123 My Street, Tampa FL', '555-555-5555', 'john@mail.com');
SELECT add_customer('Sam','Kinison','579 Nu FuFu, Los Angeles CA', '222-123-4567', 'sam@mail.com');
SELECT add_customer('Jon','Bon Jovi','722 Navesink River Road, Red Bank NJ', '123-456-7890', 'john@mail.com');
SELECT add_customer('Corey','Taylor','5721 Pommel Ct, Wdm, IA', '727-232-4552', 'corey@mail.com');
SELECT add_customer('Jesse','Leach','3208 Noble Dr, Edmond, OK', '405-330-6747', 'jesse@mail.com');

CREATE OR REPLACE FUNCTION add_part(
    _part_name VARCHAR,
    _part_no VARCHAR,
    _part_desc VARCHAR,
    _part_price DECIMAL
)
RETURNS void 
AS $$
BEGIN
    INSERT INTO part
    VALUES(_part_name,_part_no,_part_desc,_part_price);
END;
$$
LANGUAGE plpgsql;


SELECT add_part(
    'Ford Performance Spark Plugs',
    'M-12405-M50A',
    'set of eight (8) Ford Motorcraft OEM Spark Plugs',
    219.95
);
SELECT add_part(
    'PowerStop OE Stock Replacement Rotor; Front',
    'AR8171',
    'PowerStop OE Stock Replacement Rotor',
    66.95
);
SELECT add_part(
    'Ford Performance High Performance 9mm Spark Plug Wires; Red',
    'M-12259-R462',
    'durable red silicone insulation with black silicone boots that are resistant to heat, fuel, oil, and solvents',
    89.99
);
SELECT add_part(
    'Performance Cylinder Head Gaskets',
    'M-6051-A302',
    'Head Gaskets, Composition Type, 4.100 in. Bore, .042 Compressed Thickness, Ford, 289/302/351W, Pair',
    219.95
);
SELECT add_part(
    'Dorman Plastic Intake Manifold',
    '615-175',
    'Dorman Plastic Intake Manifold - Includes Gaskets',
    223.99
);

CREATE OR REPLACE FUNCTION add_labor(
    _labor_desc VARCHAR,
    _labor_rate DECIMAL
)
RETURNS void 
AS $$
BEGIN
    INSERT INTO labor
    VALUES(_labor_desc,_labor_rate);
END;
$$
LANGUAGE plpgsql;


SELECT add_labor(
    'L1',
    45.00
);

SELECT add_labor(
    'L2',
    65.00
);

SELECT add_labor(
    'L3',
    85.00
);

SELECT add_labor(
    'Warranty',
    0
);

SELECT add_labor(
    'Complimentary',
    0
);


CREATE OR REPLACE FUNCTION add_mechanic(
    _mech_id INTEGER,
    _first_name VARCHAR,
    _last_name VARCHAR,
    _phone, VARCHAR,
    _email, VARCHAR
)
RETURNS void
AS $$
BEGIN
    INSERT INTO mechanic
    VALUES(_mech_id,_first_name, _last_name,_phone,_email);
END;
$$
LANGUAGE plpgsql;


SELECT add_mechanic(1,'Mike','Jones','333-555-1234','mike@gmail.com');
SELECT add_mechanic(2,'George','Maple','727-545-1334','george@hotmail.com');
SELECT add_mechanic(3,'Conrad','Foreina','727-455-3234','cfor@gmail.com');
SELECT add_mechanic(4,'James','Hartford','813-554-1246','jhart@aol.com');

CREATE OR REPLACE FUNCTION add_sales_person(
    _emp_id INTEGER,
    _first_name VARCHAR,
    _last_name VARCHAR,
    _email VARCHAR,
    _phone VARCHAR
)
RETURNS void
AS $$
BEGIN
    INSERT INTO sales_person
    VALUES(_emp_id,_first_name, _last_name,_email,_phone);
END;
$$
LANGUAGE plpgsql;


SELECT add_sales_person(1,'Michael','Himes','333-535-1234','michael@gmail.com');
SELECT add_sales_person(2,'John','Carpenter','727-575-1334','john@hotmail.com');
SELECT add_sales_person(3,'George','Carlin','727-445-3234','george@gmail.com');
SELECT add_sales_person(4,'Ken','Bradley','813-574-1246','ken@aol.com');

CREATE OR REPLACE FUNCTION add_vehicle(
    _vin VARCHAR,
    _make VARCHAR,
    _model VARCHAR,
    _veh_year VARCHAR,
    _body_style VARCHAR,
    _color VARCHAR,
    _price DECIMAL
)
RETURNS void
AS $$
BEGIN
    INSERT INTO vehicle
    VALUES(_vin,_make,_model,_veh_year,_body_style,_color,_price);
END;
$$
LANGUAGE plpgsql;


SELECT add_vehicle('4Y1SL65848Z411439','Ford','Mustang','2023','2DR','Black',32930);
SELECT add_vehicle('1FMEU7DE5AUA72472','Mini Cooper','Cooper S Electric','2023','2DR','Red',30895);
SELECT add_vehicle('WMWZN3C51BT133317','Mini Cooper','Cooper SE','2022','2DR','White',22741);
SELECT add_vehicle('1D7HA18D44J218509','Genesis','GV70','2023','4DR','Gunmetal',43150);
SELECT add_vehicle('JNKCV54E46M706213','Infinity','Q60','2022','Sport Sedan','Silver',27940);

CREATE OR REPLACE FUNCTION add_svc_invoice(
    _cust_id INTEGER,
    _vin VARCHAR,
    _mech_id INTEGER,
    _veh_make VARCHAR,
    _veh_model VARCHAR,
    _veh_year VARCHAR,
    _veh_lic VARCHAR,
    _labor_total DECIMAL(8,2),
    _parts_total DECIMAL(8,2),
    _inv_total DECIMAL(8,2),
    _serv_date DATETIME,
    _serv_status VARCHAR
)
RETURNS void
AS $$
BEGIN
    _labor_total = calc_labor_total(_labor_time,_labor_rate)
    _parts_total = calc_parts_total(_part_no,_part_quant)
    INSERT INTO service_invoice
    VALUES(_cust_id,_vin,_mech_id,veh_make,veh_model,veh_year,_veh_lic,_labor_total,_parts_total,_inv_total,_serv_date,_serv_status);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_sales_inv(
    _sale_date DATETIME,
    _sale_amt DECIMAL(8,2),
    _vin VARCHAR,
    _emp_id INTEGER,
    _cust_id INTEGER
)
RETURNS void
AS $$
BEGIN
    INSERT INTO sales_invoice
    VALUES(_sale_date,_sale_amt,_vin,_emp_id,_cust_id);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_svc_inv_detail(
    _svc_inv_no INTEGER,
    _labor_id INTEGER,
    _labor_quant INTEGER,
    _part_no VARCHAR,
    _part_quant INTEGER
)
RETURNS void
AS $$
BEGIN
    INSERT INTO svc_inv_detail
    VALUES(_svc_inv_no,_labor_id,_labor_quant,_part_no,_part_quant);
END;
$$
LANGUAGE plpgsql;

ALTER TABLE vehicle ADD COLUMN is_serviced BOOL