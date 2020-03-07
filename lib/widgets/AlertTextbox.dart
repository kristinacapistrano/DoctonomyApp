import 'package:flutter/material.dart';

class AlertTextbox extends AlertDialog {
  final String titleText;
  final String hint;
  final String initialValue;
  final String leftText;
  final String middleText;
  final String rightText;
  final Function leftAction;
  final Function middleAction;
  final Function rightAction;

  AlertTextbox(this.titleText, this.hint, this.initialValue, this.leftText, this.middleText, this.rightText, this.leftAction, this.middleAction, this.rightAction);

  @override
  Widget build(BuildContext context) {
    TextEditingController _alertInput = new TextEditingController();
    _alertInput.text = initialValue;

    List<Widget> buttons = [];
    if (leftText != null && leftAction != null) {
      buttons.add(FlatButton(child: new Text(leftText), onPressed: () => leftAction(_alertInput.text)));
    }
    if (middleText != null && middleAction != null) {
      buttons.add(FlatButton(child: new Text(middleText), onPressed: () => middleAction(_alertInput.text)));
    }
    if (rightText != null && rightAction != null) {
      buttons.add(FlatButton(child: new Text(rightText), onPressed: () => rightAction(_alertInput.text)));
    }

    return AlertDialog(
        title: Text(titleText),
        content: TextField(
          controller: _alertInput,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: buttons,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)))
    );
  }

}