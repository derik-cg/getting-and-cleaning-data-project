##Codebook for the variables
This dataset describes how the variables were obtained and describes them

#background
The original accelerometer data was obtained from 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This is not raw data because it includes transformations including filters, means, and std.

Variable names were modified to increase their readability, at the cost of having 
very long names. To do this, two abbreviations that could cause confusion
were expanded:
acc -> acceleration
mag -> magnitude

Also, duplicates of the word "body" were eliminated

The word "std" was not expanded because it was assumed easily understood.

Only columns matching the criteria number 2 in the assigment, namely
"Extracts only the measurements on the mean and standard deviation for each measurement."
were considered. However, there are three types of means included in the dataset.
1. mean estimated from the signals, coded as mean()
2. weighted means, that produce the average frequency
3. averages on a window sample used in the angle() variable

The first type of mean fits in the criteria without problem. The second type is a 
variant of the traditional mean, and the end product is the average frequency. This 
was assumed to fit in the criteria.
The third type of average was done on a time window. This means that only a subset
of the data was used to compute the mean. This is enough for this type of average
not to fit the criteria. Moreover, the end product is an angle, not an average.
The third type of average was eliminated from the dataset.

The train and test datasets were treated in the same way. Since the id of each
participant, as well as the activities were in separate files, they were
added as new columns in each dataset. This assumed that the order of all three
columns matches perfectly.

To merge both datasets, one was binded at the top of the other. this was possible
because all variable were the same.

The tidy dataset for the means of all variables has one column for the individual
id of the participant and other for the activity. Since each individual performed
a total of six activities, the id column has each id repeated six times. This is 
consistent with the tidy data criteria, because each row corresponds to one
observation, the observation being the activity performed by the indivitual.

The means of each variable (grouped.means) was computed, but the names of the dataset do not reflect
this. This is because by default, the names of the variables are inherited from
the dataset. Just bear in mind that for this dataset, each column represents the 
means.