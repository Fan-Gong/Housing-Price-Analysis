# Housing-Price-Analysis
(TOP 10% Project in Kaggle Competition)

This project aims to make a good housing price prediction based on thousands of housing data. The data has 81 features and a lot of missing data. 

* First I performed EDA to have a general idea about the data structure and also created correlation plots to see the relationship between each numeric value and boxplots to see the relationship between some important categorical data and housing price.
* Then I cleaned the data, including interpolating the most frequent value in each column and removing the outlier.
* Then I performed feature engineering including 
	* Ordinal Categorical Variable Transformation: Determine which order the categories follow and assigning the values an order from 1,2,…,n
	* Nominal Categorical Variable Transformation: Take one of the categories that is distinct from the others and create a binary feature that returns 1 if the house has that specific value and 0 if it does not
	* Other Categorical Variables: **One-hot encode** each value to get as many splits in the data as possible
	* New Feature Generation: Such as the total area; Houses have recently remodeled or not.
	* Feature Normalization: Linear models assume normality from dependant variables, so I made a log transformation.
* Feature Selection: Some of these features may have become zero-variance predictors, such that a few samples may have an insignificant influence on the model.
* Model Training: First use XGBoost tree regression model to train my model including parameter tuning. To enhense the interpreation of the model, i also performed Ridge/Lasso/elastic-net model and average the results. 
