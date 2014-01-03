##Data Analytics for Beginners: A Walkthrough Example

Have you ever had data and wanted to derive meaningful insights from it? Have you wanted to answer a question from raw data or discover a new trend? In todays day and age, data analytics has become a business problem. Decisions are now based upon metrics instead of intuition. Whether you are A/B testing, segmenting customers, or predicting stock prices you are using analytics to do so. We believe that following the agricultural and industrial revolutions is the information revolution, and unique from the plow or the assembly line, the key to this revolution is the knowledge of how to analyze data. 

Marketers A/B test, consultants segment customers, financiers predict stock price, engineers. The ability to answer a question from raw data or discover a new trend will never go out of demand and is only increasing in demand as data becomes more easily stored, access, and shared.

This post is meant for **ANYONE** interested in learning more about data analytics and is made so that you can still follow along even with no prior experience in **R**. Some background in Statistics would be helpful (making the fancy words seem less fancy) but neither is it necessary. The purpose of this post is to simply give you a taste of what data analytics is really like, by walking you through step by step in an example. The "data project" you will complete is given from Kaggle, a data science competition website, and if you follow carefully you can also place yourself at the top 15% of all competitors


### Internal Comments on BlogPost

THOUGHTS:

2. We should just give them a cleaned version of the testData so they don't have to see all that code again.
  * Will this confuse them? What if they want to add variables? maybe this is where the automated function comes in? I dont think we can blindly give people the cleaned data, because they won't understand that same proces applied to train and test. 
3. We should remove explanatory variables that we don't use.
  * Again, what if they want to look at it / try using it? Or, it's possible (likely) that no one will, so we can remove safeyl..
4. Need to teach them how to run code thats written in the script (typing ctrl + enter)
  * discuss*
5. Need to indicate that # means comments and aren't run, need to explain what comments are
  * Good call
6. In general to avoid confusion we should just have code snippets be things the reader should put into R. Anything else should be text
  * That's how it is for the most part. Are you referring to the comments?
7. Add a glossary?
  * discuss (from lean startup pov)
8. Lets put those barplots in the exploratory analysis in, pictures are good I think
  * like, include the completed plots? Already plotted i.e?
9. Lets get rid of the user defined function and just brute force everything, repetition will make it easier to understand
  * agreed, so this appliest to every single place where they use any function, right?

Concept needed to cover:

1. data structure, c(), i.e. lists. subsetting indices
2. explain the concept of a function
3. Way to examine data. (head, tail, or editor etc)
4. idea of variables (holding block)
6. grep
7. idea behind linear regression
8. misc function (round, mean, table, gsub, cbind, nrow etc)

Already covered:

1. Directory related stuff
2. comment in code
3. if-else statements
4. for loops
5. Density

Video breaks:<br />
http://www.youtube.com/watch?v=FzRH3iTQPrk#t=13<br />
http://www.youtube.com/watch?v=Fc1P-AEaEp8#t=5<br />

TARGET READER: A young professional with no prior experience in R and maybe an elementary understanding of statistics.

This post can be our MVP: Its a data project which we walk them through, we add sections for conceptual understanding, and we send them to post their results on Kaggle to replicate the competition and comparison. Critical missing features: **interactivity** **video lectures** on conceptual understanding, **competition/comparison network**, **applicability** to industry (titanic dataset is random), this tutorial focuses on predictive analytics so we are missing other teaching concepts, no gamification, we aren't charging them (maybe we can offer additional personal tutoring/hr to test WTP?). What can this confirm? Demand and specifically what types of people our customers are, we can test this on our friends easily and gain experience in teaching statistics to people,

Make this walkthrough fun, put in parts like "**Take a break!** Watch this video: (link to some funny harlem shake)"
Instruct them to type the code as they read along (anyway to make it so they can split screen btw blog post and Rstudio easily?)
Put some kind of legitimacy backing? Like this post is sponsored by Wayne Lee a PhD in Statistics at UC Berkeley (probably shouldn't because we don't expect to put that kind of stuff in the initial product)
Create a joke certification at the end to be funny? ("You can write this on your resume: ...")
Google adwords people who search for the Predictive Analytics World Conference
Find out if the readers are: (Engineer, Business, Medicine, Research, Student)
In the tutorial teach them to a score of **.70** and then offer tips and advice to improve score to **.77**


