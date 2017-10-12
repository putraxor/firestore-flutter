import 'dart:async';

import 'package:flutter/material.dart';

class ExpenseForm {

  final BuildContext context;

  ExpenseForm(this.context);

  Future<Null> show() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text('Expense Form'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('You will never be satisfied.'),
              new Text('You\’re like me. I’m never satisfied.'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Regret'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

