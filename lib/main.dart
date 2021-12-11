import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randomcolor_tomo/ColorsCheckbox.dart';
//import 'package:randomcolor_tomo/DropdownItems.dart';
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
  int _counter = 0;
  String hexxcode = '0xff';
  int theHexCode = 0;
  String dropdownValue = 'ddd';

  Duration duration = Duration(minutes: 1, seconds: 30);

//Variabeln für Einstellungen, siehe Skizze, werden an Page2 übergeben
  int anzColorsOnPage=2;
  int secChangeColor=5;
  int secLengthRound=210; //=roundDisplayedSec+roundDisplayedMin in sekunden
  int secLengthRest=90;  //=restDisplayedSec+restDisplayedMin in sekunden
  int anzRounds=5;

//Werte, die in applescroll angezeigt werden aber nicht so an Page2 übergeben werden können weil Min und Sec gemischt
  int roundDisplayedSec=30;
  int roundDisplayedMin=3;
  int restDisplayedSec=30;
  int restDisplayedMin=1;

//Dropdown-Menue Anzahl Farben, die aufs Mal angezeigt werden
  //List<String> _amountColorsAtOnce = ['1','2','3','4'];
  /*List<DropdownItems> _amountColorsAtOnce = [
    DropdownItems(1, "first"),
    DropdownItems(2, "second"),
    DropdownItems(3, "third"),
    DropdownItems(4, "fourth"),
  ];*/
  
  //List<DropdownMenuItem<DropdownItems>> _dropdownAmountColors = [];//musste initialisiert werden
  
  //int _selectedAmountColors=0;
  //DropdownItems _selectedAmountColors = DropdownItems(3, "third");
  
  

  //List<DropdownMenuItem<String>> buildDropdownMenueAmountColors(List listItems){
    //List<DropdownMenuItem<String>> items = []; 
    /*for (DropdownItems listItem in listItems){
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }*/
    /*for (int i = 0; i<listItems.length; i++){
      items.add(
        DropdownMenuItem(
          child: Text(listItems[i]),
          value: i,  //evtl auch value: i
        )
        
      );
    }*/
   // return items;

 // }

  

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
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.leading,//checkbox links von text
              value: checkbox.selected, 
              title: Text(
                checkbox.colorname,
                style: TextStyle(fontSize: 20,),
              ),
              onChanged: (selected) => _incrementCounter(checkbox, checkbox.selected),
              // onChanged: (selected) => setState(() => checkbox.selected = selected!),
            );

            
  void _incrementCounter(ColorsCheckbox checkbox, bool selected) {
    setState(() {
      if(checkbox.selected){
      checkbox.selected = false;
      selectedColors.remove(checkbox);
      print('checkbox is now false');
      }else{
        checkbox.selected = true;     
        selectedColors.add(checkbox);
        print('checkbox is now ticked');
      }
      _updateHexcode(checkbox);
      _counter++;
     
     for(ColorsCheckbox name in selectedColors){
      print(name.colorname);     
      }
    });
  }

  void _updateHexcode(ColorsCheckbox checkbox){
    this.hexxcode = '0xff' + checkbox.hexcode;
    this.theHexCode= (int.parse(hexxcode));
  }

  //Wechsel auf Seite 2 mit den angezeigten Farben
  void _changeToPage2(){
    //überprüft, ob Werte in Range sind
    if (this.secLengthRound >= 30 && this.secLengthRound <= 300
        && this.secLengthRest >= 30 && this.secLengthRest <= 150    
        && this.selectedColors.length >= this.anzColorsOnPage     
      ) {
        print('page will change now');
        Navigator.push(context, MaterialPageRoute(builder: (context) => RandomColorPage2(
          title: 'page2', 
          listSelectedColors: this.selectedColors, 
          anzColorsOnPage: this.anzColorsOnPage,
          secChangeColor: this.secChangeColor,
          secLengthRound: this.secLengthRound,
          secLengthRest: this.secLengthRest,
          anzRounds: this.anzRounds,
        ),),); 
    }
    else{
      print('fehlermeldung');
    }
  }

  void _testCounter() {
    setState(() {
     
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      print(_counter);
    });
  }

  void initState() {
    super.initState();
    //_dropdownAmountColors = buildDropdownMenueAmountColors(_amountColorsAtOnce);
    //_selectedAmountColors = _dropdownAmountColors[1]; //eig _dropdownAmountColors[1]
  }
  
 // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: //damit scrollable wenn content grösser ist als bildschirmgrösses
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [  

  //Checkbox - Mit welchen Farben trainieren
            Text(
              '\nWähle die Fraben aus, mit denen du trainieren möchtest:',
              style: TextStyle(fontSize: 20),
            ),

            
            SizedBox(
              height: 300,  //evtl. noch flexibel machen und nicht hardcode falls sich anzahl ändert oder format des bildschirms
              child:ListView(
                padding: EdgeInsets.all(12),
                children: [
                ...checkboxcolors.map(buildSingleCheckbox).toList(),
                ],
              ),
            ),
            
        
           
//Dropdown - wie viele Farben aufs Mal angezeigt werden
            Text('Wähle wie viele Farben aufs Mal angezeigt werden sollen?'),
            DropdownButton<int>(
              value: anzColorsOnPage,
              onChanged: (int? val) {
                setState(() {
                  anzColorsOnPage = val!;
                  print(anzColorsOnPage);
                },);
              },
              items: <int>[1,2,3,4]
              .map<DropdownMenuItem<int>>((int val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text(val.toString()),
                );
              },).toList(),
             /* underline: Container(
                 height: 2,
                 color: Colors.deepPurpleAccent,
                ),*/                 
            ),


