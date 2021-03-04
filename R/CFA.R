#CFA R

library(lavaan)
library(psych)

model1 <- 'LEI=~ Q1 + Q2 + Q6 + Q5
           ACA=~ Q3 + Q7 + Q8 + Q9 + Q10'
mod1fit <- cfa(model1, USESCH, estimator = "ML")
summary(mod1fit, standardized = T, fit.measures = T)

(Lambda.results<-as.matrix(inspect(mod1fit, what="Estimates")$lambda))


(Phi.results<-as.matrix(inspect(mod1fit, what="Estimates")$psi))

modindices(mod1fit)
