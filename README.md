# MaestroApp
Bu proje İstanbul Aydın Üniversitesi Yazılım Mühendisliği Bölümü Öğrencileri @nadirakdag ve @caliskansinan tarafından mezuniyet projesi olarak geliştirilmektedir.
Geliştirdiğimiz bu uygulama ile kullanıcılar MaestroPanel arayüzüne giriş yapmadan aşağıda yer alan işlemleri yapabilmesini sağlayacaktır. 

1.  Domain İşlemleri
    -   Web
        *  [x] Yeni Domain Oluşturma 
        *  [x] Domain Başlatma, Durdurma, Silme
        *  [x] Domain Kullanıcısı Şifre Değiştirme
        *  [x] Domainleri Listeleme 
    -   Dosya İşlemleri
        *  [ ] Klasor ve Dosya Listemele
        *  [ ] Yeni Klasor oluşturma
        *  [ ] Klasor ve Dosya Silme
        *  [ ] Yazma İzni Verme ve Kaldırma
    -   Alias Yönetimi
        *  [x] Alias Oluşturma 
        *  [x] Aliasları Listeleme 
        *  [x] Alias Silme 
    -   E-Posta Adres Yönetimi
        *   [x] Yeni E-Posta Adresi Oluşturma 
        *   [x] E-Posta Adreslerini Listeleme 
        *   [x] E-Posta Adresi Silme 
        *   [ ] E-Posta Adresinin Şifresini ve Kotasını Değiştirme
    -   Veritabanı Yönetimi
        *   [x] Yeni Veritabanı Oluşturma  
        *   [x] Veritabanlarını Listeleme  
        *   [x] Veritabanı Silme  
        *   [ ] Veritabanı Kotası Değiştirme
        *   [ ] Veritabanı Kullanıcı Yönetimi
            *  [ ] Yeni Kullanıcı Oluşturma
            *  [ ] Kullanıcı Silme
            *  [ ] Kullanıcı Şifresini Değiştirme
            *  [ ] Kullanıcı İzinlerini Yönetme
    -   FTP Kullanıcı Yönetimi
        *   [x] Yeni FTP Kullanıcısı Oluşturma  
        *   [x] FTP Kullanıcılarını Listeleme  
        *   [x] FTP Kullanıcısının Şifresini Değiştirme 
        *   [x] FTP Kullanıcısını Silme  
    -   DNS Yönetimi
        *   [x] DNS Kayıtlarını Listelenmesi  
        *   [ ] Yeni DNS Kaydı Ekleme
        *   [x] DNS Kaydı Silme  
        *   [ ] DNS Zone Ayarlanması
2.  Bayi Yönetimi
    -   Bayi Kullanıcı Yönetimi
        *   [ ] Yeni Bayi Kullanıcısı Oluşturma
        *   [ ] Bayi Kullanısını Başlatma, Durdurma ve Silme İşlemleri
        *   [ ] Bayi Kullanıcısının Şifresini Değiştirme
        *   [x] Bayi Kullanıcılarının Listelemesi  
        *   [ ] Bayi Kullanıcısına ait Domain Yönetimi
        *   [ ] Bayi Kullanıcısına ait IP Adreslerinin Yönetimi
3. Sunucu Yönetimi
    -   [ ] IP Adresi Yönetimi
    -   [x] Sunucunun Kaynak Durumlarının Listelenmesi  
    -   [x] Sunucuların Listelenmesi  


## Başlangıç

``` git clone https://github.com/nadirakdag/maestroapp.git ```

Uygulama paket yöneticisi olarak [cocoapods](https://cocoapods.org/) kullanmaktadır. Gerekli paketleri yükleye bilmeniz için cocoapods'un bilgisayarınızda yüklü olması gerekmektedir. Yüklemek için [https://cocoapods.org/](https://cocoapods.org/#install) adresinden yardım alabilirsiniz. 

cocoapods'u yükledikten sonra 

``` cd MaestroApp ```

``` pod install ```

demeniz yeterli olacaktır.

cocoapods'un oluşturacağı "MaestroApp.xcworkspace" açıp derlediğiniz takdirde projenin başarılı bir şekilde derleniyor olması gerekmektedir.
