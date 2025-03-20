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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';

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
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
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
                  //  큰 아이콘 표시
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: RiveAnimation.asset(
                      'assets/animations/bear_avatar_remix.riv',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Contact Name
                  Text(
                    phoneAppVo.name,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ).animate().shimmer(delay: 4000.ms, duration: 1800.ms),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          '/update',
                          arguments: {'id': phoneAppId},
                        ),
                  ).animate().shake(hz: 4, curve: Curves.easeInOutCubic),
                  // Contact Info
                  _buildContactRow(
                    "📞 전화번호",
                    phoneAppVo.phone_number,
                  ).animate().slideX(duration: 700.ms),
                  _buildContactRow(
                    "📧 이메일",
                    phoneAppVo.email,
                  ).animate().slideX(duration: 700.ms),
                  _buildContactRow(
                    "👤 닉네임",
                    phoneAppVo.nickname ?? '없음',
                  ).animate().slideX(duration: 700.ms),
                  _buildContactRow(
                    "📝 메모",
                    phoneAppVo.memo ?? '없음',
                  ).animate().slideX(duration: 700.ms),
                  // Delete Button
                  SizedBox(height: 10),
                  DeletePhoneAppButton(
                    phoneAppId: phoneAppId,
                  ).animate().rotate(),
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
        // "http://10.0.2.2:8090/api/phoneApp/$phoneAppId",
        "http://3.36.112.4:28088/api/phoneApp/$phoneAppId",
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
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(value, style: TextStyle(fontSize: 24)),
        ],
      ),
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
        // "http://10.0.2.2:8090/api/phoneApp/delete/$phoneAppId",
        "http://3.36.112.4:28088/api/phoneApp/delete/$phoneAppId",
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
