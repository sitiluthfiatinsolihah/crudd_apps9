import 'package:crud_apps9/model/User.dart';
import 'package:crud_apps9/screens/EditUser.dart';
import 'package:crud_apps9/screens/addUser.dart';
import 'package:crud_apps9/screens/ViewUsers.dart';
import 'package:crud_apps9/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD P9 SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<User> _userList = <User>[];
  final _userService = UserService();
  getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    _userList = <User>[];
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.address = user['address'];
        userModel.contact = user['contact'];
        userModel.description = user['description'];
        _userList.add(userModel);
      });
    });
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  _viewUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUser(user: user),
      ),
    );
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Are You Sure to Delete',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result = await _userService.deleteUser(userId);
                if (result != null) {
                  Navigator.pop(context);
                  getAllUserDetails(); // Update the list after deletion
                  _showSuccessSnackBar('User Detail Deleted Success');
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Pengembangan Aplikasi Mobile P9 - 20210120015"),
          backgroundColor: Color.fromARGB(255, 0, 255, 0)),
      body: ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color.fromARGB(255, 0, 255, 234),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewUser(
                                user: _userList[index],
                              )));
                },
                leading: const Icon(Icons.person),
                title: Text(_userList[index].name ?? ''),
                subtitle: Text(_userList[index].contact ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditUser(
                                        user: _userList[index],
                                      ))).then((data) {
                            if (data != null) {
                              getAllUserDetails();
                              _showSuccessSnackBar(
                                  'User Detail Updated Success');
                            }
                          });
                          ;
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.yellow,
                        )),
                    IconButton(
                        onPressed: () {
                          _viewUserDetails(_userList[index]);
                        },
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.blue,
                        )),
                    IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _userList[index].id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddUser()))
              .then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('User Detail Added Success');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
