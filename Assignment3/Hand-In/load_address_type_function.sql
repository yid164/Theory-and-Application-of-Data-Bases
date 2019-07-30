-- Yinsheng Dong
-- yid164

CREATE OR REPLACE FUNCTION load_address_types()
RETURNS void AS $$
DECLARE type_name VARCHAR;
BEGIN

        
        INSERT INTO address_types(id, code, name)
        VALUES (1, 'Ho','Home');
        
        INSERT INTO address_types(id, code, name)
        VALUES (2, 'Bu','Bussiness');
        
        
END; $$ LANGUAGE plpgsql;