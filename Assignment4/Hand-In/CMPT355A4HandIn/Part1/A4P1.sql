-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164

-- create new schema for audting 
CREATE schema IF NOT EXISTS audit;
REVOKE CREATE ON schema audit FROM public;

-- create new table employee_audit
CREATE TABLE IF NOT EXISTS audit.employees_audit(
        employee_number VARCHAR(200),
        title VARCHAR(20),
        first_name VARCHAR(100),
        middle_name VARCHAR(100),
        last_name VARCHAR(100),
        gender VARCHAR(1),
        ssn VARCHAR(11),
        birth_date DATE,
        hire_date DATE,
        rehire_date DATE,
        termination_date DATE,
        marital_status_id INT,
        home_email VARCHAR(200),
        employment_status_id INT,
        term_type_id INT,
        term_reason_id INT,
        change_time TIMESTAMP,
        action_type VARCHAR,
        action_user VARCHAR);
 
-- Create table for employee_jobs_audit       
CREATE TABLE IF NOT EXISTS audit.employee_jobs_audit(
        employee_id INT,
        job_id INT,
        effective_date DATE,
        expiry_date DATE,
        pay_amount INT,
        standard_hours INT,
        employee_type_id INT,
        employee_status_id INT,
        change_time TIMESTAMP,
        action_type VARCHAR,
        action_user VARCHAR);  
 
-- Create table in audit schema named employee_history       
CREATE TABLE IF NOT EXISTS audit.employee_history(
        first_name VARCHAR(100),
        middle_name VARCHAR(100),
        last_name VARCHAR(100),
        gender VARCHAR(1),
        ssn VARCHAR(11),
        birthdate DATE,
        marital_status VARCHAR(100),
        employee_status VARCHAR(100),
        hire_date DATE,
        rehire_date DATE,
        termination_date DATE,
        termination_type VARCHAR(100),
        termination_reason VARCHAR(100),
        job_code VARCHAR(10),
        job_title VARCHAR(100),
        job_start_date DATE,
        job_end_date DATE,
        pay_amount INT,
        standard_hours INT,
        employee_type VARCHAR(100),
        employment_status VARCHAR(100),
        department_code VARChAR(10),
        department_name VARCHAR(100),
        location_code VARCHAR(10),
        location_name VARCHAR(100),
        pay_frequency VARCHAR(100),
        pay_type VARCHAR(100),
        supervisor_job_id INT,
        history_record_date TIMESTAMP);
        
 