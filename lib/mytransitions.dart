import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'Select Language': 'Select Language',
      'No branch name': 'No branch name',
      'Failed to load image': 'Failed to load image',
    'Success': 'Success',
    'Language changed to': 'Language changed to',

    },
    'hi': {
      'Select Language': 'भाषा चुनें',
      'No branch name': 'कोई शाखा नहीं',
      'Failed to load image': 'छवि लोड करने में विफल',
      'Success': 'सफलता',
      'Language changed to': 'भाषा बदली गई'
    },
    'te': {
      'Select Language': 'భాషను ఎంచుకోండి',
      'No branch name': 'శాఖ పేరు లేదు',
      'Failed to load image': 'చిత్రాన్ని లోడ్ చేయడం విఫలమైంది',
    },
    // Add more languages as needed
  };
}