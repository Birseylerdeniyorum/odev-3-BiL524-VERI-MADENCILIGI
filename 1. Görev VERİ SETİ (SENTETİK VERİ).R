##################################################
# KE????FSEL VER?? ANAL??Z?? PROJES??
# ????renci: ferda kaya
# A????klama: Bu ??al????mada 2 farkl?? veri seti ??zerinde
# ke??ifsel veri analizi yap??lm????t??r.
##################################################

library(corrplot)

# 1. VER?? SET?? (SENTET??K VER??)

# Tekrarlanabilirlik
set.seed(100)

# G??zlem say??s??
n <- 100

# Veri ??retimi
veri1 <- data.frame(
  egitim_yili = rnorm(n, 16, 3),
  deneyim = rnorm(n, 10, 5),
  calisma_saati = rnorm(n, 45, 10)
)

# Ba????ml?? de??i??ken
veri1$maas <- 3000 +
  1000 * veri1$egitim_yili +
  500 * veri1$deneyim +
  50 * veri1$calisma_saati +
  rnorm(n, 0, 1000)

# Veri yap??s??
str(veri1)
head(veri1)

# EKS??K VER?? ANAL??Z??

colSums(is.na(veri1))

# Kas??tl?? olarak eksik veri olu??tural??m
veri1$egitim_yili[10] <- NA

# Ortalama ile doldurma
veri1$egitim_yili[is.na(veri1$egitim_yili)] <- mean(veri1$egitim_yili, na.rm = TRUE)

# STANDARD??ZASYON

z_egitim <- scale(veri1$egitim_yili)
z_deneyim <- scale(veri1$deneyim)

# AYKIRI DE??ER ANAL??Z??

Q1 <- quantile(veri1$maas, 0.25)
Q3 <- quantile(veri1$maas, 0.75)

IQR <- Q3 - Q1

alt <- Q1 - 1.5 * IQR
ust <- Q3 + 1.5 * IQR

boxplot(veri1$maas, main="Maa?? Ayk??r?? De??er")

# KORELASYON

cor1 <- cor(veri1)
corrplot(cor1, method="color")

# REGRESYON

model1 <- lm(maas ~ egitim_yili + deneyim + calisma_saati, data = veri1)
summary(model1)