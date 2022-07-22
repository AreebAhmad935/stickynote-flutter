import 'package:flutter/material.dart';
import 'package:stickynote/textbox.dart';
import 'google_sheets_api.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: GoogleSheetsApi.currentNotes.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return MyTextBox(text: GoogleSheetsApi.currentNotes[index]);
        });
  }
}
