import 'dart:convert';

import 'package:flutter/material.dart';
import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../models/todo_item.dart';
import '../helpers/my_list_tile.dart';
import '../helpers/my_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoItems(); // Load TodoItems when the page is initialized
  }

  Future<void> _loadTodoItems() async {
    try {
      final data =
          await ApiCaller().get('web_types'); // Make a GET request to the API
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
      });
    } catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Web by Fondue',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Container(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              Text("* ต้องกรองข้อมูล"),
              SizedBox(height: 10.0),
              MyTextField(
                controller: _urlController,
                hintText: 'URL *',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0),
              MyTextField(
                controller: _descriptionController,
                hintText: 'รายละเอียด',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0),
              Text("ระบุประเภทเว็บเลว *"),
              Expanded(
                child: ListView.builder(
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    final item = _todoItems[index];
                    return Column(
                      children: [
                        SizedBox(height: 10.0),
                        MyListTile(
                            title: item.title,
                            subtitle: item.subtitle,
                            imageUrl:
                                'https://cpsu-api-49b593d4e146.herokuapp.com${item.image}',
                            onTap: () {}),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _handleApiPost,
                child: const Text('ส่งข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    if (_urlController.text == '' || _descriptionController.text == '') {
      showOkDialog(
          context: context,
          title: "Error",
          message: "กรุณากรอกข้อมูลให้ครบถ้วน");
    } else {
      try {
        final data = await ApiCaller().post(
          'report_web',
          params: {
            "url": _urlController.text,
            "description": _descriptionController.text,
            "type": 'qwe',
          },
        );
        // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
        Map map = jsonDecode(data);
        String text =
            'ขอบคุณสำหรับแจ้งข้อมูล \n\nสถิตการรายงาน \n=========\n';
        showOkDialog(context: context, title: "Success", message: text);
      } on Exception catch (e) {
        showOkDialog(context: context, title: "Error", message: e.toString());
      }
    }
  }
}
