import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/AddUpdate.dart';
import 'package:todo_app/Model.dart';
import 'package:todo_app/db_handler.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }

  late Future<List<TodoModel>> todoList;

  void loadData() {
    todoList = dbHelper.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 3,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.help_outline_outlined),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: FutureBuilder<List<TodoModel>>(
        future: todoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                int todoId = snapshot.data![index].id!.toInt();
                String todoTitle = snapshot.data![index].title!;
                String todoDescription = snapshot.data![index].description!;
                // var formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
                // String todoDateAndTime = formatter
                //     .format(DateTime.parse(snapshot.data![index].dateandtime!));
                return Dismissible(
                  key: ValueKey<int>(todoId),
                  onDismissed: (direction) {
                    // Xóa mục từ cơ sở dữ liệu khi người dùng vuốt để xóa
                    dbHelper.delete(todoId);
                    // Load lại dữ liệu
                    setState(() {
                      loadData();
                    });
                    // Hiển thị snackbar thông báo đã xóa
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã xóa mục $todoTitle'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Hoàn tác',
                          onPressed: () {
                            // Nếu người dùng bấm vào nút hoàn tác, phục hồi mục đã xóa
                            // (Đây là ví dụ, bạn có thể thêm logic phù hợp cho việc phục hồi)
                            // Ví dụ: dbHelper.undoDelete(todoId);
                            // Sau đó, load lại dữ liệu:
                            // setState(() {
                            //   loadData();
                            // });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                  ),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async {
                    // Hiển thị hộp thoại xác nhận trước khi xóa
                    return showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Xác nhận xóa'),
                          content:
                              Text('Bạn có chắc chắn muốn xóa mục này không?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Có'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Không'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.shade300,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            todoTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            todoDescription,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            // Xử lý sự kiện khi nhấn vào mục trong danh sách
                          },
                        ),
                        const Divider(
                          thickness: 0.8,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Ngày: ' +
                                    DateFormat('dd/MM/yyyy HH:mm:ss')
                                        .format(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddUpdate(
                                      title: todoTitle,
                                      update: true,
                                      description: todoDescription,
                                      // dateandtime: todoDateAndTime,

                                      id: todoId,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    loadData();
                                  });
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddUpdate(
                      update: false,
                    )),
          ).then((_) {
            setState(() {
              loadData();
            });
          });
        },
      ),
    );
  }
}
