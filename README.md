# Housing-Project
THe repo contains an SQL code and an R code. The SQL code serves mainly as a data cleaning and transformation step that prepares the data for modelling in R

This SQL code contains a series of commands for data cleaning and formatting for a database named HousingDb with a table named NashvilleHousing. Here is a brief explanation of each section:

1. The first query selects all columns from the NashvilleHousing table.
2. The second query standardizes the date format for the SaleDate column by converting it to the Date data type.
3. The third section involves populating the PropertyAddress column for rows where it is currently NULL. It first selects all such rows, orders them by ParcelID, and then matches them with rows with the same ParcelID but a different UniqueID. It then uses the ISNULL function to update the PropertyAddress column in the original table with the non-NULL value from the matched row.
4. The fourth section reformats the PropertyAddress column by splitting it into two columns, one for the street address and the other for the city. It first selects all values from the PropertyAddress column, then uses the SUBSTRING function to split the column into two parts. It then creates two new columns in the original table, PropertySplitAddress and PropertySplitCity, and populates them with the appropriate values using the UPDATE command.
5. The fifth section reformats the OwnerAddress column by splitting it into three columns for the street address, city, and state. It first selects all values from the OwnerAddress column, then uses the PARSENAME function to split the column into three parts using the comma as the delimiter. It then creates three new columns in the original table, OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState, and populates them with the appropriate values using the UPDATE command.
6. The sixth section changes the values in the SoldAsVacant column from "Y" to "Yes" and from "N" to "No" using the CASE statement. It first selects all distinct values from the SoldAsVacant column along with their counts to verify the original distribution of values. It then creates a new column with the reformatted values using the CASE statement, and updates the original table with the new values using the UPDATE command.
7. The final section removes duplicates from the table by selecting all columns from the NashvilleHousing table, and then creating a common table expression (CTE) that assigns row numbers to each row based on its ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference columns. It then selects all rows where the row number is greater than 1, which indicates a duplicate, and orders them by PropertyAddress. Finally, it creates a new view named house_view that includes only the desired columns from the original table with the new column names specified as described in section 4 and 5.


This R code reads in a CSV file containing housing data and performs several data analysis tasks using the ggplot2 and dplyr libraries. 

First, it converts certain columns in the housing data to numeric format and removes any rows with missing values. Then, it creates a scatterplot matrix of the variables of interest, which in this case are acreage and sale price. It also creates a histogram of the sale price variable to visualize the distribution of the data. 

Next, it creates a boxplot of the sale price variable by land use type to compare the sale prices across different land use types. 

Finally, it builds a linear regression model to predict sale prices based on several variables, including bedrooms, full bath, half bath, year built, acreage, land value, and building value. It prints a summary of the model and uses the model to make predictions on new data.

Overall, this R code is useful for exploring and analyzing housing data and building a predictive model for sale prices.
