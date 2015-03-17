library(plyr)

# change me if needed - this folder is created when unzipping data source into the repo
path="C:/Users/punit.kishore/Desktop/UCI HAR Dataset"
setwd(path)

#1.. Merging Data test as per instructions.

X_train <- read.table("train/X_train.txt")
X_test <- read.table("test/X_test.txt")
X_Data <- rbind(X_train, X_test)




y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")
Y_Data <- rbind(y_train, y_test)


subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")
Subject_Data <- rbind(subject_train, subject_test)


# #2: We should only keep mean and standard deviation for each measurement.

features <- read.table("features.txt")
position <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X_Data <- X_Data[, position]

# we set and clean column names
names(X_Data) <- features[position, 2]
# we remove unwanted characters from column names
names(X_Data) <- gsub("\\(|\\)", "", names(X_Data))
names(X_Data) <- tolower(names(X_Data))
# time to cleanup no longer required variables
rm(position, features)

# #3: descriptive activity column, based on activity_labels.txt
activity_labels <- read.table("activity_labels.txt")
# clean activity names
activity_labels[, 2] = gsub("_", "", tolower(as.character(activity_labels[, 2])))
Y_Data[,1] = activity_labels[Y_Data[,1], 2]
# name that new column
names(Y_Data) <- "activity"

# labeling Subject
names(Subject_Data) <- "subjectnumber"

#  merging & saving  into a file: X_Data, Y_Data, SubjectData

merged <- cbind(Subject_Data, Y_Data, X_Data)
write.table(merged, "tidy_data.txt",row.names= FALSE)

# #5: "Creating second data set with the average of each variable for each activity and each subject."

excludedColumns = which(names(merged) %in% c("subjectnumber", "activity"))
result <- ddply(merged, .(subjectnumber, activity), .fun=function(x){ colMeans(x[,-excludedColumns]) })

write.table(result, "average_data.txt",row.names= FALSE)
