-- NAME: YINSHENG DONG
-- STUDNET NUMBER: 11148648
-- NSID: YID164

CREATE TABLE Provinces(
        id INT,
        code VARCHAR(20) UNIQUE,
        name VARCHAR(50) NOT NULL,
        PRIMARY KEY(id));
        
 CREATE TABLE Countries(
        id INT,
        code VARCHAR(20) UNIQUE,
        name VARCHAR(20) NOT NULL,
        PRIMARY KEY(id));


CREATE TABLE Locations(
        id INT,
        code VARCHAR(20) NOT NULL UNIQUE,
        name VARCHAR(50) NOT NULL,
        address VARCHAR(100) NOT NULL,
        city VARCHAR(100) NOT NULL,
        province_id INT NOT NULL REFERENCES Provinces,
        country_id INT NOT NULL REFERENCES Countries,
        PRIMARY KEY(id));


CREATE TABLE Departments(
        id INT,
        code VARCHAR(20) NOT NULL,
        name VARCHAR(50) NOT NULL,
        manager_job_id INT,
        location_id INT NOT NULL REFERENCES Locations,
        PRIMARY KEY(id));
        

CREATE TABLE Pay_Frequencies(
        id INT,
        code VARCHAR(20) NOT NULL,
        name VARCHAR (20) NOT NULL,
        description VARCHAR(40),
        PRIMARY KEY(id));
        
CREATE TABLE Pay_Types(
        id INT,
        code VARCHAR(20) NOT NULL,
        name VARCHAR(20) NOT NULL,
        description VARCHAR(40),
        PRIMARY KEY (id));



CREATE TABLE Jobs(
        id INT,
        name VARCHAR(50) NOT NULL,
        job_code VARCHAR(20) NOT NULL,
        effective_date DATE NOT NULL,
        expriry_date DATE,
        supervisor_job_id VARCHAR(40),
        department_id INT NOT NULL REFERENCES Departments,
        pay_frequency_id INT NOT NULL REFERENCES Pay_Frequencies,
        pay_type_id INT NOT NULL REFERENCES Pay_Types,
        PRIMARY KEY(id));
        
        
ALTER TABLE Jobs ADD CONSTRAINT fk_job
FOREIGN KEY (id) REFERENCES Jobs(id);

ALTER TABLE Departments ADD CONSTRAINT fk_supervisor
FOREIGN KEY (manager_job_id) REFERENCES Jobs(id);


   
CREATE TABLE Phone_Types(
        id INT,
        code VARCHAR(20) NOT NULL,
        name VARCHAR(20) NOT NULL,
        PRIMARY KEY(id));
        
 

CREATE TABLE Employees(
        id INT,
        employeeNumber VARCHAR(20),
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        gender VARCHAR (6),
        SSN VARCHAR(30),
        hireDate DATE NOT NULL,
        termDate DATE,
        rehireDate DATE,
        PRIMARY KEY(id));
      
  
CREATE TABLE Employee_Jobs(
        id INT,
        employee_id INT NOT NULL REFERENCES Employees,
        job_id INT NOT NULL REFERENCES Jobs,
        effective_date DATE NOT NULL,
        expriy_date DATE NOT NULL,
        salary_amount FLOAT,
        hourly_amount FLOAT,
        PRIMARY KEY(id));
       
CREATE TABLE emp_phone_numbers(
        id INT,
        employee_id INT NOT NULL REFERENCES Employees,
        country_code VARCHAR(5) NOT NULL,
        area_code VARCHAR(5) NOT NULL,
        phone_number VARCHAR(10) NOT NULL,
        extension VARCHAR(5),
        phone_type_id INT NOT NULL REFERENCES Phone_Types,
        PRIMARY KEY (id));

CREATE TABLE Address_types(
        id INT,
        code VARCHAR(20) NOT NULL,
        name VARCHAR(20) NOT NULL,
        PRIMARY KEY (id));
      
CREATE TABLE emp_addresses(
        id INT,
        employee_id INT NOT NULL REFERENCES Employees,
        addr VARCHAR (100) NOT NULL,
        city VARCHAR(50) NOT NULL,
        province_id INT NOT NULL REFERENCES Provinces,
        country_id INT NOT NULL REFERENCES Countries,
        postal_code VARCHAR(7) NOT NULL,
        addr_type_id INT NOT NULL REFERENCES Address_types,
        PRIMARY KEY(id));      
            

-- add title in the employee table, it can be nullable
ALTER TABLE employees
ADD COLUMN title VARCHAR(5);

-- add middle name attribute in the employee table, it can be nullable
ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(30);

-- add birthdate attribute in the employee table, it can must be not null
ALTER TABLE employees
ADD COLUMN birth_date DATE NOT NULL;

-- add home_email attribute in the employee table, it can not be null
ALTER TABLE employees
ADD COLUMN home_email VARCHAR(100) NOT NULL;

-- add marital_status in the employee table, it can not be null, and we constraint them in 5 flieds
ALTER TABLE employees
ADD COLUMN marital_status VARCHAR(20) CHECK (marital_status IN ('Married', 'Divorced','Single','Common-Law', 'Separated'));

-- add term type attribute in the employee_job table, it is in this table because a job can have different term types.
ALTER TABLE employee_jobs
ADD COLUMN term_type VARCHAR(50);

-- add term_reason in the employee_job table, it is in this table cause a job can have differnt term resons
ALTER TABLE employee_jobs
ADD COLUMN term_reason VARCHAR(20);

-- add employee_status in the employee_job table, it can not be null, can it is constriants in 3 filds
ALTER TABLE employee_jobs
ADD COLUMN employee_status VARCHAR(30) NOT NULL CHECK (employee_status IN ('Full-time', 'Part-time', 'Casual'));

-- add the standard_hours attribute in the employee_job table, it cannot be null
ALTER TABLE employee_jobs
ADD COLUMN standard_hours NUMERIC NOT NULL;

-- add the employee_table attribute in the employee_job table, it cannot be null and it is constrianted in 2 filed
ALTER TABLE employee_jobs
ADD COLUMN employee_type VARCHAR(20) NOT NULL CHECK (employee_type IN ('Temporary','Regular'));

-- add the employee_stauts_type attribute in the employee_job table, it cannot be null and it is constrianted in 4 filed
ALTER TABLE employee_jobs
ADD COLUMN employment_status_type VARCHAR(20) NOT NULL CHECK (employment_status_type IN ('Inactive','Active','Unpaid Leave','Suspended'));

-- and the last_performance attribute in the employee_jobs table
ALTER TABLE employee_jobs
ADD COLUMN last_performace_rating NUMERIC;

-- add the last_performance_text attribute in the employee_jobs table
ALTER TABLE employee_jobs
ADD COLUMN last_performance_rating_text VARCHAR(200);

-- add the last_performance_date in the employee_jobs table
ALTER TABLE employee_jobs
ADD COLUMN last_performance_rating_date DATE;

-- add the postal_code in location table
ALTER TABLE locations
ADD COLUMN postal_code VARCHAR(7) NOT NULL;

-- add the manager_job_title in the department table
ALTER TABLE departments
ADD COLUMN manager_job_title VARCHAR(30) NOT NULL;

-- add effective date in department table
ALTER TABLE departments
ADD COLUMN effective_date DATE NOT NULL;

-- add expeiry date in department table
ALTER TABLE departments
ADD COLUMN expiry_date DATE;