//Applescroll - Farbwechsel nach wie vielen Sekunden
            Text('\n\nFarbwechsel nach wie vielen Sekunden?'),
            NumberPicker(
                value: secChangeColor,
                minValue: 1,
                maxValue: 10,
                step: 1,
                itemHeight: 20,
                selectedTextStyle: TextStyle(fontSize: 22),              
                textStyle: TextStyle(fontSize: 13),
              //haptics: false,
                onChanged: (value) => setState(() => secChangeColor = value), 
              ),

//Applescroll - Dauer eines Durchlaufs
            Text("\n\nDauer eines Durchlaufs? Range: 30s - 5min"),
            Row(
              children: [
                Column(
                  children: [
                    Text('Minuten'),
                    NumberPicker(
                      value: roundDisplayedMin,
                      minValue: 0,
                      maxValue: 5,
                      step: 1,
                      itemHeight: 20,
                      selectedTextStyle: TextStyle(fontSize: 22),              
                      textStyle: TextStyle(fontSize: 13),
                      //haptics: false,
                      onChanged: (value) => setState((){
                        roundDisplayedMin = value;
                        secLengthRound = roundDisplayedSec + roundDisplayedMin*60;
                      },),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Sekunden'),
                    NumberPicker(
                      value: roundDisplayedSec,
                      minValue: 0,
                      maxValue: 59,
                      step: 1,
                      itemHeight: 20,
                      selectedTextStyle: TextStyle(fontSize: 22),              
                      textStyle: TextStyle(fontSize: 13),
                    //haptics: false,
                      onChanged: (value) => setState((){
                        roundDisplayedSec = value;
                        secLengthRound = roundDisplayedSec + roundDisplayedMin*60;                      
                      },),
                    ), 
                 ],
                ),
              ],        
            ),


           /* 
           //kann kein min/max gesetzt werden
           SizedBox(
              height: 180,
              child: CupertinoTimerPicker(
                initialTimerDuration: duration,
                mode: CupertinoTimerPickerMode.ms,
                minuteInterval: 1,
                secondInterval: 1,
                onTimerDurationChanged: (duration) =>
                  setState(() => this.duration = duration),
              ),

            ),*/

//Applescroll - Dauer einer Pause
            Text("\n\nDauer einer Pause? Range: 30s - 2min 30s"),
            Row(
              children: [
                Column(
                  children: [
                    Text('Minuten'),
                    NumberPicker(
                      value: restDisplayedMin,
                      minValue: 0,
                      maxValue: 2,
                      step: 1,
                      itemHeight: 20,
                      selectedTextStyle: TextStyle(fontSize: 22),              
                      textStyle: TextStyle(fontSize: 13),
                      //haptics: false,
                      onChanged: (value) => setState((){
                        restDisplayedMin = value;
                        secLengthRest =  restDisplayedSec + restDisplayedMin*60; //als Methode weil 2x vorkommt?
                      },), 
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Sekunden'),
                    NumberPicker(
                      value: restDisplayedSec,
                      minValue: 0,
                      maxValue: 59,
                      step: 1,
                      itemHeight: 20,
                      selectedTextStyle: TextStyle(fontSize: 22),              
                      textStyle: TextStyle(fontSize: 13),
                    //haptics: false,
                      onChanged: (value) => setState((){
                        restDisplayedSec = value; 
                        secLengthRest = restDisplayedSec + restDisplayedMin*60;  //als Methode weil 2x vorkommt?
                      },),
                    ),  
                  ],
                ),
              ],        
            ),



//Dropdown - Anzahl Durchgänge
            Text('\n\nWähle wie viele Durchgänge (1x Durchlauf + 1x Pause) du machen willst'),
            DropdownButton<int>(
              value: anzRounds,
              onChanged: (int? val) {
                setState(() {
                  anzRounds = val!;
                },);
              },
              items: <int>[1,2,3,4,5,6,7,8,9,10]
              .map<DropdownMenuItem<int>>((int val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text(val.toString()),
                );
              },).toList(),
             /* underline: Container(
                 height: 2,
                 color: Colors.deepPurpleAccent,
                ),*/                 
            ),          
                  
            Text("\n\n\n"),

            TextButton(
              child: Text(
                'weiter',
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
                side: BorderSide(color: Color(this.theHexCode))//Farbe in hex-code aus Variable
              ),
              autofocus: true,
              onPressed: _changeToPage2,
              onLongPress: _changeToPage2,
              ),
          ],
        ),
        ),
    );
  }

}


