##Code Book 


###Data set # 1 returned in data.txt from the run_analysis. r script. 

| Column / Variable name  | Column # | Data Type | Description |
|-------------------------|:--------:|:---------:|------------:|
| Activity                | 1 		 | Factor    | Expresses on of the 6 activities. WALKING ,WALKING_UPSTAIRS ,WALKING_DOWNSTAIRS , SITTING ,STANDING and LAYING
| Subject                 | 2		 | Numeric   | A number identifying one of the 30 subjects 1 threw 30  |
| tGravity* & tBody*      | 3 to 81  |           | 79 variables from the original data set that represent the mean and SDT . The variable names have been cleaned up to remove  the ‘-‘ , ‘()” characters. For example the variable from the original data set tBodyAcc-mean()-X  was renamed to tBodyAcc.mean.X



###Data set # 2 returned in data.txt from the run_analysis. r script. 


The ask “average of each variable for each activity and each subject “is a bit ambiguous.  
As its not asking explicitly for a mean for each combination of activity and subject, 
I concluded that is must be asking means for activities and subjects independent.  A total of 36 means across 78 variables 

To represent this in a single table the 70 variables from the first data set are now the observations named rows. And each column Activity Laying, Subject 30 , .. is now the variable.  
That means we will have 6 columns to represent the activity mean and 30 Colum to represent the Subject means. For a total of 36 columns. 
The table snippet below 

```
                   A.LAYING.mean     A.SITTING.mean  …
tBodyAcc.mean.X       0.26864864         0.27305961  …
tBodyAcc.mean.Y      -0.01831773        -0.01268957  …
…………………………………………………………………………………………………………………………….
```

| Column / Variable name  | Column #   | Data Type | Description |
|-------------------------|:----------:|:---------:|------------:|
| A.\<Activity\>.mean     | 1 threw 6  | Numeric   | Where \<Activity\> is one of the 6 activities , WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING , STANDING ,LAYING
| S.\<Subject\>.mean      | 7 threw 37 |  Numeric  | Where \<Subject\> is one of the 30  numbers representing a subject





