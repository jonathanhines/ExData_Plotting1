# If the source isn't downloaded yet go get it and download it
if (!file.exists("household_power_consumption.txt")) {
    if( .Platform$OS.type == "windows" ) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "project.zip", mode="wb")
        unzip("project.zip")
        unlink("project.zip")
        file.rename("./exdata_data_household_power_consumption//household_power_consumption.txt", "./household_power_consumption.txt")
    } else {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "project.zip", method="curl")
        unzip("project.zip")
        unlink("project.zip")
    }
    write(date(), file="dateDownloaded.txt")
}

# Check to see if the data is already loaded.  If not load it.
if(!exists("d")) {
    d <- read.table(
        "household_power_consumption.txt",
        na.strings = ("?"),
        nrow = 24*60*2,
        col.names = c( "Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
        sep = ";",
        colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),
        skip = 66637
    )
    d$Time <- strptime(paste(d$Date,d$Time),"%d/%m/%Y %H:%M:%S")
    d$Date <- as.Date(d$Date, "%d/%m/%Y")
}
# xaxis_ticks <- seq(as.POSIXct("2007/02/01"),as.POSIXct("2007/02/03"),"days")

png(file = "plot4.png")

# Set up to run a grid of plots (store the old default first so that we can put it back the way we found it)
old_mfrow <- par("mfrow")
par("mfrow"=c(2,2))

# cell 1
plot(d$Time, d$Global_active_power, type="l", ylab = "Global Active Power", xlab = "" )

# cell 2
plot(d$Time, d$Voltage, type="l", ylab = "Voltage", xlab = "datetime" )

# cell 3
plot(d$Time, d$Sub_metering_1, type="l", ylab = "Energy sub metering", xlab = "" )
points(d$Time, d$Sub_metering_2, type="l", col = "red")
points(d$Time, d$Sub_metering_3, type="l", col = "blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lwd=1,col=c("black","red","blue"), bty="n")

#cell 4
plot(d$Time, d$Global_reactive_power, type="l", ylab = "Global_reactive_power", xlab = "datetime" )

# Close the png device so that we can view the new image file
dev.off()

# Clean up and return default value
par("mfrow"=old_mfrow)
rm(old_mfrow)