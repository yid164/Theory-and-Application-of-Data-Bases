-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

UPDATE instructors
SET 
        employee_number = 00000,
        first_name = 'Ellen',
        last_name = 'Redlick',
        seniority_date = TO_DATE('04/06/2015','MM/DD/YYYY'),
        email_address = 'ellen.redilick@usask.ca'
WHERE 
      id = (SELECT DISTINCT s.instructor_id FROM sections s, courses c WHERE c.code = 'CMPT355' and s.course_id = c.id);
