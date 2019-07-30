-- Yinsheng Dong
-- yid164
CREATE OR REPLACE FUNCTION load_departments()
RETURNS void AS $$
BEGIN

        INSERT INTO departments (id, code, name, manager_job_id,location_id, manager_job_title, effective_date, expiry_date)
                SELECT row_number() OVER() AS id,
                d.department_code,
                d.department_name,
                null,
                location_id.id AS location_id,
                d.department_job_title,
                TO_DATE (d.effective_date,'MM/DD/YYYY') AS effective_date,
                TO_DATE(d.expiry_date,'MM/DD/YYYY') AS expiry_date
         FROM   (SELECT id from locations WHERE code IN 
                (SELECT location_code from load_employee where supervisor_job_code IN 
                (SELECT department_mgr_job_code FROM load_department))) AS location_id, load_department d;     

END $$ LANGUAGE plpgsql
                                  
                       
                 