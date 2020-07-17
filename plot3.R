# Data to use are for 1999, 2002, 2005, and 2008

# Two files
	# PM2.5 emissions data - summarySCC_PM25.rds
		# contains all emissions data for the necessary years
	# Source Classification Code Table - Source_Classification_Code.rds
		# mapping from SCC digit in emissions table to actual name of pm2.5 source

# Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer this question.

library(ggplot2)

# Exploration
str(NEI)
summary(NEI)

str(SCC)
summary(SCC)

# Subset data
baltimore <- subset(NEI, fips == "24510")

balt_type <- as.data.frame(tapply(baltimore$Emissions, list(baltimore$year, baltimore$type), FUN=sum))
balt_type$Year <- rownames(balt_type)
library(reshape2)
melted_balt <- melt(balt_type, id.vars=5)

#open graphic device to save
png('plot3.png')

# construct plot
g <- ggplot(data = melted_balt, aes(x = Year, y = value, fill = Year)) 
g + geom_bar(stat = "identity") + 
facet_grid(. ~ variable) +
ylab("Total PM2.5 Emissions (in tons)") + 
ggtitle("Total PM2.5 Emissions in Baltimore, Maryland")

#save plot to png
dev.off()
