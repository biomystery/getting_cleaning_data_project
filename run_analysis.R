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
library(data.table)
train_set_obj <-
train_set_label <- fread("./data/UCI HAR Dataset/train/y_train.txt",header=F)
train_set_value <- fread("./data/UCI HAR Dataset/train/x_train.txt",header=F)
train_set_value <-cbind(train_set_value,label=train_set_label);rm(train_set_label)
head(train_set_value,n=3)

test_set_label <- read.csv(file="./data/UCI HAR Dataset/test/y_test.txt",header=FALSE)
test_set_value <- read.table(file="./data/UCI HAR Dataset/test/X_test.txt")
test_set_value <-cbind(test_set_value,test_set_label);rm(test_set_label)
head(test_set_value,n=3)

merge_date <-merge(train_set_value,test_set_value,all=TRUE)
head(merge_date,n=3)

# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.