// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:sqlite_crud/database/db_helper.dart';
import 'package:sqlite_crud/widgets/colors.dart';

class HomePg extends StatefulWidget {
  const HomePg({super.key});

  @override
  State<HomePg> createState() => _HomePgState();
}

class _HomePgState extends State<HomePg> {
  List<Map<String, dynamic>> _allData = [];

  bool _isloading = true;

// Get All Data From Database
  void _refreshData() async {
    final customers = await SQLHelper.getAllData();
    setState(() {
      _allData = customers;
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

//Add Data
  Future<void> _addData() async {
    await SQLHelper.createData(
      _nameEditingController!.text,
      _addressEditingController!.text,
      _cityEditingController!.text,
    );
    _refreshData();
  }

// Update Data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
      id,
      _nameEditingController!.text,
      _addressEditingController!.text,
      _cityEditingController!.text,
    );
    _refreshData();
  }

// Delete Data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Data Deleted."),
        backgroundColor: Colors.redAccent,
      ),
    );
    _refreshData();
  }

  TextEditingController? _nameEditingController = TextEditingController();
  TextEditingController? _addressEditingController = TextEditingController();
  TextEditingController? _cityEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 221, 221, 221),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          "Customers",
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              showDialogCustomers(null);
            },
          ),
        ],
      ),
      body: _isloading
          ? Container(
              color: Color.fromARGB(255, 229, 229, 229),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add Some Customers!!!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  isThreeLine: true,
                  dense: true,
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]["name"],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_allData[index]["address"]),
                      Text(_allData[index]["city"]),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialogCustomers(_allData[index]["id"]);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteData(_allData[index]["id"]);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

// ***********************************

  void showDialogCustomers(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element["id"] == id);
      _nameEditingController!.text = existingData["name"];
      _addressEditingController!.text = existingData["address"];
      _cityEditingController!.text = existingData["city"];
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text("Customers"),
        elevation: 2,
        content: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: TextField(
                controller: _nameEditingController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                    letterSpacing: 0,
                  ),
                  hintStyle: TextStyle(
                    letterSpacing: 0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: alternateColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  letterSpacing: 0,
                ),
                // validator: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: TextField(
                controller: _addressEditingController,
                autofocus: true,
                obscureText: false,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Address",
                  labelStyle: TextStyle(
                    letterSpacing: 0,
                  ),
                  hintStyle: TextStyle(
                    letterSpacing: 0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: alternateColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  letterSpacing: 0,
                ),
                // validator: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 18),
              child: TextField(
                controller: _cityEditingController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "City",
                  labelStyle: TextStyle(
                    letterSpacing: 0,
                  ),
                  hintStyle: TextStyle(
                    letterSpacing: 0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: alternateColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  letterSpacing: 0,
                ),
                // validator: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.orange[900],
              ),
            ),
            onPressed: () async {
              if (id == null) {
                await null;
              }
              if (id != null) {
                _deleteData(id);
              }

              _nameEditingController!.text = "";
              _addressEditingController!.text = "";
              _cityEditingController!.text = "";

              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                id == null ? "Cancel" : "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (id == null) {
                await _addData();
              }
              if (id != null) {
                await _updateData(id);
              }
              _nameEditingController!.text = "";
              _addressEditingController!.text = "";
              _cityEditingController!.text = "";

              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.indigo,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                id == null ? "Save" : "Update",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
