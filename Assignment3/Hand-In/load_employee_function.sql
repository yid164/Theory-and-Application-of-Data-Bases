-- NAME: YINSHENG DONG
-- YID164

CREATE OR REPLACE FUNCTION load_employees()
RETURNS void AS $$

BEGIN
        INSERT INTO employees (id, employeeNumber, 
                        title, firstName, middle_name, 
                         lastname, gender, birth_date,
                         marital_status, ssn,
                         home_email, hiredate, 
                         termdate, rehiredate)
        SELECT
                row_number()OVER() AS id,
                emplid,
                title,
                firstname,
                middlename,
                lastname,
                gender,
                TO_DATE(birthdate,'MM/DD/YYYY') AS birthdate,
                maritalstatus,
                ssn,
                homeemail,
                TO_DATE(orighiredate,'MM/DD/YYYY') AS orighiredate,
                TO_DATE(termdate,'MM/DD/YYYY') AS termdate,
                TO_DATE(rehiredate,'MM/DD/YYYY') AS rehiredate
        FROM load_employee;
END; $$ LANGUAGE plpgsql;
                         
                         