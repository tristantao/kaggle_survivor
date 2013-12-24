This is the writeup.


## Kaggle Exercise ##

First we must indicate to R where our current working directory is. We achieve that by calling setcwd (roughly stands for set current working directory).
```R
setwd("/Path/to/training/test/data/")
e.g.
setwd("/Users/t-rex-Box/Desktop/work/kaggle_survivor")
```

Now that we've indicate to R where we are working, we can begin reading in the code; we utilize the _read.csv()_ function to do that. Previewing the data with your text editor (word/excel is ok!), we notice hearders, so we flag header as _True_.

We also indicate that stringAsFactors as false. We'll cover factors later, but for now, we flag that as _False_ as well
```R
trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = F)
```

At this moment, we also want to grab on passengerID column, because we'll need it for the submission phase.
```R
passID <- testData$PassengerId
```

####@TODO explain why we don't use these variables.

At this point, we remove the variables that are not used in the model: PassengerID, Ticket, Cabin. We are using the negative sign, combined with c() to indicate a list of indices to remove.
```R
trainData <- trainData[-c(1,9,11)]
```

At this point, we've accomplished the following:
- [x] load the data we intend to work with.
- [x] did some prelimery exploration in the data.
- [] begin formulating a plan on how to tackle the problem.

####Elaborate on "why" we want to do the following. Maybe quickly run a non-optimized model and suggest that we're going to start improving?

