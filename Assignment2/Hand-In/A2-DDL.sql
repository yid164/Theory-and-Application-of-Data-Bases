-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT355


-- The company table to record the company's name and id
CREATE TABLE company(
        id INT,
        name VARCHAR(50) NOT NULL,
        PRIMARY KEY (id));
 
 -- The location table to record location's code,city,province,country,postcode and connect by company's id  
CREATE TABLE locations (
        id INT,
        company_id INT NOT NULL REFERENCES company,
        location_code VARCHAR(15) NOT NULL,
        city VARCHAR(30) NOT NULL,
        province VARCHAR(20) NOT NULL,
        country VARCHAR (20) NOT NULL,
        postcode VARCHAR (7) NOT NULL,
        PRIMARY KEY (id));

-- The department table to record department's id, name, code, address, top_position and connected by location's id  
CREATE TABLE departments(
        id INT,
        location_id INT NOT NULL REFERENCES locations,
        name VARCHAR(40),
        code VARCHAR(15),
        top_position VARCHAR(50),
        PRIMARY KEY (id));



-- The job table to record jobs, and connected by deparment id     
CREATE TABLE jobs (
        id INT,
        department_id INT NOT NULL REFERENCES departments,
        name VARCHAR(30),
        code VARCHAR(40),
        effect_date DATE,
        expiry_date DATE,
        job_reference VARCHAR(200),
        pay_type VARCHAR (20),
        PRIMARY KEY (id));
        
-- The payment method for a job, include pay frequency and pay type
CREATE TABLE pay_method(
        id INT,
        jobs_id INT NOT NULL REFERENCES jobs,
        pay_frequency VARCHAR (20),
        pay_type VARCHAR(20),
        PRIMARY KEY (id));


-- The employees table that record everything for a employee, and one employee only could have 1 job
CREATE TABLE employees (
        id INT UNIQUE,
        job_id INT NOT NULL REFERENCES jobs,
        name VARCHAR(80) NOT NULL,
        gender VARCHAR (2) CHECK (gender = 'M' OR gender = 'F' OR GENDER = 'NA'),
        ssn_num VARCHAR (16) NOT NULL,
        hire_date DATE,
        termination_date DATE,
        rehire_date DATE,
        PRIMARY KEY (id));
        
-- The payment table that paid using the same pay mothod, but not for same job so just add the employee id   
CREATE TABLE payment (
        id INT,
        pay_method_id INT NOT NULL REFERENCES pay_method,
        employees_id INT NOT NULL REFERENCES employees,
        payment_amount NUMERIC,
        PRIMARY KEY (id));
        
-- The address table to store every employee's address, whatever business or home address
CREATE TABLE address (
        id INT,
        employee_id INT NOT NULL REFERENCES employees,
        address_type VARCHAR(20) CHECK (address_type = 'business' OR address_type = 'home'),
        address VARCHAR(100),
        city VARCHAR (30),
        province VARCHAR(20),
        PRIMARY KEY (id));
      
--The phone number table to store every employee's phone number whatever home,cell or business  
CREATE TABLE phone_num(
        id INT,
        employee_id INT NOT NULL REFERENCES employees,
        phone_type VARCHAR(20) CHECK (phone_type = 'home' OR phone_type = 'cell' OR phone_type = 'home'),
        phone_num VARCHAR(11),
        PRIMARY KEY (id));
        
        
        
        