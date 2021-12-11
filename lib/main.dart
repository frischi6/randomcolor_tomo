//import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:randomcolor_tomo/ColorsCheckbox.dart';

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
      home: MyHomePage(title: 'Colddorswitch by Tomoo'),
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

  var selectedColors = [];
  //List<String, HSVColor> selectedColors = ['sfdas', ];
  

  //alle Checkboxen, die mit dieser Bezeichnung angezeigt werden 
  final checkboxcolors = [
    ColorsCheckbox(colorname: 'rot', hexcode: 'd51010'),
    ColorsCheckbox(colorname: 'blau', hexcode: '102ad5'),
    ColorsCheckbox(colorname: 'weiss', hexcode: 'ffffff'),
    ColorsCheckbox(colorname: 'grün', hexcode: '21b40e'),
    ColorsCheckbox(colorname: 'schwarz', hexcode: '000000'),
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

  void _changeToPage2(){
    print('page will change now');
    Navigator.push(context, MaterialPageRoute(builder: (context) => RandomColorPage2(title: 'page2', listSelectedColors: this.selectedColors,)),
            );  }

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


 // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
    
      body:       
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [  
            Text(
              '\nWähle die Fraben aus, mit denen du trainieren möchtest:',
              style: TextStyle(fontSize: 20),
            ),

            Expanded(child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                ...checkboxcolors.map(buildSingleCheckbox).toList(),
              ],
              ),
            ),
            TextButton(
              child: Text(
                'weeeiter',
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
                side: BorderSide(color: Color(this.theHexCode))//Farbe in hex-code aus Variable
              ),
              autofocus: true,
              onPressed: _changeToPage2,
              onLongPress: _changeToPage2,
              )
          ],
        ),
    );
  }

}


//Page 2
class RandomColorPage2 extends StatefulWidget {
  RandomColorPage2({Key? key, required this.title, required this.listSelectedColors}) : super(key: key);
  final String title;
  var listSelectedColors = [];

   @override
  _RandomColorPage2 createState() => _RandomColorPage2();
}

class _RandomColorPage2 extends State<RandomColorPage2> {

var start = DateTime.now().millisecondsSinceEpoch;
var listWithSelectedColors = [];
var listWithSelectedHex = [];

void initState(){
  super.initState();
  setState(() {
    const oneSecond = const Duration(seconds: 10);
    new Timer.periodic(oneSecond, (Timer t) => setState((){}));
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(_getHexAfter10Sec()),
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

  //füllt listWithSelectedColors ab aus widget.
  void _initializeListSelectedColors(){
    this.listWithSelectedColors.clear();
    for (ColorsCheckbox name  in widget.listSelectedColors) {
      this.listWithSelectedColors.add(name);
    }
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

  int _getHexAfter10Sec(){
    _initializeListWithAllHex();
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
