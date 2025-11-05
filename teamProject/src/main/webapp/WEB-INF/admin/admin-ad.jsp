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
                        <img src="/images/logo.png" alt="Dessert Lab" style="max-width: 150px;">
                        <p>Admin Panel</p>
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

                <div>
                    <div>광고관리</div>
                    <div>
                        <div>광고추가</div>

                        <div>
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
                        </div>
                        <div><button @click="fnAdAdd()">추가</button></div>
                    </div>
                    <div>
                        <div>
                            <div>광고 리스트</div>
                            <div>
                                <table>
                                    <tr>
                                        <th>광고번호</th>
                                        <th>광고이름</th>
                                        <th>시작시간</th>
                                        <th>종료시간</th>
                                        <th>링크</th>
                                        <th>클릭</th>
                                        <th>클릭당 비용(원)</th>
                                        <th>진행상태</th>
                                        <th>수정</th>
                                    </tr>
                                    <tr v-for="ad in adList">
                                        <td>{{ad.adId}}</td>
                                        <td>{{ad.adName}}</td>
                                        <td>{{ad.startDate}}</td>
                                        <td>{{ad.endDate}}</td>
                                        <td>{{ad.linkUrl}}</td>
                                        <td>{{ad.clicks}}</td>
                                        <td>{{ad.clickUnitCost}}</td>
                                        <td>{{ad.status}}</td>
                                        <td>
                                            <span v-if="ad.status==='진행중'||ad.status==='예정'"><button
                                                    @click="fnEdit(ad.adId)">수정</button></span>
                                            <span v-else>-</span>
                                        </td>
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