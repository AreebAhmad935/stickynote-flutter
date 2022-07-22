
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  
    {
  "type": "service_account",
  "project_id": "flutter-stickynotes",
  "private_key_id": "153a2c92f3fd8364ca7f72a0880dd0943fee5f7e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNNRY44r4rA11H\n4ivv8zk2NYo5yz+XyPorvjJlO038wLjvvmCOOZDVzVBDaTyOidNr42nUhL3AlpMm\nl+E8SdugHCmgTPho+y/08oA0mLbcTtQetuBNUGESmywWROgiL0Gkf+NEm1S9afOV\naQM7dqAlT9PHsihTrAG4/KnQUGNH6rNxTdhzMTEExiSQEQqVmtt+tXFNe1V6kpdF\nflOopMpbrjEBag7UqjD8FkJ9ifak1oWrw61otgRdnn0MjrF/aWpQ/t/mOEklfiK0\nhNv/QsDr8nL1XmVtChqyDbc1UfHoS/q8b+r7a7URuRPi1vUYXnIxsK+0PDHRrlf/\nDDtIvJF5AgMBAAECggEAEKyb3+byv2GAWqcy3UZE85Xxo6UTh4Sd6WCEzUt+mIdb\nb6WnSF8+mNTcTQH32PgzjPx3XLylg4jor5XfSCwTM8UeD8e5VqR0fuGWj8+J6khg\nfZdsDfQ2UxH3SN70AtUWryRyJeC+R77ce1tDVzlaJXYBViRwmO3s3Ohw7vudOZpg\nDUmrSmyT/qOH5R6b9UKHfSgwE42fyh6bPFmU8BgyEEwrSpqf454s/OiDonpH9zSK\nVCuN/WQE2CL/bJhXaazkgRGfuh+tirLzDB3zxT0AR/9z7IwlxnZJ5yR/vmG1CY/N\n9MGcJWfJqS/CY6fd/FUTpK43iCU7Odd9cIBH5Xl3dQKBgQDv78MHExeM/hVJgMcV\n5a0ZhySqEvHIaoa2AEU3ADCLYL2VxQDhIBqHh0FoVbpVWQRIU1BPTRT5nSFPP7p7\neBaUPqagvWKEAylyx0iEqfynj0e2DyWPXZq3n2xjnEz3Y+kr05GWZZcG+HD70lJ1\n8KA+ut3R348KLl2PJexoPoHJFQKBgQDa8hszcIX6EO3byR1EsuLF6X7ob3fInP0w\nStIBgBo++wZa5r/CEg9NZI8GNvVDBqTkrVEeufsMEQGwVmaUnHR3cSyeTs4eVta8\niuoqfvnaxWshFUgq/N0n5fy7BSx5bbcXVBeBePptFNnJhH43ZZwYMckoWa5sRT0V\n0C8nDAn31QKBgA41a546ojVmQop0xtVkIYkWeLRdpNXSgSG8CF1GdJl8ZB2/adrr\nFMcb2mK8WOl++QLzdBkOHoTdqkBQLNHs/aFPyHxSWsgoi8bRSFka2+xsTrnYUcgY\nqfXfygJoGiK4VvGSeNeoMnZmNgKjpOB5HHQ6irJIA+d9cWrtuv89XGA1AoGAM695\nqmAC0LCUZhEI/sG39P6U/evqfApLXs4a203RZFLAAk98rySyRhPaC56HsYXtASrE\n/prq38NYAbezyZtRhyzJWqnB0LmxQZsNgnCtLO7zxkCO488DqjqJueCTyiqTUUeB\nsQfNHlkQvJixbwRmn/OIyCS7n0WNEQwvRWl7JO0CgYEAyclaMn2MC7e6an2g91fU\nussWvvoZ7s0NbhXae3MW2ZSvNqxV8erE2ikY73d8UtR0vVEE5t8icUK6P3yzJ3zN\nYHpAjSjbUJd5GLwddQ+YUVTQogC3phtsI0kp/kzxguZsm87PojYZXr9Rbat1sKxQ\nbiTD3JEINvK92uh1D8G14zY=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-stickynotes@flutter-stickynotes.iam.gserviceaccount.com",
  "client_id": "109981652459847324705",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-stickynotes%40flutter-stickynotes.iam.gserviceaccount.com"
}

  ''';

  // set up & connect to the spreadsheet
  static const _spreadsheetId = '1_t-11x5LKd8I1bdhdUSI_dpTav893MDZ4F2Mfv8VaNU';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }
}