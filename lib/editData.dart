import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqflite_test/home.dart';
import 'package:sqflite_test/sqlDB.dart';

class EditData extends StatefulWidget {
  const EditData(
      {Key? key,
      required this.txtName,
      required this.txtPrice,
      required this.id})
      : super(key: key);
  final String txtName;
  final String txtPrice;
  final String id;

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  SqlDB sqlDB = SqlDB();
  @override
  void initState() {
    super.initState();
    name.text = widget.txtName;
    price.text = widget.txtPrice;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Home()),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("Add Data"),
          centerTitle: true,
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextFormField(
              controller: name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueAccent.withOpacity(0.2),
                hintText: "Name",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueAccent.withOpacity(0.2),
                hintText: "Price",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2)),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: InkWell(
              onTap: () async {
                if (name.text.isEmpty || price.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Text(
                        "Fill all Fields First",
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      )));
                } else {
                  int response = await sqlDB.update(
                      "items",
                      {"name": name.text, "price": price.text},
                      "id=${widget.id}");
                  if (response != 0) {
                    name.clear();
                    price.clear();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.blueAccent,
                        content: Text(
                          "Edit Successfully",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.blueAccent,
                        content: Text(
                          "There is some error",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        )));
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2),
                width: double.maxFinite,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "EDIT",
                    style: TextStyle(
                      fontSize: 25,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
