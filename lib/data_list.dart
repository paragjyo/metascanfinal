import 'dart:convert';
import 'dart:io';

import 'package:dashboard/sidebar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'login.dart';

class Screen1 extends StatefulWidget {
  @override
  final String token;
  final bool isLoggedIn;
  const Screen1({Key? key, required this.token, required this.isLoggedIn}) : super(key: key);
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<Map<String, dynamic>> _dataRural = [];
  List<Map<String, dynamic>> _dataUrban = [];
  String ipAddress = '';
  int idTakenRural = 0;
  int idTakenUrban = 0;

  String collectorName = '';
  String collectorNumber = '';

  @override
  void initState() {
    super.initState();
    getIPAddress();
    // _queryDatabaseUrban();
    _queryDatabaseRural();
    final _dataCombined = [..._dataRural, ..._dataUrban];
  }

  Future<void> _queryDatabaseRural() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'test1.db'),
      version: 1,
    );
    try {
      final List<Map<String, dynamic>> data = await database.query('survey_form_rural_test');
      setState(() {
        _dataRural = data;
      });
      // Code to execute if there are no exceptions
    } catch (e) {
      // Code to execute if an exception is caught
      print('An exception occurred: $e');
    }

    print("YYYYYYYYYYYY");

    print(_dataRural);
    await database.close();
  }

  Future<void> _queryDatabaseUrban() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'test2.db'),
      version: 1,
    );
    final List<Map<String, dynamic>> dataTemp = await database.query('survey_form_urban_test');
    setState(() {
      _dataUrban = dataTemp;
    });
    print("XXXXXXXXX");

    print(_dataUrban);
    await database.close();
  }

  Future<String> getIPAddress() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();

      interfaces.forEach((interface) {
        interface.addresses.forEach((address) {
          if (address.address.isNotEmpty && address.rawAddress.isNotEmpty && !address.isLoopback && address.type == InternetAddressType.IPv4) {
            ipAddress = address.address;
          }
        });
      });
      print(ipAddress);
      return ipAddress;
    } catch (_) {
      return 'Failed to get IP address.';
    }
  }

  Future<void> _deleteDataRural(int recentId) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test1.db'),
      version: 1,
    );
    List<Map> data = await database.rawQuery('DELETE FROM survey_form_rural_test WHERE id = ${recentId}');
  }

  Future<void> _deleteDataUrban(int recentId) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test2.db'),
      version: 1,
    );
    List<Map> data = await database.rawQuery('DELETE FROM survey_form_urban_test WHERE id = ${recentId}');
  }

  Future<void> _syncDataRural() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test1.db'),
      version: 1,
    );

    List<Map> dataRuralToSync = await database.rawQuery('SELECT * FROM survey_form_rural_test');
    print("newdatadata");
    print(dataRuralToSync);

    // Convert the list to a JSON string
    String jsonString = jsonEncode(dataRuralToSync);

    // Update the 'collectorName' field for all items in the list
    List<dynamic> jsonData = json.decode(jsonString);
    jsonData.forEach((item) {
      setState(() {
        item['collectorName'] = collectorName;
        item['collectorNumber'] = collectorNumber;
      });
    });

    // Convert the JSON back to a list of maps
    List<Map<String, dynamic>> dataRuralToSyncFinal = List<Map<String, dynamic>>.from(jsonData);

    Map orgData = {"category": "rural", "test": true};

    for (var item = 0; item < dataRuralToSyncFinal.length; item++) {
      final Map<dynamic, dynamic> arr = {};
      dataRuralToSyncFinal[item].forEach((key, value) {
        if (key != "id") {
          arr.addEntries({
            MapEntry(key, value),
          });
        }
        if (key == "id") {
          idTakenRural = value;
        }
      });

      orgData.addEntries({
        MapEntry("tabletData", arr),
      });
      print("New data here: ${jsonEncode(orgData)}");

      var response = await http.post(
        Uri.parse('https://metascancorp.com/api/insert-new-record.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orgData),
      );

      Map insertResponse = jsonDecode(response.body);
      Map succsessResponse = {"status": "success", "message": "Done"};

      if (response.statusCode == 200) {
        print('Connected With API');
        if (mapEquals(insertResponse, succsessResponse)) {
          print("Data synced successfully!");
          print(idTakenRural);
          _deleteDataRural(idTakenRural);
        } else {
          print(insertResponse["message"]);
        }
      } else {
        print('Data sync failed!');
      }
    }

    await database.close(); // close the database after syncing data
  }

  Future<void> _syncDataUrban() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test2.db'),
      version: 1,
    );
    List<Map> dataUrbanToSync = await database.rawQuery('SELECT * FROM survey_form_urban_test');

    Map orgData = {"category": "urban", "test": true};

    for (var item = 0; item < dataUrbanToSync.length; item++) {
      final Map<dynamic, dynamic> arr = {};
      dataUrbanToSync[item].forEach((key, value) {
        if (key != "id") {
          arr.addEntries({
            MapEntry(key, value),
          });
        }
        if (key == "id") {
          idTakenUrban = value;
        }
      });

      orgData.addEntries({
        MapEntry("tabletData", arr),
      });
      print("New data here: ${jsonEncode(orgData)}");

      var response = await http.post(
        Uri.parse('https://metascancorp.com/api/insert-new-record.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orgData),
      );

      Map insertResponse = jsonDecode(response.body);
      Map succsessResponse = {"status": "success", "message": "Done"};

      if (response.statusCode == 200) {
        print('Connected With API');
        if (mapEquals(insertResponse, succsessResponse)) {
          print("Data synced successfully!");
          print(idTakenUrban);
          _deleteDataUrban(idTakenUrban);
        } else {
          print(insertResponse["message"]);
        }
      } else {
        print('Data sync failed!');
      }
    }

    await database.close(); // close the database after syncing data
  }

  Future<void> showLoginPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: LoginModalSheet(),
        );
      },
    );
  }

  Future<void> fetchCollData(String token) async {
    final response = await http.post(
      Uri.parse('https://metascancorp.com/api/login-status.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (responseData['status'] == 'success') {
      final data = responseData['decodedData']['data'];
      final id = data['id'];

      setState(() {
        collectorName = data['collectorName'];
        collectorNumber = data['collectorNumber'];
      });

      // Do something with the extracted data
      print('ID: $id');
      print('Collector Name: $collectorName');
      print('Collector Number: $collectorNumber');
    } else {
      final errorMessage = responseData['message'];

      // Do something with the error message
      print('Error: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Local Data'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          tooltip: "IP Address: ${ipAddress}",
          onPressed: () {
            // Perform search action
          },
        ),
      ]),
      drawer: SideBar(),
      body: ListView.builder(
        itemCount: _dataRural.length,
        itemBuilder: (context, index) {
          final item = _dataRural[index];
          return Card(
            elevation: 3,
            child: ListTile(
              title: Text(item['village_name']),
              trailing: Text("Rural"),
              subtitle: Text(item['district']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.isLoggedIn) {
            fetchCollData(widget.token);
            _syncDataRural();
          } else {
            showLoginPopup(context);
          }
        },
        child: widget.isLoggedIn ? Icon(Icons.upload) : Icon(Icons.login),
      ),
    );
  }
}
