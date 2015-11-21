##CREATED BY

**Paulo Vito Bettini de Paiva Lima**

2015-11-21

##How the script works (run_analysis.R)
###Function list:
* ra_downloadFile: 

Function responsible create temporary data directory (if it doesn't exists), and to download the data file (if needed), and to unzip the data file (if needed). This function exists to provide an easy way to start working, without the hassle of downloading file, creating directories, unzipping, etc.

* ra_getFiles:

Function responsible to keep track of the files that we will manipulate, some are for reading, others for writing. Here is the list of files:

    data/UCI HAR Dataset/test/X_test.txt => Test data for X

    data/UCI HAR Dataset/test/y_test.txt => Test data for Y

    data/UCI HAR Dataset/train/X_train.txt => Train data for X

    data/UCI HAR Dataset/train/y_train.txt => Train data for Y

    data/UCI HAR Dataset/features.txt => Features labels

    data/UCI HAR Dataset/activity_labels.txt => Activities labels

    tidy_data_set.txt => Output dataset

    tidy_data_set_mean.txt => Output dataset, with means

If you need to change some files, just change this function.

* ra_mergeFiles:

Function responsible to merge the files with data;

* ra_selectFields:

Function responsible to select only the variables that has mean or std on the name, and the variable activity; This function expects one parameter, a data frame that contains merged data.

* ra_activityJoin:

Function responsible to change the activity number by its description, using the mapping defined on the activity_labels.txt; This function expects one parameter, a data frame that contains merged data.

* ra_exportTidySet:

Function responsible to export the tidy data set to file; This function expects one parameter, a data frame that contains merged data.

* ra_exportTidySetMean:

Function responsible to calculate the mean by activity and export the tidy data set to file; This function returns the new tidy data set (mean); This function expects one parameter, a data frame that contains merged data.


* run_analysis:

Function responsible to call the other function in order to get the results, this function will call both export functions. This function will return the tidy data set (without mean);

### Usage example:

```{r}
source('run_analysis.R')
data<-run_analysis()
View(data)
```
