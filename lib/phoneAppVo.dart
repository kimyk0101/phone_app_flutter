class PhoneAppVo {
  int id;
  String name;
  String phoneNumber;
  String email;
  String? nickname;
  String? memo;

  PhoneAppVo({
    required this.id,
    required this.name,
    required this.phoneNumber,
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
      phoneNumber: apiData['phone_number'] as String,
      email: apiData['email'] as String,
      nickname: apiData['nickname'] as String? ?? '',
      memo: apiData['memo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'nickname': nickname,
      'memo': memo,
    };
  }
}
