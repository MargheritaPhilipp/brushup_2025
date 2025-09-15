
# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)

################################################################################
# 1. Importing data and explore the basics
################################################################################

# Assuming the relative path to the data file is available, we'll load the CSV file.
df_og <- read.csv('./data/WB_more_data.csv')

# dimension of data set (shape)
dim(df_og)

# show structure
str(df_og)

# show head
head(df_og)

# check column names
colnames(df_og)

# check for missing value - remember that this is misleading due to the way the WB encodes missing values with ".."
sapply(df_og, function(x) sum(is.na(x)))
colSums(is.na(df_og)) # same but neater

# Replace all occurrences of ".." with NA
df_og[df_og == ".."] <- NA

# check again
colSums(is.na(df_og))

################################################################################
# Find the maximum value among population for 2023

# Filter the data for rows where Series.Name is "pop"
pop_data <- df_og[df_og$Series.Name == "Population, total", ]

# Find the row with the maximum value in the value_column within the filtered data
max_pop_row <- pop_data[which.max(pop_data$X2023), ]

# Print the row with the maximum value
print(max_pop_row)

################################################################################
# 2. Reshaping data
################################################################################
# used to address a problem (always handy to work with a smaller data set)
#df_albania <- df_og[df_og$Country.Name == "Albania",]
#df_og <- df_albania

# Define the year columns
year_cols <- c('X2001', 'X2002', 'X2003', 'X2011', 'X2012', 'X2013', 'X2021', 'X2022', 'X2023')

################################################################################
# Melt the data frame
df_melted <- df_og %>%
  pivot_longer(cols = all_of(year_cols), 
               names_to = "year", 
               values_to = "values")

# View a sample of the data
sample_n(df_melted, 5)

################################################################################
# Pivot the data frame
pivoted_df <- df_melted %>%
  pivot_wider(names_from = "Series.Name", 
              values_from = "values",
              id_cols = c(year, Country.Name, Country.Code))

# Print the dimensions of the pivoted data frame
print(dim(pivoted_df))

# View a sample of the data
pivoted_df[sample(nrow(pivoted_df), 4), ]


################################################################################
# 3. Renaming columns and cleaning year values
################################################################################
# Use gsub to remove the "X" prefix from the year column
pivoted_df$year <- gsub("X", "", pivoted_df$year)

# Optionally, convert the year column to numeric
pivoted_df$year <- as.numeric(pivoted_df$year)

# Check the updated column
head(pivoted_df$year)

################################################################################
# Remind yourself of the current names before renaming
colnames(pivoted_df)

# Create a named vector (like a dictionary) for renaming columns
new_column_names <- c(
                      "CountryName" = "Country.Name",
                      "CountryCode" = "Country.Code",
                      "Year" = "year",
                      "PopulationTotal" = "Population, total",
                      "ChildrenOutOfSchoolPercent" = "Children out of school (% of primary school age)",
                      "ChildrenOutOfSchoolPrimary" = "Children out of school, primary",
                      "GNIPerCapita" = "GNI per capita, Atlas method (current US$)",
                      "GNI" = "GNI, Atlas method (current US$)")

# Rename columns using the named vector - Note the different expected order to python: rename(new_name = old_name)
df_renamed <- pivoted_df %>%
  rename(!!!new_column_names)

# View the new column names
colnames(df_renamed)

################################################################################
# 4. Plot some values
################################################################################

# show boxplots of population data for several years
# Filter the data for the years 2003, 2013, and 2023
df_selected_years <- df_renamed[df_renamed$Year %in% c(2003, 2013, 2023), ]

# Convert 'PopulationTotal' to numeric if necessary
df_selected_years$PopulationTotal <- as.numeric(df_selected_years$PopulationTotal)

# Create a boxplot with PopulationTotal for each of the selected years
boxplot(PopulationTotal ~ Year, 
        data = df_selected_years, 
        main = "Boxplot of Population for the Years 2003, 2013, and 2023", 
        xlab = "Year", 
        ylab = "Population", 
        col = "lightblue")

################################################################################
# 5. Remove missing values
################################################################################
# check for missing value
colSums(is.na(df_renamed))

# drops rows with missing values
df_nomissing <- df_renamed %>% na.omit()

# Drop rows with missing values only in specific columns 
#df_schooldata <- df_renamed %>% drop_na(ChildrenOutOfSchoolPrimary, ChildrenOutOfSchoolPercent)
#df_gnidata <- df_renamed %>% drop_na(GNI)


################################################################################
# 6. Create features
################################################################################

df <- df_nomissing

# note that some are still characters rather than numeric
str(df)

# Convert to numeric if they are not already
df <- df %>%
  mutate(
    ChildrenOutOfSchoolPrimary = as.numeric(ChildrenOutOfSchoolPrimary),
    ChildrenOutOfSchoolPercent = as.numeric(ChildrenOutOfSchoolPercent),
    PopulationTotal = as.numeric(PopulationTotal)
  )
# Perform same calculations as in python
df <- df %>%
  mutate(
    ChildrenPrimaryAgeTotal = ChildrenOutOfSchoolPrimary * 100 / ChildrenOutOfSchoolPercent,
    ChildrenPrimaryAgeOfPop = round(ChildrenPrimaryAgeTotal / PopulationTotal, 7)
  )

################################################################################
# 7. Basic scatter plots
################################################################################

# Create the scatter plot
ggplot(df, aes(x = GNIPerCapita, y = ChildrenPrimaryAgeOfPop)) +
  geom_point(color = "blue") +
  labs(title = "Scatter Plot of GNIPerCapita vs ChildrenPrimaryAgeOfPop",
       x = "GNI Per Capita",
       y = "Children Primary Age of Population") +
  theme_minimal()

# Create the scatter plot
ggplot(df, aes(x = GNI, y = ChildrenOutOfSchoolPercent)) +
  geom_point(color = "blue") +
  labs(title = "Scatter Plot of GNI vs ChildrenOutOfSchoolPercent",
       x = "GNI Per Capita",
       y = "Children Primary Age of Population") +
  theme_minimal()

################################################################################
# 8. Saving the new data
################################################################################

# Save the filtered dataset to a new CSV file
write.csv(df, './data/WB_reshaped_R.csv', row.names = FALSE)

