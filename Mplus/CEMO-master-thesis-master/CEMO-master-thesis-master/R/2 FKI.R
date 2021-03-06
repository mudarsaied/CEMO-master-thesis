# Section 0: Housekeeping
library(Orcs) # Set working directory depending on operating system
setwdOS(
    lin = "~/uio/", win = "M:/",
    ext = "pc/Dokumenter/MSc/Thesis/Data/L3/"
)

# Set up a "bookshelf" to hold variables nessary to compute FKI
fki_raw <- matrix(NA,
    nrow = 20, ncol = 10, dimnames = list(
        c( # row names
            "BRA", "BGR", "CAN", "CHL", "EST",
            "FIN", "GEO", "IDN", "ITA", "LVA",
            "LTU", "NLD", "PER", "POL", "PRT",
            "RUS", "SRB", "SVK", "ESP", "USA"
        ),
        c( # column names
            "gdp_per_capita", # economic capability (sub_ind_ec)
            "highly_skilled", "mean_year_of_schooling", # (sub_ind_et)
            "gpea", "ica", "ius", # use (sub_ind_use)
            "pfa", "ac", "gdp", "ageing" # need (sub_ind_need)
        )
    ) # End list()
) # End matrix()


# Section 1: Economic Capacity (EC)

gdp_per_capita <- read.csv("gdp_per_capita.csv", header = T, sep = "\t")

fki_raw[, 1] <- log(gdp_per_capita[, 2])

rm(gdp_per_capita)


# Section 2: Educational Training (ET)
    # Subsection 2.1: Highly skilled
        # Masters
isced_7 <- read.csv("isced_7.csv", header = T, sep = "\t")
        # PhDs
isced_8 <- read.csv("isced_8.csv", header = T, sep = "\t")
        # Total tertiary
total_tertiary <- read.csv("total_tertiary.csv", header = T, sep = "\t")

# Compute highly skilled (master + PhD) to total tertiary ratio
highly_skilled <- ts(
    (isced_7 + isced_8) / total_tertiary,
    start = 2013, end = 2018, frequency = 1
)

# # Visualise highly_skilled. Turn off GEO (#7), IDN (#8), SRB (#17) and RUS (#16)
# pdf("../../Figures/skilled.pdf")
# ts.plot(100 * highly_skilled[, -c(7, 8, 16, 17)],
#     type = "b", col = 1:15,
#     xlab = "Year", ylab = "Percent"
# )
# legend("topright", colnames(highly_skilled[, -c(6, 7, 15, 16)]),
#     col = 1:15, lty = 1, cex = 0.65
# )
# dev.off()

# Decision: naive forcasts, i.e., copy-paste nearest available year
library(forecast)
# Create a placeholder matrix
placeholder <- matrix(NA, nrow = 20, ncol = 1)

# Run a loop to foreecast all 20 countries, using naive method
for (.i in 1:20) {
    m_naive_i <- naive(highly_skilled[, .i], h = 1)
    placeholder[.i] <- data.frame(unlist(m_naive_i[5])[6])[1, 1]
}
# [5] = fitted values; [6] = 2018; [1,1] = only the numeric value

# GEO and IDN have 2018 data, plug actual numbers back
placeholder[c(7, 8)] <- highly_skilled[6, c(7, 8)]

# RUS needs separate calculation
# ISCED 7 = 101766 (Type 1) + 170437 (Type 2) = 272203 (total masters)
# ISCED 8 = 15465 (Type 1) + 330 (Type 2) = 15795 (total PhDs)
# Total tertiary WITHOUT PhD = 933153
# => Total tertiary = 933153 + 15795 = 948948
# highly_skilled (RUS) = (272203 + 15795) / 948948 = 0.30349187
placeholder[16] <- 0.30349187

# Save results to "bookshelf"
fki_raw[, 2] <- placeholder * 100

rm(
    isced_7, isced_8, total_tertiary,
    highly_skilled, placeholder, m_naive_i
)

# Sub-section 2.2: Mean year of schooling
mean_year_of_schooling <- read.csv("mean_year_of_schooling.csv",
    header = F, sep = "\t"
)
fki_raw[, 3] <- mean_year_of_schooling[, 2]

rm(mean_year_of_schooling)


# Section 3: Use

gpea <- read.csv("gpea.csv", header = T, sep = "\t")
gpea <- ts(gpea, start = 2011, end = 2017, frequency = 1)

# # Visualise data in both original and ln forms. Contain trend?
# pdf("../../Figures/use.pdf", width = 12.94, height = 9.15)

# # Re-set canvas layout to 2x2
# par(mfcol = c(2, 2))

# # Add extra space to the right of plot area
# par(mar = c(5.1, 4.1, 4.1, 2.1), xpd = TRUE)

# # Plot GPEA in original form
# ts.plot(gpea,
#     type = "b", col = 1:20,
#     xlab = "Year", ylab = "Percent", main = "GPEA to GDP ratio"
# )

# # Remove extra gap between the two graphs
# par(mar = c(5.1, 4.1, 0, 2.1), xpd = TRUE)

