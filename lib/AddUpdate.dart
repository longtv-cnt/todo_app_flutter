import 'package:flutter/material.dart';
import 'package:todo_app/Model.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/TodoApp.dart';
import 'package:intl/intl.dart';

class AddUpdate extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  final String? dateandtime;
  final bool? update;

  AddUpdate({
    this.id,
    this.title,
    this.description,
    this.dateandtime,
    this.update,
  });

  @override
  State<AddUpdate> createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  late DbHelper dbHelper;
  final _formKey = GlobalKey<FormState>();

  // Khai báo controllers ở đây
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();

    // Khởi tạo controllers với dữ liệu ban đầu
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị loại bỏ
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.update == true ? 'Update Todo' : 'Add Todo';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 3,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "Note Title",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            labelText: 'Title',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox.square(
                        dimension: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "Note Description",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          minLines: 5,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.update == true) {
                            dbHelper.update(
                              TodoModel(
                                  id: widget.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  dateandtime: DateTime.now().toString()
                                  //.substring(0, 16),
                                  ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoApp(),
                              ),
                            );
                          } else {
                            dbHelper.insert(
                              TodoModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                dateandtime: DateFormat("dd/MM/yyyy HH:mm:ss")
                                    .format(DateTime.now()),
                              ),
                            );
                            titleController.clear();
                            descriptionController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoApp(),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        titleController.clear();
                        descriptionController.clear();
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
