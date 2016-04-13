filename <- "UCIDataset"

#### load libraries
library(dplyr)

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  

home_dir<-'UCI HAR Dataset/'

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#home_dir<-'/Users/priyanchandrapala/Documents/DataScienceCourse/Rworkspace/UCI HAR Dataset/'

####### Load the files 
### Define file location URLs to load data

# Features and activity urls
url_activity_labels <- paste(home_dir, "activity_labels.txt", sep="")
url_features <- paste(home_dir, "features.txt", sep="")

# Train data set
url_train_subjects<- paste(home_dir, "train/subject_train.txt", sep="")

url_y_train <- paste(home_dir, "train/y_train.txt", sep="")
url_x_train <- paste(home_dir, "train/x_train.txt", sep="")

# Test data set
url_test_subjects<- paste(home_dir, "test/subject_test.txt", sep="")

url_y_test  <- paste(home_dir, "test/y_test.txt", sep="")
url_x_test <- paste(home_dir, "test/x_test.txt", sep="")

### Load the files in to datasets 
df_activity_labels <- read.table(url_activity_labels)
df_features <- read.table(url_features)

df_train_subjects <- read.table(url_train_subjects)
df_test_subjects <- read.table(url_test_subjects)

df_x_train <- read.table(url_x_train)
df_x_test <- read.table(url_x_test)

df_y_train <- read.table(url_y_train)
df_y_test <- read.table(url_y_test)

### Merge the files 

# subjects
df_subjects_merged<- rbind(df_train_subjects, df_test_subjects)

# X data set
df_x_merged<- rbind(df_x_train, df_x_test)

# y data set
df_y_merged<- rbind(df_y_train, df_y_test)


### Save the merged files back (optional)


### Extract Avg and Std columns 

df_feature_subset<- df_features[grepl("mean|std", df_features $V2), ]
df_x_merged_subset <- df_x_merged[,df_feature_subset$V1]

x_names <-as.character(df_feature_subset$V2)

x_names = gsub('-mean', 'Mean', x_names)
x_names = gsub('-std', 'Std', x_names)
x_names <- gsub('[-()]', '', x_names)


### Assign column names
colnames(df_x_merged_subset)<-x_names


# Name Subject
names(df_subjects_merged)<-c("Subject")

# Name Activity
names(df_activity_labels) <-c("Activity","ActivityName")

# Name y 
names(df_y_merged) <-c("Activity")

#### Merge the X,y, subject and activity data

# merge activity labels with previously merged activity data
df_y_merged_labled <- merge(df_y_merged, df_activity_labels, by=c("Activity"))
df_y_merged_activity<- as.data.frame(df_y_merged_labled$ActivityName)
names(df_y_merged_activity) <- c("ActivityName")
df_x_subjects_activity_merged_subset <-cbind(df_y_merged_activity,df_subjects_merged, df_x_merged_subset)

## Save workspace 

save.image("coursework2.rda")

## Summarising 

df_x_subjects_activity_merged_subset_summary <- df_x_subjects_activity_merged_subset %>% group_by(ActivityName,Subject) %>% summarise_each(funs(mean))

# write back the df_x_subjects_activity_merged_subset_summary
url_main_summary<- paste(home_dir, "merge/X_summary.txt", sep="")
merge_dir<- paste(home_dir, "merge", sep="")

dir.create(merge_dir, showWarnings = TRUE, recursive = FALSE, mode = "0777")
write.table(df_x_subjects_activity_merged_subset_summary, file= url_main_summary,row.name=FALSE)

