# 2 tables: 1. Reservations of last 2 years (5000+ obs), 2. Guests
# Guest phone numbers, emails, countries are needed for all guests in Reservations, 
# where all is empty in the beginning.
# Only key is reservation ID and it is in only Reservations table.
# No key in Guests table: Even no Guest_ID exist.

#Use "xlsx" package
library(xlsx)

# In both tables, Clean the first and last names from the whitespaces before and after the names
library(stringr)
reservations <- read.xlsx("Eviivo res as of 20 oct 2017.xlsx", 1, colIndex = c(6,7), startRow = 3)
fnames <- str_trim(reservations[,1])
lnames <- str_trim(reservations[,2])
resnames <- cbind(fnames, lnames)

guest1 <- read.xlsx("Commercial Guests_AsOf_2017.Oct.20.xlsx", 1, colIndex = c(2,3,6,7,11), startRow = 8)
gfname <- str_trim(guest1[,1])
glname <- str_trim(guest1[,2])
guest2 <- as.data.frame(cbind(gfname, glname, as.character(guest1[,3]), as.character(guest1[,4]), as.character(guest1[,5])))
colnames(guest2) <- c("First_Name", "Last_Name", "Email", "Phone", "Country")

# Check for each guest in Reservations whether s/he exists in Guests table.
# If no phone number exists, assign the phone number as "1234"
phones <- as.vector(NULL)
emails <- as.vector(NULL)
countries <- as.vector(NULL)
for (i in 1:nrow(resnames)){
  checking <- which(guest2$First_Name==as.character(resnames[i,1]) & guest2$Last_Name==as.character(resnames[i,2]))
  if(length(checking)==0) {
    phones[i] <- as.character(1234)
    emails[i] <- as.character("no_email")
    countries[i] <- as.character("no_country")
  } else {
      phones[i] <- as.character(guest2[checking[1], 4])
      emails[i] <- as.character(guest2[checking[1], 3])
      countries[i] <- as.character(guest2[checking[1], 5])
  }
}

# Create a data frame including all guests in the system and their respective phone numbers
resphone <- as.data.frame(cbind(resnames, phones, emails, countries))
resphone

# Write it to an xlsx file you like!