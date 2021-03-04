# This file is NOT about performing multilevel multiple imputation (MMI).
# MMI should be performed in Mplus.
# This file continues with the clean up process.


# Housekeeping
setwd("C:/Users/Mudar Saied")

# Import data
library(data.table); setDTthreads(0)
# Import imputation No.1
read_mmi_1 <- fread("Read_MMI_1.dat")
# Add header to data
# I copy-pasted this list from Mplus output file, hence the vertical layout.
names(read_mmi_1) <- c(
    "Q05HA",
    "PV1READ",
    "PV2READ",
    "PV3READ",
    "PV4READ",
    "PV5READ",
    "PV6READ",
    "PV7READ",
    "PV8READ",
    "PV9READ",
    "PV10READ",
    "FEMALE",
    "IMMI1GEN",
    "IMMI2GEN",
    "ESCS",
    "Q3",
    "Q4",
    "Q5",
    "Q7",
    "Q8",
    "Q9",
    "Q10",
    "Q1",
    "Q2",
    "Q6",
    "LEIHOM",
    "USESCH",
    "ACAHOM",
    "READJOY",
    "READCOMP",
    "READEASE",
    "CNTRYID",
    "CNTSTUID",
    "W_STU",
    "W_SCH",
    "CNTSCHID"
)
# Inspect data
head(read_mmi_1); dim(read_mmi_1)

# Rearrange data
names(read_mmi_1)
readimp1 <- read_mmi_1[, c(32, 36, 33, 34, 2, 12:25, 28, 27, 26, 29:31, 35, 1)]
head(readimp1); dim(readimp1)

# Now I am happy. I can apply the same procedure to all 10 versions

read_mmi_2 <- fread("Read_MMI_2.dat")
names(read_mmi_10) <- names(read_mmi_1) # Give version # a heading
read_mmi_3 <- fread("Read_MMI_3.dat")
read_mmi_4 <- fread("Read_MMI_4.dat")
read_mmi_5 <- fread("Read_MMI_5.dat")
read_mmi_6 <- fread("Read_MMI_6.dat")
read_mmi_7 <- fread("Read_MMI_7.dat")
read_mmi_8 <- fread("Read_MMI_8.dat")
read_mmi_9 <- fread("Read_MMI_9.dat")
read_mmi_10 <- fread("Read_MMI_10.dat")
names(finlit_mmi_10) <- names(finlit_mmi_1) # Give version 10 a heading

readimp2 <- read_mmi_2[, c(32, 36, 33, 34, 3, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp3 <- read_mmi_3[, c(32, 36, 33, 34, 4, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp4 <- read_mmi_4[, c(32, 36, 33, 34, 5, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp5 <- read_mmi_5[, c(32, 36, 33, 34, 6, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp6 <- read_mmi_6[, c(32, 36, 33, 34, 7, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp7 <- read_mmi_7[, c(32, 36, 33, 34, 8, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp8 <- read_mmi_8[, c(32, 36, 33, 34, 9, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp9 <- read_mmi_9[, c(32, 36, 33, 34, 10, 12:25, 28, 27, 26, 29:31, 35, 1)]
readimp10 <- read_mmi_10[, c(32, 36, 33, 34, 11, 12:25, 28, 27, 26, 29:31, 35, 1)]

head(readimp2); head(readimp10) # Inspect version 2 and 10 to make sure they make sense

# Save these clean data sets to the Data folder
#setwdOS(lin = "~/uio", win = "M:/", ext = "pc/Dokumenter/MSc/Thesis/Data/Mplus/")

# Use the correct end-of-line marker depending on the operating system
switch(Sys.info()[["sysname"]],
    Linux = {EOL = "\r\n"},
    Windows = {EOL = "\n"}
)

write.table(readimp1, "read1.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp2,
    "read2.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp3,
    "read3.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp4,
    "read4.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp5,
    "read5.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp6,
    "read6.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp7,
    "read7.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp8,
    "read8.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp9,
    "read9.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)

write.table(readimp10,
    "read10.dat",
    row.names = F, col.names = F,
    sep= ",", eol = EOL
)