We believe R or some software like it will be the baseline skill business professionals require like Microsoft Excel is today.


### Concepts to Cover:

##### Instructions for following along
We recommend **directly typing** all code snippets that we have included<br />
Additional materials which provide a more conceptual understanding of the programming or statistics are marked with:<br />
Feel free to ask questions on our Kaggle Forum post and we will respond as soon as possible!

To work on the project we recommend splitting your screen space between RStudio and our walkthrough:
Inline-style: 
![alt text](https://github.com/tristantao/kaggle_survivor/blob/master/WorkStation.png "Split Screen View")

![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png)

####Table of Content:

1. [Preparing R/Rstudio](#r preparation)
2. [Data Exploration](#data exploration)
3. [Data Curation](#data curation)
4. [Training a Model](#train model)
5. [Fitting a Model](#predict model)

Before beginning you will need to install R and RStudio. It is a useful and free application for data analytics that is widely used by statisticians and data miners. You also need to become a Kaggle Competitor for access to the datasets and entry into the competition, don't worry its free! Sign up for <a href = "http://www.kaggle.com/account/register">Kaggle</a>. If you already have these, skip to [Data Exploration](#data exploration)

<a name="r preparation"></a>
####Preparing R
#####Macs

Download and install from [Mac_R_Download] (http://cran.r-project.org/bin/macosx/)

#####Windows
Download and install from [Windows_R_Download] (http://cran.r-project.org/bin/windows/base/)

#####Linux
Download and install from [Linux_R_Download] (http://cran.r-project.org/bin/linux/ubuntu/README)

##### Now install Rstudio 
Choose the appropriate package from [RStudio_Download] (http://www.rstudio.com/ide/download/desktop)
@TODO Also install ggplot2

### Kaggle Competition: Titanic - Machine Learning From Disaster

The Kaggle competition asks you to predict whether a passenger survived the Titanic crash. You are given two datasets (Train & Test) each of which include predictor variables such as Age, Passenger Class, Sex, etc. With these two data sets we will do the following:

1. Create a model which will predict whether a passenger survived using only the Train data set
2. Predict whether the passengers survived in the Test data set based on the model we created

Read the full description of the project <a href = "http://www.kaggle.com/c/titanic-gettingStarted">here</a>. The project result will be an excel spreadsheet with predictions for which passengers in the Test data set survived. The spreadsheet will have a column for the Passenger ID and another column which indicates whether they survived (0 for death, 1 for survival).

The first step is to download the datasets <a href = "https://www.kaggle.com/c/titanic-gettingStarted/data">here</a>. Remember which folder you saved it in!

In RStudio, we must first create a file for us to write in. Go to File ==> New ==> Rscript. Now in that file we must tell R where our current working directory is. We do this by using the ```setwd()``` function (roughly stands for set current working directory). Your working directory indicates to R which folder to look for the data you want to use, for us it will be the Train and Test files you downloaded from Kaggle. Remember everything in R you type is case sensitive!

For Mac Users:
```R
setwd("/Users/(Folder)/(Folder)/(CurrentFolder)/")
```

For Windows users:<br />
```R
setwd("C://Users/(Folder)/(Folder)/(CurrentFolder)/")
```
Example:<br />
```R
setwd("/Users/Jeff_Adams/Desktop/work/kaggle_survivor/")
```

To run what you just wrote in your RScript, enter CONTROL and RETURN at the same time! It should now pop up on the bottom left window labeled "Console". Congrats you've just run your first line of R code! From now on you can run any of our code snippets by copy and pasting it into your own RScript and entering CONTROL and RETURN.

The path is essentially a hierchical represention of the workspace location. && I find this confusing

Now that we've indicated to R where we want to grab the files from, we can grab the files by what is called "reading in the code"; we utilize the ```read.csv()``` function to do that and we name the dataset by typing ```<-```. You'll notice that we also have you write something about header and stringsAsFactors. Setting ```header = TRUE ``` means that we want to keep the first row of data as column titles instead of as part of observations in the data set. StringsAsFactors is a little more complicated and we'll cover it later. Remember again, everything is case sensitive!

```R
trainData <- read.csv("train.csv", header = TRUE, stringsAsFactors = FALSE)
testData <- read.csv("test.csv", header = TRUE, stringsAsFactors = FALSE)
```

<a name="data exploration"></a>
####Data Exploration

Before actually building a model, we need to explore the data. To just look at the data set in R. Write the following:

```R
head(trainData)
```

The ```head()``` function in R shows you the first 6 rows of the data set.

We'll also take a look at a few values and plots to get a better understanding of our data. We start with a few simple generic x-y plots to get a feel. By first plotting the density we're able to get a sense of how the overall data feel and get a few vague answers: where is the general center? Is there a skew? Does is generally take higher values? Where are most of the values concentrated?


```R
plot(density(trainData$Age, na.rm = TRUE))
plot(density(trainData$Fare, na.rm = TRUE))
```
Try plotting the other variables by inserting ```trainData$(Variable)``` insteadf of age or fare. In R, ```$``` and column title selects an entire column of data. ```na.rm = TRUE``` means ignore the NA's in the data set.

Lets now look at the survival rate filtered by sex. Our intuition is that women had a higher chance of surviving because the crewman used teh standard "Women and Childre first" to board the lifeboats. We first create a table and call it ```counts```. Then we use R's ```barplot()``` function with respective x-axis, y-axis, and main titles. We also calculate the male/female survival rates from the table by indexing the table we made called ```counts```. ```counts[1]``` returns the top left value of the table, ```counts[2]``` the bottom left, and so on.

```R
counts <- table(trainData$Survived, trainData$Sex)
barplot(counts, xlab = "Gender", ylab = "Number of People", main = "survived and deceased between male and female")
counts[2] / (counts[1] + counts[2])
counts[4] / (counts[3] + counts[4])
```

Note that in the barplot you create the lighter areas indicate survival. Doing the calculations below the barplot we see that in our Train data, 74.2% of women survived versus 18.9% of men. 

Lets now look at the survival rate filtered by passenger class.

```R
Pclass_survival <- table(trainData$Survived, trainData$Pclass)
barplot(Pclass_survival, xlab = "Cabin Class", ylab = "Number of People",
        main = "survived and deceased between male and female")
Pclass_survival[2] / (Pclass_survival[1] + Pclass_survival[2]) 
Pclass_survival[4] / (Pclass_survival[3] + Pclass_survival[4]) 
Pclass_survival[6] / (Pclass_survival[5] + Pclass_survival[6])

```
It seems like the Pclass column might also be informative in survival prediction as the survival rate of the 1st class, 2nd class, and 3rd class are: 63.0%, 47.3%, and 24.2% respectively.


Though not covered here, a few more insights would be useful here; survival rate based on fare rages, survival rate based on age ranges etc. **The key idea is that we're trying to determine if any/which of our variables are related to what we're trying to predict: Survived**

<a name="data curation"></a>
####Data Curation

After doing some exploratory analysis of the data we now need to clean and curate it to create our model. Note that exploring the data helps you understand what elements need to be cleaned, for example you probably noticed that there are missing values in the data set.

At this point, we remove the variables that we do not want to use in the model: PassengerID, Ticket, Fare, Cabin, and Embarked. To do so we index our data set ```trainData``` with ```[ ]```. Using the ```c()``` means include the following column numbers and since we put a negative sign before it we're telling R to **not** include the following columns.

```R
trainData <- trainData[-c(1,9:12)]
```

Additionally, we need to replace qualitative variables (such as gender) into quantitative variables (0 for male, 1 for female etc) in order to fit our model. Note that there are models where the variables can be qualitative. We use the R function ```gsub()``` which will replace any text with a value of our choosing.

```R
trainData$Sex <- gsub("female", 1, trainData$Sex)
trainData$Sex <- gsub("^male", 0, trainData$Sex)
```

Lastly, upon examining our dataset, we see that many entries for "age" are missing. Because age entries could be an important variable we try inferencing them based on a relationship between title and age; we're essentially assuming that Mrs.X will older than Ms.X.

So first, we put the index of people with the specified surname into a list for further processing. In R we use the ```grep()``` function which will return a vector of row numbers which have a specified surname.

```R
master_vector <- grep("Master\\.",trainData$Name)
miss_vector <- grep("Miss\\.", trainData$Name)
mrs_vector <- grep("Mrs\\.", trainData$Name)
mr_vector <- grep("Mr\\.", trainData$Name)
dr_vector <- grep("Dr\\.", trainData$Name)

```

If you noticed there are many other surnames (Rev, Col, etc.) that are much less popular which we ignore dealing with for now.

Next we rename each of the rows with a shortened tag. For example if a row had a title such as "Allison, Master. Hudson Trevor" we shorten it to be "Master". This is done in the following code:

```R
for(i in master_vector) {
  trainData[i, 3] <- "Master"
}
for(i in miss_vector) {
  trainData[i, 3] <- "Miss"
}
for(i in mrs_vector) {
  trainData[i, 3] <- "Mrs"
}
for(i in mr_vector) {
  trainData[i, 3] <- "Mr"
}
for(i in dr_vector) {
  trainData[i, 3] <- "Dr"
}
```

```
FOR LOOP
Note that we use a _**for**_ function in the above snippet. For loop is intended to apply the same function, over a range of data.
```

Now that we have a series of standardized titles, we calculate the average age of each title.
We replace the missing ages with their respective title-group average. This means that if we have a missing age entry for a man named Mr.Bond, we substitute his age for the *average* age for all passenger with the title Mr. Similarly for *Master*, *Miss*, *Mrs*, and *Dr*. We then write a for loop that goes through the entire Train data set and checks if the age value is missing and if it is assigns it according to the surname of the observation. This code snippet is quite complicated and just copy and paste this for now!

```R

master_age <- round(mean(trainData$Age[trainData$Name == "Master"], na.rm = TRUE), digits = 2)
miss_age <- round(mean(trainData$Age[trainData$Name == "Miss"], na.rm = TRUE), digits =2)
mrs_age <- round(mean(trainData$Age[trainData$Name == "Mrs"], na.rm = TRUE), digits = 2)
mr_age <- round(mean(trainData$Age[trainData$Name == "Mr"], na.rm = TRUE), digits = 2)
dr_age <- round(mean(trainData$Age[trainData$Name == "Dr"], na.rm = TRUE), digits = 2)

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
```
IF
In the above code, we use the operator, if.
if (some true/false statement_1) {
  #do this action if it is true
} else if (some other true/false statement_2) {
  #do this if the statement_1 wasn't true, but statement_2 ended up true
} else if (some other true/false statement_3) {
  #do this if the statement_1 and statement_2 were both not true, but statement_3 was true.
} else {
  #do this if none of the statement_* was true. Note that this last bit of "else" doesn't always have to happen.
}
If statements allow people to let programs make decisions.
```

######We've now achieved the following:
- [x] Provided inference on the missing age entries.


At this point, we have accomplished the following:
- [x] load the data we intend to work with.
- [x] did some preliminary exploration into the data.
- [x] cleaned the data


We now begin the following:
- [] Creating additional variables which may improve the accuracy of our model.

#####Variable 1: Child.
This additional variable choice stems from the fact that we suspect that being a child might affect the survival rate of a passanger. 

We start by creating a child variable. This is done by appending an empty column to the dataset, titled "Child".
We then populate the column with value "1", if the passenger is under the age of 12, and "2" otherwie.

```R
trainData["Child"] <- NA

for (i in 1:nrow(trainData)) {
  if (trainData[i, 5] <= 12) {
    trainData[i, 8] <- 1
  } else {
    trainData[i, 8] <- 2
  }
}
```

#####Variable 2: Family
This variable is meant to represent the family size of each passenger by adding the number of Siblings/Spouses and Parents/Children and one. Our hypothesis is that larger families were less likely to survive.

```R
trainData["Family"] <- NA

for(i in 1:nrow(trainData)) {
  trainData[i, 9] <- trainData[i, 6] + trainData[i, 7] + 1
}
```

#####Varible 3: Mother
We add another variable indicating whether the passenger is a mother.
This is done by going through the passengers and checking to see if the title is Mrs and if the number of kids is greater than 0. This also includes any titles with Mrs and if the number of parents is greater than 0 but it is much less likely.

```R
trainData["Mother"] <- NA

for(i in 1:nrow(trainData)) {
  if(trainData[i,3] == "Mrs" & trainData[i, 7] > 0) {
    trainData[i, 10] <- 1
  } else {
    trainData[i, 10] <- 2
  }
}
```

Now, we have a fully equipped training dataset!
We have completed the following:
- [x] Added more variables that we think that may help with the classification.

<a name="train model"></a>
#####Now for the final step: fitting (training) a model! 
######We feed the training data into a model, and the model will optimize the itself to give you the best explanation for your variables and outcome. The idea is that we will use the trained model, along with test data to acquire our prediction.

###### Fitting logistic regression model. R will take care of solving/optmizing the model. We don't have to worry about any complicated Math!
@todo explain the model actuall is?
```R
train.glm <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare,
                 family = binomial, data = trainData)

train.glm.best <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Family + Mother,
                     family = binomial, data = trainData)

train.glm.one <- glm(Survived ~ Pclass + Sex + Age + Child + Sex*Pclass + Mother,
                     family = binomial, data = trainData)

train.glm.two <- glm(Survived ~ Pclass + Sex + Age + Child + Rich + Sex*Pclass, family =binomial,
                     data = trainData)
```

Now that we have a trained mdoel, we repeat the exact process on the test data that we did on the training data. The idea is to conduct the same steps (in terms of subsetting, cleaning, inference ,adding more variables), so that both datasets are in the same state. The only difference is the following: **The test dataset doesn't have the "surivived" variable (which is what we're trying to predict), therefore the subsetting indexes are slightly different when cleaning the data**


```
# Cleaning the testData set

testData <- testData[-c(8,10)]

# Converting categorical variable Sex to integers
testData$Sex <- gsub("female", 1, testData$Sex)
testData$Sex <- gsub("^male", 0, testData$Sex)

# Converting categorical variable Embarked to integers
testData$Embarked <- gsub("C", as.integer(1), testData$Embarked)
testData$Embarked <- gsub("Q", as.integer(2), testData$Embarked)
testData$Embarked <- gsub("S", as.integer(3), testData$Embarked)

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

# Adding a mother variable
testData["Mother"] <- NA
for(i in 1:nrow(testData)) {
  if(testData[i,3] == "Mrs" & testData[i, 7] > 0) {
    testData[i, 13] <- 1
  } else {
    testData[i, 13] <- 2
  }
}

```

<a name="predict model"></a>
####Now that the test dataset is ready, we plug it into the trained model below. Because the result is not in 0s and 1s (but rather continous), we apply a cutoff at 0.5, essentiall rounding the result to surived or non-survived.

&& Are people going to wonder why we use a cutoff of .5?

```R
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
```

We now output the data into a csv file, which can be submitted on kaggle for grading. Fingers Crossed!

```R
kaggle.sub <- cbind(testData$PassengerId,survival)
colnames(kaggle.sub) <- c("PassengerId", "Survived")
write.csv(kaggle.sub, file = "kpred14.csv")
```

Thanks for reading the tutorial!
PLEASE drop us any comment/suggestion/question at XXXX@gmail.com We will respond within 12 hrs!


