# Preset
# Preset
cat("\014") # clears console
rm(list = ls()) # clears global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) #clears packages
options(scipen = 100) # disables scientific notion for entire R session

#Loading all the required libraries
library(ggplot2)
library(pacman)
library(tidyverse)
library(tidyr)
library(janitor)
#install.packages("stringr")
library(stringr)
#install.packages('leaflet')
library(leaflet)
library(dplyr)
#install.packages('usmap')
library(usmap)
#install.packages('rworldmap')
library(rworldmap)
#install.packages('psych')
library(psych)
#install.packages("ggpubr")
library(ggpubr)

#Read Data
airbnb <- read.csv("C:/Users/farru/Desktop/ALY 6010/Final Project/listings.csv")

#Data Cleaning 
airbnb <- clean_names(airbnb)

#Removing unwanted variable
airbnb <-subset(airbnb, select = -c(id, host_id, host_name, last_review, reviews_per_month, calculated_host_listings_count, license, number_of_reviews_ltm))
#view(airbnb)


#The name column contains the name of the Airbnb along with a rating
# Extract ratings using a regular expression
ratings <- str_extract(airbnb$name, "★[0-9]+\\.[0-9]+")

# Convert the extracted ratings to numeric
ratings_numeric <- as.numeric(sub("★", "", ratings))

# Replace rows with no valid rating with NA
ratings_numeric[is.na(ratings_numeric)] <- NA

# Add the ratings to your data frame as a new column
airbnb$rating <- ratings_numeric

#Descriptive statistics
rating_table <- describe(airbnb$rating)
price_table <- describe(airbnb$price)
combin_table <- rbind.data.frame(rating_table, price_table)
rownames(combin_table) <- c("Rating", "Price")
#view(rating_table)

# Identifying which neighborhood has more listings and creating a bar plot 
neighborhood_counts <- airbnb %>%
  group_by(neighbourhood) %>%
  summarize(listing_count = n())

ggplot(neighborhood_counts, aes(x = reorder(neighbourhood, -listing_count), y = listing_count)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Distribution of Airbnb Listings by Neighborhood",
       x = "Neighborhood",
       y = "Number of Listings") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))  # Rotate x-axis labels for better readability

neighborhood_counts <- neighborhood_counts[order(-neighborhood_counts$listing_count), ]
neighborhood_counts 

#Creating Visualizations

#As we have many outliners in Price, we are cleaning outliniers to have good data and visualizations
iqr <- IQR(airbnb$price)
up <- quantile(airbnb$price, 0.50) + 1.5*iqr
low <- quantile(airbnb$price, 0.40) - 1.5*iqr
airbnb_price_cleaned <- subset(airbnb, airbnb$price>low & airbnb$price<up )


#Box Plot
ggplot(airbnb_price_cleaned , aes(x = neighbourhood_group, y = price)) +
  geom_boxplot(fill='grey') +
  labs(title="Box Plot of Neighbourhood Group vs Price",
       x='Neighbourhood Group',
       y= "Price")

#Scatter Plot
airbnb_data <- data.frame(
  latitude = airbnb_price_cleaned$latitude,  
  longitude = airbnb_price_cleaned$longitude,  
  room_type = airbnb_price_cleaned$price,  
  price = airbnb_price_cleaned$price  
)

#Visualizing the new Rating column
##As we have many Out liners in Ratings, we are cleaning out liners to have good data and visualizations

airbnb_rating_cleaned <- subset(airbnb_price_cleaned, airbnb_price_cleaned$rating>4.4)

#Histogram of numeric variable 'price' with density

ggplot(airbnb_rating_cleaned , aes(x = rating)) +
  geom_histogram(binwidth = 0.1, fill = "blue", color = "black") +
  labs(
    title = "Distribution of Ratings",
    x = "Rating",
    y = "Frequency"
  ) 

#Boxplot for Ratings
ggplot(airbnb_rating_cleaned , aes(x = 1, y = rating)) +
  geom_boxplot(fill = "lightblue") +
  labs(
    title = "Boxplot of Ratings",
    x = "",
    y = "Rating"
  )

