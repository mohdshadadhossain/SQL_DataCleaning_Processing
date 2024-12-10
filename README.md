# SQL Data Cleaning: Nashville Housing Dataset
This project demonstrates data cleaning techniques applied to the Nashville Housing dataset using SQL. It focuses on processing and enhancing data quality by standardizing formats, addressing missing values, and eliminating redundancies.

# Dataset:

Nashville Housing Data: Contains details on property sales, ownership, prices, and related information in the Nashville area.

# Key SQL Tasks Performed:
Standardizing Dates: Ensured date fields follow a consistent format.

Validating Data Types: Checked if columns, like SalePrice, conform to expected data types (e.g., numeric).

Handling Missing Data: Identified null values and filled missing property addresses using ParcelID.

Splitting Address Fields: Separated PropertyAddress and OwnerAddress into components such as Address, City, and State.

Consistency Checks: Converted Y/N entries in the SoldAsVacant column to Yes/No.

Duplicate Removal: Detected and removed duplicate rows using the ROW_NUMBER function.

Exploratory Analysis: Conducted basic analyses, such as examining house prices and distribution across land uses.
