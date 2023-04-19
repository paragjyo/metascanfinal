// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart' as permissionx;
import 'dart:ui' as ui;
import 'package:path/path.dart' as path;

import 'main.dart';

class PanchayatDomestic extends StatefulWidget {
  final String title;

  const PanchayatDomestic({Key? key, required this.title}) : super(key: key);
  @override
  State<PanchayatDomestic> createState() => _PanchayatDomesticState();
}

class _PanchayatDomesticState extends State<PanchayatDomestic> {
  String parag = "";
  bool _isProcessing = false;
  // final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  bool _isResizedPhoto = false;
  bool _isResizedNameplatePhoto = false;
  bool _storagePermissionGranted = false;
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _base64Image;

  String? _base64PhotoImage;
  String? _base64PhotoThumb;

  String? _base64NameplateImage;
  String? _base64NameplateThumb;

  File? _photoImageFile;
  File? _nameplateImageFile;

  // For all the variable of Form
  String _houseOwner = '';

  String _houseNo = '';

  String _district = "";

  String _block_development_office = "";

  String _road_name = "";

  String _village_name = "";

  String _village_panchayat_name = "";

  String _ward_no = "";

  String _house_flat_shop_office_no = "";

  String _house_owner_name = "";

  String _father_husband_name = "";

  String _number_of_male = "";

  String _number_of_female = "";

  String _number_of_male_female_total = "";

  String _number_of_male_below_5 = "";

  String _number_of_female_below_5 = "";

  String _number_of_male_female_total_below_5 = "";

  String _number_of_male_above_60 = "";

  String _number_of_female_above_60 = "";

  String _number_of_male_female_total_above_60 = "";

  String _caste = "";

  String _religion = "";

  String _no_of_handicapped_persons_physically = "";

  String _no_of_handicapped_persons_mentally = "";

  String _no_of_handicapped_persons_total = "";

  String _type_structure_of_house = "";

  String _house_lighting = "";

  String _fuel_of_cooking = "";

  String _source_of_drinking_water = "";

  String _existence_of_toilet_facility = "";

  String _access_to_welfare_benifits_by_any_family_member = "";

  String _number_of_govt_earning_adult_members_male = "";

  String _number_of_govt_earning_adult_members_female = "";

  String _number_of_govt_earning_adult_members_total = "";

  String _number_of_privale_earning_adult_members_male = "";

  String _number_of_privale_earning_adult_members_female = "";

  String _number_of_privale_earning_adult_members_total = "";

  String _source_of_income = "";

  String _shop_office_no = "";

  String _trade_license_no = "";

  String _name_of_the_landowner_of_the_shop = "";

  String _name_of_the_shop_owner = "";

  String _land_tenure = "";

  String _type_structure_of_shop = "";

  String _area_of_shop = "";

  String _electricity_facilities = "";

  String _image = "";

  String _latitude = "";

  String _longitude = "";

  String _imageSign = "";

  String _rccType = "";

  String _rccTypeShop = "";

  String _family_identification_certificate = "";

  String _area_of_living_land = "";

  String _area_of_agricultural_land = "";

  String _number_of_literate_male = "";

  String _number_of_literate_female = "";

  String _number_of_male_female_total_literate = "";

  String _number_of_illiterate_male = "";

  String _number_of_illiterate_female = "";

  String _number_of_male_female_total_illiterate = "";

  String _father_name_of_the_shop_owner = "";

  String _landowner_of_the_shop = "";

  String _father_name_of_the_landowner = "";

  String _type_of_shop = "";

  String _holding_no = "";

  String _payment_done = "";

  String _mode_of_payment = "";

  String _payment_optional = "";

  String _pricePayment = "";

  String _date_time = "";

  String _ip_address = "";

  String _contactNumber = "";

  String _category = "";

  String _image2 = "";

  String _image3 = "";

  String _collectorName = "";

  String _image0 = "";

  String _collectorNumber = "";

  ////Image variables

  String newFileName = '';
  String actualImage = '';
  String thumbImage = '';
  String actualImageNameplate = '';
  String thumbImageNameplate = '';

  String newFilePath = '';

  ////Image variables

  final TextEditingController _controller2 = TextEditingController();

  // For all the variable of Form
  int idTaken = 0;

  Future<List<Map<String, dynamic>>> _data = Future.value([]);

  List<String> familyIdentificationCertificateOptions = ['APL', 'BPL', 'MMAY', 'AY', 'None', 'Others'];

  List<String> accessToWelfareBenifitsByAnyFamilyMemberOptions = ['Old age pension', 'Widow pension', 'Disabled pension', 'Healty insurance', 'General insurance', 'Other'];

  List<String> casteOptions = [
    'Genarel',
    'OBC',
    'ST',
    'SC',
  ];

  List<String> religionOptions = [
    'Hindu',
    'Muslim',
    'Christian',
    'Sikh',
    'Buddhism',
    'Other',
  ];

