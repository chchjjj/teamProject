<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>광고관리</title>
        <link rel="stylesheet" href="/css/admin-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            /* 페이징 버튼 CSS */
            .paging {
                margin-top: 20px;
                text-align: center;
                font-family: Arial, sans-serif;
            }

            .paging button {
                background-color: #3E2723;
                /* ESPRESSO 색상 */
                color: #FFEDAC;
                /* 글자 색상 */
                border: none;
                padding: 5px 10px;
                margin: 0 3px;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .paging button:hover {
                background-color: #5D4037;
                /* hover 시 조금 밝게 */
            }

            .paging a {
                display: inline-block;
                padding: 5px 10px;
                margin: 0 2px;
                border-radius: 5px;
                text-decoration: none;
                color: #3E2723;
                /* ESPRESSO */
                background-color: #FFEDAC;
                /* BUTTER 배경 */
                font-weight: bold;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .paging a:hover {
                background-color: #F4C9D6;
                /* PEONY 색상으로 hover */
                color: #3E2723;
            }

            .paging a.active {
                background-color: #3E2723;
                /* 선택된 페이지 */
                color: #FFEDAC;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- 관리자 페이지 컨테이너 -->
            <div class="mainPageContainer">

                <!-- 왼쪽 네비게이션 바 -->
                <div class="navBar">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    <div class="navButton">
                        <div><button @click="fnBuyerManage()" :class="{active: currentMenu==='buyer'}">구매자 관리</button>
                        </div>
                        <div><button @click="fnSellerManage()" :class="{active: currentMenu==='seller'}">판매자 관리</button>
                        </div>
                        <div><button @click="fnSalesManage()" :class="{active: currentMenu==='money'}">매출관리</button>
                        </div>
                        <div><button @click="fnAdRequest()" :class="{active: currentMenu==='ad'}">광고관리</button></div>
                        <div><button @click="fnMembership()"
                                :class="{active: currentMenu==='membership'}">맴버쉽관리</button></div>
                        <div><button @click="fnMonthlyFee()" :class="{active: currentMenu==='month'}">판매자 월 정산결과
                                조회</button></div>
                        <div><button @click="fnQandA()" :class="{active: currentMenu==='qna'}">Q&A</button></div>
                    </div>
                    <div class="logOut">
                        <button @click="fnLogout()">Logout</button>
                    </div>
                </div>

                <!-- 광고 관리 영역 -->
                <div class="adManagement">
                    <h2>광고관리</h2>

                    <!-- 광고 추가 폼 -->
                    <div class="adAdd">
                        <h3>광고 추가</h3>
                        <table>
                            <tr>
                                <th>광고이름</th>
                                <th>링크</th>
                                <th>클릭당 비용(원)</th>
                            </tr>
                            <tr>
                                <td><input type="text" v-model="adName"></td>
                                <td><input type="text" v-model="urlLink"></td>
                                <td><input type="text" v-model="clickUnitCost"></td>
                            </tr>
                        </table>
                        <button @click="fnAdAdd()" style="margin-top:10px;">추가</button>
                    </div>

                    <!-- 광고 리스트 -->
                    <div class="adList" style="margin-top:20px;">
                        <h3>광고 리스트</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>광고번호</th>
                                    <th>광고이름</th>
                                    <th>시작시간</th>
                                    <th>종료시간</th>
                                    <th>링크</th>
                                    <th>클릭</th>
                                    <th>클릭당 비용(원)</th>
                                    <th>진행상태</th>
                                    <th>비용발생(원)</th>
                                    <th>수정</th>
                                    
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="ad in adList" :key="ad.adId">
                                    <td>{{ad.adId}}</td>
                                    <td>{{ad.adName}}</td>
                                    <td>{{ad.startDate}}</td>
                                    <td>{{ad.endDate}}</td>
                                    <td>{{ad.linkUrl}}</td>
                                    <td>{{ad.clicks}}</td>
                                    <td>{{ad.clickUnitCost}}</td>
                                    <td>{{ad.status}}</td>
                                    <td>{{formatNumber(ad.adCost)}}</td>
                                    <td>
                                        <span v-if="ad.status==='진행중'||ad.status==='예정'">
                                            <button @click="fnEdit(ad.adId)">수정</button>
                                        </span>
                                        <span v-else>-</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- 페이징 버튼 -->
                        <div class="paging" style="margin-top: 15px; text-align: center;">
                            <span v-if="page>1">
                                <button @click="fnPre()">◀</button>
                            </span>
                            <span v-for="num in pageRangeList" :key="num" style="margin:0 5px;">
                                <a href="javascript:;" @click="fnChange(num)" :class="{active: page == num}">{{num}}</a>
                            </span>
                            <span v-if="page < pageNum">
                                <button @click="fnNext()">▶</button>
                            </span>
                        </div>
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
                    sessionId: "${sessionId}",
                    // 변수 - (key : value)
                    adList: [],

                    currentMenu: "ad",

                    //새 광고 삽입 시
                    adId: "",
                    adName: "",
                    startDate: "",
                    endDate: "",
                    urlLink: "",
                    clickUnitCost: 0,
                    status: "",

                    //전에 진행중인 광고(시간이 만료되었을 때 만 새로운 추가가)


                    //paging에 관한 모든 것
                    totalRows: 0,//전체 목록의 총 행수
                    pageRangeList: [],//화면 페이징을 하는 숫자들이 이루어진 리스트
                    pageSize: 10,//뿌렸을 때 한 페이지에 몇 행
                    page: 1,//지금 페이지
                    pageRange: 5,//한 화면에 몇개 페이지 수 나오게 한다
                    pageNum: 0,//목록 전체를 가져오려면 합하여 몇 페지


                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnAdList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/adad/adlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.adList = data.adList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();
                        }
                    });
                },

                fnAdAdd: function () {
                    let self = this;
                    let param = {
                        adName: self.adName,
                        urlLink: self.urlLink,
                        clickUnitCost: self.clickUnitCost,
                    };
                    self.fnCheck()
                        .then(function () {
                            //검사에 통과하면 집행
                            $.ajax({
                                url: "/adad/adadd.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    alert("광고가 추가되었습니다.");
                                }
                            });
                        })
                        .catch(function () {
                            //검사에 통과하지 않으면 집행x
                            console.log("업로드 중단됨");
                        });

                },


                fnCheck: function () {
                    //promise:먼저fnCheck를 집행하고 다음을 집행
                    return new Promise(function (resolve, reject) {
                        let self = this;
                        let param = {

                        };
                        $.ajax({
                            url: "/adad/adcheck.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if (data.check > 0) {
                                    alert("진행 중인 광고가 있습니다. 스케줄을 확인하시기 바람니다.");
                                    reject();
                                } else {
                                    resolve();
                                }
                            }
                        });
                    })
                },




                //수정 페이지로 이동
                fnEdit: function (adId) {
                    pageChange("/admin/adedit.do", { adId: adId });
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
                    self.fnAdList();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                    }
                    self.fnAdList();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                    }
                    self.fnAdList();

                },

                 formatNumber: function (num) {
                    if (!num && num !== 0) return '0';
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
                self.fnAdList();

            }
        });

        app.mount('#app');
    </script>