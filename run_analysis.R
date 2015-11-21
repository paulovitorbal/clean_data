ra_downloadFile <- function () {
  remotefile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
  if (!dir.exists("data")){
    dir.create("data");
    print("Creating data dir.");
  }else{
    print("Data dir already created, using it.");
  }
    
  if (!file.exists("data/data.zip")){
    print("downloading remote data file to data/data.zip");
    download.file(remotefile, "data/data.zip");
  }else{
    print("Using file at: data/data.zip");
  }
  
  if (dir("data")[1] == "data.zip" && length(dir("data")) == 1){
    print("uncompressing zipped data to data/");
    unzip("data/data.zip",exdir = "data")
  }else{
    print("data already uncompressed, using it.")
  }
    
}
ra_getFiles <- function(){
  files <- c(
    "data/UCI HAR Dataset/test/X_test.txt",
    "data/UCI HAR Dataset/test/y_test.txt",
    "data/UCI HAR Dataset/train/X_train.txt",
    "data/UCI HAR Dataset/train/y_train.txt",
    "data/UCI HAR Dataset/features.txt",
    "data/UCI HAR Dataset/activity_labels.txt",
    "tidy_data_set.txt",
    "tidy_data_set_mean.txt"
  );
  
  
}
ra_mergeFiles <- function(){
  files <- ra_getFiles();
  X.test <- read.table(files[1], quote="\"")
  Y.test <- read.table(files[2], quote="\"")
  data.test <- cbind(Y.test,X.test)
  
  X.train <- read.table(files[3], quote="\"")
  Y.train <- read.table(files[4], quote="\"")
  data.train <- cbind(Y.train, X.train)
  
  data.merged <- rbind(data.test, data.train)
  remove(X.test,Y.test, data.test, X.train, Y.train, data.train);
  data.merged
}
ra_selectFields <- function(merged){
  files <- ra_getFiles();
  data.features <- read.table(files[5], quote="\"", stringsAsFactors = FALSE)
  names(merged) <- c("activity", gsub("-","",data.features$V2))
  
  
  data.merged1 <- merged[,"activity"]
  data.merged2 <- merged[grep("mean|std", names(merged), value = TRUE)]
  
  merged <- cbind(data.merged1, data.merged2)
  remove(data.merged1, data.merged2);
  merged
}
ra_activityJoin <- function(merged){
  files <- ra_getFiles();
  names(merged)[1] <- "activity"
  
  data.activitylabel <- read.table(files[6], quote="\"", stringsAsFactors = FALSE)
  
  merged$activity <-as.factor(merged$activity)
  levels(merged$activity) <- data.activitylabel$V2
  merged
}
ra_exportTidySet <- function(data.tidy){
  files <- ra_getFiles();
  write.table(data.tidy, file=files[7],col.names=TRUE, row.names = FALSE);
}
ra_exportTidySetMean <- function(data.tidy){
  files <- ra_getFiles();
  data.tidy.mean <- as.data.frame(
    as.table(
      tapply(
        data.tidy[,2],
        data.tidy[,1], 
        mean
      )
    )
  )
  
  for (i in 3:ncol(data.tidy)){
    temp <- as.data.frame(
      as.table(
        tapply(
          data.tidy[,i],
          data.tidy[,1], 
          mean
        )
      )
    )
    data.tidy.mean <- cbind(data.tidy.mean,temp[,2])                  
  }
  
  names(data.tidy.mean) <- names(data.tidy)
  
  write.table(data.tidy.mean, files[8], sep="\t", col.names=TRUE, row.names = FALSE)
  data.tidy.mean
}
run_analysis <- function(){
  data.merged <- ra_mergeFiles();
  data.merged <- ra_selectFields(data.merged);
  data.merged <- ra_activityJoin(data.merged);
  ra_exportTidySet(data.merged);
  ra_exportTidySetMean(data.merged);
  data.merged
}