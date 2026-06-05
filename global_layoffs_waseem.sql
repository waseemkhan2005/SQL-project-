
-- SECTION 1: STAGING TABLE SETUP

SELECT *
FROM layoffs;


CREATE TABLE layoffs_staging
LIKE layoffs;



INSERT INTO layoffs_staging
SELECT *
FROM layoffs;



SELECT *
FROM layoffs_staging;


-- SECTION 2: DUPLICATE DETECTION & REMOVAL

WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;



SELECT *
FROM layoffs_staging
WHERE company = 'Casper';




CREATE TABLE `layoffs_staging2` (
    `company`               TEXT,
    `location`              TEXT,
    `industry`              TEXT,
    `total_laid_off`        INT          DEFAULT NULL,
    `percentage_laid_off`   TEXT,
    `date`                  TEXT,
    `stage`                 TEXT,
    `country`               TEXT,
    `funds_raised_millions` INT          DEFAULT NULL,
    `row_num`               INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry,
                        total_laid_off, percentage_laid_off,
                        `date`, country, funds_raised_millions
       ) AS row_num
FROM layoffs_staging;



SELECT *
FROM layoffs_staging2
WHERE row_num > 1;



DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- SECTION 3: STANDARDIZE DATA


SELECT company, TRIM(company) AS company_trimmed
FROM layoffs_staging2;



UPDATE layoffs_staging2
SET company = TRIM(company);



SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;



UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country,
       TRIM(TRAILING '.' FROM country) AS country_cleaned
FROM layoffs_staging2
ORDER BY country;



UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United%';



SELECT `date`,
       STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM layoffs_staging2;



UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');



ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- SECTION 4: HANDLE NULL / BLANK VALUES


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;



SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
   OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';



UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';



SELECT t1.company,
       t1.industry  AS industry_missing,
       t2.industry  AS industry_source
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;



UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;



SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
   OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- SECTION 5: FINAL CLEANUP

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT *
FROM layoffs_staging2;



-- SECTION 6: EXPLORATORY DATA ANALYSIS (EDA)

SELECT SUBSTRING(`date`, 6, 2) AS `month`,
       SUM(total_laid_off)      AS total_laid_off
FROM layoffs_staging2
GROUP BY `month`
ORDER BY `month`;



SELECT SUBSTRING(`date`, 1, 7) AS `month`,
       SUM(total_laid_off)      AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY `month` ASC;


WITH rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `month`,
           SUM(total_laid_off)      AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `month`
    ORDER BY `month` ASC
)
SELECT `month`,
       total_off,
       SUM(total_off) OVER (ORDER BY `month`) AS rolling_total
FROM rolling_total;



SELECT company,
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;


SELECT company,
       YEAR(`date`)        AS `year`,
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY total_laid_off DESC;



WITH company_year AS (
    SELECT company,
           YEAR(`date`)        AS `year`,
           SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_year_rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY `year`
               ORDER BY total_laid_off DESC
           ) AS ranking
    FROM company_year
    WHERE `year` IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;
