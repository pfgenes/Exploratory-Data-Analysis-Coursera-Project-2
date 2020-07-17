# Data to use are for 1999, 2002, 2005, and 2008

# Two files
	# PM2.5 emissions data - summarySCC_PM25.rds
		# contains all emissions data for the necessary years
	# Source Classification Code Table - Source_Classification_Code.rds
		# mapping from SCC digit in emissions table to actual name of pm2.5 source

# Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
#from 1999 to 2008? 
#Use the base plotting system to make a plot answering this question

# Exploration
str(NEI)
summary(NEI)

str(SCC)
summary(SCC)

# Subset and sum data
baltimore <- subset(NEI, fips == "24510")
balt1999sum <- sum(subset(baltimore , year == 1999)$Emissions)
balt2002sum <- sum(subset(baltimore , year == 2002)$Emissions)
balt2005sum <- sum(subset(baltimore , year == 2005)$Emissions)
balt2008sum <- sum(subset(baltimore , year == 2008)$Emissions)
baltsum <- data.frame(c(1999,2002,2005,2008),c(balt1999sum ,balt2002sum, balt2005sum,balt2008sum))
colnames(baltsum) <- c("Year","Total_Pollution")

#open graphic device to save
png('plot2.png')

# construct plot
barplot(baltsum$Total_Pollution, names.arg = c(1999, 2002, 2005, 2008), xlab = "Year", ylab = "Total PM2.5 Pollution (in Tons)",  main = "Total PM2.5 Emissions in Baltimore, Maryland")

#save plot to png
dev.off()
