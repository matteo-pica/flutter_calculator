import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:dart2_constant/math.dart' as math_polyfill;
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterCalc',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Dumbest Flutter Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      // body: Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Invoke "debug painting" (press "p" in the console, choose the
      //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
      //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      //     // to see the wireframe for each widget.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.display1,
      //       ),
      //     ],
      //   ),
      // ),
      body: Calcolatrice(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Calcolatrice extends StatefulWidget {
  @override
  CalcolatriceState createState() => CalcolatriceState();
}

Parser p = Parser();
Expression exp;
double eval;
ContextModel cm = new ContextModel();
class CalcolatriceState extends State<Calcolatrice> {
  String lastClickedBtn = "";
  String toShowOnScreen = "";
  double firstFactor = 0, secondFactor = 0;
  String operatore;
  void clickedButton(String clicked) {
    print("clicked $lastClickedBtn now");
    int digit = int.tryParse(clicked);
    String toShow;
    if (digit != null) {
      // Sto inserendo il primo numero
      if (operatore == null) {
        firstFactor = (firstFactor * 10) + digit;
        toShow = "$firstFactor";
      }else{
        secondFactor = (secondFactor * 10) + digit;
        toShow = "$secondFactor";
      }
    } else {
      // Non sto cliccando un numero
      switch (clicked) {
        case "+":
        case "*":
        case "-":
        case "/":
          operatore = clicked;
          toShow = "";
          break;
        case "C":
        case "=":
          if(clicked == "="){
            exp = p.parse("$firstFactor $operatore $secondFactor");
            eval = exp.evaluate(EvaluationType.REAL,cm);
            toShow = "$eval";
            firstFactor = eval;
          }else{
            toShow = "";
            firstFactor = 0;
          }
          operatore = null;
          secondFactor = 0;
          break;
      }
    }
    setState(() {
      lastClickedBtn = clicked;
      toShowOnScreen = toShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            DisplayCalc(toShow: toShowOnScreen),
            ButtonsGrid(
              onClickBtn: clickedButton,
            ),
          ],
        ));
  }
}

class DisplayCalc extends StatelessWidget {
  final String toShow;
  DisplayCalc({@required this.toShow});
//   @override
//   DisplayCalcState createState() => DisplayCalcState();
// }

// class DisplayCalcState extends State<DisplayCalc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 250,
      decoration: BoxDecoration(
          border: Border.all(width: 5, color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Center(child: Text(toShow)),
    );
  }
}

class ButtonsGrid extends StatelessWidget {
  ButtonsGrid({@required this.onClickBtn});
  final ValueChanged<String> onClickBtn;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // decoration: BoxDecoration(
        //     border: Border.all(width: 5, color: Theme.of(context).primaryColor),
        //     borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "7",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "8",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "9",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "/",
                    onClickBtn: onClickBtn),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "4",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "5",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "6",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "*",
                    onClickBtn: onClickBtn),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "1",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "2",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "3",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "-",
                    onClickBtn: onClickBtn),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "C",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "0",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "=",
                    onClickBtn: onClickBtn),
                _MyButton(
                    // onPressed: _incrementCounter,
                    // tooltip: '7',
                    button: "+",
                    onClickBtn: onClickBtn),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MyButton extends StatelessWidget {
  final String button;
  _MyButton({@required this.button, @required this.onClickBtn});
  final ValueChanged<String> onClickBtn;
  void _handleTap() {
    onClickBtn(button);
  }

  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _handleTap,
      // tooltip: '7',
      child: Text(button),
    );
  }
}

// FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
