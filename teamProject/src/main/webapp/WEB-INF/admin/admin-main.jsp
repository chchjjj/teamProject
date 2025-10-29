
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
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
                        <button>대시보드</button>
                    </div>
                    <div>
                        <button @click="fnBuyerManage()">구매자관리</button>
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
            <div class="userAdmin">
                <!--구매자관리-->
                <div>
                    <!--구역이름-->
                    <div>
                        구매자관리
                    </div>
                    <!--아이콘-->
                    <div></div>
                    <!--태이블-->
                    <table>
                        <tr>
                            <th>아이디</th>
                            <th>닉네임/</th>
                            <th>연락처</th>
                            <th>등록일자</th>
                        </tr>
                        <tr v-for="user in userList">
                            <td>{{user.userId}}</td>
                            <td>{{user.userName}}</td>
                            <td>{{user.phone}}</td>
                            <td>{{user.joinCdate}}</td>
                        </tr>
                    </table>
                </div>

                <!--판매자관리-->
                <div>
                    <!--구역이름-->
                    <div>
                        판매자관리
                    </div>
                    <!--아이콘-->
                    <div></div>
                    <!--태이블-->
                    <table>
                        <tr>
                            <th>아이디</th>
                            <th>가게이름</th>
                            <th>닉네임</th>
                            <th>사업자번호</th>
                            <th>승인여부</th>
                        </tr>
                        <tr>
                            <td></td>
                        </tr>
                    </table>
                </div> 
                

                <!--매출관리-->
                <div>
                    <!--구역이름-->
                    <div>
                        판매자관리
                    </div>
                    <!--아이콘-->
                    <div></div>
                    <!--차트-->
                    
                    </table>
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
                userList:[],
                sellerList:[]

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnUserList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/dashboard/userList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.userList=data.userList;

                    }
                });
            },

            fnSellerList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/dashboard/userList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.sellerList=data.sellerList;
                    }
                });
            },

            fnBuyerManage:function(){
                location.href="/admin/userlist.do";
            },

            fnSellerManage:function(){
                location.href="/admin/sellerlist.do";
            },


            fnSalesManage:function(){
                location.href="/admin/chart.do";
            },

            fnAdRequest:function(){
                location.href="/admin/ad.do";
            },

            fnMembership:function(){
                location.href="/admin/membership.do";
            },

             fnQandA:function(){
                location.href="/admin/boardManage.do";
            },

            fnLogout:function(){

            }



        }, // methods
        
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnUserList();
            self.fnSellerList();
        }
    });

    app.mount('#app');
</script>


