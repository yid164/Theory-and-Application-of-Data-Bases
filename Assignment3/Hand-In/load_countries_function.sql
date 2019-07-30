
-- load country function
CREATE OR REPLACE FUNCTION load_provinces()
-- return null because it is just need put the data in
RETURNS void AS $$
DECLARE province_record RECORD;
BEGIN 
        INSERT INTO countries (id, code, name)
        SELECT  row_number() OVER() AS id,
                UPPER(SUBSTRING(countries.country,0,3)),
                countries.country
        FROM 
                (SELECT DISTINCT country FROM load_location
                 UNION 
                SELECT DISTINCT bus_country FROM load_employee
                UNION
                select DISTINCT home_country FROM load_employee) AS countries
        GROUP BY countreis.country;      
END; $$ LANGUAGE plpgsql;