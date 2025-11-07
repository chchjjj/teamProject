<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배송지 팝업</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <div> 
            <div>
                주소 : <input v-model="addr" disabled><button @click="fnSearchAddr">주소검색</button>
            </div>
            <div>
                핸드폰번호 :
                <input class="phone" v-model="phone1"> -
                <input class="phone" v-model="phone2"> -
                <input class="phone" v-model="phone3">
            </div>
            <div>
                <button @click="fnAddAddress">+ 배송지 신규 추가</button><!-- 배송지 추가-->
            </div> 
        </div>
         <div>
            <div>기본배송지</div>
            <div>휴대폰 번호: {{userPhone}}</div> <!-- 가입할 때 휴대폰 번호-->
            <div>배송지: {{userAddress}}</div> <!-- 가입할 때 주소-->
            <div><button @click="fnUseAddress(userAddress)">선택</button></div>
         </div>
         <div v-for="item in addressList">
            <hr>
            <div>{{item.phone}}</div> <!-- 휴대폰 번호-->
            <div>{{item.fullAddress}}</div> <!-- 주소-->
            <div>
                <button @click="fnUseAddress(item.fullAddress)">선택</button>
                <button @click="fnRemoveAddress(item.addressId)">삭제</button>
            </div>
         </div>
    </div>
</body>
</html>

<script>
    //주소 api 관련 여기부터
    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
            console.log(roadFullAddr);
            console.log(addrDetail);
            console.log(zipNo);

            window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
    }
    //주소 api 관련 여기까지

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                addressList: [], // 기본 주소 이외에 구매자가 추가로 입력한 배송지 정보
                addr: "", //추가할 배송지 주소 

                //세션
                userPhone: "${sessionPhone}", //사용자의 기본 휴대폰 번호
                userAddress: "${sessionAddress}", //사용자의 기본 주소
                userId: "${sessionId}", //사용자 아이디

                //payment.jsp에서 넘겨받기
                orderIdList: [],

                //추가할 배송지 휴대폰 번호
                phone1: "",
                phone2: "",
                phone3: ""

            };
        },
        methods: {
            // 함수(메소드) - (key : function())

            //주소 api 사용하기 여기부터
            fnSearchAddr: function(){
                window.open("/user/addr.do", "addr", "width=500, height=500, top=100, left=900");
            },
            fnResult: function (roadFullAddr, addrDetail, zipNo) {
                    let self = this;
                    self.addr = roadFullAddr;
            },
            //주소 api 사용하기 여기까지


            //배송지 추가
            fnAddAddress: function(){
                let self = this;
                if (self.addr == "") {
                    alert("주소를 입력해주세요.");
                    return;
                }
                if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                    alert("휴대폰 형식이 맞지 않습니다.");
                    return;
                }

                let phone = self.phone1 + "-" + self.phone2 + "-" + self.phone3;

                let param = {
                    userId: self.userId,
                    phone: phone,
                    addr : self.addr
                };
                $.ajax({
                    url: "/payment/addAddress.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("배송지가 성공적으로 추가되었습니다!");
                        self.fnAddressList();
                    }
                });
            },

            //배송지 주소, 휴대폰 목록 (기본 정보 외에 추가한 것 출력)
            fnAddressList: function () {
                let self = this;
                let param = {
                    userId: self.userId
                };
                $.ajax({
                    url: "/payment/addressList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.addressList = data.list;
                    }
                });
            },

            fnRemoveAddress: function(addressId){
                let self = this;
                let param = {
                    addressId : addressId
                };
                $.ajax({
                    url: "/payment/removeAddress.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("배송지가 삭제되었습니다.");
                        self.fnAddressList(); //주소 목록 출력(기본 주소 외에 추가 입력한 것)
                    }
                });
            },

            fnUseAddress: function(fullAddress){
                let self = this;
                if (self.orderIdList.length === 0) {
                        alert("배송지를 선택할 주문서가 없습니다.");
                        return;
                }
                let param = {
                    fullAddress : fullAddress,
                    orderIdList: JSON.stringify(self.orderIdList) //문자열로 전송
                };
                $.ajax({
                    url: "/payment/useAddress.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("배송지가 선택되었습니다.");
                        window.close();
                    }
                });
            }

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            //스크립트에서 vue 내부의 데이터 접근 (주소 api 관련)
            window.vueObj = this;
            self.fnAddressList(); //주소 목록 출력(기본 주소 외에 추가 입력한 것)
            let str = "${orderIdList}";
             self.orderIdList = JSON.parse(str); //파싱을 해줘야 문자열을 리스트로 바꿀 수 있다.
            //self.orderIdList = JSON.parse("$orderIdList"); //파싱을 해줘야 문자열을 리스트로 바꿀 수 있다.
            console.log("self.orderIdList: " + self.orderIdList);
            console.log("최종적으로 사용할 orderIdList 값은 => " + self.orderIdList);
        }
    });

    app.mount('#app');
</script>