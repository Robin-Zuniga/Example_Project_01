# Analysis of Worldwide Layoffs

## Table of Contents
- [Project Overview](#project-overview)
- [Dataset Description](#dataset-description)
- [Tools](#tools)
- [Data Processing](#data-processing)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Insights](#insights)
- [Limitations](#limitations)
- [Appendix](#appendix)

### Project Overview
In today's rapidly evolving business environment, understanding workforce trends is crucial for strategic decision-making. Layoffs have significant implications for companies, employees, and the broader economy. This project analyzes a comprehensive dataset of layoffs across various industries and locations to uncover patterns and insights that can inform better workforce management strategies. Understanding layoff trends is essential for mitigating negative impacts and ensuring business continuity. By leveraging data-driven insights, organizations can develop more resilient workforce strategies and better prepare for economic uncertainties.

### Dataset Description
The primary dataset used for this analysis is the "layoffs.csv" file, containing detailed information on [layoffs from multiple companies worldwide](https://layoffstracker.com/). Each record in the dataset represents a layoff event and includes the following key attributes:
  1.	**Company:** The name of the company where the layoffs occurred.
  2.	**Location:** The specific location (city) of the company.
  3.	**Industry:** The industry in which the company operates.
  4.	**Total Laid Off:** The total number of employees laid off during the event.
  5.	**Percentage Laid Off:** The percentage of the total workforce affected by the layoffs.
  6.	**Date:** The date when the layoff event was reported.
  7.	**Stage:** The business stage of the company (e.g., Series B, Post-IPO).
  8.	**Country:** The country where the company is based.
  9.	**Funds Raised (Millions):** The amount of funds the company has raised in millions.

### Tools
- **Excel**
- **SQL** - Data Cleaning
  - DBMS: MySQL --> [Download MySQL](https://dev.mysql.com/downloads/installer/)
- **Python** - Data Analysis & Visualization
  - Environment: Google Colab --> [Use Google Colab](https://colab.research.google.com/)

### Data Processing
  1. Remove duplicates
  2. Standardize the data
  3. Examine null values and blank data
  4. Remove any unnecessary columns and rows

### Exploratory Data Analysis
EDA involved exploring the layoffs data to answer key questions, such as:
  1. What are the overall trends in layoffs over time?
  2. Are layoffs more frequent in specific months or seasons?
  3. Which industries are experiencing the highest number of layoffs?

### Insights
The analysis results are summarized as follows:
1. **Yearly Increase:** The graph highlights how external events (like the War in Ukraine) and technological advancements (like the release of ChatGPT) can correlate with increased layoffs. It also shows a broader trend of rising layoffs in the latter part of the period studied, indicating a period of economic adjustment and instability. Companies and policymakers can use such insights to better understand and potentially mitigate the impacts of these events on the labor market.

![total_layoffs_over_time](https://github.com/Robin-Zuniga/Example_Project_01/assets/157915112/8832e292-f5e2-4c5e-898f-a695aa0d429a)

2. **Monthly Variations:** Layoffs are not evenly distributed throughout the year. Certain months experience significantly higher layoffs compared to others. Specifically in **January** and **November** layoffs are higher than average.
    - Layoffs in January and November can be particularly high due to several key reasons:
      - End of Fiscal Year Adjustments
      - Performance Reviews and Contract Endings
      - Tax and Financial Reporting

![monthly_layoffs](https://github.com/Robin-Zuniga/Example_Project_01/assets/157915112/ab9f93bc-037c-4cf9-ab84-387f44247f68)

3. The **industries** experiencing the highest number of layoffs, according to the data, include **Consumer, Retail, Other, and Transportation**. Here are potential causes for the high number of layoffs in these industries:
    - **Consumer Industry:**
      - *Market Saturation:* High competition and market saturation can lead to decreased sales and profits, prompting companies to cut costs.
      - *Changing Consumer Preferences:* Shifts in consumer behavior and preferences can impact demand for certain products, leading to downsizing.
      - *Economic Downturns:* Economic recessions or downturns can reduce consumer spending, affecting revenue and leading to layoffs.
    - **Retail Industry:**
      - *E-commerce Growth:* The rise of e-commerce has put pressure on traditional brick-and-mortar retailers, leading to store closures and layoffs.
      - *Seasonal Adjustments:* Retail often hires seasonal workers for holidays and lays them off afterward.
   - **Other Industries:**
     - This category can encompass a wide range of sectors, and layoffs may be driven by diverse factors such as technological disruption, regulatory changes, or economic conditions affecting specific industries within this category.
   - **Transportation Industry:**
     - *Economic Cycles:* The transportation sector is closely tied to economic cycles. Economic slowdowns can reduce demand for transportation services.
     - *Fuel Prices:* Fluctuations in fuel prices can impact profitability, leading to cost-cutting measures including layoffs.
     - *Technological Changes:* Automation and technological advancements can reduce the need for certain types of labor in transportation.

	![industry_layoffs_pie_chart](https://github.com/Robin-Zuniga/Example_Project_01/assets/157915112/7e5213ba-82e4-4342-9e2e-2b06a28bb64c)

### Limitations
  1. **Incomplete Data:** Some entries in the dataset have missing values, particularly in the 'percentage_laid_off' column. This can skew the analysis and lead to incomplete or inaccurate insights.
  2. **Temporal Coverage:** The dataset may not cover all relevant time periods equally, leading to potential biases in understanding trends over time. The absence of data for certain months or years could affect the overall analysis.
  3. **Geographic Limitations:** The dataset includes layoffs from various locations, but it may not be comprehensive for all regions or countries. This geographic limitation can affect the generalizability of the findings.
  4. **Industry Classification:** The categorization of companies into industries might be broad or inconsistent. Some industries are grouped under "Other," which can obscure specific trends within more narrowly defined sectors.
  5. **Causality:** The data primarily shows correlations but does not provide insights into the causal factors behind layoffs. Understanding the reasons behind trends requires more in-depth analysis and additional data sources.
  6. **Company-Specific Factors:** Layoff decisions are often influenced by company-specific factors such as management decisions, financial health, and strategic changes, which are not detailed in the dataset. This limits the ability to generalize findings across all companies within an industry.

### Appendix
#### SQL Code for Data Processing
``` sql
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
WHERE company IS NULL -- no NULL values detected
OR company = ''; -- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE location IS NULL -- no NULL values detected
OR location = ''; -- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE industry IS NULL -- 1 NULL value detected
OR industry = ''; -- 3 blank values detected
	-- interim control (check if data can be populated)
	SELECT * FROM layoffs_c3_null_values WHERE company = 'Airbnb';
    
SELECT * FROM layoffs_c3_null_values
WHERE total_laid_off IS NULL -- 739 NULL values detected
OR total_laid_off = ''; -- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE percentage_laid_off IS NULL -- 784 NULL values detected
OR percentage_laid_off = ''; -- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE `date` IS NULL; -- 1 NULL value detected

SELECT * FROM layoffs_c3_null_values
WHERE stage IS NULL OR '' -- 6 NULL values detected
OR stage = ''; -- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE country IS NULL -- no NULL values detected
OR country = ''; -- no blank values detected

SELECT * FROM layoffs_c3_null_values
WHERE funds_raised_millions IS NULL	-- 209 NULL values detected
OR funds_raised_millions = ''; 		  -- 7 blank values detected

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
```
#### Python Code for Data Analysis & Visualization
``` python
# import library
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

# Load the data
file_path = '/content/layoffs_c4_cleaned_data.csv'
layoffs_data = pd.read_csv(file_path)
```
``` python
# Convert the 'date' column to datetime format
layoffs_data['date'] = pd.to_datetime(layoffs_data['date'])

# Group the data by date and sum the total_laid_off
layoffs_trends = layoffs_data.groupby('date')['total_laid_off'].sum().reset_index()

# Plotting the graph with enhancements and dark background
plt.figure(figsize=(14, 8), facecolor='#1A1A1A')

# Adding a smoothed line plot
layoffs_trends.set_index('date')['total_laid_off'].rolling(window=7).mean().plot(
    style='-', lw=3, color='#1f77b4', label='7-day Moving Average', alpha=0.8)

# Adding scatter plot for actual data points
plt.scatter(layoffs_trends['date'], layoffs_trends['total_laid_off'], color='#ff7f0e', alpha=0.8, label='Actual Data', s=20)

# Adding vertical lines for significant events
plt.axvline(pd.to_datetime('2022-02-24'), color='red', linestyle='--', lw=2, label='War in Ukraine')
plt.axvline(pd.to_datetime('2022-11-30'), color='green', linestyle='--', lw=2, label='Release of ChatGPT')

# Adding titles and labels
plt.title('Total Layoffs Over Time', fontsize=16, color='white')
plt.xlabel('Date', fontsize=14, color='white')
plt.ylabel('Total Laid Off', fontsize=14, color='white')
plt.grid(True, which='both', linestyle='--', linewidth=0.5, alpha=0.5)

# Formatting x-axis for better readability
plt.gca().xaxis.set_major_locator(mdates.MonthLocator(interval=1))
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
plt.xticks(rotation=45, color='white')
plt.yticks(color='white')

# Adding legend
legend = plt.legend(facecolor='#1A1A1A', edgecolor='white', fontsize=12)
for text in legend.get_texts():
    text.set_color('white')

# Annotating the events with increased distance
plt.text(pd.to_datetime('2022-02-24') - pd.Timedelta(days=15), max(layoffs_trends['total_laid_off']) * 0.9, 
         'War in Ukraine', color='red', fontsize=12, ha='right')
plt.text(pd.to_datetime('2022-11-30') - pd.Timedelta(days=15), max(layoffs_trends['total_laid_off']) * 0.9, 
         'Release of ChatGPT', color='green', fontsize=12, ha='right')

# Set plot background color
plt.gca().set_facecolor('#1A1A1A')

# Save the plot with a dark background
plt.savefig('/content/total_layoffs_over_time.png', facecolor='#1A1A1A')

# Show plot
plt.show()
```
``` python
# Convert the 'date' column to datetime format
layoffs_data['date'] = pd.to_datetime(layoffs_data['date'])

# Extract month from the date column
layoffs_data['month'] = layoffs_data['date'].dt.month

# Group by month to find the total layoffs per month
monthly_layoffs = layoffs_data.groupby('month')['total_laid_off'].sum().reset_index()

# Month names for x-axis
months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

# Plotting the total layoffs per month with enhancements and dark background
plt.figure(figsize=(14, 8), facecolor='#1A1A1A')

# Creating the bar plot with orange color
plt.bar(monthly_layoffs['month'], monthly_layoffs['total_laid_off'], color='#ff7f0e', alpha=0.8)

# Adding titles and labels
plt.title('Total Layoffs by Month', fontsize=16, color='white')
plt.xlabel('Month', fontsize=14, color='white')
plt.ylabel('Total Laid Off', fontsize=14, color='white')
plt.grid(True, axis='y', linestyle='--', linewidth=0.5, alpha=0.5)

# Formatting x-axis for better readability
plt.xticks(monthly_layoffs['month'], months, rotation=45, color='white')
plt.yticks(color='white')

# Set plot background color
plt.gca().set_facecolor('#1A1A1A')

# Save the plot with a dark background
plt.savefig('/content/monthly_layoffs.png', facecolor='#1A1A1A')

# Show plot
plt.show()
```
``` python
# Group by industry to find the total layoffs per industry
industry_layoffs = layoffs_data.groupby('industry')['total_laid_off'].sum().reset_index()

# Get the top industries by layoffs
top_industries = industry_layoffs.sort_values(by='total_laid_off', ascending=False).head(10)

# Define a set of minimalistic, matte blue tones
colors = ['#003f5c', '#2f4b7c', '#665191', '#a05195', '#d45087', '#f95d6a', '#ff7c43', '#ffa600', '#ffd700', '#b6d700']

# Plotting the pie chart for industries with the highest number of layoffs
plt.figure(figsize=(14, 8), facecolor='#1A1A1A')

# Creating the pie chart with the chosen color scheme and custom design choices
wedges, texts, autotexts = plt.pie(
    top_industries['total_laid_off'], 
    labels=top_industries['industry'], 
    colors=colors, 
    autopct='%1.1f%%', 
    startangle=140, 
    pctdistance=0.85, 
    wedgeprops={'edgecolor': 'white', 'linewidth': 2}
)

# Customizing the text for a clean and futuristic look
for text in texts:
    text.set_color('white')
    text.set_fontsize(12)
    text.set_fontweight('bold')
for autotext in autotexts:
    autotext.set_color('white')
    autotext.set_fontsize(10)
    autotext.set_fontweight('bold')  # Make the numbers bold

# Adding a title
plt.title('Industries with the Highest Number of Layoffs', fontsize=18, color='white', fontweight='bold')

# Adding a circle at the center to make it a donut chart
centre_circle = plt.Circle((0, 0), 0.70, fc='#1A1A1A', edgecolor='white', linewidth=2)
plt.gca().add_artist(centre_circle)

# Ensuring the pie chart is drawn as a circle
plt.gca().set_aspect('equal')

# Set plot background color
plt.gca().set_facecolor('#1A1A1A')

# Save the plot with a dark background
plt.savefig('/content/industry_layoffs_pie_chart.png', facecolor='#1A1A1A')

# Show plot
plt.show()
```
