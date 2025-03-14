// detailPage.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:phone_app_flutter/phoneAppVo.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final phoneAppId = args['id'];

    return Scaffold(
      appBar: AppBar(title: Text("상세 정보")),
      body: FutureBuilder(
        future: getPhoneApp(phoneAppId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("데이터 불러오기 실패: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("데이터가 없습니다."));
          } else {
            final phoneAppVo = snapshot.data as PhoneAppVo;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("이름: ${phoneAppVo.name}"),
                  Text("전화번호: ${phoneAppVo.phoneNumber}"),
                  Text("이메일: ${phoneAppVo.email}"),
                  Text("닉네임: ${phoneAppVo.nickname ?? ''}"),
                  Text("메모: ${phoneAppVo.memo ?? ''}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<PhoneAppVo> getPhoneApp(int phoneAppId) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";
      final response = await dio.get(
        "http://10.0.2.2:8090/api/phoneApp/$phoneAppId",
      );

      if (response.statusCode == 200) {
        return PhoneAppVo.fromJson(response.data);
      } else {
        throw Exception("API 서버 오류");
      }
    } catch (e) {
      throw Exception("데이터를 불러오는데 실패했습니다.: $e");
    }
  }
}
