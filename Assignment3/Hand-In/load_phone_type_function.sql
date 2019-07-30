-- name: yinsheng Dong
-- yid164

CREATE OR REPLACE FUNCTION load_phone_types()
RETURNS void AS $$

BEGIN
        INSERT INTO phone_types(id, code, name)
                SELECT row_number() OVER() AS id,
                UPPER (SUBSTRING(phone_type.phone1_type, 0, 3)) AS code,
                phone_type.phone1_type AS phone_type        
                FROM
                        (SELECT DISTINCT phone1_type from load_employee WHERE phone1_type IS NOT NULL UNION
                        SELECT DISTINCT phone2_type from load_employee WHERE phone2_type IS NOT NULL UNION
                        SELECT DISTINCT phone3_type from load_employee WHERE phone3_type IS NOT NULL UNION
                        SELECT DISTINCT phone4_type from load_employee WHERE phone4_type IS NOT NULL) AS phone_type
                GROUP BY phone_type;
END; $$ LANGUAGE plpgsql;