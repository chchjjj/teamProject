<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>회원가입</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            /* ===== 기본 세팅 ===== */


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
                justify-content: flex-start;
                align-items: center;
                padding-top: 80px;
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

            /* ===== 회원가입 박스 ===== */
            .join-box {
                width: 60%;
                max-width: 550px;
                background-color: #ffffff;
                padding: 30px 30px;
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(62, 39, 35, 0.1);
                transition: all 0.3s ease;
            }

            .join-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(62, 39, 35, 0.2);
            }

            .join-title {
                font-size: 2rem;
                font-weight: 700;
                color: #3E2723;
                text-align: center;
                margin-bottom: 25px;
            }

            label {
                display: block;
                color: #3E2723;
                font-weight: 500;
                margin-top: 15px;
                margin-bottom: 5px;
            }

            input {
                width: 100%;
                padding: 12px;
                border-radius: 10px;
                border: 1px solid #ddd;
                outline: none;
                background-color: #f9f9f9;
                transition: all 0.3s ease;
            }

            input:focus {
                border-color: #3E2723;
            }

            .small-input {
                width: 80px;
                display: inline-block;
                text-align: center;
            }

            button {
                background-color: #3E2723;
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 10px 15px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.3s;
            }

            button:hover {
                background-color: #5A3E37;
            }

            .btn-line {
                margin-top: 20px;
                display: flex;
                justify-content: center;
                gap: 10px;
            }

            .addr-box,
            .phone-box {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .addr-box input {
                flex: 1;
                padding: 12px;
                border-radius: 10px;
                border: 1px solid #ddd;
                background-color: #f9f9f9;
                transition: all 0.3s ease;
            }

            .info-text {
                font-size: 0.9rem;
                color: #5A3E37;
                margin-top: 10px;
            }

            .addr-box button {
                height: 45px;
                width: 100px;
                min-width: 90px;
                white-space: nowrap;
                /* 줄바꿈 방지 */
                background-color: #3E2723;
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 10px 0;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
            }

            .addr-box button:hover {
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

            .inputNum{
                width: 100px;
            }
            .mask{
                -webkit-text-security: square;
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
                <div class="join-box">
                    <div class="join-title">회원가입</div>

                    <label>아이디</label>
                    <div class="addr-box">
                        <input v-if="!userIdFlg" v-model="userId" placeholder="아이디 입력">
                        <input v-else v-model="userId" disabled>
                        <button @click="fnCheck">중복체크</button>
                    </div>

                    <label>비밀번호</label>
                    <input type="password" v-model="userPass" placeholder="영문, 숫자, 특수기호 포함 8자리 이상">

                    <label>비밀번호 확인</label>
                    <input type="password" v-model="userPass2" placeholder="비밀번호 재입력">

                    <label>성함</label>
                    <input v-model="userName" placeholder="이름을 입력하세요">

                    <label>이메일</label>
                    <input v-model="email" placeholder="example@dessertlab.com">

                    <label>주소</label>
                    <div class="addr-box">
                        <input v-model="userAddr" disabled placeholder="주소를 검색하세요">
                        <button @click="fnAddr">주소검색</button>
                    </div>

                    <label>휴대폰 번호</label>
                    <div class="phone-box">
                        <input type="tel" class="small-input" v-model="phone1" maxlength="3"> -
                        <input type="tel" class="mask small-input" v-model="phone2" maxlength="4"> -
                        <input type="tel" class="mask small-input" v-model="phone3" maxlength="4">
                        <template v-if="!sendMessageFlg">
                            <button @click="fnSendSms">인증번호 받기</button>
                        </template>
                        <template v-else>
                            <input v-model="inputNum" :placeholder="timer" class="inputNum">
                            <button @click="fnSmsAuth">인증</button>
                        </template>
                    </div>

                    <div class="btn-line">
                        <button @click="fnJoin">회원가입</button>
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
        function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
            // console.log(roadFullAddr);
            // console.log(addrDetail);
            // console.log(zipNo);

            window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
        }
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    userId: "",
                    userPass: "",
                    userPass2: "",
                    userAddr: "",
                    userName: "",
                    email: "",
                    phone1: "",
                    phone2: "",
                    phone3: "",
                    userIdFlg: false, //아이디 중복 체크 유무
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
                fnCheck: function () {
                    let self = this;
                    if (self.userId.length < 5) {
                        alert("아이디는 5글자 이상이어야 합니다.");
                        return;
                    }
                    let param = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/user/check.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "true") {
                                alert("이미 사용중인 아이디 입니다.");
                            }
                            else {
                                alert("사용 가능한 아이디 입니다.");
                                self.userIdFlg = true;
                            }
                        }
                    });
                },
                fnAddr: function () {
                    //두 번째 인자가 팝업창의 이름
                    window.open("/user/addr.do", "addr", "width=500, height=500, top=100, left=100");
                },
                fnResult: function (roadFullAddr, addrDetail, zipNo) {
                    let self = this;
                    self.userAddr = roadFullAddr;
                },
                fnSendSms: function () {
                    let self = this;
                    let phone = self.phone1.trim() + self.phone2.trim() + self.phone3.trim();
                    // console.log(phone);
                    if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                        alert("휴대폰 형식이 맞지 않습니다.");
                        return;
                    }
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
                fnJoin: function () {
                    let self = this;
                    let regPassword = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,500}$/; //비밀번호 정규식 (영문 숫자 특수기호 조합 8자리 이상 500자리 이하)
                    let regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; // 이메일 정규식
                    let phone = self.phone1 + "-" + self.phone2 + "-" + self.phone3;

                    if (self.userId.length < 5) {
                        alert("아이디는 5글자 이상이어야 합니다.");
                        return;
                    }

                    if (!self.userIdFlg) {
                        alert("아이디 중복 체크를 진행해주세요.");
                        return;
                    }

                    if (!regPassword.test(self.userPass)) {
                        alert('비밀번호 형식에 따라 정확히 입력해주세요');
                        return;
                    }

                    if (self.userPass != self.userPass2) {
                        alert("비밀번호를 다시 확인해주세요.");
                        return;
                    }

                    if (self.userName == "") {
                        alert("성함이 있어야 합니다.");
                        return;
                    }

                    if (!regEmail.test(self.email)) {
                        alert('이메일 형식에 따라 정확히 입력해주세요');
                        return;
                    }

                    if (self.userAddr == "") {
                        alert("주소가 있어야 합니다.");
                        return;
                    }

                    if (self.phone1.length != 3 || self.phone2.length != 4 || self.phone3.length != 4) {
                        alert("휴대폰 형식이 맞지 않습니다.");
                        return;
                    }

                    //문자 인증이 완료되지 않으면 
                    //회원가입 불가능(안내문구 출력)
                    //최종본에서 주석 해제할 것
                    if(!self.smsFlg){
                        alert("문자 인증을 진행해주세요.");
                        return;
                    }

                    let param = {
                        userId: self.userId,
                        userPass: self.userPass,
                        userName: self.userName,
                        userAddr: self.userAddr,
                        phone: phone,
                        email: self.email
                    };

                    $.ajax({
                        url: "/user/join.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("회원가입 완료");
                                location.href = "/user/login.do";
                            }
                            else {
                                alert("오류가 발생했습니다.");
                            }


                        }
                    });
                },
                fnSmsAuth: function () {
                    let self = this;
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

                //스크립트에서 vue 내부의 데이터 접근
                window.vueObj = this;
            }
        });

        app.mount('#app');
    </script>