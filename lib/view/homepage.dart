import 'dart:ffi';

import 'package:crudsqlite/db/de_helper.dart';
import 'package:crudsqlite/model/crud.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  // ignore: unused_element
  void _refreshData() async {
    final data = await SQLHelper.getAlldata();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _addData() async {
    await SQLHelper.createData(
        Note(title: _titleController.text, desc: _descController.text));
    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        Note(id: id, title: _titleController.text, desc: _descController.text));
    _refreshData();
  }

  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red, content: Text('Data Delete')));
    _refreshData();
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }

    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 30,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Description"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addData();
                        } else {
                          await _updateData(id);
                        }
                        _titleController.text = "";
                        _descController.text = "";
                        Navigator.of(context).pop();
                        print("Data Added");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          id == null ? "Add Data" : "Update Data",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => showBottomSheet(null)),
        child: const Icon(Icons.add),
      ),
    );
  }

  _body() {
    return ListView.builder(
      itemCount: _allData.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.all(15),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              _allData[index]['title'],
              style: const TextStyle(fontSize: 20),
            ),
          ),
          subtitle: Text(_allData[index]['desc']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showBottomSheet(_allData[index]['id']);
                },
                icon: Icon(Icons.edit),
                color: Colors.indigo,
              ),
              IconButton(
                onPressed: () {
                  _deleteData(_allData[index]['id']);
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}
