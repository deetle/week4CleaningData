
#include("data.table")

################################################################
#
# read common data 
#
################################################################



# read column names from "features.txt".  It containes two columns.
# Names is the column we will be intrested in.
#   Numbers             Names
#         1 tBodyAcc-mean()-X
#         2 tBodyAcc-mean()-Y
#         ....................
#
#   The # of rows match the data set


print("+++++++++++++++++++ get column names")
ColumnNames = read.table("features.txt",
		              col.names=c("Numbers","Names"),           # Define first and second column names
				  colClasses=c("numeric","character"))      # Define first and second column data types.
print( dim(ColumnNames ) )
print( class(ColumnNames$Numbers) )  # should be be numeric 
print( class(ColumnNames$Names) )    # should be character 
print( head( ColumnNames ),20 )


# filter out unwanted characters in column names

columnNames = gsub( "[[:punct:]]" , "", ColumnNames$Names)
#columnNames = gsub( "()" , "", columnNames ,fixed=TRUE)
columnNames = gsub( "mean" , "Mean", columnNames ,fixed=TRUE)
columnNames = gsub( "std" , "Std", columnNames ,fixed=TRUE)
#columnNames = gsub( "[.]" , "", columnNames ,fixed=TRUE)
columnNames = gsub( "angle" , "Angle", columnNames ,fixed=TRUE)
columnNames = gsub( "gravity" , "Gravity", columnNames ,fixed=TRUE)
#columnNames = gsub( "angle.tBodyAccMean.gravity." , "AngleTbodyAccMeanGravity", columnNames ,fixed=TRUE)


print( head( ColumnNames ),20 )



# read activity table 
#
#  Number           Activity
#      1            WALKING
#      2   WALKING_UPSTAIRS
#      3 WALKING_DOWNSTAIRS
#      4            SITTING
#      5           STANDING
#      6             LAYING


print("+++++++++++++++++++ get activity table ")

ActivityTable = read.table("activity_labels.txt",
		                   col.names=c("Number","Activity"),         # Define first and second column names
				           colClasses=c("numeric","character"))      # Define first and second column data types.
print( dim(ActivityTable ) )
print( class(ActivityTable$Number) )      # should be be numeric 
print( class(ActivityTable$Activity) )    # should be character 
print( head( ActivityTable ) )

for( i in  1:nrow(ActivityTable ))
{
	print(ActivityTable [i,])
}

################################################################
#
#  Define readData function
# 
################################################################

ReadData <- function(subjectDataFile,
					 actvityDataFile,
                     dataFile) {


		columnPrintFilter = c(1,2,3,4,5)  # When printing tables for debug purposes , only print these columns


		# read subject data 
		print(paste("+++++++++++++++++++ get subject data: ",subjectDataFile))
		TestSubjectData = read.table(subjectDataFile,col.names="Subject")
		print( dim(TestSubjectData) )
		print( head(TestSubjectData ,3) )



		# read activity data 
		print(paste("+++++++++++++++++++ get activity data: ",actvityDataFile))
		TestActivityData = read.table(actvityDataFile,col.names="Activity")
		print( dim(TestActivityData ) )
		print( head(TestActivityData,3) )



		# read data 
		print(paste("+++++++++++++++++++ get data: ",dataFile))
		Data = read.table(dataFile,
						      colClasses=c("double"),
							  col.names=columnNames)     
							  
		print( dim(Data) )
		print( head( Data[, columnPrintFilter ],1 ) ) # print out the first few rows and columns
		print( class( Data[1,3] ))



		# filter out mean and std colums 

		print("+++++++++++++++++++ Filter out mean columns")

		TestDataMeanDataColumns = grep("Mean",columnNames,fixed=TRUE)
		print( length(TestDataMeanDataColumns) )
		print( names(Data[ ,TestDataMeanDataColumns]) )


		print(names(Data[ ,TestDataMeanDataColumns])[1])
		print(ColumnNames$Names[1])
		print("+++++++++++++++++++ Filter out std columns")
		TestDataSdtDataColumns = grep("Std",columnNames,fixed=TRUE)
		print( length(TestDataSdtDataColumns ) )
		print( names(Data[ ,TestDataSdtDataColumns ]) )


		print("+++++++++++++++++++ Filter mean and STD data tables")

		FilteredMeanTestData = Data[ ,TestDataMeanDataColumns]
		print( dim( FilteredMeanTestData ) )

		FilteredStdTestData = Data[ ,TestDataSdtDataColumns ]
		print( dim( FilteredStdTestData ) )



		# merge tables


		print("+++++++++++++++++++ Merge mean and STD data tables")


		Data  = cbind(FilteredMeanTestData ,FilteredStdTestData)
		print( dim(Data) )


		print("+++++++++++++++++++ Merge Subject and Data tables")


		Data  = cbind(TestSubjectData ,Data  )
		print( dim(Data) )

		print("+++++++++++++++++++ Merge Activity and Data tables")

		Data  = cbind(TestActivityData ,Data  )
		print( dim(Data) )
		print( names(Data  ))
		print( head( Data,5 ) ) # print out the first few rows and columns



		# replace activity Number with their Activity names
		print("+++++++++++++++++++ Replace activity Number with their Activity names")
		for( i in  1:nrow(ActivityTable ))
		{
			  Data[ Data$Activity == ActivityTable[i,"Number"],"Activity"]  = trimws(ActivityTable[i,"Activity"])
		}
		print( class( Data$Activity) )

		# convert activity to a factor column
		print("+++++++++++++++++++ convert activity to a factor column")

		Data$Activity = as.factor(Data$Activity)

		print( class( Data$Activity) )
		
		print(dim(Data))

		print( head( Data[, columnPrintFilter ],5 ) ) # print out the first few rows and columns


		Data

}


