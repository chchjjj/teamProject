<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Trends Chart</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/admin-style.css">
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
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

        .monthlyRevenue {
    margin-top: 20px;
    text-align: center;
}
    </style>
</head>

<body>
    <!--이것을 추가해야 영어외의 언어가 정상적으로 작동-->
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <div id="app">
    <div class="mainPageContainer">
        <!-- 사이드바 -->
        <div class="navBar">
            <!-- Logo -->
            <div class="logo">
                <a href="javascript:;" onclick="location.href='/main.do'">
                    <img src="/img/로고.png" alt="쇼핑몰 로고">
                </a>
            </div>

            <!-- 메뉴 버튼 -->
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
                    <button @click="fnMonthlyFee()" :class="{active: currentMenu==='month'}">판매자 월 정산결과 조회</button>
                </div>
                <div>
                    <button @click="fnQandA()" :class="{active: currentMenu==='qna'}">Q&A</button>
                </div>
            </div>

            <!-- 로그아웃 -->
            <div class="logOut">
                <div>
                    <button @click="fnLogout()">Logout</button>
                </div>
            </div>
        </div>

        <!-- 컨텐츠 영역 -->
        <div class="contentArea">
            <!-- 차트 -->
            <div id="chart" style="margin-bottom: 40px;"></div>

            <!-- 이 달의 수익 테이블 -->
            <div class="monthlyRevenue">
                <div style="font-weight:bold; font-size:18px; margin-bottom:10px;">이 달의 수익</div>
                <table>
                    <tr>
                        <th>판매 수익</th>
                        <th>맴버십 수익</th>
                        <th>광고 수익</th>
                        <th>총합</th>
                    </tr>
                    <tr>
                        <td>{{revenue.monthlyRevenue}}</td>
                        <td>{{revenue.membershipFee}}</td>
                        <td>{{revenue.monthlyAdRevenue}}</td>
                        <td>{{revenue.totalMonthlyRevenue}}</td>
                    </tr>
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
                revenue: {},
                currentMenu: "money",
                chart: null,
                options: {
                    series: [{
                        name: "Sales",
                        data: [],
                    }],
                    chart: {
                        height: 350,
                        type: 'line',
                        zoom: {
                            enabled: false
                        }
                    },
                    dataLabels: {
                        enabled: true,

                    },
                    stroke: {
                        curve: 'smooth'
                    },
                    title: {
                        text: '2025년 트랜드 판매량 조회',
                        align: 'center'
                    },
                    grid: {
                        row: {
                            colors: ['#f3f3f3', 'transparent'],
                            opacity: 0.5
                        },
                    },
                    xaxis: {
                        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    }
                }
            };
        },
        methods: {
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/adsale/salestrends.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success" && data.list && data.list.length > 0) {
                            // Extract the sales data object
                            let salesData = data.list[0];

                            // 월별 데이터를 삽입
                            let monthlyData = [
                                salesData.JAN || 0,
                                salesData.FEB || 0,
                                salesData.MAR || 0,
                                salesData.APR || 0,
                                salesData.MAY || 0,
                                salesData.JUN || 0,
                                salesData.JUL || 0,
                                salesData.AUG || 0,
                                salesData.SEP || 0,
                                salesData.OCT || 0,
                                salesData.NOV || 0,
                                salesData.DEC || 0
                            ];

                            // Update the chart with new data
                            self.chart.updateSeries([{
                                name: "Sales",
                                data: monthlyData
                            }]);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching sales data:", error);
                    }
                });
            },

            fnRevenue: function () {
                let self = this;
                let param = {
                    userId: self.userId
                };
                $.ajax({
                    url: "/adrevenue/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data.revenue);
                        self.revenue = data.revenue;

                    }
                });

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


        },


        mounted() {
            let self = this;

            // Initialize the chart and store reference
            self.chart = new ApexCharts(document.querySelector("#chart"), self.options);
            self.chart.render();

            // Load data
            self.fnList();
            self.fnRevenue();
        }
    });

    app.mount('#app');
</script>