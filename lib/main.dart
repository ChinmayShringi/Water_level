import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var data;
Future<Post> fetchPost() async {
  final response =
  await http.get('http://10.0.2.2:5000/');
  if (response.statusCode == 200) {
    data = json.decode(response.body);
    data=data["institutes"] as List;
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final List temp;
  Post({this.temp});

  factory Post.fromJson(Map<String, dynamic> json) {
//    return data;
    return Post(
      temp:data,
    );
  }
}


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Level',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Water Level Indicator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double rating=0;
  Future<Post> post;
  String dropdownValue = '1';
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body:
     Padding(
        padding: EdgeInsets.all(20),
        child:Column(
          children: <Widget>[
            Text("Enter Volume or Select using scroll"),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset("assets/images/water.jpeg",width: MediaQuery.of(context).size.width/2, height: 150,),
                    Container(
                      width: 200,
                      child: TextField(
                        onChanged: (value){
                          setState(() {
                            print(value);
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter In Liters"
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                        height: 200,
                        child:FlutterSlider(
                          rtl: true,
                          values: [00],
                          max: 100,
                          min: 0,
                          axis: Axis.vertical,
                          onDragging: (handlerIndex, lowerValue, upperValue) {
                            rating = lowerValue;
                            setState(() {});
                          },
                        )
                    )
                  ],
                )
              ],
            ),
              SizedBox(height: 100,),
              Row(
                children: <Widget>[
                  Text("Select The No. Of containers:",style: TextStyle(fontSize: 24),),
                ],
              ),
            Row(
              children: <Widget>[
                SizedBox(width: 100,),
                DropdownButton<String>(
                  value: dropdownValue,
//                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue=newValue;
                      print(newValue);
                    });
                  },
                  items: <String>['ALL','1','2','3','4','5']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                      .toList(),
                )
              ],
            ),
            Container(
              child:
                FutureBuilder<Post>(
                    future: post,
                     builder: (context, snapshot) {
                      if (snapshot.hasData) {
                       print(snapshot.data);
                       }  else if (snapshot.hasError) {
                    return AlertDialog(
                    title: Text('Error!'),
                    content: SingleChildScrollView(
                    child: ListBody(
                    children: <Widget>[
                    Text("Please Check Your Network Connection!"),
                    Text("${snapshot.error}"),
                    ],
                    ),
                    ),
                    actions: <Widget>[
                    FlatButton(
                    child: Text('Ok'),
                    onPressed: () {},
                    ),
                    ],
                    );
                    }
                    return Column(
                    children: <Widget>[
                    CircularProgressIndicator(),
                 ],
                );
               },
              ),
            )
          ],
        )
      ),
      )
    );
  }
}
