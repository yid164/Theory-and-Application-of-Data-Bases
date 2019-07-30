-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355
SELECT
        c.code AS course_code,
        c.name AS course_name,
        s.section_code AS section_code,
        s.lec_type AS lecture_type,
        CASE
                WHEN s.num_enrolled > s.max_enrollment THEN 'section over-filled'
                WHEN s.num_enrolled < s.max_enrollment THEN 'room available'
                WHEN s.num_enrolled = s.max_enrollment THEN 'section full'
        END AS status
FROM courses c, sections s
WHERE c.id = s.course_id
GROUP BY course_code, course_name, section_code, lecture_type, status
ORDER BY course_code ASC;