//Page 2
class RandomColorPage2 extends StatefulWidget {
  RandomColorPage2({
    Key? key, 
    required this.title, 
    required this.listSelectedColors, 
    required this.anzColorsOnPage,
    required this.secChangeColor,
    required this.secLengthRound,
    required this.secLengthRest,
    required this.anzRounds
  }) : super(key: key);


  final String title;
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
var listWithSelectedColors = [];
var listWithSelectedHex = [];
var selectedIndex = 1;
var listHeight4Container = [];
var list4RandomHex = [0xffff0000, 0xffff0000, 0xffff0000, 0xffff0000];
//var listIndexColor=[];
int anzColorsOnPage2=1;
int secChangeColor2=1;
int secLengthRound2=1;
int secLengthRest2=1;
int anzRounds2=1;

int anzRoundsDone=1;
late Timer _timer;
late Timer _timerCD;
int secsLengthRoundCD = 1;
int minsLengthRoundCD = 1;






void initState(){
  _initializeSettinvariables();
  _initializeListHeight4Containers();
  _initializeListWithAllHex();
  _set4RandomHex();

  _timer=Timer.periodic(Duration(seconds: this.secChangeColor2), (Timer t) => setState((){_set4RandomHex();})); //nach 10s setState aufgerufen, build-Methode neu durchlaufen ->gibt es einen weg, der weniger rechenleistung etc. erfordert?
  _timerCD=Timer.periodic(Duration(seconds: 1), (Timer timer) => setState((){_setCountdown();})); //nach 10s setState aufgerufen, build-Methode neu durchlaufen ->gibt es einen weg, der weniger rechenleistung etc. erfordert?

  
  super.initState();

  //print('DateTime.now().millisecondsSinceEpoch - this.start: '+(DateTime.now().millisecondsSinceEpoch - this.start).toString());
  /*if((DateTime.now().millisecondsSinceEpoch - this.start)<18000){
    print('in if');
    new Timer.periodic(Duration(seconds: this.secChangeColor2), (Timer t) => testState()); //nach 10s setState aufgerufen, build-Methode neu durchlaufen ->gibt es einen weg, der weniger rechenleistung etc. erfordert?

      // new Timer.periodic(Duration(seconds: this.secLengthRound2), (Timer timer) => setState((){}));
      
  }

    //const durationchange = const Duration(seconds: 10);
    if((DateTime.now().millisecondsSinceEpoch - this.start)<18000){
         new Timer.periodic(Duration(seconds: this.secChangeColor2), (Timer t) => setState((){})); //nach 10s setState aufgerufen, build-Methode neu durchlaufen ->gibt es einen weg, der weniger rechenleistung etc. erfordert?

      // new Timer.periodic(Duration(seconds: this.secLengthRound2), (Timer timer) => setState((){}));
      
    }else{
      print("jetzt wäre fertig");
    }*/
  setState(() {
    print('bin in setState');
    //print("Datetime.now="+DateTime.now().millisecondsSinceEpoch.toString());
    //print("start: "+start.toString());
     
  });
  
}


