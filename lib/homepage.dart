import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stickynote/button.dart';
import 'package:stickynote/google_sheets_api.dart';
import 'package:stickynote/grid.dart';
import 'package:stickynote/loading.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  // when user presses POST
  void _save() async {
    await GoogleSheetsApi.insert(_controller.text);

    // clear the user typed text once note has been posted
    setState(() {
      _controller.clear();
    });
  }

  // wait for the data to be fetched from google sheets
  void startLoading() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'P O S T  a  N O T E',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: GoogleSheetsApi.loading ? const LoadingCircle() : const NotesGrid(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'post a little message..',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                          });
                        },
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '@AreebAhmad935.guthub.io',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                    MyButton(
                      text: 'P O S T',
                      function: _save,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
