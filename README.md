# Quarterly Review - Power BI Report

## 📌 Overview
**Description:** This comprehensive Quarterly report presents a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.

**Target Audience:**  
- C-suite executives
- Regional Managers
- Product team

---

## 📊 Data Sources & Model
**Imported Tables:**  
- `Orders` is imported from an Azure SQL Database
- `Stores` is imported from an Azure Blob Storage
- `Products` and `Customers` are imported from local csv files

**Data Transformation:** 
  - Remove sensitive client information such as card numbers from the `Orders` table
  - Create a `Full Name` column in the `Customers` table by combining `[First Name]` and `[Last Name]` 
  - Ensure all regions are correctly and consistently spelled in `Stores[Region]`
  - Removed null/empty/duplicate records  
  - Deleted unnecessary columns  
  - Ensured consistent naming conventions  

**Data Model:**  
- Built a **star schema** to optimise query performance and maintainability.  
- Summary of relationships:  
  - `Products[product_code]` → `Orders[product_code]`  
  - `Stores[store_code]` → `Orders[Store Code]`  
  - `Customers[User UUID]` → `Orders[User ID]`  
  - `Date[date]` → `Orders[Order Date]`  
  - `Date[date]` → `Orders[Shipping Date]`  

![Data Model](https://github.com/user-attachments/assets/2b2b02df-4b0c-42bd-b963-c2ff66e3cb38)


---

## 📅 Creating the Date Table  
To generate a date table, the following DAX expression was used:  
```DAX
Date Table =
CALENDAR(
    MIN(Orders[Order Date]),
    MAX(Orders[Order Date])
)
```
This generates a column of dates from the first to most recent order date. The following DAX expressions were used to created the calculated columns.

```DAX
Day of Week = FORMAT('Date Table'[Date], "dddd")
```

```DAX
Month Number = MONTH('Date Table'[Date])
```

```DAX
Month Name = FORMAT('Date Table'[Date], "mmmm")
```

```DAX
Quarter = "Q" & ROUNDUP(MONTH('Date Table'[Date]) / 3, 0)
```

```DAX
Year = YEAR('Date Table'[Date])
```

```DAX
Start of Year = STARTOFYEAR('Date Table'[Date])
```

```DAX
Start of Quarter = STARTOFQUARTER('Date Table'[Date])
```

```DAX
Start of Month = STARTOFMONTH('Date Table'[Date])
```

```DAX
Start of Week = 'Date Table'[Date] - WEEKDAY('Date Table'[Date], 2) + 1
```

Mark the table as the Date Table and ensure the active relationship between the Order table and Date table is between `Date Table[Date]` and `Orders[Order Date]`. This allows for date-based aggregations and time intelligence calculations.

---

## 📈 Key Measures & Calculations  
### Core KPIs  
- **Total Orders** 
  ```DAX
  Total Orders = COUNTROWS(Orders)
  ```
- **Total Revenue**  
  ```DAX
  Total Revenue = SUMX(
      Orders,
      Orders[Product Quantity] * RELATED(Products[Sale Price])
  )
  ```
- **Total Profit**  
  ```DAX
  Total Profit = SUMX(
      Orders,
      Orders[Product Quantity] * (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price]))
  )
  ```
- **Total Customers**  
  ```DAX
  Total Customers = COUNTA(Customers[User UUID])
  ```
- **Total Quantity**
  ``` DAX
  Total Quantity = SUM(Orders[Product Quantity])
  ```

- **Profit YTD**: Calculates the total profit earned from the beginning of the current year
  ``` DAX
  Profit YTD = TOTALYTD (
    SUMX (Orders,
      Orders[Product Quantity] * (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price]))),
      Orders[Order Date] 
  )
  ```
- **Revenue YTD**: Calculates the total revenue earned from the beginning of the current year
  ``` DAX
  Revenue YTD = TOTALYTD(
      SUMX(
      Orders,
      Orders[Product Quantity] * RELATED(Products[Sale Price])
      ),
      Orders[Order Date]
  )
  ```

### 🌍 Creating Date & Geography Hierarchies  
To improve filtering and visualisation, hierarchies were created:  
- **Date hierarchy**  
  - `Start of Year` → `Start of Quarter` → `Start of Month` → `Start of Week` → `Date`
- **Geography hierarchy**  
  - `Region` → `Country` → `Country Region`

To calculate the `Country` column the `Country Code` column was converted to the country's full name.
#### DAX for Country Column  
```DAX
Country = 
IF( 
    Stores[Country Code] = "GB", "Great Britain",
    IF(Stores[Country Code] = "DE", "Germany", "United States")
)
```
To calculate the `Geography` column the store's region was concatenated to the store's country. 
#### DAX for Geography Column  
```DAX
Geography = CONCATENATE(
    Stores[Country Region], 
    CONCATENATE(", ", Stores[Country])
)
```

---

## 🗂️ Report Structure & Key Features
### 📊 Executive Summary Page  
This page aims to give an overview of the company's performance as a whole and visualises outcomes against key targets.

**Key Visuals:** 
- **KPIs**: Quarterly revenue, orders, and profit compared to a target of 5% growth across each measure. Red indicates a target is not met.
- **Cards**: Total revenue, orders, and profit  
- **Line Chart**: Revenue over time  
- **Donut Charts**: Revenue by country and store type  
- **Bar Chart**: Orders by product category  
- **Table**: Top 10 Products


![Executive Summary](https://github.com/user-attachments/assets/c0fd9bd4-94ba-439a-a5f7-8f87c0e7d44f)


---

### 🛍️ Customer Detail Page  
This page aims to provide a comprehensive analysis of the customer base and allows filtering by country and product categories.

**Key Visuals:** 
- **Donut charts**: Customer distribution by country and product category  
- **Line chart**: Customer growth over time  
- **Table**: Top 20 customers by revenue  
- **Cards**: Top customer by revenue, number of unique customers, revenue per customer 

![Customer Summary](https://github.com/user-attachments/assets/692f888a-d586-4019-810f-513eefe156b3)


---

### 📦 Product Detail Page  
This page aims to give the Product Team an overview of total revenue, top products, and profitability across different product categories.

**Key Visuals:**  
- **Gauge Visuals**: Quarterly targets of 10% quarter-on-quarter growth in all three key metrics. 
- **Table**: Top 10 Products 
- **Line Graph**: Revenue by product category over time  
- **Scatter Graph**: Profit per item vs quantity sold  
![Product Detail](https://github.com/user-attachments/assets/80f2b741-1fa7-4319-b2e0-e72692af5b2d)
#### Slicer Toolbar

Slicers allow users to filter report pages, but multiple slicers can clutter the layout. To resolve this, a pop-out toolbar is created using Power BI's bookmarks feature. This toolbar can be accessed via a navigation bar button and hidden when not in use.

To implement the toolbar: 
1. Create a slicer panel
1. Add a filter button which opens the slicer panel
1. Add two slicers in "Vertical List" style
    1. `Products[Category]` (with "multi-select" enabled)
    1. `Stores[Country]` (with "Select All" enabled)
1. Group the slicers, toolbar shape, and back button
1. Open the Bookmarks pane and create:
    1. Slicer Bar Closed (with toolbar hidden)
    1. Slicer Bar Open (with toolbar visible)
1. Uncheck "Data" to prevent bookmarks from affecting slicer selections.
1. In the Format pane, enable Action for:
    1. The "Filter button" (assign to "Slicer Bar Open" bookmark)
    1. The "Back button" (assign to "Slicer Bar Closed" bookmark)

![Product Detail Toolbar](https://github.com/user-attachments/assets/514ca724-7397-4e3c-8458-d914f2911f23)

---

### 🏬 Stores Map Page
This page allows Regional Managers to compare individual stores agaisnt their profit targets and to drillthrough to key metrics of each store.

**Key Visuals:**  
- **Map**: Showing the `ProfitYTD` with the ability to move through the Geography hierarchy from region all the way down to individual stores
- **Country Slicer**: Allows the user to select multiple regions 
- **Gauge Tooltip**: Hovering over a store shows a `Prfit YTD` gauge against the `Profit Goal` target
![Stores Map](https://github.com/user-attachments/assets/d75cc2c2-ad86-4cc6-862b-9a900ed59e9d)

#### Drillthrough Page Setup
The drillthrough page gives a quick summary of a stores performance in key Quarterly targets and top selling products.

**Key Visuals:**
- **Table**: Top 5 products based on `Total Orders`
- **Column Chart**: `Total Orders` by product category 
- **Gauges**: `Profit YTD` and `Revenue YTD` against a target of 20% year-on-year growth vs. the same period in the previous year. 
- **Card**: Showing the currently selected store

![Stores Drillthrough](https://github.com/user-attachments/assets/482df94c-bee9-4965-a9e5-8d78bf729cb4)


#### Tooltip Setup
Create a custom tooltip page, and copy the profit gauge visual from the drillthrough page, then set the tooltip of the map visual to the tooltip page.

![Stores Map Tooltip](https://github.com/user-attachments/assets/b9ef0cb7-1b04-45fb-8e27-7b7d2f19de8a)

---

## 🖱️ Cross Filtering & Navigation Settings  
Removing unintentional cross filtering is important for maintaining useful visualisations. 
To remove unwanted interactions between visuals click on the visual you would like to remove cross filtering and go to the Edit Interactions view in the Format tab ribbon.
![Edit Interactions](https://github.com/user-attachments/assets/204b9738-4b56-4cfe-a4c2-7c8512d6ab05)

The following interactions were set for each page:

### Executive Summary Page  
- **Product Category bar chart** and **Top 10 Products table** → should not filter KPIs  

### Customer Detail Page  
- **Top 20 Customers table** → should not filter any visuals  
- **Total Customers by Product Category** → should not filter the customers line graph  
- **Total Customers by Country** → should cross-filter **Total Customers by Product Category**

### Product Detail Page  
- **Quantity Sold vs. Profit per Item** → should not filter other visuals  
- **Top 10 Products table** → should not filter other visuals  

---
## 🛢️ Key Metrics Extraction using SQL  

To share key insights with clients who do not use Power BI, SQL queries were used to extract relevant data directly from the database. The database is hosted on a **PostgreSQL server** on **Microsoft Azure**. Queries were executed using **VS Code** with the **SQLTools extension**.  

### Questions Answered  

The following key business questions were addressed:  

1. **Total Staff Count (UK)** – How many staff are employed across all UK stores?  
2. **Highest Revenue Month (2022)** – Which month had the highest revenue in 2022?  
3. **Top-Performing Store Type (Germany, 2022)** – Which German store type generated the highest revenue in 2022?  
4. **Sales Summary by Store Type** – Create a summary table where:  
   - Rows represent different store types  
   - Columns include total sales, percentage of total sales, and order count  
5. **Most Profitable Product Category (Wiltshire, UK, 2021)** – Which product category generated the highest profit in this region and year?  

### SQL Query & Output Files  

The SQL scripts and corresponding CSV outputs are stored in the project directory under the following filenames:  

| Question | SQL File | CSV Output |  
|----------|---------|------------|  
| Total Staff Count (UK) | `question_1.sql` | `question_1.csv` |  
| Highest Revenue Month (2022) | `question_2.sql` | `question_2.csv` |  
| Top-Performing Store Type (Germany, 2022) | `question_3.sql` | `question_3.csv` |  
| Sales Summary by Store Type | `question_4.sql` | `question_4.csv` |  
| Most Profitable Product Category (Wiltshire, UK, 2021) | `question_5.sql` | `question_5.csv` |  


_Last updated: 28/03/2025_

