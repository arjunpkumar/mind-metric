// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get _locale {
    return Intl.message('en', name: '_locale', desc: '', args: []);
  }

  /// `FlutterBase`
  String get labelFlutterBase {
    return Intl.message(
      'FlutterBase',
      name: 'labelFlutterBase',
      desc: '',
      args: [],
    );
  }

  /// `FlutterBase`
  String get titleApp {
    return Intl.message('FlutterBase', name: 'titleApp', desc: '', args: []);
  }

  /// `Home`
  String get titleHome {
    return Intl.message('Home', name: 'titleHome', desc: '', args: []);
  }

  /// `Please Authenticate Using Biometric or Device Lock Mechanism`
  String get messagePleaseAuthenticateUsingBiometric {
    return Intl.message(
      'Please Authenticate Using Biometric or Device Lock Mechanism',
      name: 'messagePleaseAuthenticateUsingBiometric',
      desc: '',
      args: [],
    );
  }

  /// `Error Loading The Web Page. Try Again Later`
  String get errWebView {
    return Intl.message(
      'Error Loading The Web Page. Try Again Later',
      name: 'errWebView',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get hintDefaultSearch {
    return Intl.message(
      'Search...',
      name: 'hintDefaultSearch',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get btnUpdate {
    return Intl.message('Update', name: 'btnUpdate', desc: '', args: []);
  }

  /// `Later`
  String get btnLater {
    return Intl.message('Later', name: 'btnLater', desc: '', args: []);
  }

  /// `View`
  String get btnView {
    return Intl.message('View', name: 'btnView', desc: '', args: []);
  }

  /// `Ok`
  String get btnOk {
    return Intl.message('Ok', name: 'btnOk', desc: '', args: []);
  }

  /// `Cancel`
  String get btnCancel {
    return Intl.message('Cancel', name: 'btnCancel', desc: '', args: []);
  }

  /// `{username} is {status}`
  String userStatus(String username, String status) {
    return Intl.message(
      '$username is $status',
      name: 'userStatus',
      desc: '',
      args: [username, status],
    );
  }

  /// `Update Required`
  String get titleImmediateUpdate {
    return Intl.message(
      'Update Required',
      name: 'titleImmediateUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Kindly update this app to the latest version to improve its compatibility.`
  String get messageImmediateUpdate {
    return Intl.message(
      'Kindly update this app to the latest version to improve its compatibility.',
      name: 'messageImmediateUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Update Available`
  String get titleFlexibleUpdate {
    return Intl.message(
      'Update Available',
      name: 'titleFlexibleUpdate',
      desc: '',
      args: [],
    );
  }

  /// `There is a new version available for this app. Try out new features by updating the app.`
  String get messageFlexibleUpdate {
    return Intl.message(
      'There is a new version available for this app. Try out new features by updating the app.',
      name: 'messageFlexibleUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Something Went Wrong. Please Try Again Later`
  String get labelSomethingWentWrong {
    return Intl.message(
      'Something Went Wrong. Please Try Again Later',
      name: 'labelSomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get labelOk {
    return Intl.message('Ok', name: 'labelOk', desc: '', args: []);
  }

  /// `Image`
  String get labelImage {
    return Intl.message('Image', name: 'labelImage', desc: '', args: []);
  }

  /// `Document`
  String get labelDocument {
    return Intl.message('Document', name: 'labelDocument', desc: '', args: []);
  }

  /// `No Network Available`
  String get labelNoNetworkAvailable {
    return Intl.message(
      'No Network Available',
      name: 'labelNoNetworkAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel the {label}?`
  String labelCancelXConfirmation(String label) {
    return Intl.message(
      'Are you sure you want to cancel the $label?',
      name: 'labelCancelXConfirmation',
      desc: '',
      args: [label],
    );
  }

  /// `Yes, Cancel`
  String get btnYesCancel {
    return Intl.message(
      'Yes, Cancel',
      name: 'btnYesCancel',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get labelNoData {
    return Intl.message('No Data', name: 'labelNoData', desc: '', args: []);
  }

  /// `Yes`
  String get btnYes {
    return Intl.message('Yes', name: 'btnYes', desc: '', args: []);
  }

  /// `No`
  String get btnNo {
    return Intl.message('No', name: 'btnNo', desc: '', args: []);
  }

  /// `No Connection`
  String get labelNoConnection {
    return Intl.message(
      'No Connection',
      name: 'labelNoConnection',
      desc: '',
      args: [],
    );
  }

  /// `Please Check Your Internet Connection`
  String get labelPleaseCheckYourInternetConnection {
    return Intl.message(
      'Please Check Your Internet Connection',
      name: 'labelPleaseCheckYourInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get btnTryAgain {
    return Intl.message('Try Again', name: 'btnTryAgain', desc: '', args: []);
  }

  /// `Delete`
  String get btnDelete {
    return Intl.message('Delete', name: 'btnDelete', desc: '', args: []);
  }

  /// `Login`
  String get titleLogin {
    return Intl.message('Login', name: 'titleLogin', desc: '', args: []);
  }

  /// `Logout`
  String get titleLogout {
    return Intl.message('Logout', name: 'titleLogout', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
