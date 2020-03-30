# loading the dataset
library(dplyr)

# unzipping the file downloaded
unzip("getdata_projectfiles_UCI HAR Dataset")

# reading train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# reading test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# reading vaariable names
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# reading activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merging the training and the test sets to create one data set.
x_merge <- rbind(x_train, x_test)
y_merge <- rbind(y_train, y_test)
sub_merge <- rbind(sub_train, sub_test)

# Extracting only the measurements on the mean and standard deviation for each measurement.
extract <- grep("mean\\(\\)|std\\(\\)",variable_names[,2])
selected_var <- variable_names[extract,]
x_merge <- x_merge[,selected_var[,1]]

# Naming the activities
colnames(y_merge) <- "activity"
y_merge$activitylabel <- factor(y_merge$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_merge[,-1]

# Labelling the dataset
colnames(x_merge) <- variable_names[selected_var[,1],2]

# Creating a new dataset
colnames(sub_merge) <- "subject"
new <- cbind(x_merge, activitylabel, sub_merge)
new_mean <- new %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(new_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)