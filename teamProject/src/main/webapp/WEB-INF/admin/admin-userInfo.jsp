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

                <!--메인 페이지 바디 내용-->
                <div class="User">
                    <!--사용자수정 페이지-->
                    <div>
                        <!--구역이름-->
                        <div>
                            {{order.user_name}}
                        </div>
                        <!--아이콘-->
                        <div></div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>상품번호</th>
                                <td>{{order.proNo}}</td>
                            </tr>
                            <tr>
                                <th>상품명</th>
                                <td>{{order.proName}}</td>
                            </tr>
                            <tr>
                                <th>상품 종류</th>
                                <td>{{order.proType}}></td>
                            </tr>
                            <tr>
                                <th>배달된 주소</th>
                                <td>{{order.fullAddress}}</td>
                            </tr>
                            <tr>
                                <th>총가격</th>
                                <td>{{order.totalPrice}}</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div>
                    <button @click="fnEdit(userId)">
                        수정
                    </button>
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
                    userId:"${userId}",
                    user:{},
                    userName:"",
                    phone:"",
                    email:"",
                    userAddr:"",
                    userStatus:"",
                    joinCdate:"",
                    role:"",   

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
                        self.order=data.order;
                        self.orderId=data.order.orderId;
                        self.orderName=data.order.orderName;
                        self.phone=data.order.phone;
                        self.email=data.order.email;
                        self.orderAddr=data.order.orderAddr;
                        self.orderStatus=data.order.orderStatus;
                        self.joinCdate=data.order.joinCdate;
                        self.role=data.order.role;
                        
                    }
                });
            },
            fnEdit: function () {
                let self = this;
                let param = {
                    order:self.user,
                    userId:self.userId,
                    userName:self.userName,
                    phone:self.phone,
                    email:self.email,
                    userAddr:self.userAddr,
                    userStatus:self.userStatus,
                    role:self.role, 
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