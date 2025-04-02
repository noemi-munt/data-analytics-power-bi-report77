# Quarterly Review - Power BI Report 
## Table of Contents
1. [Project Description](#project-description)
2. [Installation Instructions](#installation-instructions)
3. [Usage Instructions](#usage-instructions)
4. [File Structure](#file-structure)
5. [License](#license)

## Project Description
This comprehensive quarterly report provides a high-level business summary aimed at C-suite executives. It offers insights into top-performing customers segmented by sales region, detailed analysis of products against sales targets, and a map visualization highlighting the performance of retail outlets across various regions.

**Target Audience:**  
- C-suite executives
- Regional Managers
- Product team

_For more details on the project refer to the project [Wiki](https://github.com/noemi-munt/data-analytics-power-bi-report77/wiki)._
## Installation Instructions
To use the Power BI report, follow these steps:

1. Install Power BI Desktop from the official Microsoft website.
1. Download the report files from the repository.
1. Open the .pbix file in Power BI Desktop.

## Usage Instructions
This report is designed to allow interactive filtering and includes the following pages:

- Executive Summary Page: Provides an overview of company performance with KPIs, charts, and tables.
- Customer Detail Page: Offers an in-depth analysis of customer distribution and growth over time.
- Product Detail Page: Displays performance metrics and profitability across product categories.
- Stores Map Page: Allows regional managers to assess store performance using geographical data.
- Drillthrough Page: Enables deeper insights into individual store performance and product sales.

To navigate between pages using the navigation bar or to open the filter panel use Ctrl+Click on the desired icon. To move through a date or geography heirarchy select the visual and click on the single downward arrow to enable Drill down. To Drill through on store on the Stores Map page, drill down to the `Country Region` level and left click on the store and select Drill through.

## File Structure
```
project-directory/
│── PowerBIProject # PowerBI file containing the report
│── SQL Query & Output Files
    │──question_1.csv # Question 1 Output 
    │──question_1.sql # Question 1 SQL Query
    │──question_2.csv # Question 2 Output
    │──question_2.sql # Question 2 SQL Query
    │──question_3.csv # Question 3 Output
    │──question_3.sql # Question 3 SQL Query
    │──question_4.csv # Question 4 Output
    │──question_4.sql # Question 4 SQL Query
    │──question_5.csv # Question 5 Output
    │──question_5.sql # Question 5 SQL Query
│── README.md
```

---

## License

This project is licensed under the MIT License. 

---
_Last updated: 02/04/2025_

