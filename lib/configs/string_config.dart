import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:upfin/styles/ColorStyles.dart';
import 'package:upfin/utils/common_utils.dart';
import 'package:upfin/utils/ui_utils.dart';

class StringConfig{
  static String agreeContents1 = "제 1 조 (목적)\n이 약관은 YSMETA(이하 \'사이트\'라 합니다)에서 제공하는 인터넷서비스(이하 \'서비스\'라 합니다)의 이용 조건 및 절차에 관한 기본적인 사항을 규정함을 목적으로 합니다."
      "\n\n제 2 조 (약관의 효력 및 변경)\n\n① 이 약관은 서비스 화면이나 기타의 방법으로 이용고객에게 공지함으로써 효력을 발생합니다."
      "\n② 사이트는 이 약관의 내용을 변경할 수 있으며, 변경된 약관은 제1항과 같은 방법으로 공지 또는 통지함으로써 효력을 발생합니다."
      "\n\n제 3 조 (용어의 정의)\n이 약관에서 사용하는 용어의 정의는 다음과 같습니다."
      "\n① 회원 : 사이트와 서비스 이용계약을 체결하거나 이용자 아이디(ID)를 부여받은 개인 또는 단체를 말합니다."
      "\n② 신청자 : 을 신청하는 개인 또는 단체를 말합니다."
      "\n③ 아이디(ID) : 회원의 식별과 서비스 이용을 위하여 회원이 정하고 사이트가 승인하는 문자와 숫자의 조합을 말합니다."
      "\n④ 비밀번호 : 회원이 부여 받은 아이디(ID)와 일치된 회원임을 확인하고, 회원 자신의 비밀을 보호하기 위하여 회원이 정한 문자와 숫자의 조합을 말합니다."
      "\n⑤ 해지 : 사이트 또는 회원이 서비스 이용계약을 취소하는것을 말합니다.";

  static String bannerTextForTest = "대출금리 연 20%이내 (연체금리는 약정금리 +3% 이내, 최대 연20% 이내)l연체금 보유, 신용점수 등 낮음등의 사유로 대출이 제한될 수 있습니다."
      "l담보 물건, 담보종류 등에 따라 대출조건(이자율,기한등)이 차등 적용되며, 담보물이 부적합할 경우 대출이 제한될 수 있습니다.l담보대출의 경우 중도상환수수료, "
      "담보권설정비용이 발생 될 수 있습니다.l중도상환수수료는 최대3%로 대부업법에 따른 최고 이자율이내에서 대출기간에 따라 차등 적용 됩니다."
      "l예시:이자는 매월 약정일에 부과. 100만원을 연 20%로 12개월 동안 원리금균등상환 시 총 납부금액 1,111,662원l일정기간 납부해야 할 원리금이 "
      "연체될 경우에 계약만료 기한이 도래하기 전에 모든 원리금을 변제해야 할 의무가 발생할 수 있습니다.l금융소비자는 금소법 제19조제1항에 따라 해당상품 또는 서비스에 대하여 설명을 받을 권리가 있으며, "
      "그 설명을 듣고 내용을 충분히 이해한 후 거래하시기 바랍니다.l계약을 체결하기 전 자세한 내용은 상품설명서와 약관을 읽어보시기 바랍니다.과도한 빚은 당신에게 큰 불행을 안겨줄 수 있습니다."
      "대출 시, 상환능력에 비해 대출금이 과도할 경우 귀하의 신용등급 또는 개인신용평점이 하락할 수 있습니다."
      "중개수수료를 요구하거나 받는 것은 불법 입니다.";

  static String htmlTest = """ <br>안녕하십니까 저는 김동환 입니다.<br> <a class='btn btn-primary'  href='/mycredit/cXfOR99PRmMZyaORJKl3-w?checklist=1'>나이스신용인증 바로가기</a> """;

