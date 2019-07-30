-- Name: yinsheng Dong
-- yid164

-- load location function
CREATE OR REPLACE FUNCTION load_locations()
-- return null because it is just need put the data in
RETURNS void AS $$

-- declare location record from load_locaitons table, then need location_id, province_id and country_id
DECLARE 
BEGIN 

        INSERT INTO locations (id, code, name, address, city, province_id, country_id, postal_code)
                SELECT row_number()OVER() AS id,
                location_code,
                location_name,
                street1,
                city,
                (SELECT id FROM provinces WHERE name = province) AS province_id,
                (SELECT id FROM countries WHERE  name = country) AS country_id,
                postal_code
         FROM load_location;
END; $$ LANGUAGE plpgsql;