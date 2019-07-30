-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- CMPT355

CREATE OR REPLACE VIEW update_view AS
        SELECT e.employee_number AS emplid,
               e.title AS title,
               e.first_name AS firstName,
               e.middle_name AS middleName,
               e.last_name AS last_name,
               CASE e.gender 
                WHEN 'M' THEN 'Male'
                WHEN 'F' THEN 'Female'
                ELSE 'Unknow' END AS gender,
               TO_CHAR(e.birth_date,'YYYY/MM/DD') AS birthdate,
               ms.name AS maritalStatus,
               e.home_email AS homeEmail,
               TO_CHAR(e.hire_date,'YYYY/MM/DD') AS OrigHireDate,
               TO_CHAR(e.rehire_date, 'YYYY/MM/DD') AS rehireDate,          
               
               TO_CHAR(e.termination_date,'YYYY/MM/DD') AS termDate,
               tt.name AS termType,
               tr.name AS termReason,
               j.name AS jobTitle,
               j.code AS jobCode,
               TO_CHAR(ej.effective_date,'YYYY/MM/DD') AS jobStartDt,
               TO_CHAR(ej.expiry_date,'YYYY/MM/DD') AS jobEndDt,
               d.code AS departmentCode,
               l.code AS locationCode,
               pf.name AS payFreq,
               pt.name AS payType,
               '$' || hourly_ej.pay_amount AS hourlyAmount,
               '$' || salary_ej.pay_amount AS salaryAmount,
               sup_job.code AS supervisorJobCode,
               es.name AS employeeStatus,
               ej.standard_hours AS standardHours,
               et.name AS employeeType,
               est.name AS employmentStatusType,
               rr.id AS lastPerformanceRating,
               rr.review_text AS lastPerformanceRatingText,
               TO_CHAR(er.review_date,'YYYY/MM/DD') AS lastPerformanceRatingDate,
               regexp_replace (homeAddress.street, '[^0-9]*', '', 'g') AS homeStreetNum,
               TRIM (BOTH (split_part(homeAddress.street, ' ',
                           LENGTH(REPLACE(homeAddress.street, ' ', '  '))-LENGTH(homeAddress.street)+1)) || split_part(homeAddress.street, ' ', 1) FROM 
                           homeAddress.street) AS homeStreetName,
               split_part(homeAddress.street, ' ', array_length(regexp_split_to_array(homeAddress.street, '\s'),1)) AS homeStreetSuffix,
               homeAddress.city AS homeCity,
               homeProvince.name AS homeState,
               homeCountry.name AS homeCountry,
               homeAddress.postal_code AS homeZipCode,
               regexp_replace (busAddress.street, '[^0-9]*', '', 'g') AS busStreetNum,
               TRIM (BOTH (split_part(busAddress.street, ' ',
                           LENGTH(REPLACE(busAddress.street, ' ', '  '))-LENGTH(busAddress.street)+1)) || split_part(busAddress.street, ' ', 1) FROM 
                           busAddress.street) AS busStreetName,
               split_part(busAddress.street, ' ', array_length(regexp_split_to_array(busAddress.street, '\s'),1)) AS busStreetSuffix,
               busAddress.city AS busCity,
               busProvince.name AS busState,
               busCountry.name AS busCountry,
               busAddress.postal_code AS busZipCode,
              
               phone1.country_code AS phone1CountryCode,
               phone1.area_code AS phone1AreaCode,
               phone1.ph_number AS phone1Number,
               phone1.extension AS phone1Extension,
               
               phone1_type.name AS phone1Type,
               
               phone2.country_code AS phone2CountryCode,
               phone2.area_code AS phone2AreaCode,
               phone2.ph_number AS phone2Number,
               phone2.extension AS phone2Extension,
               phone2_type.name AS phone2Type,
               phone3.country_code AS phone3CountryCode,
               phone3.area_code AS phone3AreaCode,
               phone3.ph_number AS phone3Number,
               phone3.extension AS phone3Extension,
               phone3_type.name AS phone3Type,
               phone4.country_code AS phone4CountryCode,
               phone4.area_code AS phone4AreaCode,
               phone4.ph_number AS phone4Number,
               phone4.extension AS phone4Extension,
               phone4_type.name AS phone4Type
               

               
               FROM employees e
                    JOIN employee_jobs ej ON ej.employee_id = e.id 
                    JOIN jobs j ON j.id = ej.job_id
                    JOIN departments d ON d.id = j.department_id
                    JOIN locations l ON l.id = d.location_id
                    JOIN marital_statuses ms ON ms.id = e.marital_status_id
                    LEFT JOIN termination_types tt ON tt.id = e.term_type_id
                    LEFT JOIN termination_reasons tr ON tr.id = e.term_reason_id
                    JOIN pay_frequencies pf ON pf.id = j.pay_frequency_id
                    JOIN pay_types pt ON pt.id = j.pay_type_id
                    LEFT JOIN jobs hourly_j ON hourly_j.id = ej.job_id AND hourly_j.pay_type_id = 1
                    LEFT JOIN employee_jobs hourly_ej ON hourly_ej.id = ej.id AND hourly_ej.job_id = hourly_j.id
                    LEFT JOIN jobs salary_j ON salary_j.id = ej.job_id AND salary_j.pay_type_id = 2
                    LEFT JOIN employee_jobs salary_ej ON salary_ej.id = ej.id AND salary_ej.job_id = salary_j.id
                    LEFT JOIN jobs sup_job ON sup_job.id = j.supervisor_job_id 
                    LEFT JOIN employee_jobs sup_ej ON sup_ej.job_id = sup_job.id
                                 AND CURRENT_DATE BETWEEN sup_ej.effective_date 
                                                  AND COALESCE(sup_ej.expiry_date, CURRENT_DATE+1)
                    JOIN employee_statuses es ON es.id = ej.employee_status_id
                    JOIN employee_types et ON et.id = ej.employee_type_id
                    LEFT JOIN employment_status_types est ON est.id = e.employment_status_id
                    LEFT JOIN employee_reviews er ON er.employee_id = e.id
                    LEFT JOIN review_ratings rr ON rr.id = er.rating_id
                    LEFT JOIN emp_addresses homeAddress ON homeAddress.employee_id = e.id AND homeAddress.type_id = 1
                    LEFT JOIN provinces homeProvince ON homeProvince.id = homeAddress.province_id
                    LEFT JOIN countries homeCountry ON homeCountry.id = homeAddress.country_id
                    LEFT JOIN emp_addresses busAddress ON busAddress.employee_id = e.id AND busAddress.type_id = 2
                    LEFT JOIN provinces busProvince ON busProvince.id = busAddress.province_id
                    LEFT JOIN countries busCountry ON busCountry.id = busAddress.country_id
                    
                    LEFT JOIN phone_numbers phone1 ON phone1.employee_id = e.id AND phone1.id = (SELECT pn.id FROM phone_numbers pn 
                    WHERE pn.employee_id = e.id OFFSET 0 LIMIT 1)
                    
                    LEFT JOIN phone_types phone1_type ON phone1_type.id = phone1.type_id
                    
                    
                    LEFT JOIN phone_numbers phone2 ON phone2.employee_id = e.id AND phone2.id = (SELECT pn.id FROM phone_numbers pn 
                    WHERE pn.employee_id = e.id OFFSET 1 LIMIT 1 )
                    
                    LEFT JOIN phone_types phone2_type ON phone2_type.id = phone2.type_id
                    
                    
                    
                    
                    LEFT JOIN phone_numbers phone3 ON phone3.employee_id = e.id AND phone3.id = (SELECT pn.id FROM phone_numbers pn 
                    WHERE pn.employee_id = e.id OFFSET 2 LIMIT 1)
                    
                    LEFT JOIN phone_types phone3_type ON phone3_type.id = phone3.type_id
                    
                    
                    
                    
                    LEFT JOIN phone_numbers phone4 ON phone4.employee_id = e.id AND phone4.id = (SELECT pn.id FROM phone_numbers pn 
                    WHERE pn.employee_id = e.id OFFSET 3 LIMIT 1)
                    
                    LEFT JOIN phone_types phone4_type ON phone4_type.id = phone4.type_id
                    
                   
                   
                   
                   
                    GROUP BY e.id, 
                             ms.name, 
                             tt.name,
                             tr.name,
                             j.name,
                             j.code,
                             ej.effective_date, 
                             ej.expiry_date,
                             d.code,
                             l.code,
                             pf.name,
                             pt.name,
                             hourly_ej.pay_amount,
                             salary_ej.pay_amount,
                             sup_job.code,
                             es.name,
                             ej.standard_hours,
                             et.name,
                             est.name,
                             rr.id,
                             er.review_date,
                             homeaddress.street,
                             homeaddress.city,
                             homeaddress.province_id,
                             homeprovince.name,
                             homeaddress.country_id,
                             homecountry.name,
                             homeaddress.postal_code,
                             busaddress.street,
                             busaddress.city,
                             busaddress.province_id,
                             busprovince.name,
                             busaddress.country_id,
                             buscountry.name,
                             busaddress.postal_code,
                             phone1.country_code,
                             phone1.area_code,
                             phone1.ph_number,
                             phone1.extension,
                             phone1_type.name,
                             phone2.country_code,
                             phone2.area_code,
                             phone2.ph_number,
                             phone2.extension,
                             phone2_type.name,
                             phone3.country_code,
                             phone3.area_code,
                             phone3.ph_number,
                             phone3.extension,
                             phone3_type.name,
                             phone4.country_code,
                             phone4.area_code,
                             phone4.ph_number,
                             phone4.extension,
                             phone4_type.name;
                             
                   
SELECT * FROM update_view;