-- Yinsheng Dong
-- yid164 
-- load province function
CREATE OR REPLACE FUNCTION load_provinces()
-- return null because it is just need put the data in
RETURNS void AS $$
DECLARE province_record RECORD;
BEGIN 
        INSERT INTO provinces (id, code, name)
        select row_number() OVER() AS id,
                UPPER(SUBSTRING(provinces.province,0,5)),
                provinces.province
        FROM 
                (select distinct province FROM load_location
                UNION 
                SELECT DISTINCT bus_state FROM load_employee
                UNION
                select DISTINCT home_state FROM load_employee) AS provinces
        GROUP BY provinces.province;      
END; $$ LANGUAGE plpgsql;