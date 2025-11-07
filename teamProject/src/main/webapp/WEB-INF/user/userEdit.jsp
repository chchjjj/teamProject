<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>사용자 정보 수정</title>
        <link rel="stylesheet" href="/css/navbar.css">

        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
            rel="stylesheet">

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

        <!-- Vue.js -->
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!-- 페이지 변경 유틸리티 -->
        <script src="/js/page-change.js"></script>

        <style>
            .userEdit {
                margin-left: 270px;
                margin-top: 50px;
                background-color: var(--white);
                border-radius: 14px;
                width: 70%;
                max-width: 900px;
                padding: 50px 60px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            .title {
                font-size: 30px;
                font-weight: 700;
                text-align: center;
                color: var(--espresso);
                margin-bottom: 35px;
                letter-spacing: 1px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                color: #3E2723;
                font-size: 17px;
                background-color: #fffdfc;
                border-radius: 10px;
                overflow: hidden;
            }

            th {
                text-align: left;
                width: 180px;
                padding: 15px 20px;
                background-color: #f7f3f1;
                font-weight: 600;
                border-bottom: 1px solid #e6dcd8;
            }

            td {
                padding: 15px 20px;
                border-bottom: 1px solid #eee;
            }

            input[type="text"],
            select {
                width: 100%;
                padding: 10px 12px;
                font-size: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }

            input[type="text"]:focus,
            select:focus {
                border-color: var(--peony);
                box-shadow: 0 0 4px rgba(244, 201, 214, 0.5);
                outline: none;
            }

            td button {
                background-color: var(--peony);
                color: var(--espresso);
                border: none;
                border-radius: 6px;
                padding: 8px 15px;
                margin-left: 10px;
                margin-top: 15px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            td button:hover {
                background-color: #f0b8ca;
                transform: translateY(-1px);
            }

            /* 修改按钮（卡片左下角） */
            .userEdit .edit-btn {
                position: relative;
                display: inline-block;
                margin-top: 25px;
                background-color: var(--butter);
                color: var(--espresso);
                border: none;
                border-radius: 8px;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .userEdit .edit-btn:hover {
                background-color: #ffeb9e;
                transform: translateY(-2px);
            }

            /* 让外层 div 的布局正常，不漂浮 */
            .userEdit {
                position: relative;
            }

            .userEdit .button-container {
                margin-top: 20px;
                text-align: left;
            }


            @media (max-width: 1024px) {
                .userEdit {
                    width: 85%;
                    padding: 40px;
                    margin-left: 250px;
                }

                th {
                    width: 150px;
                }
            }

            @media (max-width: 768px) {
                .userEdit {
                    width: 90%;
                    margin-left: 0;
                    margin-top: 80px;
                    padding: 30px;
                }

                table {
                    font-size: 15px;
                }

                th {
                    width: 120px;
                }
            }
        </style>
    </head>

    <body>
        <div id="app">
            <div class="mainPageContainer">
                <div class="navBar">
                    <div class="logoArea">
                        <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    </div>
                    <div class="navButton">
                        <button @click="fnOrderHistory()" class="active">주문 내역</button>
                        <button @click="fnWishList()">찜한 상품</button>
                        <button @click="fnChatList()">채팅이력</button>
                        <button @click="fnReview()">내가 쓴 리뷰</button>
                        <button @click="fnQnA()">QnA</button>
                        <button @click="fnUserEdit()">정보수정</button>
                    </div>
                    <div class="logOut">
                        <button @click="fnLogout()">Logout</button>
                    </div>
                </div>

                <div class="userEdit">
                    <div class="title">사용자 정보 수정</div>

                    <table>
                        <tr>
                            <th>아이디</th>
                            <td>{{user.userId}}</td>
                        </tr>
                        <tr>
                            <th>닉네임</th>
                            <td><input type="text" v-model="userName"></td>
                        </tr>
                        <tr>
                            <th>연락처</th>
                            <td><input type="text" v-model="phone"></td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td><input type="text" v-model="email"></td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td><input type="text" v-model="userAddr"><button @click="fnAddr">주소선택</button></td>
                        </tr>
                        <tr>
                            <th>활동탈퇴여부</th>
                            <td>
                                <select v-model="userStatus">
                                    <option value="O">활동</option>
                                    <option value="X">탈퇴</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>가입일자</th>
                            <td>{{user.joinCdate}}</td>
                        </tr>
                    </table>
                    <div class="button-container">
                        <button class="edit-btn" @click="fnEdit(userId)">수정</button>
                    </div>
                </div>


            </div>
        </div>
    </body>

    <script>
        function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
            console.log(roadFullAddr);
            console.log(addrDetail);
            console.log(zipNo);

            window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
        }

        const app = Vue.createApp({
            data() {
                return {
                    userId: "${sessionId}",
                    user: {},
                    userName: "",
                    phone: "",
                    email: "",
                    userAddr: "",
                    userStatus: "",
                    joinCdate: "",
                    role: "",
                    storePass: ""
                };
            },
            methods: {
                fnUser() {
                    const self = this;
                    $.ajax({
                        url: "/user/view.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: self.userId },
                        success(data) {
                            self.user = data.user;
                            Object.assign(self, data.user);
                        }
                    });
                },
                fnEdit() {
                    const self = this;
                    $.ajax({
                        url: "/user/update.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            userId: self.userId,
                            userName: self.userName,
                            phone: self.phone,
                            email: self.email,
                            userAddr: self.userAddr,
                            userStatus:self.userStatus
                        },
                        success() {
                            alert("수정되었습니다.");
                            self.fnBack?.();
                        }
                    });
                },
                fnAddr() {
                    window.open("/user/addr.do", "addr", "width=500,height=500,top=100,left=100");
                },
                fnResult(roadFullAddr) {
                    this.userAddr = roadFullAddr;
                },
                fnHome() { location.href = "/main.do" },
                fnOrderHistory() { location.href = "/user/orderHistory.do"; },
                fnWishList() { location.href = "/product/wishlist.do"; },
                fnChatList() { location.href = "/user/chatList.do"; },
                fnReview() { location.href = "/user/review.do"; },
                fnQnA() { location.href = "/user/qnA.do"; },
                fnUserEdit() { location.href = "/user/userEdit.do"; },
                fnLogout() { location.href = "/logout.do"; }
            },
            mounted() {
                this.fnUser();
                //스크립트에서 vue 내부의 데이터 접근
                window.vueObj = this;
            }
        });

        app.mount('#app');
    </script>

    </html>