


##Study Design 

##The experiment 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

##The data set 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##The process for the resulting table 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



##Steps taken by run_analasys.r
1. Read column name data fie ( features.txt )
2. Read Activity table file  ( activity_labels.txt )
3. Read both the test and Train Data
	1. Read subject column data and clean up its names  
		For example remove ‘(‘ and ‘)’ characters
	3. Read activity column data
	4. Read data for all the 561 columns  
		This will also assign each of the columns it name from the previously read column name data file 
	6. Remove all NON mean and STD columns  	
		Leaves you 79 columns 
	7. Merge Subject Column &  Activity Column &  Data Columns  
		Giving you a total of 81 columns 
	8. Replace Activity numbers with descriptive Activity names  
       For example, a 1 in the active column becomes WALKING
4. Merge the test data and train data tables 
8. Write the resulting table to file 


