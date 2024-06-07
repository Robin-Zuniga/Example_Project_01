-- ----------------------------------------------- --
-- DATA PROCESSING
-- 		1. Remove Duplicates
-- 		2. Standardize the Data
-- 		3. Examine Null Values and blank Data
-- 		4. Remove Any Unnecessary Columns and Rows
-- ----------------------------------------------- --


-- ----------------------------------------------- --
-- ####    PRE-PROCESSING    #### --

-- Create a copy of the original table, to protect the source data
CREATE TABLE layoffs_c0 AS
SELECT * FROM layoffs;

-- Disable safe update mode (!)
SET SQL_SAFE_UPDATES = 0;
-- ----------------------------------------------- --


-- #### 1. REMOVE DUPLICATES #### --

-- Step 1.1: Check for duplicates in the original table (before removal)
SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM
    layoffs_c0
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
HAVING
    COUNT(*) > 1;

	-- Step 1.2.1: interim control (Check if duplicates are valid)
		SELECT *
		FROM layoffs_c0
		WHERE company = 'Casper';

-- Step 1.2: Create a table to hold unique records
CREATE TABLE layoffs_c1_no_duplicates AS
SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
FROM
    layoffs_c0
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions;

-- Step 1.3: Check for duplicates in the new table (after removal)
SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM
    layoffs_c1_no_duplicates
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
HAVING
    COUNT(*) > 1;


-- #### 2. STANDARDIZE THE DATA #### --

-- Step 2.1: Create a copy of the previous table & explore the data
CREATE TABLE layoffs_c2_standardized AS
SELECT * FROM layoffs_c1_no_duplicates;

-- Step 2.2: Trim spaces from text fields
UPDATE layoffs_c2_standardized
SET 
    company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    stage = TRIM(stage),
    country = TRIM(country);

-- Step 2.3: Update the date format
UPDATE layoffs_c2_standardized
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Step 2.4: Modify the column type to DATE
ALTER TABLE layoffs_c2_standardized
MODIFY COLUMN `date` DATE;

-- Step 2.5: Explore the Data for Name irregularities
SELECT * FROM layoffs_c2_standardized;

SELECT DISTINCT company
FROM layoffs_c2_standardized
ORDER BY 1;	-- no irregularities detected

SELECT DISTINCT location
FROM layoffs_c2_standardized
ORDER BY 1;	-- no irregularities detected

SELECT DISTINCT industry
FROM layoffs_c2_standardized
ORDER BY 1; 
	-- 2 irregularities detected (industry: Crypto...)
	SELECT *
	FROM layoffs_c2_standardized
	WHERE industry LIKE 'Crypto%';

SELECT DISTINCT stage
FROM layoffs_c2_standardized
ORDER BY 1;	-- no irregularities detected

SELECT DISTINCT country
FROM layoffs_c2_standardized
ORDER BY 1; 
	-- 1 irregularity detected (country: United States...)
	SELECT *
	FROM layoffs_c2_standardized
	WHERE country LIKE 'United States%';

-- Step 2.6: Remove name irregularities
UPDATE layoffs_c2_standardized
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_c2_standardized
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Step 2.7: Repeat Step 2.5 to 2.6 until no further irregularities are detected
SELECT * FROM layoffs_c2_standardized;


-- #### 3. EXAMINE NULL VALUES AND BLANK DATA #### --

-- Step 3.1: Create a copy of the previous table & explore the data
CREATE TABLE layoffs_c3_null_values AS
SELECT * FROM layoffs_c2_standardized;

-- Step 3.2: Explore the Data for NULL values
SELECT * FROM layoffs_c3_null_values;

SELECT * FROM layoffs_c3_null_values
WHERE company IS NULL 				-- no NULL values detected
OR company = ''; 					-- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE location IS NULL 				-- no NULL values detected
OR location = ''; 					-- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE industry IS NULL 				-- 1 NULL value detected
OR industry = ''; 					-- 3 blank values detected
	-- interim control (check if data can be populated)
	SELECT * FROM layoffs_c3_null_values WHERE company = 'Airbnb';
    
SELECT * FROM layoffs_c3_null_values
WHERE total_laid_off IS NULL		-- 739 NULL values detected
OR total_laid_off = ''; 			-- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE percentage_laid_off IS NULL	-- 784 NULL values detected
OR percentage_laid_off = ''; 		-- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE `date` IS NULL; 				-- 1 NULL value detected

SELECT * FROM layoffs_c3_null_values
WHERE stage IS NULL OR '' 			-- 6 NULL values detected
OR stage = ''; 						-- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE country IS NULL 				-- no NULL values detected
OR country = ''; 					-- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE funds_raised_millions IS NULL	-- 209 NULL values detected
OR funds_raised_millions = ''; 		-- 7 blank values detected

-- Step 3.3: Populate missing INDUSTRY Data
SELECT * FROM layoffs_c3_null_values;

	-- Step 3.3.1: Select rows with NULL or empty industry fields and corresponding non-NULL industry fields
	SELECT t1.industry, t2.industry
	FROM layoffs_c3_null_values t1
	JOIN layoffs_c3_null_values t2
	ON t1.company = t2.company
	WHERE (t1.industry IS NULL OR t1.industry = '')
	AND t2.industry IS NOT NULL;

	-- Step 3.3.2: Setting blanks to NULL
	UPDATE layoffs_c3_null_values
	SET industry = NULL
	WHERE industry = '';

	-- Step 3.3.3: Update the rows with NULL or empty industry fields using corresponding non-NULL industry fields
	UPDATE layoffs_c3_null_values t1
	JOIN layoffs_c3_null_values t2
	ON t1.company = t2.company
	SET t1.industry = t2.industry
	WHERE t1.industry IS NULL
	AND t2.industry IS NOT NULL;


-- #### 4. REMOVE ANY UNNECESSARY COLUMNS AND ROWS #### --

-- Step 4.1: Create a copy of the previous table
CREATE TABLE layoffs_c4_cleaned_data AS
SELECT * FROM layoffs_c3_null_values;

-- Step 4.2: Identifying rows with missing LAYOFF Data
SELECT * FROM layoffs_c4_cleaned_data
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
	-- Note: 361 rows detected (from 2000 rows in total)
    -- Conclusion: Deleting those rows ensures that analysis is based on complete and reliable data, minimizing the risk of skewed results

-- Step 4.3: Deleting rows with missing LAYOFF Data (!)
DELETE
FROM layoffs_c4_cleaned_data
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Note: No further Data is getting deleted

-- Step 4.4: Review the cleaned Data
SELECT * FROM layoffs_c4_cleaned_data;

-- ----------------------------------------------- --
-- ####    POST-PROCESSING    #### --

-- Re-enable safe update mode (!)
SET SQL_SAFE_UPDATES = 1;

-- Drop redundant tables
DROP TABLE IF EXISTS layoffs_c0;
DROP TABLE IF EXISTS layoffs_c1_no_duplicates;
DROP TABLE IF EXISTS layoffs_c2_standardized;
DROP TABLE IF EXISTS layoffs_c3_null_values;
-- ----------------------------------------------- --

