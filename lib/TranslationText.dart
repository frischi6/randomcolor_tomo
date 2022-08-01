import 'package:get/get.dart';

class TranslationText extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'de_DE': {
          'test': 'deutschh',
          'ungültigeAngaben': 'Deine Angaben sind ungültig.',
          'bereit': 'Mach dich bereit!\n',
          'selFarben': 'Die Farben, mit denen du trainieren möchtest?',
          'selAnzFarben': 'Anzahl Farben, die aufs Mal angezeigt werden?',
          'selWechselSek': 'Farbwechsel nach wie vielen Sekunden?',
          'selDurchlauf': 'Dauer eines Durchlaufs?',
          'min': 'Min.',
          'sek': 'Sek.',
          'selPause': 'Dauer einer Pause?',
          'selAnzDurchg': 'Anzahl Durchgänge total?',
          'start': 'Start',
          'hauptmenü': 'Hauptmenü',
          'neustart': 'Neustart',
          'pause': 'Pause',
          'trainingEnde': 'Trainingsrunde beendet!',
        },
        'en_US': {
          'test': 'englishhhh',
          'ungültigeAngaben': 'Your data is invalid',
          'bereit': 'get ready!\n',
          'selFarben': 'The colors you want to train with?',
          'selAnzFarben': 'Number of colors displayed at a time?',
          'selWechselSek': 'Color change after how many seconds?',
          'selDurchlauf': 'Duration of a run?',
          'min': 'min',
          'sek': 'sec',
          'selPause': 'Duration of a break?',
          'selAnzDurchg': 'Total number of passes?',
          'start': 'start',
          'hauptmenü': 'main menu',
          'neustart': 'restart',
          'pause': 'break',
          'trainingEnde': 'Training session completed!',
        }
      };
}
