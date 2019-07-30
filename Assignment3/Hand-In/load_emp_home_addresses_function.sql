-- NAME: YINSHENG DONG
-- YID164

CREATE OR REPLACE FUNCTION load_emp_home_addresses()
RETURNS void AS $$
DECLARE 
        v_address_record RECORD;
        v_addr_type_id INT;
        v_employee_id INT;
        v_province_id INT;
        v_country_id INT;
        v_address_id INT;

BEGIN
      FOR v_address_record IN (SELECT 
                                home_street_num,
                                home_street_name,
                                home_street_suffix,
                                home_city,
                                home_state,
                                home_country,
                                home_zipcode 
                                FROM load_employee) LOOP
        SELECT id INTO v_addr_type_id FROM address_types WHERE name = 'Home';
        IF v_addr_type_id IS NULL THEN
                RAISE NOTICE 'HOME NOT FOUND: %',v_address_record;
        EXIT;
        END IF;
        
        SELECT id INTO v_employee_id FROM employees WHERE employeenumber = (SELECT emplid FROM
                                                              load_employee e  
                                                              WHERE e.home_street_num =v_address_record.home_street_num AND
                                                              e.home_street_name =v_address_record.home_street_name AND
                                                              e.home_street_suffix =v_address_record.home_street_suffix AND
                                                              e.home_city =v_address_record.home_city AND
                                                              e.home_state =v_address_record.home_state AND
                                                              e.home_country =v_address_record.home_country AND
                                                              e.home_zipcode =v_address_record.home_zipcode);
        
        IF v_employee_id IS NULL THEN 
                RAISE NOTICE 'EMPLOYEE NOT FOUND: %', v_address_record;
        EXIT;
        END IF;
        
        
        SELECT id INTO v_province_id FROM provinces WHERE name = v_address_record.home_state;
        IF v_province_id IS NULL THEN 
                RAISE NOTICE 'province NOT FOUND: %',v_address_record;
        EXIT;
        END IF;
        
        SELECT id INTO v_country_id FROM countries WHERE name = v_address_record.home_country;
        IF v_country_id IS NULL THEN 
                RAISE NOTICE 'country NOT FOUND: %',v_address_record;
        EXIT;
        END IF;
        
        SELECT id INTO v_address_id
        FROM emp_addresses
        WHERE employee_id = v_employee_id AND
              addr_type_id = v_addr_type_id;
         
         
        IF EXISTS (SELECT * FROM emp_addresses) THEN      
                IF v_address_id IS NULL THEN 
                        INSERT INTO emp_addresses (id, employee_id, addr, city, province_id, country_id, postal_code, addr_type_id)
                        SELECT MAX(id)+1,
                        v_employee_id,
                        CONCAT(v_address_record.home_street_suffix, v_address_record.home_street_num,
                        v_address_record.home_street_name),v_address_record.home_city,v_province_id,
                        v_country_id, v_address_record.home_zipcode,v_addr_type_id
                        FROM emp_addresses;
                ELSE
                        
                       UPDATE emp_addresses
                       SET addr = (v_address_record.home_street_suffix, v_address_record.home_street_num,
                                   v_address_record.home_street_name),
                                   city = v_address_record.home_city,
                                   province_id = v_province_id,
                                   country_id = v_country_id,
                                   postal_code = v_address_record.home_zipcode,
                                   addr_type_id = v_addr_type_id
                        WHERE id = v_address_id;
                END IF;
        ELSE
                INSERT INTO emp_addresses (id, employee_id, addr, city, province_id, country_id, postal_code, addr_type_id)
                VALUES  (1, v_employee_id,
                CONCAT(v_address_record.home_street_suffix, v_address_record.home_street_num,
                v_address_record.home_street_name), v_address_record.home_city,v_province_id,
                v_country_id,v_address_record.home_zipcode,v_addr_type_id);

        END IF;
      END LOOP;
END; $$ LANGUAGE plpgsql;