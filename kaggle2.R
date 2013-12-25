## Kaggle Exercise ##

setwd("/Users/t-rex-Box/Desktop/work/kaggle_survivor/")

trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = F)

# Holding the PassengerId column for final Kaggle format submission
passID <- testData$PassengerId

# Removing variables that I won't use to model: PassengerID, Ticket, Cabin
trainData <- trainData[-c(1,9,11)]

# Finding the rows which have certain surnames
master_vector <- grep("Master\\.",trainData$Name)
miss_vector <- grep("Miss\\.", trainData$Name)

# Replacing those rows with the shortened tag "Master" | "Miss" | ....
for(i in master_vector) {
  trainData$Name[i] <- "Master"
}

for(i in miss_vector) {
  trainData$Name[i] <- "Miss"
}

# User defined function for replacing surnames for TRAIN 
trainnamefunction <- function(name, replacement, dataset) {
  vector <- grep(name, dataset)
  for (i in vector) {
    trainData$Name[i] <- replacement
  }
  return(trainData)
}

# Replacing surnames for major surnames
trainData <- trainnamefunction("Master\\.", "Master",trainData$Name)
trainData <- trainnamefunction("Miss\\.", "Miss",trainData$Name)
trainData <- trainnamefunction("Mrs\\.", "Mrs",trainData$Name)
trainData <- trainnamefunction("Mr\\.", "Mr",trainData$Name)
trainData <- trainnamefunction("Dr\\.", "Dr",trainData$Name)

# Calculating average age per surname
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
    } else if (trainData[i, 3] == "Miss") {
      trainData$Age[i] <- miss_age
    } else if (trainData[i, 3] == "Mrs") {
      trainData$Age[i] <- mrs_age
    } else if (trainData[i, 3] == "Mr") {
      trainData$Age[i] <- mr_age
    } else if (trainData[i, 3] == "Dr") {
      trainData$Age[i] <- dr_age
    } else {
      print("Uncaught Surname")
    }
  }
}

# Converting categorical variable Sex to integers
trainData$Sex <- gsub("female", 1, trainData$Sex)
trainData$Sex <- gsub("^male", 0, trainData$Sex)

# Converting categorical variable Embarked to integers
trainData$Embarked <- gsub("C", as.integer(1), trainData$Embarked)
trainData$Embarked <- gsub("Q", as.integer(2), trainData$Embarked)
trainData$Embarked <- gsub("S", as.integer(3), trainData$Embarked)


# Adding Embarked locations to missing values
trainData[which(trainData$Embarked == ""), ]
trainData[771, 9] <- as.integer(3)
trainData[852, 9] <- as.integer(3)

# Creating a child variable
trainData["Child"] <- NA

for (i in 1:nrow(trainData)) {
  if (trainData$Age[i] <= 12) {
    trainData$Child[i] <- 1
  } else {
    trainData$Child[i] <- 2
  }
}

# Percentage of people with ticket prices over $100 that survived
rich_people <- sum(trainData$Survived[which(trainData$Fare > 100)]) / length(trainData$Survived[which(trainData$Fare > 100)])

# Percentage of Men > 25 and Pclass = 3
#poor_men <- sum(trainData[which(trainData$Age > 25 & trainData$Sex == 0 & trainData$Pclass == 3), ]) / 214

# Adding an explanatory variable for lower class men
trainData["Lowmen"] <- NA

for (i in 1:nrow(trainData)) {
  if (trainData$Age[i] > 25 & trainData$Sex[i] == 0 & trainData$Pclass[i] == 3) {
    trainData$Lowmen[i] <- 1
  } else {
    trainData$Lowmen[i] <- 2
  }
}

# Adding rich people variable
trainData["Rich"] <- NA

for(i in 1:nrow(trainData)) {
  if (trainData$Fare[i] > 100) {
    trainData$Rich[i] <- 1
  } else {
    trainData$Rich[i] <- 2
  }
}

# Adding Family variable
trainData["Family"] <- NA

for(i in 1:nrow(trainData)) {
  x <- trainData$SibSp[i]
  y <- trainData$Parch[i]
  trainData$Family[i] <- x + y + 1
}

# Adding a mother variable (surname = Mrs AND Parch > 0)
trainData["Mother"] <- NA
for(i in 1:nrow(trainData)) {
  if(trainData$Name[i] == "Mrs" & trainData$Parch[i] > 0) {
    trainData$Mother[i] <- 1
  } else {
    trainData$Mother[i] <- 2
  }
}
    

# Fitting logistic regression model
train.glm <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
                 family = binomial, data = trainData)

