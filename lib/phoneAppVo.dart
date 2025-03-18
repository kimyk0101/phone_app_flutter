/**
 * ${PHONEAPP}
 *  FileName : ${phoneAppVo.dart}
 *  Class: ${PhoneAppVo}.
 *  Created by ${승룡}.
 *  Created On ${3.14}.
 *  Description: 전화번호 관리 애플리케이션에서 사용되는 VO 클래스
 *
 *  필수 필드 (id, name, phone_number, email)와 선택적 필드 (nickname, memo)
 */

class PhoneAppVo {
  int id;
  String name;
  String phone_number;
  String email;
  String? nickname;
  String? memo;

  PhoneAppVo({
    required this.id,
    required this.name,
    required this.phone_number,
    required this.email,
    this.nickname,
    this.memo,
  });

  factory PhoneAppVo.fromJson(Map<String, dynamic> apiData) {
    if (apiData['id'] == null ||
        apiData['name'] == null ||
        apiData['phone_number'] == null ||
        apiData['email'] == null) {
      print("apiData : : : : :$apiData");
      throw Exception('필수 필드가 누락되었습니다.');
    }

    return PhoneAppVo(
      id: apiData['id'] as int,
      name: apiData['name'] as String,
      phone_number: apiData['phone_number'] as String,
      email: apiData['email'] as String,
      nickname: apiData['nickname'] as String? ?? '',
      memo: apiData['memo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phone_number,
      'email': email,
      'nickname': nickname,
      'memo': memo,
    };
  }
}
