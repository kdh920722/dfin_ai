import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController{

  static Future<void> initAccessToken(Function(bool) callback) async {
    final endPoint = Uri.parse('https://oauth.codef.io/oauth/token');
    const body = 'grant_type=client_credentials&scope=read';

    final auth = hostStatus == HostStatus.prod.value
        ? '${Host.clientId.value}:${Host.clientSecret.value}'
        : '${HostDev.clientId.value}:${HostDev.clientSecret.value}';

    final authBytes = utf8.encode(auth);
    final authStringEnc = base64.encode(authBytes);
    final authHeader = 'Basic $authStringEnc';

    try {
      final request = http.Request('POST', endPoint);
      request.headers.addAll({
        'Authorization': authHeader,
        'Content-Type': 'application/x-www-form-urlencoded',
      });
      request.body = body;

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponseBody = Uri.decodeFull(responseBody);
        final json = jsonDecode(decodedResponseBody);

        if (json.containsKey('access_token')) {
          token = json['access_token'];
          callback(true);
        } else {
          callback(false);
        }
      } else {
        callback(false);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false);
    }
  }

  static Future<void> getDataFromApi(Apis apiInfo, Map<String, dynamic> inputJson,
      void Function(bool isSuccess, Map<String, dynamic>? outputJson, List<dynamic>? outputJsonArray) callback) async {
    final baseUrl = hostStatus == HostStatus.prod.value ? Host.baseUrl.value : HostDev.baseUrl.value;
    final endPoint = apiInfo.value;
    final url = baseUrl + endPoint;
    final tokenHeader = 'Bearer $token';

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Authorization': tokenHeader,
            'Content-Type': 'application/json'
          },
          body: jsonEncode(inputJson)
      );

      if(response.statusCode == 200) {
        final decodedResponseBody = Uri.decodeFull(response.body);
        final json = jsonDecode(decodedResponseBody);
        if(json.containsKey('result') && json.containsKey('data')){
          final result = json['result'];
          final resultCode = result['code'];
          if(resultCode == 'CF-00000'){
            final resultData = json['data'];
            if (resultData is Map<String, dynamic>) {
              callback(true, resultData, null);
            } else if (resultData is List<dynamic>) {
              callback(true, null, resultData);
            }
          } else {
            callback(false, null, null);
          }
        }
      } else {
        callback(false, null, null);
      }
    } catch (e) {
      callback(false, null, null);
    }
  }

  static Future<void> initTestQuestionData(void Function(bool isSuccess, List<dynamic>? outputJson) callback) async {
    try {
      var testJsonMap = json.decode(_testStringData);
      final resultData = testJsonMap['list'];
      callback(true, resultData);
    }catch (e) {
      callback(false, null);
    }
  }

  static const String _testStringData =
  '''
  {"list" :
    [
        {
            "q_id" : "FIRST",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "대출 받을 주택 유형을@선택하세요",
            "q_endtitle" : "대출 받을 주택 유형",
            "q_subtitle" : "",
            "q_list" : [
                        {"name" : "아파트", "sub_name" : "", "prev_next_list" : [{"prev_id" : "NONE", "next_id" : "DETAIL LOCATION1"}]},
                        {"name" : "오피스텔", "sub_name" : "", "prev_next_list" : [{"prev_id" : "NONE", "next_id" : "DETAIL LOCATION1"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "DETAIL LOCATION1",
            "q_desc" : "detail locatation with address1",
            "q_type" :  "search list",
            "q_title" : "담보로 할 주택의@주소를 입력하세요",
            "q_subtitle" : "",
            "q_endtitle" : "담보로 할 주택 주소",
            "q_list" : [
                        {"name" : "", "sub_name" : "", "prev_next_list" : [{"prev_id" : "FIRST", "next_id" : "DETAIL LOCATION2"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "DETAIL LOCATION2",
            "q_desc" : "detail location with address2",
            "q_type" :  "detail location2",
            "q_title" : "상세 주소를 입력하세요",
            "q_subtitle" : "",
            "q_endtitle" : "주택 상세 주소",
            "q_list" : [],
            "q_button_list" : [
                                {"name" : "동 호수 모름", "sub_name" : "", "prev_next_list" : [{"prev_id" : "DETAIL LOCATION1", "next_id" : "DETAIL LOCATION SIZE"}]},
                                {"name" : "다음", "sub_name" : "", "prev_next_list" : [{"prev_id" : "DETAIL LOCATION1", "next_id" : "DETAIL LOCATION SIZE"}]}
                            ],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "DETAIL LOCATION SIZE",
            "q_desc" : "list of q2",
            "q_type" :  "search list",
            "q_title" : "주택 평수를 선택하세요",
            "q_subtitle" : "",
            "q_endtitle" : "주택 평수",
            "q_list" : [
                        {"name" : "", "sub_name" : "", "prev_next_list" : [{"prev_id" : "DETAIL LOCATION2", "next_id" : "LOCATION FLOOR"}]}
                    ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "LOCATION FLOOR",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "주택 층수를 선택하세요",
            "q_subtitle" : "",
            "q_endtitle" : "주택 층수",
            "q_list" : [
                        {"name" : "1층", "sub_name" : "", "prev_next_list" : [{"prev_id" : "DETAIL LOCATION SIZE", "next_id" : "LOAN PURPOSE"}]},
                        {"name" : "2층", "sub_name" : "", "prev_next_list" : [{"prev_id" : "DETAIL LOCATION SIZE", "next_id" : "LOAN PURPOSE"}]},
                        {"name" : "3층 이상", "sub_name" : "", "prev_next_list" : [{"prev_id" : "DETAIL LOCATION SIZE", "next_id" : "LOAN PURPOSE"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "LOAN PURPOSE",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "대출 용도를 선택하세요",
            "q_subtitle" : "임대사업자는 '주택구입'을 선택해 주세요",
            "q_endtitle" : "대출 용도",
            "q_list" : [
                        {"name" : "주택구입", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOCATION FLOOR", "next_id" : "OWN HOUSE YN1"}]},
                        {"name" : "생활자금", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOCATION FLOOR", "next_id" : "OWN HOUSE YN2"}]},
                        {"name" : "대환(대출 갈아타기)", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOCATION FLOOR", "next_id" : "CHOOSE JOB"}]},
                        {"name" : "세입자 보증금 반환", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOCATION FLOOR", "next_id" : "CHOOSE JOB"}]},
                        {"name" : "사업자금", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOCATION FLOOR", "next_id" : "BUSINESS TYPE"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "OWN HOUSE YN1",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "현재 주택을 보유중이신가요?",
            "q_subtitle" : "",
            "q_endtitle" : "주택 보유 상태",
            "q_list" : [
                        {"name" : "무주택", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "FIRST BUY"}]},
                        {"name" : "1주택", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "DISPOSE HOUSE YN"}]},
                        {"name" : "2주택 이상", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "WANT PRICE"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "FIRST BUY",
            "q_desc" : "is first buy",
            "q_type" :  "one list",
            "q_title" : "생애최초 주택구매인가요?",
            "q_subtitle" : "",
            "q_endtitle" : "생애최초 주택 구매 여부",
            "q_list" : [
                        {"name" : "예", "sub_name" : "", "prev_next_list" : [{"prev_id" : "OWN HOUSE YN1", "next_id" : "WANT PRICE"}]},
                        {"name" : "아니오", "sub_name" : "", "prev_next_list" : [{"prev_id" : "OWN HOUSE YN1", "next_id" : "WANT PRICE"}]}
                    ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "WANT PRICE",
            "q_desc" : "input want price",
            "q_type" :  "input price",
            "q_title" : "구입할 주택 가격을@입력하세요",
            "q_subtitle" : "",
            "q_endtitle" : "구입할 주택 가격",
            "q_list" : [],
            "q_button_list" : [
                                {"name" : "다음", "sub_name" : "", "prev_next_list" : [{"prev_id" : "FIRST BUY", "next_id" : "CHOOSE JOB"},{"prev_id" : "DISPOSE HOUSE YN", "next_id" : "CHOOSE JOB"},{"prev_id" : "OWN HOUSE YN1", "next_id" : "CHOOSE JOB"}]}
                            ],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "CHOOSE JOB",
            "q_desc" : "is first buy",
            "q_type" :  "one list",
            "q_title" : "직업을 선택하세요",
            "q_subtitle" : "",
            "q_endtitle" : "직업 정보",
            "q_list" : [
                        {"name" : "직장인", "sub_name" : "", "prev_next_list" : [{"prev_id" : "WANT PRICE", "next_id" : "CREDIT SCORE"},{"prev_id" : "OWN HOUSE YN2", "next_id" : "CREDIT SCORE"},{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]},
                        {"name" : "공무원", "sub_name" : "", "prev_next_list" : [{"prev_id" : "WANT PRICE", "next_id" : "CREDIT SCORE"},{"prev_id" : "OWN HOUSE YN2", "next_id" : "CREDIT SCORE"},{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]},
                        {"name" : "개인사업자", "sub_name" : "", "prev_next_list" : [{"prev_id" : "WANT PRICE", "next_id" : "CREDIT SCORE"},{"prev_id" : "OWN HOUSE YN2", "next_id" : "CREDIT SCORE"},{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]},
                        {"name" : "임대사업자", "sub_name" : "", "prev_next_list" : [{"prev_id" : "WANT PRICE", "next_id" : "CREDIT SCORE"},{"prev_id" : "OWN HOUSE YN2", "next_id" : "CREDIT SCORE"},{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]},
                        {"name" : "프리랜서", "sub_name" : "", "prev_next_list" : [{"prev_id" : "WANT PRICE", "next_id" : "CREDIT SCORE"},{"prev_id" : "OWN HOUSE YN2", "next_id" : "CREDIT SCORE"},{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]},
                        {"name" : "무직", "sub_name" : "", "prev_next_list" : [{"prev_id" : "WANT PRICE", "next_id" : "CREDIT SCORE"},{"prev_id" : "OWN HOUSE YN2", "next_id" : "CREDIT SCORE"},{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]}
                    ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "CREDIT SCORE",
            "q_desc" : "input credit score",
            "q_type" :  "input score",
            "q_title" : "신용점수를 입력하세요",
            "q_subtitle" : "",
            "q_endtitle" : "신용점수",
            "q_list" : [],
            "q_button_list" : [
                                {"name" : "다음", "sub_name" : "", "prev_next_list" : [{"prev_id" : "CHOOSE JOB", "next_id" : "LOAN HISTORY YN"},{"prev_id" : "BUSINESS TYPE", "next_id" : "LOAN HISTORY YN"}]}
                            ],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "DISPOSE HOUSE YN",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "처분 예정이신가요?",
            "q_subtitle" : "",
            "q_endtitle" : "처분 예정 여부",
            "q_list" : [
                        {"name" : "네, 처분 예정이에요", "sub_name" : "", "prev_next_list" : [{"prev_id" : "OWN HOUSE YN1", "next_id" : "WANT PRICE"}]},
                        {"name" : "아니오, 보유 예정이에요", "sub_name" : "", "prev_next_list" : [{"prev_id" : "OWN HOUSE YN1", "next_id" : "WANT PRICE"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "OWN HOUSE YN2",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "현재 주택을 보유중이신가요?",
            "q_subtitle" : "",
            "q_endtitle" : "주택 보유 상태",
            "q_list" : [
                        {"name" : "1주택", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "CHOOSE JOB"}]},
                        {"name" : "2주택 이상", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "CHOOSE JOB"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "BUSINESS TYPE",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "사업자 형태를 선택하세요",
            "q_subtitle" : "",
            "q_endtitle" : "사업자 형태",
            "q_list" : [
                        {"name" : "개인사업자", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]},
                        {"name" : "법인사업자", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN PURPOSE", "next_id" : "CREDIT SCORE"}]}
                     ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "LOAN HISTORY YN",
            "q_desc" : "list of q1",
            "q_type" :  "one list",
            "q_title" : "해당 주택을 담보로@이미 받은 대출이 있나요?",
            "q_subtitle" : "",
            "q_endtitle" : "기 주택담보대출 여부",
            "q_list" : [
                        {"name" : "예", "sub_name" : "", "prev_next_list" : [{"prev_id" : "CREDIT SCORE", "next_id" : "HIST LOAN PRICE"}]},
                        {"name" : "아니오", "sub_name" : "", "prev_next_list" : [{"prev_id" : "CREDIT SCORE", "next_id" : "TENANT YN"}]}
                    ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "HIST LOAN PRICE",
            "q_desc" : "input loan price",
            "q_type" :  "input price2",
            "q_title" : "이미 받은 대출은@얼마인가요?",
            "q_subtitle" : "",
            "q_endtitle" : "기 주택담보대출 금액",
            "q_list" : [],
            "q_button_list" : [
                                {"name" : "모름", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN HISTORY YN", "next_id" : "TENANT YN"}]},
                                {"name" : "다음", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN HISTORY YN", "next_id" : "TENANT YN"}]}
                            ],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "TENANT YN",
            "q_desc" : "is tenant",
            "q_type" :  "one list",
            "q_title" : "임차인이 있나요?",
            "q_subtitle" : "",
            "q_endtitle" : "임차인 여부",
            "q_list" : [
                        {"name" : "예", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN HISTORY YN", "next_id" : "TENANT PRICE"},{"prev_id" : "HIST LOAN PRICE", "next_id" : "TENANT PRICE"}]},
                        {"name" : "아니오", "sub_name" : "", "prev_next_list" : [{"prev_id" : "LOAN HISTORY YN", "next_id" : "WANT LOAN PRICE"},{"prev_id" : "HIST LOAN PRICE", "next_id" : "WANT LOAN PRICE"}]}
                    ],
            "q_button_list" : [],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "TENANT PRICE",
            "q_desc" : "input loan price",
            "q_type" :  "input price2",
            "q_title" : "임차인 보증금액을@입력하세요",
            "q_subtitle" : "",
            "q_endtitle" : "임차인 보증금액",
            "q_list" : [],
            "q_button_list" : [
                                {"name" : "모름", "sub_name" : "", "prev_next_list" : [{"prev_id" : "TENANT YN", "next_id" : "WANT LOAN PRICE"}]},
                                {"name" : "다음", "sub_name" : "", "prev_next_list" : [{"prev_id" : "TENANT YN", "next_id" : "WANT LOAN PRICE"}]}
                            ],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        },
        {
            "q_id" : "WANT LOAN PRICE",
            "q_desc" : "input loan price",
            "q_type" :  "input price",
            "q_title" : "대출 받고 싶은 금액을@입력하세요",
            "q_subtitle" : "",
            "q_endtitle" : "희망 대출 금액",
            "q_list" : [],
            "q_button_list" : [
                                {"name" : "다음", "sub_name" : "", "prev_next_list" : [{"prev_id" : "TENANT YN", "next_id" : "END"},{"prev_id" : "TENANT PRICE", "next_id" : "END"}]}
                            ],
            "q_ext1" : "",
            "q_ext2" : "",
            "q_ext3" : ""
        }
    ]
}
''';
}