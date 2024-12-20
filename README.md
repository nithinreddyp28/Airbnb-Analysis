Title: "Hawaii Airbnb Analysis: Unveiling Price Determinants"

Description: This GitHub repository contains the code and documentation for a comprehensive analysis of Airbnb listings in Hawaii. The project focuses on understanding the relationships between listing prices and various factors influencing them. Leveraging the rich dataset sourced from Inside Airbnb, our analysis delves into the dynamics of pricing in one of the world's most popular holiday destinations. The repository includes data cleaning scripts, exploratory data analysis notebooks, and statistical analyses such as t-tests and linear regression models to address key questions of interest. Through this project, we aim to provide valuable insights for both travelers planning a trip to Hawaii and stakeholders in the tourism industry.

Link of the dataset: https://www.kaggle.com/datasets/deeplearner09/airbnb-listings

Questions of Interest:

Question 1: Do Airbnb listings in specific neighbourhoods differ significantly in their average price?

Hypotheses:
Null Hypothesis (H0): There is no significant difference in the average prices between neighbourhoods North Kona and Primary Urban Centre.
Alternate Hypothesis (H1): There is a significant difference in the average prices between neighbourhoods North Kona and Primary Urban Centre.
The statistical analysis strongly suggests that there is indeed a notable difference in the average prices of Airbnb listings between these two neighbourhoods. The calculated confidence interval (42.544 to 49.061) further solidifies this conclusion, indicating with 95% confidence that 'North Kona' has substantially higher average prices compared to 'Primary Urban Centre.' Therefore, the results support the alternate hypothesis, confirming a significant disparity in Airbnb listing prices between these specific neighbourhoods. 

Question 2: Is there a significant difference in average price between listings with high and low ratings?

Hypotheses:
Null Hypothesis (H0): The average price of listings with high and low ratings is the same.
Alternate Hypothesis (H1): The average price of listings with high and low ratings differs significantly.

Two Sample t-test was conducted to compare the prices between high and low-rated Airbnb listings:
•	Test Outcome: The test resulted in a t-value of 2.4461 with a corresponding degree of freedom (df) of approximately 92.172. The calculated p-value is 0.01634, suggesting statistical significance.
•	Null Hypothesis Rejection: With a p-value less than the significance level (α = 0.05), we reject the null hypothesis. This indicates a statistically significant difference in the average prices between high-rated (‘mean of x = 204.85’) and low-rated (‘mean of y = 183.40’) Airbnb listings.
•	Confidence Interval: The 95% confidence interval for the difference in means ranges from 4.032 to 38.853. This interval suggests that there's a high likelihood (95% confidence) that the true difference in mean prices between these groups falls within this range.

Question 3: Does shorter distance between properties and centre of Hawaii have any effect on pricing?

Hypotheses:
Null Hypothesis (H0): There is no significant difference in mean pricing between properties within 30 km and those beyond.
Alternate Hypothesis (H1): There is a significant difference in mean pricing between properties within 30 km and those beyond.

Since two sample t-test was conducted to compare the prices of listing between two different groups, referring to figure 16 more details of the analysis was given as below:
•	Test Outcome: The t-value of the test equal to 9.435 with degree of freedom equal to 1548.9. The calculated p-value is less than 0.0001.
•	Null Hypothesis Rejection: Since the p-value is far less than the chosen significant level (α = 0.05), we reject the null hypothesis and have strong evidence to conclude that there is a significant difference in the prices of listing between properties within 30 km of the centre of Hawaii and those beyond.
•	Confidence Interval: The 95% confidence interval for the difference in means ranges from 18.088 to 27.583. This interval suggests that there's a high likelihood (95% confidence) that the true difference in mean prices between these groups falls within this range.

Conclusion:
This project analyzed Airbnb data in Hawaii to understand factors influencing listing prices. Using exploratory data analysis, we examined relationships between prices and variables such as neighborhoods, ratings, and distances to the center of the Big Island.

Key findings include:

Neighborhoods: Listings in urban areas like North Kona tend to have higher prices, revealing significant geographical price distinctions.
Ratings: Guest comments and ratings were found to impact prices, emphasizing the role of reviews in pricing strategies.
Distances: Listings closer to the center of the Big Island were more expensive, with significant price variations observed within a 30 km radius.

Overall, this study provides valuable insights for travelers and hosts by highlighting how location, reviews, and geography influence Airbnb prices in Hawaii.



