<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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
        <!-- 아이디, 이름, 번호를 가진 사람이 db에 있으면  -->
        <!-- 비밀번호 변경 페이지로 이동 -->
        <!-- 그렇지 않으면 '회원정보를 확인해주세요.' 출력 화면이동x -->
        <!-- 비밀번호 수정화면에서 비밀번호 입력 후  -->
        <!-- 회원 비밀번호 변경 - 해시화 해서 저장 -->
        <!-- 비밀번호 변경 요청 시 -->
        <!-- 내가 입력한 비밀번호랑 기존 비밀번호랑 동일하면  -->
        <!-- '비밀번호가 이전과 동일합니다.' 출력 후 업데이트 x (비교는 해시값끼리 비교) -->
        <div v-if="!authFlg">
            <div>
                <label>아이디 : <input v-model="userId"></label>
            </div>
            <div>
                <label>이름 : <input v-model="userName"></label>
            </div>
            <div>
                <label>번호 : <input v-model="phone" placeholder="-를 제외하고 입력해주세요."></label>
            </div>
            <div>
                <button @click="fnAuth">인증</button>
            </div>
        </div>
        <div v-else>
            <div>
                <label>비밀번호 : <input v-model="userPass"></label>
            </div>
            <div>
                <label>비밀번호 확인 : <input v-model="userPass2"></label>
            </div>
            <div>
                <button @click="fnChangePwd">비밀번호 수정</button>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    //IMP.init("imp44302855");
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                authFlg: false,
                userId: "",
                userPass: "",
                userPass2: "",
                userName: "",
                phone: ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAuth: function () {
                    let self = this;
                    // console.log("공백 제거 전 ==> ", self.userId);
                    // console.log("공백 제거 후 ==> ", self.userId.trim());
                    let param = {
                        userId: self.userId.trim(),
                        userName: self.userName.trim(),
                        phone: self.phone.trim()
                    };
                    $.ajax({
                        url: "/user/auth.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("인증되었습니다!");
                                
                                //문자 인증용
                                //self.fnCertification();

                                self.authFlg = true;
                            } else {
                                alert("사용자 정보를 찾을 수 없습니다.");
                            }
                        }
                    });
                },
                fnCertification: function () {
                    let self = this;
                    // IMP.certification(param, callback) 호출
                    IMP.certification(
                       {
                            // param
                           channelKey: "channel-key-06c235fe-518d-4661-a71c-e7750166e1e1",
                           merchant_uid: "merchant_" + new Date().getTime() // 주문 번호
                            
                       },
                       function (rsp) {
                            // callback
                           if (rsp.success) {
                                // 인증 성공 시 로직
                               alert("인증 성공!");
                               console.log(rsp);
                               self.authFlg = true;
                           } else {
                               // 인증 실패 시 로직
                               alert("인증 실패!");
                               console.log(rsp);
                           }
                       },
                    );
                },
                fnChangePwd: function () {
                    let self = this;
                    if (self.userPass != self.userPass2) {
                        alert("비밀번호가 다릅니다!");
                        return;
                    }
                    let param = {
                        userId: self.userId.trim(),
                        userPass: self.userPass.trim()
                    };
                    $.ajax({
                        url: "/user/resetPassword.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            if (data.result == "success") {
                                alert(data.msg);
                            } else {
                                alert(data.msg);
                            }
                        }
                    });
                }

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>