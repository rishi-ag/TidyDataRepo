## Packages
library(sqldf)
library(reshape2)

##Please set working directory to a valid path name on your console
setwd("C:\\Users\\RA186032\\Documents\\Coursera\\Data Science Track\\3. Getting and Cleaning Data\\HW")

##Load Features.txt from file
featureDF <- read.table(".\\data\\UCI HAR Dataset\\features.txt", nrows = 561, 
                            col.names = c("ID", "Feature"))

##Extract feature names
featuresVector <- as.vector(featureDF[[2]])

##Load Activity File
activityNameDF <- read.table(".\\data\\UCI HAR Dataset\\activity_labels.txt", 
                           col.names = c("ID", "Activity"))

##PROCESSING TEST DATA
        #Load test data with 561 features in each row
        testDataDF <- read.table(".\\data\\UCI HAR Dataset\\test\\X_test.txt")
        
        #Load test subject ids
        testSubjectDF <- read.table(".\\data\\UCI HAR Dataset\\test\\subject_test.txt")
        
        #Load test activity data and replace activity number by activity name
        testActivityDF <- read.table(".\\data\\UCI HAR Dataset\\test\\y_test.txt", col.names = "ID")
        sql1 <- "select Activity from testActivityDF A join activityName B on A.ID = B.ID"
        testActivityDF <- sqldf(sql1)
        
        #Merge feature vector
        testDataTempDF <- cbind(testSubjectDF, testActivityDF, testDataDF)
        
        #Label columns
        colnames(testDataTempDF) <- c("subject_ID", "activity", featuresVector)

##PROCESSING TRAINING DATA
        #Load train data with 561 features in each row
        trainDataDF <- read.table(".\\data\\UCI HAR Dataset\\train\\X_train.txt")
        
        #Load train subject ids
        trainSubjectDF <- read.table(".\\data\\UCI HAR Dataset\\train\\subject_train.txt")
        
        #Load train activity data replave activity number by activity name
        trainActivityDF <- read.table(".\\data\\UCI HAR Dataset\\train\\y_train.txt", col.names = "ID")
        sql2 <- "select Activity from trainActivityDF A join activityNameDF B on A.ID = B.ID"
        trainActivityDF <- sqldf(sql2)
        
        #Merge feature vector
        trainDataTempDF <- cbind(trainSubjectDF, trainActivityDF, trainDataDF)
        
        #Label columns
        colnames(trainDataTempDF) <- c("subject_ID", "activity", featuresVector)


##Combining Test Data and Training Data
tempCombDataDF <- rbind(testDataTempDF, trainDataTempDF)

##Using sqldf package to isolate relevant columns from tempData DF
sql3 <- "select ID from featureDF where Feature like '%mean()%' or Feature like '%std()%'"
relevantCols <- sqldf(sql3)[[1]] + 2

##Filter out relevant columns which have mean and std variations and get TIDY DATA
tempCombDataDF <- tempCombDataDF[, c(1, 2, relevantCols)]

##melting data and creating tidy file with average of all variables
meltTempCombData <- melt(tempCombDataDF, id.vars= as.vector(names(tempCombDataDF)[1:2]))
tidyData <- dcast(meltTempCombData, subject_ID + activity ~ variable, mean)

##Writing data to file
write.table(tidyData, ".//data//tidyData.txt")
