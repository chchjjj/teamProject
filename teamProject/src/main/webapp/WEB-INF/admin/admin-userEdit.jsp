<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>사용자관리</title>
        <!-- 관리자 스타일시트 -->
        <link rel="stylesheet" href="/css/admin-style.css">
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
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            .title {
                font-size: 30px;
                font-weight: bold;
                text-align: center;
                color: #3E2723;
                margin-bottom: 23px;

            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->

            <!--관리자 마이 페이지의 컨데너 입니다-->
            <div class="mainPageContainer">

                <!--외쪽측 네이버바-->
                <div class="navBar">
                    <!-- Logo -->
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    <div class="navButton">
                        <div>
                            <button @click="fnBuyerManage()" :class="{active: currentMenu==='buyer'}">전체 유저 관리</button>
                        </div>
                        <div>
                            <button @click="fnSellerManage()" :class="{active: currentMenu==='seller'}">판매자관리</button>
                        </div>
                        <div>
                            <button @click="fnSalesManage()" :class="{active: currentMenu==='money'}">매출관리</button>
                        </div>
                        <div>
                            <button @click="fnAdRequest()" :class="{active: currentMenu==='ad'}">광고관리</button>
                        </div>
                        <div>
                            <button @click="fnMembership()" :class="{active: currentMenu==='membership'}">맴버쉽관리</button>
                        </div>
                        <div>
                            <button @click="fnMonthlyFee()" :class="{active: currentMenu==='month'}">판매자 월 정산결과
                                조회</button>
                        </div>
                        <div>
                            <button @click="fnQandA()" :class="{active: currentMenu==='qna'}">Q&A</button>
                        </div>
                    </div>

                    <!--logout button-->
                    <div class="logOut">
                        <div>
                            <button @click="fnLogout()">Logout</button>
                        </div>
                    </div>

                </div>

                <!--메인 페이지 바디 내용-->
                <div class="userList">
                    <!--사용자수정 페이지-->
                    <div>
                        <!--구역이름-->
                        <div class="title">
                            사용자 정보 수정
                        </div>
                        <!--아이콘-->
                        <div>

                        </div>
                        <!--태이블-->
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
                            <tr>
                                <th>권한</th>
                                <td>
                                    <span v-if="user.role==='S'">판매자</span>
                                    <span v-if="user.role==='C'">구매자</span>
                                    <span v-if="user.role==='A'">관리자</span>
                                </td>
                            </tr>
                        </table>

                    </div>
                    <div>
                        <button @click="fnEdit(userId)">
                            수정
                        </button>
                    </div>
                </div>



            </div>

        </div>
    </body>

    </html>

    <script>
        function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
           

            window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
        }
        const app = Vue.createApp({
            
            data() {
                return {
                    // 변수 - (key : value)
                    userId: "${userId}",
                    user: {},
                    userName: "",
                    phone: "",
                    email: "",
                    userAddr: "",
                    userStatus: "",
                    joinCdate: "",
                    role: "",
                    storePass: "",
                    sessionId: "${sessionId}",

                };
            },
            methods: {
                 fnAddr() {
                    window.open("/user/addr.do", "addr", "width=500,height=500,top=100,left=100");
                },
                // 함수(메소드) - (key : function())
                fnUser: function () {
                    let self = this;
                    let param = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/aduser/view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.user = data.user;
                            self.userId = data.user.userId;
                            self.userName = data.user.userName;
                            self.phone = data.user.phone;
                            self.email = data.user.email;
                            self.userAddr = data.user.userAddr;
                            self.userStatus = data.user.userStatus;
                            self.joinCdate = data.user.joinCdate;
                            self.role = data.user.role;

                        }
                    });
                },
                fnEdit: function () {
                    let self = this;
                    let param = {
                        user: self.user,
                        userId: self.userId,
                        userName: self.userName,
                        phone: self.phone,
                        email: self.email,
                        userAddr: self.userAddr,
                        userStatus: self.userStatus,
                        role: self.role,
                        storePass: self.storePass
                    };
                    $.ajax({
                        url: "/aduser/update.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert("수정되었습니다.");
                            self.fnBack();
                        }
                    });
                },

                fnBack: function () {
                    location.href = "/admin/userlist.do";
                },

                fnResult(roadFullAddr) {
                    this.userAddr = roadFullAddr;
                },


                fnAdminMain: function () {
                    location.href = "/admin/main.do";
                },


                fnBuyerManage: function () {
                    location.href = "/admin/userlist.do";
                },

                fnSellerManage: function () {
                    location.href = "/admin/sellerlist.do";
                },


                fnSalesManage: function () {
                    location.href = "/admin/chart.do";
                },

                fnAdRequest: function () {
                    location.href = "/admin/ad.do";
                },

                fnMembership: function () {
                    location.href = "/admin/membership.do";
                },

                fnQandA: function () {
                    location.href = "/admin/boardManage.do";
                },
                fnMonthlyFee: function () {
                    location.href = "/admin/monthlyfee.do";
                },

                fnLogout: function () {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        let param = {};
                        $.ajax({
                            url: "/user/logout.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if(data.result=="success"){
                                    alert(data.msg+"! 홈페이지로 이동하겠습니다.");
                                    location.href = "/main.do";
                                }else{
                                    alert("로그아웃하는 도중에 오류가 발생하였습니다.");
                                }
                                    
                            }
                            
                        });
                    }
                },




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnUser();
                window.vueObj = this;

            }
        });

        app.mount('#app');
    </script>