  static String htmlTest2 = """ 
  <p>&nbsp;</p>
<table style="border: none;border-collapse: collapse;width:1107pt;">
    <tbody>
        <tr>
            <td colspan="2" style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;width:601pt;'>아침해파이낸셜대부 개인정보처리방침<br><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:82pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:53pt;'><br></td>
        </tr>
        <tr>
            <td colspan="9" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:15.75pt;'>㈜아침해파이낸셜대부(이하 &lsquo;회사&rsquo;라 한다)는 정보주체의 자유와 권리 보호를 위해 「개인정보 보호법」 및 관계 법령이 정한 바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다.&nbsp;</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="11" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:15.75pt;'>이에 「개인정보 보호법」 제30조에 따라 정보주체에게 개인정보 처리에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립&middot;공개합니다.</td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:15.75pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제1조 개인정보의 처리 목적</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 이용자의 서비스 제공을 위하여 개인정보를 다음과 같은 목적을 위하여 처리합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="4" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>개인정보는 다음의 목적 이외의 용도로 이용되지 않으며 이용목적이 변경되는 경우에는 별도의 동의를 받는 등 필요한 조치를 이행할 것입니다.<br><br></td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td colspan="6" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>등&apos;을 근거로 수집항목 확대하는 것은 분쟁 소지가 있음.</td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회원가입</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>가입의사 확인, 연령 확인, 이용자 식별, 본인확인</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>대출비교서비스</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>제휴된 금융회사의 대출한도, 금리, 계약기간, 상환방법 비교</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>등록된 상담사와 상담 신청</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>온라인 간편서류 제출 제공</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자가 선택한 금융회사의 대출 접수</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>대출 심사 과정 정보 제공</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>대출거래의 체결 여부 조회 및 관리</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자가 가입한 금융상품 정보 제공에 기반한 금융상품 추천</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>분쟁 해결, 민원처리, 문의사항, 공지사항 전달</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>광고 마케팅</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사 및 제휴사의 상품 서비스에 대한 광고, 홍보, 프로모션 제공</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제2조 개인정보의 수집 항목</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자는 회원가입을 통해 회사가 제공하는 모든 서비스를 이용할 수 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>단, 필수 항목의 수집 이용동의를 거부할 경우, 회원가입 및 일부 서비스의 이용이 불가할 수 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>마케팅 등의 선택 동의를 거부하여도 서비스는 정상적으로 이용할 수 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 단계별 서비스에서 이용자의 동의 후 개인정보를 수집합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>서비스</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>수집 항목</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>회원가입</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>이름, 생년월일, 성별, 전화번호, 통신사, 이메일</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td rowspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:34.0pt;'>대출비교서비스</td>
            <td colspan="3" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>직업, 소유 부동산 주소, 주거 주소, 고용형태, 소득구분, 사건번호, 환급계좌번호, 소유차량번호</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>희망대출금액, 예상한도, 예상금리, 대출기간, 예상금융사명</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>대출비교관리</td>
            <td colspan="4" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>금융사명, 대출금액, 대출금리, 대출승인여부, 대출실행일, 대출상환방식, 중도상환수수료,대출관리번호</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>온라인 간편 서류 제출</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>*열기 (별도 구성)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자의 개인정보는 아래 방법을 통해 수집합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>1) 이용자가 서비스 단계별로 직접 입력</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>2) 이용자가 서비스 단계별 내용을 확인 후 동의</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>3) 고객센터, 이메일, 전화 등을 통한 상담</td>
            <td colspan="3" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>&nbsp;&apos;등&apos; 삭제. &nbsp; &nbsp; 수집항목을 구체적으로 명시해야함. &nbsp;예시) 고객센터, 이메일, 전화, 채팅을 통한 상담 &nbsp;</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제3조 개인정보의 처리 및 보유기간</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자의 회원가입 또는 서비스 동의를 얻은 경우</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>목적</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;'>보관기관</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회원가입 및 서비스 이용</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>회원 탈퇴시까지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>대출비교 및 관리 서비스</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>회원 탈퇴 및 동의 철회시</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>대출과정 확인을 위해 제휴 금융사로부터 수집한 정보</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>3개월</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>마케팅, 광고</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>동의시부터 동의 철회 또는 회원 탈퇴시</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>법령에서 일정 기간 정보보관 의무가 있는 경우</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>관계 법령 위반에 따른 수사/조사 등이 진행 중인 경우에는 해당 수사/조사 종료 시까지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>중개수수료등 서비스 공급 결제 정산 완료시까지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>관계법령에 포함되는 사유(아래)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>관계법령</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;'>목적</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;'>보관기관</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td rowspan="3" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:54.0pt;'>「전자상거래 등에서의 소비자보호에 관한 법률」</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:355pt;'>계약 또는 청약철회 등에 관한 기록</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:82pt;'>5년</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:18.0pt;width:355pt;'>소비자의 불만 또는 분쟁처리에 관한 기록</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:82pt;'>3년</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:18.0pt;width:355pt;'>대금 결제 및 재화 등의 공급에 관한 기록</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:82pt;'>5년</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:18.0pt;width:246pt;'>「전자금융거래법」</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:355pt;'>전자금융에 관한 기록</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:82pt;'>5년</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:18.0pt;width:246pt;'>「통신비밀 보호법」</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:355pt;'>로그인 기록(로그기록 자료, 접속자의 추적 자료)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:82pt;'>3개월</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:18.0pt;width:246pt;'>「신용정보의 이용 및 보호에 관한 법률」</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:355pt;'>신용정보 업무처리에 관한 기록</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;width:82pt;'>3년</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제4조 개인정보의 3자정보제공</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="5" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 대출비교 및 중개, 대출접수의 서비스를 위해 이용자가 동의한 경우에 한하여 선택한 금융기관에 다음과 같이 귀하의 개인정보를 제공합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>기관</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;'>항목</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;'>목적</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>나이스신용정보㈜</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>이름, 휴대전화번호, 통신사정보, 생년월일, 성별</td>
            <td colspan="5" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>신용 조회 서비스 (신용점수 및 신용정보 등 확인) 제공</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>계약된 금융사명 <span style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";'>(기관 미기재)</span></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>이름, 생년월일, 성별, 전화번호, 통신사, 이메일</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>목적 미고지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:36.0pt;'>기관 미기재</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;width:355pt;'>직업, 소유 부동산 주소, 주거 주소, 고용형태, 소득구분,&nbsp;<br>&nbsp;사건번호, 환급계좌번호, 소유차량번호</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>목적 미고지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>기관 미기재</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>희망대출금액</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>목적 미고지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:center;vertical-align:middle;border:none;height:17.0pt;'>기관 미기재</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>온라인 간편 서류 항목 (바로가기)</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>목적 미고지</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제5조 개인정보 처리 위탁</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 서비스의 원활한 제공을 위해 일부 업무를 외부 업체로 개인정보를 위탁하고 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="5" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:19.5pt;'>관련법령에 의거하여 정기적으로 위탁업체를 감독하고 있으며, 위탁업무의 내용이나 수탁자가 변경되는 경우 개인정보처리방침을 통해 공개 하겠습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>수탁업체</td>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>위탁업무</td>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>보유 및 이용기관</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>이용기간?</td>
            <td colspan="2" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>오타 수정 필요</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>다날</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>휴대전화 본인인증</td>
            <td colspan="3" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>회원 탈퇴 및 위탁 계약 종료시</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>와이에스메타</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>서버 운영 및 관리</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>미기재</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>나이스신용정보㈜</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>미기재</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>미기재</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제6조 개인정보 자동 수집 장치의 설치&middot;운영 및 거부에 관한 사항</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 이용자에게 서비스를 제공하기 위해 이용정보를 저장하고 찾아내는 &apos;쿠키(Cookie)&apos;를 사용합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="4" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>&nbsp;&ldquo;쿠키&rdquo;는 앱 또는 웹사이트 서버가 이용자의 브라우저에 보내는 아주 작은 텍스트 정보이며 이용자의 컴퓨터 또는 단말 기기에 저장됩니다</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="8" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자가 회사의 앱 또는 웹사이트에 접속한 경우 이용자에게 최적의 서비스를 제공하기 위해 이용자의 기기에 저장되어 있는 쿠키 정보를 확인하여 이용형태등을 파악하여 사용 됩니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="7" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자는 웹브라우저의 보안정책을 통해 쿠키 허용을 제한하여 설치 운영을 거부할 수 있습니다. 단, 쿠키 저장을 제한하는 경우 서비스 이용에 어려움이 발생할 수 있습니다.</td>
            <td colspan="4" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>쿠키 저장 거부시 제한되는 서비스 구체적으로 안내해야함.</td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>도구-&gt;인터넷옵션-&gt;보안-&gt;사용자정의수준</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제7조 이용자 및 법정대리인의 권리 의무 및 그 행사방법</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자는 회사가 보유한 개인정보에 대해 개인정보 열람&middot;정정&middot;삭제&middot;처리정지 요구 등 권리를 행사할 수 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>등&apos; 삭제</td>
            <td colspan="3" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>확대 해석의 여지 차단</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="5" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 이용자에게 신분증 또는 기타 방법을 통하여 본인임을 확인하고 이용자가 요청한 열람, 삭제, 처리정지 등에 대한 요청을 지체없이 처리하겠습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>등&apos; 삭제</td>
            <td colspan="3" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>확대 해석의 여지 차단</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="5" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자는 법정대리인이나 위임을 받은 자 등 대리인을 통하여 권리를 요구하실 수 있으며, 이 경우 대리권을 증명할 수 있는 자료를 제출하셔야 합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제6조 개인정보의 파기 절차 및 방법</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="4" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:left;vertical-align:middle;border:none;height:17.0pt;'>회사는 이용자의 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 대에는 지체없이 해당 개인정보를 파기합니다.</td>
            <td colspan="3" style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>오타수정 필요(되었을 때)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="11" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고&nbsp;<br>&nbsp;다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터<br>&nbsp;베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.&nbsp;</td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>개인정보보호 책임자의 승인을 통해 파기사유를 확인하고 파기합니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="6" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>&nbsp;전자적 파일 형태로 기록&middot;저장된 개인정보는 기록을 재생할 수 없도록&nbsp;<br>&nbsp;파기하며, 종이 문서에 기록&middot;저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제5조 개인정보의 안전성 확보조치에 관한 사항</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="4" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이용자의 개인정보를 안정하게 관리하기 위하여 회사는 법령에서 요구하는 사항을 준수하고, 개인정보 보호를 위한 대책은 아래와 같습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>기술적대책</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>시스템 접근권한관리, 접근통제시스템, 보안프로그램설치, 암호화 등</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>등&apos; 삭제</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>물리적 대책</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>전산실, 자료 보관실 접근통제</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>관리적 대책</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>개인정보관리 내부 교육, 준수여부확인, 정보보호서약등의 관리</td>
            <td style='color:red;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>등&apos; 삭제</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:19px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:20.0pt;'>제11조 개인정보 관련 고충사항처리</td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:19px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="4" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>회사는 이용자의 개인신용정보를 보호하고 개인신용정보와 관련한 고충 처리를 위하여 다음과 같이 개인정보보호책임자를 두고 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="5" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>또한 이용자 고충사항을 신속하게 처리하기 위하여 고객센터를 운영하고 있습니다. 고객센터를 통해 궁금한 사항을 문의하고 조치를 요청할 수 있습니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>소속</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>관리부</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>성명</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>권미희</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이메일</td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>admin@sunfnc.com</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>민원처리센터 대표번호</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'>1800-9221</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>기타 개인정보 침해에 대한 신고나 상담이 필요한 경우 아래 기관에 문의하시기 바랍니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>개인정보침해 신고센터(https://privacy.kisa.or.kr, 국번없이 118)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>대검찰청 사이버수사과 (https://spo.go.kr, 국번없이 1301)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>경찰청 사이버안전국 (https://ecrm.cyber.go.kr, 국번없이 182)</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>개인정보 분쟁조정위원회(https://www.kopico.go.kr, 국번없이 1833-6972)<br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:#161616;font-size:15px;font-weight:700;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>제12조 개인정보처리방침의 변경에 관한 사항</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td colspan="2" style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'>이 개인정보 처리방침은 2023년 &nbsp;월 &nbsp;일 부터 적용됩니다.</td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:#161616;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
        <tr>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;height:17.0pt;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
            <td style='color:black;font-size:15px;font-weight:400;font-style:normal;text-decoration:none;font-family:"맑은 고딕";text-align:general;vertical-align:middle;border:none;'><br></td>
        </tr>
    </tbody>
</table>
  """;

