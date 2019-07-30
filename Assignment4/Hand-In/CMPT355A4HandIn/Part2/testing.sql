-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164

-- Testing script fro employee_audit, employee_jobs_audit, and history tables

-- Insertion for employees table
SELECT set_config('session.trigs_enabled','Y', FALSE);
INSERT INTO employees(employee_number, title, first_name, middle_name, last_name, gender, ssn, birth_date, hire_date,
                        rehire_date, termination_date, marital_status_id, home_email, employment_status_id, term_type_id,
                        term_reason_id)
VALUES ('101859', 'Mr.', 'Apple', 'Not', 'Good', 'M', '123121111', to_date('1911-11-00','yyyy-MM-dd'),to_date('2011-11-00','yyyy-MM-dd'),
        NULL,NULL,5, 'goodgood@cba.com',1,1, NULL);

 -- Insertion for employee_jobs table       
INSERT INTO employee_jobs(employee_id, job_id, effective_date, expiry_date, pay_amount, standard_hours, employee_type_id, employee_status_id)
VALUES((SELECT e.id FROM employees e WHERE e.employee_number = '101859'),13, to_date('2010-11-00','yyyy-MM-dd'),NULL,44626, 20, 1, 2);

-- Update employee table
UPDATE employees
        SET middle_name = 'Bye'
        WHERE id = (SELECT e.id FROM employees e WHERE e.employee_number = '101859');
        
-- Update employee_jobs table
UPDATE employee_jobs
        SET standard_hours = 25
        WHERE employee_id = (SELECT e.id FROM employees e WHERE e.employee_number = '101859');



-- Deletion for employee_jobs table
DELETE FROM employee_jobs WHERE employee_id = (SELECT e.id FROM employees e WHERE e.employee_number = '101859');

-- Delete for employees table
DELETE FROM employees WHERE id = (SELECT e.id FROM employees e WHERE e.employee_number = '101859');

/**
-- Checking to the employee_history in audit schemas
SELECT * FROM audit.employee_history;

-- Checking to the employee_jobs_audit table in audit schemas
SELECT * FROM audit.employee_jobs_audit;

-- Checking to the employees_audit table in audit schemas
SELECT * FROM audit.employees_audit;**/