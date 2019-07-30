-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

SELECT 
        c.code,
        c.name, 
        s.lec_type, 
        s.max_enrollment, 
        s.num_enrolled, 
        s.max_enrollment-s.num_enrolled AS remain, 
        i.first_name||' '||i.last_name AS instructor_name, 
        t.start_date, 
        t.end_date,
        s.start_time, 
        s.end_time
FROM terms t
JOIN courses c ON c.code LIKE 'CMPT%'
JOIN sections s ON s.term_id = t.id AND c.id = s.course_id
JOIN instructors i ON i.id = s.instructor_id;