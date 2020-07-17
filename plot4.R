# Data to use are for 1999, 2002, 2005, and 2008

# Two files
	# PM2.5 emissions data - summarySCC_PM25.rds
		# contains all emissions data for the necessary years
	# Source Classification Code Table - Source_Classification_Code.rds
		# mapping from SCC digit in emissions table to actual name of pm2.5 source

# Read in the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Across the United States, how have emissions from 
#coal combustion-related sources changed from 1999–2008?

library(ggplot2)

# Exploration
str(NEI)
summary(NEI)

str(SCC)
summary(SCC)
head(SCC)
names(SCC)

#subset SCC data to include SCC column (first column) that are for coal emissions
SCC_coal_comb <- grepl("comb.*coal|coal.*comb", SCC$Short.Name, ignore.case=TRUE)
SCC_subset <- SCC[SCC_coal_comb,]

# Subset NEI data by SCC codes

NEI_coal_comb <- NEI[NEI$SCC %in% SCC_subset$SCC,]

#sum total data
NEI_cc_sum <- as.data.frame(tapply(NEI_coal_comb$Emissions, NEI_coal_comb$year, FUN = sum))
colnames(NEI_cc_sum) <- "Sum"
NEI_cc_sum$Year <- row.names(NEI_cc_sum)
rownames(NEI_cc_sum) <- 1:nrow(NEI_cc_sum)

#open graphic device to save
png('plot4.png')

# construct total coal combustion plot
ggplot(data = NEI_cc_sum, aes(x = Year, y = Sum)) + geom_bar(stat = "identity", fill = rgb(0.3, 0.8, 0.3,.4)) +
ylab("Total PM2.5 Emissions (in tons)") + 
ggtitle("Total Coal Combustion Emissions in the US") + 
geom_text(aes(label = round(Sum, 2)), vjust = 1, color = "darkblue", size = 4.5)

#save plot to png
dev.off()

