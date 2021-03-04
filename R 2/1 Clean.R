library(Orcs)
setwdOS(
    lin = "~/uio/", win = "M:/",
    ext = "pc/Dokumenter/MSc/Thesis/Data/"
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

# Incorporating MALE, IMMI1GEN and IMMI2GEN and ease to the database
clean <- cbind(clean[, c(1:39)], READEASE, clean[,c(40:46)])
read <- cbind(clean[, c(2:15)], FEMALE, IMMI1GEN, IMMI2GEN, clean[, c(18:47)])
head(read)
names(read)


# Remove cases whose school weights (Column 40) are NA
obs0 <- dim(read)[1]
read <- read[complete.cases(read[, 41]), ]
obs1 <- dim(read)[1]
obs0 - obs1


# Split data to 10 versions
read1 <- read[, c(1:4, 5, 15:47)]
read2 <- read[, c(1:4, 6, 15:47)]
read3 <- read[, c(1:4, 7, 15:47)]
read4 <- read[, c(1:4, 8, 15:47)]
read5 <- read[, c(1:4, 9, 15:47)]
read6 <- read[, c(1:4, 10, 15:47)]
read7 <- read[, c(1:4, 11, 15:47)]
read8 <- read[, c(1:4, 12, 15:47)]
read9 <- read[, c(1:4, 13, 15:47)]
read10 <- read[, c(1:4, 14, 15:47)]

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

