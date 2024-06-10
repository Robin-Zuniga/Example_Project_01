# Analysis of Worldwide Layoffs

## Table of Contents
- [Project Overview](#project-overview)
- [Dataset Description](#dataset-description)
- [Tools](#tools)
- [Data Processing](#data-processing)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Insights](#insights)
- [Limitations](#limitations)

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
  2. Are layoffs more frequent in specific months?
  3. Which industries are experiencing the highest number of layoffs?

### Insights
The dataset on worldwide layoffs provides a comprehensive view of job cuts across various industries and regions. It includes data from **51 countries**, involving **1272 companies** over a period of **3 years and 3 months**. The analysis aims to shed light on the trends and impacts of these layoffs on a global scale. On **average**, the number of layoffs per company is approximately **514**, reflecting significant workforce reductions across diverse sectors.

The analysis results are summarized as follows:
1. **Yearly Increase:** The graph highlights how external events (like the War in Ukraine) and technological advancements (like the release of ChatGPT) can correlate with increased layoffs. It also shows a broader trend of rising layoffs in the latter part of the period studied, indicating a period of economic adjustment and instability. Companies and policymakers can use such insights to better understand and potentially mitigate the impacts of these events on the labor market.

	The 7-day moving average is used to smooth out daily fluctuations, providing a clearer view of the underlying trends and making it easier to identify significant changes over time.
	``` python
	# Calculate and plot the 7-day moving average of the 'total_laid_off'
	layoffs_trends.set_index('date')['total_laid_off'].rolling(window=7).mean().plot(
	    style='-', lw=3, color='#1f77b4', label='7-day Moving Average', alpha=0.8)
	```
	
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
