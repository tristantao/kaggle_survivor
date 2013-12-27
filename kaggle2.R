## Kaggle Exercise ##
source('kaggle_util.R')

setwd("/Users/t-rex-Box/Desktop/work/kaggle_survivor/")
#setwd("/Users/Brian_Liou/Documents/STAT151A") #Setting WD for mee

trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = F)
trainDataOriginal = trainData
testDataOriginal = testData
# Holding the PassengerId column for final Kaggle format submission
passID <- testData$PassengerId

# Removing variables that I won't use to model: PassengerID, Ticket, Cabin
trainData <- trainData[-c(1,9,11)]

mr_age = c(31, 823)
ms_age = c(642)
mrs_age = c(642)
trainData = prep_data(trainData, mr_age, ms_age, mrs_age)

# Fitting logistic regression model
train.glm <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
                 family = binomial, data = trainData)

train.glm.best <- glm(Survived ~ Pclass + Sex + Age + Child + Sex+Pclass + Family 
                      + Mother, family = binomial, data = trainData)

train.glm.t_rex <- glm(Survived ~ ., family = binomial, data = trainData)

train.glm.one <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Mother + Name,
                     family = binomial, data = trainData)

#train.glm.two <- glm(Survived ~ Pclass + Sex + Age + Child + Rich + Sex*Pclass + Family, family =binomial,
#                     data = trainData)


# Cleaning the testData set
testData <- testData[-c(8,10)]

mr_age = c()
ms_age = c(415)
mrs_age = c()
testData = prep_data(test_data, mr_age, ms_age, mrs_age)
testData = manualy_replace_title(testData, c(415), "Miss")

#library(klaR)

# Choosing a cutoff value based on error rate on trainData
#xx <- seq(0,1,length = 100)
#err <- rep(NA, 10)
#for (i in 1:length(xx)) {
#  err[i] <- sum((p.hats.cutoff > xx[i]) != trainData$Survived)
#}
#plot(xx, err, xlab = "Cutoff", ylab = "Error")
#identify(xx, err, xlab = "Cutoff", ylab = "Error")
#xx[54] # Ideal cutoff? (.535)

#library(party)
#library(randomForest)
#clf <- randomForest(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Family + Mother, 
#                    data = trainData, ntree=20, nodesize=5, mtry=9)

#controls = cforest_unbiased(ntree=1000, mtry=3) 
#cforest <- cforest(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Family + Mother,
#                   data = trainData[-3], controls=contols) 
#p.hats = predict(clf, testData)

p.hats <- predict.glm(train.glm.best, newdata = testData, type = "response")

#P hats to compare off of trainData
#p.hats.cutoff <- predict.glm(train.glm.best, newdata =trainData, type = "response") 

# Converting to binary response values based on a cutoff of .5
survival <- vector()
for(i in 1:length(p.hats)) {
  if(p.hats[i] > .5) {
    survival[i] <- 1
  } else {
    survival[i] <- 0
  }
}

kaggle.sub <- cbind(testData$PassengerId,survival)
colnames(kaggle.sub) <- c("PassengerId", "Survived")
write.csv(kaggle.sub, file = "kpred14.csv", row.names = FALSE)







