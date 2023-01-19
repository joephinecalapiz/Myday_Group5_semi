import 'package:flutter/material.dart';
import 'package:group5finalproject/Pages/home_screen.dart';

class DetailsPage extends StatelessWidget{
  final HomeScreen details;

  const DetailsPage ({ required this.details,
    Key? key}): super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left:2),
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.code),
              title: Row(
                children: [
                  const Expanded (
                    flex: 3,
                    child: Text('ID number'),
                  ),
                  // Expanded (
                  //   flex: 7,
                  //   child: Text(': ${details.description}'),
                  // ),
                ],
              )
          ),
          const SizedBox(height: 34),
        ],
      ),
    );

  }
}


