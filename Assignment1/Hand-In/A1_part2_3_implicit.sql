-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

SELECT 
        c.code AS course_code,
        c.name AS course_name, 
        s.lec_type AS lecture_type, 
        s.max_enrollment AS max_enrollment, 
        s.num_enrolled AS num_cur_enrolled, 
        s.max_enrollment-s.num_enrolled AS remain, 
        i.first_name||' '||i.last_name AS instructor_name, 
        t.start_date AS start_date, 
        t.end_date AS end_date,
        s.start_time AS start_time, 
        s.end_time AS end_time
FROM courses c, sections s, instructors i, terms t
WHERE c.code LIKE 'CMPT%' and c.id = s.course_id and s.term_id = t.id and i.id = s.instructor_id;