import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randomcolor_tomo/ColorsCheckbox.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:randomcolor_tomo/TranslationText.dart';

void main() {
  runApp(MyApp());
}

//damit primaryswatch in materialapp themedata customized color haben kann
Map<int, Color> color = {
  50: Color.fromRGBO(188, 250, 0, .1),
  100: Color.fromRGBO(188, 250, 0, .2),
  200: Color.fromRGBO(188, 250, 0, .3),
  300: Color.fromRGBO(188, 250, 0, .4),
  400: Color.fromRGBO(188, 250, 0, .5),
  500: Color.fromRGBO(188, 250, 0, .6),
  600: Color.fromRGBO(188, 250, 0, .7),
  700: Color.fromRGBO(188, 250, 0, .8),
  800: Color.fromRGBO(188, 250, 0, .9),
  900: Color.fromRGBO(188, 250, 0, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MaterialColor colorCustom = MaterialColor(0xffbcfa00, color);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Skillatics',
      theme: ThemeData(
        primarySwatch: colorCustom,
        unselectedWidgetColor: Colors.black,
      ),
      home: MyHomePage(title: 'Skillatics'),
      translations: TranslationText(),
      locale: Locale('de', 'DE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String hexxcode = '0xff';
  int theHexCode = 0;
  String textFehlermeldung = '';
  bool isGerman = true;
  String currentCountry = "GB"; //flagge die oben rechts angezeigt wird

  String testString = 'test';
  String testStringLang = 'spa';

//Variabeln für Einstellungen, siehe Skizze, werden an Page2 übergeben
  int anzColorsOnPage = 2;
  int secChangeColor = 5;
  int secLengthRound = 210; //=roundDisplayedSec+roundDisplayedMin in sekunden
  int secLengthRest = 90; //=restDisplayedSec+restDisplayedMin in sekunden
  int anzRounds = 5;

  var selectedArrows = [];

//Werte, die in applescroll angezeigt werden aber nicht so an Page2 übergeben werden können weil Min und Sec gemischt
  int roundDisplayedSec = 30;
  int roundDisplayedMin = 3;
  int restDisplayedSec = 30;
  int restDisplayedMin = 1;

//Checkboxen, mit allen gewünschten Farben
  var selectedColors = [];

  String countryFlag() {
    //https://stackoverflow.com/questions/56999448/display-country-flag-character-in-flutter
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    int firstChar = currentCountry.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = currentCountry.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    return emoji;
  }

  //Wechsel auf Seite 2 mit den angezeigten Farben
  void _changeToPage2() {
    organizeArrowsColors();
    //überprüft, ob Werte in Range sind
    if (this.selectedColors.length >= this.anzColorsOnPage &&
        this.secLengthRound > 0 &&
        this.secLengthRest > 0) {
      showDialog(
        context: context,
        builder: (_) => alertDialogCD(),
      );

      Timer(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RandomColorPage2(
              listSelectedColors: this.selectedColors,
              listSelectedArrows: this.selectedArrows,
              anzColorsOnPage: this.anzColorsOnPage,
              secChangeColor: this.secChangeColor,
              secLengthRound: this.secLengthRound,
              secLengthRest: this.secLengthRest,
              anzRounds: this.anzRounds,
            ),
          ),
        );
      });
    } else {
      //Fehlermeldung falls Eingaben nicht korrekt
      setState(() {
        this.textFehlermeldung = 'ungültigeAngaben'.tr;
      });
    }
  }

  /**
   * Initializes selectedArrows[] and sets correct color for arrows in selectedcolors that there are only hex and no strings like 'north' etc
   */
  void organizeArrowsColors() {
    for (int i = 0; i < selectedColors.length; i++) {
      if (selectedColors[i].length != 6) {
        selectedArrows.add(selectedColors[i]);
        selectedColors[i] =
            'fefefe'; //weisser hintergrund aber nicht ffffff damit später erkennbar dass dort arrows angezeigt werden müssen
      } //else ist bereits ein hexcode in selectedColors und kein arrow
    }
  }

  /**
   * Returnt einen AlertDialog, damit der User Zeit hat auf Position zu gehen
   */
  Widget alertDialogCD() {
    return AlertDialog(
      content: Center(
        heightFactor: 1.2,
        child: Text('bereit'.tr),
      ),
    );
  }

  void initState() {
    super.initState();
  }

  // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (isGerman) {
                  Get.updateLocale(Locale('en', 'US'));
                  isGerman = false;
                  this.currentCountry = "DE";
                } else {
                  //is English
                  Get.updateLocale(Locale('de', 'DE'));
                  isGerman = true;
                  this.currentCountry = "GB";
                }
                setState(() {
                  testString = 'test'.tr;
                  testStringLang = testString;
                });
              },
              child: Text(
                countryFlag(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
          centerTitle: true,
          automaticallyImplyLeading: false //damit kein zurück-Pfeil oben links
          ),
      body: SingleChildScrollView(
        child: //damit scrollable wenn content grösser ist als bildschirmgrösses
            Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Checkbox - Mit welchen Farben trainieren
              //SizedBox(height: 20,),
              Text(
                'selFarben'.tr,
                style: TextStyle(fontSize: 15),
              ),
              Text(testString.tr),
              SizedBox(height: 18),
              ConstrainedBox(
                constraints: BoxConstraints(),
                //evtl. noch flexibel machen und nicht hardcode falls sich anzahl ändert oder format des bildschirms
                child: MultiSelectContainer(
                  prefix: MultiSelectPrefix(
                      selectedPrefix: const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  )),
                  items: [
                    MultiSelectCard(
                      clipBehavior: Clip.antiAlias,
                      child: Text(testStringLang),
                      value: 'f5ff00',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: 'ff5f1f',
                      label: 'Orange'.tr,
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: 'ff0000',
                      label: 'Rot',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: 'f500ab',
                      label: 'Pink',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.pink.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '6600a1',
                      label: 'Violett',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 102, 0, 161)
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 102, 0, 161),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '00b2ee',
                      label: 'Hellblau',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '00008b',
                      label: 'Dunkelblau',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 00, 0, 139)
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 00, 0, 139),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '00ee00',
                      label: 'Hellgrün',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '006400',
                      label: 'Dunkelgrün',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color:
                                Color.fromARGB(255, 0, 100, 0).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 100, 0),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '00868b',
                      label: 'Türkis',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 134, 139)
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 134, 139),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: 'a8a8a8',
                      label: 'Grau',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 168, 168, 168)
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 168, 168, 168),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: '000000',
                      label: 'Schwarz',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10))),
                      textStyles: MultiSelectItemTextStyles(
                        selectedTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'bd9b16',
                      label: 'Gold',
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 189, 155, 22)
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 189, 155, 22),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    MultiSelectCard(
                      value: 'ffffff',
                      label: 'Weiss',
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 203, 203, 203)
                                .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'north',
                      child: Icon(Icons.north),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'east',
                      child: Icon(Icons.east),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'south',
                      child: Icon(Icons.south),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'west',
                      child: Icon(Icons.west),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'northwest',
                      child: Icon(Icons.north_west),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'northeast',
                      child: Icon(Icons.north_east),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'southeast',
                      child: Icon(Icons.south_east),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    MultiSelectCard(
                      value: 'southwest',
                      child: Icon(Icons.south_west),
                      textStyles: const MultiSelectItemTextStyles(
                          selectedTextStyle: TextStyle(color: Colors.black)),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          selectedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all())),
                      prefix: MultiSelectPrefix(
                        selectedPrefix: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChange: (allSelectedItems, selectedItem) {
                    this.selectedColors = allSelectedItems;
                  },
                ),
              ),
              SizedBox(height: 15),
              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

              //Dropdown - wie viele Farben aufs Mal angezeigt werden
              SizedBox(height: 12),
              Text(
                'selAnzFarben'.tr,
                style: TextStyle(fontSize: 15),
              ),
              DropdownButton<int>(
                value: anzColorsOnPage,
                onChanged: (int? val) {
                  setState(
                    () {
                      anzColorsOnPage = val!;
                    },
                  );
                },
                items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                    .map<DropdownMenuItem<int>>(
                  (int val) {
                    return DropdownMenuItem<int>(
                      value: val,
                      child: Text(val.toString()),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Farbwechsel nach wie vielen Sekunden
              SizedBox(height: 12),
              Text(
                'selWechselSek'.tr,
                style: TextStyle(fontSize: 15),
              ),
              NumberPicker(
                value: secChangeColor,
                minValue: 1,
                maxValue: 59,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),
                textStyle: TextStyle(fontSize: 13),
                onChanged: (value) => setState(() => secChangeColor = value),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Dauer eines Durchlaufs
              SizedBox(height: 12),
              Text(
                'selDurchlauf'.tr,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 18,
              ), //Für Abstand
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      NumberPicker(
                        value: roundDisplayedMin,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            roundDisplayedMin = value;
                            secLengthRound =
                                roundDisplayedSec + roundDisplayedMin * 60;
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('min'.tr),
                  Column(
                    children: [
                      NumberPicker(
                        value: roundDisplayedSec,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            roundDisplayedSec = value;
                            secLengthRound =
                                roundDisplayedSec + roundDisplayedMin * 60;
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('sek'.tr),
                ],
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Dauer einer Pause
              SizedBox(height: 12),
              Text(
                'selPause'.tr,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 18,
              ), //Für Abstand
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      NumberPicker(
                        value: restDisplayedMin,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            restDisplayedMin = value;
                            secLengthRest = restDisplayedSec +
                                restDisplayedMin *
                                    60; //als Methode weil 2x vorkommt?
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('min'.tr),
                  Column(
                    children: [
                      NumberPicker(
                        value: restDisplayedSec,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        itemHeight: 20,
                        selectedTextStyle: TextStyle(fontSize: 22),
                        textStyle: TextStyle(fontSize: 13),
                        onChanged: (value) => setState(
                          () {
                            restDisplayedSec = value;
                            secLengthRest = restDisplayedSec +
                                restDisplayedMin *
                                    60; //als Methode weil 2x vorkommt?
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('sek'.tr),
                ],
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Dropdown - Anzahl Durchgänge
              SizedBox(height: 12),
              Text(
                'selAnzDurchg'.tr,
                style: TextStyle(fontSize: 15),
              ),
              NumberPicker(
                value: anzRounds,
                minValue: 1,
                maxValue: 59,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),
                textStyle: TextStyle(fontSize: 13),
                onChanged: (value) => setState(() => anzRounds = value),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

              SizedBox(height: 10),
              Text(
                this.textFehlermeldung + '\n',
                style: TextStyle(color: Colors.red),
              ),

              TextButton(
                child: Text(
                  'start'.tr,
                ),
                style: TextButton.styleFrom(
                    primary: Colors.black,
                    side: BorderSide(color: Colors.grey.shade700)),
                autofocus: true,
                onPressed: _changeToPage2,
                onLongPress: _changeToPage2,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

//Page 2
class RandomColorPage2 extends StatefulWidget {
  RandomColorPage2(
      {Key? key,
      required this.listSelectedColors,
      required this.listSelectedArrows,
      required this.anzColorsOnPage,
      required this.secChangeColor,
      required this.secLengthRound,
      required this.secLengthRest,
      required this.anzRounds})
      : super(key: key);

  var listSelectedColors;
  var listSelectedArrows;
  int anzColorsOnPage;
  int secChangeColor;
  int secLengthRound;
  int secLengthRest;
  int anzRounds;

  @override
  _RandomColorPage2 createState() => _RandomColorPage2();
}

class _RandomColorPage2 extends State<RandomColorPage2> {
  var start = DateTime.now().millisecondsSinceEpoch;
  var listWithSelectedColors = []; //gefüllt mit ColorsCheckbox-Elemente
  var listWithSelectedHex = []; //gefüllt mit Hex-Werten (int)
  var listHeight4Container = [];
  var listToFillContainersHex = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12
  ]; //nur Füllwerte
  var listWithSelectedArrows = [];
  var listToFillContainersIcon = [
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north),
    Icon(Icons.north)
  ];

  //var list4RandomHex = [0xffff0000, 0xffff0000, 0xffff0000, 0xffff0000];
  int anzColorsOnPage2 = 1;
  int secChangeColor2 = 1;
  int secLengthRound2 = 1;
  int secLengthRest2 = 1;
  int anzRounds2 = 1;

  late Timer _timer;
  int anzRoundsDone = 1;
  int secsLengthRoundCD = 1;
  int minsLengthRoundCD = 1;
  int secsLengthRestCD = 1;
  int minsLengthRestCD = 1;
  bool isRest = false;
  var colorRestText = 0xffffffff;
  var restText = '';
  var paddingTopRestText = 0.0;
  var fontsizeRestText = 0.0;

  int currentSecsCD = 0;
  int currentMinsCD = 0;

  double footerPercentage = 0.05;
  double bodyPercentage =
      0.95; //1-footerPercentage-> dieser Platz muss aufgeteilt werden um Farben anzuzeigen
  double thicknessVerticalDividerFooter = 0.5;

  void initState() {
    _initializeSettinvariables();
    _initializeListHeight4Containers();
    _initializeListWithAllHex();
    _initializeListSelectedArrows();
    organizeRound();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(() {
              timemanagement();
            }));

    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async =>
          false), //damit swipe back(ios) bzw. Back Button (android) deaktiviert
      child: Scaffold(
        backgroundColor: Color(0xff000000),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[
                      0]), //noch ersetzen mit 1/"wie viele farben aufs mal anzeigen"
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(this.listToFillContainersHex[0]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
              child: Stack(
                children: [
                  Center(child: listToFillContainersIcon[0]),
                  Center(
                    child: Text(
                      this.restText,
                      style: TextStyle(
                          color: Color(this.colorRestText),
                          fontSize: this.fontsizeRestText,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: listToFillContainersIcon[1],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[1]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[1]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[2],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[2]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[2]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[3],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[3]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[3]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[4],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[4]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[4]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[5],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[5]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[5]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[6],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[6]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[6]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[7],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[7]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[7]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[8],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[8]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[8]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[9],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[9]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.listToFillContainersHex[9]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              child: listToFillContainersIcon[10],
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[10]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(this.listToFillContainersHex[10]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
            ),
            Container(
              child: listToFillContainersIcon[11],
              color: Color(this.listToFillContainersHex[11]),
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[11]),
              width: MediaQuery.of(context).size.width,
            ),

            //footer
            Container(
              height: MediaQuery.of(context).size.height * (footerPercentage),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade700,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        this.anzRoundsDone.toString() +
                            '/' +
                            this.anzRounds2.toString() +
                            ' Runden',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        currentMinsCD.toString().padLeft(2, '0') +
                            ':' +
                            currentSecsCD.toString().padLeft(2, '0'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 0.5,
                    width: 0.5,
                  ),
                  Container(
                    child: TextButton(
                      child: Text(
                        'hauptmenü'.tr,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      autofocus: false,
                      onPressed: changeToPage1,
                      onLongPress: changeToPage1,
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                  Container(
                    child: TextButton(
                      child: Text(
                        'neustart'.tr,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      autofocus: false,
                      onPressed: neustart,
                      onLongPress: neustart,
                    ),
                    width: (MediaQuery.of(context).size.width -
                            thicknessVerticalDividerFooter) /
                        4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * Initialisiert die Settingvariablen in Page2 mit den korrekten Werten aus Page1, da diese nicht direkt als lokale Variable gebraucht werden können
  */
  void _initializeSettinvariables() {
    this.anzColorsOnPage2 = widget.anzColorsOnPage;
    this.secChangeColor2 = widget.secChangeColor;
    this.secLengthRound2 = widget.secLengthRound;
    this.secLengthRest2 = widget.secLengthRest;
    this.anzRounds2 = widget.anzRounds;

    this.minsLengthRoundCD = (this.secLengthRound2 / 60).toInt();
    this.secsLengthRoundCD = this.secLengthRound2 % 60;
    this.minsLengthRestCD = (this.secLengthRest2 / 60).toInt();
    this.secsLengthRestCD = this.secLengthRest2 % 60;
  }

  //füllt listWithSelectedColors ab aus widget.
  void _initializeListSelectedColors() {
    this.listWithSelectedColors = widget.listSelectedColors;
  }

  void _initializeListSelectedArrows() {
    this.listWithSelectedArrows = widget.listSelectedArrows;
  }

  /**
   * füllt listWithSelectedHex mit Hexcodes aus listWithSelectedColors ab
   */
  void _initializeListWithAllHex() {
    this.listWithSelectedHex.clear();
    _initializeListSelectedColors();
    String hexxcode = '0xff';
    int theHexCode = 0;
    for (String item in listWithSelectedColors) {
      hexxcode = '0xff' + item;
      theHexCode = (int.parse(hexxcode));
      this.listWithSelectedHex.add(theHexCode);
    }
  }

  /**
   * initialisiert listHeight4Containers
   * beinhaltet den Wert, der für die Höhe jedes Containers gebraucht wird
   * Sollte in diesem Schema eingesetzt werden können height: MediaQuery.of(context).size.height*(listHeight4Containers[0])
   * 
   */
  void _initializeListHeight4Containers() {
    this.listHeight4Container.clear();
    for (int i = 0; i < 12; i++) {
      if (i < anzColorsOnPage2) {
        listHeight4Container.add(bodyPercentage / anzColorsOnPage2);
      } else {
        listHeight4Container.add(0);
      }
    }
  }

  /**
   * diese methode muss bei einem restart zusätzlich zu den anderen 3 _initialize..-Methoden aufgerufen werden
   * bringt alle variabeln, die sonst von anfang an schon korrekt initialisiert sind, wieder in ihren anfangszustand
   */
  void _initializeResetVariables() {
    this.anzRoundsDone = 1;
    this.isRest = false;
    this.currentSecsCD = 0;
    this.currentMinsCD = 0;
  }

/**
 * füllt listToFillContainersIcon mit korrektem icon und farbe inkl ob arrow sichtbar ist oder selbe farbe hat wie hintergrund
 */
  void addToListToFillContainersIcon(index, arrowDirection, arrowVisible) {
    var sizeIcon = 60.0;
    if (arrowVisible) {
      if (arrowDirection == 'north') {
        listToFillContainersIcon[index] =
            Icon(Icons.north, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'east') {
        listToFillContainersIcon[index] =
            Icon(Icons.east, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'south') {
        listToFillContainersIcon[index] =
            Icon(Icons.south, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'west') {
        listToFillContainersIcon[index] =
            Icon(Icons.west, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'northeast') {
        listToFillContainersIcon[index] =
            Icon(Icons.north_east, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'northwest') {
        listToFillContainersIcon[index] =
            Icon(Icons.north_west, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'southeast') {
        listToFillContainersIcon[index] =
            Icon(Icons.south_east, color: Colors.black, size: sizeIcon);
      } else if (arrowDirection == 'southwest') {
        listToFillContainersIcon[index] =
            Icon(Icons.south_west, color: Colors.black, size: sizeIcon);
      }
    } else {
      //arrow should not be visible
      listToFillContainersIcon[index] =
          Icon(Icons.north, color: Color(listToFillContainersHex[index]));
    }
  }

  /**
   * wird nur bei wechsel von rest zu round aufgerufen und ganz am Anfang bei Start page2 
   */
  void organizeRound() {
    _initializeListHeight4Containers(); //damit nach rest wieder alle Grössen der Container stimmen

    this.currentSecsCD = secsLengthRoundCD;
    this.currentMinsCD = minsLengthRoundCD;
    int randomInt;
    Random random = new Random();
    for (var i = 0; i < this.anzColorsOnPage2; i++) {
      randomInt = random.nextInt(listWithSelectedColors.length);

      //damit nicht gleiche Farben aufs Mal angezeigt werden
      if (i == 0) {
        listToFillContainersHex[i] = listWithSelectedHex[randomInt];
        this.colorRestText =
            listToFillContainersHex[i]; //damit Text nicht erkennbar
        this.restText = ''; //damit pfeil gute Position hat
        this.paddingTopRestText = 0.0; //damit pfeil gute Position hat
        this.fontsizeRestText = 0.0; //damit pfeil gute Position hat
      } else {
        while (
            listToFillContainersHex[i - 1] == listWithSelectedHex[randomInt]) {
          randomInt = random.nextInt(listWithSelectedColors.length);
        }
        listToFillContainersHex[i] = listWithSelectedHex[randomInt];
      }
    }

    //organize arrows
    for (int i = 0; i < listToFillContainersHex.length; i++) {
      if (listToFillContainersHex[i] != int.parse('0xfffefefe')) {
        //arrow not visible
        addToListToFillContainersIcon(i, null, false);
      } else {
        //arrow visible
        String arrowDirection = listWithSelectedArrows[
            random.nextInt(listWithSelectedArrows.length)];
        addToListToFillContainersIcon(i, arrowDirection, true);
      }
    }
  }

  /**
   * wird nur bei wechsel von round zu rest aufgerufen 
   */
  void organizeRest() {
    this.currentSecsCD = this.secsLengthRestCD;
    this.currentMinsCD = this.minsLengthRestCD;
    for (var i = 0; i < this.anzColorsOnPage2; i++) {
      //this.list4RandomHex[i] = 0xff000000;
      this.listToFillContainersHex[i] = 0xff000000;
      this.listHeight4Container[i] = 0; //damit Rest angezeigt werden kann
    }
    this.listHeight4Container[0] = bodyPercentage /
        1; //damit Rest angezeigt werden kann-> 1. container nimmt 100% ein
    this.colorRestText = 0xffffffff;
    this.restText = 'pause'.tr;
    this.paddingTopRestText = MediaQuery.of(context).size.height / 3;
    this.fontsizeRestText = 80.0;
    for (int i = 0; i < listToFillContainersHex.length; i++) {
      //damit alle pfeile schwarz und somit nicht sichtbar in pause
      listToFillContainersIcon[i] = Icon(Icons.north, color: Colors.black);
    }
  }

  /**
   * Methode, die jede Sekunde wegen _timer aufgerufen wird
   * managt farbwechsel, ende der Übung und Countdown
   */
  void timemanagement() {
    int randomInt;
    Random random = new Random();
    if (this.anzRoundsDone <= this.anzRounds2) {
      outerloop:
      if (isRest) {
        //management change
        if (this.secsLengthRestCD == 1 && this.minsLengthRestCD == 0) {
          isRest = false;
          this.anzRoundsDone++;
          if (this.anzRoundsDone <= this.anzRounds2) {
            //dass nicht organizeRound aufgerufen wird wenn eig fertig wäre
            organizeRound();
          } else {
            this.secsLengthRestCD--;
            this.currentSecsCD = this.secsLengthRestCD;
          }
          this.minsLengthRestCD = (this.secLengthRest2 / 60)
              .toInt(); //damit ready für nächsten durchgang
          this.secsLengthRestCD = this.secLengthRest2 % 60;
        } else {
          //management time
          if (this.secsLengthRestCD > 0) {
            this.secsLengthRestCD--;
          } else if (this.minsLengthRestCD > 0) {
            this.minsLengthRestCD--;
            this.secsLengthRestCD = 59;
            this.currentMinsCD = this.minsLengthRestCD;
          }
          this.currentSecsCD = this.secsLengthRestCD;
        }
      } else {
        //isRound

        //management change
        if (this.secsLengthRoundCD == 1 && this.minsLengthRoundCD == 0) {
          isRest = true;
          organizeRest();
          this.minsLengthRoundCD = (this.secLengthRound2 / 60)
              .toInt(); //damit ready für nächsten durchgang
          this.secsLengthRoundCD = this.secLengthRound2 % 60;
          break outerloop;
        } else {
          //management time
          if (this.secsLengthRoundCD > 0) {
            this.secsLengthRoundCD--;
          } else if (this.minsLengthRoundCD > 0) {
            this.minsLengthRoundCD--;
            this.secsLengthRoundCD = 59;
            this.currentMinsCD = minsLengthRoundCD;
          }
          this.currentSecsCD = this.secsLengthRoundCD;
        }
        //management color
        if ((this.secLengthRound2 -
                        (this.secsLengthRoundCD +
                            this.minsLengthRoundCD * 60)) %
                    this.secChangeColor2 ==
                0 &&
            (this.secsLengthRoundCD != 0 || this.minsLengthRoundCD != 0)) {
          //color wechseln
          for (var i = 0; i < this.anzColorsOnPage2; i++) {
            randomInt = random.nextInt(listWithSelectedColors.length);

            //damit nicht gleiche Farben aufs Mal angezeigt werden
            if (i == 0) {
              listToFillContainersHex[i] = listWithSelectedHex[randomInt];
              colorRestText = listToFillContainersHex[i];
            } else {
              while (listToFillContainersHex[i - 1] ==
                  listWithSelectedHex[randomInt]) {
                randomInt = random.nextInt(listWithSelectedColors.length);
              }
              listToFillContainersHex[i] = listWithSelectedHex[randomInt];
            }
          }

          //organize arrows
          for (int i = 0; i < listToFillContainersHex.length; i++) {
            if (listToFillContainersHex[i] != int.parse('0xfffefefe')) {
              //arrow not visible
              addToListToFillContainersIcon(i, null, false);
            } else {
              //arrow visible
              String arrowDirection = listWithSelectedArrows[
                  random.nextInt(listWithSelectedArrows.length)];
              addToListToFillContainersIcon(i, arrowDirection, true);
            }
          }
        }
      }
    } else {
      this._timer.cancel();
      showDialog(
          context: context,
          builder: (_) => alertDialogFinish(),
          barrierDismissible: false);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => alertDialog()));
    }
  }

  /**
   * AlertDialog das bei Ende von Übung erscheint
   */
  Widget alertDialogFinish() {
    this.anzRoundsDone--;
    return AlertDialog(
      //ähnlich wie modalWindow
      content: Text('trainingEnde'.tr),
      actions: [
        TextButton(
            onPressed: changeToPage1,
            child: Text(
              'hauptmenü'.tr,
              style: TextStyle(color: Color.fromARGB(177, 0, 0, 0)),
            )),
        TextButton(
            onPressed: changeToPage2,
            child: Text(
              'neustart'.tr,
              style: TextStyle(color: Color.fromARGB(177, 0, 0, 0)),
            )),
      ],
    );
  }

  /**
   * Methode, die alle Variablen etc wieder in den anfangszustand bringt, damit page2 nochmals von null aus abgespielt werden kann
   * timer wird absichtlich nicht verändert da nicht nötig
   */
  void neustart() {
    _initializeSettinvariables();
    _initializeListHeight4Containers();
    _initializeListWithAllHex();
    _initializeListSelectedArrows();
    _initializeResetVariables();
    organizeRound();
  }

  /**
   * Wechsel von page2 to page1
   */
  void changeToPage1() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Skillatics')));
  }

  /**
   * neustart der page2
   * wird nach alertDialogFinish aufgerufen weil neustart() nicht funktioniert
   */
  void changeToPage2() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RandomColorPage2(
                  listSelectedColors: this.listWithSelectedColors,
                  listSelectedArrows: this.listWithSelectedArrows,
                  anzColorsOnPage: this.anzColorsOnPage2,
                  secChangeColor: this.secChangeColor2,
                  secLengthRound: this.secLengthRound2,
                  secLengthRest: this.secLengthRest2,
                  anzRounds: this.anzRounds2,
                )));
  }
}
