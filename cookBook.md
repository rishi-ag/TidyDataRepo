Cookbook for Data Cleaning
==========================

Introduction
------------
Welcome to the cookbook for the first assignment of the course Getting and Cleaning Data. In this cookbook, I will proceed to describe the following:

1. All packages needed for the analysis
2. All the variables used to transform data from its raw format to a tidy format
3. The flow of the transformations
4. Describe the final tidy data itself

Packages Used
-------------
1. sqldf
2. reshape2

Variable Description
--------------------
Variables below are listed not alpabetically but in the order in which they appear. This along with well named variables facilitate a better understanding of the flow of the analysis even before the user reads the flow description.

| Name            | Type             | Description                                                              |
| :-------------- | :--------------- | :----------------------------------------------------------------------- |
| featureDF       | Data Frame       | 561 Feature names with ID                                                |
| featuresVector  | Character Vector | Extracted feature names                                                  |
| activityNameDF  | Data Frame       | Activity names with ID                                                   |
| testDataDF      | Data Frame       | Contains test data                                                       |
| testSubjectDF   | Data Frame       | Test subjects by ID                                                      |
| testActivityDF  | Data Frame       | Activity of test subjects by ID and later by name                        |
| sql1            | Character Vector | SQL to generate activity names based on IDs for test data                |
| testDataTempDF  | Data Frame       | Combines subject IDs, activity names and test data in one Data Frame     |
| trainDataDF     | Data Frame       | Contains training data                                                   |
| trainSubjectDF  | Data Frame       | Training subjects by ID                                                  |
| trainActivityDF | Data Frame       | Activity of training subjects by ID and later by name                    |
| sql2            | Character Vector | SQL to generate activity names based on IDs for training data            |
| trainDataTemp   | Data Frame       | Combines subject IDs, activity names and training data in one Data Frame |
| tempCombDataDF  | Data Frame       | Combines trainDataTemp and testDataTemp vertically                       |
| sql3            | Character Vector | SQL to extract feature names that represent mean and std of obs.         |
| relevantCols    | Data Frame       | Contains names of columns extracted by SQL3                              |
| meltTempCombData| Data Frame       | Melted tempCombDataDF                                                    |
| tidyData        | Data Frame       | Final tidy dataset                                                       |

Flow of Transformations
-----------------------

1. As a first step, groundwork for later transformations is layed out by loading activity names and feature names from the given files. The activity names will be used to replace activity IDs to imrpove readdability of tidy adatset. Feature names will be used to name columns representing mean and std calculations of observations.
2. For each of the test and training datasets the following sets are performed:

        - Test data is loaded into a data frame.
        - Corresponding activity IDs are loaded into a daat frame
        - Corresponding subject IDs are loaded in to the data frame
        - SQLDF is used to replace activity IDs by activity names by joining activity name data extracted in step 1 and activity id data. I chose to use SQLDF to join data because it does not alter the ordering of the data. This makes it easier to just combine corresponding sets of data in different data frames using cbind.
        - Subject IDs, test data and activity labels are combined into one dataset using cbind.
        - Columns are named. Columns corresponding to features are named using the feature names that were extracted in step one.
        
3. Correctly labled test and training data sets are combined vertically using cbind.
4. SQLDF is used on feature names vector to isolate column names that represent means or standard deviations of observations.
5. After identifying relevant columns, they are retained in the combined data set.
6. RESHAPE2 package is ued to melt combined dataset into id columns and a single column representing all measurement variables. I have done this step to faciliate calculation of summary statistic "mean" of all measurement variables simultaneously.
7. The melted data set is then recast into a dataset containing seperate id and measurement variables. Each measurement variable's mean is calulated by subject and activity.
8. Finally, the tidy dataset is written to a .txt file.