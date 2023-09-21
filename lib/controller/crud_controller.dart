import 'package:crudsqlite/db/de_helper.dart';
import 'package:get/get.dart';

class CRUDController extends GetxController {
  // ignore: unused_field
  List<Map<String, dynamic>> _allDatas = [];
  // ignore: unused_field
  bool _isLoading = true;

  @override
  void onReady() {
    _refreshData();
    super.onReady();
  }

  // ignore: unused_element
  void _refreshData() async {
    final data = await SQLHelper.getAlldata();
    _allDatas = data;
    _isLoading = false;
    update(); // Notify listeners that data has changed
  }

  Future<void> _addData(String _titleController, String _descController) async {
    await SQLHelper.createData(_titleController, _descController);
    _refreshData();
  }

  Future<void> _updateData(
      int id, String _titleController, String _descController) async {
    await SQLHelper.updateData(id, _titleController, _descController);
    _refreshData();
  }

  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    _refreshData();
  }
}
