-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

SELECT COUNT(s) AS count_of_num_sections
FROM sections s
WHERE s.num_enrolled = (SELECT COUNT(e.id)
                        FROM enrollments e
                        WHERE e.section_id = s.id);
        