  @override
  Widget build(BuildContext context) {
    print('jetzt wurde build durchlaufen');

    return Scaffold( 
      backgroundColor:Colors.white, //Color(_getHexAfter10Sec()),
      body: Column(
        children: [
            Container(
              //color: Colors.blue,
              height: MediaQuery.of(context).size.height*(listHeight4Container[0]), //noch ersetzen mit 1/"wie viele farben aufs mal anzeigen"
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(  
                //color: Color(listWithSelectedHex[_getRandomInt()]),
                color: Color(this.list4RandomHex[0]),
                border: Border(bottom: BorderSide(color: Colors.black)),           
              ),
            ),
            Container(
              //color: Colors.pink,
              height: MediaQuery.of(context).size.height*(listHeight4Container[1]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
               // color: Color(listWithSelectedHex[_getRandomInt()]),
                color: Color(this.list4RandomHex[1]),
                border: Border(bottom: BorderSide(color: Colors.black))),
            ),
            Container(
              //color: Colors.red,
              height: MediaQuery.of(context).size.height*(listHeight4Container[2]),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(this.list4RandomHex[2]),
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
            ),
           //expanded gleicht aus und füllt in höhe das aus, was noch übrig bleiben würde
             Container(
                //color: Color(_getHexAfter10Sec()),
                color: Color(this.list4RandomHex[3]),
                //color: Colors.green,
                height: MediaQuery.of(context).size.height*(listHeight4Container[3]),
                width: MediaQuery.of(context).size.width,
              
            ),

            Container(
              height: MediaQuery.of(context).size.height*(0.04),
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              child: Row(
                children: [
                  Text('blablav'),           
                  TextButton(
                    child: Text('Startmenü'),
                    autofocus: true,
                    onPressed: null,
                    onLongPress: null,
                  ),
                  Text(this.minsLengthRoundCD.toString().padLeft(2, '0')+':'+this.secsLengthRoundCD.toString().padLeft(2,'0')),           
                ],
              )
            ),
            
            
            

            
        ],
        
      ),
      
      /*appBar: AppBar(
        //backgroundColor: Colors.white,
        //title: Text(widget.title),
       // centerTitle: true,
      ),*/
      /*body: 
      Column(
        children:[
          TextButton(
            child: Text(
              'press'
            ),
            autofocus: true,
            onPressed: _initializeListSelectedColors,
            onLongPress: _donothing,
          ),
          _iterateThroughList(),
        ]
      ),*/
    ); 
  }

  


