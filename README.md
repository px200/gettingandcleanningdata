# Getting and cleaning data course project
This script has been tested with R 3.2.0, with MacOS.

It extarcts means of selected variables for each subject and each activity from UCI HAR dataset. The raw data should be present in the working directory, otherwise it will be downloaded automatically from the internet.

This script creates "summary.txt" dataset with the following properties:

Training and test data are merged together.
Only the columns with "-mean()" and "-std()" strings in their names are retained.These variables represent mean and standard deviations measures for each movement trajectory.
Variable names are unique and descriptive. Original names have been modified to conform to R syntax rules (invalid characters have been replaced with "."). See ?make.names for details.
Activity labels are descriptive, and unchanged from the labels of the raw data.
Each row represents an average of selected measures (mean and standard deviations), over each subject and each activity.