Our first improvement is in regards to the age variable. Upon examining our dataset, we see that many entries for "age" are missing. Because age entries could be an important variable (we'll learn how to verify this), we try inferencing them  based on relationship between title and age; we're essentially banking on the fact that Mrs.X will older than Ms.X.

So first, we put the index of people with the specified surname into a list for further processing. 
Then we rename those rows with the shortened tag "Master" | "Miss" | ....
```R
master_vector <- grep("Master\\.",trainData$Name)
miss_vector <- grep("Miss\\.", trainData$Name)

for(i in master_vector) {
  trainData[i, 3] <- "Master"
}

for(i in miss_vector) {
  trainData[i, 3] <- "Miss"
}
```

Now, in order to make the process above more repeatable on the TRAIN data, we create a function:
```R
trainnamefunction <- function(name, replacement, dataset) {
  vector <- grep(name, dataset)
  for (i in vector) {
    trainData[i, 3] <- replacement
  }
  return(trainData)
}
```

We then apply the function defined above on the trainData. We are renaming the titles of the titanic passengers.
```R
trainData <- trainnamefunction("Master\\.", "Master",trainData$Name)
trainData <- trainnamefunction("Miss\\.", "Miss",trainData$Name)
trainData <- trainnamefunction("Mrs\\.", "Mrs",trainData$Name)
trainData <- trainnamefunction("Mr\\.", "Mr",trainData$Name)
trainData <- trainnamefunction("Dr\\.", "Dr",trainData$Name)
````
Now that we have a series of standardized titles, we begin analysis on the average age of each title.
We replace the missing ages with their respective title-group average. This means that if we have a missing age entry for a man named Mr.Bond, we substitute his age for the *average* age for all passenger with the title Mr. Similarly for *master*, *miss*, *mrs*, and *dr*.

```R
#We save the averages into variables (space holders) for later use.
master_age <- round(mean(trainData$Age[trainData$Name == "Master"], na.rm = TRUE), digits = 2)
miss_age <- round(mean(trainData$Age[trainData$Name == "Miss"], na.rm = TRUE), digits =2)
mrs_age <- round(mean(trainData$Age[trainData$Name == "Mrs"], na.rm = TRUE), digits = 2)
mr_age <- round(mean(trainData$Age[trainData$Name == "Mr"], na.rm = TRUE), digits = 2)
dr_age <- round(mean(trainData$Age[trainData$Name == "Dr"], na.rm = TRUE), digits = 2)


# We go through the ENTIRE training dataset and replace the missing age entry with the values we acquired above.
for (i in 1:nrow(trainData)) {
  if (is.na(trainData[i,5])) {
    if (trainData[i, 3] == "Master") {
      trainData[i, 5] <- master_age
    } else if (trainData[i, 3] == "Miss") {
      trainData[i, 5] <- miss_age
    } else if (trainData[i, 3] == "Mrs") {
      trainData[i, 5] <- mrs_age
    } else if (trainData[i, 3] == "Mr") {
      trainData[i, 5] <- mr_age
    } else if (trainData[i, 3] == "Dr") {
      trainData[i, 5] <- dr_age
    } else {
      print("Uncaught Surname")
    }
  }
}

```
WE are now finished with age 

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
  if (trainData[i, 5] <= 12) {
    trainData[i, 10] <- 1
  } else {
    trainData[i, 10] <- 2
  }
}

# Percentage of people with ticket prices over $100 that survived
rich_people <- sum(trainData$Survived[which(trainData$Fare > 100)]) / length(trainData$Survived[which(trainData$Fare > 100)])

# Percentage of Men > 25 and Pclass = 3
poor_men <- sum(trainData[which(trainData$Age > 25 & trainData$Sex == 0 & trainData$Pclass == 3), ]) / 214

# Adding an explanatory variable for lower class men
trainData["Lowmen"] <- NA

for (i in 1:nrow(trainData)) {
  if (trainData[i, 5] > 25 & trainData[i, 4] == 0 & trainData[i, 2] == 3) {
    trainData[i, 11] <- 1
  } else {
    trainData[i, 11] <- 2
  }
}

# Adding rich people variable
trainData["Rich"] <- NA

for(i in 1:nrow(trainData)) {
  if (trainData[i, 8] > 100) {
    trainData[i, 11] <- 1
  } else {
    trainData[i, 11] <- 2
  }
}

# Adding Family variable
trainData["Family"] <- NA

for(i in 1:nrow(trainData)) {
  trainData[i, 12] <- trainData[i, 6] + trainData[i, 7] + 1
}


# Fitting logistic regression model
train.glm <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
                 family = binomial, data = trainData)

train.glm.best <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Family,
                     family = binomial, data = trainData)

train.glm.one <- glm(Survived ~ Pclass + Sex + Age + Child + Lowmen + Sex*Pclass, family =binomial,
                     data = trainData)

train.glm.two <- glm(Survived ~ Pclass + Sex + Age + Child + Rich + Sex*Pclass, family =binomial,
                     data = trainData)



# Cleaning the testData set

testData <- testData[-c(8,10)]

# User defined function for replacing surnames for TEST
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
    if (testData[i, 3] == "Master") {
      testData[i, 5] <- t_master_age
    } else if (testData[i, 3] == "Miss") {
      testData[i, 5] <- t_miss_age
    } else if (testData[i, 3] == "Mrs") {
      testData[i, 5] <- t_mrs_age
    } else if (testData[i, 3] == "Mr") {
      testData[i, 5] <- t_mr_age
    } else if (testData[i, 3] == "Dr") {
      testData[i, 5] <- t_dr_age
    } else {
      print("Uncaught Surname")
    }
  }
}
# Manually inputting one age variable for Ms.
testData[89, 5] <- t_miss_age

# Adding Fare values to missing values
val <- mean(testData$Fare[testData$Pclass == 3], na.rm =T) #12.45
testData[153, 6]
testData[153, 8] <- val

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
  if (testData[i, 5] < 15) {
    testData[i, 10] <- 1
  } else {
    testData[i, 10] <- 2
  }
}

# Adding variable for ticket fare > 100
testData["Rich"] <- NA

for(i in 1:nrow(testData)) {
  if (testData[i, 8] > 100) {
    testData[i, 11] <- 1
  } else {
    testData[i, 11] <- 2
  }
}

# Adding an explanatory variable for lower class men
testData["Lowmen"] <- NA

for (i in 1:nrow(testData)) {
  if (testData[i, 5] > 25 & testData[i, 4] == 0 & testData[i, 2] == 3) {
    testData[i, 11] <- 1
  } else {
    testData[i, 11] <- 2
  }
}

# Adding Family variable
testData["Family"] <- NA

for(i in 1:nrow(testData)) {
  testData[i, 12] <- testData[i, 6] + testData[i, 7] + 1
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
write.csv(kaggle.sub, file = "kpred10.csv")





