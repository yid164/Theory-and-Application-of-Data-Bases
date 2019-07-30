CREATE OR REPLACE FUNCTION load_jobs()
RETURNS void AS $$

BEGIN
        INSERT INTO jobs(id, name, job_code, effective_date, expiry_date, supervisor_job_id, department_id, pay_frequency_id, pay_type_id)
        SELECT row_number()OVER() AS id,
        job_name,
        job_code,
        TO_DATE(effective_date,'MM/DD/YYYY') AS effective_date,
        TO_DATE(expiry_date, 'MM/DD/YYYY') AS expiry_date,
        null,
        department.id AS department_id,
        pay_freq.id AS pay_freq_id,
        pay_type.id AS pay_type_id
        FROM 
        (SELECT DISTINCT id FROM departments where code IN 
                (SELECT department_code FROM load_employee WHERE job_code IN 
                (SELECT j.job_code from jobs j))) AS department,
        (SELECT DISTINCT id FROM pay_frequencies where name IN 
                (SELECT pay_freq FROM load_employee WHERE job_code IN 
                (SELECT j.job_code FROM jobs j))) AS pay_freq,
        (SELECT DISTINCT id FROM pay_types WHERE name IN
                (SELECT pay_type FROM load_employee WHERE job_code IN 
                (SELECT j.job_code FROM jobs j))) AS pay_type,
        load_job;
        

END; $$ LANGUAGE plpgsql; 