import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Uygulama adı (Türkçe)
  ///
  /// In tr, this message translates to:
  /// **'Kervan A.Ş.'**
  String get appTitle;

  /// No description provided for @appTitleShort.
  ///
  /// In tr, this message translates to:
  /// **'Kervan'**
  String get appTitleShort;

  /// No description provided for @companySuffix.
  ///
  /// In tr, this message translates to:
  /// **'A.Ş.'**
  String get companySuffix;

  /// No description provided for @play.
  ///
  /// In tr, this message translates to:
  /// **'Oyna'**
  String get play;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @exit.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış'**
  String get exit;

  /// No description provided for @newGame.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Oyun'**
  String get newGame;

  /// No description provided for @continueGame.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueGame;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @buy.
  ///
  /// In tr, this message translates to:
  /// **'Satın Al'**
  String get buy;

  /// No description provided for @unlock.
  ///
  /// In tr, this message translates to:
  /// **'Aç'**
  String get unlock;

  /// No description provided for @newGameConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Oyun'**
  String get newGameConfirmTitle;

  /// No description provided for @newGameConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut kayıt silinecek. Emin misin?'**
  String get newGameConfirmBody;

  /// No description provided for @tabProduction.
  ///
  /// In tr, this message translates to:
  /// **'Üretim'**
  String get tabProduction;

  /// No description provided for @tabInventory.
  ///
  /// In tr, this message translates to:
  /// **'Envanter'**
  String get tabInventory;

  /// No description provided for @tabTransport.
  ///
  /// In tr, this message translates to:
  /// **'Nakliye'**
  String get tabTransport;

  /// No description provided for @tabContracts.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşme'**
  String get tabContracts;

  /// No description provided for @tabResearch.
  ///
  /// In tr, this message translates to:
  /// **'Araştırma'**
  String get tabResearch;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @languageTr.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTr;

  /// No description provided for @languageEn.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get languageEn;

  /// No description provided for @sound.
  ///
  /// In tr, this message translates to:
  /// **'Ses'**
  String get sound;

  /// No description provided for @music.
  ///
  /// In tr, this message translates to:
  /// **'Müzik'**
  String get music;

  /// No description provided for @version.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get version;

  /// No description provided for @money.
  ///
  /// In tr, this message translates to:
  /// **'Para'**
  String get money;

  /// No description provided for @diamonds.
  ///
  /// In tr, this message translates to:
  /// **'Elmas'**
  String get diamonds;

  /// No description provided for @prestigePoints.
  ///
  /// In tr, this message translates to:
  /// **'Prestij'**
  String get prestigePoints;

  /// No description provided for @perHour.
  ///
  /// In tr, this message translates to:
  /// **'/saat'**
  String get perHour;

  /// No description provided for @comingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Yapım aşamasında...'**
  String get comingSoon;

  /// No description provided for @sectorAgriculture.
  ///
  /// In tr, this message translates to:
  /// **'Hammadde'**
  String get sectorAgriculture;

  /// No description provided for @sectorProduction.
  ///
  /// In tr, this message translates to:
  /// **'Üretim'**
  String get sectorProduction;

  /// No description provided for @sectorLogistics.
  ///
  /// In tr, this message translates to:
  /// **'Lojistik'**
  String get sectorLogistics;

  /// No description provided for @sectorTrade.
  ///
  /// In tr, this message translates to:
  /// **'Ticaret'**
  String get sectorTrade;

  /// No description provided for @sectorFinance.
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get sectorFinance;

  /// No description provided for @sectorTechnology.
  ///
  /// In tr, this message translates to:
  /// **'Teknoloji'**
  String get sectorTechnology;

  /// No description provided for @sectorLocked.
  ///
  /// In tr, this message translates to:
  /// **'Kilitli'**
  String get sectorLocked;

  /// No description provided for @statusProducing.
  ///
  /// In tr, this message translates to:
  /// **'Üretiyor'**
  String get statusProducing;

  /// No description provided for @statusIdle.
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get statusIdle;

  /// No description provided for @statusWaitingInput.
  ///
  /// In tr, this message translates to:
  /// **'Girdi Bekleniyor'**
  String get statusWaitingInput;

  /// No description provided for @statusStorageFull.
  ///
  /// In tr, this message translates to:
  /// **'Depo Dolu'**
  String get statusStorageFull;

  /// No description provided for @statusNoEnergy.
  ///
  /// In tr, this message translates to:
  /// **'Enerji Yok'**
  String get statusNoEnergy;

  /// No description provided for @produce.
  ///
  /// In tr, this message translates to:
  /// **'Üret'**
  String get produce;

  /// No description provided for @selectRecipe.
  ///
  /// In tr, this message translates to:
  /// **'Tarif seç'**
  String get selectRecipe;

  /// No description provided for @upgradeTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get upgradeTimeLabel;

  /// No description provided for @upgradeCostLabel.
  ///
  /// In tr, this message translates to:
  /// **'Maliyet'**
  String get upgradeCostLabel;

  /// No description provided for @upgrade.
  ///
  /// In tr, this message translates to:
  /// **'Yükselt'**
  String get upgrade;

  /// No description provided for @upgradeTo.
  ///
  /// In tr, this message translates to:
  /// **'Lv.{level} yap'**
  String upgradeTo(int level);

  /// No description provided for @level.
  ///
  /// In tr, this message translates to:
  /// **'Lv.'**
  String get level;

  /// No description provided for @manager.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici'**
  String get manager;

  /// No description provided for @managerNone.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Yok (Manuel)'**
  String get managerNone;

  /// No description provided for @managerIntern.
  ///
  /// In tr, this message translates to:
  /// **'Stajyer'**
  String get managerIntern;

  /// No description provided for @managerExpert.
  ///
  /// In tr, this message translates to:
  /// **'Uzman'**
  String get managerExpert;

  /// No description provided for @managerManager.
  ///
  /// In tr, this message translates to:
  /// **'Müdür'**
  String get managerManager;

  /// No description provided for @managerDirector.
  ///
  /// In tr, this message translates to:
  /// **'Direktör'**
  String get managerDirector;

  /// No description provided for @managerCEO.
  ///
  /// In tr, this message translates to:
  /// **'CEO'**
  String get managerCEO;

  /// No description provided for @assignManager.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Ata'**
  String get assignManager;

  /// No description provided for @managerSpeed.
  ///
  /// In tr, this message translates to:
  /// **'×{mult} hız'**
  String managerSpeed(String mult);

  /// No description provided for @sell.
  ///
  /// In tr, this message translates to:
  /// **'Sat'**
  String get sell;

  /// No description provided for @sellAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Sat ({qty})'**
  String sellAll(String qty);

  /// No description provided for @estimatedRevenue.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Gelir'**
  String get estimatedRevenue;

  /// No description provided for @available.
  ///
  /// In tr, this message translates to:
  /// **'Satılabilir'**
  String get available;

  /// No description provided for @reserved.
  ///
  /// In tr, this message translates to:
  /// **'Rezerve'**
  String get reserved;

  /// No description provided for @insufficientStock.
  ///
  /// In tr, this message translates to:
  /// **'Yetersiz stok'**
  String get insufficientStock;

  /// No description provided for @insufficientFunds.
  ///
  /// In tr, this message translates to:
  /// **'Yetersiz para'**
  String get insufficientFunds;

  /// No description provided for @storageFull.
  ///
  /// In tr, this message translates to:
  /// **'Depo dolu — önce sat'**
  String get storageFull;

  /// No description provided for @filterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get filterAll;

  /// No description provided for @filterRawAgri.
  ///
  /// In tr, this message translates to:
  /// **'🌾 Tarım'**
  String get filterRawAgri;

  /// No description provided for @filterRawAnimal.
  ///
  /// In tr, this message translates to:
  /// **'🐄 Hayvan'**
  String get filterRawAnimal;

  /// No description provided for @filterRawMining.
  ///
  /// In tr, this message translates to:
  /// **'⛏️ Maden'**
  String get filterRawMining;

  /// No description provided for @filterRawForest.
  ///
  /// In tr, this message translates to:
  /// **'🌲 Orman'**
  String get filterRawForest;

  /// No description provided for @filterProcessed.
  ///
  /// In tr, this message translates to:
  /// **'⚙️ İşlenmiş'**
  String get filterProcessed;

  /// No description provided for @filterManufactured.
  ///
  /// In tr, this message translates to:
  /// **'📦 Ürünler'**
  String get filterManufactured;

  /// No description provided for @inventoryTotalValue.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get inventoryTotalValue;

  /// No description provided for @inventoryCapacity.
  ///
  /// In tr, this message translates to:
  /// **'Kapasite'**
  String get inventoryCapacity;

  /// No description provided for @reservedNote.
  ///
  /// In tr, this message translates to:
  /// **'{qty} sözleşme rezervi'**
  String reservedNote(String qty);

  /// No description provided for @channelLocked.
  ///
  /// In tr, this message translates to:
  /// **'🔒 Bina gerekli'**
  String get channelLocked;

  /// No description provided for @unitPrice.
  ///
  /// In tr, this message translates to:
  /// **'Birim'**
  String get unitPrice;

  /// No description provided for @perMinute.
  ///
  /// In tr, this message translates to:
  /// **'/dk'**
  String get perMinute;

  /// No description provided for @hideZeroStock.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırları Gizle'**
  String get hideZeroStock;

  /// No description provided for @showZeroStock.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırları Göster'**
  String get showZeroStock;

  /// No description provided for @sortByQuantity.
  ///
  /// In tr, this message translates to:
  /// **'Miktar'**
  String get sortByQuantity;

  /// No description provided for @sortByValue.
  ///
  /// In tr, this message translates to:
  /// **'Değer'**
  String get sortByValue;

  /// No description provided for @sortByName.
  ///
  /// In tr, this message translates to:
  /// **'İsim'**
  String get sortByName;

  /// No description provided for @warehouseLv.
  ///
  /// In tr, this message translates to:
  /// **'Depo Sv.{level}'**
  String warehouseLv(int level);

  /// No description provided for @warehouseMaxLv.
  ///
  /// In tr, this message translates to:
  /// **'Maks Seviye'**
  String get warehouseMaxLv;

  /// No description provided for @upgradeWarehouseBtn.
  ///
  /// In tr, this message translates to:
  /// **'Yükselt'**
  String get upgradeWarehouseBtn;

  /// No description provided for @waitingForInput.
  ///
  /// In tr, this message translates to:
  /// **'⚠️ {product} bekleniyor'**
  String waitingForInput(String product);

  /// No description provided for @building_farm.
  ///
  /// In tr, this message translates to:
  /// **'Tarla'**
  String get building_farm;

  /// No description provided for @building_mine.
  ///
  /// In tr, this message translates to:
  /// **'Maden Ocağı'**
  String get building_mine;

  /// No description provided for @building_forest.
  ///
  /// In tr, this message translates to:
  /// **'Orman'**
  String get building_forest;

  /// No description provided for @building_ranch.
  ///
  /// In tr, this message translates to:
  /// **'Çiftlik'**
  String get building_ranch;

  /// No description provided for @building_quarry.
  ///
  /// In tr, this message translates to:
  /// **'Taş Ocağı'**
  String get building_quarry;

  /// No description provided for @building_mill.
  ///
  /// In tr, this message translates to:
  /// **'Değirmen'**
  String get building_mill;

  /// No description provided for @building_ironFactory.
  ///
  /// In tr, this message translates to:
  /// **'Demir Fabrikası'**
  String get building_ironFactory;

  /// No description provided for @building_woodProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap İşleme'**
  String get building_woodProcessing;

  /// No description provided for @building_dairyFactory.
  ///
  /// In tr, this message translates to:
  /// **'Süt Fabrikası'**
  String get building_dairyFactory;

  /// No description provided for @building_textileFactory.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil Fabrikası'**
  String get building_textileFactory;

  /// No description provided for @building_bakery.
  ///
  /// In tr, this message translates to:
  /// **'Fırın'**
  String get building_bakery;

  /// No description provided for @building_steelFactory.
  ///
  /// In tr, this message translates to:
  /// **'Çelik Fabrikası'**
  String get building_steelFactory;

  /// No description provided for @building_furnitureFactory.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya Fabrikası'**
  String get building_furnitureFactory;

  /// No description provided for @building_clothingFactory.
  ///
  /// In tr, this message translates to:
  /// **'Giysi Fabrikası'**
  String get building_clothingFactory;

  /// No description provided for @building_readyFoodFactory.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Gıda Fabrikası'**
  String get building_readyFoodFactory;

  /// No description provided for @building_machineFactory.
  ///
  /// In tr, this message translates to:
  /// **'Makine Fabrikası'**
  String get building_machineFactory;

  /// No description provided for @building_market.
  ///
  /// In tr, this message translates to:
  /// **'Market'**
  String get building_market;

  /// No description provided for @building_supermarket.
  ///
  /// In tr, this message translates to:
  /// **'Süpermarket'**
  String get building_supermarket;

  /// No description provided for @building_furnitureStore.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya Mağazası'**
  String get building_furnitureStore;

  /// No description provided for @building_clothingStore.
  ///
  /// In tr, this message translates to:
  /// **'Giyim Mağazası'**
  String get building_clothingStore;

  /// No description provided for @building_industrialStore.
  ///
  /// In tr, this message translates to:
  /// **'Endüstriyel Satış'**
  String get building_industrialStore;

  /// No description provided for @building_warehouse.
  ///
  /// In tr, this message translates to:
  /// **'Depo'**
  String get building_warehouse;

  /// No description provided for @building_truckGarage.
  ///
  /// In tr, this message translates to:
  /// **'Kamyon Garajı'**
  String get building_truckGarage;

  /// No description provided for @building_port.
  ///
  /// In tr, this message translates to:
  /// **'Liman'**
  String get building_port;

  /// No description provided for @building_airCargoTerminal.
  ///
  /// In tr, this message translates to:
  /// **'Hava Kargo Terminali'**
  String get building_airCargoTerminal;

  /// No description provided for @product_wheat.
  ///
  /// In tr, this message translates to:
  /// **'Buğday'**
  String get product_wheat;

  /// No description provided for @product_sugarCane.
  ///
  /// In tr, this message translates to:
  /// **'Şeker Kamışı'**
  String get product_sugarCane;

  /// No description provided for @product_cotton.
  ///
  /// In tr, this message translates to:
  /// **'Pamuk'**
  String get product_cotton;

  /// No description provided for @product_corn.
  ///
  /// In tr, this message translates to:
  /// **'Mısır'**
  String get product_corn;

  /// No description provided for @product_milk.
  ///
  /// In tr, this message translates to:
  /// **'Süt'**
  String get product_milk;

  /// No description provided for @product_wool.
  ///
  /// In tr, this message translates to:
  /// **'Yün'**
  String get product_wool;

  /// No description provided for @product_meat.
  ///
  /// In tr, this message translates to:
  /// **'Et'**
  String get product_meat;

  /// No description provided for @product_egg.
  ///
  /// In tr, this message translates to:
  /// **'Yumurta'**
  String get product_egg;

  /// No description provided for @product_ironOre.
  ///
  /// In tr, this message translates to:
  /// **'Demir Cevheri'**
  String get product_ironOre;

  /// No description provided for @product_copperOre.
  ///
  /// In tr, this message translates to:
  /// **'Bakır Cevheri'**
  String get product_copperOre;

  /// No description provided for @product_sand.
  ///
  /// In tr, this message translates to:
  /// **'Kum'**
  String get product_sand;

  /// No description provided for @product_coal.
  ///
  /// In tr, this message translates to:
  /// **'Kömür'**
  String get product_coal;

  /// No description provided for @product_stone.
  ///
  /// In tr, this message translates to:
  /// **'Taş'**
  String get product_stone;

  /// No description provided for @product_timber.
  ///
  /// In tr, this message translates to:
  /// **'Kereste'**
  String get product_timber;

  /// No description provided for @product_flour.
  ///
  /// In tr, this message translates to:
  /// **'Un'**
  String get product_flour;

  /// No description provided for @product_cornFlour.
  ///
  /// In tr, this message translates to:
  /// **'Mısır Unu'**
  String get product_cornFlour;

  /// No description provided for @product_sugar.
  ///
  /// In tr, this message translates to:
  /// **'Şeker'**
  String get product_sugar;

  /// No description provided for @product_cheese.
  ///
  /// In tr, this message translates to:
  /// **'Peynir'**
  String get product_cheese;

  /// No description provided for @product_yogurt.
  ///
  /// In tr, this message translates to:
  /// **'Yoğurt'**
  String get product_yogurt;

  /// No description provided for @product_fabric.
  ///
  /// In tr, this message translates to:
  /// **'Kumaş'**
  String get product_fabric;

  /// No description provided for @product_rawIron.
  ///
  /// In tr, this message translates to:
  /// **'Ham Demir'**
  String get product_rawIron;

  /// No description provided for @product_copper.
  ///
  /// In tr, this message translates to:
  /// **'Bakır'**
  String get product_copper;

  /// No description provided for @product_steel.
  ///
  /// In tr, this message translates to:
  /// **'Çelik'**
  String get product_steel;

  /// No description provided for @product_glass.
  ///
  /// In tr, this message translates to:
  /// **'Cam'**
  String get product_glass;

  /// No description provided for @product_processedWood.
  ///
  /// In tr, this message translates to:
  /// **'İşlenmiş Ahşap'**
  String get product_processedWood;

  /// No description provided for @product_bread.
  ///
  /// In tr, this message translates to:
  /// **'Ekmek'**
  String get product_bread;

  /// No description provided for @product_cake.
  ///
  /// In tr, this message translates to:
  /// **'Pasta'**
  String get product_cake;

  /// No description provided for @product_machine.
  ///
  /// In tr, this message translates to:
  /// **'Makine'**
  String get product_machine;

  /// No description provided for @product_electronic.
  ///
  /// In tr, this message translates to:
  /// **'Elektronik'**
  String get product_electronic;

  /// No description provided for @product_furniture.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya'**
  String get product_furniture;

  /// No description provided for @product_premiumFurniture.
  ///
  /// In tr, this message translates to:
  /// **'Premium Mobilya'**
  String get product_premiumFurniture;

  /// No description provided for @product_clothing.
  ///
  /// In tr, this message translates to:
  /// **'Giysi'**
  String get product_clothing;

  /// No description provided for @product_smartClothing.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Giysi'**
  String get product_smartClothing;

  /// No description provided for @product_burger.
  ///
  /// In tr, this message translates to:
  /// **'Burger'**
  String get product_burger;

  /// No description provided for @product_pizza.
  ///
  /// In tr, this message translates to:
  /// **'Pizza'**
  String get product_pizza;

  /// No description provided for @channel_market.
  ///
  /// In tr, this message translates to:
  /// **'Market'**
  String get channel_market;

  /// No description provided for @channel_supermarket.
  ///
  /// In tr, this message translates to:
  /// **'Süpermarket'**
  String get channel_supermarket;

  /// No description provided for @channel_furnitureStore.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya Mağazası'**
  String get channel_furnitureStore;

  /// No description provided for @channel_clothingStore.
  ///
  /// In tr, this message translates to:
  /// **'Giyim Mağazası'**
  String get channel_clothingStore;

  /// No description provided for @channel_electronicStore.
  ///
  /// In tr, this message translates to:
  /// **'Elektronik Mağazası'**
  String get channel_electronicStore;

  /// No description provided for @channel_industrialStore.
  ///
  /// In tr, this message translates to:
  /// **'Endüstriyel'**
  String get channel_industrialStore;

  /// No description provided for @channel_restaurant.
  ///
  /// In tr, this message translates to:
  /// **'Restoran'**
  String get channel_restaurant;

  /// No description provided for @channel_port.
  ///
  /// In tr, this message translates to:
  /// **'Liman İhracat'**
  String get channel_port;

  /// No description provided for @channel_airCargoTerminal.
  ///
  /// In tr, this message translates to:
  /// **'Hava Kargo'**
  String get channel_airCargoTerminal;

  /// No description provided for @vehicle_smallTruck.
  ///
  /// In tr, this message translates to:
  /// **'Küçük Kamyon'**
  String get vehicle_smallTruck;

  /// No description provided for @vehicle_bigTruck.
  ///
  /// In tr, this message translates to:
  /// **'Büyük Kamyon'**
  String get vehicle_bigTruck;

  /// No description provided for @vehicle_ship.
  ///
  /// In tr, this message translates to:
  /// **'Gemi'**
  String get vehicle_ship;

  /// No description provided for @vehicle_airCargo.
  ///
  /// In tr, this message translates to:
  /// **'Hava Kargo'**
  String get vehicle_airCargo;

  /// No description provided for @vehicle_train.
  ///
  /// In tr, this message translates to:
  /// **'Tren'**
  String get vehicle_train;

  /// No description provided for @contract_cityOrder.
  ///
  /// In tr, this message translates to:
  /// **'Şehir Siparişi'**
  String get contract_cityOrder;

  /// No description provided for @contract_b2bOrder.
  ///
  /// In tr, this message translates to:
  /// **'B2B Sipariş'**
  String get contract_b2bOrder;

  /// No description provided for @contract_vipOrder.
  ///
  /// In tr, this message translates to:
  /// **'VIP Müşteri'**
  String get contract_vipOrder;

  /// No description provided for @contract_exportContract.
  ///
  /// In tr, this message translates to:
  /// **'İhracat Sözleşmesi'**
  String get contract_exportContract;

  /// No description provided for @contract_urgentOrder.
  ///
  /// In tr, this message translates to:
  /// **'Acil Sipariş'**
  String get contract_urgentOrder;

  /// No description provided for @research_fertileSoil.
  ///
  /// In tr, this message translates to:
  /// **'Verimli Toprak'**
  String get research_fertileSoil;

  /// No description provided for @research_fertileSoil_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tarla üretimi +%20'**
  String get research_fertileSoil_desc;

  /// No description provided for @research_irrigation.
  ///
  /// In tr, this message translates to:
  /// **'Sulama Sistemi'**
  String get research_irrigation;

  /// No description provided for @research_irrigation_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tarla hızı +%15'**
  String get research_irrigation_desc;

  /// No description provided for @research_miningDrill.
  ///
  /// In tr, this message translates to:
  /// **'Maden Matkabı'**
  String get research_miningDrill;

  /// No description provided for @research_miningDrill_desc.
  ///
  /// In tr, this message translates to:
  /// **'Maden üretimi +%25'**
  String get research_miningDrill_desc;

  /// No description provided for @research_assemblyLine.
  ///
  /// In tr, this message translates to:
  /// **'Montaj Hattı'**
  String get research_assemblyLine;

  /// No description provided for @research_assemblyLine_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm üretim +%10'**
  String get research_assemblyLine_desc;

  /// No description provided for @research_qualityControl.
  ///
  /// In tr, this message translates to:
  /// **'Kalite Kontrol'**
  String get research_qualityControl;

  /// No description provided for @research_qualityControl_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm üretim +%15'**
  String get research_qualityControl_desc;

  /// No description provided for @research_logisticsSoftware.
  ///
  /// In tr, this message translates to:
  /// **'Lojistik Yazılımı'**
  String get research_logisticsSoftware;

  /// No description provided for @research_logisticsSoftware_desc.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşme slotu +1'**
  String get research_logisticsSoftware_desc;

  /// No description provided for @research_vehicleUpgrade.
  ///
  /// In tr, this message translates to:
  /// **'Araç Modernizasyonu'**
  String get research_vehicleUpgrade;

  /// No description provided for @research_vehicleUpgrade_desc.
  ///
  /// In tr, this message translates to:
  /// **'Araç kapasitesi +%20'**
  String get research_vehicleUpgrade_desc;

  /// No description provided for @research_exportNetwork.
  ///
  /// In tr, this message translates to:
  /// **'İhracat Ağı'**
  String get research_exportNetwork;

  /// No description provided for @research_exportNetwork_desc.
  ///
  /// In tr, this message translates to:
  /// **'İhracat kâr +%20'**
  String get research_exportNetwork_desc;

  /// No description provided for @research_fastSale.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Satış'**
  String get research_fastSale;

  /// No description provided for @research_fastSale_desc.
  ///
  /// In tr, this message translates to:
  /// **'Oto-satış aralığı 30→20sn'**
  String get research_fastSale_desc;

  /// No description provided for @research_warehouseOrg.
  ///
  /// In tr, this message translates to:
  /// **'Depo Organizasyonu'**
  String get research_warehouseOrg;

  /// No description provided for @research_warehouseOrg_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm ürün kapasiteleri +%25'**
  String get research_warehouseOrg_desc;

  /// No description provided for @research_smartShelf.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Raf Sistemi'**
  String get research_smartShelf;

  /// No description provided for @research_smartShelf_desc.
  ///
  /// In tr, this message translates to:
  /// **'Global ağırlık kapasitesi +%30'**
  String get research_smartShelf_desc;

  /// No description provided for @research_marketConnect.
  ///
  /// In tr, this message translates to:
  /// **'Pazar Bağlantısı'**
  String get research_marketConnect;

  /// No description provided for @research_marketConnect_desc.
  ///
  /// In tr, this message translates to:
  /// **'Oto-satış aralığı 20→15sn'**
  String get research_marketConnect_desc;

  /// No description provided for @research_smartReserve.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Rezerv'**
  String get research_smartReserve;

  /// No description provided for @research_smartReserve_desc.
  ///
  /// In tr, this message translates to:
  /// **'Sözleşme rezervi üretimi durdurmaz'**
  String get research_smartReserve_desc;

  /// No description provided for @research_passiveIncome.
  ///
  /// In tr, this message translates to:
  /// **'Pasif Gelir'**
  String get research_passiveIncome;

  /// No description provided for @research_passiveIncome_desc.
  ///
  /// In tr, this message translates to:
  /// **'Saatte +%0.5 faiz geliri'**
  String get research_passiveIncome_desc;

  /// No description provided for @research_automation.
  ///
  /// In tr, this message translates to:
  /// **'Otomasyon'**
  String get research_automation;

  /// No description provided for @research_automation_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm üretim +%30'**
  String get research_automation_desc;

  /// No description provided for @prestige_headStart.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Başlangıç'**
  String get prestige_headStart;

  /// No description provided for @prestige_headStart_desc.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıçta +50.000₺'**
  String get prestige_headStart_desc;

  /// No description provided for @prestige_productionMastery.
  ///
  /// In tr, this message translates to:
  /// **'Üretim Ustalığı'**
  String get prestige_productionMastery;

  /// No description provided for @prestige_productionMastery_desc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm üretim +%25'**
  String get prestige_productionMastery_desc;

  /// No description provided for @prestige_heritageStorage.
  ///
  /// In tr, this message translates to:
  /// **'Miras Deposu'**
  String get prestige_heritageStorage;

  /// No description provided for @prestige_heritageStorage_desc.
  ///
  /// In tr, this message translates to:
  /// **'En değerli 3 ürünün %20\'si korunur'**
  String get prestige_heritageStorage_desc;

  /// No description provided for @prestige_veteranManager.
  ///
  /// In tr, this message translates to:
  /// **'Deneyimli Yönetici'**
  String get prestige_veteranManager;

  /// No description provided for @prestige_veteranManager_desc.
  ///
  /// In tr, this message translates to:
  /// **'Yöneticiler prestij sonrası kalır'**
  String get prestige_veteranManager_desc;

  /// No description provided for @prestige_researchCarry.
  ///
  /// In tr, this message translates to:
  /// **'Araştırma Mirası'**
  String get prestige_researchCarry;

  /// No description provided for @prestige_researchCarry_desc.
  ///
  /// In tr, this message translates to:
  /// **'Araştırmaların %50\'si aktarılır'**
  String get prestige_researchCarry_desc;

  /// No description provided for @prestige_diamondBonus.
  ///
  /// In tr, this message translates to:
  /// **'Elmas Bonusu'**
  String get prestige_diamondBonus;

  /// No description provided for @prestige_diamondBonus_desc.
  ///
  /// In tr, this message translates to:
  /// **'Elmas kazanımı +%20'**
  String get prestige_diamondBonus_desc;

  /// No description provided for @offlineEarnings.
  ///
  /// In tr, this message translates to:
  /// **'Çevrimdışı Kazanım'**
  String get offlineEarnings;

  /// No description provided for @offlineEarningsBody.
  ///
  /// In tr, this message translates to:
  /// **'{duration} süre çevrimdışıydın.\n{summary}'**
  String offlineEarningsBody(String duration, String summary);

  /// No description provided for @sectorUnlocked.
  ///
  /// In tr, this message translates to:
  /// **'{sector} Sektörü Açıldı!'**
  String sectorUnlocked(String sector);

  /// No description provided for @units.
  ///
  /// In tr, this message translates to:
  /// **'birim'**
  String get units;

  /// No description provided for @capacity.
  ///
  /// In tr, this message translates to:
  /// **'Kapasite'**
  String get capacity;

  /// No description provided for @totalValue.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Değer'**
  String get totalValue;

  /// No description provided for @fillPercent.
  ///
  /// In tr, this message translates to:
  /// **'Doluluk'**
  String get fillPercent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
