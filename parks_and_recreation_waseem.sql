-- SECTION 1: BASIC SELECT QUERIES

-- Type   : SELECT

SELECT *
FROM employee_demographics;

SELECT *
FROM parks_and_recreation.employee_demographics;


SELECT first_name
FROM parks_and_recreation.employee_demographics;


SELECT
    first_name,
    last_name,
    birth_date
FROM parks_and_recreation.employee_demographics;


SELECT
    first_name,
    last_name,
    birth_date,
    age,
    age + 10 AS age_plus_10
FROM parks_and_recreation.employee_demographics;



-- Type   : SELECT DISTINCT

SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;

-- SECTION 2: WHERE CLAUSE FILTERS


SELECT *
FROM employee_salary
WHERE first_name = 'Leslie';


SELECT *
FROM employee_salary
WHERE salary > 50000;


SELECT *
FROM employee_salary
WHERE salary >= 50000;


SELECT *
FROM employee_salary
WHERE salary < 50000;


SELECT *
FROM employee_demographics
WHERE gender = 'female';



SELECT *
FROM employee_demographics
WHERE gender != 'female';


SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01';



SELECT *
FROM employee_demographics
WHERE birth_date >= '1985-01-01'
  AND gender = 'male';


SELECT *
FROM employee_demographics
WHERE birth_date >= '1985-01-01'
   OR gender = 'male';


SELECT *
FROM employee_demographics
WHERE birth_date >= '1985-01-01'
   OR NOT gender = 'male';



SELECT *
FROM employee_demographics
WHERE first_name = 'Leslie'
  AND age = 44;



SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44)
   OR age > 55;



-- SECTION 3: LIKE / PATTERN MATCHING
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'jer%';



SELECT *
FROM employee_demographics
WHERE first_name LIKE '%er%';



SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a%';



SELECT *
FROM employee_demographics
WHERE first_name LIKE '%a%';


SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__';


SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__%';


SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1989%';


-- SECTION 4: GROUP BY AND AGGREGATE FUNCTIONS


SELECT gender
FROM employee_demographics
GROUP BY gender;



SELECT
    gender,
    AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;


SELECT occupation
FROM employee_salary
GROUP BY occupation;


SELECT
    occupation,
    salary
FROM employee_salary
GROUP BY occupation, salary;



SELECT
    gender,
    AVG(age) AS avg_age,
    MAX(age) AS max_age
FROM employee_demographics
GROUP BY gender;


SELECT
    gender,
    AVG(age) AS avg_age,
    MIN(age) AS min_age
FROM employee_demographics
GROUP BY gender;




-- Type   : SELECT with GROUP BY + multiple aggregates


SELECT
    gender,
    AVG(age)   AS avg_age,
    MAX(age)   AS max_age,
    MIN(age)   AS min_age,
    COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender;


-- SECTION 5: ORDER BY AND LIMIT


SELECT *
FROM employee_demographics
ORDER BY first_name;


SELECT *
FROM employee_demographics
ORDER BY age ASC;



SELECT *
FROM employee_demographics
ORDER BY age DESC;



SELECT *
FROM employee_demographics
ORDER BY gender, age;


SELECT *
FROM employee_demographics
ORDER BY 5, 4;


SELECT *
FROM employee_salary
LIMIT 5;


SELECT *
FROM employee_demographics
ORDER BY age ASC
LIMIT 5;



-- SECTION 6: JOINS


SELECT *
FROM employee_demographics
INNER JOIN employee_salary
    ON 1 = 1;  


SELECT *
FROM employee_demographics
INNER JOIN employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;



SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

SELECT
    dem.employee_id,
    age,
    occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;


SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;


SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;


-- SECTION 7: UNION


SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;



SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;



SELECT first_name, last_name, age,    'old'                   AS label
FROM employee_demographics
WHERE age > 50
UNION
SELECT first_name, last_name, salary, 'highly paid employee'  AS label
FROM employee_salary
WHERE salary > 70000;



SELECT first_name, last_name, age,    'old man'               AS label
FROM employee_demographics
WHERE age > 40
  AND gender = 'male'

UNION

SELECT first_name, last_name, age,    'old lady'              AS label
FROM employee_demographics
WHERE age > 40
  AND gender = 'female'

UNION

SELECT first_name, last_name, salary, 'highly paid employee'  AS label
FROM employee_salary
WHERE salary > 70000

ORDER BY first_name, last_name;


-- SECTION 8: STRING FUNCTIONS


SELECT LENGTH('waseem') AS string_length;


SELECT
    first_name,
    LENGTH(first_name) AS name_length
FROM employee_demographics;


SELECT
    first_name,
    LENGTH(first_name) AS name_length
FROM employee_demographics
ORDER BY 2;



SELECT UPPER('waseem') AS upper_result;
SELECT LOWER('WASEEM') AS lower_result;


SELECT
    first_name,
    UPPER(first_name) AS upper_first_name
