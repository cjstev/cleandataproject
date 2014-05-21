
library(plyr)

## Unzip the file to local directory

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/data.zip")
unzip("./data/data.zip", exdir = "./data")

## Read Files into R

folders <- list.dirs("./data/UCI HAR Dataset")[c(1,2,4)]

for (i in 1:length(folders)) {        
        files_list <- list.files(folders[i], pattern="*txt")
        if(i==1){ files_list <- files_list[1:2] }
        object_names <- gsub(".txt", "", files_list)
        for (j in 1:length(files_list)){
                f1 <- read.table(paste(folders[i], "/",files_list[j], sep=""), stringsAsFactors = FALSE)
                assign(paste("tbl", object_names[j], sep=""), f1)
        }
}

remove("f1","files_list","object_names","folders","i","j","fileUrl")

## Substitute Activity Label for Number

testLabels = matrix(nrow=nrow(tbly_test))
for(i in 1:nrow(tbly_test)){
        a <- tbly_test[i,1]
        b <- tblactivity_labels[a,2]
        testLabels[i,1] <- b
}
testLabels <- as.data.frame(testLabels)

trainLabels = matrix(nrow=nrow(tbly_train))
for(i in 1:nrow(tbly_train)){
        a <- tbly_train[i,1]
        b <- tblactivity_labels[a,2]
        trainLabels[i,1] <- b
}
trainLabels <- as.data.frame(trainLabels)

remove("tbly_train","tbly_test","tblactivity_labels")

## Create Column Labels for DFs

colNames <- tblfeatures[,2]

colNames <- c("subject","activity",colNames)

remove(tblfeatures)

## Build Train Dataframe
train <- cbind(tblsubject_train,trainLabels,tblX_train)

colnames(train) <- colNames

remove(tblsubject_train,trainLabels,tblX_train)

## Build Test Dataframe
test <- cbind(tblsubject_test,testLabels,tblX_test)

colnames(test) <- colNames

remove(tblsubject_test,testLabels,tblX_test)

## Combine Test and Train DFs

master <- rbind(test,train)

remove(test,train)

remove(a,b,colNames,i)

## Extract Mean and STD Measurements

valids <- grep("mean[^Freq]|std|subject|activity",names(master))

master <- master[,valids]

remove(valids)

## Average each variable for each activity and subject

master<-master[order(master$subject,master$activity),]

subject <- unique(master$subject)
activity <- unique(master$activity)

f<-colwise(mean)

extra<- matrix(nrow=0, ncol=66)

for (i in 1:length(subject)){
        for (j in 1:length(activity)){
                A <- master[master$subject == subject[i] & master$activity == activity[j],3:68] 
                B <- f(A)
                extra <- rbind(extra,B)
        }
}

#creates labels

labels <- data.frame(gl(30,6),activity)

meandf <- cbind(labels,extra)

titles<-names(meandf)

titles[1]<-"subject"

colnames(meandf)<-titles

remove(labels,extra,A,B,activity,i,j,subject,titles,f)



