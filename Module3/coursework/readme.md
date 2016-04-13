Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Load the activity,subject, feature info, training and test data. 
3. Merge training and test data.
4. Extract Avg and Std columns from the merged data set.
5. Assign column names to activity, subject and merged training-test data sets
6. Merge activity,subject and training-test data sets.
7. Summarise by activity, subject and calculate averages.
8. Save to file; create new folder merged and save file X_summary.txt
