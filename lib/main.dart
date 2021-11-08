import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CURRENCY CONVERTER',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: Colors.pink[100],
          appBar: AppBar(
            title: const Text('CURRENCY CONVERTER',textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RobotoMono',
              color: Colors.white, 
              fontSize: 33, 
              fontWeight: FontWeight.bold
              ),),
          ),
          body: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  Color mainColor = const Color (0xFFF189AC);
  Color secondColor = const Color (0xFFEE2B6F);
  Color thirdColor = const Color (0xFFF8BBD0);

  
  String selectFcur = "MYR";
  String selectTcur = "USD";
  List<String> curList = [
    "MYR",
    "SGD",
    "THB",
    "USD",
    "EUR",
    "AUD",
  ];

  String result = "";
  double input = 0.0, val = 0.0 ;
  
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          TextField(
            controller: textEditingController, 
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                    filled: true,
                    fillColor: mainColor,
                    labelText: "Input value to convert", 
                    labelStyle: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.pink,
                    ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.5)),
              ),
            
            ),
          const SizedBox(height: 20),
          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:[
          DropdownButton(
              
              itemHeight: 50,
              value: selectFcur,
              onChanged: (curValue){
                setState((){
                  selectFcur = curValue.toString();
                });
              },
              items: curList.map((selectFcur){
                return DropdownMenuItem(
                  child : Text(
                    selectFcur,style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),          
                value: selectFcur,
                );
              }).toList(),
          ),

          FloatingActionButton(
            onPressed: (){
              String temp = selectFcur;
              setState (() {
                selectFcur = selectTcur;
                selectTcur = temp;
              });
            },
            child: const Icon(Icons.swap_horiz),
            elevation: 0.0, 
            backgroundColor: secondColor,
            ),
          DropdownButton(
              itemHeight: 50,
              value: selectTcur,
              onChanged: (curValue){
                setState((){
                  selectTcur = curValue.toString();
                });
              },
              items: curList.map((selectTcur){
                return DropdownMenuItem(
                  child : Text(
                    selectTcur,style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                value: selectTcur,
                );
              }).toList(),
            ),
          ],
        ),

        Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  primary: Colors.pink, 
                  onPrimary: Colors.white, 
                  ),
                  onPressed: _convert, 
                  child: const Text("Convert",
                    style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
                 
                ),
              ],),

              const SizedBox(height:50.0),
              Container(
                width:double.infinity,
                padding: const EdgeInsets.all(14.0),
                decoration:BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(14.0)
                ),

                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  const Text("Amount",
                    style: TextStyle (
                    fontSize: 18, 
                    fontFamily: 'RobotoMono',
                    color: Colors.white, 
                    fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                        ("\n" + input.toString() + " " + selectFcur + " = " + result +" " + selectTcur),
                            style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'RobotoMono',
                            fontSize: 18.00,
                            fontWeight: FontWeight.bold,
                          )),
              ],),
        ),
        ]        
    ),
  )
  );
}

Future<void> _convert() async {
    var apikey = "e24704a0-3f12-11ec-be8c-df48dc56be94";
    var url = Uri.parse(
        'https://freecurrencyapi.net/api/v2/latest?apikey=$apikey&base_currency=$selectFcur');
    http.Response res = await http.get(url);
    if (res.statusCode == 200) 
    {
      var jsonData = res.body;
      var parsedJson = json.decode(jsonData);
      val = parsedJson['data'][selectTcur];
      
      setState(() {
        input = double.parse(textEditingController.text);
        result = (input * parsedJson['data'][selectTcur]).toStringAsFixed(2);
      });
    } else {
      print("Failed");
    }
  }
}