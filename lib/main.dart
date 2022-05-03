import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randomcolor_tomo/ColorsCheckbox.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        unselectedWidgetColor: Colors.black,
      ),
      home: MyHomePage(title: 'Colorswitch by Tomo'),
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

//Variabeln für Einstellungen, siehe Skizze, werden an Page2 übergeben
  int anzColorsOnPage = 2;
  int secChangeColor = 5;
  int secLengthRound = 210; //=roundDisplayedSec+roundDisplayedMin in sekunden
  int secLengthRest = 90; //=restDisplayedSec+restDisplayedMin in sekunden
  int anzRounds = 5;

//Werte, die in applescroll angezeigt werden aber nicht so an Page2 übergeben werden können weil Min und Sec gemischt
  int roundDisplayedSec = 30;
  int roundDisplayedMin = 3;
  int restDisplayedSec = 30;
  int restDisplayedMin = 1;

//Checkboxen, mit allen gewünschten Farben
  var selectedColors = [];

//alle Checkboxen, die mit dieser Bezeichnung angezeigt werden
  final checkboxcolors = [
    ColorsCheckbox(colorname: 'pink', hexcode: 'f500ab'),
    ColorsCheckbox(colorname: 'gelb', hexcode: 'f5ff00'),
    ColorsCheckbox(colorname: 'orange', hexcode: 'ff5f1f'),
    ColorsCheckbox(colorname: 'grün', hexcode: '21b40e'),
    ColorsCheckbox(colorname: 'blau', hexcode: '3383e6'),
    ColorsCheckbox(colorname: 'weiss', hexcode: 'ffffff'),
  ];

  Widget buildSingleCheckbox(ColorsCheckbox checkbox) => CheckboxListTile(
        activeColor: Colors.red,
        controlAffinity:
            ListTileControlAffinity.leading, //checkbox links von text
        value: checkbox.selected,
        title: Text(
          checkbox.colorname,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        onChanged: (selected) => _checkboxChanged(checkbox, checkbox.selected),
      );

  void _checkboxChanged(ColorsCheckbox checkbox, bool selected) {
    setState(() {
      if (checkbox.selected) {
        checkbox.selected = false;
        selectedColors.remove(checkbox);
      } else {
        checkbox.selected = true;
        selectedColors.add(checkbox);
      }
    });
  }

  //Wechsel auf Seite 2 mit den angezeigten Farben
  void _changeToPage2() {
    //überprüft, ob Werte in Range sind
    if (this.secLengthRound >= 30 &&
        this.secLengthRound <= 300 &&
        this.secLengthRest >= 30 &&
        this.secLengthRest <= 150 &&
        this.selectedColors.length >= this.anzColorsOnPage) {
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
        this.textFehlermeldung =
            'Deine Angaben sind nicht gültig. Bitte Range beachten.';
      });
    }
  }

  /**
   * Returnt einen AlertDialog, damit der User Zeit hat auf Position zu gehen
   */
  Widget alertDialogCD() {
    return AlertDialog(
      content: Center(
        heightFactor: 1.2,
        child: Text('Mach dich bereit!\n'),
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
          title: Text(widget.title),
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
                'Wähle die Fraben aus, mit denen du trainieren möchtest:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height:
                    310, //evtl. noch flexibel machen und nicht hardcode falls sich anzahl ändert oder format des bildschirms
                child: ListView(
                  padding: EdgeInsets.all(12),
                  children: [
                    ...checkboxcolors.map(buildSingleCheckbox).toList(),
                  ],
                ),
              ),
              Divider(
                color: Colors.black54,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

              //Dropdown - wie viele Farben aufs Mal angezeigt werden
              SizedBox(height: 12),
              Text(
                'Wähle, wie viele Farben aufs Mal angezeigt werden sollen:',
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
                color: Colors.black54,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Farbwechsel nach wie vielen Sekunden
              SizedBox(height: 12),
              Text(
                'Farbwechsel nach wie vielen Sekunden?',
                style: TextStyle(fontSize: 15),
              ),
              NumberPicker(
                value: secChangeColor,
                minValue: 1,
                maxValue: 10,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),
                textStyle: TextStyle(fontSize: 13),
                onChanged: (value) => setState(() => secChangeColor = value),
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black54,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Dauer eines Durchlaufs
              SizedBox(height: 12),
              Text(
                "Dauer eines Durchlaufs (Range: 30s - 5min)?",
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
                        maxValue: 5,
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
                  Text('Min.'),
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
                  Text('Sek.'),
                ],
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black54,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Applescroll - Dauer einer Pause
              SizedBox(height: 12),
              Text(
                "Dauer einer Pause (Range: 30s - 2min 30s)?",
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
                        maxValue: 2,
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
                  Text('Min.'),
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
                  Text('Sek.'),
                ],
              ),
              SizedBox(height: 12),

              Divider(
                color: Colors.black54,
                height: 15,
                indent: 30,
                endIndent: 30,
              ),

//Dropdown - Anzahl Durchgänge
              SizedBox(height: 12),
              Text(
                'Wähle, wie viele Durchgänge (1x Durchlauf + 1x Pause) du machen willst:',
                style: TextStyle(fontSize: 15),
              ),
              DropdownButton<int>(
                value: anzRounds,
                onChanged: (int? val) {
                  setState(
                    () {
                      anzRounds = val!;
                    },
                  );
                },
                items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
                color: Colors.black54,
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
                  'Start',
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
      required this.anzColorsOnPage,
      required this.secChangeColor,
      required this.secLengthRound,
      required this.secLengthRest,
      required this.anzRounds})
      : super(key: key);

  var listSelectedColors;
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
  var list4RandomHex = [0xffff0000, 0xffff0000, 0xffff0000, 0xffff0000];
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

  int currentSecsCD = 0;
  int currentMinsCD = 0;

  void initState() {
    _initializeSettinvariables();
    _initializeListHeight4Containers();
    _initializeListWithAllHex();
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
                color: Color(this.list4RandomHex[0]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[1]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(this.list4RandomHex[1]),
                  border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[2]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(this.list4RandomHex[2]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
            ),
            Container(
              color: Color(this.list4RandomHex[3]),
              height: MediaQuery.of(context).size.height *
                  (listHeight4Container[3]),
              width: MediaQuery.of(context).size.width,
            ),

            //footer
            Container(
                height: MediaQuery.of(context).size.height * (0.05),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Remaining: ' +
                          currentMinsCD.toString().padLeft(2, '0') +
                          ':' +
                          currentSecsCD.toString().padLeft(2, '0'),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      this.anzRoundsDone.toString() +
                          '/' +
                          this.anzRounds2.toString() +
                          ' Runden',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      child: Text(
                        'Hauptmenü',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      /*style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                    ),*/
                      autofocus: false,
                      onPressed: changeToPage1,
                      onLongPress: changeToPage1,
                    ),
                    TextButton(
                      child: Text(
                        'Neustart',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      autofocus: false,
                      onPressed: neustart,
                      onLongPress: neustart,
                    ),
                  ],
                )),
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

  /**
   * füllt listWithSelectedHex mit Hexcodes aus listWithSelectedColors ab
   */
  void _initializeListWithAllHex() {
    this.listWithSelectedHex.clear();
    _initializeListSelectedColors();
    String hexxcode = '0xff';
    int theHexCode = 0;
    for (ColorsCheckbox item in listWithSelectedColors) {
      hexxcode = '0xff' + item.hexcode;
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
    for (int i = 0; i < this.anzColorsOnPage2; i++) {
      listHeight4Container.add(
          (1 - 0.05) / anzColorsOnPage2); //0.04 selbst definiert als "footer"
    }
    if (this.anzColorsOnPage2 < 4) {
      for (int i = anzColorsOnPage2; i < 4; i++) {
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
   * wird nur bei wechsel von rest zu round aufgerufen 
   */
  void organizeRound() {
    this.currentSecsCD = secsLengthRoundCD;
    this.currentMinsCD = minsLengthRoundCD;
    int randomInt;
    Random random = new Random();
    for (var i = 0; i < this.anzColorsOnPage2; i++) {
      randomInt = random.nextInt(listWithSelectedColors.length);

      //damit nicht gleiche Farben aufs Mal angezeigt werden
      while (listWithSelectedHex[randomInt] == list4RandomHex[3] ||
          listWithSelectedHex[randomInt] == list4RandomHex[2] ||
          listWithSelectedHex[randomInt] == list4RandomHex[1] ||
          listWithSelectedHex[randomInt] == list4RandomHex[0]) {
        randomInt = random.nextInt(listWithSelectedColors.length);
      }

      this.list4RandomHex[i] = listWithSelectedHex[randomInt];
    }
  }

  /**
   * wird nur bei wechsel von round zu rest aufgerufen 
   */
  void organizeRest() {
    this.currentSecsCD = this.secsLengthRestCD;
    this.currentMinsCD = this.minsLengthRestCD;
    for (var i = 0; i < this.anzColorsOnPage2; i++) {
      this.list4RandomHex[i] = 0xff000000;
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
            while (listWithSelectedHex[randomInt] == list4RandomHex[3] ||
                listWithSelectedHex[randomInt] == list4RandomHex[2] ||
                listWithSelectedHex[randomInt] == list4RandomHex[1] ||
                listWithSelectedHex[randomInt] == list4RandomHex[0]) {
              randomInt = random.nextInt(listWithSelectedColors.length);
            }

            this.list4RandomHex[i] = listWithSelectedHex[randomInt];
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
      content: Text('Trainingsrunde beendet!'),
      actions: [
        TextButton(onPressed: changeToPage1, child: Text('Hauptmenü')),
        TextButton(onPressed: changeToPage2, child: Text('Neustart')),
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
            builder: (context) => MyHomePage(title: 'Colorswitch by Tomo')));
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
                  anzColorsOnPage: this.anzColorsOnPage2,
                  secChangeColor: this.secChangeColor2,
                  secLengthRound: this.secLengthRound2,
                  secLengthRest: this.secLengthRest2,
                  anzRounds: this.anzRounds2,
                )));
  }
}
