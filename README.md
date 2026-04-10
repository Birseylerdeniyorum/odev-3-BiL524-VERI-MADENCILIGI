# odev-3-BiL524-VERI-MADENCILIGI
iki farklı data seti için keşifsel veri analizi sürecini aşama aşama gerçekleştiriniz 


BİL524 VERİ MADENCİLİĞİ
i) Veri üreterek,
ii) Veriyi çekerek (çektiğiniz veri http ise ben de çekebilirim ancak diskinize kayıtlı bir veri seti ise çektiğiniz veriyi ödevinize ayrı bir dosya olarak yükleyiniz),
iki farklı data seti için keşifsel veri analizi sürecini aşama aşama gerçekleştiriniz 
(1- Tek bir script olarak  2- "#" ile her işlem için açıklama ve yorum yazarak).
Bu çalışmayı posit.cloud'da (veya Colab'da) gerçekleştirebilirsiniz. 
Github hesabınızdan da yayınlayınız.
GitHub linkini içeren açıklayıcı kısa raporu (word) ve script'inizi (tek betik) ödev olarak sisteme yükleyiniz (Toplam 2 dosya)
Not: ii için veriyi diskinizden çekiyorsanız ilgili veriyi de yükleyiniz, csv xlsx vb. (Bu durumda ise toplam 3 dosya)
Başarılar.
####################################################################################################
Ödev Açıklaması
KEŞİFSEL VERİ ANALİZİ ÖDEV RAPORU (Görev -1 )
Bu çalışmada sentetik bir veri seti oluşturulmuş ve çalışanların maaşlarını etkileyen faktörler analiz edilmiştir. Eksik veriler ortalama usülü ile tamamlanmış olup, değişkenler standardize edilmiştir. Aykırı değer analizi yapılmış ve verideki uç değerler incelenmiştir. Korelasyon analizi ile değişkenler arasındaki ilişkiler değerlendirilmiş, son olarak regresyon modeli ile maaşı etkileyen faktörler belirlenmiştir. (1. Görev)
Bu ödev çalışma ortamı: Posit.Cloud (RStudio) üzerinde gerçekleştirilmiştir.
GitHub Linki: https://github.com/Birseylerdeniyorum/odev-3-BiL524-VERI-MADENCILIGI
Yapılan İşlemlerin Özeti:
1. Veri üretme (sentetik veri oluşturma)
set.seed(100) (Her çalıştırdığımızda aynı sonuç gelsin diye sabitliyoruz 
n <- 100 (100 kişilik veri seti oluşturacağız)

Değişkenleri oluşturma  (3 tane değişken oluşturduk:
veri1 <- data.frame(
•	  egitim_yili = rnorm(n, 16, 3),       (1. Eğitim yılı )
  deneyim = rnorm(n, 10, 5),        (2. Deneyim)
•	  calisma_saati = rnorm(n, 45, 10)       (3. Haftalık çalışma saati)
)

  
Maaş değişkeni  (  Maaşı “formülle” ürettik Yani gerçek hayatta şöyle bir mantık kurduk:)
veri1$maas <- 3000 +
  1000 * veri1$egitim_yili +      (Eğitim artarsa maaş artar)
  500 * veri1$deneyim +              (Deneyim artarsa maaş artar)
  50 * veri1$calisma_saati +          (Çalışma saati artarsa maaş artar)
  rnorm(n, 0, 1000)        (Gerçek hayattaki şans / hata payı)

2. Veri yapısını inceleme (Burada amaç: “veri doğru mu oluştu?” kontrol etmek) 
str(veri1)      (veri nasıl bir yapıdadır (sütunlar, tipler))
head(veri1)     (ilk 6 satırı gösterir)

3. Eksik veri analizi
colSums(is.na(veri1))    (Veride boş (NA) var mı bakıyoruz)
veri1$egitim_yili[10] <- NA    (Bilerek eksik veri oluşturuyoruz veriyi biz ürettik.  Gerçek hayatta veri eksikliği illaki oluyor)
 

Eksik veriyi doldurma (verimizde oluşturduğumuz eksik verileri ortalama usulü ile dolduruyoruyz)
veri1$egitim_yili[is.na(veri1$egitim_yili)] <- mean(veri1$egitim_yili, na.rm = TRUE)

 

4. Standardizasyon (Z-score)   (Verileri aynı ölçeğe getiriyoruz)

veri1$z_egitim <- scale(veri1$egitim_yili)
veri1$z_deneyim <- scale(veri1$deneyim)
Eğitim yılı ve Maaş bunlar farklı ölçek tipleri olduğu için karşılaştırma zor oluyor Standardizasyon yaparak hepsini ortalama 0, standart sapma 1 yaparız

    

5. Aykırı değer (Outlier) analizi (Verinin alt %25 ve üst %25 değerlerini buluyoruz)
Q1 <- quantile(veri1$maas, 0.25)
Q3 <- quantile(veri1$maas, 0.75)
IQR <- Q3 - Q1
Aykırı sınırlar (Bu sınırların dışındaki değerler  aykırı değer olarak kabul edeceğiz)
alt <- Q1 - 1.5 * IQR
ust <- Q3 + 1.5 * IQR
 
Görselleştirme
boxplot(veri1$maas)  (Maaşlarda anormal değer var mı gösterir)

 
6. Korelasyon (ilişki analizi)  (Değişkenler arasında ilişki var mı ona bakıyoruz)

cor1 <- cor(veri1)
corrplot(cor1, method="color")
   
Bu korelasyon analizinde maaş üzerinde en güçlü belirleyici değişkenin eğitim yılı olduğu görülmektedir. Deneyim orta düzeyde bir etki gösterirken, çalışma saatinin maaş üzerinde anlamlı bir etkisi (yok denecek kadar) bulunmamaktadır. Bu durum, ücret belirlemede eğitim seviyesinin diğer faktörlere göre daha baskın bir rol oynadığını göstermektedir.
7. Regresyon (en önemli kısım) (Maaşı etkileyen faktörleri matematiksel model ile açıklıyoruz)
model1 <- lm(maas ~ egitim_yili + deneyim + calisma_saati, data = veri1)
summary(model1)
 
Bu regresyon analizinde maaşı en güçlü şekilde etkileyen değişkenin eğitim yılı olduğu görülmektedir. Eğitim yılındaki bir birim artış maaşı yaklaşık 1021 TL artırmaktadır. Deneyim ve çalışma saati de maaş üzerinde pozitif ve istatistiksel olarak anlamlı etkiye sahiptir. Modelin R² değeri 0.91 olup, maaş değişkeninin %91’inin model tarafından açıklanabildiğini göstermektedir. Bu durum modelin oldukça güçlü bir açıklama gücüne sahip olduğunu göstermektedir.
Bu çalışma sonucunda genel mantık  Maaş =Eğitim + Deneyim + Çalışma Saati + hata sonucuna varıyoruz.



KEŞİFSEL VERİ ANALİZİ ÖDEV RAPORU (Görev -2 )
Bu çalışmada araç fiyatlarını etkileyen faktörler analiz edilmiştir. Şehir içi yakıt tüketimi, beygir gücü ve araç ağırlığının fiyat üzerindeki etkisi incelenmiştir. Yapılan korelasyon analizine göre özellikle beygir gücü ile fiyat arasında pozitif bir ilişki bulunmaktadır. Regresyon modeli sonucunda ise araç fiyatını en güçlü şekilde etkileyen değişkenin beygir gücü olduğu görülmektedir. Model, araç fiyatlarının önemli bir kısmını açıklayabilmektedir. (2. Görev)
Bu ödev çalışma ortamı: Posit.Cloud (RStudio) üzerinde gerçekleştirilmiştir.
GitHub Linki: https://github.com/Birseylerdeniyorum/odev-3-BiL524-VERI-MADENCILIGI
Yapılan İşlemlerin Özeti:

1. VERİYİ GİTHUBTAN ÇEKME
(Veri içerisinde araba fiyatları ve teknik özellikler var amaç gerçek veri ile analiz yapmak )
url <- https://raw.githubusercontent.com/selva86/datasets/master/Cars93.csv 
(Hazır bir araç veri seti githubtan çekildi)
veri2 <- read.csv(url) 
 
2. VERİYİ İNCELEME (Nasıl bir veri üzeinde çalışıyoruz inceliyoruz)
head(veri2)   (ilk 6 satır)
str(veri2)    (veri yapısı (hangi sütunlar var?)
   
3. VERİYİ TÜRKÇELEŞTİRME
veri2 <- veri2[, c("Price", "MPG.city", "Horsepower", "Weight")]
colnames(veri2) <- c("fiyat", "sehir_yakit", "beygir_gucu", "agirlik")
 
 
Sadece 4 değişkeni aldık Fiyat Şehir içi yakıt Beygir gücü Ağırlık Sonra isimleri Türkçeye çevirerek veri setimiz Türkiye’de araç piyasası gibi anlatılabilir hale geldi.

4. EKSİK VERİ ANALİZİ
colSums(is.na(veri2))   (Veri içinde boş değer var mı inceliyoruz)
Eksik veri doldurma
veri2$fiyat[is.na(veri2$fiyat)] <- mean(veri2$fiyat, na.rm = TRUE)
Eksik fiyatları ortalama ile doldurduk
 

5. AYKIRI DEĞER ANALİZİ
boxplot(veri2$fiyat)   (Çok pahalı veya çok ucuz araçlar var mı?)
 
Bu boxplot grafiği, araç fiyatlarının büyük kısmının belirli bir aralıkta toplandığını göstermektedir. Ancak bazı araçların fiyatlarının diğer araçlara göre çok yüksek olduğu ve aykırı değer oluşturduğu görülmektedir. Bu durum piyasada lüks araçların bulunduğunu ve fiyat dağılımının homojen olmadığını göstermektedir

6. KORELASYON ANALİZİ (Değişkenler arasındaki ilişkileri inceliyoruz)
cor2 <- cor(veri2)
corrplot(cor2, method = "color")
 
Korelasyon analizi sonucunda araç fiyatı ile beygir gücü arasında güçlü pozitif bir ilişki olduğu görülmektedir. Araç ağırlığı da fiyat üzerinde pozitif bir etkiye sahiptir. Buna karşılık şehir içi yakıt tüketimi ile fiyat arasında negatif bir ilişki bulunmuştur. Bu durum, daha güçlü ve ağır araçların genellikle daha pahalı olduğunu, ancak yakıt tüketimi yüksek olan araçların daha düşük fiyatlı olabileceğini göstermektedir.

7. REGRESYON MODELİ (EN ÖNEMLİ KISIM)
Araba fiyatını etkileyen faktörleri matematiksel olarak buluyoruz
Bir arabanın fiyatını ne belirler?
1.	yakıt tüketimi mi? 
2.	motor gücü mü? 
3.	ağırlık mı? 
model2 <- lm(fiyat ~ sehir_yakit + beygir_gucu + agirlik, data = veri2)
summary(model2)
 
Bu regresyon analizi sonucunda araç fiyatını en güçlü şekilde etkileyen değişkenin beygir gücü olduğu görülmektedir. Şehir içi yakıt tüketimi ve araç ağırlığı ise istatistiksel olarak anlamlı bulunmamıştır. Modelin açıklama gücü %63 seviyesinde olup, araç fiyatlarının orta düzeyde açıklanabildiğini göstermektedir. Bu sonuçlara göre araç fiyatlarının belirlenmesinde en kritik faktör motor gücüdür.
Sonuç: Araç fiyatını istatistiksel olarak arttıran anlamlı şekilde sadece beygir gücü çıkmaktadır.


Ferda KAYA
51148568266

