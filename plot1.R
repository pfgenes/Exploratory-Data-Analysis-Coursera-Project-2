# Data to use are for 1999, 2002, 2005, and 2008

# Two files
	# PM2.5 emissions data - summarySCC_PM25.rds
		# contains all emissions data for the necessary years
	# Source Classification Code Table - Source_Classification_Code.rds
		# mapping from SCC digit in emissions table to actual name of pm2.5 source

# Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from 
#all sources for each of the years 1999, 2002, 2005, and 2008.

# Exploration
str(NEI)
summary(NEI)

str(SCC)
summary(SCC)

# Subset and sum data
pm1999sum <- sum(subset(NEI, year == 1999)$Emissions)
pm2002sum <- sum(subset(NEI, year == 2002)$Emissions)
pm2005sum <- sum(subset(NEI, year == 2005)$Emissions)
pm2008sum <- sum(subset(NEI, year == 2008)$Emissions)
pmsum <- data.frame(c(1999,2002,2005,2008),c(pm1999sum,pm2002sum, pm2005sum,pm2008sum))
colnames(pmsum) <- c("Year","Total_Pollution")

#open graphic device to save
png('plot1.png')

# construct plot
barplot(pmsum$Total_Pollution, names.arg = c(1999, 2002, 2005, 2008), xlab = "Year", ylab = "Total PM2.5 Pollution (in Tons)",  main = "Total PM2.5 Emissions in the US")

#save plot to png
dev.off()
