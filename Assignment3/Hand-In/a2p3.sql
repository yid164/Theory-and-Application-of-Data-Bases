-- Yinsheng Dong
-- yid164

CREATE TABLE (employee_number VARCHAR(50)
              employee_name VARCHAR(50),
              birth_data DATE,
              gender VARCHAR(5),
              lenth_service DATE,
              department VARCHAR(30),
              location VARCHAR(20),
              pay_type VARCHAR(20),
              pay_amount NUMERIC,
              supervisor_name (30),
              last_performance_rating_text);
              
CREATE TABLE (employee_name VARCHAR(20), 
              employee_age INT, 
              termination_DATE DATE,
              performance_rating_number INT,
              performance_rating_text VARCHAR(200),
              performace_rating_date DATE,
              current_length_servise DATE);
              
CREATE TABLE (employee_name VARCHAR(20), 
              age INT,
              termination_date DATE, 
              recent_length_servise DATE,
              termination_type VARCHAR(40),
              termination_reason VARCHAR(300),
              department_code VARCHAR(40),
              department_name VARCHAR(50),
              department_number VARCHAR(20),
              over_all NUMERIC,
              job_title VARCHAR(20),
              job_code VARCHAR(20),
              number_term INT);
              