# Load the required packages
library(lubridate)

# Download and unzip the data file
Download.Date <- Sys.Date() # "2019-05-19"

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "dat.zip", method = "curl")
unzip(zipfile = "dat.zip", exdir = "./data")

# Load the data and convert Date column format

dat <- read.table("data/household_power_consumption.txt", header = TRUE, sep = ";")
head(dat)

dat$Date <- dmy(dat$Date)
head(dat)

# subset the data frame to include only 2007-02-01 and 2007-02-02

df1 <- as.data.frame(dat[which(dat$Date >= as.Date("2007-02-01") & dat$Date <= as.Date("2007-02-02")), ])
head(df1)    
tail(df1)    

# Make a new vector combining the date and time called Day and then make a new data frame containing columns 3 to 9

Day <- with(df1, ymd(Date) + hms(Time))
head(Day)

df2 <- as.data.frame(cbind(Day, df1[,3:9]))
head(df2)

# coerce variables to numeric

df2[,2:7] <- lapply(df2[,2:7], as.character)
df2[,2:7] <- lapply(df2[,2:7], as.numeric)
head(df2)

# Plot 4: Multiplot

png(filename = "plot4.png", 
    width = 480, height = 480)
par(mfrow=c(2,2))

# Global active power

plot(x = df2$Day, y = df2$Global_active_power, type = "l",
     ylab = " Global Active Power (kilowatts)", xlab = "")

# Voltage

plot(x = df2$Day, y = df2$Voltage, type = "l",
     ylab = "Voltage", xlab = "")

# Submetering

plot(x = df2$Day, y = df2$Sub_metering_1, type = "l", ylim = c(0, 40),
     ylab = "Energy sub metering", xlab = "")
lines(x = df2$Day, y = df2$Sub_metering_2, type = "l", col = "red")
lines(x = df2$Day, y = df2$Sub_metering_3, type = "l", col = "blue")     
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1)

# Global reactive power

plot(x = df2$Day, y = df2$Global_reactive_power, type = "l",
     ylab = "Global reactive power", xlab = "")

dev.off()

