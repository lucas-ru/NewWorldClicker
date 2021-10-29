import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/html.dart' as html;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: const MyHomePage(title: 'New World Ore Clicker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  int _nbUpdate = 0;
  int _counter = 0;
  int _cost = 20;
  String _image = "platine.png";
  int _NbEsclave = 0;

  late AnimationController _controller;

  @override
  void initState(){
    super.initState();
    setState(() {
      ReadInformation();
    });
    // Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
  }

  Future<void> ReadInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = (prefs.getInt('counter') ?? 0);
    _NbEsclave = (prefs.getInt('esclave') ?? 0);
    _nbUpdate = (prefs.getInt('update') ?? 0);
    _cost = (prefs.getInt('cost') ?? 20);

    if(_counter <= 50){
      _image = "platine.png";
    }else if(_counter >50 && _counter <= 125){
      _image = "or.png";
    }else{
      _image = "ori.png";
    }
    if(_NbEsclave > 0){
      autoclick();
    }
  }

  Future<void> WriteInformation(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("pickaxe.mp3");
  }

  void _incrementCounter(){
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_counter <= 50){
        _image = "platine.png";
      }else if(_counter >50 && _counter <= 125){
        _image = "or.png";
      }else{
        _image = "ori.png";
      }
      _counter = _counter + 1 + _nbUpdate;
      WriteInformation("counter", _counter);
    });
  }

  void autoclick(){

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState((){
        _counter= _counter+1*_NbEsclave;
        WriteInformation("counter",_counter);
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.2)
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.7),

                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Number of Ore : $_counter',
                                style: GoogleFonts.bebasNeue(fontSize: 35,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                   GestureDetector(
                        onTap: (){_incrementCounter();},
                        child:Container(
                                height: 100,
                                decoration: BoxDecoration(
                                                image: DecorationImage(
                                                image: AssetImage("assets/images/$_image")
                                                ),
                                            ),
                          ),
                    ),
                    GestureDetector(
                        onTap: (){
                          if(_counter >= _cost){
                            setState(() {
                              _counter-= _cost;
                            });
                            _nbUpdate++;
                            _cost = _cost*2;
                            WriteInformation("update", _nbUpdate);
                            WriteInformation("cost", _cost);
                            HapticFeedback.heavyImpact();
                          }
                        },
                        child: Image.asset("assets/images/pickaxe.png")),
                    Text(
                      'Cost : $_cost, +${_nbUpdate+2}',
                      style: GoogleFonts.bebasNeue(fontSize: 35,color: Colors.white),
                    ),
                    GestureDetector(
                        onTap: (){
                          if(_counter >= 80){
                            setState(() {
                              _counter-= 80;
                            });
                            _NbEsclave++;
                            WriteInformation("esclave", _NbEsclave);
                            if(_NbEsclave==1){
                              autoclick();
                            }
                            HapticFeedback.heavyImpact();
                            playLocalAsset();
                          }
                        },
                        child: Image.asset("assets/images/character.png")
                    ),
                    Text(
                      'Cost : 80, autoclick',
                      style: GoogleFonts.bebasNeue(fontSize: 35,color: Colors.white),
                    ),
                  ],
              ),
            ),
          ),
          )
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
    );
  }
}

class CircleImageButton extends StatelessWidget {
  final Function? onTap;
  final ImageProvider? image;

  CircleImageButton({ this.onTap, this.image }): super();


  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap!(),
    );
  }
}


