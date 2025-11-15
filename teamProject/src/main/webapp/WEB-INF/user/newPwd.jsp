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
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Pretendard", sans-serif;
            }

            body {
                background-color: #fff;
            }

            #app {
                display: flex;
                height: 100vh;
            }

            /* ===== 왼쪽 영역 ===== */
            .left-panel {
                flex: 0.75;
                background-color: #3E2723;
                color: #FFEDAC;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                font-size: 30px;
                font-weight: 600;
                line-height: 1.8;
                text-align: center;
                cursor: pointer;
            }

            /* ===== 오른쪽 영역 ===== */
            .right-panel {
                flex: 1.25;
                background: linear-gradient(120deg, #FFEDAC, #FFEDAC, #3E2723);
                background-size: 300% 300%;
                animation: gradientMove 8s ease infinite;
                display: flex;
                flex-direction: column;
                justify-content: center;
                /* 세로 중앙 정렬 */
                align-items: center;
                position: relative;
                overflow: hidden;
            }

            .right-panel::before {
                content: "";
                position: absolute;
                top: 0;
                left: -50%;
                width: 200%;
                height: 100%;
                background: radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.3), transparent 60%);
                animation: shineMove 6s linear infinite;
                pointer-events: none;
            }

            @keyframes gradientMove {
                0% {
                    background-position: 0% 50%;
                }

                50% {
                    background-position: 100% 50%;
                }

                100% {
                    background-position: 0% 50%;
                }
            }

            @keyframes shineMove {
                0% {
                    transform: translateX(-20%);
                }

                50% {
                    transform: translateX(20%);
                }

                100% {
                    transform: translateX(-20%);
                }
            }

            /* ===== 비밀번호 찾기 박스 ===== */
            .find-box {
                width: 60%;
                max-width: 500px;
                background-color: #fff;
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(62, 39, 35, 0.1);
                transition: all 0.3s ease;
            }

            .find-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(62, 39, 35, 0.2);
            }

            .find-title {
                font-size: 1.8rem;
                font-weight: 700;
                color: #3E2723;
                text-align: center;
                margin-bottom: 25px;
            }

            label {
                display: block;
                font-weight: 600;
                color: #3E2723;
                margin-top: 15px;
                margin-bottom: 8px;
            }

            input {
                width: 100%;
                padding: 12px;
                border-radius: 10px;
                border: 1px solid #ddd;
                background-color: #f9f9f9;
                transition: all 0.3s ease;
                outline: none;
            }

            input:focus {
                border-color: #3E2723;
            }

            button {
                background-color: #3E2723;
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 10px 15px;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
                margin-top: 20px;
                width: 100%;
            }

            button:hover {
                background-color: #5A3E37;
            }

            .back-link {
                margin-top: 20px;
                text-align: center;
            }

            .back-link a {
                color: #3E2723;
                text-decoration: underline;
                font-weight: 500;
            }
            .mask{
                -webkit-text-security: square;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <div class="left-panel" onclick="location.href='/main.do'">
                디저트 연구소에<br>오신 걸 환영해요!<br>
                /<br>Welcome to the<br>Dessert Lab!
            </div>
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <!-- 아이디, 이름, 번호를 가진 사람이 db에 있으면  -->
            <!-- 문자인증 후 비밀번호 변경 페이지로 이동 -->
            <!-- 그렇지 않으면 '회원정보를 확인해주세요.' 출력 화면이동x -->
            <!-- 비밀번호 수정화면에서 비밀번호 입력 후  -->
            <!-- 회원 비밀번호 변경 - 해시화 해서 저장 -->
            <!-- 비밀번호 변경 요청 시 -->
            <!-- 내가 입력한 비밀번호랑 기존 비밀번호랑 동일하면  -->
            <!-- '비밀번호가 이전과 동일합니다.' 출력 후 업데이트 x (비교는 해시값끼리 비교) -->
            <div class="right-panel">
                <div class="find-box">
                    <div class="find-title">비밀번호 찾기</div>

                    <!-- 인증 전 -->
                    <div v-if="!authFlg">
                        <label>아이디</label>
                        <input v-model="userId" placeholder="아이디를 입력하세요">

                        <label>이름</label>
                        <input v-model="userName" placeholder="이름을 입력하세요">

                        <label>전화번호</label>
                        <input type="tel" class="mask" v-model="phone"  placeholder="-를 제외하고 입력해주세요.">

                        <!-- 여기 밑 세 줄을 문자인증 도입하면 주석 처리 -->
                        <!-- <button @click="fnAuth">인증</button> -->

                        <!-- 문자 인증 도입하기 전에는 밑에 줄 주석처리 여기부터 -->
                        <div v-if="!smsFlg">
                            <template v-if="!sendMessageFlg">
                                <button @click="fnSendSms">인증번호 전송</button>
                            </template>
                            <template v-else>
                                <label>문자인증</label>
                                <input v-model="inputNum" :placeholder="timer">
                                <button @click="fnSmsAuth">문자인증</button>
                            </template>
                        </div>
                        <div v-else>
                            <button @click="fnAuth">사용자인증</button>
                        </div>
                    </div>
                    <!-- 여기까지 -->

                    <!-- 인증 후 -->
                    <div v-else>
                        <label>새 비밀번호</label>
                        <input type="password" v-model="userPass" placeholder="영문, 숫자, 특수기호 조합 8자리 이상">

                        <label>비밀번호 확인</label>
                        <input type="password" v-model="userPass2" placeholder="비밀번호를 다시 입력하세요">

                        <button @click="fnChangePwd">비밀번호 수정</button>
                    </div>
                </div>

                <div class="back-link">
                    <a href="/user/login.do">로그인으로 돌아가기</a>
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
                    ranStr: "", //문자 인증 번호
                    smsTimeOverFlg: false //문자 인증 시간초과 여부
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
                            // console.log(data);
                            if (data.result == "success") {
                                alert(data.msg);
                                location.href = "/main.do";
                            } else {
                                alert(data.msg);
                            }
                        }
                    });
                },
                fnSendSms: function () {
                    let self = this;
                    if (self.phone.length != 11) {
                        alert("휴대폰 형식이 맞지 않습니다.");
                        return;
                    }
                    let param = {
                        phone: self.phone
                    };
                    $.ajax({
                        url: "/send-one",
                        dataType: "json",
                        type: "POST",
                        data: JSON.stringify(param), //에러 잡으려고 수정함
                        contentType: "application/json", //에러 잡으려고 추가함
                        success: function (data) {
                            // console.log(data);
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
                                self.smsTimeOverFlg = true;
                                alert("시간이 만료되었습니다.");
                            } else if(!self.smsFlg){
                                let min = parseInt(self.count / 60);
                                let sec = self.count % 60;
                                min = min < 10 ? "0" + min : min;
                                sec = sec < 10 ? "0" + sec : sec;
                                self.timer = min + " : " + sec;

                                self.count--;
                            } else {
                                clearInterval(interval);
                            }
                        }, 1000);
                },
                fnSmsAuth: function () {
                    let self = this;
                    if (!self.sendMessageFlg) {
                        alert("문자 인증을 진행해주세요.");
                        return;
                    }

                    if (self.smsTimeOverFlg) {
                        alert("문자 인증 시간이 초과 되었습니다.");
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