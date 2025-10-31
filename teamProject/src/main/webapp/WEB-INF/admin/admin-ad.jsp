<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>사용자정보수정</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            table,
            tr,
            td,
            th {
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

            <!--관리자 마이 페이지의 컨데너 입니다-->
            <div class="mainPageContainer">

                <!--외쪽측 네이버바-->
                <div class="navBar">
                    <!---->
                    <div class="navButton">
                        <div>
                            <button @click="fnAmdinMain()">대시보드</button>
                        </div>
                        <div>
                            <button @click="fnBuyerManage()">사용자 관리</button>
                        </div>
                        <div>
                            <button @click="fnSellerManage()">판매자관리</button>
                        </div>
                        <div>
                            <button @click="fnSalesManage()">매출관리</button>
                        </div>
                        <div>
                            <button @click="fnAdRequest()">광고관리</button>
                        </div>
                        <div>
                            <button @click="fnMembership()">맴버쉽관리</button>
                        </div>
                        <div>
                            <button @click="fnQandA()">Q&A</button>
                        </div>
                    </div>

                    <!--logout button-->
                    <div class="logOut">
                        <div>
                            <button @click="fnLogout()">Logout</button>
                        </div>
                    </div>
                </div>

                
                <div>
                    <div>광고관리</div>
                    <div>
                        <div>상단광고</div>
                        <div>
                            <button>수정하기</button>
                        </div>
                    </div>
                    <div>
                        <div>하단광고</div>
                        <div>
                            <button>수정하기</button>
                        </div>
                    </div>
                    <div>
                        <div>외쪽광고</div>
                        <div>
                            <button>수정하기</button>
                        </div>
                    </div>
                    <div>
                        <div>오른쪽광고</div>
                        <div>
                            <button>수정하기</button>
                        </div>
                    </div>
                </div>

                <div>
                    <img :src="currentImage" alt="상품 이미지">
                    <span v-else>광고 이미지</span>
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
                    

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnUser: function () {
                let self = this;
                let param = {
                    userId:self.userId
                };
                $.ajax({
                    url: "/aduser/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.user=data.user;
                        self.userId=data.user.userId;
                        self.userName=data.user.userName;
                        self.phone=data.user.phone;
                        self.email=data.user.email;
                        self.userAddr=data.user.userAddr;
                        self.userStatus=data.user.userStatus;
                        self.joinCdate=data.user.joinCdate;
                        self.role=data.user.role;
                        
                    }
                });
            },
            fnEdit: function () {
                let self = this;
                let param = {
                    user:self.user,
                    userId:self.userId,
                    userName:self.userName,
                    phone:self.phone,
                    email:self.email,
                    userAddr:self.userAddr,
                    userStatus:self.userStatus,
                    role:self.role, 
                    storePass:self.storePass
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

            fnBack:function(){
                location.href="/admin/userlist.do";
            },


                

                fnAdminMain:function(){
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

                fnLogout: function () {

                }




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnUser();

            }
        });

        app.mount('#app');
    </script>