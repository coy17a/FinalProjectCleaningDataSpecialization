# FinalProjectCleaningDataJH


# ReadMe Final Project -Getting and Cleaning Data

## The Task : 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The first step is to load all the libraries needed  and the files load to data frames using read_delim()  function from the reader package


    trainx <- read_delim("./train/X_Train.txt", delim = " ", col_names = FALSE)
    trainy <- read_delim("./train/Y_Train.txt", delim = " ", col_names = FALSE)
    subject_train <-read_delim("./train/subject_train.txt", delim = " ", col_names = FALSE)
    testx <- read_delim("./test/X_Test.txt", delim = " ", col_names = FALSE)
    testy <- read_delim("./test/Y_Test.txt", delim = " ", col_names = FALSE)
    subject_test <-read_delim("./test/subject_test.txt", delim = " ", col_names = FALSE)
    features <- read_delim("features.txt",delim = " ",col_names = FALSE).  
    activities <-  read_delim("activity_labels.txt",delim = " ",col_names = FALSE)


### Merges the training and the test sets to create one data set.

The train and test data is join to a data-frame called df. Similarly the subjects and training label are joined. The last line slow us to change the training label based on the activity name file provided. Leaving us with three data frames: 

    df <- rbind(trainx,testx)
    subjects <- rbind(subject_train,subject_test)
    trainingLabels <- rbind(trainy,testy)
    trainingLabels <- sapply(trainingLabels$X1, function(x) activities$X2[x])


###Extracts only the measurements on the mean and standard deviation for each measurement.

The selection of the columns is achieved using regular expressions for mean() and std(). Using grep the result is index of the features where mean and std are present. After that we select the columns based on the index obtained. Finally the selection is done for the features using the same vector obtaining the names for the columns in the joined data-frame 

    #meand and std selection
    selection1 <-  grep("mean()",features$X2)
    selection2 <- grep("std()",features$X2)
    selection <- sort(c(selection1,selection2))
   df <- df[,selection]
   features <- features[selection,]

    #name columns in trainx
    names(df) <- features$X2

    #join the activities and subject information and label variables
    df<- df %>%
    mutate(Activity = trainingLabels,Subjects_Number= subjects$X1)


### Uses descriptive activity names to name the activities in the data set

The names of the activity was obtained early with the line of code : 

    trainingLabels <- sapply(trainingLabels$X1, function(x) activities$X2[x])

### Appropriately labels the data set with descriptive variable names.

The name of the columns are obtained using the same vector obtained from the previous filter using regular expression. Then the columns are named using the names() function


    features <- features[selection,]
    #name columns in trainee
    names(df) <- features$X2

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In order to calculate the mean of each variable for each activity and subject the df is group by these two variables and using the summarise_all() function the mean can be calculated


    #tidy data 
    df <- df%>%
    mutate_at(1:79, as.numeric)
    tidydf <- df %>%
    group_by(Subjects_Number,Activity)%>%
    summarise_all(funs(mean))

However to obtain a tidy data set we should spread the subjects. This is achieved by gather the date by all the variables in one column and then spread the subjects 


    tidydf <- gather (tidydf,features$X2,key="Measurements",value="mean")
    tidydf <- spread (tidydf,Subjects_Number,mean)


Finally the data frames product of this project are saved as csv files:

 
    #wirte the df to files
    write.csv(features$X2, file = "newFeatures.csv")
    write.csv(tidydf, file = "tidy.csv")
    write.csv(tidydf, file = “df.csv")









