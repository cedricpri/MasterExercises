#Code written by Cedric Prieels (Workshop006)
library(ORE)

# Let's use the ORE library to connect to the database to avoid writing sql queries
ore.connect(user = "ruser", host = "130.61.215.115",
            password = "ruser",
            service_name = "pdb1.sub12041412512.bdcevcn.oraclevcn.com",all=TRUE) 

# List all tables
ore.ls()

df <- ONTIME_S
dim(df)
head(df, 20) #Let's print the first 20 results

#We now need to aggregate the data to count the number of flights per destination using our dataframe
aggdf <- aggregate(ONTIME_S$DEST, 
                     by = list(ONTIME_S$DEST), 
                     FUN = length) #Apply the length function to count the flights
head(aggdf, 20)

#Calculate the standard deviation of the arrival delay for each airline and destination
aggdf2 <- aggregate(ONTIME_S$ARRDELAY, 
                   by = list(ONTIME_S$DEST, ONTIME_S$UNIQUECARRIER), 
                   FUN = sd, na.rm=TRUE) #Apply the length function to count the flights
head(aggdf2, 20) 

#Linear regression to calculate the arrival delay
linReg <- ore.lm(ARRDELAY ~ DISTANCE + DEPDELAY, ONTIME_S)
summary(linReg)

#Linear model to predict the delay on arrival by using group apply
model <- ore.groupApply(
  X=ONTIME_S,
  INDEX = ONTIME_S$DEST,
  function(data) {
    lm(ARRDELAY ~ DISTANCE + DEPDELAY, data)
  });

modelLocal <- ore.pull(model)
summary(modelLocal$BOS) #Use our model

#Do a scoring for the arrival delay using the predict function
prediction <- ore.predict(linReg, data = ONTIME_S, interval = "confidence")
head(prediction, 20)

#Demonstrate the results using graphics (let's only plot some data in order to see it better)
reduceddf <- head(df, 1000)
plot(reduceddf$DISTANCE + reduceddf$DEPDELAY, reduceddf$ARRDELAY, pch=16, cex=0.4, main="Arrival delay with respect to the distance and departure delay of a flight", xlab="Distance and departure delay", ylab="Arrival delay")
abline(linReg, col="red", lwd=2)

#Execute our code on the server instead of the client with a distinct function name to avoid conflicts
ore.scriptDrop("workshop006")
output <- ore.scriptCreate("workshop006", model)
output #A NULL value means that everything went fine, according to the documentation: https://docs.oracle.com/cd/E11882_01/doc.112/e36761/scripts.htm#CIHIBEGD

#Disconnet the database
ore.disconnect()