  List<String> structureOfHouseOptions = [
    'Pucca',
    'Semi Pucca',
    'Katcha',
    'RCC',
    'RCC Story',
    'PMAY-G',
    'Other',
  ];

  List<String> houseLightingOptions = [
    'Electricity Connection',
    'Kerosene',
    'Other',
  ];

  List<String> fuelCookingOptions = [
    'Gas',
    'Electricity',
    'Kerosene',
    'Firewood',
    'Other',
  ];

  List<String> sourceDrinkingWaterOptions = ['Govt. tubewell', 'Private tubewell', 'Borewell', 'Govt. Supply', 'Private Supply', 'Other'];

  List<String> existenceOfToiletFacilityOptions = ['Govt. septic tank', 'Govt dry latrine', 'Own septic tank', 'Own dry latrine', 'Other'];

  List<String> landTenureOptions = ['Patta', 'Possession Certificate', 'Private Land Enchroached', 'Public Land Enchroached', 'Tented', 'Meyadi', 'Eksonia', 'Occupancy Right', 'Other'];

  List<String> otherSourceOfIncomeOptions = ['Daily Workers', 'Agriculture', 'Business', 'Self Employed', 'Ex Serviceman', 'Job Card', 'Rented Shop', 'Rented Tenate', 'None', 'Other'];

  List<String> _districts = [];

  List<String> _blocks = [];

  String _selectedDistrict = '';

  String _selectedBlock = '';

  File? image;

  late Future<String> futureData;

  // Map<String, dynamic> jsonMapDistrictBlock = {};
  Map<String, dynamic> globalJson = {};

  get futureResult => null;

  // Define the current step
  int _currentStep = 0;

  // Define functions to handle moving to the next/previous step
  Uint8List? exportedSignImage;

  String? signaturePath;

  ///SIgnature ///
  SignatureController controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.yellowAccent,
  );

  ///SIgnature ///

  Future<String> loadJson() async {
    String jsonString = await rootBundle.loadString('assets/district-block.json');
    setState(() {
      globalJson = json.decode(jsonString);
      _districts = globalJson.keys.toList();
      _selectedDistrict = _districts[0];
      _blocks = List<String>.from(globalJson[_selectedDistrict].values);
      _selectedBlock = _blocks[0];
    });

    return parag;
  }

  Future<List<Map<String, dynamic>>> _query() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test1.db'),
      version: 1,
    );
    List<Map<String, dynamic>> result = await database.query("user");
    await database.close(); // close the database after querying
    return result;
  }

  Future<void> fetchData() async {
    final data = await _data; // Replace futureResult with the actual instance of Future<List<Map<String, dynamic>>>
    // Iterate over the list of maps and print the values
    data.forEach((map) {
      map.forEach((key, value) {
        print('$key: $value');
      });
    });
  }

  Future<void> _syncData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test1.db'),
      version: 1,
    );
    List<Map> data = await database.rawQuery('SELECT * FROM survey_form_rural_test');

    Map orgData = {"category": "rural", "test": true};

    for (var item = 0; item < data.length; item++) {
      final Map<dynamic, dynamic> arr = {};
      data[item].forEach((key, value) {
        if (key != "id") {
          arr.addEntries({
            MapEntry(key, value),
          });
        }
        if (key == "id") {
          idTaken = value;
        }
      });
      // /data/data/com.example.metascan_crop/cache
      //   /data/user/0/com.example.metascan_crop/cache/8fbc72c5-acbb-46a4-9d69-33ba37172097/IMG_20230303_124030.jpg

      // Upload image to server

      // final result = await database.rawQuery(
      //     'SELECT image FROM survey_form_rural_test WHERE id = ${idTaken}');
      // print(result);
      // final fileToUploadOnline = File(result[0]['image'] as String);
      // final bytes = await fileToUploadOnline.readAsBytes();

      // print("gsagd");
      // print(bytes);

      // final base64Image = base64Encode(bytes);

      // print("BASE");
      // print(base64Image);

      // var request = http.MultipartRequest(
      //     'POST', Uri.parse('https://metascancorp.com/testing-image/'));

      // request.files.add(
      //     await http.MultipartFile.fromPath('file', fileToUploadOnline.path));

      // var response1 = await request.send();
      // print(response1);
      // if (response1.statusCode == 200) {
      //   print('File uploaded!');
      // } else {
      //   print('Upload failed.');
      // }

      // Upload image to server

      // final serverResponse = await http.post(
      //   Uri.parse('https://metascancorp.com/testing-image/'),
      //   body: {'image': "base64Image"},
      // );
      // print("SRVR RSP");
      // print(serverResponse as String);
      // final serverImagePath = jsonDecode(serverResponse.body)['path'];

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
          print(idTaken);
          _deleteData(idTaken);
        } else {
          print(insertResponse["message"]);
        }
      } else {
        print('Data sync failed!');
      }
    }

    await database.close(); // close the database after syncing data
  }

  Future<void> _deleteData(int recentId) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'test1.db'),
      version: 1,
    );
    List<Map> data = await database.rawQuery('DELETE FROM survey_form_rural_test WHERE id = ${recentId}');
  }

  Future<void> requestLocationPermission() async {
    final status = await permissionx.Permission.location.request();

    if (status.isGranted) {
      // getLocation();
      print('Location permission is granted');
    } else {
      print('Location permission not granted');
    }
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _latitude = position.latitude.toString();
    _longitude = position.longitude.toString();
    print(_latitude);
    print(_longitude);
  }

  Future<String> getUserInputForOriginalName() async {
    // You can implement this function to get the original name from the user,
    // for example, by showing a dialog or using a text field.
    return 'originalImageName';
  }

