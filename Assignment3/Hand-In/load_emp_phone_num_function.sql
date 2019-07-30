CREATE OR REPLACE FUNCTION load_emp_phone_number()
RETURNS void AS $$
DECLARE 
        v_employee_id INT;
        v_phone_type_id INT;
        emp_phone_num_id INT;
        v_phone_num_record RECORD;
        v_emploer_num VARCHAR;
        
BEGIN

        FOR v_phone_num_record IN (SELECT phone1_country_code,
                    phone1_area_code,
                    phone1_num,
                    phone1_extension,
                    phone1_type,
                    phone2_country_code,
                    phone2_area_code,
                    phone2_num,
                    phone2_extension,
                    phone2_type,
                    phone3_country_code,
                    phone3_area_code,
                    phone3_num,
                    phone3_extension,
                    phone3_type,
                    phone4_country_code,
                    phone4_area_code,
                    phone4_num,
                    phone4_extension,
                    phone4_type FROM load_employee) LOOP
         
         SELECT id, employeenumber INTO v_employee_id,v_emploer_num FROM employees WHERE employeenumber = (SELECT
                emplid from load_employee WHERE
                        (phone1_country_code = v_phone_num_record.phone1_country_code AND
                        phone1_area_code = v_phone_num_record.phone1_area_code AND
                        phone1_num = v_phone_num_record.phone1_num AND
                        phone1_extension = v_phone_num_record.phone1_extension AND
                        phone1_type = v_phone_num_record.phone1_type) OR
                        
                        (phone2_country_code = v_phone_num_record.phone2_country_code AND
                        phone2_area_code = v_phone_num_record.phone2_area_code AND
                        phone2_num = v_phone_num_record.phone2_num AND
                        phone2_extension = v_phone_num_record.phone2_extension AND
                        phone2_type = v_phone_num_record.phone2_type)  OR
                        
                        (phone3_country_code = v_phone_num_record.phone3_country_code AND
                        phone3_area_code = v_phone_num_record.phone3_area_code AND
                        phone3_num = v_phone_num_record.phone3_num AND
                        phone3_extension = v_phone_num_record.phone3_extension AND
                        phone3_type = v_phone_num_record.phone3_type) OR
                        
                        
                        (phone4_country_code = v_phone_num_record.phone4_country_code AND
                        phone4_area_code = v_phone_num_record.phone4_area_code AND
                        phone4_num = v_phone_num_record.phone4_num AND
                        phone4_extension = v_phone_num_record.phone4_extension AND
                        phone4_type = v_phone_num_record.phone4_type));
          IF v_employee_id IS NULL THEN
                RAISE NOTICE 'THE EMPLOY DOES NOT FOUND %', v_phone_num_record;
                EXIT;
          END IF;
          
          SELECT id INTO v_phone_type_id FROM phone_types WHERE name IN (SELECT phone1_type FROM load_employee WHERE emplid = v_emploer_num 
                UNION SELECT phone2_type FROM load_employee WHERE emplid = v_emploer_num
                UNION SELECT phone3_type FROM load_employee WHERE emplid = v_emploer_num
                UNION SELECT phone4_type FROM load_employee WHERE emplid = v_emploer_num);
          IF v_phone_type_id IS NULL THEN
                RAISE NOTICE 'THE PHONE TYPE DOES NOT FOUND %', v_phone_num_record;
                EXIT;
          END IF;
          
          SELECT id INTO emp_phone_num_id FROM emp_phone_numbers 
          WHERE employee_id = v_employee_id AND phone_type_id = v_phone_type_id;
          
          IF EXISTS (SELECT * FROM emp_phone_numbers) THEN
                IF emp_phone_num_id IS NULL THEN
                        INSERT INTO emp_phone_numbers (id, employee_id, country_code, area_code, phone_number, extension, phone_type_id)
                            SELECT MAX(id) + 1,
                            v_employee_id,
                            phone_country.phone1_country_code AS country_code,
                            phone_area.phone1_area_code AS area_code,
                            phone_num.phone1_num AS phone_number,
                            phone_extension.phone1_extension AS area_extension,
                            v_phone_type_id
                         FROM
                           (SELECT phone1_country_code FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_country_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_country_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_country_code FROM load_employee WHERE emplid = v_emploer_num) AS phone_country,
                           
                           (SELECT phone1_area_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone2_area_code FROM load_employee WHERE empid = v_emploer_num
                            UNION SELECT phone3_area_code FROM load_employee WHERE empid = v_emploer_num
                            UNION SELECT phone4_area_code FROM load_employee WHERE empid = v_emploer_num) AS phone_area,
                            
                            (SELECT phone1_num FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_num FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_num FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_num FROM load_employee WHERE emplid = v_emploer_num) AS phone_num,
                            
                           (SELECT phone1_extension FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_extension FROM load_employee WHERE emplid = v_emploer_num) AS phone_extension;
                        
                  ELSE
                           UPDATE emp_phone_numbers
                           SET country_code = phone_country.phone1_country_code,
                               area_code = phone_area.phone1_area_code,
                               phone_number = phone_num.phone1_num,
                               extension = phone_extension.phone1_extension
                           FROM
                           (SELECT phone1_country_code FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_country_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_country_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_country_code FROM load_employee WHERE emplid = v_emploer_num) AS phone_country,
                           
                           (SELECT phone1_area_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone2_area_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_area_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_area_code FROM load_employee WHERE emplid = v_emploer_num) AS phone_area,
                            
                            (SELECT phone1_num FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_num FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_num FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_num FROM load_employee WHERE emplid = v_emploer_num) AS phone_num,
                            
                           (SELECT phone1_extension FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_extension FROM load_employee WHERE emplid = v_emploer_num) AS phone_extension
                           WHERE id = emp_phone_num_id; 
                  END IF;
         ELSE
         
                        INSERT INTO emp_phone_numbers (id, employee_id, country_code, area_code, phone_number, extension, phone_type_id)
                            SELECT row_number() OVER() AS id,
                            v_employee_id,
                            phone_country.phone1_country_code,
                            phone_area.phone1_area_code,
                            phone_num.phone1_num,
                            phone_extension.phone1_extension,
                            v_phone_type_id 
 
                        FROM
                           (SELECT phone1_country_code FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_country_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_country_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_country_code FROM load_employee WHERE emplid = v_emploer_num) AS phone_country,
                           
                           (SELECT phone1_area_code FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_area_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_area_code FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_area_code FROM load_employee WHERE emplid = v_emploer_num) AS phone_area,
                            
                            (SELECT phone1_num FROM load_employee WHERE emplid = v_emploer_num 
                            UNION SELECT phone2_num FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_num FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_num FROM load_employee WHERE emplid = v_emploer_num) AS phone_num,
                            
                           (SELECT phone1_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone2_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone3_extension FROM load_employee WHERE emplid = v_emploer_num
                            UNION SELECT phone4_extension FROM load_employee WHERE emplid = v_emploer_num) AS phone_extension;
        END IF;
   END LOOP;
END; $$ LANGUAGE plpgsql;
                            
         
        