  /**
   * Initialisiert die Settingvariablen in Page2 mit den korrekten Werten aus Page1, da diese nicht direkt als lokale Variable gebraucht werden können
  */
  void _initializeSettinvariables(){
    print(3.7.toInt());//printet 5
  

    this.anzColorsOnPage2=widget.anzColorsOnPage;
    this.secChangeColor2=widget.secChangeColor;
    this.secLengthRound2=widget.secLengthRound;
    this.secLengthRest2=widget.secLengthRest;
    this.anzRounds2=widget.anzRounds;

    this.minsLengthRoundCD=(this.secLengthRound2/60).toInt();
    this.secsLengthRoundCD=this.secLengthRound2%60;
  }

  
  //füllt listWithSelectedColors ab aus widget.
  void _initializeListSelectedColors(){
    //this.listWithSelectedColors.clear();
    this.listWithSelectedColors=widget.listSelectedColors;
    /*for (ColorsCheckbox name  in widget.listSelectedColors) {
      this.listWithSelectedColors.add(name);
    }*/
  }


  void _initializeListWithAllHex(){
    this.listWithSelectedHex.clear();
    _initializeListSelectedColors();
    String hexxcode = '0xff';
    int theHexCode = 0;
    for (ColorsCheckbox item in listWithSelectedColors) {
      hexxcode = '0xff' + item.hexcode;
      theHexCode= (int.parse(hexxcode));  
      this.listWithSelectedHex.add(theHexCode);
    }

  }

  /**
   * initialisiert listHeight4Containers
   * beinhaltet den Wert, der für die Höhe jedes Containers gebraucht wird
   * Sollte in diesem Schema eingesetzt werden können height: MediaQuery.of(context).size.height*(listHeight4Containers[0])
   * 
   */
  void _initializeListHeight4Containers(){
    this.listHeight4Container.clear();
    for (int i = 0; i < this.anzColorsOnPage2; i++) {
      listHeight4Container.add((1-0.04)/anzColorsOnPage2);
    }
    if (this.anzColorsOnPage2 < 4) {
      for (int i = anzColorsOnPage2; i < 4; i++) {
        listHeight4Container.add(0);
      }
    }
    print('\n\n\nlistHeight4Container:');
    print(listHeight4Container);
    print('\n\nok');
  
  }




//könnte als return nicht int haben sondern int-array, damit pro container mit [n] bei Color einsetzbar
  int _getHexAfter10Sec(){
    int currentBackgroundcolor = 0;
    print('DateTime.now:');
    print(DateTime.now().millisecondsSinceEpoch);
    print('start:');
    print(this.start);
    print('different now - start');
    print(DateTime.now().millisecondsSinceEpoch - start);


    if((DateTime.now().millisecondsSinceEpoch - start) <  10000){
      print('list[0]: '+listWithSelectedHex[0].toString());
      currentBackgroundcolor = listWithSelectedHex[0];
    }else if((DateTime.now().millisecondsSinceEpoch - start) <  20000){
      print('list[1]: '+listWithSelectedHex[1].toString());
      currentBackgroundcolor = listWithSelectedHex[1];
    }else if((DateTime.now().millisecondsSinceEpoch - start) <  30000){
      print('list[2]: '+listWithSelectedHex[2].toString());
      currentBackgroundcolor = listWithSelectedHex[2];
    }else if((DateTime.now().millisecondsSinceEpoch - start) >  30000){
      print('list[3]: '+listWithSelectedHex[3].toString()); 
      currentBackgroundcolor = listWithSelectedHex[3];
    }

    return currentBackgroundcolor;
  }