// IP ADDRESS
  Future<String> getIPAddress() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();
      String ipAddress = '';
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
  // IP ADDRESS

  //STEPPER CUSTOM BUTTON
  void _onContinue() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      setState(() {
        if (_currentStep < 4) {
          _currentStep += 1;
        }
      });
    }
  }

  void _onCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      } else {
        _currentStep = 0;
      }
    });
  }

  void _submitForm() {
    // Do something with the form data
  }

  //STEPPER CUSTOM BUTTON

  // DATABASE PATH
  Future<String> getDatabasePath() async {
    final directory = Directory('/data/data/com.example.dashboard/databases');
    final databasePath = join(directory.path, 'test1.db');
    print("Database path: $databasePath");
    return databasePath;
  }
  // DATABASE PATH

  //Create Table
  Future<Database> createTable() async {
    final databasePath = await getDatabasePath();

    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();

    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        return db.transaction((txn) async {
          // create the table if it does not already exist
          await txn.execute('''
   CREATE TABLE IF NOT EXISTS survey_form_rural_test (id INTEGER PRIMARY KEY ,
district TEXT DEFAULT NULL,
block_development_office TEXT DEFAULT NULL,
road_name TEXT DEFAULT NULL,
village_name TEXT DEFAULT NULL,
village_panchayat_name TEXT DEFAULT NULL,
ward_no TEXT DEFAULT NULL,
house_flat_shop_office_no TEXT DEFAULT NULL,
house_owner_name TEXT DEFAULT NULL,
father_husband_name TEXT DEFAULT NULL,
number_of_male TEXT DEFAULT NULL,
number_of_female TEXT DEFAULT NULL,
number_of_male_female_total TEXT DEFAULT NULL,
number_of_male_below_5 TEXT DEFAULT NULL,
number_of_female_below_5 TEXT DEFAULT NULL,
number_of_male_female_total_below_5 TEXT DEFAULT NULL,
number_of_male_above_60 TEXT DEFAULT NULL,
number_of_female_above_60 TEXT DEFAULT NULL,
number_of_male_female_total_above_60 TEXT DEFAULT NULL,
caste TEXT DEFAULT NULL,
religion TEXT DEFAULT NULL,
no_of_handicapped_persons_physically TEXT DEFAULT NULL,
no_of_handicapped_persons_mentally TEXT DEFAULT NULL,
no_of_handicapped_persons_total TEXT DEFAULT NULL,
type_structure_of_house TEXT DEFAULT NULL,
house_lighting TEXT DEFAULT NULL,
fuel_of_cooking TEXT DEFAULT NULL,
source_of_drinking_water TEXT DEFAULT NULL,
existence_of_toilet_facility TEXT DEFAULT NULL,
access_to_welfare_benifits_by_any_family_member TEXT DEFAULT NULL,
number_of_govt_earning_adult_members_male TEXT DEFAULT NULL,
number_of_govt_earning_adult_members_female TEXT DEFAULT NULL,
number_of_govt_earning_adult_members_total TEXT DEFAULT NULL,
number_of_privale_earning_adult_members_male TEXT DEFAULT NULL,
number_of_privale_earning_adult_members_female TEXT DEFAULT NULL,
number_of_privale_earning_adult_members_total TEXT DEFAULT NULL,
source_of_income TEXT DEFAULT NULL,
shop_office_no TEXT DEFAULT NULL,
trade_license_no TEXT DEFAULT NULL,
name_of_the_landowner_of_the_shop TEXT DEFAULT NULL,
name_of_the_shop_owner TEXT DEFAULT NULL,
land_tenure TEXT DEFAULT NULL,
type_structure_of_shop TEXT DEFAULT NULL,
area_of_shop TEXT DEFAULT NULL,
electricity_facilities TEXT DEFAULT NULL,
image TEXT DEFAULT NULL,
latitude TEXT DEFAULT NULL,
longitude TEXT DEFAULT NULL,
imageSign TEXT DEFAULT NULL,
rccType TEXT DEFAULT NULL,
rccTypeShop TEXT DEFAULT NULL,
family_identification_certificate TEXT DEFAULT NULL,
area_of_living_land TEXT DEFAULT NULL,
area_of_agricultural_land TEXT DEFAULT NULL,
number_of_literate_male TEXT DEFAULT NULL,
number_of_literate_female TEXT DEFAULT NULL,
number_of_male_female_total_literate TEXT DEFAULT NULL,
number_of_illiterate_male TEXT DEFAULT NULL,
number_of_illiterate_female TEXT DEFAULT NULL,
number_of_male_female_total_illiterate TEXT DEFAULT NULL,
father_name_of_the_shop_owner TEXT DEFAULT NULL,
landowner_of_the_shop TEXT DEFAULT NULL,
father_name_of_the_landowner TEXT DEFAULT NULL,
type_of_shop TEXT DEFAULT NULL,
holding_no TEXT DEFAULT NULL,
payment_done TEXT  DEFAULT NULL,
mode_of_payment TEXT  DEFAULT NULL,
payment_optional TEXT DEFAULT NULL,
pricePayment TEXT  DEFAULT NULL,
date_time TEXT DEFAULT NULL,
ip_address TEXT DEFAULT NULL,
contactNumber TEXT DEFAULT NULL,
category TEXT DEFAULT NULL,
image2 TEXT DEFAULT NULL,
image3 TEXT DEFAULT NULL,
collectorName TEXT DEFAULT NULL,
image0 TEXT DEFAULT NULL,
collectorNumber TEXT DEFAULT NULL);
''');
          debugPrint("DONE");
        });
      },
      version: 1,
    );

    debugPrint('Table created');
    return database;
  }

