
library(psych)
library(GPArotation)

library(data.table)

setwd (Sys.getenv("USERPROFILE")
)

read <- fread("read2.dat", header = T, sep = ",", na = "NA")
USESCH <- read[, c(10:19)]

P <- 10

Rmatrix <- cor(USESCH[,1:P])

names(USESCH) <- c("Q3","Q4", "Q5", "Q7","Q8", "Q9", "Q10", "Q1", "Q2", "Q6")

(modelpca <- principal(r = Rmatrix, nfactor = 2, rotate = "none", fm = "ml"))

fa.diagram(modelpca, nfactor = 2, simple = F)


fa.parallel(USESCH,fa = "fa", fm = "ml")

(scree_parallel <- fa.parallel(x = Rmatrix, n.obs= 18809, fm= "pa"))
 
(efamodel1 <-fa (r = Rmatrix, nfactor= 2, rotate = "none" , fm= "pa", n.obs= 18809))

(efamodel1_r0 <-factor.rotate(efamodel1, angle = 0, plot = TRUE, xlim= c(-1,1), ylim= c(-1,1), title = "Unrotatedfactors"))




fa(r = Cor_USESECH, nfactors = 2)
names(read)
