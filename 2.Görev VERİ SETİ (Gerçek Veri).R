##################################################
# 2. VER?? SET?? ARA?? F??YATLARI
##################################################

# ??nternetten verimizi ??ekiyoruz
url <- "https://raw.githubusercontent.com/selva86/datasets/master/Cars93.csv"
veri2 <- read.csv(url)

# verimizi inceliyoruz
head(veri2)
str(veri2)

# YABANCI B??R VER?? SET?? ??LE ??ALI??TI??IMIZ ??????N T??RK??YE BA??LAMINA UYARLIYORUZ T??RK??YEYE A??TM???? G??B?? YAPIYORUZ
# De??i??ken isimlerini T??rk??e yap??yoruz
veri2 <- veri2[, c("Price", "MPG.city", "Horsepower", "Weight")]
colnames(veri2) <- c("fiyat", "sehir_yakit", "beygir_gucu", "agirlik")

# EKS??K VER?? ANAL??Z??
colSums(is.na(veri2))

# Eksik veri varsa ortalama ile doldurma i??lemi yap??yoruz
veri2$fiyat[is.na(veri2$fiyat)] <- mean(veri2$fiyat, na.rm = TRUE)

# AYKIRI DE??ER ANAL??Z??

boxplot(veri2$fiyat,
        main = "T??rkiye ??kinci El Ara?? Fiyat Ayk??r?? De??erleri",
        col = "lightblue")

# KORELASYON ANAL??Z??

library(corrplot)

cor2 <- cor(veri2)
corrplot(cor2, method = "color")

# REGRESYON MODEL??

model2 <- lm(fiyat ~ sehir_yakit + beygir_gucu + agirlik, data = veri2)
summary(model2)