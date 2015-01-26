#######
#The purpose of this project is to demonstrate your ability to collect, 
#work with, and clean a data set. The goal is to prepare tidy data that 
#can be used for later analysis. You will be graded by your peers on a 
#series of yes/no questions related to the project. You will be required 
#to submit: 

#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis
#3) a code book that describes the variables, the data, and any transformations 
#or work that you performed to clean up the data called CodeBook.md. You should 
#also include a README.md in the repo with your scripts. This repo explains 
#how all of the scripts work and how they are connected.  

#One of the most exciting areas in all of data science right now is wearable 
#computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new 
#users. The data linked to from the course website represent data collected from 
#the accelerometers from the Samsung Galaxy S smartphone. A full description is 
#available at the site where the data was obtained: 



# 0. Getting data from the web 
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/data.zip",method="curl")
unzip("./data/data.zip",exdir="./data/")

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
train_set_sub <-read.table(file="./data/UCI HAR Dataset/train/subject_train.txt",header=F)

train_set_y <- read.table(file="./data/UCI HAR Dataset/train/y_train.txt",header=F)

train_set_x <- read.table(file="./data/UCI HAR Dataset/train/x_train.txt",header=F)

test_set_sub <-read.table(file="./data/UCI HAR Dataset/test/subject_test.txt",header=F)
test_set_y <- read.table(file="./data/UCI HAR Dataset/test/y_test.txt",header=F)
test_set_x <- read.table(file="./data/UCI HAR Dataset/test/X_test.txt",header=F)

names(train_set_sub) <- "sub"
names(train_set_y) <- "y"
names(test_set_sub) <- "sub"
names(test_set_y) <- "y"

merge_data <-rbind(cbind(train_set_sub,train_set_x,y=train_set_y,dataset=rep("train",dim(train_set_sub)[1])),
                   cbind(test_set_sub,test_set_x,y=test_set_y,dataset=rep("test",dim(test_set_sub)[1])))
head(merge_data,n=3)

# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement
feature_table<-read.table(file="./data//UCI HAR Dataset//features.txt")
features.mean_std <- feature_table[grep("mean\\(\\)|std\\(\\)", feature_table$V2), ]
merge_data.mean_std <- merge_data[, c(1, features.mean_std$V1+2,563:564)]

# 3. Uses descriptive activity names to name the activities in the data set
act_table<- read.table(file="./data/UCI HAR Dataset//activity_labels.txt")
merge_data$y <- act_table[merge_data.mean_std$y,2]
head(merge_data.mean_std$y)

# 4. Appropriately labels the data set with descriptive variable names. 
feature_table<-read.table(file="./data//UCI HAR Dataset//features.txt")

names(merge_data.mean_std)[2:67]<-as.character(features.mean_std[,2])
head(names(merge_data));tail(names(merge_data))
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
tidy_data <- aggregate(merge_data.mean_std[,2:67],
                       by=list(subject = merge_data.mean_std$sub, 
                               label = merge_data.mean_std$y),
                       mean)
head(tidy_data[1:10,1:10])
write.table(format(tidy_data, scientific=T), "tidy.txt",
            row.names=F, col.names=F, quote=2)
