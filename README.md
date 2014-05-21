cleandataproject
================

##Getting and Cleaning Data Course Project

This repo includes:
* A readme: README.md
* The script used to download and clean the data: run_analysis.R
* A full dataset file: FullData.txt
* A dataset with the mean of all subjects across all activities: MeanData.txt
* A codebook: codebook.md

 #Description of run_analysis.R
 
Below is a desctiption of what is accomplished by this R file.
1. Data is downloaded to a local folder in the working directory called "data"
2. All files in the following subfolders are read into R except the README.txt and the features_info.txt: "./data/UCI HAR Dataset"       "./data/UCI HAR Dataset/test"  "./data/UCI HAR Dataset/train"
3. All of the activity numbers in the data are replaced by the activity labels; ie walking, sitting
4. Column labels are created for all columns in the data
5. DFs are built for the train and test datasets with the cbind command then labels are attached
6. DFs are merged into one
7. Mean and STD measurements are GREP'd from the DF
8. The DF is sorted by subject and activity
9. A new DF that is the mean of all variables for each subject and activity is created

