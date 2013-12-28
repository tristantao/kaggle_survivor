## Kaggle Exercise ##

setwd("/Users/t-rex-Box/Desktop/work/kaggle_survivor/")
source('kaggle_util.R')
#setwd("/Users/Brian_Liou/Documents/STAT151A") #Setting WD for mee

trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = F)
#original data is cached in order for inspection later
trainDataOriginal = trainData
testDataOriginal = testData
# Holding the PassengerId column for final Kaggle format submission
passID <- testData$PassengerId

#age / density
plot(trainData$Age)
plot(density(trainData$Age, na.rm = TRUE))
# Try plotting the density of other variables. Does it work? Are they helpful?
plot(density(trainData$Fare, na.rm = TRUE))

#Now, we may want to check out how the data relates to what we're trying to predict (Survived)
Sex_survival = table(trainData$Survived, trainData$Sex)
#We see that the lighter areas indidcates survival.
barplot(Sex_survival, xlab = "Gender", ylab = "Number of People",
        main = "survived and deceased between male and female")
Sex_survival[2] / (Sex_survival[1] + Sex_survival[2])
Sex_survival[4] / (Sex_survival[3] + Sex_survival[4])
#Further exploration of gender reveals the following:
#roughly 74.2% of women in our training data survived, versus only 18.9% of men.
#Since this is a training data, the numbers are not 100% accurate. 
#Nevertheless they are often indicative of general trends. #TODO add disclaimers 

#Survival rate by cabin classes
Pclass_survival = table(trainData$Survived, trainData$Pclass)
#barplot(prop.table(Pclass_survival))
barplot(Pclass_survival, xlab = "Cabin Class", ylab = "Number of People",
        main = "survived and deceased between male and female")
Pclass_survival[2] / (Pclass_survival[1] + Pclass_survival[2]) #Survival rate of 1st class cabin
Pclass_survival[4] / (Pclass_survival[3] + Pclass_survival[4]) #Survival rate of 2nd class cabin
Pclass_survival[6] / (Pclass_survival[5] + Pclass_survival[6]) #Survival rate of 3rdt class cabin
#Further exploration of gender reveals the following:
#The survival rate of 1st class, 2nd class, and 3rd class are: 63.0%, 47.3%, 24.2% respectively


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



