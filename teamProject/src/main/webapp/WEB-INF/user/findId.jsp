<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>아이디 찾기</title>
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

            /* ===== 왼쪽 패널 ===== */
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

            /* ===== 오른쪽 패널 ===== */
            .right-panel {
                flex: 1.25;
                background: linear-gradient(120deg, #FFEDAC, #FFEDAC, #3E2723);
                background-size: 300% 300%;
                animation: gradientMove 8s ease infinite;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                align-items: center;
                padding-top: 200px;
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

            /* ===== 아이디 찾기 박스 ===== */
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

            .phone-box {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .small-input {
                width: 70px;
                text-align: center;
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
            }

            button:hover {
                background-color: #5A3E37;
            }

            .cert-box {
                display: flex;
                align-items: center;
                gap: 10px;
                
            }

            .result-text {
                font-size: 1.1rem;
                color: #3E2723;
                text-align: center;
                font-weight: 500;
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
            .inputNum{
                width: 100px;
            }
            
        </style>
    </head>

    <body>
        <div id="app">
            <!-- 왼쪽 영역 -->
            <div class="left-panel" onclick="location.href='/main.do'">
                디저트 연구소에<br>오신 걸 환영해요!<br>
                /<br>Welcome to the<br>Dessert Lab!
            </div>

            <!-- 오른쪽 영역 -->
            <div class="right-panel">
                <div class="find-box">
                    <div class="find-title">아이디 찾기</div>

                    <label>성함</label>
                    <input v-model="userName" placeholder="이름을 입력하세요">

                    <label>휴대폰 번호</label>
                    <div class="phone-box">
                        <input class="small-input" v-model="phone1" maxlength="3"> -
                        <input class="small-input" v-model="phone2" maxlength="4"> -
                        <input class="small-input" v-model="phone3" maxlength="4">
                        <!-- 문자 인증 실제 적용 버전 여기부터 -->
                        <div v-if="!smsFlg">
                    
                            <template v-if="!sendMessageFlg">
                                <div class="cert-box">
                                    <button @click="fnSendSms">문자인증</button>
                                </div>
                            </template>
                            <template v-else>
                                <div class="cert-box">
                                    <input v-model="inputNum" :placeholder="timer" class="inputNum">
                                    <button @click="fnSmsAuth">확인</button>
                                </div>
                            </template>
                        </div>

                        <div v-else class="result-text">
                            <button @click="fnFind">아이디 찾기</button>
                            <div v-if="findResult">{{userName}}님의 아이디는 <b>{{info.userId}}</b> 입니다.</div>
                        </div>
                        <!-- 문자 인증 실제 적용 버전 여기까지 -->
                    </div>  
                    <div class="back-link">
                        <a href="/user/login.do">로그인으로 돌아가기</a>
                    </div>
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
                    info: {},
                    userName: "",
                    phone1: "",
                    phone2: "",
                    phone3: "",
                    inputNum: "", //문자인증 번호
                    sendMessageFlg: false, //문자인증 메세지 전송 여부
                    timer: "",
                    count: 180,
                    smsFlg: false, //문자 인증 유무
                    ranStr: "", //문자 인증 번호
                    smsTimeOverFlg: false, //문자 인증 시간초과 여부

                    findResult: false //최종 찾기 성공 여부
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnSendSms: function () {
                    let self = this;
                    let phone = self.phone1.trim() + self.phone2.trim() + self.phone3.trim();
                    // console.log("self.phone1.length: " + self.phone1.length);
                    // console.log("self.phone2.length: " + self.phone2.length);
                    // console.log("self.phone3.length: " + self.phone3.length);
                     if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                        alert("휴대폰 형식이 맞지 않습니다.");
                        return;
                    }
                    // console.log(phone);
                    let param = {
                        phone: phone
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
                },
                fnFind: function () {
                    let self = this;
                    let phone = self.phone1 + "-" + self.phone2 + "-" + self.phone3;
                    // console.log("self.phone1.length: " + self.phone1.length);
                    // console.log("self.phone2.length: " + self.phone2.length);
                    // console.log("self.phone3.length: " + self.phone3.length);
                     if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                        alert("휴대폰 형식이 맞지 않습니다.");
                        return;
                    }

                    if (self.userName.length < 1) {
                        alert("성함을 적어주세요.");
                        return;
                    }

                    let param = {
                        phone: phone,
                        userName: self.userName
                    };
                    $.ajax({
                        url: "/user/findId.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // console.log(data);
                            self.info = data.info;
                            self.findResult = true;
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