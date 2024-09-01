// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sqlite_crud/database/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        _nameController.text, _addressController.text, _cityController.text);
    _refreshData();
  }

// Update Data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _nameController.text,
        _addressController.text, _cityController.text);
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  void showBottomSheet(int? id) async {
    // if if id not null then it will update other wise will add new data
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element["id"] == id);
      _nameController.text = existingData["name"];
      _addressController.text = existingData["address"];
      _cityController.text = existingData["city"];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          right: 18,
          left: 18,
          // bottom: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                hintText: "Name",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              maxLines: 4,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                hintText: "Address",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                hintText: "City",
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.indigo),
                ),
                onPressed: () async {
                  if (id == null) {
                    await _addData();
                  }
                  if (id != null) {
                    await _updateData(id);
                  }
                  _nameController.text = "";
                  _addressController.text = "";
                  _cityController.text = "";

                  // Hide BottomSheet
                  Navigator.of(context).pop();
                  // print("Data Added");
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add Data" : " Update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              showBottomSheet(null);
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
                          showBottomSheet(_allData[index]["id"]);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showBottomSheet(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