// SAVE THE FULL FORM DATA
  void _saveFullUserDataToDatabase() async {
    final database = await createTable();
    try {
      await database.insert(
        'survey_form_rural_test',
        {
          "district": _district,
          "block_development_office": _block_development_office,
          "road_name": _road_name,
          "village_name": _village_name,
          "village_panchayat_name": _village_panchayat_name,
          "ward_no": _ward_no,
          "house_flat_shop_office_no": _house_flat_shop_office_no,
          "house_owner_name": _house_owner_name,
          "father_husband_name": _father_husband_name,
          "number_of_male": _number_of_male,
          "number_of_female": _number_of_female,
          "number_of_male_female_total": _number_of_male_female_total,
          "number_of_male_below_5": _number_of_male_below_5,
          "number_of_female_below_5": _number_of_female_below_5,
          "number_of_male_female_total_below_5": _number_of_male_female_total_below_5,
          "number_of_male_above_60": _number_of_male_above_60,
          "number_of_female_above_60": _number_of_female_above_60,
          "number_of_male_female_total_above_60": _number_of_male_female_total_above_60,
          "caste": _caste,
          "religion": _religion,
          "no_of_handicapped_persons_physically": _no_of_handicapped_persons_physically,
          "no_of_handicapped_persons_mentally": _no_of_handicapped_persons_mentally,
          "no_of_handicapped_persons_total": _no_of_handicapped_persons_total,
          "type_structure_of_house": _type_structure_of_house,
          "house_lighting": _house_lighting,
          "fuel_of_cooking": _fuel_of_cooking,
          "source_of_drinking_water": _source_of_drinking_water,
          "existence_of_toilet_facility": _existence_of_toilet_facility,
          "access_to_welfare_benifits_by_any_family_member": _access_to_welfare_benifits_by_any_family_member,
          "number_of_govt_earning_adult_members_male": _number_of_govt_earning_adult_members_male,
          "number_of_govt_earning_adult_members_female": _number_of_govt_earning_adult_members_female,
          "number_of_govt_earning_adult_members_total": _number_of_govt_earning_adult_members_total,
          "number_of_privale_earning_adult_members_male": _number_of_privale_earning_adult_members_male,
          "number_of_privale_earning_adult_members_female": _number_of_privale_earning_adult_members_female,
          "number_of_privale_earning_adult_members_total": _number_of_privale_earning_adult_members_total,
          "source_of_income": _source_of_income,
          "shop_office_no": _shop_office_no,
          "trade_license_no": _trade_license_no,
          "name_of_the_landowner_of_the_shop": _name_of_the_landowner_of_the_shop,
          "name_of_the_shop_owner": _name_of_the_shop_owner,
          "land_tenure": _land_tenure,
          "type_structure_of_shop": _type_structure_of_shop,
          "area_of_shop": _area_of_shop,
          "electricity_facilities": _electricity_facilities,
          "latitude": _latitude,
          "longitude": _longitude,
          "imageSign": _imageSign,
          "rccType": _rccType,
          "rccTypeShop": _rccTypeShop,
          "family_identification_certificate": _family_identification_certificate,
          "area_of_living_land": _area_of_living_land,
          "area_of_agricultural_land": _area_of_agricultural_land,
          "number_of_literate_male": _number_of_literate_male,
          "number_of_literate_female": _number_of_literate_female,
          "number_of_male_female_total_literate": _number_of_male_female_total_literate,
          "number_of_illiterate_male": _number_of_illiterate_male,
          "number_of_illiterate_female": _number_of_illiterate_female,
          "number_of_male_female_total_illiterate": _number_of_male_female_total_illiterate,
          "father_name_of_the_shop_owner": _father_name_of_the_shop_owner,
          "landowner_of_the_shop": _landowner_of_the_shop,
          "father_name_of_the_landowner": _father_name_of_the_landowner,
          "type_of_shop": _type_of_shop,
          "holding_no": _holding_no,
          "payment_done": _payment_done,
          "mode_of_payment": _mode_of_payment,
          "payment_optional": _payment_optional,
          "pricePayment": _pricePayment,
          "date_time": _date_time,
          "ip_address": _ip_address,
          "contactNumber": _contactNumber,
          "category": _category,
          "image2": _image2,
          "image": _image,
          "image3": _image3,
          "collectorName": _collectorName,
          "image0": _image0,
          "collectorNumber": _collectorNumber,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      createTable();
    }

    await database.close();
  }
  // SAVE THE FULL FORM DATA

  Future<File?> _pickImage(ImageSource source) async {
    // final imageProcessing = _MyImagePickerState();

    final pickedFile = await _picker.pickImage(source: source);
    // imageProcessing.bytes = await pickedFile!.readAsBytes();
    final bytes = await pickedFile!.readAsBytes();
    setState(() {
      _imageFile = File(pickedFile!.path);
      _base64Image = base64Encode(_imageFile!.readAsBytesSync());
    });
    // print(_imageFile);
    return _imageFile;
  }

  Future<void> requestStoragePermission() async {
    var status = await permissionx.Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        _storagePermissionGranted = true;
      });
    } else if (status.isDenied) {
      setState(() {
        _storagePermissionGranted = false;
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _storagePermissionGranted = false;
      });
    }
  }