#
# read test data 
#

print("+++++++++++++++++++ Read Test Data")
TestData = ReadData(
					"test\\subject_test.txt",   # subject
					"test\\y_test.txt",         # activity 
					"test\\x_test.txt")         # data

#
# read train data 
#

print("+++++++++++++++++++ Read Train Data")

TrainData = ReadData(
			"train\\subject_train.txt",  # subject
                  "train\\y_train.txt",        # activity 
                  "train\\x_train.txt")        # data
				  
				  
#
# Merge Test and Train Data 
# 

print("+++++++++++++++++++ Merge Test & Train Data")
print( dim(TrainData))
print( dim(TrainData))


Data  = rbind(TestData ,TrainData )
print( dim(Data) )

print("+++++++++++++++++++ Write tidy data set to file as data.txt")

#
# Write tidy data set to file as data.txt
#

write.table(Data,file = "data.txt",row.name=FALSE , col.names=TRUE)


#
#
#  Create second tidy data set
#
#  Columns names will become rows.  Then the collumn will represent Activity and Subject categries 
#  we got the means for.
#
#                      A.LAYING.mean A.SITTING.mean ...
# tBodyAcc.mean.X        0.268648643    0.273059614 ...
# .....................................................
#

print("+++++++++++++++++++ Create second tidy data set")


print("+++++++++++++++++++ Split data on Activity")

#
# Split data on activity 
#

DataGroupByActivity = split(Data  ,Data$Activity)
print( length(DataGroupByActivity))
print( names(DataGroupByActivity))

#
# create empty data frame 
#

activityMeanDF = data.frame(Temp=c(1:(length(names(Data))-2)))
print( dim(activityMeanDF ) )

#
# loop threw the activitys of the split data
#

for( a in  names(DataGroupByActivity ))
{
	print(a)

    # Get the the data set for the current activity 

	ad = DataGroupByActivity [[a]]  
	print(dim(ad))
	print(class(ad))
	#print(str( ad ))
	print( ad[4,5])

	# calulate the means for the columns

	aColMean = colMeans( ad[,c(3:ncol(ad) )])
	#print(aColMean )
	print( class(aColMean ))
	print( length(aColMean ))

	# turn the column means data into a data frame with a 
	# single names column

	Row = data.frame(aColMean ) 
	colnames(Row) = paste0("A.",a,".mean")
	#print(Row)

	# add the column means to the data frame 

	activityMeanDF = cbind(activityMeanDF,Row)
	
}

#print(activityMeanDF )
#print( dim(activityMeanDF ))

# remove the Temp column 

activityMeanDF$Temp = NULL

#
# Split data on subjects 
#

print("+++++++++++++++++++ Split data on Subjects")

DataGroupBySubject = split(Data  ,Data$Subject)
print( length(DataGroupBySubject ))
print( names(DataGroupBySubject ))

#
# create empty data frame 
#

subjectMeanDF = data.frame(Temp=c(1:(length(names(Data))-2)))
print( dim(subjectMeanDF ) )

#
# loop threw the subjects of the split data
#

for( s in  names(DataGroupBySubject ))
{
	print(s)

 	# Get the the data set for the current subject 

	sd = DataGroupBySubject [[s]]
	print(dim(sd))
	print(class(sd))
	#print(str( sd ))
	print( sd[4,5])


	# calulate the means for the columns

	sColMean = colMeans( sd[,c(3:ncol(ad) )])
	#print(sColMean )
	print( class(sColMean ))
	print( length(sColMean ))

	# turn the column means data into a data frame with a 
	# single names column

	Row = data.frame(sColMean ) 
	colnames(Row) = paste0("S.",s,".mean")
	#print(Row)

	# add the column means to the data frame 

	subjectMeanDF = cbind(subjectMeanDF ,Row)
}

#print( head(subjectMeanDF ) )
#print( dim(subjectMeanDF ))

# remove the Temp column 

subjectMeanDF$Temp = NULL




# combine activity mean and subject mean data 


Data2 = cbind(activityMeanDF ,subjectMeanDF )

print( head(Data2 ) )
print( dim(Data2 ))




# Write tidy data set to file as data.txt


print("+++++++++++++++++++ Write tidy data set to file as data.txt")
write.table(Data2 ,file = "data2.txt",row.names=TRUE,col.names=TRUE)

print(" +++ DONE +++ ")




































