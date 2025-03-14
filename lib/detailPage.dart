// // detailPage.dart
//
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:phone_app_flutter/phoneAppVo.dart';
//
// class DetailPage extends StatelessWidget {
//   const DetailPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final args =
//         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//     final phoneAppId = args['id'];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("상세 정보"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.blue),
//           onPressed: () {
//             Navigator.popUntil(context, ModalRoute.withName("/"));
//           },
//         ),
//       ),
//       body: FutureBuilder(
//         future: getPhoneApp(phoneAppId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("데이터 불러오기 실패: ${snapshot.error}"));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text("데이터가 없습니다."));
//           } else {
//             final phoneAppVo = snapshot.data as PhoneAppVo;
//             // return Padding(
//             //   padding: const EdgeInsets.all(16.0),
//             //   child: Column(
//             //     children: [
//             //       Text("이름: ${phoneAppVo.name}"),
//             //       Text("전화번호: ${phoneAppVo.phone_number}"),
//             //       Text("이메일: ${phoneAppVo.email}"),
//             //       Text("닉네임: ${phoneAppVo.nickname ?? ''}"),
//             //       Text("메모: ${phoneAppVo.memo ?? ''}"),
//             //     ],
//             //   ),
//             // );
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Edit Button (오른쪽 상단)
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed:
//                           () => Navigator.pushNamed(
//                             context,
//                             '/edit',
//                             arguments: {'id': phoneAppId}, // String 그대로 전달
//                           ),
//                     ),
//                   ),
//                   // Contact Name
//                   Text(
//                     phoneAppVo.name,
//                     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   // Contact Info
//                   _buildContactRow("전화번호", phoneAppVo.phoneNumber),
//                   _buildContactRow("이메일", phoneAppVo.email),
//                   _buildContactRow("닉네임", phoneAppVo.nickname ?? '없음'),
//                   _buildContactRow("메모", phoneAppVo.memo ?? '없음'),
//                   // Delete Button
//                   SizedBox(height: 20),
//                   ContactDeleteButton(phoneAppId: phoneAppId),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<PhoneAppVo> getPhoneApp(int phoneAppId) async {
//     try {
//       var dio = Dio();
//       dio.options.headers['Content-Type'] = "application/json";
//       final response = await dio.get(
//         "http://10.0.2.2:8090/api/phoneApp/$phoneAppId",
//       );
//
//       if (response.statusCode == 200) {
//         return PhoneAppVo.fromJson(response.data);
//       } else {
//         throw Exception("API 서버 오류");
//       }
//     } catch (e) {
//       throw Exception("데이터를 불러오는데 실패했습니다.: $e");
//     }
//   }
// }
//

//
//   Widget _buildListItem(PhoneAppVo phoneAppVo) {
//     return Card(
//       child: ListTile(
//         title: Text(phoneAppVo.name, overflow: TextOverflow.ellipsis),
//         subtitle: Text(phoneAppVo.phone_number),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () async {
//                 await Navigator.pushNamed(
//                   context,
//                   "/update",
//                   arguments: {"id": phoneAppVo.id},
//                 );
//                 fetchPhoneAppList(); // 목록 새로고침
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () async {
//                 try {
//                   await deletePhoneAppItem(phoneAppVo.id);
//                   fetchPhoneAppList(); // 목록 새로고침
//                 } catch (e) {
//                   // 삭제 실패 시 뒤로가기 버튼 표시
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text("삭제 실패"),
//                         content: Text("삭제에 실패했습니다. 다시 시도해 주세요."),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text("확인"),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               Navigator.of(context).pop(); // 목록으로 돌아가기
//                             },
//                             child: Text("목록으로 돌아가기"),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.info),
//               onPressed: () async {
//                 await Navigator.pushNamed(
//                   context,
//                   "/detail",
//                   arguments: {"id": phoneAppVo.id},
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> deletePhoneAppItem(int id) async {
//     try {
//       var dio = Dio();
//       dio.options.headers['Content-Type'] = "application/json";
//       final response = await dio.delete("$apiEndpoint/delete/$id");
//
//       if (response.statusCode != 204) {
//         throw Exception("API 서버 오류");
//       }
//
//       if (mounted) {
//         setState(() {
//           fetchPhoneAppList(); // 목록 새로고침
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           errorMessage = "삭제에 실패했습니다.: $e";
//         });
//       }
//     }
//   }
// }

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
                            '/edit',
                            arguments: {'id': phoneAppId}, // String 그대로 전달
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
                  ContactDeleteButton(phoneAppId: phoneAppId),
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

class ContactDeleteButton extends StatefulWidget {
  final int phoneAppId;
  const ContactDeleteButton({super.key, required this.phoneAppId});

  @override
  _ContactDeleteButtonState createState() => _ContactDeleteButtonState();
}

class _ContactDeleteButtonState extends State<ContactDeleteButton> {
  bool _isHovered = false; // Hover 상태를 추적

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true; // 마우스가 들어오면 hover 상태를 true로 변경
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false; // 마우스가 나가면 hover 상태를 false로 변경
        });
      },
      child: TextButton(
        onPressed: () => deletePhoneAppItem(context, widget.phoneAppId),
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue, // 텍스트 색 파란색
          backgroundColor:
              _isHovered ? Colors.grey[300] : Colors.white, // hover 시 배경색 변경
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          side: BorderSide(color: Colors.transparent), // 테두리 없애기
        ),
        child: Text("연락처 삭제", style: TextStyle(fontSize: 18)),
      ),
    );
  }


Future<void> deletePhoneAppItem(
  BuildContext context,
  int phoneAppId,
  Function refreshList,
) async {
  try {
    var dio = Dio();
    dio.options.headers['Content-Type'] = "application/json";
    final response = await dio.delete(
      "http://10.0.2.2:8090/api/phoneApp/delete/$phoneAppId",
    );

    print("Response Status: ${response.statusCode}");
    if (response.statusCode == 204) {
      refreshList(); // 리스트 갱신 함수 호출
      Navigator.pop(context); // 삭제 후 목록으로 돌아가기
    } else {
      throw Exception("삭제 실패: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e"); // 에러 로그 출력
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




