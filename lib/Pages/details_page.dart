import 'dart:convert';
import 'package:group5finalproject/Pages/add_edit_page.dart';
import 'package:group5finalproject/Pages/profileedit_page.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class DetailsPage extends StatefulWidget {
  final details;
  const DetailsPage({Key? key, this.details}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoading = true;
  List items = [];


  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("DIARY DETAILS"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context)=> const ProfileEditPage()),
                  );
                  },
              )
            ]
        ),
        body: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item ['_id'] as String;
                  return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blueAccent.shade100),
                      child: ListTile(
                        leading: CircleAvatar(
                            child: Text('${index + 1}')),
                        title: Text(item['title'],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        subtitle: Text(item['description'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              navigateToEditPage(item);

                            }
                            else if (value == 'delete') {
                              deleteById(id);
                            }
                            },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                  value: 'edit',
                                  child: Icon(Icons.edit_rounded, color: Colors.green)
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Icon(Icons.delete_rounded, color: Colors.red),
                              ),
                            ];
                            },
                        ),
                      )
                  );
                }
                )
        ),
    );
  }


  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddEditPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future <void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState((){
        items = filtered;
        showSuccessMessage('delete successfully');

      });

    }else {
      showErrorMessage('Unable to delete');
    }

  }
  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//  63236c2f2503b8760620386e
}