  /**
   * setzt zufällige Hex-Werte in die List list4RandomHex -> nur die werte, die auch angezeigt werden(wenn nur zwei angezeigt werden auch nur [0] und [1] gesetzt)
   * beinhaltet die ganze Zeitmanagement-Logik
   */
  void _set4RandomHex(){

    int randomHex=(int.parse('0xff000000'));
    int randomInt;
    Random random = new Random();

    print('now - start:'+(DateTime.now().millisecondsSinceEpoch-this.start).toString());
    print('secLengthRound in ms: '+(secLengthRound2*1000).toString());

    if(this.anzRoundsDone <= this.anzRounds2){
      if((DateTime.now().millisecondsSinceEpoch-this.start) < (this.secLengthRound2*1000*anzRoundsDone + this.secLengthRest2*1000*(anzRoundsDone-1))){
        for (var i = 0; i < this.anzColorsOnPage2; i++) {
          randomInt = random.nextInt(listWithSelectedColors.length);
          
          //damit nicht gleiche Farben aufs Mal angezeigt werden
          while(listWithSelectedHex[randomInt] == list4RandomHex[3] || listWithSelectedHex[randomInt] == list4RandomHex[2] || listWithSelectedHex[randomInt] == list4RandomHex[1] || listWithSelectedHex[randomInt] == list4RandomHex[0]){
            randomInt = random.nextInt(listWithSelectedColors.length);
          }

          this.list4RandomHex[i]=listWithSelectedHex[randomInt];
        }
       
      }else if((DateTime.now().millisecondsSinceEpoch - this.start) < (this.secLengthRound2*1000*anzRoundsDone + this.secLengthRest2*1000*anzRoundsDone) ){
        //Pausezeit
        for (var i = 0; i < this.anzColorsOnPage2; i++) {
          this.list4RandomHex[i]=0xff000000;
        }
      }else{
        //eine Runde vorüber
        this.anzRoundsDone++;
      }
    }else{
      //Übung beendet
      for (var i = 0; i < this.anzColorsOnPage2; i++) {
        this.list4RandomHex[i]=0xffff0000;
      }
      _timer.cancel();

      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'homepage')));
    }
    
  }

  void _setCountdown(){
    if(this.secsLengthRoundCD>0){
      this.secsLengthRoundCD--;
    }else if(this.minsLengthRoundCD>0){
      this.minsLengthRoundCD--;
      this.secsLengthRoundCD=59;
    }

  }



  /*int _getBackgroundcolorHex(){
    _initializeListSelectedColors();
    String hexxcode = '0xff';
    int theHexCode = 0;
    var hexColors = [];
    for (ColorsCheckbox item in listWithSelectedColors) {
      hexxcode = '0xff' + item.hexcode;
      theHexCode= (int.parse(hexxcode));  
      hexColors.add(theHexCode);  
    }
    return hexColors[0];
  }*/

  /*
  //wenn man mit aktueller Uhrzeit arbeiten würde
  int _getBackgroundTime(){
    _initializeListWithAllHex();
    var hour = DateTime.now().hour;
    print('hour: ' + hour.toString());
    int currentBackgroundcolor = 0;
    if(hour < 12){
      print('list[0]: '+listWithSelectedHex[0].toString());
      currentBackgroundcolor = listWithSelectedHex[0];
    }else{
      print('list[1]: '+listWithSelectedHex[1].toString());
      currentBackgroundcolor = listWithSelectedHex[1];
    }
    return currentBackgroundcolor;
  }*/

  /*Widget _getTextWidgets(List<dynamic> lisst){
    List<Widget> printThis = new List<Widget>;

    for (var i = 0; i < lisst.length; i++) {
      printThis.add(new Text(lisst[i].toString()));
    }

    return new Row(children: printThis);
  }
*/
  /*Text _iterateThroughList(){
     String hexxcode = '0xff';
      int theHexCode = 0;
    print('hallo');
    for(ColorsCheckbox name in widget.listSelectedColors){
      hexxcode = '0xff' + name.hexcode;
      theHexCode= (int.parse(hexxcode));
      print(name.colorname);     
     return new Text(
        name.colorname, 
        style: TextStyle(backgroundColor: Color(theHexCode)),
      );
    } 
    return Text('oke');
  }*/

  

  /*
  just to check if listWithSelectedColors is filled
  void _printNewList(){
    print('Method _printNewList: ');
    for (ColorsCheckbox item in listWithSelectedColors) {
      print(item.colorname);
    }
  }*/



}
