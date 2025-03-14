import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EditForm extends StatelessWidget {
  const EditForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("정보 수정"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _EditForm(),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm({super.key});

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  late int _phoneAppId;

  static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('id')) {
      _phoneAppId = args['id'];
      getPhoneApp(_phoneAppId);
    }
  }

  void getPhoneApp(int phoneAppId) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      final response = await dio.get("$apiEndpoint/$phoneAppId");

      if (response.statusCode == 200) {
        setState(() {
          _nameController.text = response.data["name"];
          _phoneNumberController.text = response.data["phoneNumber"];
          _emailController.text = response.data["email"];
          _nicknameController.text = response.data["nickname"];
          _memoController.text = response.data["memo"];
        });
      }
    } catch (e) {
      throw Exception("데이터를 불러오지 못했습니다.:$e");
    }
  }

  void updatePhoneApp() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      var phoneAppVo = {
        'id': _phoneAppId,
        'name': _nameController.text,
        'phoneNumber': _phoneNumberController.text,
        'email': _emailController.text,
        'nickname': _nicknameController.text,
        'memo': _memoController.text,
      };

      final response = await dio.put(
        "$apiEndpoint/$_phoneAppId",
        data: phoneAppVo,
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Go back and notify success
      } else {
        throw Exception("API 서버 오류 입니다.");
      }
    } catch (e) {
      throw Exception("정보를 수정하지 못했습니다.:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "이름", hintText: "이름을 입력하세요"),
          ),
          TextFormField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              labelText: "전화번호",
              hintText: "전화번호를 입력하세요",
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "이메일",
              hintText: "이메일을 입력하세요",
            ),
          ),
          TextFormField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: "닉네임",
              hintText: "닉네임을 입력하세요",
            ),
          ),
          TextFormField(
            controller: _memoController,
            decoration: InputDecoration(labelText: "메모", hintText: "메모를 입력하세요"),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: updatePhoneApp, child: Text("수정")),
        ],
      ),
    );
  }
}
