-- Name: Yinsheng Dong
-- Student Number: 11148648
-- NSID: yid164
-- Lecture: CMPT 355

CREATE TABLE assessments (
        id INT,
        name VARCHAR(100),
        type VARCHAR(10),
        total_point NUMERIC,
        weight NUMERIC,
        due_date DATE,
        section_id INT NOT NULL REFERENCES sections,
        PRIMARY KEY (id));
        
CREATE TABLE enrollment_assessments(
        id INT,
        enrollment_id INT NOT NULL REFERENCES enrollments,
        assessments_id INT NOT NULL REFERENCES assessments,
        point NUMERIC,
        PRIMARY KEY (id));
        
