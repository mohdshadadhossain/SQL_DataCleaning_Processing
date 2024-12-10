# SQL Data Cleaning: Nashville Housing Dataset
This project demonstrates data cleaning techniques applied to the Nashville Housing dataset using SQL. It focuses on processing and enhancing data quality by standardizing formats, addressing missing values, and eliminating redundancies.

# Dataset:

Nashville Housing Data: Contains details on property sales, ownership, prices, and related information in the Nashville area.

# Key SQL Tasks Performed:
•	Standardizing Date Formats: Ensured uniformity in date fields.
•	Validating Data Types: Checked columns (e.g., SalePrice) to confirm expected data types.
•	Handling Missing Data:
o	Identified columns with null values.
o	Populated missing property addresses using ParcelID.
•	Splitting Address Fields: Divided PropertyAddress and OwnerAddress into separate components (e.g., Address, City, State).
•	Consistency Checks: Converted Y/N values in the SoldAsVacant column to Yes/No.
•	Removing Duplicates: Detected and eliminated duplicate records using the ROW_NUMBER function.
•	Exploratory Data Analysis: Conducted initial analyses, such as:
o	House price distribution.
o	Properties by land use category.
