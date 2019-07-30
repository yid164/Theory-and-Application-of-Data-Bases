-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- CMPT355

-- DROP triggers for testing
DROP TRIGGER IF EXISTS audit_employee_jobs_change_tg ON public.employee_jobs;

-- Create trigger on employee_job table for the audit.employee_jobs table
CREATE OR REPLACE FUNCTION audit.employee_jobs_audit_change()
RETURNS TRIGGER AS $$
DECLARE
        v_trig_enabled VARCHAR(1);
BEGIN
        -- trigger gate
        SELECT COALESCE(current_setting('session.trigs_enabled'),'Y')
        INTO v_trig_enabled;
        IF v_trig_enabled = 'Y' THEN
                -- If delete operation, insert the old data
                IF(TG_OP = 'DELETE') THEN
                        INSERT INTO audit.employee_jobs_audit
                                SELECT OLD.employee_id,
                                OLD.job_id,
                                OLD.effective_date,
                                OLD.expiry_date,
                                OLD.pay_amount,
                                OLD.standard_hours,
                                OLD.employee_type_id,
                                OLD.employee_status_id,
                                now(),
                                'DELETE',
                                user; 
                -- If update opration, insert new data                     
                ELSEIF(TG_OP = 'UPDATE') THEN
                        INSERT INTO audit.employee_jobs_audit
                               SELECT NEW.employee_id,
                               NEW.job_id,
                               NEW.effective_date,
                               NEW.expiry_date,
                               NEW.pay_amount,
                               NEW.standard_hours,
                               NEW.employee_type_id,
                               NEW.employee_status_id,
                               now(),
                               'UPDATE',
                               user; 
                 -- If insert operation, insert new data
                ELSEIF(TG_OP = 'INSERT') THEN
                        INSERT INTO audit.employee_jobs_audit
                               SELECT NEW.employee_id,
                               NEW.job_id,
                               NEW.effective_date,
                               NEW.expiry_date,
                               NEW.pay_amount,
                               NEW.standard_hours,
                               NEW.employee_type_id,
                               NEW.employee_status_id,
                               now(),
                               'INSERT',
                               user;
                END IF;
           END IF;
        RETURN NULL;
END; $$ LANGUAGE plpgsql;

-- Fire the trigger
CREATE TRIGGER audit_employee_jobs_change_tg
AFTER INSERT OR UPDATE OR DELETE
        ON public.employee_jobs
        FOR EACH ROW
        EXECUTE PROCEDURE audit.employee_jobs_audit_change();
