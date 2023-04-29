# Load necessary libraries
library(ggplot2)
library(dplyr)

# Read in housing data from CSV file
housing_data <- read.csv("Desktop/Data Analyst /Tableau/Nashville /Housing.csv")

# Convert certain columns to numeric format
housing_data[, c("LandValue", "BuildingValue", "TotalValue", "YearBuilt", "Bedrooms", 
"FullBath", "HalfBath", "Acreage")] <- lapply(housing_data[, c("LandValue", "BuildingValue", "TotalValue", "YearBuilt", 
"Bedrooms", "FullBath", "HalfBath", "Acreage")], as.numeric)

# Remove any rows with missing values
housing_data <- na.omit(housing_data)

# Create a scatterplot matrix of variables of interest
ggplot(data = housing_data, aes(x = Acreage, y = SalePrice)) +
  geom_point() +
  geom_smooth(method = "lm") +
  ggtitle("Scatterplot of Sale Price by Acreage") +
  labs(x = "Acreage", y = "Sale Price") +
  theme_bw()

# Create a histogram of the sale price variable
ggplot(data = housing_data, aes(x = SalePrice)) +
  geom_histogram(binwidth = 100000) +
  ggtitle("Distribution of Sale Prices") +
  labs(x = "Sale Price", y = "Count") +
  theme_bw()

# Create a boxplot of the sale price variable by land use type
ggplot(data = housing_data, aes(x = LandUse, y = SalePrice)) +
  geom_boxplot() +
  ggtitle("Sale Prices by Land Use Type") +
  labs(x = "Land Use Type", y = "Sale Price") +
  theme_bw()

# Build linear regression model to predict sale prices
model <- lm(SalePrice ~ Bedrooms + FullBath + HalfBath + YearBuilt + Acreage + LandValue + BuildingValue, data = housing_data)

# Print summary of model
summary(model)

# Use the model to make predictions on new data
new_data <- data.frame(Bedrooms = 3, FullBath = 2, HalfBath = 1, YearBuilt = 1990, Acreage = 0.5, LandValue = 100000, BuildingValue = 200000)
prediction <- predict(model, newdata = new_data)
cat("Prediction for new data 1:", prediction, "\n")

new_data_1 <- data.frame(Bedrooms = 2, FullBath = 1, HalfBath = 2, YearBuilt = 2000, Acreage = 1, LandValue = 10000, BuildingValue = 20000)
prediction_1 <- predict(model, newdata = new_data_1)
cat("Prediction for new data 2:", prediction_1, "\n")
