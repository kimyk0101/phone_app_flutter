/**
 * ${PHONEAPP}
 *  FileName : ${detailPage.dart}
 * Class: ${DetailPage}.
 * Created by ${승룡}.
 * Created On ${3.14}.
 * Description: 연락처 상세정보, 연락처 수정 및 연락처 삭제 기능
 *
 * 연락처 삭제 -> 리스트 화면에서 최신 목록 불러와서 반영
 * 연락처 수정 -> 연락처 수정 폼으로 이동
 */

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
      appBar: AppBar(
        title: Text("상세 정보"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },
        ),
      ),
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
                  // Edit Button (오른쪽 상단)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            '/update',
                            arguments: {'id': phoneAppId},
                          ),
                    ),
                  ),
                  // Contact Name
                  Text(
                    phoneAppVo.name,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Contact Info
                  _buildContactRow("전화번호", phoneAppVo.phone_number),
                  _buildContactRow("이메일", phoneAppVo.email),
                  _buildContactRow("닉네임", phoneAppVo.nickname ?? '없음'),
                  _buildContactRow("메모", phoneAppVo.memo ?? '없음'),
                  // Delete Button
                  SizedBox(height: 20),
                  DeletePhoneAppButton(phoneAppId: phoneAppId),
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

// 연락처 정보를 표시하는 Row 위젯
Widget _buildContactRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(value, style: TextStyle(fontSize: 18)),
      ],
    ),
  );
}

class DeletePhoneAppButton extends StatelessWidget {
  final int phoneAppId;
  const DeletePhoneAppButton({super.key, required this.phoneAppId});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue, // 글자 색 파란색
        backgroundColor: Colors.white, // 배경 색 흰색
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        side: BorderSide(color: Colors.blue), // 파란색 테두리 추가
      ),
      onPressed: () async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("삭제 확인"),
              content: Text("정말 삭제하시겠습니까?"),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    side: BorderSide(color: Colors.transparent), // 테두리 제거
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("취소"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () async {
                    await deletePhoneAppItem(context, phoneAppId);
                    Navigator.pop(context, true);
                  },
                  child: Text("삭제"),
                ),
              ],
            );
          },
        );

        if (confirmDelete == true) {
          Navigator.pop(context, true);
        }
      },
      child: Text("연락처 삭제"),
    );
  }

  Future<void> deletePhoneAppItem(BuildContext context, int phoneAppId) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";
      final response = await dio.delete(
        "http://10.0.2.2:8090/api/phoneApp/delete/$phoneAppId",
      );

      if (response.statusCode == 204) {
        Navigator.pop(context); // 삭제 후 이전 화면으로 이동
      } else {
        throw Exception("삭제 실패: ${response.statusCode}");
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("삭제 실패"),
            content: Text("삭제에 실패했습니다. 다시 시도해 주세요."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    }
  }
}
