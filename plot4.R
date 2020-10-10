#Coursera - Exploratory Data Analysis - Course Project 1
#by Patrick David H. Arboleda
#created: October 11, 2020
#plot4.R

dataDir <- "_data"
plotDir <- "_plots"
zipname <- "exdata_data_household_power_consumption.zip"
data_name<- "household_power_consumption.txt"

#----data directory----
if(!file.exists(dataDir)){			#creates data directory if does not exist
	dir.create(file.path(dataDir))
	}

setwd(file.path(dataDir))

#----Raw Data Extraction----
#download the zip file
if(!file.exists(zipname)){
	download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
				destfile = zipname,
				method = "curl"
				)

	retrieval_date <- Sys.Date()		#saves the date the data is extracted		
}

if(!file.exists(data_name)){
	unzip (zipname, exdir = ".")		#unzips downloaded file
}

#read in the data
tmp <- read.table(file = data_name,
					sep = ";",
					header = TRUE,
					na.strings = "?",
					colClasses = c(rep("character", 2), rep("numeric", 7))
					)

#------Data Processing--------
whole_data <- data.frame(tmp)
#create a column with combined date and time
whole_data[,"abs_time"] <- paste(whole_data$Date, whole_data$Time, sep = " ")
whole_data$abs_time <- strptime(whole_data$abs_time, format = "%d/%m/%Y %H:%M:%S")

#extract rows with 2007-02-01 until 2007-02-02 as date
lower_bound <- strptime("2007-02-01", format = "%Y-%m-%d")
upper_bound <- strptime("2007-02-03", format = "%Y-%m-%d")
plot_data <- subset(whole_data,
					lower_bound<=abs_time & abs_time<upper_bound,
					select = c(3:5,7:10)
					)
#==============================

#----plot directory----
if(!file.exists(file.path("..",plotDir))){			#creates plot directory if does not exist
	dir.create(file.path("..",plotDir))
	}

setwd(file.path("..",plotDir))

#----plot4.R----
png(filename = "plot4.png",
	width = 480,
	height = 480,
	units = "px",
	bg = "transparent"
	)
	
# 4 graphs on 1 image
par(mfcol=c(2,2))

#upper left plot
plot(plot_data$abs_time, plot_data$Global_active_power,
		type = "l",
		xlab = "",
		ylab = "Global Active Power (kilowatts)"
		)

#lower left plot
plot(plot_data$abs_time, plot_data$Sub_metering_1,
		type = "l",
		xlab = "",
		ylab = "Energy sub metering",
		col = "black"
		)
		
lines(plot_data$abs_time, plot_data$Sub_metering_2,
		type = "l",
		col = "red"
		)
		
lines(plot_data$abs_time, plot_data$Sub_metering_3,
		type = "l",
		col = "blue"
		)

legend(x = "topright",
		legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
		lty = c(1,1,1),
		col = c("black", "red", "blue")
		)

#upper right plot
plot(plot_data$abs_time, plot_data$Voltage,
			type = "l",
			col = "black",
			xlab = "datetime",
			ylab = "Voltage",
			)
			
#lower right plot
plot(plot_data$abs_time, plot_data$Global_reactive_power,
			type = "l",
			col = "black",
			xlab = "datetime",
			ylab = "Global_reactive_power"
			)
		
dev.off()
setwd("..")