#Given a dataset, creates a boolean variable of "is_" for each list_to_replace
add_title_vars = function (targetData, list_to_replace) {
  for (title in list_to_replace) {
    new_col = 0
    for (i in 1:nrow(targetData)) { 
      if (targetData$Name[i] == title) {
        new_col[i] = 1
      } else {
        new_col[i] = 0
      }
    }
    targetData[paste("Is", title, sep="_")] <- new_col
  }
  return (targetData)
}

manualy_replace_title  = function(data, indices, new_title) {
  for (index in 1:(length(indices))) {
    data$Name[indices[index]] = new_title
  }
  return (data)
}

prep_data = function(targetData, mr_age, ms_age, mrs_age) {
  "This function will clean and prep data for targetData "
  "mr_age, ms_age, mrs_age are "
  # Finding the rows which have certain surnames
  master_vector <- grep("Master\\.",targetData$Name)
  miss_vector <- grep("Miss\\.", targetData$Name)
  
  # Replacing those rows with the shortened tag "Master" | "Miss" | ....
  for(i in master_vector) {
    targetData$Name[i] <- "Master"
  }
  
  for(i in miss_vector) {
    targetData$Name[i] <- "Miss"
  }
  
  # User defined function for replacing surnames for TRAIN 
  namefunction <- function(name, replacement, dataset, targetData) {
    vector <- grep(name, dataset)
    for (i in vector) {
      targetData$Name[i] <- replacement
    }
    return(targetData)
  }
  
  # Replacing surnames for major surnames
  targetData <- namefunction("Master\\.", "Master",targetData$Name, targetData)
  targetData <- namefunction("Miss\\.", "Miss",targetData$Name, targetData)
  targetData <- namefunction("Mrs\\.", "Mrs",targetData$Name, targetData)
  targetData <- namefunction("Mr\\.", "Mr",targetData$Name, targetData)
  targetData <- namefunction("Dr\\.", "Dr",targetData$Name, targetData)
  targetData <- namefunction("Rev.", "Mr",targetData$Name, targetData)
  
  #Also replace those not properly caught #Do we even need the ones above wiht periods?
  targetData = namefunction("Mr", "Mr",targetData$Name, targetData)
  targetData = namefunction("Miss", "Miss",targetData$Name, targetData)
  targetData = namefunction("Mrs", "Mrs",targetData$Name, targetData)
  targetData = namefunction("Col", "Mr",targetData$Name, targetData)
  targetData = namefunction("Major.", "Mr",targetData$Name, targetData)
  targetData = namefunction("Capt", "Mr",targetData$Name, targetData)
  targetData = namefunction("Mme", "Mrs",targetData$Name, targetData)
  targetData = namefunction("Countess", "Mrs",targetData$Name, targetData)
  targetData <- namefunction("Ms\\.", "Miss", targetData$Name, targetData) # One random obs that had "Ms." surname causing code to break
  
  #manually update the ages:
  
  targetData = manualy_replace_title(targetData, mr_age, "Mr")
  targetData = manualy_replace_title(targetData, ms_age, "Miss")
  targetData = manualy_replace_title(targetData, mrs_age, "Mrs")
  
  # Calculating average age per surname
  master_age <- round(mean(targetData$Age[targetData$Name == "Master"], na.rm = TRUE), digits = 2)
  miss_age <- round(mean(targetData$Age[targetData$Name == "Miss"], na.rm = TRUE), digits =2)
  mrs_age <- round(mean(targetData$Age[targetData$Name == "Mrs"], na.rm = TRUE), digits = 2)
  mr_age <- round(mean(targetData$Age[targetData$Name == "Mr"], na.rm = TRUE), digits = 2)
  dr_age <- round(mean(targetData$Age[targetData$Name == "Dr"], na.rm = TRUE), digits = 2)
  
  
  # Adding age values for missing values
  for (i in 1:nrow(targetData)) {
    if (is.na(targetData[i,5])) {
      if (targetData$Name[i] == "Master") {
        targetData$Age[i] <- master_age
      } else if (targetData$Name[i] == "Miss") {
        targetData$Age[i] <- miss_age
      } else if (targetData$Name[i] == "Mrs") {
        targetData$Age[i] <- mrs_age
      } else if (targetData$Name[i] == "Mr") {
        targetData$Age[i] <- mr_age
      } else if (targetData$Name[i] == "Dr") {
        targetData$Age[i] <- dr_age
      } else {
        print("Uncaught Surname")
      }
    }
  }
  
  
  #Test if there are any more NAs in Age column
  if (sum(is.na(targetData$Age)) > 0) {
    print("NAs exist")
  }
  
  
  # Converting categorical variable Sex to integers
  targetData$Sex <- gsub("female", 1, targetData$Sex)
  targetData$Sex <- gsub("^male", 0, targetData$Sex)
  

  
  # Converting categorical variable Embarked to integers
  targetData$Embarked <- gsub("C", as.integer(1), targetData$Embarked)
  targetData$Embarked <- gsub("Q", as.integer(2), targetData$Embarked)
  targetData$Embarked <- gsub("S", as.integer(3), targetData$Embarked)
  
  
  # Adding Embarked locations to missing values FOR trainData COMMENT OUT for testData
  #targetData[which(targetData$Embarked == ""), ]
  #targetData[771, 9] <- as.integer(3)
  #targetData[852, 9] <- as.integer(3)
  
  # Adding Fare value for OBS 153 in testData COMMENT OUT for trainData
  targetData[153, 8] <- 50
  
  
  # Creating a child variable
  targetData["Child"] <- NA
  for (i in 1:nrow(targetData)) {
    if (targetData$Age[i] <= 12) {
      targetData$Child[i] <- 1
    } else {
      targetData$Child[i] <- 2
    }
  }
  
  # Percentage of people with ticket prices over $100 that survived
  rich_people <- sum(targetData$Survived[which(targetData$Fare > 100)]) / length(targetData$Survived[which(targetData$Fare > 100)])
  
  # Percentage of Men > 25 and Pclass = 3
  #poor_men <- sum(targetData[which(targetData$Age > 25 & targetData$Sex == 0 & targetData$Pclass == 3), ]) / 214
  
  # Adding an explanatory variable for lower class men
  targetData["Lowmen"] <- NA
  
  for (i in 1:nrow(targetData)) {
    if (targetData$Age[i] > 25 & targetData$Sex[i] == 0 & targetData$Pclass[i] == 3) {
      targetData$Lowmen[i] <- 1
    } else {
      targetData$Lowmen[i] <- 2
    }
  }
  
  # Adding rich people variable
  targetData["Rich"] <- NA
  
  for(i in 1:nrow(targetData)) {
    if (targetData$Fare[i] > 100) {
      targetData$Rich[i] <- 1
    } else {
      targetData$Rich[i] <- 2
    }
  }
  
  # Adding Family variable
  targetData["Family"] <- NA
  
  for(i in 1:nrow(targetData)) {
    x <- targetData$SibSp[i]
    y <- targetData$Parch[i]
    targetData$Family[i] <- x + y + 1
  }
  
  # Adding a mother variable (surname = Mrs AND Parch > 0)
  targetData["Mother"] <- NA
  for(i in 1:nrow(targetData)) {
    if(targetData$Name[i] == "Mrs" & targetData$Parch[i] > 0) {
      targetData$Mother[i] <- 1
    } else {
      targetData$Mother[i] <- 2
    }
  }
  
  targetData = add_title_vars (targetData, c("Mrs", "Mr", "Master", "Miss", "Dr"))
  return (targetData)
}

#mr_age = c(31, 823)
#ms_age = c(642)
#mrs_age = c(642)
#trainData = prep_data(trainData, mr_age, ms_age, mrs_age)
