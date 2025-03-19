/**
 * ${PHONEAPP}
 *  FileName : ${editForm.dart}
 * Class: ${EditForm}.
 * Created by ${승룡}.
 * Created On ${3.14}.
 * Description: 연락처 수정 폼
 *
 * 필수 필드 (id, name, phone_number, email) - Null || 공백 불가 -> 경고 메세지
 * 선택적 필드 (nickname, memo) - Null 가능
 * nickname과 memo - Null 일 경우 공백으로 처리
 */

import 'package:flutter/material.dart';
import 'package:phone_app_flutter/phoneAppVo.dart';
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
  late int? _phoneAppId;

  // static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";
  static const String apiEndpoint = "http://43.202.55.123:28088/api/phoneApp";

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
      getPhoneApp(_phoneAppId); // nullable 타입으로 전달
    }
  }

  void getPhoneApp(int? _phoneAppId) async {
    if (_phoneAppId == null) return;

    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      final response = await dio.get("$apiEndpoint/$_phoneAppId");

      if (response.statusCode == 200) {
        setState(() {
          // 서버에서 받은 값
          String name = response.data["name"] ?? '';
          String phone_number = response.data["phone_number"] ?? '';
          String email = response.data["email"] ?? '';
          String nickname = response.data["nickname"] ?? ''; // 공백 처리
          String memo = response.data["memo"] ?? ''; // 공백 처리

          // 필수 필드 체크: null 또는 공백이면 수정 불가
          if (name.isEmpty || phone_number.isEmpty || email.isEmpty) {
            // 필수 값이 비어있는 경우 경고 메시지
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("이름, 전화번호, 이메일은 필수 입력 사항입니다.")),
            );
            return; // 수정 불가
          }

          // 필수 값이 채워진 경우에만 수정 가능
          _nameController.text = name;
          _phoneNumberController.text = phone_number;
          _emailController.text = email;
          _nicknameController.text = nickname;
          _memoController.text = memo;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('데이터를 불러오지 못했습니다.')));
    }
  }

  void onSaveButtonPressed() {
    // 필수 값이 null이나 공백인 경우 수정 불가
    if (_nameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _emailController.text.isEmpty) {
      // 필수 입력 값이 비어 있을 때 경고 메시지
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("필수 입력 사항"),
            content: Text("이름, 전화번호, 이메일은 필수 입력 사항입니다."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 경고창 닫기
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
      return; // 수정되지 않도록 return으로 종료
    }
    // 필수 값이 모두 채워졌다면 수정 저장
    updatePhoneApp(); // 데이터를 서버에 전송하는 함수 호출
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
          SizedBox(height: 10), // 간격을 3px로 설정
          TextFormField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              labelText: "전화번호",
              hintText: "전화번호를 입력하세요",
            ),
          ),
          SizedBox(height: 10), // 간격을 3px로 설정
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "이메일",
              hintText: "이메일을 입력하세요",
            ),
            keyboardType: TextInputType.emailAddress, // 이메일 입력 모드
          ),
          SizedBox(height: 10), // 간격을 3px로 설정
          TextFormField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: "닉네임",
              hintText: "닉네임을 입력하세요",
            ),
          ),
          SizedBox(height: 10), // 간격을 3px로 설정
          TextFormField(
            controller: _memoController,
            decoration: InputDecoration(labelText: "메모", hintText: "메모를 입력하세요"),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed:
                onSaveButtonPressed, // onPressed에서 직접 updatePhoneApp()을 호출하지 않음
            child: Text("수정", style: TextStyle(color: Colors.blue)), // 글자색 파랑
            style: TextButton.styleFrom(
              backgroundColor: Colors.white, // 배경색 하얀색
              side: BorderSide(color: Colors.blue), // 테두리 파란색
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 30,
              ), // 버튼 크기 조정
            ),
          ),
        ],
      ),
    );
  }

  void updatePhoneApp() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      PhoneAppVo phoneAppVo = PhoneAppVo(
        id: _phoneAppId!,
        name: _nameController.text,
        phone_number: _phoneNumberController.text,
        email: _emailController.text,
        nickname: _nicknameController.text,
        memo: _memoController.text,
      );

      final response = await dio.patch(
        "$apiEndpoint/modify/$_phoneAppId",
        data: phoneAppVo.toJson(),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/");
      } else {
        throw Exception("API 서버 오류 입니다.");
      }
    } catch (e) {
      throw Exception("정보를 수정하지 못했습니다.:$e");
    }
  }
}
