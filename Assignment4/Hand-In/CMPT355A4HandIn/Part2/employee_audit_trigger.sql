-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164

-- DROP triggers for testing
DROP TRIGGER IF EXISTS audit_employee_change_tg ON public.employees;
CREATE OR REPLACE FUNCTION audit.employee_audit_change()
RETURNS TRIGGER AS $$
DECLARE
        v_trig_enabled VARCHAR(1);
BEGIN
        -- trigger gate
        SELECT COALESCE(current_setting('session.trigs_enabled'),'Y')
        INTO v_trig_enabled;
        IF v_trig_enabled = 'Y' THEN
                -- if the operation is delete, insert the old data
                IF(TG_OP = 'DELETE') THEN
                        INSERT INTO audit.employees_audit 
                                SELECT OLD.employee_number,
                                OLD.title,
                                OLD.first_name,
                                OLD.middle_name,
                                OLD.last_name,
                                OLD.gender,
                                OLD.ssn,
                                OLD.birth_date,
                                OLD.hire_date,
                                OLD.rehire_date,
                                OLD.termination_date,
                                OLD.marital_status_id,
                                OLD.home_email,
                                OLD.employment_status_id,
                                OLD.term_type_id,
                                OLD.term_reason_id,
                                now(),
                                'DELETE',
                                user;
                        -- if the operation is update, insert the new data
                        ELSEIF (TG_OP = 'UPDATE') THEN
                                INSERT INTO audit.employees_audit
                                SELECT NEW.employee_number,
                                NEW.title,
                                NEW.first_name,
                                NEW.middle_name,
                                NEW.last_name,
                                NEW.gender,
                                NEW.ssn,
                                NEW.birth_date,
                                NEW.hire_date,
                                NEW.rehire_date,
                                NEW.termination_date,
                                NEW.marital_status_id,
                                NEW.home_email,
                                NEW.employment_status_id,
                                NEW.term_type_id,
                                NEW.term_reason_id,
                                now(),
                                'UPDATE',
                                user;
                         -- if the operation is insert, insert the new data
                        ELSEIF (TG_OP = 'INSERT') THEN
                                INSERT INTO audit.employees_audit
                                SELECT NEW.employee_number,
                                NEW.title,
                                NEW.first_name,
                                NEW.middle_name,
                                NEW.last_name,
                                NEW.gender,
                                NEW.ssn,
                                NEW.birth_date,
                                NEW.hire_date,
                                NEW.rehire_date,
                                NEW.termination_date,
                                NEW.marital_status_id,
                                NEW.home_email,
                                NEW.employment_status_id,
                                NEW.term_type_id,
                                NEW.term_reason_id,
                                now(),
                                'INSERT',
                                user;
                        END IF;
               END IF;
            RETURN NULL;
END; $$ LANGUAGE plpgsql;


-- fire the trigger
CREATE TRIGGER audit_employee_change_tg
AFTER INSERT OR UPDATE OR DELETE
        ON public.employees
        FOR EACH ROW
        EXECUTE PROCEDURE audit.employee_audit_change();                    
                        