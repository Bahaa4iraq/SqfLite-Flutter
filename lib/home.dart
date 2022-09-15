import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite_test/addData.dart';
import 'package:sqflite_test/editData.dart';
import 'package:sqflite_test/sqlDB.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> res = [];
  SqlDB sqlDB = SqlDB();

  Future getData() async {
    List<Map> response = await sqlDB.readData("SELECT * FROM 'items'");
    res.addAll(response);
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                sqlDB.deleteDB();
              },
              icon: Icon(Icons.delete))
        ],
        centerTitle: true,
        title: const Text("SqfLite"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: res.length,
          itemBuilder: (context, i) => Card(
            child: ListTile(
              leading: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return Center(
                          child: Image.memory(
                            base64Decode(res[i]['image'].toString()),
                            fit: BoxFit.cover,
                          ),
                        );
                      });
                },
                child: Image.memory(
                  base64Decode(res[i]['image'].toString()),
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "${res[i]['name']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${res[i]['price']}"),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditData(
                                    txtName: res[i]['name'],
                                    txtPrice: "${res[i]['price']}",
                                    id: "${res[i]['id']}")));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        int response =
                            await sqlDB.delete("items", "id=${res[i]['id']}");
                        if (response > 0) {
                          res.removeWhere(
                              (element) => element['id'] == res[i]['id']);
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddData()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
