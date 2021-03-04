library(Orcs)
setwdOS(
    lin = "~/", win = Sys.getenv("USERPROFILE")
)

library(data.table)
setDTthreads(0)
ict <- fread("ict.dat", header = T, sep = "\t", na = "NA")
names(ict)
clean <- ict[, -c(5, 7:96, 107:176)]

head(clean)
dim(clean)

library(car)

# Recode ST004D01T to MALE
FEMALE <- recode(clean$ST004D01T, "
    1 = 1;
    2 = 0
")

# Recode IMMIG to 1st and 2nd generation
IMMI1GEN <- recode(clean$IMMIG, "
    1 = 0;
    2 = 0;
    3 = 1
")
IMMI2GEN <- recode(clean$IMMIG, "
    1 = 0;
    2 = 1;
    3 = 0
")

#Reverse Difficulty to ease
READEASE <- (clean$SCREADDIFF)*-1

names(clean)
# Incorporating MALE, IMMI1GEN and IMMI2GEN and ease to the database
clean <- cbind(clean[, c(1:49)],READEASE, clean[,c(50:57)])
read <- cbind(clean[, c(2:15)], FEMALE, IMMI1GEN, IMMI2GEN, clean[, c(18,
    35:46,26, 47,48, 50, 51, 56
)])

head(read)
dim(read)
# Complete case
dim(read[complete.cases(read), ])

# inspection <- cbind(read$CNTSCHID, read$SC156Q05HA)
# head(inspection,100)
# names(read)
# #Check if there is NA cases in schools weights
# table(read[,41])
# sum(is.na(read$W_FSTUWT_SCH_SUM))

# Write "clean" dat file

fwrite(read,
    file = "readallpv.dat",
    sep = ",", row.names = F, col.names = F, na = "-99"
)

names(read)

# Remove cases whose school weights (Column 40) are NA
obs0 <- dim(read)[1]
read <- read[complete.cases(read[, 41]), ]
obs1 <- dim(read)[1]
obs0 - obs1


# Split data to 10 versions
read1 <- read[, c(1:4, 5, 15:36)]
read2 <- read[, c(1:4, 6, 15:36)]
read3 <- read[, c(1:4, 7, 15:36)]
read4 <- read[, c(1:4, 8, 15:36)]
read5 <- read[, c(1:4, 9, 15:36)]
read6 <- read[, c(1:4, 10, 15:36)]
read7 <- read[, c(1:4, 11, 15:36)]
read8 <- read[, c(1:4, 12, 15:36)]
read9 <- read[, c(1:4, 13, 15:36)]
read10 <- read[, c(1:4, 14, 15:36)]

# Use the correct end-of-line marker depending on the operating system
switch(Sys.info()[["sysname"]],
    Linux = {
        EOL <- "\r\n"
    },
    Windows = {
        EOL <- "\n"
    }
)

# Save data to Mplus-ready format
write.table(read1, "read1.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read2, "read2.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read3, "read3.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read4, "read4.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read5, "read5.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read6, "read6.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read7, "read7.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read8, "read8.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read9, "read9.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

write.table(read10, "read10.dat",
    na = "-99", sep = ",", row.names = F, col.names = F, eol = EOL
)