  /*
/n간격/n --> 치환
@제목
@소제목
@본문
   */
  static String testAgreeText =
          "@제목큰제목1여기에@제목"+
              "@소제목큰제목1의소제목1여기에@소제목"+
              "@본문소제목1의본문내용여기에@본문"+
              "@소제목큰제목1의소제목2여기에@소제목"+
              "@본문소제목2의본문내용여기에@본문"+
              "@소제목큰제목1의소제목3여기에@소제목"+
              "@본문소제목3의본문내용여기에@본문"+
              "@소안내큰제목1의안내문구여기에@소안내"+ //(*각 제목 부분의 맨 마지막에 위치)

          "@제목큰제목2여기에@제목"+
              "@소제목큰제목2의소제목1여기에@소제목"+
              "@본문큰제목2의소제목2의본문내용여기에@본문"+
              "@소제목큰제목2의소제목2여기에@소제목"+
              "@본문큰제목2의소제목2의본문내용여기에@본문"+
              "@소제목큰제목2의소제목3여기에@소제목"+
              "@본문큰제목2의소제목3의본문내용여기에@본문"+
              "@소안내큰제목2의안내문구여기에@소안내"+ //(*각 제목 부분의 맨 마지막에 위치)

          "@제목큰제목3여기에@제목"+
              "@소제목큰제목3의소제목1여기에@소제목"+
              "@본문큰제목3의소제목2의본문내용여기에@본문"+
              "@소제목큰제목3의소제목2여기에@소제목"+
              "@본문큰제목3의소제목2의본문내용여기에@본문"+
              "@소제목큰제목3의소제목3여기에@소제목"+
              "@본문큰제목3의소제목3의본문내용여기에@본문"+
              "@소안내큰제목3의안내문구여기에@소안내"+ //(*각 제목 부분의 맨 마지막에 위치)

