# Data to use are for 1999, 2002, 2005, and 2008

# Two files
	# PM2.5 emissions data - summarySCC_PM25.rds
		# contains all emissions data for the necessary years
	# Source Classification Code Table - Source_Classification_Code.rds
		# mapping from SCC digit in emissions table to actual name of pm2.5 source

# Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Compare emissions from motor vehicle sources in Baltimore City with emissions from 
#motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

library(ggplot2)

# Exploration
str(NEI)
summary(NEI)

str(SCC)
summary(SCC)
head(SCC)
names(SCC)
# subset to only include Baltimore City and LA
baltimore <- subset(NEI, fips == "24510")
LA <- subset(NEI, fips == "06037")

#Change SCC.Level.Two to character
SCC$SCC.Level.Two <- as.character(SCC$SCC.Level.Two)

#subset SCC data to be only those that include vehicle

SCC_vehicle<- grepl("[Vv]ehicle", SCC$SCC.Level.Two, ignore.case = TRUE)
SCC_vehicle <- SCC[SCC_vehicle,]$SCC

# Subset baltimore and LA data by SCC codes

balt_vehicle <- baltimore[baltimore$SCC %in% SCC_vehicle,]
LA_vehicle <- LA[LA$SCC %in% SCC_vehicle,]

#sum total data
balt_vehicle_sum <- as.data.frame(tapply(balt_vehicle$Emissions,balt_vehicle$year, FUN = sum))
colnames(balt_vehicle_sum) <- "Sum"
balt_vehicle_sum$Year <- row.names(balt_vehicle_sum)
rownames(balt_vehicle_sum) <- 1:nrow(balt_vehicle_sum)

LA_vehicle_sum <- as.data.frame(tapply(LA_vehicle$Emissions,LA_vehicle$year, FUN = sum))
colnames(LA_vehicle_sum) <- "Sum"
LA_vehicle_sum$Year <- row.names(LA_vehicle_sum)
rownames(LA_vehicle_sum) <- 1:nrow(LA_vehicle_sum)

#Bind the two data sets
vehicle_bind <- rbind.data.frame(LA_vehicle_sum,balt_vehicle_sum)
vehicle_bind <- cbind.data.frame(vehicle_bind, City = c("LA","LA","LA","LA","BAL","BAL","BAL","BAL"))

#open graphic device to save
png('plot6.png')

# construct motor vehicle plot
ggplot(data = vehicle_bind, aes(x = factor(Year), y = Sum))+
geom_bar(stat = "identity", fill = rgb(0.3, 0.8, 0.3,.4)) + 
ylab("Total PM2.5 emissions (in tons)") +
xlab("Year")+
facet_wrap(~City)+
ggtitle("Total Emissions From Motor Vehicles in Baltimore vs. LA")+
geom_text(aes(label = round(Sum, 2)), vjust = 1, color = "darkblue", size = 3.5) 

#save plot to png
dev.off()

############
