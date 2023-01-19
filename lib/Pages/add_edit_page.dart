import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddEditPage extends StatefulWidget {
  final Map? todo;
  AddEditPage({ super.key, this.todo
  });

  @override
  State<AddEditPage> createState() => _AddEditPageState();

}

class _AddEditPageState extends State<AddEditPage> {

  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState(){
    final todo = widget.todo;

    super.initState();
    if(todo !=null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            isEdit? 'Edit MY DAY':'ADD MY DAY'),
      ),
      body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                  hintText: '01-21-2022',
                  labelText: 'Date Today'
              ),

            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Start your day',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 50,
              maxLines: 100,

            ),

            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: isEdit? updateData : submitData,
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Text(
                      isEdit? 'update':'save'),
                )
            )

          ]
      ),

    );
  }
  Future <void> updateData() async{
    final todo = widget.todo;
    if(todo == null){
      return;
    }
    final id = todo ['_id'];
    //final isCompleted = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url ='https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.put(
        uri,
        body:
        jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'}
    );

    if (response.statusCode == 200){
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage('Update successfully');

    }else{
      showErrorMessage('Update unsuccessful');

    }

  }

//-------------------------------------------------
  Future <void> submitData() async{
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url ='https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await http.post(
        uri,
        body:
        jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'}
    );

    if (response.statusCode == 201){
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage('Creation success');

    }else{
      showErrorMessage('Creation unsuccessful');

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