# # Repeat GPEA, but for the ln() version
# ts.plot(log(gpea),
#     type = "b", col = 1:20,
#     xlab = "Year", ylab = "ln( percent )"
# )

# # Plot ICA in original form
# par(mar = c(5.1, 4.1, 4.1, 6.1), xpd = TRUE)
# ts.plot(ica,
#     type = "b", col = 1:20,
#     xlab = "Year", ylab = "Percent", main = "ICA to GDP ratio"
# )
# # Add the legend
# legend("topright",
#     inset = c(-0.2, 0), colnames(ica),
#     col = 1:20, lty = 1, cex = 0.875
# )

# # Remove extra gap between the two graphs
# par(mar = c(5.1, 4.1, 0, 6.1), xpd = TRUE)

# # Repeat, but for the ln()
# ts.plot(log(ica),
#     type = "b", col = 1:20,
#     xlab = "Year", ylab = "ln( percent )"
# )
# # Add the legend
# legend("topright",
#     inset = c(-0.2, 0), colnames(ica),
#     col = 1:20, lty = 1, cex = 1.07
# )
# dev.off()

# Decision: since the ln() version is not flat, original time series
# contain trend. Use Holt method rather than simple exponential smoothing.

# Run a time series forecast using Holt method

# Create a placeholder matrix
placeholder <- matrix(NA, nrow = 20, ncol = 1)

# Run a loop to forecast all 13 countries, using Holt method
for (.i in 1:20) {
    m_holt_i <- holt(gpea[, .i], h = 1)
    placeholder[.i] <- m_holt_i[2]
} # Ignore warnings

# Only keep the 2018 forecasts
placeholder <- unlist(placeholder)

# Run PER (#13) separately because it misses both 2017 and 2018 data
m_holt_PER <- holt(gpea[, 13], h = 2); summary(m_holt_PER)
placeholder[13] <- 16.02698

# Push placeholder to fki_raw
fki_raw[, 4] <- placeholder

rm(gpea, placeholder, m_holt_i, m_holt_PER)

# Sub-section 3.2: Insurance company assets (ica)

ica <- read.csv("ica.csv", header = T, sep = "\t")
ica <- ts(ica, start = 2011, end = 2017, frequency = 1)

placeholder <- matrix(NA, nrow = 20, ncol = 1)

for (.i in 1:20) {
    m_holt_i <- holt(ica[, .i], h = 1)
    placeholder[.i] <- m_holt_i[2]
} # Ignore warnings

placeholder <- unlist(placeholder)

m_holt_CAN <- holt(ica[, 3], h = 2); summary(m_holt_CAN)
m_holt_IND <- holt(ica[, 8], h = 2); summary(m_holt_IND)
m_holt_ITA <- holt(ica[, 9], h = 2); summary(m_holt_ITA)
m_holt_POL <- holt(ica[, 14], h = 2); summary(m_holt_POL)
m_holt_USA <- holt(ica[, 20], h = 2); summary(m_holt_USA)

placeholder[c(3, 8, 9, 14, 20)] <- c(
    77.72768, 4.611597, 51.2596, 9.534750, 30.18295
)

fki_raw[, 5] <- placeholder

rm(ica, placeholder, list = ls(pattern = "^m.holt"))

# Sub-section 3.3: Individuals using the Internet (ius)

ius <- read.csv("ius.csv", header = T, sep = "\t")
ius <- ts(ius, start = 2009, end = 2018, frequency = 1)

m_holt_CAN <- holt(ius[1:9, 3], h = 1); summary(m_holt_CAN)
m_holt_CHL <- holt(ius[1:9, 4], h = 1); summary(m_holt_CHL)
m_holt_USA <- holt(ius[1:9, 20], h = 1); summary(m_holt_USA)

ius_2018 <- ius[10, ] # Only want 2018 data
ius_2018[3] <- 93.58751 # CAN
ius_2018[4] <- 89.5309 # CHL
ius_2018[20] <- 84.88108 # USA

fki_raw[, 6] <- ius_2018

rm(list = ls(pattern = "^ius"))
rm(list = ls(pattern = "^m_holt_"))


# Section 4: Need

# Subsection 4.1: Pension fund assets (pfa)
pfa <- read.csv("pfa.csv", header = T, sep = "\t")
# Delete GEO (#7) due to all missing. Will come back to it later.
pfa <- ts(pfa[, -7], start = 2008, end = 2017, frequency = 1)

placeholder <- matrix(NA, nrow = 19, ncol = 1)

for (.i in 1:19) {
    m_holt_i <- holt(pfa[, .i], h = 1)
    placeholder[.i] <- m_holt_i[2]
}

placeholder <- unlist(placeholder)

# Calculate GEO
# From Georgia Pension Agency:
#   2019 mesub_ind_eting minute: 372,113,933 GEL
# From GeoStat website:
#   2018 gdp = 44.6 billion GEL

fki_raw[, 7] <- c(
    placeholder[1:6],
    372113934 / 44600000000 * 100, # Insert GEO figure
    placeholder[7:19]
)