train.glm.best <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Family + Mother,
                     family = binomial, data = trainData)

train.glm.one <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Mother,
                     family = binomial, data = trainData)

#train.glm.two <- glm(Survived ~ Pclass + Sex + Age + Child + Rich + Sex*Pclass + Family, family =binomial,
#                     data = trainData)


# Cleaning the testData set

testData <- testData[-c(8,10)]

# User defined function for replacing surnames for TEST
#@TODO WE NEED TO NOTE THAT THIS DEPENDS ON ABOVE ALL WORKING
testnamefunction <- function(name, replacement, dataset) {
  vector <- grep(name, dataset)
  for (i in vector) {
    testData[i, 3] <- replacement
  }
  return(testData)
}

testData <- testnamefunction("Master\\.", "Master",testData$Name)
testData <- testnamefunction("Miss\\.", "Miss",testData$Name)
testData <- testnamefunction("Mrs\\.", "Mrs",testData$Name)
testData <- testnamefunction("Mr\\.", "Mr",testData$Name)
testData <- testnamefunction("Dr\\.", "Dr",testData$Name)

# Cacluating the age for each surname in the testdata set
t_master_age <- round(mean(testData$Age[testData$Name == "Master"], na.rm = TRUE), digits = 2)
t_miss_age <- round(mean(testData$Age[testData$Name == "Miss"], na.rm = TRUE), digits =2)
t_mrs_age <- round(mean(testData$Age[testData$Name == "Mrs"], na.rm = TRUE), digits = 2)
t_mr_age <- round(mean(testData$Age[testData$Name == "Mr"], na.rm = TRUE), digits = 2)
t_dr_age <- round(mean(testData$Age[testData$Name == "Dr"], na.rm = TRUE), digits = 2)


# Adding age values for missing values
for (i in 1:nrow(testData)) {
  if (is.na(testData[i,5])) {
    if (testData$Name[i] == "Master") {
      testData$Age[i] <- t_master_age
    } else if (testData$Name[i] == "Miss") {
      testData$Age[i] <- t_miss_age
    } else if (testData$Name[i] == "Mrs") {
      testData$Age[i] <- t_mrs_age
    } else if (testData$Name[i] == "Mr") {
      testData$Age[i] <- t_mr_age
    } else if (testData$Name[i] == "Dr") {
      testData$Age[i] <- t_dr_age
    } else {
      print("Uncaught Surname")
    }
  }
}
# Manually inputting one age variable for Ms.
testData$Age[89] <- t_miss_age

# Adding Fare values to missing values
val <- mean(testData$Fare[testData$Pclass == 3], na.rm =T) #12.45
testData[153, 6]
testData$Fare[153] <- val

# Converting categorical variable Sex to integers
testData$Sex <- gsub("female", 1, testData$Sex)
testData$Sex <- gsub("^male", 0, testData$Sex)

# Converting categorical variable Embarked to integers
testData$Embarked <- gsub("C", as.integer(1), testData$Embarked)
testData$Embarked <- gsub("Q", as.integer(2), testData$Embarked)
testData$Embarked <- gsub("S", as.integer(3), testData$Embarked)

# Creating a child variable
testData["Child"] <- NA

for (i in 1:nrow(testData)) {
  if (testData$Age[i] < 15) {
    testData$Child[i] <- 1
  } else {
    testData$Child[i] <- 2
  }
}


# Adding variable for ticket fare > 100
testData["Rich"] <- NA

for(i in 1:nrow(testData)) {
  if (testData$Fare[i] > 100) {
    testData$Rich[i] <- 1
  } else {
    testData$Rich[i] <- 2
  }
}

# Adding an explanatory variable for lower class men
testData["Lowmen"] <- NA

for (i in 1:nrow(testData)) {
  if (testData$Age[i] > 25 & testData$Sex[i] == 0 & testData$Pclass[i] == 3) {
    testData$Lowmen[i] <- 1
  } else {
    testData$Lowmen[i] <- 2
  }
}

# Adding Family variable
testData["Family"] <- NA

for(i in 1:nrow(testData)) {
  testData$Family[i] <- testData$SibSp[i] + testData$Parch[i] + 1
}

# Adding a mother variable
testData["Mother"] <- NA
for(i in 1:nrow(testData)) {
  if(testData$Name[i] == "Mrs" & testData$Parch[i] > 0) {
    testData$Mother[i] <- 1
  } else {
    testData$Mother[i] <- 2
  }
}


p.hats <- predict.glm(train.glm.best, newdata = testData, type = "response")

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
write.csv(kaggle.sub, file = "kpred13.csv")







