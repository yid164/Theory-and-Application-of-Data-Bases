-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164

-- DROP triggers for testing
DROP TRIGGER IF EXISTS history_employee_tg ON public.employees;
DROP TRIGGER IF EXISTS history_employee_jobs_tg ON public.employee_jobs;

-- Create trigger on employees table for the audit employee_history 
CREATE OR REPLACE FUNCTION audit.employee_history_change()
RETURNS TRIGGER AS $$
DECLARE
        v_trig_enabled VARCHAR(1);
BEGIN
        -- Gate for the trigger
        SELECT COALESCE(current_setting('session.trigs_enabled'),'Y')
        INTO v_trig_enabled;
        IF v_trig_enabled = 'Y' THEN
           
           -- Delete operation for recording the old info to the history table
           IF (TG_OP = 'DELETE') THEN
                INSERT INTO audit.employee_history
                        (first_name, middle_name, last_name, gender,
                         ssn, birthdate, marital_status, employee_status,
                         hire_date, rehire_date, termination_date, termination_type, termination_reason,
                         job_code, job_title, job_start_date, job_end_date, pay_amount, standard_hours,
                         employee_type, employment_status, department_code, department_name, location_code,
                         location_name,pay_frequency, pay_type, supervisor_job_id, history_record_date)
                                SELECT OLD.first_name, 
                                OLD.middle_name, 
                                OLD.last_name,
                                OLD.gender,
                                OLD.ssn, 
                                OLD.birth_date, 
                                (SELECT m.name FROM marital_statuses m WHERE m.id = OLD.marital_status_id),
                                (SELECT eps.name FROM employee_statuses eps, employee_jobs ej WHERE eps.id = (SELECT ej.employee_status_id WHERE
                                        ej.employee_id = OLD.id)), 
                                OLD.hire_date,
                                OLD.rehire_date,
                                OLD.termination_date,
                                (SELECT tt.name FROM termination_types tt WHERE tt.id = OLD.term_type_id),
                                (SELECT tr.name FROM termination_reasons tr WHERE tr.id = OLD.term_reason_id),
                                (SELECT j.code FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)),
                                (SELECT j.name FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)),
                                (SELECT ej.effective_date FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT ej.expiry_date FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT ej.pay_amount FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT ej.standard_hours FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT et.name FROM employee_types et, employee_jobs ej WHERE et.id = (SELECT ej.employee_type_id WHERE ej.employee_id = OLD.id)),
                                (SELECT ems.name FROM employment_status_types ems WHERE ems.id = OLD.employment_status_id),
                                (SELECT d.code FROM departments d, employee_jobs ej, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT d.name FROM departments d, employee_jobs ej, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT l.code FROM locations l, departments d, jobs j, employee_jobs ej WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)))),
                                (SELECT l.name FROM locations l, departments d, jobs j, employee_jobs ej WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)))),
                                (SELECT pf.name FROM pay_frequencies pf, jobs j, employee_jobs ej WHERE pf.id = (SELECT j.pay_frequency_id
                                        where j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT pt.name FROM pay_types pt, jobs j, employee_jobs ej WHERE pt.id = (SELECT j.pay_frequency_id
                                        where j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT j.supervisor_job_id FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)),
                                 CURRENT_TIMESTAMP;
           -- Insert operation for insert new data to the table
           ELSEIF (TG_OP = 'INSERT') THEN
                INSERT INTO audit.employee_history
                        (first_name, middle_name, last_name, gender,
                         ssn, birthdate, marital_status, employee_status,
                         hire_date, rehire_date, termination_date, termination_type, termination_reason,
                         job_code, job_title, job_start_date, job_end_date, pay_amount, standard_hours,
                         employee_type, employment_status, department_code, department_name, location_code,
                         location_name,pay_frequency, pay_type, supervisor_job_id, history_record_date)
                                SELECT NEW.first_name, 
                                NEW.middle_name, 
                                NEW.last_name,
                                NEW.gender,
                                NEW.ssn, 
                                NEW.birth_date, 
                                (SELECT m.name FROM marital_statuses m WHERE m.id = NEW.marital_status_id),
                                (SELECT eps.name FROM employee_statuses eps, employee_jobs ej WHERE eps.id = (SELECT ej.employee_status_id WHERE
                                        ej.employee_id = NEW.id)), 
                                NEW.hire_date,
                                NEW.rehire_date,
                                NEW.termination_date,
                                (SELECT tt.name FROM termination_types tt WHERE tt.id = NEW.term_type_id),
                                (SELECT tr.name FROM termination_reasons tr WHERE tr.id = NEW.term_reason_id),
                                (SELECT j.code FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id)),
                                (SELECT j.name FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id)),
                                (SELECT ej.effective_date FROM employee_jobs ej WHERE ej.employee_id = NEW.id),
                                (SELECT ej.expiry_date FROM employee_jobs ej WHERE ej.employee_id = NEW.id),
                                (SELECT ej.pay_amount FROM employee_jobs ej WHERE ej.employee_id = NEW.id),
                                (SELECT ej.standard_hours FROM employee_jobs ej WHERE ej.employee_id = NEW.id),
                                (SELECT et.name FROM employee_types et, employee_jobs ej WHERE et.id = (SELECT ej.employee_type_id WHERE ej.employee_id = NEW.id)),
                                (SELECT ems.name FROM employment_status_types ems WHERE ems.id = NEW.employment_status_id),
                                (SELECT d.code FROM departments d, employee_jobs ej, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id))),
                                (SELECT d.name FROM departments d, employee_jobs ej, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id))),
                                (SELECT l.code FROM locations l, departments d, jobs j, employee_jobs ej WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id)))),
                                (SELECT l.name FROM locations l, departments d, jobs j, employee_jobs ej WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id)))),
                                (SELECT pf.name FROM pay_frequencies pf, jobs j, employee_jobs ej WHERE pf.id = (SELECT j.pay_frequency_id
                                        where j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id))),
                                (SELECT pt.name FROM pay_types pt, jobs j, employee_jobs ej WHERE pt.id = (SELECT j.pay_frequency_id
                                        where j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id))),
                                (SELECT j.supervisor_job_id FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = NEW.id)),
                                 CURRENT_TIMESTAMP;
                                 
             -- Update operation that record old data to the table
             ELSEIF (TG_OP = 'UPDATE') THEN
                INSERT INTO audit.employee_history
                        (first_name, middle_name, last_name, gender,
                         ssn, birthdate, marital_status, employee_status,
                         hire_date, rehire_date, termination_date, termination_type, termination_reason,
                         job_code, job_title, job_start_date, job_end_date, pay_amount, standard_hours,
                         employee_type, employment_status, department_code, department_name, location_code,
                         location_name,pay_frequency, pay_type, supervisor_job_id, history_record_date)
                                SELECT OLD.first_name, 
                                OLD.middle_name, 
                                OLD.last_name,
                                OLD.gender,
                                OLD.ssn, 
                                OLD.birth_date, 
                                (SELECT m.name FROM marital_statuses m WHERE m.id = OLD.marital_status_id),
                                (SELECT eps.name FROM employee_statuses eps, employee_jobs ej WHERE eps.id = (SELECT ej.employee_status_id WHERE
                                        ej.employee_id = OLD.id)), 
                                OLD.hire_date,
                                OLD.rehire_date,
                                OLD.termination_date,
                                (SELECT tt.name FROM termination_types tt WHERE tt.id = OLD.term_type_id),
                                (SELECT tr.name FROM termination_reasons tr WHERE tr.id = OLD.term_reason_id),
                                (SELECT j.code FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)),
                                (SELECT j.name FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)),
                                (SELECT ej.effective_date FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT ej.expiry_date FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT ej.pay_amount FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT ej.standard_hours FROM employee_jobs ej WHERE ej.employee_id = OLD.id),
                                (SELECT et.name FROM employee_types et, employee_jobs ej WHERE et.id = (SELECT ej.employee_type_id WHERE ej.employee_id = OLD.id)),
                                (SELECT ems.name FROM employment_status_types ems WHERE ems.id = OLD.employment_status_id),
                                (SELECT d.code FROM departments d, employee_jobs ej, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT d.name FROM departments d, employee_jobs ej, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT l.code FROM locations l, departments d, jobs j, employee_jobs ej WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)))),
                                (SELECT l.name FROM locations l, departments d, jobs j, employee_jobs ej WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)))),
                                (SELECT pf.name FROM pay_frequencies pf, jobs j, employee_jobs ej WHERE pf.id = (SELECT j.pay_frequency_id
                                        where j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT pt.name FROM pay_types pt, jobs j, employee_jobs ej WHERE pt.id = (SELECT j.pay_frequency_id
                                        where j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id))),
                                (SELECT j.supervisor_job_id FROM jobs j, employee_jobs ej WHERE j.id = (SELECT ej.job_id WHERE ej.employee_id = OLD.id)),
                                 CURRENT_TIMESTAMP;       
               END IF;
            END IF;
            RETURN NULL;
