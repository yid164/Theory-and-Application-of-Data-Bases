-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecuture: CMPT355


-- drop index 1, 2, 3
DROP INDEX IF EXISTS index_1;

DROP INDEX IF EXISTS index_2;

DROP INDEX IF EXISTS index_3;


-- CREATE index 1, 2, 3
CREATE INDEX index_1 ON employee_histories (first_name, last_name);

CREATE INDEX index_2 ON employee_jobs (employee_id, job_id);

CREATE INDEX IF NOT EXISTS index_3 ON employees (birth_date);


