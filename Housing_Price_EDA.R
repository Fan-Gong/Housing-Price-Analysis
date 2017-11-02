##Feature Engineering 
###Univariate Study
I will first focus on the dependent variable ('SalePrice') and try to know a little bit more about it.

```{r}
hist(df$SalePrice, breaks = 50, main = "Distribution of SalePrice", xlab = "Sale Price")
skewness(df$SalePrice)
kurtosis(df$SalePrice)
```

SalePrice is our target variable. The SalePrice feature has a positive skewness (right skewed). Since linear model usually perform better on normally distributed data, I need to transform this distribution to a normal one.

```{r}
hist(log(df$SalePrice), breaks = 50, main = "Distribution of SalePrice", xlab = "Sale Price")
skewness(log(df$SalePrice))
kurtosis(log(df$SalePrice))
df$SalePrice = log(df$SalePrice)
```
So, after taking the logarithm, `SalePrice` is almost normal distribution. 

###Multivariate Study
Then I would like to know how the dependent variable and independent variables relate.

For numerical and categorical features, we need to use different methods to show the relationship between dependent variables and independent variables.

####Numeric Variables: Correlation Matrix
```{r}
#Extract the numeric data frame
logic_numeric = sapply(df, is.numeric)
df_numeric = df[,logic_numeric]

df_CorMatrix = cor(df_numeric)
top_features_Cor = df_CorMatrix[abs(df_CorMatrix[,"SalePrice"]) > 0.5,abs(df_CorMatrix[,"SalePrice"]) > 0.5]

#General Correlation Matrix
corrplot(df_CorMatrix, method = "square", type = "full", tl.cex = 0.8)
#Top-feature Correlation Matrix
corrplot(top_features_Cor, method = "number", tl.cex = 0.7)
```

We could see that the house price (SalePrice) shows a strong positive correlation with the Overall house quality (OverallQual), the Ground living area (GrLivArea), the 1st floor area (X1stFlrSF) , the basement area (TotalBsmtSF), the full bathromms above grade (FullBath), original construction date (YearBuilt), remodel date (YearRemodAdd) and the Size of garage (GarageCars, GarageArea).

####Scatter Plots
Then let us see the relationship between these numeric variables and SalePrice.
```{r}
top_features = colnames(top_features_Cor)
length(top_features)
pairs(df[,top_features[c(1:5,11)]])
pairs(df[,top_features[6:11]])
```
We could see that both `OverallQual`, `GrLivArea`, `X1stFlrSF`, `FullBath`, `TotRmsAbvGrd`, `TotalBsmtSF` follow a linear model. `GarageCars` and `GarageArea`, `YearBuilt` and `YearRemodAdd` are follow more of a quadratic/non-linear fit. Take a closer look to `YearBuilt` and `YearRemodAdd` we can see that the most expensive houses are the most recently built and remodelled.

####Categorical Variables: box-plots

```{r}
#Extract the categorical data frame
logic_categorical = !(sapply(df, is.numeric))
df_categorical = df[,logic_categorical]
df_categorical = cbind(df_categorical, SalePrice = df$SalePrice)
```


##Model Training
I will use several different method to train our model, including linear model, random forest model and XGboost.

###Regularized Linear Model
```{r}
#I will use 80% data as training set and 20% data as validation set.
set.seed(1)
train_logic = sample(nrow(df), size = nrow(df) * 0.8)
df_train = df[train_logic,]
df_validation = df[-train_logic,]

x = model.matrix(SalePrice~., df)[,-1]
y = df$SalePrice
cv.out = cv.glmnet(x[train_logic,], y[train_logic], alpha = 0)
plot(cv.out)
bestlam = cv.out$lambda.min; bestlam

out = glmnet(x[train_logic,], y[train_logic], alpha = 0)
ridge.pred = predict(out, s = bestlam, newx = x[-train_logic,])
mean((ridge.pred - y[-train_logic])^2)

#Let us make a prediction for the test set
x_test = data.matrix(df_test)
cv.out = cv.glmnet(x, y, alpha = 0)
bestlam = cv.out$lambda.min; bestlam

out = glmnet(x, y, alpha = 0)
ridge.pred = predict(out, s = bestlam, newx = x_test)
```


