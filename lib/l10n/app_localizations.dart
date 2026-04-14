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
  /// **'Tarım'**
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

  /// No description provided for @upgrade.
  ///
  /// In tr, this message translates to:
  /// **'Yükselt'**
  String get upgrade;

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

  /// No description provided for @sell.
  ///
  /// In tr, this message translates to:
  /// **'Sat'**
  String get sell;

  /// No description provided for @sellAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Sat'**
  String get sellAll;

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
