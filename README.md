# Flight_Delay_Analysis
A comprehensive data analytics project analyzing 5+ million flight records to identify delay patterns, airline performance, and operational inefficiencies in the US aviation industry.

## Technologies Used

### Data Processing & ETL
- **MySQL**: Database management and complex queries
- **Python (Pandas)**: Data validation and quality checks
- **Power Query**: Data transformation in PowerBI
- **Tableau Prep**: Data preparation for Tableau

### Visualization & BI Tools
- **Tableau**: Interactive dashboards and advanced analytics
- **PowerBI**: Business intelligence reports and KPIs
- **Excel**: Initial data exploration and pivot analysis

### Data Handling Scale
- **Total Records**: 5.8 million flight records
- **Data Size**: 2.1 GB raw CSV files
- **Time Period**: 2015 full year data
- **Airlines**: 14 major US carriers
- **Airports**: 320+ airports nationwide

## Key Business Questions Answered

1. **Operational Efficiency**
   - Which airlines have the best on-time performance?
   - How do weekday vs weekend operations differ?
   - What are the peak delay periods throughout the day?

2. **Geographic Analysis**
   - Which airports experience the most delays?
   - How do delay patterns vary by state and region?
   - What are the most reliable flight routes?

3. **Seasonal Trends**
   - How do delays vary by month and quarter?
   - What impact do holidays have on flight operations?
   - Are there specific weather-related delay patterns?

## Key Performance Indicators (KPIs)

### Primary Metrics
- On-Time Performance Rate (78.4%)
- Average Departure Delay (12.3 minutes)
- Cancellation Rate (1.8%)
- Significant Delay Rate (>30 mins: 15.2%)

### Advanced Metrics
- Airline Reliability Score
- Route Efficiency Index
- Delay Cost Impact Estimation
- Seasonal Performance Trends

## Installation & Setup

### Prerequisites
- MySQL 8.0+
- Tableau Desktop 2022+
- PowerBI Desktop
- Python 3.8+ (optional)

### Database Setup
```sql
-- 1. Create database
CREATE DATABASE aviation_analysis;

-- 2. Import data (see sql/database_setup.sql)
SOURCE sql/database_setup.sql;

-- 3. Run data cleaning procedures
SOURCE sql/data_cleaning.sql;

## Dashboard Setup
Tableau: Connect to MySQL database using provided credentials

PowerBI: Import processed CSV files from /data/processed/

Excel: Use power query to connect to database or CSV files.

##  Dashboard Features
### Tableau Dashboard
Interactive metric toggles (Departure vs Arrival delays)

Geographic heat maps of delay patterns

Airline performance comparisons

Time-series trend analysis

Drill-down capabilities to individual flights

### PowerBI Reports
Executive summary with key metrics

Detailed airline performance reports

Monthly operational reviews

Predictive delay analysis

Learning Outcomes

### Technical Skills Demonstrated

Large-scale data processing (5M+ records)

Database design and optimization

Advanced SQL queries and stored procedures

Data visualization best practices

ETL pipeline development

### Business Insights Delivered

Identified $15M+ in potential delay cost savings

Recommended optimal flight scheduling patterns

Provided data-driven airline performance benchmarks

Developed predictive models for delay forecasting
