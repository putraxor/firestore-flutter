import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(new App());

///APP
class App extends StatelessWidget {

  var _routes = <String, WidgetBuilder>{
    ListScreen.routeName: (BuildContext context) => new ListScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter CRUD',
      theme: new ThemeData(primarySwatch: Colors.blue, accentColor: Colors.lightBlue),
      home: new ListScreen(),
      routes: _routes,
      onGenerateRoute: (settings) {
        var path = settings.name.split('/');
        final param = path.length > 1 ? path[1] : null;
        return new MaterialPageRoute(
          builder: (context) => new FormScreen(id: param),
          settings: settings,
        );
      },
    );
  }
}


///DTO
class User {
  String name = "";
}


///LIST SCREEN
class ListScreen extends StatefulWidget {
  static String routeName = "list-screen";

  @override
  _ListScreenState createState() => new _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("User List")),
      body: new StreamBuilder(
          stream: Firestore.instance
              .collection("user")
              .snapshots,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return new Center(child: new Text("Loading"));
            return new ListView(
                children: snapshot.data.documents.map((data) {
                  return new ListTile(
                    title: new Text(data['name']),
                    onTap: () => Navigator.pushNamed(context, "${FormScreen.routeName}/${data.documentID}"),
                  );
                }).toList()
            );
          }),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, FormScreen.routeName)),
    );
  }
}

///FORM SCREEN
class FormScreen extends StatefulWidget {
  String id;
  static String routeName = "form-screen";


  FormScreen({this.id});

  @override
  _FormScreenState createState() => new _FormScreenState(id: id);
}

class _FormScreenState extends State<FormScreen> {
  String id;
  User user = new User();
  final formKey = new GlobalKey<FormState>();

  _FormScreenState({this.id});

  ///On save action
  _onSave() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      Firestore.instance
          .collection("user")
          .document(id).setData({'name': user.name});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Form"), actions: [new FlatButton(onPressed: () => _onSave(), child: new Text("Save"))]),
      body: new StreamBuilder(
          stream: Firestore.instance
              .collection("user")
              .document(id)
              .snapshots,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return new Center(child: new Text("Loading Form"));
            user.name = snapshot.data['name'];
            return new Form(
                key: formKey,
                child: new TextFormField(
                  initialValue: "${user.name}",
                  decoration: new InputDecoration(labelText: 'Name', hintText: "Type name", icon: new Icon(Icons.person_outline)),
                  validator: (val) => val.length == 0 ? 'Define user\'s name.' : null,
                  onSaved: (val) => user.name = val,
                )
            );
          }
      ),
    );
  }
}
