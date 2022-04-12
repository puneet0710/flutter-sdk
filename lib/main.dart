import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'form_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: "AIzaSyCb08-188boJCcSZ2Wq3hWd63BKzxtFVXg", // Your apiKey
    appId: "1:559802030356:android:92ab0c6d54c1537f510a01", // Your appId
    databaseURL: "https://puneet-bal-utsav-default-rtdb.asia-southeast1.firebasedatabase.app/",
    messagingSenderId: "XXX", // Your messagingSenderId
    projectId: "puneet-bal-utsav", // Your projectId
  ),);
  //runApp(const MyApp());
  runApp(MaterialApp(
      title: 'Bal Utsav',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(app: app, title: 'Bal Utsav'),
  ));
}
class MyHomePage extends StatefulWidget {
  final FirebaseApp app;
  const MyHomePage({Key? key, required this.title, required this.app}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final refDataInstance = FirebaseDatabase.instance.reference().child('users');

  String _location ='';
  String _details='';
  String _name='';
  String _email='';
  String _password='';
  String _url='';
  String _phoneNumber='';
  String _calories='';

  var data ={ "name" : '',"email":'',"phoneNumber":"","location":"","details":""};

  List<Map> list = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      //controller: textController,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 10,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (value) {
        _name = value!;
        data["name"]=value;
      },
    );
  }

  Widget _buildLocation() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Location'),
      maxLength: 10,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Location is Required';
        }

        return null;
      },
      onSaved: (value) {
        _location = value!;
        data["location"]=value;
      },
    );
  }

  Widget _buildDetails() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Details'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Details is Required';
        }

        return null;
      },
      onSaved: (value) {
        _details = value!;
        data["details"]=value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (value) {
        _email = value!;
        data["email"]=value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: ( value) {
        if (value!.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  Widget _builURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Url'),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value!.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (value) {
        _url = value!;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (value) {
        _phoneNumber = value!;
        data["phoneNumber"] = value;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      validator: (value) {
        int? calories = int.tryParse(value!);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (value) {
        _calories = value!;
      },
    );
  }

  _openPopup(context) {
    Alert(
      context: context,
      title: "Enter Details",
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildName(),
            _buildEmail(),
            _buildPhoneNumber(),
            _buildLocation(),
            _buildDetails(),
            SizedBox(height: 100),
            DialogButton(
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                //put into firestore db
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                _formKey.currentState!.save();

                print(_name);
                print(_email);
                print(_phoneNumber);
                print(_location);
                print(_details);
                _updateList();
                refDataInstance.push().child('volunteer-details').set(data).asStream();
                Navigator.pop(context);
                //Send to API
              },
            ),
          ],
        ),
      ),
    ).show();
  }
  int _counter = 0;

  void _updateList() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      list.add({"name":data["name"],"email":data["email"],"phoneNumber":data["phoneNumber"],"location":data["location"],"details":data["details"]});
    });
    print(list);
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
      body: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Email',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Phone Number',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Location',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Details',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: list.map((e) => DataRow(cells: [
          DataCell(Text(e["name"].toString())),
          DataCell(Text(e["email"].toString())),
          DataCell(Text(e["phoneNumber"].toString())),
          DataCell(Text(e["location"].toString())),
          DataCell(Text(e["details"].toString()))
        ])).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: ()=>_openPopup(context),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
