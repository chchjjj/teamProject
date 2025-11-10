<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 판매자 월 정산결과 조회 ::</title>
        <link rel="stylesheet" href="/css/admin-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>

        <style>
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

            .info {
                font-size: 14px;
                color: #666;
                margin-bottom: 30px;
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
                            <button @click="fnQandA()" :class="{active: currentMenu==='qna'}">게시글 관리</button>
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
                    <!--사용자list-->
                    <div>
                        <!--구역이름-->
                        <div>
                            판매자 월 정산결과 조회
                        </div>
                        <div class="info">
                            ※ 판매 승인을 받은 판매자 목록만 표시합니다.
                        </div>

                        <div>
                            <select v-model="pageSize" @change="fnSellerList">
                                <option value="10">:: 10개씩 ::</option>
                                <option value="15">:: 15개씩 ::</option>
                                <option value="20">:: 20개씩 ::</option>
                            </select>
                            <select v-model="option">
                                <option value="all">:: 전체 ::</option>
                                <option value="storeId">가게 아이디</option>
                                <option value="storeName">가게 이름</option>
                            </select>
                            <input type="text" v-model="keyWord" @keyup.enter="fnSellerList">
                            <button @click="fnSellerList">검색</button>
                        </div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>
                                    <div><input type="checkbox" @click="fnSelectAll"></div>
                                </th>
                                <th>시간</th>
                                <th>가게아이디</th>
                                <th>가게이름</th>
                                <th>월말정산결과(원)</th>
                            </tr>
                            <tr v-for="seller in sellerList">
                                <td><input type="checkbox" :value="seller.storeId" v-model="selectItem"></td>
                                <td>{{seller.thisMonth}}</td>
                                <td>{{seller.storeId}}</td>
                                <td>{{seller.storeName}}</td>
                                <td>{{formatNumber(seller.storeMonthlyFee)}}</td>
                            </tr>
                        </table>
                    </div>





                    <!--페이징 구역-->
                    <div>
                        <span v-if="page>1">
                            <button @click="fnPre()">◀</button>
                        </span>
                        <a href="javascript:;" v-for="num in pageRangeList" @click="fnChange(num)"
                            :class="{active:page == num}">{{num}}</a>
                        <span v-if="page!=pageNum"><button @click="fnNext()">▶</button></span>
                    </div>


                    <div style="text-align: left; margin-top: 10px;">
                        <button @click="fnRemoveAll">
                            선택 삭제
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
                    sellerList: [],
                    sessionId: "${sessionId}",

                    currentMenu: "month",
                    flgPending: true, // 항상 P만 보도록 기본값 설정

                    //선택
                    selectItem: [],
                    flgAllChecked: false,

                    //검색

                    keyWord: "",
                    option: "all",

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
                fnSellerList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        flgApp: self.flgApp,
                        flgPending: true, // <-- 추가 (판매자 테이블에서 판매승인 받은 애들만 나오게)
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/adseller/sellerlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {                           
                            self.sellerList = data.sellerList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();
                        }
                    });
                },

                //선택
                fnSelectAll: function () {
                    let self = this;
                    self.flgAllChecked = !self.flgAllChecked;
                    if (self.flgAllChecked) {
                        self.selectItem = [];
                        for (let i = 0; i < self.sellerList.length; i++) {
                            self.selectItem.push(self.sellerList[i].storeId);
                        }
                    } else {
                        self.selectItem = [];
                    }


                },

                //전체 삭제
                fnRemoveAll: function () {
                    let self = this;

                    if (self.selectItem.length === 0) {
                        alert("삭제할 항목을 선택해주세요");
                        return;
                    }

                    if (!confirm("선택한 항목을 삭제하시겠습니까?")) {
                        return;
                    }

                    let fList = JSON.stringify(self.selectItem);//把selectItem变成json形式
                    let param = { selectItem: fList };

                    $.ajax({
                        url: "/adseller/deleteall.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("삭제되었습니다");
                                self.page = 1;
                                self.fnSellerList();

                            } else {
                                alert("오류가 발생하였습니다.")
                            }


                        }
                    });
                },

                //수정 페이지로 이동
                fnEdit: function (storeId) {
                    pageChange("/admin/selleredit.do", { storeId: storeId });
                },

                fnSellerInfo: function (storeId) {
                    pageChange("/admin/sellerchart.do", { storeId: storeId });
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
                    self.fnSellerList();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                    }
                    self.fnSellerList();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                    }
                    self.fnSellerList();

                },

                // formatNumber: function (num) {
                //     if (!num && num !== 0) return '0';
                //     return Number(num).toLocaleString('ko-KR');
                // },

                formatNumber: function(num) {
                    if (num === null || num === undefined) return '0';
                    return Number(num).toLocaleString('ko-KR');
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




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnSellerList();

            }
        });

        app.mount('#app');
    </script>