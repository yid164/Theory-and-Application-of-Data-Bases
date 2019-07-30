-- name: yinsheng dong
-- yid164
-- load pay_type function

CREATE OR REPLACE FUNCTION load_pay_types()
RETURNS void AS $$

DECLARE 
BEGIN
        INSERT INTO pay_types (id, code, name, description)
        SELECT row_number() OVER() AS id,
               UPPER (SUBSTRING(e.pay_type, 0, 4)),
               e.pay_type,
               CONCAT(e.pay_type, ' type')
        FROM load_employee e
        GROUP BY e.pay_type;
END; $$ LANGUAGE plpgsql;