FROM employee_demographics;


SELECT TRIM('              WASEEM             ')  AS trimmed;
SELECT LTRIM('              WASEEM             ') AS left_trimmed;
SELECT RTRIM('              WASEEM             ') AS right_trimmed;



SELECT
    first_name,
    LEFT(first_name, 4)                     AS first_4_chars,
    RIGHT(first_name, 4)                    AS last_4_chars,
    SUBSTRING(first_name, 3, 2)             AS chars_3_and_4,
    birth_date,
    SUBSTRING(birth_date, 6, 2)             AS birth_month
FROM employee_demographics;


SELECT
    first_name,
    REPLACE(first_name, 'a', 'z') AS replaced_lower
FROM employee_demographics;


SELECT
    first_name,
    REPLACE(first_name, 'A', 'Z') AS replaced_upper
FROM employee_demographics;


SELECT LOCATE('i', 'waseem khan') AS position_of_i;


SELECT
    first_name,
    LOCATE('an', first_name) AS position_of_an
FROM employee_demographics;


SELECT
    first_name,
    last_name,
    CONCAT(first_name, '     ', last_name) AS full_name
FROM employee_demographics;


-- SECTION 9: CASE EXPRESSIONS


SELECT
    first_name,
    last_name,
    age,
    CASE
        WHEN age <= 30               THEN 'YOUNGER'
        WHEN age BETWEEN 31 AND 50   THEN 'OLD'
        WHEN age >= 50               THEN 'FINISHED'
    END AS stage
FROM employee_demographics;


SELECT
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary < 50000 THEN salary + (salary * 0.05)
        WHEN salary > 50000 THEN salary * 1.07
    END AS new_salary,
    CASE
        WHEN dept_id = 6    THEN salary * 0.10
    END AS bonus
FROM employee_salary;



-- SECTION 10: SUBQUERIES


SELECT *
FROM employee_demographics
WHERE employee_id IN (
    SELECT employee_id
    FROM employee_salary
    WHERE dept_id = 1
);



SELECT
    first_name,
    salary,
    (SELECT AVG(salary) FROM employee_salary) AS avg_salary
FROM employee_salary;


SELECT *
FROM (
    SELECT
        gender,
        AVG(age)   AS avg_age,
        MAX(age)   AS max_age,
        MIN(age)   AS min_age,
        COUNT(age) AS count_age
    FROM employee_demographics
    GROUP BY gender
) AS agg_table;



SELECT
    gender,
    AVG(max_age) AS avg_of_max_age
FROM (
    SELECT
        gender,
        AVG(age)   AS avg_age,
        MAX(age)   AS max_age,
        MIN(age)   AS min_age,
        COUNT(age) AS count_age
    FROM employee_demographics
    GROUP BY gender
) AS agg_table
GROUP BY gender;



SELECT AVG(max_age) AS avg_max_age
FROM (
    SELECT
        gender,
        AVG(age)   AS avg_age,
        MAX(age)   AS max_age,
        MIN(age)   AS min_age,
        COUNT(age) AS count_age
    FROM employee_demographics
    GROUP BY gender
) AS agg_table;


-- SECTION 11: TEMPORARY TABLES


CREATE TEMPORARY TABLE temp_table (
    first_name     VARCHAR(50),
    last_name      VARCHAR(50),
    favorite_movie VARCHAR(100)
);


SELECT *
FROM temp_table;



INSERT INTO temp_table (first_name, last_name, favorite_movie)
VALUES ('waseem', 'khan', '365 days');


CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;


SELECT *
FROM salary_over_50k;


-- SECTION 12: STORED PROCEDURES


CREATE PROCEDURE large_salary()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salary();



DELIMITER $$

CREATE PROCEDURE large_salary3()
BEGIN
    SELECT *
    FROM employee_salary
    WHERE salary >= 50000;

    SELECT *
    FROM employee_salary
    WHERE salary >= 10000;
END $$

DELIMITER ;

CALL large_salary3();



DELIMITER $$

CREATE PROCEDURE large_salary4(IN p_employee_id INT)
BEGIN
    SELECT salary
    FROM employee_salary
    WHERE employee_id = p_employee_id;
END $$

DELIMITER ;

-- Example calls:
CALL large_salary4(1);
CALL large_salary4(2);



-- SECTION 13: TRIGGERS

-- -----------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER employee_insert
    AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
    INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$

DELIMITER ;

-- Test the trigger:
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'waseem', 'khan', 'data analyst', 1000, NULL);

SELECT * FROM employee_salary;
SELECT * FROM employee_demographics;


-- SECTION 14: EVENTS (MySQL Scheduler)


SHOW VARIABLES LIKE 'ev%';

DELIMITER $$

CREATE EVENT delete_retirers
    ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$

DELIMITER ;



-- SECTION 15: JOIN WITH GROUP BY


SELECT gender
FROM employee_demographics AS dem
JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id
GROUP BY gender;