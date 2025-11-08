<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>광고 정보 수정</title>
    <!-- 관리자 스타일시트 -->
    <link rel="stylesheet" href="/css/admin-style.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.js" 
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
            crossorigin="anonymous"></script>
    <!-- Vue.js -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <!-- 페이지 변경 유틸리티 -->
    <script src="/js/page-change.js"></script>

    <style>
        .userEdit{
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);  
        }

        .title{
            font-size:30px;
            font-weight: bold;
            text-align: center;
            color:#3E2723;
            margin-bottom:23px;

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
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    <div class="navButton">
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
                            <button @click="fnMonthlyFee()">판매자 월 정산결과 조회</button>
                        </div>
                        <div>
                            <button @click="fnQandA()">Q&A/리뷰</button>
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
                <div class="userEdit">
                    <!--사용자수정 페이지-->
                    <div>
                        <!--구역이름-->
                        <div class="title">
                            광고 정보 수정
                        </div>
                        <!--아이콘-->
                        <div>

                        </div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>광고 아이디</th>
                                <td>{{ad.adId}}</td>
                            </tr>
                            <tr>
                                <th>광고이름</th>
                                <td><input type="text" v-model="adName"></td>
                            </tr>
                            <tr>
                                <th>시작시간</th>
                                <td>{{ad.startDate}}</td>
                            </tr>
                            <tr>
                                <th>종료시간</th>
                                <td>{{ad.endDate}}</td>
                            </tr>
                            <tr>
                                <th>링크</th>
                                <td>
                                    <input type="text" v-model="linkUrl">
                                </td>  
                            </tr>
                            <tr>
                                <th>클릭당 단가</th>
                                <td>
                                    {{ad.clickUnitCost}}
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div>
                    <button @click="fnEdit(adId)">
                        수정
                    </button>
                </div>

                <div>
                    <button @click="fnEnd(adId)">
                        강제종료
                    </button>
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
                    sessionId: "${sessionId}",
                    adId:"${adId}",
                    ad:{},
                    adName:"",
                    linkUrl:"",
                    flgEnd:false
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnAd: function () {
                let self = this;
                let param = {
                    adId:self.adId
                };
                $.ajax({
                    url: "/adad/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.ad=data.ad;
                        self.adName=data.ad.adName;
                        self.clickUnitCost=data.ad.clickUnitCost;
                        self.linkUrl=data.ad.linkUrl
                        
                    }
                });
            },
            fnEdit: function () {
                let self = this;
                let param = {
                    ad:self.ad,
                    adId:self.adId,
                    adName:self.adName,
                    linkUrl:self.linkUrl,
                    flgEnd:self.flgEnd
                };
                $.ajax({
                    url: "/adad/update.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("수정되었습니다.");
                        self.fnBack();
                    }
                });
            },

            fnEnd: function () {
                let self = this;
                self.flgEnd=true;
                let param = {
                    ad:self.ad,
                    adId:self.adId,
                    adName:self.adName,
                    linkUrl:self.linkUrl,
                    flgEnd:self.flgEnd
                };
                $.ajax({
                    url: "/adad/update.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("강제 종료되었습니다.");
                        self.fnBack();
                    }
                });
            },

            fnBack:function(){
                location.href="/admin/ad.do";
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

                fnMonthlyFee: function () {
                    location.href = "/admin/monthlyfee.do";
                },

                fnQandA: function () {
                    location.href = "/admin/boardManage.do";
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
                self.fnAd();

            }
        });

        app.mount('#app');
    </script>