#Bar plot for Ratings Vs neighbourhood_group
airbnb_rating_cleaned <- group_by(airbnb_rating_cleaned, neighbourhood_group)

ggplot(airbnb_rating_cleaned, aes(x = neighbourhood_group, fill = rating)) +
  geom_bar(position = "dodge", stat = "count") +
  labs(title = "Bar Plot of Ratings by Neighbourhood Group", x = "Neighbourhood Group", y = "Count of Ratings") +
  scale_fill_discrete(name = "Ratings")
 

#Creating Subsets
#Choosing the neighborhood group as Hawaii
#Also not including any rows that do not have a rating
airbnb_neigh_group <- airbnb[airbnb$neighbourhood_group == "Hawaii" & !is.na(airbnb$rating),  ]
#view(airbnb_neigh_group)

#Descriptive statistics for the new subset that we are gonna study
summary(airbnb_neigh_group$rating)
mean(airbnb_neigh_group$rating)
median(airbnb_neigh_group$rating)
sd(airbnb_neigh_group$rating)
quantile(airbnb_neigh_group$rating)


#Density plot for Price Vs neighbourhood_group
airbnb_grouped <- group_by(airbnb_price_cleaned, neighbourhood_group)
ggplot(data=airbnb_price_cleaned, aes(x=price, group=neighbourhood_group, fill=neighbourhood_group)) +
  geom_density(adjust=1.5, alpha= 0.3) +
  labs(
    title = "Density Plot of Price and Neighbourhood",
    x = "Price",
    y = "Density"
  )

# Create a leaflet map
data <- data.frame(
  latitude = (airbnb$latitude), #  latitude coordinates
  longitude = (airbnb$longitude), #  longitude coordinates
  room_type = airbnb$room_type, #  room types
  price = airbnb$price #  prices
)

map <- leaflet(data) %>%
  addTiles() %>%
  addCircleMarkers(
    lng = ~longitude,
    lat = ~latitude,
    radius = 5,
    color = "blue",
    popup = ~paste("Room Type: ", room_type, "<br>Price: $", price)
  )
# Display the map
map

### Question 1: Do Airbnb listings in specific neighborhoods differ significantly in their average price?

#### Hypotheses:
#H0: There is no significant difference in the average prices between neighborhoods North Kona and Primary Urban Center
#H1: There is a significant difference in the average prices between neighborhoods North Kona and Primary Urban Center

#Cal median price, to split it the data into low price and high price

median_price <- median(airbnb_price_cleaned$price)

#Creating subsets to store the values
high_price <- subset(airbnb_price_cleaned, price>=200 & price<=400)
low_price <- subset(airbnb_price_cleaned, price<200)

# We are combining the subset of price to access them in the t-test
combined_subset <- rbind(high_price, low_price)

# performing the t-test on price subset and neighborhood_subset
t_test <- t.test(price ~ neighbourhood, data=combined_subset, 
                 subset = neighbourhood %in% c('North Kona', 'Primary Urban Center'))
# As t-test can only be applied to 2 levels of grouping factors, creating a subset to hold two neighborhoods
t_test 

#Visualizing the data using ggboxplot
# creating and binding price subsets for 'Primary Urban Center' and 'North Kona' within high and low categories
ggboxplot(
  data = combined_subset[(combined_subset$neighbourhood %in% c('Primary Urban Center', 'North Kona')), ],
  x = "neighbourhood",
  y = "price",
  color = "neighbourhood",
  palette = c("#00AFBB", "#E7B800"),
  legend = "top",
  title = "Boxplot of Prices in Primary Urban Center and North Kona for High and Low Categories"
)+
  scale_y_continuous(limits = c(0, 600), breaks = seq(0, 600, by = 100)) 

#Creating variables for correlation
combined_subset$pvt_room <- ifelse(combined_subset$room_type == "Private room", 1, 0)
combined_subset$shared_room <- ifelse(combined_subset$room_type == "Shared room", 1, 0)
combined_subset$home <- ifelse(combined_subset$room_type == "Entire home/apt", 1, 0)
combined_subset$hotel <- ifelse(combined_subset$room_type== 'Hotel room',1,0)