rm(pfa, placeholder, m_holt_i)

# Subsection 4.2: Aggregate consumption (ac)

ac <- read.csv("ac.csv", header = F, row.names = 1, sep = "\t")
gdp <- read.csv("gdp.csv", header = F, row.names = 1, sep = "\t")

fki_raw[, 8] <- unlist(ac * 0.02 / gdp * 100)

fki_raw[, 9] <- unlist(gdp)

rm(ac, gdp)

# Subsection 4.3: Ageing

ageing <- read.csv("ageing.csv", header = T, sep = "\t")
attach(ageing)
names(ageing)

# Calculate total population
poptotal_f <- pop0to14_f + pop15to64_f + pop65plus_f
poptotal_m <- pop0to14_m + pop15to64_m + pop65plus_m
# Calculate population between 15 and 19
# Need to divide by 100 to get decimals
pop15to19_f <- poptotal_f * per15to19_f / 100
pop15to19_m <- poptotal_m * per15to19_m / 100
# Calculate population between 0 and 19
pop0to19_f <- pop0to14_f + pop15to19_f
pop0to19_m <- pop0to14_m + pop15to19_m
# Calculate population between 20 and 64
pop20to64_f <- poptotal_f - pop0to19_f - pop65plus_f
pop20to64_m <- poptotal_m - pop0to19_m - pop65plus_m
# Calculate 64+ / 20-to-64 ratio    'GEO' = 0.419;
ageing_ratio <- I(
    (pop65plus_f + pop65plus_m) / (pop20to64_f + pop20to64_m)
)
# Split data into 2018 [ , 1] and 2009 [ , 2] portions
ageing <- cbind(ageing_ratio[1:20], ageing_ratio[21:40])
fki_raw[, 10] <- (ageing[, 1] - ageing[, 2]) / ageing[, 2]

rm(ageing, ageing_ratio, list = ls(pattern = "^pop"))


# Section 5: FKI

fki_raw <- fki_raw[, -9] # Throw away gdp (already in ac)
round(fki_raw, digits = 3) # Inspect data

# Save data to an external file
library(data.table); setDTthreads(0)
fwrite(round(fki_raw, digits = 3), file = "fki_raw.csv", row.names = T)

# Subection 5.0: Standardise each variable to [0.01,0.99] range
fki_stand <- matrix(NA, nrow = dim(fki_raw)[1], ncol = dim(fki_raw)[2])
dimnames(fki_stand) <- dimnames(fki_raw)

library(scales) # I wish this function could have "by.col = T". Oh well.
for (.j in 1:dim(fki_raw)[2]) {
    fki_stand[, .j] <- rescale(fki_raw[, .j], to = c(0.01, 0.99))
}

rm(fki_raw)

fki_stand <- data.frame(fki_stand)
attach(fki_stand)

# Subsection 5.1: Economic capacity (sub_ind_ec)

sub_ind_ec <- gdp_per_capita

# Subsection 5.2: Education and training (sub_ind_et)

wt_highly_skilled <- 1 / sd(highly_skilled)
wt_mean_year_of_schooling <- 1 / sd(mean_year_of_schooling)

sub_ind_et <- (highly_skilled^wt_highly_skilled *
    mean_year_of_schooling^wt_mean_year_of_schooling)^
    (1 / (wt_highly_skilled + wt_mean_year_of_schooling))

rm(list = ls(pattern = "^wt"))

# Subsection 5.3: Use (sub_ind_use)

sub_ind_u <- (gpea + ica)^ius

# Subsection 5.4: Need (sub_ind_need)

sub_ind_n <- (pfa + ac)^ageing

## Subsection 5.5: FKI

wt_ec <- 1 / sd(sub_ind_ec)
wt_et <- 1 / sd(sub_ind_et)
wt_u <- 1 / sd(sub_ind_u)
wt_n <- 1 / sd(sub_ind_n)

fki <- (
    sub_ind_ec^wt_ec *
        sub_ind_et^wt_et *
        sub_ind_u^wt_u *
        sub_ind_n^wt_n
) ^ (
    1 / (wt_ec + wt_et + wt_u + wt_n)
)

rm(list = ls(pattern = "^wt"))

l3 <- data.frame(
    round(
        cbind(fki, sub_ind_ec, sub_ind_et, sub_ind_u, sub_ind_n),
        digits = 3
    )
)
rownames(l3) <- rownames(fki_stand)
attach(l3)

rm(fki_stand, fki, sub_ind_ec, sub_ind_et, sub_ind_u, sub_ind_n)

# Display country-level FKI, default by country code
l3

# Sort FKI by country (highest to lowest)
l3_ordered <- l3[order(-fki), ]
l3_ordered
fwrite(l3_ordered, file = "fki.csv", row.names = T)

pdf("../../Figures/FKI.pdf")
    barplot(l3_ordered$fki,
        names.arg = rownames(l3_ordered),
        xlab = "Country", las = 2, ylab = "Financial Knowledge Index (FKI)",
        ylim = c(0, 1), main = "FKI of 20 participating countries"
    )
dev.off()
