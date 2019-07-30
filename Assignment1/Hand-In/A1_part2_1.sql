-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

SELECT 
        u.name AS university_name,
        d.name AS department_name,
        c.code AS course_code,
        c.name AS course_name,
        c.course_desc AS course_description,
        c.credit_units AS credit_unit
FROM universities u, departments d, courses c
WHERE u.name = 'University of Saskatchewan' AND c.department_id = d.id
GROUP BY university_name, department_name, course_code, course_name, course_description, credit_unit;