          "@안내전체주의사항안내여기에@안내" //(*전체의 맨 마지막에 위치)
  ;
  static Widget getAgreeContents(String agreeText){
    List<Widget> widgetList = [];
    try{
      List<String> textList = agreeText.split("@제목");
      for (int i = 0; i < textList.length; i++) {
        if (i % 2 != 0) {
          if(textList[i] != ""){
            // @제목 위간격
            if(i != 1) widgetList.add(UiUtils.getMarginBox(0, 3.h));

            // @제목 문구
            widgetList.add(Padding(padding: EdgeInsets.only(left: 2.w, right: 0.w, top: 0.w, bottom: 0.w),
                child: UiUtils.getTextWithFixedScale(textList[i], 22.sp, FontWeight.w600, ColorStyles.upFinBlack, TextAlign.start, null)));

            // @제목 아래간격
            widgetList.add(UiUtils.getMarginBox(0, 1.h));
          }
        } else {
          if(textList[i] != ""){
            List<String> subTextList = textList[i].split("@소제목");
            for(int i2 = 0; i2 < subTextList.length; i2++){
              if (i2 % 2 != 0) {
                if(subTextList[i2] != ""){
                  // @소제목 위간격
                  if(i2 != 1) widgetList.add(UiUtils.getMarginBox(0, 2.h));

                  // @소제목 문구
                  widgetList.add(Padding(padding: EdgeInsets.only(left: 4.w, right: 0.w, top: 0.w, bottom: 0.w),
                      child: UiUtils.getTextWithFixedScale(subTextList[i2], 16.sp, FontWeight.w500, ColorStyles.upFinBlack, TextAlign.start, null)));

                  // @소제목 아래간격
                  widgetList.add(UiUtils.getMarginBox(0, 0.5.h));
                }
              }else{
                if(subTextList[i2] != ""){
                  List<String> contentsTextList = subTextList[i2].split("@본문");
                  for(int i3 = 0; i3 < contentsTextList.length; i3++){
                    if (i3 % 2 != 0) {
                      if(contentsTextList[i3] != ""){
                        // @본문 위간격
                        widgetList.add(UiUtils.getMarginBox(0, 1.h));

                        // @본문 문구
                        widgetList.add(Padding(padding: EdgeInsets.only(left: 8.w, right: 0.w, top: 0.w, bottom: 0.w),
                            child: UiUtils.getTextWithFixedScale(contentsTextList[i3], 12.sp, FontWeight.w400, ColorStyles.upFinBlack, TextAlign.start, null)));

                        // @본문 아래간격
                        widgetList.add(UiUtils.getMarginBox(0, 1.h));
                      }
                    }else if(i2 == subTextList.length-1 && i3 == contentsTextList.length-1){
                      List<String> alarmContentsTextList = contentsTextList[i3].split("@소안내");
                      for(int i4 = 0; i4 < alarmContentsTextList.length; i4++){
                        if(i4 % 2 != 0){
                          if(contentsTextList[i3] != ""){
                            // @소안내 위간격
                            widgetList.add(UiUtils.getMarginBox(0, 1.h));

                            // @소안내 문구
                            widgetList.add(Padding(padding: EdgeInsets.only(left: 4.w, right: 0.w, top: 0.w, bottom: 0.w),
                                child: UiUtils.getTextWithFixedScale(alarmContentsTextList[i4], 12.sp, FontWeight.w400, ColorStyles.upFinRed, TextAlign.start, null)));

                            // @소안내 아래간격
                            widgetList.add(UiUtils.getMarginBox(0, 0.5.h));
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          if(i == textList.length-1){
            // @안내 문구(전체 주의사항 문구)
            List<String> bigAlarmContentsTextList = textList[i].split("@안내");
            for(int i5 = 0; i5 < bigAlarmContentsTextList.length; i5++){
              if(i5 % 2 != 0){
                if(bigAlarmContentsTextList[i5] != ""){
                  // @안내 위간격
                  widgetList.add(UiUtils.getMarginBox(0, 3.h));

                  // @안내 문구
                  widgetList.add(Padding(padding: EdgeInsets.only(left: 2.w, right: 0.w, top: 0.w, bottom: 0.w),
                      child: UiUtils.getTextWithFixedScale(bigAlarmContentsTextList[i5], 18.sp, FontWeight.w600, ColorStyles.upFinRed, TextAlign.start, null)));

                  // @안내 아래간격
                  widgetList.add(UiUtils.getMarginBox(0, 2.h));
                }
              }
            }
          }
        }
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgetList);
    }catch(error){
      CommonUtils.log("e", "agree contents parsing error : $error");
      return Container();
    }
  }
}