-- Name: Yinsheng Dong
-- yid164
-- load pay_frequencies function

CREATE OR REPLACE FUNCTION load_pay_frequencies()
RETURNS void AS $$
        
BEGIN
        
        INSERT INTO pay_frequencies (id, code, name, description)
        SELECT row_number() OVER() AS id,
               UPPER (SUBSTRING(pay_freq, 0, 4)),
               pay_freq,
               CONCAT(pay_freq, 'Payment')
        FROM load_employee
        GROUP BY pay_freq;
END; $$ LANGUAGE plpgsql;