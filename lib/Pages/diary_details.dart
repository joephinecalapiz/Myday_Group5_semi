import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:group5finalproject/Pages/add_edit_page.dart';

class DetailsPage extends StatefulWidget {

  final dynamic todo;

  const DetailsPage({
    required this.todo,
    Key? key}) : super(key: key);

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
          leading: InkWell(
            onTap: () { /* Write listener code here */ },
            child: const Icon(
              Icons.menu,  // add custom icons also
            ),
          ),
        title: const Text("MY DIARY'S PAGE"),
          actionsIconTheme: const IconThemeData(
              size: 30.0,
              opacity: 10.0
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    navigateToEditPage;

                    // Navigator.push(
                    //   context, MaterialPageRoute(
                    //     builder: (context)=> const AddEditPage()),
                    // );
                  },
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.green,
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: InkWell(
                  onTap: () {
                    deleteById;

                  },
                  child: const Icon(
                      Icons.delete_rounded,
                    color: Colors.red,
                  ),
                )
            )


          ]
      ),
      body:
      ListView(
        padding: const EdgeInsets.only(top: 5),
        children: [
          rowItem("Title", widget.todo['title']),
          rowItem("Description", widget.todo["description"])
        ],
      ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){},
          label: const Text('Edit Diary'),
        ),



    );
  }
  Widget rowItem(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        const SizedBox(height: 50),
        Text(value.toString(), style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),)
      ],

    );
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

  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddEditPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
      showSuccessMessage('Updated successfully');
    });
    fetchTodo();
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

}
