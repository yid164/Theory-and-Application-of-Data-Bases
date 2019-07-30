CREATE OR REPLACE FUNCTION load_employee_jobs()
RETURNS void AS $$
BEGIN
        INSERT INTO employee_jobs(id, employee_id, job_id, 
                effective_date, expiry_date, 
                salary_amount, hourly_amount,
                term_reason, employee_status,
                standard_hours, employee_type,
                employee_status_type, last_performance_rating,
                last_performance_rating_text, last_performance_rating_date)
                
             SELECT row_number() OVER() AS id,
             e.id,
             j.id,
             TO_DATE(j.effective_date,'MM/DD/YYYY'),
             TO_DATA(j.expiry_date, 'MM/DD/YYYY'),
             salary_amount,
             hourly_amount,
             term_reason,
             employee_status,
             standard_hours,
             exployee_type,
             employee_satus_type,
             CAST(COALESCE(last_performance_rating,'0') AS INT) AS last_performance_rating,
             last_performance_rating_text,
             TO_DATE(last_performance_rating_date,'MM/DD/YYYY')
             
             FROM
                load_employee l,
                (select id from employees e where title = l.job_title) AS e,
                (select id from jobs j where code = l.job_code) AS j;
                
END; $$ LANGUAGE plpgsql;
             