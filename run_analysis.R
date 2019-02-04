library(readr)
library(dplyr)
library(tidyr)
library(purrr)


trainx <- read_delim("./Original_DataSet/train/X_Train.txt", delim = " ", col_names = FALSE)
trainy <- read_delim("./Original_DataSet/train/Y_Train.txt", delim = " ", col_names = FALSE)
subject_train <-read_delim("./Original_DataSet/train/subject_train.txt", delim = " ", col_names = FALSE)
testx <- read_delim("./Original_DataSet/test/X_Test.txt", delim = " ", col_names = FALSE)
testy <- read_delim("./Original_DataSet/test/Y_Test.txt", delim = " ", col_names = FALSE)
subject_test <-read_delim("./Original_DataSet/test/subject_test.txt", delim = " ", col_names = FALSE)
features <- read_delim("./Original_DataSet/features.txt",delim = " ",col_names = FALSE)
activities <-  read_delim("./Original_DataSet/activity_labels.txt",delim = " ",col_names = FALSE)

#join the train and test df
df <- rbind(trainx,testx)
subjects <- rbind(subject_train,subject_test)
trainingLabels <- rbind(trainy,testy)
#change the name of activities

trainingLabels <- sapply(trainingLabels$X1, function(x) activities$X2[x])

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
#tidy data 
df <- df%>%
  mutate_at(1:79, as.numeric)
tidydf <- df %>%
    group_by(Subjects_Number,Activity)%>%
    summarise_all(funs(mean))
#tidydf <- spread(tidyf,Subjects_Number,)
tidydf <- gather (tidydf,features$X2,key="Measurements",value="mean")
tidydf <- spread (tidydf,Measurements,mean)

#wirte the df to files
write.csv(features$X2, file = "./newDataSets/newFeatures.csv")
write.csv(tidydf, file = "./newDataSets/tidy.csv")
write.csv(tidydf, file = "./newDataSets/df.csv")
write.table(tidydf, file = "./newDataSets/tidy.txt", row.names = FALSE)


