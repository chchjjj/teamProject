<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>비밀번호 찾기</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            table, tr, td, th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <!-- 아이디, 이름, 번호를 가진 사람이 db에 있으면  -->
            <!-- 문자인증 후 비밀번호 변경 페이지로 이동 -->
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

                <!-- 여기 밑 세 줄을 문자인증 도입하면 주석 처리 -->

                <!-- <div>
                    <button @click="fnAuth">인증</button>
                </div> -->

                <!-- 문자 인증 도입하기 전에는 밑에 줄 주석처리 여기부터 -->
                
                <div v-if="!smsFlg">
                    문자인증 : <input v-model="inputNum" :placeholder="timer">
                    <template v-if="!sendMessageFlg">
                        <button @click="fnSms">인증번호 전송</button>
                    </template>
                    <template v-else>
                        <button @click="fnSmsAuth">문자인증</button>
                    </template>
                </div>
                <div v-else>
                    <button @click="fnAuth">사용자인증</button>
                </div>

                <!-- 여기까지 -->

            </div>
            <div v-else>
                <div>
                    <label>비밀번호 : <input v-model="userPass" placeholder="영문 숫자 특수기호 조합 8자리 이상"></label>
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
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    authFlg: false,
                    userId: "",
                    userPass: "",
                    userPass2: "",
                    userName: "",
                    phone: "",
                    inputNum: "", //문자인증 번호
                    sendMessageFlg: false, //문자인증 메세지 전송 여부
                    timer: "",
                    count: 180,
                    smsFlg: false, //문자 인증 유무
                    ranStr: "" //문자 인증 번호
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
                                self.authFlg = true;
                            } else {
                                alert("사용자 정보를 찾을 수 없습니다.");
                            }
                        }
                    });
                },
                fnChangePwd: function () {
                    let self = this;
                    let regPassword = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,500}$/; //비밀번호 정규식 (영문 숫자 특수기호 조합 8자리 이상 500자리 이하)
                    if (!regPassword.test(self.userPass)) {
                        alert('비밀번호 형식에 따라 정확히 입력해주세요');
                        return;
                    }
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
                                location.href = "/main.do";
                            } else {
                                alert(data.msg);
                            }
                        }
                    });
                },
                fnSms: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "/send-one",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            if (data.res.statusCode == "2000") {
                                alert("문자 전송 완료");
                                self.ranStr = data.ranStr;
                                self.sendMessageFlg = true;
                                self.fnTimer();
                            } else {
                                alert("잠시 후 다시 시도해주세요.");
                            }
                        }
                    });
                },
                fnTimer: function () {
                    let self = this;
                    let interval = setInterval(() => {
                        if (self.count == 0) {
                            clearInterval(interval);
                            alert("시간이 만료되었습니다.");
                        } else {
                            let min = parseInt(self.count / 60);
                            let sec = self.count % 60;
                            min = min < 10 ? "0" + min : min;
                            sec = sec < 10 ? "0" + sec : sec;
                            self.timer = min + " : " + sec;

                            self.count--;
                        }
                    }, 1000);
                },
                fnSmsAuth: function () {
                    let self = this;
                    if(!self.sendMessageFlg){
                        alert("문자 인증을 진행해주세요.");
                        return;
                    }
                    if (self.ranStr == self.inputNum) {
                        alert("문자인증이 완료되었습니다.");
                        self.smsFlg = true;
                    } else {
                        alert("문자인증에 실패했습니다.");
                    }
                }

            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
            }
        });

        app.mount('#app');
    </script>