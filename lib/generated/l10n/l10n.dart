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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Maestro`
  String get appName {
    return Intl.message(
      'Maestro',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy Listening To Music`
  String get enjoy {
    return Intl.message(
      'Enjoy Listening To Music',
      name: 'enjoy',
      desc: '',
      args: [],
    );
  }

  /// `Maestro is an innovative music application for Android and iOS devices, created for true music lovers. The app provides a unique experience in managing and listening to music, combining an elegant interface, advanced technology and rich functionality.`
  String get enjoyTitle {
    return Intl.message(
      'Maestro is an innovative music application for Android and iOS devices, created for true music lovers. The app provides a unique experience in managing and listening to music, combining an elegant interface, advanced technology and rich functionality.',
      name: 'enjoyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Choose Mode`
  String get chooseMode {
    return Intl.message(
      'Choose Mode',
      name: 'chooseMode',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Maestro is a proprietary Russian audio streaming and media services provider`
  String get enjoyTitleSignUpSignIn {
    return Intl.message(
      'Maestro is a proprietary Russian audio streaming and media services provider',
      name: 'enjoyTitleSignUpSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message(
      'Full name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `By clicking Next you agree to the `
  String get nextYouAgree {
    return Intl.message(
      'By clicking Next you agree to the ',
      name: 'nextYouAgree',
      desc: '',
      args: [],
    );
  }

  /// `terms of use`
  String get termsOfUse {
    return Intl.message(
      'terms of use',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// ` of user data and sending you advertising notices about our services. Please review our `
  String get dataSendingAdvertising {
    return Intl.message(
      ' of user data and sending you advertising notices about our services. Please review our ',
      name: 'dataSendingAdvertising',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy.`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy.',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Do you have an account?`
  String get youHaveAccount {
    return Intl.message(
      'Do you have an account?',
      name: 'youHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Not all fields are filled in!`
  String get allFieldsFilled {
    return Intl.message(
      'Not all fields are filled in!',
      name: 'allFieldsFilled',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Successful`
  String get signInSuccessful {
    return Intl.message(
      'Sign In Successful',
      name: 'signInSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Not a Member?`
  String get notMember {
    return Intl.message(
      'Not a Member?',
      name: 'notMember',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get registerNow {
    return Intl.message(
      'Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Signin was Successful`
  String get signinWasSuccessful {
    return Intl.message(
      'Signin was Successful',
      name: 'signinWasSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Feed`
  String get feed {
    return Intl.message(
      'Feed',
      name: 'feed',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade`
  String get upgradeNav {
    return Intl.message(
      'Upgrade',
      name: 'upgradeNav',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get news {
    return Intl.message(
      'News',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get videos {
    return Intl.message(
      'Videos',
      name: 'videos',
      desc: '',
      args: [],
    );
  }

  /// `Artists`
  String get artists {
    return Intl.message(
      'Artists',
      name: 'artists',
      desc: '',
      args: [],
    );
  }

  /// `Podcasts`
  String get podcasts {
    return Intl.message(
      'Podcasts',
      name: 'podcasts',
      desc: '',
      args: [],
    );
  }

  /// `Concerts`
  String get concerts {
    return Intl.message(
      'Concerts',
      name: 'concerts',
      desc: '',
      args: [],
    );
  }

  /// `Clear search history`
  String get clearSearchHistory {
    return Intl.message(
      'Clear search history',
      name: 'clearSearchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Nothing happened yet`
  String get nothingHappenedYet {
    return Intl.message(
      'Nothing happened yet',
      name: 'nothingHappenedYet',
      desc: '',
      args: [],
    );
  }

  /// `Interact with people you follow to get some activities and updates`
  String get nothingHappenedYetSubtitle {
    return Intl.message(
      'Interact with people you follow to get some activities and updates',
      name: 'nothingHappenedYetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Inbox`
  String get inbox {
    return Intl.message(
      'Inbox',
      name: 'inbox',
      desc: '',
      args: [],
    );
  }

  /// `Error loading profile`
  String get errorLoadingProfile {
    return Intl.message(
      'Error loading profile',
      name: 'errorLoadingProfile',
      desc: '',
      args: [],
    );
  }

  /// `No user data found`
  String get noUserDataFound {
    return Intl.message(
      'No user data found',
      name: 'noUserDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Hello! {userName}! Thank you for downloading our application!`
  String helloUserMessage(Object userName) {
    return Intl.message(
      'Hello! $userName! Thank you for downloading our application!',
      name: 'helloUserMessage',
      desc: '',
      args: [userName],
    );
  }

  /// `No name`
  String get noName {
    return Intl.message(
      'No name',
      name: 'noName',
      desc: '',
      args: [],
    );
  }

  /// `Select theme`
  String get selectTheme {
    return Intl.message(
      'Select theme',
      name: 'selectTheme',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get selectLanguage {
    return Intl.message(
      'Select language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russianLanguage {
    return Intl.message(
      'Russian',
      name: 'russianLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get englishLanguage {
    return Intl.message(
      'English',
      name: 'englishLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanishLanguage {
    return Intl.message(
      'Spanish',
      name: 'spanishLanguage',
      desc: '',
      args: [],
    );
  }

  /// `No Data Found!`
  String get noDataFound {
    return Intl.message(
      'No Data Found!',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get wentWrong {
    return Intl.message(
      'Something went wrong.',
      name: 'wentWrong',
      desc: '',
      args: [],
    );
  }

  /// `guest`
  String get guest {
    return Intl.message(
      'guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `More of what you like`
  String get moreWhatYouLike {
    return Intl.message(
      'More of what you like',
      name: 'moreWhatYouLike',
      desc: '',
      args: [],
    );
  }

  /// `Buzzing Electronic`
  String get buzzingElectronic {
    return Intl.message(
      'Buzzing Electronic',
      name: 'buzzingElectronic',
      desc: '',
      args: [],
    );
  }

  /// `Mixed for {userName}`
  String mixedFor(Object userName) {
    return Intl.message(
      'Mixed for $userName',
      name: 'mixedFor',
      desc: '',
      args: [userName],
    );
  }

  /// `Made for {userName}`
  String madeFor(Object userName) {
    return Intl.message(
      'Made for $userName',
      name: 'madeFor',
      desc: '',
      args: [userName],
    );
  }

  /// `Discover with Stations`
  String get discoverStations {
    return Intl.message(
      'Discover with Stations',
      name: 'discoverStations',
      desc: '',
      args: [],
    );
  }

  /// `Trending by genre`
  String get trendingGenre {
    return Intl.message(
      'Trending by genre',
      name: 'trendingGenre',
      desc: '',
      args: [],
    );
  }

  /// `Trending Music`
  String get trendingMusic {
    return Intl.message(
      'Trending Music',
      name: 'trendingMusic',
      desc: '',
      args: [],
    );
  }

  /// `Curated to your taste`
  String get curatedYourTaste {
    return Intl.message(
      'Curated to your taste',
      name: 'curatedYourTaste',
      desc: '',
      args: [],
    );
  }

  /// `Artists to watch out for`
  String get artistsWatchOutFor {
    return Intl.message(
      'Artists to watch out for',
      name: 'artistsWatchOutFor',
      desc: '',
      args: [],
    );
  }

  /// `New!`
  String get newArtists {
    return Intl.message(
      'New!',
      name: 'newArtists',
      desc: '',
      args: [],
    );
  }

  /// `UPGRADE`
  String get upgrade {
    return Intl.message(
      'UPGRADE',
      name: 'upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Additional Info`
  String get additionalInfo {
    return Intl.message(
      'Additional Info',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Select Gender`
  String get selectGender {
    return Intl.message(
      'Select Gender',
      name: 'selectGender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Select Age`
  String get selectAge {
    return Intl.message(
      'Select Age',
      name: 'selectAge',
      desc: '',
      args: [],
    );
  }

  /// `Google sign-in successful!`
  String get googleSignInSuccess {
    return Intl.message(
      'Google sign-in successful!',
      name: 'googleSignInSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Google sign-in failed: {error}`
  String googleSignInFailed(Object error) {
    return Intl.message(
      'Google sign-in failed: $error',
      name: 'googleSignInFailed',
      desc: '',
      args: [error],
    );
  }

  /// `No date available`
  String get noDateAvailable {
    return Intl.message(
      'No date available',
      name: 'noDateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign-Up was Successful`
  String get googleSignUpSuccess {
    return Intl.message(
      'Google Sign-Up was Successful',
      name: 'googleSignUpSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Apple Sign-In was Successful`
  String get appleSignInSuccess {
    return Intl.message(
      'Apple Sign-In was Successful',
      name: 'appleSignInSuccess',
      desc: '',
      args: [],
    );
  }

  /// `New message`
  String get newMessage {
    return Intl.message(
      'New message',
      name: 'newMessage',
      desc: '',
      args: [],
    );
  }

  /// `Type your message`
  String get typeYourMessage {
    return Intl.message(
      'Type your message',
      name: 'typeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `No user logged in`
  String get noUserLoggedIn {
    return Intl.message(
      'No user logged in',
      name: 'noUserLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Deleted user`
  String get deletedUser {
    return Intl.message(
      'Deleted user',
      name: 'deletedUser',
      desc: '',
      args: [],
    );
  }

  /// `Show all notifications`
  String get showAllNotify {
    return Intl.message(
      'Show all notifications',
      name: 'showAllNotify',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image`
  String get chooseImage {
    return Intl.message(
      'Choose Image',
      name: 'chooseImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load image`
  String get failedLoadImage {
    return Intl.message(
      'Failed to load image',
      name: 'failedLoadImage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Albums`
  String get albums {
    return Intl.message(
      'Albums',
      name: 'albums',
      desc: '',
      args: [],
    );
  }

  /// `Photos, People, Places...`
  String get photosPeoplePlaces {
    return Intl.message(
      'Photos, People, Places...',
      name: 'photosPeoplePlaces',
      desc: '',
      args: [],
    );
  }

  /// `No images found`
  String get noImagesFound {
    return Intl.message(
      'No images found',
      name: 'noImagesFound',
      desc: '',
      args: [],
    );
  }

  /// `Describe your track`
  String get describeYourTrack {
    return Intl.message(
      'Describe your track',
      name: 'describeYourTrack',
      desc: '',
      args: [],
    );
  }

  /// `Add a caption to your post (optional)`
  String get addCaptionYourPost {
    return Intl.message(
      'Add a caption to your post (optional)',
      name: 'addCaptionYourPost',
      desc: '',
      args: [],
    );
  }

  /// `No file selected`
  String get noFileSelected {
    return Intl.message(
      'No file selected',
      name: 'noFileSelected',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Pick genre`
  String get pickGenre {
    return Intl.message(
      'Pick genre',
      name: 'pickGenre',
      desc: '',
      args: [],
    );
  }

  /// `Select genre`
  String get selectGenre {
    return Intl.message(
      'Select genre',
      name: 'selectGenre',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Caption`
  String get caption {
    return Intl.message(
      'Caption',
      name: 'caption',
      desc: '',
      args: [],
    );
  }

  /// `Uploading`
  String get uploading {
    return Intl.message(
      'Uploading',
      name: 'uploading',
      desc: '',
      args: [],
    );
  }

  /// `Your track is ready. Tap Save to continue.`
  String get yourTrackReady {
    return Intl.message(
      'Your track is ready. Tap Save to continue.',
      name: 'yourTrackReady',
      desc: '',
      args: [],
    );
  }

  /// `Cancel upload`
  String get cancelUpload {
    return Intl.message(
      'Cancel upload',
      name: 'cancelUpload',
      desc: '',
      args: [],
    );
  }

  /// `Uploading this track will be stopped and deleted from Maestro.`
  String get uploadingTrackStoppedDeleted {
    return Intl.message(
      'Uploading this track will be stopped and deleted from Maestro.',
      name: 'uploadingTrackStoppedDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Resume`
  String get resume {
    return Intl.message(
      'Resume',
      name: 'resume',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Please make sure your internet is available`
  String get pleaseSureInternetAvailable {
    return Intl.message(
      'Please make sure your internet is available',
      name: 'pleaseSureInternetAvailable',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Show all notifications`
  String get showAllNotifications {
    return Intl.message(
      'Show all notifications',
      name: 'showAllNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Followings`
  String get followings {
    return Intl.message(
      'Followings',
      name: 'followings',
      desc: '',
      args: [],
    );
  }

  /// `Reposts`
  String get reposts {
    return Intl.message(
      'Reposts',
      name: 'reposts',
      desc: '',
      args: [],
    );
  }

  /// `Latest from artists you follow`
  String get latestArtistsFollow {
    return Intl.message(
      'Latest from artists you follow',
      name: 'latestArtistsFollow',
      desc: '',
      args: [],
    );
  }

  /// `New releases based on your taste. Updated every day`
  String get newReleases {
    return Intl.message(
      'New releases based on your taste. Updated every day',
      name: 'newReleases',
      desc: '',
      args: [],
    );
  }

  /// `DAILY DROPS`
  String get dailyDrops {
    return Intl.message(
      'DAILY DROPS',
      name: 'dailyDrops',
      desc: '',
      args: [],
    );
  }

  /// `The best of Maestro just for you. Updated every Monday`
  String get updatedEveryMonday {
    return Intl.message(
      'The best of Maestro just for you. Updated every Monday',
      name: 'updatedEveryMonday',
      desc: '',
      args: [],
    );
  }

  /// `WEEKLY WAVE`
  String get weeklyWave {
    return Intl.message(
      'WEEKLY WAVE',
      name: 'weeklyWave',
      desc: '',
      args: [],
    );
  }

  /// `Local Audio Playlist`
  String get localAudioPlaylist {
    return Intl.message(
      'Local Audio Playlist',
      name: 'localAudioPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `LocalList`
  String get localList {
    return Intl.message(
      'LocalList',
      name: 'localList',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message(
      'See All',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Recents`
  String get recents {
    return Intl.message(
      'Recents',
      name: 'recents',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get browse {
    return Intl.message(
      'Browse',
      name: 'browse',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
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
