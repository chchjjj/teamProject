<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/admin-style.css">
        <title>사용자정보수정</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                font-family: 'Arial', sans-serif;
                margin-top: 10px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            th,
            td {
                padding: 10px 15px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #3E2723;
                /* ESPRESSO 색상 */
                color: #FFEDAC;
                /* BUTTER 색상 */
                font-weight: bold;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #F4C9D6;
                /* PEONY 색상 */
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            td {
                color: #333;
            }

            select,
            input[type="text"] {
                padding: 5px 8px;
                margin: 5px 0;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            button {
                padding: 6px 12px;
                background-color: #3E2723;
                color: #FFEDAC;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            button:hover {
                background-color: #5D4037;
            }

            /* 페이징 버튼 */
            .paging a,
            .paging button {
                display: inline-block;
                margin: 0 3px;
                padding: 5px 10px;
                text-decoration: none;
                color: #3E2723;
                border: 1px solid #3E2723;
                border-radius: 4px;
                transition: all 0.2s ease;
            }

            .paging a.active,
            .paging button:hover {
                background-color: #3E2723;
                color: #FFEDAC;
                border-color: #3E2723;
            }

            /* userList 안 라디오 버튼 그룹 */
            .userList>div:first-child {
                margin-bottom: 15px;
                /* 위쪽 컨텐츠와 간격 */
                display: flex;
                gap: 20px;
                /* 버튼 간 간격 */
                align-items: center;
            }

            /* 라디오 버튼 숨기고 라벨을 커스텀 스타일로 */
            .userList input[type="radio"] {
                display: none;
            }

            /* 라벨 스타일 */
            .userList label {
                position: relative;
                padding-left: 25px;
                /* 라디오 대체 원 공간 */
                cursor: pointer;
                font-weight: 500;
                color: #3E2723;
                /* ESPRESSO 색상 */
                user-select: none;
                transition: color 0.2s ease;
            }

            /* 라디오 대체 원 */
            .userList label::before {
                content: '';
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 16px;
                height: 16px;
                border: 2px solid #3E2723;
                border-radius: 50%;
                background-color: #fff;
                transition: all 0.2s ease;
            }

            /* 선택된 라디오 표시 */
            .userList input[type="radio"]:checked+label::before {
                background-color: #FFEDAC;
                /* BUTTER 색상 */
                border-color: #3E2723;
            }

            /* 선택된 라벨 글씨 강조 */
            .userList input[type="radio"]:checked+label {
                font-weight: bold;
                color: #3E2723;
            }

            /* 호버 효과 */
            .userList label:hover {
                color: #5D4037;
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
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    <div class="navButton">
                        <div>
                            <button @click="fnBuyerManage()" :class="{active: currentMenu==='buyer'}">구매자 관리</button>
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
                <div class="User">
                    <!--사용자수정 페이지-->
                    <div>
                        <!--구역이름-->
                        <div>
                            <span>{{user.userName }}</span>
                            <span>의 구매내역</span>
                        </div>
                        <!--아이콘-->
                        <div></div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>주문번호</th>
                                <th>상품번호</th>
                                <th>상품명</th>
                                <th>상품 종류</th>
                                <th>배달된 주소</th>
                                <th>주문시간</th>
                                <th>총가격(원)</th>
                            </tr>
                            <tr v-for="order in orderList">
                                <td>{{order.orderId}}</td>
                                <td>{{order.proNo}}</td>
                                <td>{{order.proName}}</td>
                                <td>{{order.proType}}</td>
                                <td>{{order.fullAddress}}</td>
                                <td>{{order.orderDate}}</td>
                                <td>{{formatNumber(order.totalPrice)}}</td>
                            </tr>
                        </table>
                    </div>

                    <!--페이징 구역-->
                    <!--페이징 구역-->
                    <div style="text-align:center; margin-top:25px;">
                        <span v-if="page>1">
                            <button @click="fnPre()"
                                style="padding:6px 12px; border:1px solid #3E2723; background:#fff; color:#3E2723; border-radius:4px; cursor:pointer; transition:all 0.2s ease;">
                                ◀
                            </button>
                        </span>

                        <a href="javascript:;" v-for="num in pageRangeList" @click="fnChange(num)"
                            :class="{active:page == num}"
                            style="display:inline-block; margin:0 4px; padding:6px 12px; border:1px solid #3E2723; border-radius:4px; text-decoration:none; color:#3E2723; transition:all 0.2s ease;"
                            :style="page==num ? 'background-color:#3E2723; color:#FFEDAC; font-weight:bold; box-shadow:0 2px 5px rgba(0,0,0,0.2);' : ''">
                            {{num}}
                        </a>

                        <span v-if="page!=pageNum">
                            <button @click="fnNext()"
                                style="padding:6px 12px; border:1px solid #3E2723; background:#fff; color:#3E2723; border-radius:4px; cursor:pointer; transition:all 0.2s ease;">
                                ▶
                            </button>
                        </span>
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
                    userId: "${userId}",
                    orderList: [],
                    user: {},
                    sessionId: "${sessionId}",

                    currentMenu: "buyer",

                    //paging에 관한 모든 것
                    totalRows: 0,//전체 목록의 총 행수
                    pageRangeList: [],//화면 페이징을 하는 숫자들이 이루어진 리스트
                    pageSize: 10,//뿌렸을 때 한 페이지에 몇 행
                    page: 1,//지금 페이지
                    pageRange: 5,//한 화면에 몇개 페이지 수 나오게 한다
                    pageNum: 0//목록 전체를 가져오려면 합하여 몇 페지

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnUser: function () {
                    let self = this;
                    let param = {
                        userId: self.userId,
                        //paging에 관한 모든 것
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/aduser/order.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.orderList = data.orderList;
                            self.userName = data.orderList[0].userName;
                            self.userList = data.userList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();

                        }
                    });
                },

                fnUserName: function () {
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

                        }
                    });
                },


                //페이징 메소드:화면에 나오는 페이지를 자동적으로 합산 모든 수량의 페이징을 처리
                //이게 걱정할 필요가 없습니다. 원래 실습대로 다하면 자동적으로 계산됩니다.
                fnpageRange: function () {
                    let self = this;
                    self.pageRangeList = [];
                    // 만약에 한화면의 페이지수가 10이라면 0~9 범위에서 나온 값이 floor해서 하나의 숫자가 나오고, 1~10 범위를 만들고 싶다면 0~9에서 나온 값에 +1만 해주면 됩니다.
                    // 화면에 떠있는 시작 페이지
                    let startPage = Math.floor((self.page - 1) / self.pageRange) * self.pageRange + 1;
                    // 화면에 떠있는 마지막 페이지
                    let endPage = Math.min(startPage + self.pageRange - 1, self.pageNum);

                    for (let i = startPage; i <= endPage; i++) {
                        self.pageRangeList.push(i);
                    }
                },

                fnChange: function (num) {
                    let self = this;
                    self.page = num;
                    self.fnUser();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                    }
                    self.fnUser();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                    }
                    self.fnUser();

                },


                fnBack: function () {
                    location.href = "/admin/userlist.do";
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
                                if (data.result == "success") {
                                    alert(data.msg + "! 홈페이지로 이동하겠습니다.");
                                    location.href = "/main.do";
                                } else {
                                    alert("로그아웃하는 도중에 오류가 발생하였습니다.");
                                }

                            }

                        });
                    }
                },

                formatNumber: function (num) {
                    if (!num && num !== 0) return '0';
                    return Number(num).toLocaleString('ko-KR');
                },




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnUser();
                self.fnUserName();

            }
        });

        app.mount('#app');
    </script>