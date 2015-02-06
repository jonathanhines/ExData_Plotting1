# If the source isn't downloaded yet go get it and download it
if (!file.exists("exdata_data_household_power_consumption")) {
    if( OS.type == "windows" ) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "project.zip", mode="wb")
    } else {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "project.zip", method="curl")
    }
    write(date(), file="dateDownloaded.txt")
    unzip("project.zip")
    unlink("project.zip")
}

# Check to see if the data is already loaded.  If not load it.
if(!exists("d")) {
    d <- read.table(
        "exdata_data_household_power_consumption//household_power_consumption.txt",
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

png(file = "plot1.png")
hist(d$Global_active_power, main="Global Active Power",xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()