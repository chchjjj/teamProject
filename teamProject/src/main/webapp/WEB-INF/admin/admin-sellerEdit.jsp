<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>판매자정보수정</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/admin-style.css">
    </head>

    <body>
        <div id="app">
            <div class="mainPageContainer">

                <!-- === 왼쪽 네비게이션 바 (변경 금지) === -->
                <div class="navBar">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>

                    <div class="navButton">
                        <div><button @click="fnBuyerManage()">사용자 관리</button></div>
                        <div><button @click="fnSellerManage()">판매자관리</button></div>
                        <div><button @click="fnSalesManage()">매출관리</button></div>
                        <div><button @click="fnAdRequest()">광고관리</button></div>
                        <div><button @click="fnMembership()">맴버쉽관리</button></div>
                        <div><button @click="fnMonthlyFee()">판매자 월 정산결과 조회</button></div>
                        <div><button @click="fnQandA()">Q&A/리뷰</button></div>
                    </div>

                    <div class="logOut">
                        <div><button @click="fnLogout()">Logout</button></div>
                    </div>
                </div>

                <!-- === 메인 컨텐츠 === -->
                <div class="userEdit">
                    <div class="title">판매자 정보 수정</div>

                    <table>
                        <tr>
                            <th>가게 번호</th>
                            <td>{{seller.storeId}}</td>
                        </tr>
                        <tr>
                            <th>가게 이름</th>
                            <td><input type="text" v-model="storeName"></td>
                        </tr>
                        <tr>
                            <th>소유자 유저 아이디</th>
                            <td>{{seller.userId}}</td>
                        </tr>
                        <tr>
                            <th>사업자 번호</th>
                            <td>{{seller.businessNo}}</td>
                        </tr>
                        <tr>
                            <th>가게 주소</th>
                            <td><input type="text" v-model="storeAddr"></td>
                        </tr>
                        <tr>
                            <th>입점 승인여부</th>
                            <td>
                                <select v-model="storePass">
                                    <option value="P">승인</option>
                                    <option value="R">거절</option>
                                    <option value="G">심사 진행 중</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>가입일자</th>
                            <td>{{seller.joinCdate}}</td>
                        </tr>
                        <tr v-if="seller.storePass==='P'||seller.storePass==='G'">
                            <th>입점거절 사유</th>
                            <td><input type="text" v-model="rejectReason"></td>
                        </tr>
                        <tr>
                            <th>맴버십 가입 여부</th>
                            <td v-if="seller.membership==='N'">미가입</td>
                            <td v-if="seller.membership==='Y'">가입</td>
                        </tr>
                        <tr v-if="seller.rejectReason==='P'">
                            <th>가게승인 일자</th>
                            <td><input type="text" v-model="regDate" readonly></td>
                        </tr>
                    </table>

                    <div style="text-align: right;">
                        <button @click="fnEdit()">수정</button>
                        <button @click="fnBack()" style="background-color: #888;">뒤로가기</button>
                    </div>
                </div>
            </div>
        </div>
    </body>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    sessionId: "${sessionId}",
                    storeId:"${storeId}",
                    userId:"${userId}",
                    seller: {},
                    storeName: "",
                    userId: "",
                    businessNo: "",
                    storeAddr: "",
                    storePass: "",
                    joinCdate: "",
                    rejectReason: "",
                    membership: "",
                    regDate: ""
                };
            },
            methods: {
                fnSeller() {
                    let self = this;
                    $.ajax({
                        url: "/adseller/view.dox",
                        dataType: "json",
                        type: "POST",
                        data: { storeId: self.storeId },
                        success(data) {
                            self.seller = data.seller;
                            Object.assign(self, data.seller);
                        }
                    });
                },
                fnEdit() {
                    let self = this;
                    $.ajax({
                        url: "/adseller/update.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            storeId:self.storeId,
                            userId:self.userId,
                            storeName: self.storeName,
                            storeAddr: self.storeAddr,
                            storePass: self.storePass,
                            rejectReason: self.rejectReason,
                            membership: self.membership
                        },
                        success() {
                            alert("수정되었습니다.");
                            self.fnBack();
                        }
                    });
                },
                fnBack() {
                    location.href = "/admin/sellerlist.do";
                },
                fnBuyerManage() { location.href = "/admin/userlist.do"; },
                fnSellerManage() { location.href = "/admin/sellerlist.do"; },
                fnSalesManage() { location.href = "/admin/chart.do"; },
                fnAdRequest() { location.href = "/admin/ad.do"; },
                fnMembership() { location.href = "/admin/membership.do"; },
                fnMonthlyFee() { location.href = "/admin/monthlyfee.do"; },
                fnQandA() { location.href = "/admin/boardManage.do"; },
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
            },
            mounted() {
                this.fnSeller();
            }
        });
        app.mount('#app');
    </script>

    </html>