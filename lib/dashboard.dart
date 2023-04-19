// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors

import 'package:dashboard/panchayat_commercial_form.dart';
import 'package:flutter/material.dart';
import 'panchayat_domestic_form.dart';
import 'urban_domestic_form.dart';
import 'urban_commercial_form.dart';

class MyGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanchayatDomestic(
                      title: 'Panchayat Form\nDomestic(FORM-A)'),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0), // Add padding to the card
              child: Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    'Panchayat\nDomestic\n(FORM-A)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                color: Colors.blue,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PanchayatCommercial(title: 'Card 2')),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0), // Add padding to the card
              child: Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    'Panchayat\nCommercial\n(FORM-B)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                color: Colors.blue,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UrbanDomestic(title: 'Card 3')),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0), // Add padding to the card
              child: Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    'Urban\nDomestic\n(FORM-A)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                color: Color.fromARGB(255, 194, 174, 0),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UrbanCommercial(title: 'Card 4')),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0), // Add padding to the card
              child: Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    'Urban\nCommercial\n(FORM-B)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                color: Color.fromARGB(255, 194, 174, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String title;
  final Color color;

  const MyCard({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 50,
          ),
        ],
      ),
    );
  }
}
