<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
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
                            <button @click="fnAdminMain()">대시보드</button>
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
                            사용자 정보 수정
                        </div>
                        <!--아이콘-->
                        <div></div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>가게 번호</th>
                                <td><input type="text" v-model="storeId" readonly></td>
                            </tr>
                            <tr>
                                <th>가게 이름</th>
                                <td><input type="text" v-model="storeName"></td>
                            </tr>
                            <tr>
                                <th>소유자 유저 아이디</th>
                                <td><input type="text" v-model="userId" readonly></td>
                            </tr>
                            <tr>
                                <th>사업자 번호</th>
                                <td><input type="text" v-model="businessNo" readonly></td>
                            </tr>
                            <tr>
                                <th>가게 주소</th>
                                <td><input type="text" v-model="storeAddr"></td>
                            </tr>
                            <tr>
                                <th>입점 승인여부</th>
                                <td><input type="text" v-model="storePass"></td>
                            </tr>
                            <tr>
                                <th>가입일자</th>
                                <td><input type="text" v-model="joinCdate" readonly></td>
                            </tr>
                            <tr>
                                <th>입점거절 사유</th>
                                <td><input type="text" v-model="rejectReason"></td>  
                            </tr>
                            <tr>
                                <th>맴버십 가입 여부 </th>  
                                <td><input type="text" v-model="membership"></td>  
                            </tr>
                            <tr>
                                <th>가게승인 일자</th>  
                                <td><input type="text" v-model="regDate" readonly></td>  
                            </tr>
                        </table>
                    </div>
                </div>

                <div>
                    <button @click="fnEdit()">
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
                    storeId:"${storeId}",
                    seller:{},
                    storeName:"",
                    userId:"",
                    businessNo:"",
                    storeAddr:"",
                    storePass:"",
                    joinCdate:"",
                    rejectReason:"",
                    membership:"",
                    regDate:""   

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnSeller: function () {
                let self = this;
                let param = {
                    storeId:self.storeId
                };
                $.ajax({
                    url: "/adseller/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.seller=data.seller;
                        self.storeId=data.seller.storeId;
                        self.storeName=data.seller.storeName;
                        self.userId=data.seller.userId;
                        self.businessNo=data.seller.businessNo;
                        self.storeAddr=data.seller.storeAddr;
                        self.storePass=data.seller.storePass;
                        self.joinCdate=data.seller.joinCdate;
                        self.rejectReason=data.seller.rejectReason;
                        self.membership=data.seller.membership;
                        self.regDate=data.seller.regDate;
                    }
                });
            },
            fnEdit: function () {
                let self = this;
                let param = {
                    storeId:self.storeId,
                    storeName:self.storeName,
                    storeAddr:self.storeAddr,
                    storePass:self.storePass,
                    rejectReason:self.rejectReason,
                    membership:self.membership  
                };
                $.ajax({
                    url: "/adseller/update.dox",
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
                location.href="/admin/sellerlist.do";
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
                self.fnSeller();

            }
        });

        app.mount('#app');
    </script>