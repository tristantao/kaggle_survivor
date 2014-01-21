setwd("/Users/t-rex-Box/Desktop/work/kaggle_survivor/")

trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = FALSE)

head(trainData)
plot(density(trainData$Age, na.rm = TRUE))
plot(density(trainData$Fare, na.rm = TRUE))

counts <- table(trainData$Survived, trainData$Sex)
barplot(counts, xlab = "Gender", ylab = "Number of People", main = "survived and deceased between male and female")
counts[2] / (counts[1] + counts[2])
counts[4] / (counts[3] + counts[4])

Pclass_survival <- table(trainData$Survived, trainData$Pclass)
barplot(Pclass_survival, xlab = "Cabin Class", ylab = "Number of People",
        main = "survived and deceased between male and female")
Pclass_survival[2] / (Pclass_survival[1] + Pclass_survival[2]) 
Pclass_survival[4] / (Pclass_survival[3] + Pclass_survival[4]) 
Pclass_survival[6] / (Pclass_survival[5] + Pclass_survival[6])

trainData <- trainData[-c(1,9:12)]

trainData$Sex <- gsub("female", 1, trainData$Sex)
trainData$Sex <- gsub("^male", 0, trainData$Sex)

master_vector <- grep("Master\\.",trainData$Name)
miss_vector <- grep("Miss\\.", trainData$Name)
mrs_vector <- grep("Mrs\\.", trainData$Name)
mr_vector <- grep("Mr\\.", trainData$Name)
dr_vector <- grep("Dr\\.", trainData$Name)


for(i in master_vector) {
  trainData$Name[i] <- "Master"
}
for(i in miss_vector) {
  trainData$Name[i] <- "Miss"
}
for(i in mrs_vector) {
  trainData$Name[i] <- "Mrs"
}
for(i in mr_vector) {
  trainData$Name[i] <- "Mr"
}
for(i in dr_vector) {
  trainData$Name[i] <- "Dr"
}

master_age <- round(mean(trainData$Age[trainData$Name == "Master"], na.rm = TRUE), digits = 2)
miss_age <- round(mean(trainData$Age[trainData$Name == "Miss"], na.rm = TRUE), digits =2)
mrs_age <- round(mean(trainData$Age[trainData$Name == "Mrs"], na.rm = TRUE), digits = 2)
mr_age <- round(mean(trainData$Age[trainData$Name == "Mr"], na.rm = TRUE), digits = 2)
dr_age <- round(mean(trainData$Age[trainData$Name == "Dr"], na.rm = TRUE), digits = 2)

# Adding age values for missing values
for (i in 1:nrow(trainData)) {
  if (is.na(trainData[i,5])) {
    if (trainData$Name[i] == "Master") {
      trainData$Age[i] <- master_age
    } else if (trainData$Name[i] == "Miss") {
      trainData$Age[i] <- miss_age
    } else if (trainData$Name[i] == "Mrs") {
      trainData$Age[i] <- mrs_age
    } else if (trainData$Name[i] == "Mr") {
      trainData$Age[i] <- mr_age
    } else if (trainData$Name[i] == "Dr") {
      trainData$Age[i] <- dr_age
    } else {
      print("Uncaught Surname")
    }
  }
}

trainData["Child"] <- NA

for (i in 1:nrow(trainData)) {
  if (trainData$Age[i] <= 12) {
    trainData$Child[i] <- 1
  } else {
    trainData$Child[i] <- 2
  }
}

trainData["Family"] <- NA

for(i in 1:nrow(trainData)) {
  x <- trainData$SibSp[i]
  y <- trainData$Parch[i]
  trainData$Family[i] <- x + y + 1
}

trainData["Mother"] <- NA

for(i in 1:nrow(trainData)) {
  if(trainData$Name[i] == "Mrs" & trainData$Parch[i] > 0) {
    trainData$Mother[i] <- 1
  } else {
    trainData$Mother[i] <- 2
  }
}

train.glm <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Family + Mother,
                 family = binomial, data = trainData)

summary(train.glm)


PassengerId = testData[1]
testData <- testData[-c(1, 8:11)]

testData$Sex <- gsub("female", 1, testData$Sex)
testData$Sex <- gsub("^male", 0, testData$Sex)

test_master_vector <- grep("Master\\.",testData$Name)
test_miss_vector <- grep("Miss\\.", testData$Name)
test_mrs_vector <- grep("Mrs\\.", testData$Name)
test_mr_vector <- grep("Mr\\.", testData$Name)
test_dr_vector <- grep("Dr\\.", testData$Name)

for(i in test_master_vector) {
  testData[i, 2] <- "Master"
}
for(i in test_miss_vector) {
  testData[i, 2] <- "Miss"
}
for(i in test_mrs_vector) {
  testData[i, 2] <- "Mrs"
}
for(i in test_mr_vector) {
  testData[i, 2] <- "Mr"
}
for(i in test_dr_vector) {
  testData[i, 2] <- "Dr"
}

test_master_age <- round(mean(testData$Age[testData$Name == "Master"], na.rm = TRUE), digits = 2)
test_miss_age <- round(mean(testData$Age[testData$Name == "Miss"], na.rm = TRUE), digits =2)
test_mrs_age <- round(mean(testData$Age[testData$Name == "Mrs"], na.rm = TRUE), digits = 2)
test_mr_age <- round(mean(testData$Age[testData$Name == "Mr"], na.rm = TRUE), digits = 2)
test_dr_age <- round(mean(testData$Age[testData$Name == "Dr"], na.rm = TRUE), digits = 2)

for (i in 1:nrow(testData)) {
  if (is.na(testData[i,4])) {
    if (testData[i, 2] == "Master") {
      testData[i, 4] <- test_master_age
    } else if (testData[i, 2] == "Miss") {
      testData[i, 4] <- test_miss_age
    } else if (testData[i, 2] == "Mrs") {
      testData[i, 4] <- test_mrs_age
    } else if (testData[i, 2] == "Mr") {
      testData[i, 4] <- test_mr_age
    } else if (testData[i, 2] == "Dr") {
      testData[i, 4] <- test_dr_age
    } else {
      print("Uncaught Surname")
    }
  }
}

testData[89, 4] <- test_miss_age

testData["Child"] <- NA

for (i in 1:nrow(testData)) {
  if (testData[i, 4] <= 12) {
    testData[i, 7] <- 1
  } else {
    testData[i, 7] <- 2
  }
}

testData["Family"] <- NA

for(i in 1:nrow(testData)) {
  testData[i, 8] <- testData[i, 5] + testData[i, 6] + 1
}

testData["Mother"] <- NA

for(i in 1:nrow(testData)) {
  if(testData[i, 2] == "Mrs" & testData[i, 6] > 0) {
    testData[i, 9] <- 1
  } else {
    testData[i, 9] <- 2
  }
}

p.hats <- predict.glm(train.glm, newdata = testData, type = "response")

# Converting to binary response values based on a cutoff of .5
survival <- vector()
for(i in 1:length(p.hats)) {
  if(p.hats[i] > .5) {
    survival[i] <- 1
  } else {
    survival[i] <- 0
  }
}

kaggle.sub <- cbind(PassengerId,survival)
colnames(kaggle.sub) <- c("PassengerId", "Survived")
write.csv(kaggle.sub, file = "kpred14_test.csv")