END; $$ LANGUAGE plpgsql;

-- Create trigger on employee_jobs table for the audit employee_history 
CREATE OR REPLACE FUNCTION audit.employee_jobs_history_change()
RETURNS TRIGGER AS $$
DECLARE
        v_trig_enabled VARCHAR(1);
BEGIN
        -- Gate to the trigger
        SELECT COALESCE(current_setting('session.trigs_enabled'),'Y')
        INTO v_trig_enabled;
        IF v_trig_enabled = 'Y' THEN
            -- Delete operation for recording the old info to the history table
            IF TG_OP = 'DELETE' THEN
                INSERT INTO audit.employee_history
                        (first_name, middle_name, last_name, gender,
                         ssn, birthdate, marital_status, employee_status,
                         hire_date, rehire_date, termination_date, termination_type, termination_reason,
                         job_code, job_title, job_start_date, job_end_date, pay_amount, standard_hours,
                         employee_type, employment_status, department_code, department_name, location_code,
                         location_name,pay_frequency, pay_type, supervisor_job_id, history_record_date)
                        SELECT (SELECT e.first_name FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.middle_name FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.last_name FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.gender FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.ssn FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.birth_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT ms.name FROM marital_statuses ms, employees e 
                                        WHERE ms.id = (SELECT e.marital_status_id WHERE e.id = OLD.employee_id)),
                             (SELECT eps.name FROM employee_statuses eps WHERE eps.id = OLD.employee_status_id),
                             (SELECT e.hire_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.rehire_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.termination_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT tt.name FROM termination_types tt, employees e 
                                        WHERE tt.id = (SELECT e.term_type_id WHERE e.id = OLD.employee_id)),
                             (SELECT tr.name FROM termination_reasons tr, employees e 
                                        WHERE tr.id = (SELECT e.term_reason_id WHERE e.id = OLD.employee_id)),
                             (SELECT j.code FROM jobs j WHERE j.id = OLD.job_id),
                             (SELECT j.name FROM jobs j WHERE j.id = OLD.job_id),
                             OLD.effective_date,
                             OLD.expiry_date,
                             OLD.pay_amount,
                             OLD.standard_hours,
                             (SELECT et.name FROM employee_types et WHERE et.id = OLD.employee_type_id),
                             (SELECT est.name FROM employment_status_types est, employees e WHERE est.id = 
                                        (SELECT e.employment_status_id WHERE e.id = OLD.employee_id)),
                             (SELECT d.code FROM departments d, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = OLD.job_id)),
                             (SELECT d.name FROM departments d, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = OLD.job_id)),
                             (SELECT l.code FROM locations l, departments d, jobs j WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = OLD.job_id))),
                             (SELECT l.name FROM locations l, departments d, jobs j WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = OLD.job_id))),
                             (SELECT pf.name FROM pay_frequencies pf, jobs j WHERE pf.id = (SELECT j.pay_frequency_id
                                        where j.id = OLD.job_id)),
                             (SELECT pt.name FROM pay_types pt, jobs j WHERE pt.id = (SELECT j.pay_frequency_id
                                        where j.id = OLD.job_id)),
                             (SELECT j.supervisor_job_id FROM jobs j WHERE j.id = OLD.job_id),
                             CURRENT_TIMESTAMP;
             -- Insert operation for insert new data to the table
             ELSEIF TG_OP = 'INSERT' THEN
                INSERT INTO audit.employee_history
                        (first_name, middle_name, last_name, gender,
                         ssn, birthdate, marital_status, employee_status,
                         hire_date, rehire_date, termination_date, termination_type, termination_reason,
                         job_code, job_title, job_start_date, job_end_date, pay_amount, standard_hours,
                         employee_type, employment_status, department_code, department_name, location_code,
                         location_name,pay_frequency, pay_type, supervisor_job_id, history_record_date)
                        SELECT (SELECT e.first_name FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.middle_name FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.last_name FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.gender FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.ssn FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.birth_date FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT ms.name FROM marital_statuses ms, employees e 
                                        WHERE ms.id = (SELECT e.marital_status_id WHERE e.id = NEW.employee_id)),
                             (SELECT eps.name FROM employee_statuses eps WHERE eps.id = NEW.employee_status_id),
                             (SELECT e.hire_date FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.rehire_date FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT e.termination_date FROM employees e WHERE e.id = NEW.employee_id),
                             (SELECT tt.name FROM termination_types tt, employees e 
                                        WHERE tt.id = (SELECT e.term_type_id WHERE e.id = NEW.employee_id)),
                             (SELECT tr.name FROM termination_reasons tr, employees e 
                                        WHERE tr.id = (SELECT e.term_reason_id WHERE e.id = NEW.employee_id)),
                             (SELECT j.code FROM jobs j WHERE j.id = NEW.job_id),
                             (SELECT j.name FROM jobs j WHERE j.id = NEW.job_id),
                             NEW.effective_date,
                             NEW.expiry_date,
                             NEW.pay_amount,
                             NEW.standard_hours,
                             (SELECT et.name FROM employee_types et WHERE et.id = NEW.employee_type_id),
                             (SELECT est.name FROM employment_status_types est, employees e WHERE est.id = 
                                        (SELECT e.employment_status_id WHERE e.id = NEW.employee_id)),
                             (SELECT d.code FROM departments d, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = NEW.job_id)),
                             (SELECT d.name FROM departments d, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = NEW.job_id)),
                             (SELECT l.code FROM locations l, departments d, jobs j WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = NEW.job_id))),
                             (SELECT l.name FROM locations l, departments d, jobs j WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = NEW.job_id))),
                             (SELECT pf.name FROM pay_frequencies pf, jobs j WHERE pf.id = (SELECT j.pay_frequency_id
                                        where j.id = NEW.job_id)),
                             (SELECT pt.name FROM pay_types pt, jobs j WHERE pt.id = (SELECT j.pay_frequency_id
                                        where j.id = NEW.job_id)),
                             (SELECT j.supervisor_job_id FROM jobs j WHERE j.id = NEW.job_id),
                             CURRENT_TIMESTAMP;
            -- Update operation that record old data to the table
            ELSEIF TG_OP = 'UPDATE' THEN
                INSERT INTO audit.employee_history
                        (first_name, middle_name, last_name, gender,
                         ssn, birthdate, marital_status, employee_status,
                         hire_date, rehire_date, termination_date, termination_type, termination_reason,
                         job_code, job_title, job_start_date, job_end_date, pay_amount, standard_hours,
                         employee_type, employment_status, department_code, department_name, location_code,
                         location_name,pay_frequency, pay_type, supervisor_job_id, history_record_date)
                        SELECT (SELECT e.first_name FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.middle_name FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.last_name FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.gender FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.ssn FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.birth_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT ms.name FROM marital_statuses ms, employees e 
                                        WHERE ms.id = (SELECT e.marital_status_id WHERE e.id = OLD.employee_id)),
                             (SELECT eps.name FROM employee_statuses eps WHERE eps.id = OLD.employee_status_id),
                             (SELECT e.hire_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.rehire_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT e.termination_date FROM employees e WHERE e.id = OLD.employee_id),
                             (SELECT tt.name FROM termination_types tt, employees e 
                                        WHERE tt.id = (SELECT e.term_type_id WHERE e.id = OLD.employee_id)),
                             (SELECT tr.name FROM termination_reasons tr, employees e 
                                        WHERE tr.id = (SELECT e.term_reason_id WHERE e.id = OLD.employee_id)),
                             (SELECT j.code FROM jobs j WHERE j.id = OLD.job_id),
                             (SELECT j.name FROM jobs j WHERE j.id = OLD.job_id),
                             OLD.effective_date,
                             OLD.expiry_date,
                             OLD.pay_amount,
                             OLD.standard_hours,
                             (SELECT et.name FROM employee_types et WHERE et.id = OLD.employee_type_id),
                             (SELECT est.name FROM employment_status_types est, employees e WHERE est.id = 
                                        (SELECT e.employment_status_id WHERE e.id = OLD.employee_id)),
                             (SELECT d.code FROM departments d, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = OLD.job_id)),
                             (SELECT d.name FROM departments d, jobs j WHERE d.id = (SELECT j.department_id
                                        WHERE j.id = OLD.job_id)),
                             (SELECT l.code FROM locations l, departments d, jobs j WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = OLD.job_id))),
                             (SELECT l.name FROM locations l, departments d, jobs j WHERE l.id = (SELECT d.location_id
                                        WHERE d.id = (SELECT j.department_id WHERE j.id = OLD.job_id))),
                             (SELECT pf.name FROM pay_frequencies pf, jobs j WHERE pf.id = (SELECT j.pay_frequency_id
                                        where j.id = OLD.job_id)),
                             (SELECT pt.name FROM pay_types pt, jobs j WHERE pt.id = (SELECT j.pay_frequency_id
                                        where j.id = OLD.job_id)),
                             (SELECT j.supervisor_job_id FROM jobs j WHERE j.id = OLD.job_id),
                             CURRENT_TIMESTAMP;
             END IF;
         END IF;
         RETURN NULL;
END; $$ LANGUAGE plpgsql;
        
-- fire the triggers
CREATE TRIGGER history_employee_tg
AFTER UPDATE OR INSERT OR DELETE
        ON public.employees
        FOR EACH ROW
        EXECUTE PROCEDURE audit.employee_history_change();
        
CREATE TRIGGER history_employee_jobs_tg
AFTER UPDATE OR INSERT OR DELETE
        ON public.employee_jobs
        FOR EACH ROW
        EXECUTE PROCEDURE audit.employee_jobs_history_change();