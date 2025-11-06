<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>멤버십관리</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <link rel="stylesheet" href="/css/admin-style.css">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
      /* ===== 관리자 테이블 공통 스타일 ===== */
table {
    width: 100%;
    border-collapse: collapse;
    font-family: 'Arial', sans-serif;
    margin-top: 10px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

th, td {
    padding: 10px 15px;
    text-align: center;
    border-bottom: 1px solid #ddd;
}

th {
    background-color: #3E2723; /* ESPRESSO 색상 */
    color: #FFEDAC; /* BUTTER 색상 */
    font-weight: bold;
}

tr:nth-child(even) {
    background-color: #f9f9f9;
}

tr:hover {
    background-color: #F4C9D6; /* PEONY 색상 */
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

        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->

            <!--관리자 마이 페이지의 컨데너 입니다-->
            <div class="mainPageContainer">

                <!--외쪽측 네이버바-->
                <div class="navBar">
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
                <div class="membership">
                    <!--멤버십 리스트-->
                    <div>
                        <!--구역이름-->
                        <div>
                            멤버십 관리
                        </div>
                        <!--아이콘-->
                        <div></div>
                        <!--선택사항-->
                        <div>
                            <select v-model="pageSize" @change="fnMembershipList">
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                            </select>
                            <input type="text" v-model="keyWord">
                            <button @click="fnMembershipList">사용자 아이디로 검색</button>
                        </div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>멤버십 고유 아이디</th>
                                <th>판매자 소유 유저 아이디</th>
                                <th>등급</th>
                                <th>가입일</th>
                                <th>멤버십 상태</th>
                                <th>월정액 요금</th>
                                <th>종료일</th>
                            </tr>
                            <tr v-for="membership in membershipList">
                                <td>{{membership.membershipId}}</td>
                                <td>{{membership.userId}}</td>
                                <td>
                                    <span v-if="membership.membershipLevel==='S'">SILVER</span>
                                    <span v-if="membership.membershipLevel==='G'">GOLD</span>
                                </td>
                                <td>{{membership.joinDate}}</td>
                                <td>{{membership.membershipStatus}}</td>
                                <td>{{membership.monthlyFee}}</td>
                                <td>{{membership.expirationDate}}</td>
                            </tr>
                        </table>
                    </div>

                    <div class="paging">
                        <span v-if="page>1">
                            <button @click="fnPre()">◀</button>
                        </span>
                        <a href="javascript:;" v-for="num in pageRangeList" @click="fnChange(num)"
                            :class="{active:page == num}">{{num}}</a>
                        <span v-if="page!=pageNum"><button @click="fnNext()">▶</button></span>
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
                    currentMenu: "membership",

                    membershipList: [],
                    sessionId: "${sessionId}",

                    //검색

                    keyWord: "",

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
                fnMembershipList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/admembership/membershiplist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.membershipList = data.membershipList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();
                        }
                    });
                },



                //수정 페이지로 이동
                fnEdit: function (membershipId) {
                    pageChange("/admin/membershipedit.do", { membershipId: membershipId });
                },



                //페이징 메소드:모든 수량의 페이징을 처리
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
                    self.fnMembershipList();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                    }
                    self.fnMembershipList();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                    }
                    self.fnMembershipList();

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

                fnMonthlyFee: function () {
                    location.href = "/admin/monthlyfee.do";
                },

                fnQandA: function () {
                    location.href = "/admin/boardManage.do";
                },

                fnLogout: function () {
                                     param = {}
                    if (confirm("로그아웃 하시겠습니까?")) {
                        $.ajax({
                            url: "/user/logout.dox", // 로그아웃 url 주소
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert(data.msg);
                                location.href = "/main.do";
                            }
                        });
                    }
                }




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnMembershipList();

            }
        });

        app.mount('#app');
    </script>