// IMAGE UPLOAD WITH CAMERA AND FRM GALLERY
  Future<String> _resizeImage(File? orgImage, int size) async {
    print("newww");
    print(orgImage);

    final bytesWWW = await orgImage!.readAsBytes();
    final imageWWW = await decodeImageFromList(bytesWWW);

    print(imageWWW.height);
    print(imageWWW.width);

    /////
    // var byt = await _extractImage(pickedFile);
    // final image = await decodeImageFromList(byt);
    // imgpk.Image? img = imgpk.decodeImage(bytes!);

    final maxSize = size;

    // // Calculate scaled size while maintaining aspect ratio
    double scale = 1.0;
    if (imageWWW.width > maxSize || imageWWW.height > maxSize) {
      if (imageWWW.width > imageWWW.height) {
        scale = maxSize / imageWWW.width;
      } else {
        scale = maxSize / imageWWW.height;
      }
    }
    final newWidth = (imageWWW.width * scale).round();
    final newHeight = (imageWWW.height * scale).round();

    final recorder = ui.PictureRecorder(); // Create a new PictureRecorder object
    final newCanvas = ui.Canvas(recorder);
    newCanvas.drawImage(imageWWW, ui.Offset.zero, ui.Paint());

    final newImage = await recorder.endRecording().toImage(newWidth, newHeight);
    final pngBytes = await newImage.toByteData(format: ui.ImageByteFormat.png);
    if (size == 120) {
      newFileName = path.basenameWithoutExtension(orgImage!.path) + 'thumb.png';
    } else if (size == 500) {
      newFileName = path.basenameWithoutExtension(orgImage!.path) + '_resized.png';
    }
    newFilePath = path.join(orgImage!.parent.path, newFileName);
    final newFile = File(newFilePath);
    await newFile.writeAsBytes(pngBytes!.buffer.asUint8List());

    ///

    print("new hgt wdth::::::");
    print(newFile);
    print(newHeight);
    print(newWidth);

    return newFilePath;
  }

  // IMAGE UPLOAD WITH CAMERA AND FRM GALLERY

  Future<void> _saveSignature() async {
    final databaseSign = await getDatabasePath();
    print(databaseSign);

    final database = await openDatabase(
      databaseSign,
      onCreate: (db, version) {
        return db.transaction((txn) async {
          // create the table if it does not already exist
          await txn.execute(
            "CREATE TABLE IF NOT EXISTS signatures(id INTEGER PRIMARY KEY,path TEXT);",
          );
        });
      },
      version: 1,
    );

    print(database);
    await database.insert(
      'signatures',
      {'path': signaturePath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await database.close(); // close the database after inserting data
  }

  @override
  void initState() {
    super.initState();
    createTable();
    loadJson();
    getLocation();
    print(globalJson);
    requestLocationPermission();
    requestStoragePermission();
    // _saveSignature;

    // Create and open the db, if it doesn't exist

    // final Future<Database> database = openDatabase(
    //   join( getDatabasesPath() as String, 'signatures_database.db'),
    //   onCreate: (db, version) {
    //     return db.execute(
    //       "CREATE TABLE signatures(id INTEGER PRIMARY KEY,path TEXT);",
    //     );
    //   },
    //   version: 1,
    // );

    // getLocation();
  }

  // const PanchayatDomestic({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Panchayat Domestic"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        child: Stepper(
                          type: StepperType.horizontal,
                          currentStep: _currentStep,
                          onStepContinue: () {
                            setState(() {
                              if (_formKeys[_currentStep].currentState!.validate()) {
                                _currentStep++;
                              }
                            });
                          },
                          onStepCancel: () {
                            setState(() {
                              if (_currentStep > 0) {
                                _currentStep -= 1;
                              } else {
                                _currentStep = 0;
                              }
                            });
                          },
                          steps: [
                            Step(
                                title: Text(" "),
                                content: Form(
                                  key: _formKeys[0],
                                  child: Column(
                                    children: [
                                      Text(
                                        'Latitude: ${_latitude}',
                                      ),
                                      Text('Longitude: ${_longitude}'),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'Village Panchayat Name',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter Village Panchayat Name";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => _village_panchayat_name = value as String,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        value: _selectedDistrict,
                                        items: _districts.map((district) {
                                          return DropdownMenuItem<String>(
                                            value: district,
                                            child: Text(district),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedDistrict = value!;
                                            _blocks = List<String>.from(globalJson[_selectedDistrict].values);
                                            _selectedBlock = _blocks[0];
                                          });
                                          print(_selectedDistrict);
                                          _district = _selectedDistrict;
                                        },
                                      ),
                                      SizedBox(height: 16.0),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        value: _selectedBlock,
                                        items: _blocks.map((block) {
                                          return DropdownMenuItem<String>(
                                            value: block,
                                            child: Text(block),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedBlock = value!;
                                          });
                                          print(_selectedBlock);
                                          _block_development_office = _selectedBlock;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'Ward No.',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter Warn No.";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => _ward_no = value as String,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'Village Name',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter Village Name";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => _village_name = value as String,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'Road Name',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter Road Name";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => _road_name = value as String,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      // TextFormField(
                                      //   decoration: InputDecoration(
                                      //     filled: true,
                                      //     fillColor: Colors.grey[200],
                                      //     border: OutlineInputBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10),
                                      //         borderSide: BorderSide.none),
                                      //     labelText: 'House Owner Name',
                                      //     hintStyle:
                                      //         TextStyle(color: Colors.grey[500]),
                                      //   ),
                                      //   // style: TextStyle(fontSize: 18, color: Colors.black),
                                      //   validator: (value) {
                                      //     if (value?.isEmpty ?? true) {
                                      //       return "Please enter a house_owner_name";
                                      //     }
                                      //     return null;
                                      //   },
                                      //   onChanged: (value) =>
                                      //       _houseOwner = value as String,
                                      // ),
                                      // SizedBox(
                                      //   height: 15,
                                      // ),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                            labelText: 'House Number',
                                            hintStyle: TextStyle(color: Colors.grey[500]),
                                          ),
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "Please enter an house_flat_shop_office_no";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            _house_flat_shop_office_no = value as String;
                                            print(_houseNo);
                                          }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                            labelText: 'Holding No.',
                                            hintStyle: TextStyle(color: Colors.grey[500]),
                                          ),
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "Please enter an Holding No.";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            _holding_no = value as String;
                                          }),
                                    ],
                                  ),
                                )),
                            Step(
                              title: Text(" "),
                              content: Form(
                                key: _formKeys[1],
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'House Owner Name//',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter a House Owner Name";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _house_owner_name = value as String;
                                          print(_houseOwner);
                                        }),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'Father\'s / Husband\'s Name',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter Father\'s / Husband\'s Name";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _father_husband_name = value as String;
                                        }),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                        keyboardType: TextInputType.number,
                                        maxLength: 10,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                          labelText: 'Contact Number',
                                          hintStyle: TextStyle(color: Colors.grey[500]),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return "Please enter Contact Number";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _contactNumber = value as String;
                                        }),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Number of Male / Female',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              maxLength: 2,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              maxLength: 2,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_female = value as String;
                                                int total = int.parse(_number_of_male) + int.parse(_number_of_female);
                                                _number_of_male_female_total = total.toString();
                                                _controller2.text = total.toString();
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              enabled: false,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              controller: _controller2,
                                              onChanged: (value) {
                                                _number_of_male_female_total = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Number of Children below 5 yrs. Male/ Female',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_below_5 = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_female_below_5 = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_female_total_below_5 = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Number of Senior Citizen above 60 yrs. Male/ Female',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_above_60 = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_female_above_60 = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_female_total_above_60 = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Number of literate members',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_literate_male = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_literate_female = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_female_total_literate = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Number of illiterate members',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_illiterate_male = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_illiterate_female = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_female_total_illiterate = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'No. of Handicapped Persons',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Physically',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _no_of_handicapped_persons_physically = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Mentally',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _no_of_handicapped_persons_mentally = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _no_of_handicapped_persons_total = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: familyIdentificationCertificateOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _family_identification_certificate = value!;
                                        });
                                      },
                                      hint: Text('Family Identification Certificate'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: accessToWelfareBenifitsByAnyFamilyMemberOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _access_to_welfare_benifits_by_any_family_member = value!;
                                        });
                                      },
                                      hint: Text('Access to welfare benifits'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: casteOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _caste = value!;
                                        });
                                      },
                                      hint: Text('Caste'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: religionOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _religion = value!;
                                        });
                                      },
                                      hint: Text('Religion'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: Text(" "),
                              content: Form(
                                key: _formKeys[2],
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                        labelText: 'Area of living land',
                                        hintStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return "Area of living land";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) => _area_of_living_land = value as String,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                        labelText: 'Area of agricultural land',
                                        hintStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return "Please enter Area of agricultural land";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) => _area_of_agricultural_land = value as String,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: structureOfHouseOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _type_structure_of_house = value!;
                                        });
                                      },
                                      hint: Text('Structure of house'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: houseLightingOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _house_lighting = value!;
                                        });
                                      },
                                      hint: Text('House lighting'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: fuelCookingOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _fuel_of_cooking = value!;
                                        });
                                      },
                                      hint: Text('Fuel of cooking'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: sourceDrinkingWaterOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _source_of_drinking_water = value!;
                                        });
                                      },
                                      hint: Text('Source of drinking water'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: existenceOfToiletFacilityOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _existence_of_toilet_facility = value!;
                                        });
                                      },
                                      hint: Text('Existence of toilet facility'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: landTenureOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _land_tenure = value!;
                                        });
                                      },
                                      hint: Text('Land Tenure'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: Text(" "),
                              content: Form(
                                key: _formKeys[3],
                                child: Column(
                                  children: [
                                    Text(
                                      'Number of govt. earning adult members',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_female = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_female_total = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Number of private earning adult members',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Male',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Female',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_female = value as String;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                                labelText: 'Total',
                                                hintStyle: TextStyle(color: Colors.grey[500]),
                                              ),
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "fill";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _number_of_male_female_total = value as String;
                                              }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: otherSourceOfIncomeOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _source_of_income = value!;
                                        });
                                      },
                                      hint: Text('Other source of income'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: Text(""),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Signature"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Signature(
                                    controller: controller,
                                    width: 300,
                                    height: 150,
                                    backgroundColor: Colors.lightBlue[100]!,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final bytes = await controller.toPngBytes();
                                            final directory = await getApplicationDocumentsDirectory();
                                            final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';
                                            final file = File('${directory.path}/$fileName');
                                            await file.writeAsBytes(bytes!);
                                            setState(() {
                                              exportedSignImage = bytes;
                                              signaturePath = file.path;
                                            });
                                            _saveSignature();
                                            _imageSign = await _resizeImage(file, 150);
                                            print(_imageSign);
                                            print(globalJson);
                                          },
                                          child: const Text(
                                            "Save",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: BorderSide(color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.clear();
                                          },
                                          child: const Text(
                                            "Clear",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: BorderSide(color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SafeArea(
                                                // ignore: unnecessary_new
                                                child: new Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    new ListTile(
                                                      leading: new Icon(Icons.photo_camera),
                                                      title: new Text('Take a Picture'),
                                                      onTap: () async {
                                                        _photoImageFile = await _pickImage(ImageSource.camera);

                                                        actualImage = await _resizeImage(_photoImageFile, 500);
                                                        _base64PhotoImage = base64Encode(File(actualImage).readAsBytesSync());
                                                        thumbImage = await _resizeImage(_photoImageFile, 120);
                                                        _base64PhotoThumb = base64Encode(File(thumbImage).readAsBytesSync());
                                                        _photoImageFile!.delete();
                                                        setState(() {
                                                          _isResizedPhoto = true; // set _isResized to true if resizing is successful
                                                        });
                                                        _image = actualImage;
                                                        _image0 = thumbImage;
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    new ListTile(
                                                      leading: new Icon(Icons.photo_library),
                                                      title: new Text('Choose from Gallery'),
                                                      onTap: () async {
                                                        _photoImageFile = await _pickImage(ImageSource.gallery);

                                                        actualImage = await _resizeImage(_photoImageFile, 500);
                                                        _base64PhotoImage = base64Encode(File(actualImage).readAsBytesSync());
                                                        thumbImage = await _resizeImage(_photoImageFile, 120);
                                                        _base64PhotoThumb = base64Encode(File(thumbImage).readAsBytesSync());
                                                        _photoImageFile!.delete();
                                                        setState(() {
                                                          _isResizedPhoto = true; // set _isResized to true if resizing is successful
                                                        });

                                                        _image = actualImage;
                                                        _image0 = thumbImage;
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Upload Photo'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      if (_isResizedPhoto)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SafeArea(
                                                // ignore: unnecessary_new
                                                child: new Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    new ListTile(
                                                      leading: new Icon(Icons.photo_camera),
                                                      title: new Text('Take a Picture'),
                                                      onTap: () async {
                                                        _nameplateImageFile = await _pickImage(ImageSource.camera);
                                                        actualImageNameplate = await _resizeImage(_nameplateImageFile, 500);
                                                        _base64NameplateImage = base64Encode(File(actualImageNameplate).readAsBytesSync());
                                                        thumbImageNameplate = await _resizeImage(_nameplateImageFile, 120);
                                                        _base64NameplateThumb = base64Encode(File(actualImageNameplate).readAsBytesSync());
                                                        _nameplateImageFile!.delete();
                                                        setState(() {
                                                          _isResizedNameplatePhoto = true; // set _isResized to true if resizing is successful
                                                        });

                                                        _image2 = actualImageNameplate;
                                                        _image0 = thumbImageNameplate;
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    new ListTile(
                                                      leading: new Icon(Icons.photo_library),
                                                      title: new Text('Choose from Gallery'),
                                                      onTap: () async {
                                                        _nameplateImageFile = await _pickImage(ImageSource.gallery);
                                                        actualImageNameplate = await _resizeImage(_nameplateImageFile, 500);
                                                        _base64NameplateImage = base64Encode(File(actualImageNameplate).readAsBytesSync());
                                                        thumbImageNameplate = await _resizeImage(_nameplateImageFile, 120);
                                                        _base64NameplateThumb = base64Encode(File(actualImageNameplate).readAsBytesSync());
                                                        _nameplateImageFile!.delete();
                                                        setState(() {
                                                          _isResizedNameplatePhoto = true; // set _isResized to true if resizing is successful
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Nameplate Photo'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      if (_isResizedNameplatePhoto)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                          controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) => SizedBox(),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: _onCancel,
                          child: Text('    Back    '),
                        ),
                        _currentStep < 4
                            ? ElevatedButton(
                                onPressed: _onContinue,
                                child: Text('Continue'),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  // Call your functions here

                                  _saveFullUserDataToDatabase();
                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  // Show the dialog
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false, // Set to true if you want to allow dismissing the dialog by tapping outside it
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: Dialog(
                                          child: Container(
                                            width: double.infinity,
                                            height: 500,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Lottie.asset(
                                                  'animations/process_done.json',
                                                  fit: BoxFit.contain,
                                                  repeat: false,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => MyHomePage()),
                                                    );
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ElevatedButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.disabled)) {
                                          // Set the button color when it's disabled
                                          return Colors.blue;
                                        }
                                        // Set the button color when it's enabled
                                        return Colors.white;
                                      },
                                    ),
                                  ),
                                  child: Text('Submit'),
                                ),
                              ),
                      ],
                    ),

                    // Container(
                    //   height: 200,
                    //   width: double.infinity,
                    //   child: _imagePath != null && _imagePath.isNotEmpty
                    //       ? File(_imagePath).existsSync()
                    //           ? Image.file(File(_imagePath))
                    //           : Container(
                    //               decoration: BoxDecoration(
                    //                   borderRadius:
                    //                       BorderRadius.circular(50)),
                    //               color: Colors.grey[300],
                    //               child: Center(
                    //                 child: Text('File not found'),
                    //               ),
                    //             )
                    //       : Container(
                    //           color: Colors.grey[300],
                    //           child: Center(
                    //             child: Text('No Image Selected'),
                    //           ),
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                // Row(
                //   children: [
                //     SizedBox(
                //       height: 15,
                //     ),
                //     ElevatedButton(
                //       onPressed: () async {
                //         final database = await openDatabase(
                //           join(await getDatabasesPath(), 'test.db'),
                //           version: 1,
                //           onCreate: (db, version) {},
                //         );
                //         final List<Map> maps =
                //             await database.rawQuery('SELECT * FROM signatures');
                //         print("Image Data is here");
                //         print(maps);
                //         await database
                //             .close(); // close the database after querying
                //       },
                //       child: Text('Show All Images'),
                //     ),
                //   ],
                // ),

                // Row(
                //   children: [
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.grey,
                //       ),
                //       onPressed: _saveFullUserDataToDatabase,
                //       child: Text("Save"),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.grey,
                //       ),
                //       onPressed: () async {
                //         setState(() {
                //           _data = _query();
                //         });
                //       },
                //       child: Text("Display Data"),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.grey,
                //       ),
                //       onPressed: _syncData,
                //       child: Text("Sync Data"),
                //     ),
                //   ],
                // ),
                // FutureBuilder<List<Map<String, dynamic>>>(
                //   future: _data,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData && snapshot.data != null) {
                //       return ListView.builder(
                //         itemCount: snapshot.data?.length ?? 0,
                //         itemBuilder: (context, index) {
                //           Map<String, dynamic> item = snapshot.data![index];
                //           return ListTile(
                //             title: Text(item['house_owner_name']),
                //             subtitle: Text(item['house_flat_shop_office_no']),
                //           );
                //         },
                //       );
                //     } else {
                //       return Container();
                //     }
                //   },
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
