// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Kervan A.Ş.';

  @override
  String get appTitleShort => 'Kervan';

  @override
  String get companySuffix => 'A.Ş.';

  @override
  String get play => 'Oyna';

  @override
  String get settings => 'Ayarlar';

  @override
  String get exit => 'Çıkış';

  @override
  String get newGame => 'Yeni Oyun';

  @override
  String get continueGame => 'Devam Et';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get close => 'Kapat';

  @override
  String get ok => 'Tamam';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get buy => 'Satın Al';

  @override
  String get unlock => 'Aç';

  @override
  String get newGameConfirmTitle => 'Yeni Oyun';

  @override
  String get newGameConfirmBody => 'Mevcut kayıt silinecek. Emin misin?';

  @override
  String get tabProduction => 'Üretim';

  @override
  String get tabInventory => 'Envanter';

  @override
  String get tabTransport => 'Nakliye';

  @override
  String get tabContracts => 'Sözleşme';

  @override
  String get tabResearch => 'Araştırma';

  @override
  String get language => 'Dil';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get languageEn => 'İngilizce';

  @override
  String get sound => 'Ses';

  @override
  String get music => 'Müzik';

  @override
  String get version => 'Sürüm';

  @override
  String get money => 'Para';

  @override
  String get diamonds => 'Elmas';

  @override
  String get prestigePoints => 'Prestij';

  @override
  String get perHour => '/saat';

  @override
  String get comingSoon => 'Yapım aşamasında...';

  @override
  String get sectorAgriculture => 'Tarım';

  @override
  String get sectorProduction => 'Üretim';

  @override
  String get sectorLogistics => 'Lojistik';

  @override
  String get sectorTrade => 'Ticaret';

  @override
  String get sectorFinance => 'Finans';

  @override
  String get sectorTechnology => 'Teknoloji';

  @override
  String get sectorLocked => 'Kilitli';

  @override
  String get statusProducing => 'Üretiyor';

  @override
  String get statusIdle => 'Bekliyor';

  @override
  String get statusWaitingInput => 'Girdi Bekleniyor';

  @override
  String get statusStorageFull => 'Depo Dolu';

  @override
  String get statusNoEnergy => 'Enerji Yok';

  @override
  String get upgrade => 'Yükselt';

  @override
  String upgradeTo(int level) {
    return 'Lv.$level yap';
  }

  @override
  String get level => 'Lv.';

  @override
  String get manager => 'Yönetici';

  @override
  String get managerNone => 'Yönetici Yok (Manuel)';

  @override
  String get managerIntern => 'Stajyer';

  @override
  String get managerExpert => 'Uzman';

  @override
  String get managerManager => 'Müdür';

  @override
  String get managerDirector => 'Direktör';

  @override
  String get managerCEO => 'CEO';

  @override
  String get assignManager => 'Yönetici Ata';

  @override
  String managerSpeed(String mult) {
    return '×$mult hız';
  }

  @override
  String get sell => 'Sat';

  @override
  String get sellAll => 'Tümünü Sat';

  @override
  String get estimatedRevenue => 'Tahmini Gelir';

  @override
  String get available => 'Satılabilir';

  @override
  String get reserved => 'Rezerve';

  @override
  String get insufficientStock => 'Yetersiz stok';

  @override
  String get insufficientFunds => 'Yetersiz para';

  @override
  String get storageFull => 'Depo dolu — önce sat';

  @override
  String waitingForInput(String product) {
    return '⚠️ $product bekleniyor';
  }

  @override
  String get building_farm => 'Tarla';

  @override
  String get building_mine => 'Maden Ocağı';

  @override
  String get building_forest => 'Orman';

  @override
  String get building_ranch => 'Çiftlik';

  @override
  String get building_quarry => 'Taş Ocağı';

  @override
  String get building_mill => 'Değirmen';

  @override
  String get building_ironFactory => 'Demir Fabrikası';

  @override
  String get building_woodProcessing => 'Ahşap İşleme';

  @override
  String get building_dairyFactory => 'Süt Fabrikası';

  @override
  String get building_textileFactory => 'Tekstil Fabrikası';

  @override
  String get building_bakery => 'Fırın';

  @override
  String get building_steelFactory => 'Çelik Fabrikası';

  @override
  String get building_furnitureFactory => 'Mobilya Fabrikası';

  @override
  String get building_clothingFactory => 'Giysi Fabrikası';

  @override
  String get building_readyFoodFactory => 'Hazır Gıda Fabrikası';

  @override
  String get building_machineFactory => 'Makine Fabrikası';

  @override
  String get building_market => 'Market';

  @override
  String get building_supermarket => 'Süpermarket';

  @override
  String get building_furnitureStore => 'Mobilya Mağazası';

  @override
  String get building_clothingStore => 'Giyim Mağazası';

  @override
  String get building_industrialStore => 'Endüstriyel Satış';

  @override
  String get building_warehouse => 'Depo';

  @override
  String get building_truckGarage => 'Kamyon Garajı';

  @override
  String get building_port => 'Liman';

  @override
  String get building_airCargoTerminal => 'Hava Kargo Terminali';

  @override
  String get product_wheat => 'Buğday';

  @override
  String get product_sugarCane => 'Şeker Kamışı';

  @override
  String get product_cotton => 'Pamuk';

  @override
  String get product_corn => 'Mısır';

  @override
  String get product_milk => 'Süt';

  @override
  String get product_wool => 'Yün';

  @override
  String get product_meat => 'Et';

  @override
  String get product_egg => 'Yumurta';

  @override
  String get product_ironOre => 'Demir Cevheri';

  @override
  String get product_copperOre => 'Bakır Cevheri';

  @override
  String get product_sand => 'Kum';

  @override
  String get product_coal => 'Kömür';

  @override
  String get product_stone => 'Taş';

  @override
  String get product_timber => 'Kereste';

  @override
  String get product_flour => 'Un';

  @override
  String get product_cornFlour => 'Mısır Unu';

  @override
  String get product_sugar => 'Şeker';

  @override
  String get product_cheese => 'Peynir';

  @override
  String get product_yogurt => 'Yoğurt';

  @override
  String get product_fabric => 'Kumaş';

  @override
  String get product_rawIron => 'Ham Demir';

  @override
  String get product_copper => 'Bakır';

  @override
  String get product_steel => 'Çelik';

  @override
  String get product_glass => 'Cam';

  @override
  String get product_processedWood => 'İşlenmiş Ahşap';

  @override
  String get product_bread => 'Ekmek';

  @override
  String get product_cake => 'Pasta';

  @override
  String get product_machine => 'Makine';

  @override
  String get product_electronic => 'Elektronik';

  @override
  String get product_furniture => 'Mobilya';

  @override
  String get product_premiumFurniture => 'Premium Mobilya';

  @override
  String get product_clothing => 'Giysi';

  @override
  String get product_smartClothing => 'Akıllı Giysi';

  @override
  String get product_burger => 'Burger';

  @override
  String get product_pizza => 'Pizza';

  @override
  String get channel_market => 'Market';

  @override
  String get channel_supermarket => 'Süpermarket';

  @override
  String get channel_furnitureStore => 'Mobilya Mağazası';

  @override
  String get channel_clothingStore => 'Giyim Mağazası';

  @override
  String get channel_electronicStore => 'Elektronik Mağazası';

  @override
  String get channel_industrialStore => 'Endüstriyel';

  @override
  String get channel_restaurant => 'Restoran';

  @override
  String get channel_port => 'Liman İhracat';

  @override
  String get channel_airCargoTerminal => 'Hava Kargo';

  @override
  String get vehicle_smallTruck => 'Küçük Kamyon';

  @override
  String get vehicle_bigTruck => 'Büyük Kamyon';

  @override
  String get vehicle_ship => 'Gemi';

  @override
  String get vehicle_airCargo => 'Hava Kargo';

  @override
  String get vehicle_train => 'Tren';

  @override
  String get contract_cityOrder => 'Şehir Siparişi';

  @override
  String get contract_b2bOrder => 'B2B Sipariş';

  @override
  String get contract_vipOrder => 'VIP Müşteri';

  @override
  String get contract_exportContract => 'İhracat Sözleşmesi';

  @override
  String get contract_urgentOrder => 'Acil Sipariş';

  @override
  String get research_fertileSoil => 'Verimli Toprak';

  @override
  String get research_fertileSoil_desc => 'Tarla üretimi +%20';

  @override
  String get research_irrigation => 'Sulama Sistemi';

  @override
  String get research_irrigation_desc => 'Tarla hızı +%15';

  @override
  String get research_miningDrill => 'Maden Matkabı';

  @override
  String get research_miningDrill_desc => 'Maden üretimi +%25';

  @override
  String get research_assemblyLine => 'Montaj Hattı';

  @override
  String get research_assemblyLine_desc => 'Tüm üretim +%10';

  @override
  String get research_qualityControl => 'Kalite Kontrol';

  @override
  String get research_qualityControl_desc => 'Tüm üretim +%15';

  @override
  String get research_logisticsSoftware => 'Lojistik Yazılımı';

  @override
  String get research_logisticsSoftware_desc => 'Sözleşme slotu +1';

  @override
  String get research_vehicleUpgrade => 'Araç Modernizasyonu';

  @override
  String get research_vehicleUpgrade_desc => 'Araç kapasitesi +%20';

  @override
  String get research_exportNetwork => 'İhracat Ağı';

  @override
  String get research_exportNetwork_desc => 'İhracat kâr +%20';

  @override
  String get research_fastSale => 'Hızlı Satış';

  @override
  String get research_fastSale_desc => 'Oto-satış aralığı 30→20sn';

  @override
  String get research_warehouseOrg => 'Depo Organizasyonu';

  @override
  String get research_warehouseOrg_desc => 'Tüm ürün kapasiteleri +%25';

  @override
  String get research_smartShelf => 'Akıllı Raf Sistemi';

  @override
  String get research_smartShelf_desc => 'Global ağırlık kapasitesi +%30';

  @override
  String get research_marketConnect => 'Pazar Bağlantısı';

  @override
  String get research_marketConnect_desc => 'Oto-satış aralığı 20→15sn';

  @override
  String get research_smartReserve => 'Akıllı Rezerv';

  @override
  String get research_smartReserve_desc => 'Sözleşme rezervi üretimi durdurmaz';

  @override
  String get research_passiveIncome => 'Pasif Gelir';

  @override
  String get research_passiveIncome_desc => 'Saatte +%0.5 faiz geliri';

  @override
  String get research_automation => 'Otomasyon';

  @override
  String get research_automation_desc => 'Tüm üretim +%30';

  @override
  String get prestige_headStart => 'Hızlı Başlangıç';

  @override
  String get prestige_headStart_desc => 'Başlangıçta +50.000₺';

  @override
  String get prestige_productionMastery => 'Üretim Ustalığı';

  @override
  String get prestige_productionMastery_desc => 'Tüm üretim +%25';

  @override
  String get prestige_heritageStorage => 'Miras Deposu';

  @override
  String get prestige_heritageStorage_desc =>
      'En değerli 3 ürünün %20\'si korunur';

  @override
  String get prestige_veteranManager => 'Deneyimli Yönetici';

  @override
  String get prestige_veteranManager_desc =>
      'Yöneticiler prestij sonrası kalır';

  @override
  String get prestige_researchCarry => 'Araştırma Mirası';

  @override
  String get prestige_researchCarry_desc => 'Araştırmaların %50\'si aktarılır';

  @override
  String get prestige_diamondBonus => 'Elmas Bonusu';

  @override
  String get prestige_diamondBonus_desc => 'Elmas kazanımı +%20';

  @override
  String get offlineEarnings => 'Çevrimdışı Kazanım';

  @override
  String offlineEarningsBody(String duration, String summary) {
    return '$duration süre çevrimdışıydın.\n$summary';
  }

  @override
  String sectorUnlocked(String sector) {
    return '$sector Sektörü Açıldı!';
  }

  @override
  String get perMinute => '/dk';

  @override
  String get units => 'birim';

  @override
  String get capacity => 'Kapasite';

  @override
  String get totalValue => 'Toplam Değer';

  @override
  String get fillPercent => 'Doluluk';
}
