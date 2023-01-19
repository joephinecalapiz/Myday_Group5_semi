import 'package:flutter/material.dart';
import 'package:group5finalproject/model/myday.dart';

class DetailsPage extends StatelessWidget{
  final MydayInfo details;

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
              title: Column(
                children: [
                  const Expanded (
                    flex: 3,
                    child: Text('ID number'),
                  ),
                  Expanded (
                    flex: 7,
                    child: Text(': ${details.description}'),
                  ),
                ],
              )
          ),
          const SizedBox(height: 34),
        ],
      ),
    );

  }
}


