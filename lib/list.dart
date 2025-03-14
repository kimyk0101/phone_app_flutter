import 'package:flutter/material.dart';
import 'package:phone_app_flutter/phoneAppVo.dart';
import 'package:dio/dio.dart';

class PhoneAppList extends StatelessWidget {
  const PhoneAppList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전화번호부 리스트"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(color: Colors.blue[100], child: _PhoneAppList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/insert");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _PhoneAppList extends StatefulWidget {
  const _PhoneAppList({super.key});

  @override
  State<_PhoneAppList> createState() => _PhoneAppListState();
}

class _PhoneAppListState extends State<_PhoneAppList> {
  static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";
  List<PhoneAppVo>? phoneAppList;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'name';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchPhoneAppList();
  }

  Future<void> fetchPhoneAppList() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";
      final response = await dio.get(apiEndpoint);

      if (response.statusCode == 200) {
        setState(() {
          phoneAppList =
              response.data
                  .map<PhoneAppVo>((item) => PhoneAppVo.fromJson(item))
                  .toList();
          isLoading = false;
        });
      } else {
        throw Exception("API 서버 오류");
      }
    } catch (e) {
      setState(() {
        errorMessage = "전화번호 목록을 불러오는데 실패했습니다.: $e";
        isLoading = false;
      });
    }
  }

  List<PhoneAppVo>? filterPhoneAppList() {
    if (_searchQuery.isEmpty) return phoneAppList;

    return phoneAppList?.where((item) {
      if (_searchType == 'name') {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      } else {
        return item.phoneNumber.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: '검색',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _searchQuery = text;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: _searchType,
                items: [
                  DropdownMenuItem(child: Text('이름'), value: 'name'),
                  DropdownMenuItem(child: Text('전화번호'), value: 'phoneNumber'),
                ],
                onChanged: (value) {
                  setState(() {
                    _searchType = value ?? 'name';
                  });
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('검색'),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : phoneAppList == null || phoneAppList!.isEmpty
                  ? Center(child: Text("전화번호가 없습니다."))
                  : ListView.builder(
                    itemCount: filterPhoneAppList()!.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(filterPhoneAppList()![index]);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildListItem(PhoneAppVo phoneAppVo) {
    return Card(
      child: ListTile(
        title: Text(phoneAppVo.name, overflow: TextOverflow.ellipsis),
        subtitle: Text(phoneAppVo.phoneNumber),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  "/update",
                  arguments: {"id": phoneAppVo.id},
                );
                fetchPhoneAppList(); // 목록 새로고침
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await deletePhoneAppItem(phoneAppVo.id);
                  fetchPhoneAppList(); // 목록 새로고침
                } catch (e) {
                  // 삭제 실패 시 뒤로가기 버튼 표시
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
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(); // 목록으로 돌아가기
                            },
                            child: Text("목록으로 돌아가기"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  "/detail",
                  arguments: {"id": phoneAppVo.id},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deletePhoneAppItem(int id) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";
      final response = await dio.delete("$apiEndpoint/$id");

      if (response.statusCode != 200) {
        throw Exception("API 서버 오류");
      }
    } catch (e) {
      setState(() {
        errorMessage = "삭제에 실패했습니다.: $e";
      });
    }
  }
}
