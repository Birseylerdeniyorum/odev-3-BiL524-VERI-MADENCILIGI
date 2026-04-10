# odev-3-BiL524-VERI-MADENCILIGI
iki farklı data seti için keşifsel veri analizi sürecini aşama aşama gerçekleştiriniz 

Ödev Açıklaması
KEŞİFSEL VERİ ANALİZİ ÖDEV RAPORU (Görev -1 )
Bu çalışmada sentetik bir veri seti oluşturulmuş ve çalışanların maaşlarını etkileyen faktörler analiz edilmiştir. Eksik veriler ortalama usülü ile tamamlanmış olup, değişkenler standardize edilmiştir. Aykırı değer analizi yapılmış ve verideki uç değerler incelenmiştir. Korelasyon analizi ile değişkenler arasındaki ilişkiler değerlendirilmiş, son olarak regresyon modeli ile maaşı etkileyen faktörler belirlenmiştir. (1. Görev)
Bu ödev çalışma ortamı: Posit.Cloud (RStudio) üzerinde gerçekleştirilmiştir.

1. Veri üretme (sentetik veri oluşturma)
set.seed(100) (Her çalıştırdığımızda aynı sonuç gelsin diye sabitliyoruz 
n <- 100 (100 kişilik veri seti oluşturacağız)

Değişkenleri oluşturma  (3 tane değişken oluşturduk:
veri1 <- data.frame(
•	  egitim_yili = rnorm(n, 16, 3),       (1. Eğitim yılı )
  deneyim = rnorm(n, 10, 5),        (2. Deneyim)
•	  calisma_saati = rnorm(n, 45, 10)       (3. Haftalık çalışma saati)
)

<img width="486" height="335" alt="image" src="https://github.com/user-attachments/assets/b0f9ff7e-f616-48fe-9e25-552f68ac1808" />
<img width="438" height="141" alt="image" src="https://github.com/user-attachments/assets/2bd04a28-2db6-49ed-8f1d-1a4c8429d1b5" />

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

<img width="891" height="475" alt="image" src="https://github.com/user-attachments/assets/d548fdde-d63a-4ac0-a38a-9474d7a1caed" />

Eksik veriyi doldurma (verimizde oluşturduğumuz eksik verileri ortalama usulü ile dolduruyoruyz)
veri1$egitim_yili[is.na(veri1$egitim_yili)] <- mean(veri1$egitim_yili, na.rm = TRUE)

<img width="920" height="445" alt="image" src="https://github.com/user-attachments/assets/c7eb8380-2810-472f-8e35-c603c6a12ad0" />

4. Standardizasyon (Z-score)   (Verileri aynı ölçeğe getiriyoruz)

veri1$z_egitim <- scale(veri1$egitim_yili)
veri1$z_deneyim <- scale(veri1$deneyim)
Eğitim yılı ve Maaş bunlar farklı ölçek tipleri olduğu için karşılaştırma zor oluyor Standardizasyon yaparak hepsini ortalama 0, standart sapma 1 yaparız

<img width="445" height="513" alt="image" src="https://github.com/user-attachments/assets/8fe60e44-a230-41f1-8dc6-4e37e9a3e4cd" />

<img width="427" height="512" alt="image" src="https://github.com/user-attachments/assets/3fb71be3-67d7-4316-b129-2589f3673948" />

5. Aykırı değer (Outlier) analizi (Verinin alt %25 ve üst %25 değerlerini buluyoruz)
Q1 <- quantile(veri1$maas, 0.25)
Q3 <- quantile(veri1$maas, 0.75)
IQR <- Q3 - Q1
Aykırı sınırlar (Bu sınırların dışındaki değerler  aykırı değer olarak kabul edeceğiz)
alt <- Q1 - 1.5 * IQR
ust <- Q3 + 1.5 * IQR

<img width="934" height="256" alt="image" src="https://github.com/user-attachments/assets/7b83e1b1-42a6-496c-a07f-976b22be13c2" />

Görselleştirme
boxplot(veri1$maas)  (Maaşlarda anormal değer var mı gösterir)

<img width="827" height="592" alt="image" src="https://github.com/user-attachments/assets/21f93b45-6367-4fe1-a9b8-58c9676ab4af" />

6. Korelasyon (ilişki analizi)  (Değişkenler arasında ilişki var mı ona bakıyoruz)

cor1 <- cor(veri1)
corrplot(cor1, method="color")

<img width="442" height="300" alt="image" src="https://github.com/user-attachments/assets/e174d117-bc84-4e28-aead-f51a1a534604" />

<img width="454" height="325" alt="image" src="https://github.com/user-attachments/assets/edeb22fd-5aba-4ede-b463-5c938fa3410b" />

Bu korelasyon analizinde maaş üzerinde en güçlü belirleyici değişkenin eğitim yılı olduğu görülmektedir. Deneyim orta düzeyde bir etki gösterirken, çalışma saatinin maaş üzerinde anlamlı bir etkisi (yok denecek kadar) bulunmamaktadır. Bu durum, ücret belirlemede eğitim seviyesinin diğer faktörlere göre daha baskın bir rol oynadığını göstermektedir.
7. Regresyon (en önemli kısım) (Maaşı etkileyen faktörleri matematiksel model ile açıklıyoruz)
model1 <- lm(maas ~ egitim_yili + deneyim + calisma_saati, data = veri1)
summary(model1)

<img width="944" height="436" alt="image" src="https://github.com/user-attachments/assets/8895838a-ad24-4b1c-b1c5-55355a79d69f" />

Bu regresyon analizinde maaşı en güçlü şekilde etkileyen değişkenin eğitim yılı olduğu görülmektedir. Eğitim yılındaki bir birim artış maaşı yaklaşık 1021 TL artırmaktadır. Deneyim ve çalışma saati de maaş üzerinde pozitif ve istatistiksel olarak anlamlı etkiye sahiptir. Modelin R² değeri 0.91 olup, maaş değişkeninin %91’inin model tarafından açıklanabildiğini göstermektedir. Bu durum modelin oldukça güçlü bir açıklama gücüne sahip olduğunu göstermektedir.

Bu çalışma sonucunda genel mantık  Maaş =Eğitim + Deneyim + Çalışma Saati + hata sonucuna varıyoruz.
------------------------------------------------------------------------------------------------------
KEŞİFSEL VERİ ANALİZİ ÖDEV RAPORU (Görev -2 )
Bu çalışmada araç fiyatlarını etkileyen faktörler analiz edilmiştir. Şehir içi yakıt tüketimi, beygir gücü ve araç ağırlığının fiyat üzerindeki etkisi incelenmiştir. Yapılan korelasyon analizine göre özellikle beygir gücü ile fiyat arasında pozitif bir ilişki bulunmaktadır. Regresyon modeli sonucunda ise araç fiyatını en güçlü şekilde etkileyen değişkenin beygir gücü olduğu görülmektedir. Model, araç fiyatlarının önemli bir kısmını açıklayabilmektedir. (2. Görev)
Bu ödev çalışma ortamı: Posit.Cloud (RStudio) üzerinde gerçekleştirilmiştir.

Yapılan İşlemlerin Özeti:

1. VERİYİ GİTHUBTAN ÇEKME
(Veri içerisinde araba fiyatları ve teknik özellikler var amaç gerçek veri ile analiz yapmak )
url <- https://raw.githubusercontent.com/selva86/datasets/master/Cars93.csv 
(Hazır bir araç veri seti githubtan çekildi)
veri2 <- read.csv(url) 
<img width="944" height="220" alt="image" src="https://github.com/user-attachments/assets/78f93c86-76cf-4134-9e66-612477b621e8" />

2. VERİYİ İNCELEME (Nasıl bir veri üzeinde çalışıyoruz inceliyoruz)
head(veri2)   (ilk 6 satır)
str(veri2)    (veri yapısı (hangi sütunlar var?)
<img width="451" height="466" alt="image" src="https://github.com/user-attachments/assets/c96b0cbd-a19a-4771-bfa2-f9a3551d1478" />
<img width="459" height="434" alt="image" src="https://github.com/user-attachments/assets/b4014766-5bcd-4887-80a6-8e58a4cede76" />

3. VERİYİ TÜRKÇELEŞTİRME
veri2 <- veri2[, c("Price", "MPG.city", "Horsepower", "Weight")]
colnames(veri2) <- c("fiyat", "sehir_yakit", "beygir_gucu", "agirlik")

<img width="944" height="395" alt="image" src="https://github.com/user-attachments/assets/006715a2-069c-4663-afd4-bd540ec7ec35" />

<img width="944" height="133" alt="image" src="https://github.com/user-attachments/assets/82d79132-ba03-47c6-9dbd-3ff2482930ed" />
Sadece 4 değişkeni aldık Fiyat Şehir içi yakıt Beygir gücü Ağırlık Sonra isimleri Türkçeye çevirerek veri setimiz Türkiye’de araç piyasası gibi anlatılabilir hale geldi.

4. EKSİK VERİ ANALİZİ
colSums(is.na(veri2))   (Veri içinde boş değer var mı inceliyoruz)
Eksik veri doldurma
veri2$fiyat[is.na(veri2$fiyat)] <- mean(veri2$fiyat, na.rm = TRUE)
Eksik fiyatları ortalama ile doldurduk

<img width="881" height="523" alt="image" src="https://github.com/user-attachments/assets/ff877703-dfd7-4ca2-b5af-c040eaa04a86" />
5. AYKIRI DEĞER ANALİZİ
boxplot(veri2$fiyat)   (Çok pahalı veya çok ucuz araçlar var mı?)
<img width="917" height="309" alt="image" src="https://github.com/user-attachments/assets/b1c727e2-103e-4e4b-bcf9-06d99d34e77b" />
Bu boxplot grafiği, araç fiyatlarının büyük kısmının belirli bir aralıkta toplandığını göstermektedir. Ancak bazı araçların fiyatlarının diğer araçlara göre çok yüksek olduğu ve aykırı değer oluşturduğu görülmektedir. Bu durum piyasada lüks araçların bulunduğunu ve fiyat dağılımının homojen olmadığını göstermektedir

6. KORELASYON ANALİZİ (Değişkenler arasındaki ilişkileri inceliyoruz)
cor2 <- cor(veri2)
corrplot(cor2, method = "color")
<img width="1016" height="400" alt="image" src="https://github.com/user-attachments/assets/9ba332ee-402c-4760-a48e-6523caf1265a" />

Korelasyon analizi sonucunda araç fiyatı ile beygir gücü arasında güçlü pozitif bir ilişki olduğu görülmektedir. Araç ağırlığı da fiyat üzerinde pozitif bir etkiye sahiptir. Buna karşılık şehir içi yakıt tüketimi ile fiyat arasında negatif bir ilişki bulunmuştur. Bu durum, daha güçlü ve ağır araçların genellikle daha pahalı olduğunu, ancak yakıt tüketimi yüksek olan araçların daha düşük fiyatlı olabileceğini göstermektedir.

7. REGRESYON MODELİ (EN ÖNEMLİ KISIM)
Araba fiyatını etkileyen faktörleri matematiksel olarak buluyoruz
Bir arabanın fiyatını ne belirler?
1.	yakıt tüketimi mi? 
2.	motor gücü mü? 
3.	ağırlık mı? 
model2 <- lm(fiyat ~ sehir_yakit + beygir_gucu + agirlik, data = veri2)
summary(model2)

<img width="938" height="430" alt="image" src="https://github.com/user-attachments/assets/79bec56d-6f80-490e-8dab-6651b7c34d28" />

Bu regresyon analizi sonucunda araç fiyatını en güçlü şekilde etkileyen değişkenin beygir gücü olduğu görülmektedir. Şehir içi yakıt tüketimi ve araç ağırlığı ise istatistiksel olarak anlamlı bulunmamıştır. Modelin açıklama gücü %63 seviyesinde olup, araç fiyatlarının orta düzeyde açıklanabildiğini göstermektedir. Bu sonuçlara göre araç fiyatlarının belirlenmesinde en kritik faktör motor gücüdür.

Sonuç: Araç fiyatını istatistiksel olarak arttıran anlamlı şekilde sadece beygir gücü çıkmaktadır.

