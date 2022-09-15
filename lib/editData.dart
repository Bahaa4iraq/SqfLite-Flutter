import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_test/home.dart';
import 'package:sqflite_test/sqlDB.dart';

class EditData extends StatefulWidget {
  const EditData(
      {Key? key,
      required this.txtName,
      required this.txtPrice,
      required this.id,
      this.img64})
      : super(key: key);
  final String txtName;
  final String txtPrice;
  final String id;
  final String? img64;

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  Uint8List? bytes;
  File? img;
  String? img63;

  SqlDB sqlDB = SqlDB();
  @override
  void initState() {
    super.initState();
    name.text = widget.txtName;
    price.text = widget.txtPrice;
    img63 = widget.img64;
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  primary: Colors.blueAccent,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (() async {
                                    try {
                                      XFile? xfile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (xfile != null) {
                                        img = File(xfile.path);
                                        bytes =
                                            File(img!.path).readAsBytesSync();
                                        img63 = base64Encode(bytes!);
                                      }
                                    } on PlatformException catch (e) {
                                      print("faild to pickimage");
                                    }
                                  }),
                                  child: Container(
                                    height: 59,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "اختر صورة من الاستوديو",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.grey,
                                ),
                                InkWell(
                                  hoverColor: Colors.grey,
                                  onTap: () async {
                                    try {
                                      XFile? xfile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (xfile != null) {
                                        img = File(xfile.path);
                                        bytes =
                                            File(img!.path).readAsBytesSync();
                                        img63 = base64Encode(bytes!);
                                      }
                                    } on PlatformException catch (e) {
                                      print("faild to pickimage");
                                    }
                                  },
                                  child: Container(
                                    height: 59,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      "الكاميرا",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
                },
                icon: Icon(Icons.add_a_photo, color: Colors.white),
                label: Text(
                  "Add Photo",
                  style: TextStyle(color: Colors.white),
                )),
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
                      {"name": name.text, "price": price.text, "image": img63},
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
