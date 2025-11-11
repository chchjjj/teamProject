<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>로그인</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
            body {
                margin: 0;
                font-family: "Pretendard", sans-serif;
                background-color: #ffffff;
            }

            /* 전체 컨테이너 */
            #app {
                display: flex;
                height: 100vh;
            }

            /* 왼쪽 환영 문구 영역 */
            .left-panel {
                flex: 0.75;
                background-color: #3E2723;
                /* 진한 에스프레소 갈색 */
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                color: #FFEDAC;
                /* 밝은 노란색 글씨 */
                font-size: 30px;
                font-weight: 600;
                line-height: 1.8;
                text-align: center;
            }





            /* 오른쪽 로그인 폼 영역 */
            .right-panel {
                flex: 1.25;
                background: linear-gradient(120deg, #FFEDAC, #FFEDAC, #3E2723);
                background-size: 300% 300%;
                animation: gradientMove 8s ease infinite;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                position: relative;
                overflow: hidden;
                 justify-content: flex-start; /* 🔹 상단 정렬로 변경 */
    padding-top: 80px; /* 🔹 위쪽 여백 추가 */
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

            .login-box {
                width: 60%;
                max-width: 400px;
                background-color: #ffffff;
                padding: 40px 35px;
                border-radius: 20px;
                box-shadow: 0 8px 20px rgba(62, 39, 35, 0.1);
                transition: all 0.3s ease;
                text-align: left;
            }

            /* 마우스 올렸을 때 */
            .login-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(62, 39, 35, 0.2);
            }

            .login-title {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 30px;
                color: #3E2723;
            }

            label {
                display: block;
                color: #3E2723;
                font-weight: 500;
                margin-bottom: 5px;
                margin-top: 15px;
            }

            input {
                box-sizing: border-box;
                width: 100%;
                padding: 12px;
                border-radius: 10px;
                border: 1px solid #ddd;
                outline: none;
                background-color: #f5f5f5;
                transition: all 0.3s;
            }

            input:focus {
                border-color: #3E2723;
                /* background-color: #fffbea; */
            }

            .btn-box {
                margin-top: 20px;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }

            button {
                flex: 1;
                padding: 12px;
                border: none;
                border-radius: 10px;
                background-color: #3E2723;
                color: #fff;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
            }

            button:hover {
                background-color: #5A3E37;
            }

            .social-btn {
                background-color: #FFEDAC;
                color: #3E2723;
                font-weight: 600;
            }

            .social-btn:hover {
                background-color: #ffe27a;
            }

            .link-box {
                text-align: center;
                margin-top: 20px;
                font-size: 0.9rem;
                color: #3E2723;
            }

            .link-box a {
                color: #3E2723;
                text-decoration: underline;
                font-weight: 500;
                margin: 0 5px;
            }

            .bottom-links {
                display: flex;
                justify-content: space-between;
                font-size: 0.9rem;
                margin-top: 15px;
            }

            .bottom-links a {
                color: #3E2723;
                text-decoration: none;
            }

            .bottom-links a:hover {
                text-decoration: underline;
            }

            .login-logo {
                text-align: center;
                margin-top: 50px;
                margin-bottom: 25px;
                /* 로그인 박스와의 간격 */
            }

            .login-logo img {
                width: 200px;
                /* 로고 크기 조정 */
                height: auto;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- 왼쪽 영역 -->
            <div class="left-panel" onclick="location.href='/main.do'" style="cursor: pointer;">
                <p>
                    디저트 연구소에<br>오신 걸 환영해요!<br>
                    /<br>
                    Welcome to the
                    <br>Dessert Lab!
                </p>
            </div>

            <!-- 오른쪽 영역 -->
            <div class="right-panel">
                <div class="login-logo">
                    <img src="/img/로고.png" alt="디저트 연구소 로고" onclick="location.href='/main.do'">
                </div>
                <div class="login-box">

                    <div class="login-title">Login</div>
                    <div>
                        <label>아이디</label>
                        <input v-model="userId" @keyup.enter="fnLogin">
                    </div>
                    <div>
                        <label>비밀번호</label>
                        <input type="password" v-model="userPass" @keyup.enter="fnLogin">
                    </div>

                    <!-- <div class="btn-box">
                        <button class="social-btn">카카오 로그인</button>
                        <button class="social-btn">소셜 로그인</button>
                    </div> -->

                    <div class="link-box">
                        디저트 연구소 첫손님이신가요?
                        <a href="/user/join.do">회원가입</a>
                    </div>

                    <div class="btn-box" style="margin-top: 15px;">
                        <button @click="fnLogin">로그인</button>
                    </div>

                    <div class="bottom-links">
                        <a href="/user/findId.do">아이디 찾기</a>
                        <a href="/user/newPwd.do">비밀번호 찾기</a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        userId: "",
                        userPass: ""
                    };
                },
                methods: {
                    fnLogin: function () {
                        let self = this;
                        let param = {
                            userId: self.userId,
                            userPass: self.userPass
                        };
                        $.ajax({
                            url: "/user/login.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert(data.msg);
                                if (data.result == "success") {
                                    location.href = data.url;
                                }
                            }
                        });
                    }
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>