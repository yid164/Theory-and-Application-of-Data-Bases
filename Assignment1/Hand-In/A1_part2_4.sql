-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355


SELECT  
        section_info.course_code AS course_code,
        section_info.course_name AS course_name,
        section_info.lec_type AS lecture_type,
        section_info.num_of_section AS num_of_section

        
FROM
         (SELECT
          COUNT(s.lec_type) AS num_of_section,
          c.code AS course_code,
          c.name AS course_name,
          s.lec_type
          FROM sections s,courses c
          WHERE s.course_id = c.id
          GROUP BY course_code, course_name,s.lec_type 
          ORDER BY num_of_section ASC) AS section_info
ORDER BY course_code ASC;
