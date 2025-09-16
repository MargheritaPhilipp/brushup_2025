
# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)

################################################################################
# 1. Importing data and explore the basics
################################################################################

# Assuming the relative path to the data file is available, we'll load the CSV file.
df_og <- read.csv('files/data/WB_extra/WB_gni_edu.csv')

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

# Filter the data for rows for a chosen Series.Name - why is there a comma at the end?
subset_data <- df_og[df_og$Series.Name == "GNI per capita, Atlas method (current US$)", ]

# Find the row with the maximum value in the value_column within the filtered data
max_row <- subset_data[which.max(subset_data$X2023), ]

# Print the row with the maximum value
print(max_row)

################################################################################
# 2. Reshaping data
################################################################################
# used to address a problem (always handy to work with a smaller data set)
#df_albania <- df_og[df_og$Country.Name == "Albania",]
#df_og <- df_albania

# Replace pattern "..YRYYYY." with ""
colnames(df_og) <- gsub("\\.\\.YR[0-9]{4}\\.", "", colnames(df_og))

# Define column vectors to keep
index_cols <- c( "Series.Name", "Series.Code", "Country.Name", "Country.Code")
year_cols <- c('X1990', 'X2000', 'X2015', 'X2020', 'X2022')

# Keep only the columns in index_cols and year_cols
df_subset <- df_og[ , c(index_cols, year_cols)]

################################################################################
# Melt the data frame
df_melted <- df_subset %>%
  pivot_longer(cols = all_of(year_cols), 
               names_to = "year", 
               values_to = "values")

# View a sample of the data
sample_n(df_melted, 5)

################################################################################
# Pivot the data 

colnames(df_melted)

df_clean <- df_melted %>%
  mutate(
    Series.Name = trimws(Series.Name),
    Series.Name = na_if(Series.Name, "")
  ) %>%
  # drop rows with missing series names...
  filter(!is.na(Series.Name))

pivoted_df <- df_clean %>%
  pivot_wider(
    id_cols = c("year", "Country.Name", "Country.Code"),
    names_from = "Series.Name", 
    values_from = "values"
  )

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
                      #"PopulationTotal" = "Population, total",
                      "ChildrenOutOfSchoolPercent" = "Children out of school (% of primary school age)",
                      "PrimaryComplRate" = "Primary completion rate, total (% of relevant age group)",
                      "GNIPerCapita" = "GNI per capita, Atlas method (current US$)",
                      "GNI" = "GNI, Atlas method (current US$)")

# Rename columns using the named vector - Note the different expected order to python: rename(new_name = old_name)
df_renamed <- pivoted_df %>%
  rename(!!!new_column_names)

# View the new column names - let's drop the two weird ones
colnames(df_renamed)

# backticks allow R to handle spaces, colons, and special characters in column names
df_renamed <- subset(df_renamed, 
                     select = -c(`Data from database: World Development Indicators`, 
                                 `Last Updated: 07/01/2025`))
colnames(df_renamed)

################################################################################
# 4. Plot some values
################################################################################

# show boxplots of population data for several years
# Filter the data for the years 2003, 2013, and 2023
df_selected_years <- df_renamed[df_renamed$Year %in% c(1990, 2015, 2022), ]

# Convert to numeric if necessary
df_selected_years$GNI <- as.numeric(df_selected_years$GNI)

# Create a boxplot with PopulationTotal for each of the selected years
# Can yoy work out who has been increasing so much?
boxplot(GNI ~ Year, 
        data = df_selected_years, 
        #main = "Boxplot of ____ for the Years ___", 
        xlab = "Year", 
        ylab = "GNI", 
        col = "lightblue")

################################################################################
# 5. Remove missing values
################################################################################
# check for missing value
colSums(is.na(df_renamed))

# drops rows with missing values
df_nomissing <- df_renamed %>% na.omit()

# Drop rows with missing values only in specific columns 
#df_outofschooldata <- df_renamed %>% drop_na(ChildrenOutOfSchoolPercent)
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
    ChildrenOutOfSchoolPercent = as.numeric(ChildrenOutOfSchoolPercent),
    GNIPerCapita = as.numeric(GNIPerCapita),
    GNI = as.numeric(GNI)
  )
# Create an estimated population column - can you add the population data to check if it's right?
df$Population <- df$GNI / df$GNIPerCapita


################################################################################
# 7. Basic scatter plots
################################################################################

# Create the scatter plot
ggplot(df, aes(x = GNI, y = ChildrenOutOfSchoolPercent)) +
  geom_point(color = "blue") +
  labs(title = "Scatter Plot of GNI vs ChildrenOutOfSchoolPercent",
       x = "GNI Per Capita",
       y = "Children Primary Age of Population") +
  theme_minimal()

# create another with a different variable
ggplot(df, aes(x = GNIPerCapita, y = ??)) +
  geom_point(color = "blue") +
  labs(title = "Scatter Plot of GNIPerCapita vs ??",
       x = "GNI Per Capita",
       y = "??") +
  theme_minimal()

################################################################################
# 8. Saving the new data
################################################################################

# Save the filtered dataset to a new CSV file
write.csv(df, 'files/data/WB_extra/WB_reshaped_R.csv', row.names = FALSE)

