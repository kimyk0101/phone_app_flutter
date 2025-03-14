import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:phone_app_flutter/phoneAppVo.dart';

class WriteForm extends StatelessWidget {
  const WriteForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전화번호 추가"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _WriteForm(),
    );
  }
}

class _WriteForm extends StatefulWidget {
  const _WriteForm({super.key});

  @override
  State<_WriteForm> createState() => _WriteFormState();
}

class _WriteFormState extends State<_WriteForm> {
  // 상수
  static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";

  // TextEditingController를 사용하여 텍스트 필드의 입력 값을 관리
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "이름",
                  hintText: "이름을 입력하세요",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: "전화번호",
                  hintText: "전화번호를 입력하세요",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "이메일",
                  hintText: "이메일을 입력하세요",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: "닉네임",
                  hintText: "닉네임을 입력하세요",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: _memoController,
                decoration: InputDecoration(
                  labelText: "메모",
                  hintText: "메모를 입력하세요",
                ),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  createInfo();
                },
                child: Text('정보 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createInfo() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      PhoneAppVo phoneAppVo = PhoneAppVo(
        id: 0,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        nickname: _nicknameController.text,
        memo: _memoController.text,
      );

      final response = await dio.post(
        apiEndpoint + "/insert",
        data: phoneAppVo.toJson(),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/");
      } else {
        throw Exception("정보 추가 실패하였습니다.: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("정보를 추가하지 못했습니다.:$e");
    }
  }
}
