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
  static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(_nameController, "이름", "이름을 입력하세요"),
              _buildTextField(_phoneNumberController, "전화번호", "전화번호를 입력하세요"),
              _buildTextField(_emailController, "이메일", "이메일을 입력하세요"),
              _buildTextField(_nicknameController, "닉네임", "닉네임을 입력하세요"),
              _buildMemoField(_memoController, "메모", "메모를 입력하세요"),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    createInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white, // 버튼 배경색
                    foregroundColor: Colors.blue, // 버튼 텍스트 및 아이콘 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('정보 추가'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 기본 TextFormField 스타일을 위한 메소드
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  // 메모 입력 필드 스타일을 위한 메소드
  Widget _buildMemoField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
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
        phone_number: _phoneNumberController.text,
        email: _emailController.text,
        // nickname: _nicknameController.text,
        // memo: _memoController.text,
        nickname:
            _nicknameController.text.isEmpty ? null : _nicknameController.text,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
      );

      final response = await dio.post(
        apiEndpoint + "/insert",
        data: phoneAppVo.toJson(),
      );
      // [연경] - 위의 주소 오류로 아래 사용(연경만)
      // final response = await dio.post(apiEndpoint, data: phoneAppVo.toJson());

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
