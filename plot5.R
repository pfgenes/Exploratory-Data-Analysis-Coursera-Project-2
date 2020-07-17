# Data to use are for 1999, 2002, 2005, and 2008

# Two files
	# PM2.5 emissions data - summarySCC_PM25.rds
		# contains all emissions data for the necessary years
	# Source Classification Code Table - Source_Classification_Code.rds
		# mapping from SCC digit in emissions table to actual name of pm2.5 source

# Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(ggplot2)

# Exploration
str(NEI)
summary(NEI)

str(SCC)
summary(SCC)
head(SCC)
names(SCC)
# subset to only include Baltimore City
baltimore <- subset(NEI, fips == "24510")

#Change SCC.Level.Two to character
SCC$SCC.Level.Two <- as.character(SCC$SCC.Level.Two)

#subset SCC data to be only those that include vehicle

SCC_vehicle<- grepl("[Vv]ehicle", SCC$SCC.Level.Two, ignore.case = TRUE)
SCC_vehicle <- SCC[SCC_vehicle,]$SCC

# Subset NEI data by SCC codes

balt_vehicle <- baltimore[baltimore$SCC %in% SCC_vehicle,]

#sum total data
balt_vehicle_sum <- as.data.frame(tapply(balt_vehicle$Emissions,balt_vehicle$year, FUN = sum))
colnames(balt_vehicle_sum) <- "Sum"
balt_vehicle_sum$Year <- row.names(balt_vehicle_sum)
rownames(balt_vehicle_sum) <- 1:nrow(balt_vehicle_sum)

#open graphic device to save
png('plot5.png')

# construct motor vehicle plot
g <- ggplot(data = balt_vehicle_sum, aes(x = factor(Year), y = Sum))
g + geom_bar(stat = "identity", fill = rgb(0.3, 0.8, 0.3,.4)) + 
ylab("Total PM2.5 emissions (in tons)") +
xlab("Year")+
ggtitle("Total Emissions From Motor Vehicles in Baltimore, Maryland")+
geom_text(aes(label = round(Sum, 2)), vjust = 2, color = "darkblue", size = 4.5) 


#save plot to png
dev.off()

############
