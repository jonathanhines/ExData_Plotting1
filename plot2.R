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

png(file = "plot2.png")
plot(d$Time, d$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab = "" )
dev.off()