### Question 2: Is there a significant difference in average price between listings with high and low ratings?

#### Hypotheses:
#H0: The average price of listings with high and low ratings is the same.
#H1: The average price of listings with high and low ratings differs significantly.

# Split data into high and low rating groups
high_rating <- combined_subset[combined_subset$rating >= 4.5, ]
low_rating <- combined_subset[combined_subset$rating <=3.5, ]


# Two-sample t-test or Mann-Whitney U test
t_test_result <- t.test(high_rating$price, low_rating$price)
t_test_result

#Regression: Does ratings and neighbourhood have any effect on pricing
# Adding neighborhood made the model better.
lmratings <- lm(price ~ rating+neighbourhood, data = combined_subset)
summary(lmratings)

# Plotting the chart.
ggplot(combined_subset, aes(x = rating, y = price)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")+
  labs(title= "Regression line between Ratings and Price") +
  scale_y_continuous(limits = c(200, 400), breaks = seq(200, 400, by = 200)) +
  scale_x_continuous(limits = c(4.5, 5), breaks = seq(4.5, 5, by = 0.5))

#Q3 Does shorter distance between properties and center of Hawaii have any effect on pricing?

#H0 There is no significant difference in mean pricing between properties within 30 km and those beyond
#H1: There is a significant difference in mean pricing between properties within 30 km and those beyond

#Distance
haversine_distance <- function(lat1, lon1, lat2, lon2) { R <- 6371

# Convert degrees to radians
lat1 <- lat1 * (pi/180)
lon1 <- lon1 * (pi/180)
lat2 <- lat2 * (pi/180)
lon2 <- lon2 * (pi/180)

# Haversine formula
dlon <- lon2 - lon1
dlat <- lat2 - lat1
a <- sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2
c <- 2 * atan2(sqrt(a), sqrt(1-a))
distance <- R * c

return(distance)

}

for (i in 1:length(airbnb_data)){
  
  airbnb_data$distance <- haversine_distance(airbnb_data$latitude,airbnb_data$longitude, 19.8987, -155.8859)
  
  
}

# Calculating distances for each property
airbnb_data$distance <- haversine_distance(airbnb_data$latitude, airbnb_data$longitude, 19.8987, -155.8859)

# Creating  have two groups: properties within 30 km and beyond 30 km

# Creating subsets based on distance 
subset_within_30km <- airbnb_data[airbnb_data$distance <= 30 & airbnb_data$price <= 400, ]
subset_beyond_30km <- airbnb_data[airbnb_data$distance > 30 & airbnb_data$price <= 400, ]

# Perform two-sample t-test to compare mean prices between the two groups
t_test_result <- t.test(subset_within_30km$price, subset_beyond_30km$price, alternative = "two.sided")

# Print t-test result
t_test_result

# Subsetting data for regression (e.g., properties within a certain distance)
subset_data <- airbnb_data[airbnb_data$distance <= 100, ]  # Adjust distance range as needed

# Fitting regression model: Does Distance have any effect on Price
lm_distance <- lm(price ~ distance, data = subset_data)
summary(lm_distance)

# Plotting regression line
ggplot(subset_data, aes(x = distance, y = price)) + 
  geom_point() +
  geom_smooth(method = "lm", col = "red") +
  labs(
    title= "Regression line between Distance and Price",
    x = 'Distance from Centre of the City',
    y = 'Price'
  ) +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 25))+
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 100))

#####Correlation

library(Hmisc)
#creating a subset to access numeric values only
subset_for_corr <- subset(combined_subset, select = c("price", "rating", "pvt_room"))

res <- rcorr(as.matrix(subset_for_corr))
res$r
#r : the correlation matrix 
#n : the matrix of the number of observations used in analyzing each pair of variables 
#P : the p-values corresponding to the significance levels of correlations.

pairs(data= combined_subset, ~ price + rating + pvt_room)
