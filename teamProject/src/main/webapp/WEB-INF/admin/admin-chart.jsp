<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>:: 매출 관리 ::</title>
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

        .monthlyRevenue {
            margin-top: 20px;
            text-align: center;
        }


        .section-title {
            font-size: 20px !important;
            font-weight: bold !important;
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

                    <!-- 로그아웃 -->
                    <div class="logOut">
                        <div>
                            <button @click="fnLogout()">Logout</button>
                        </div>
                    </div>
                </div>

                <!-- 컨텐츠 영역 -->
                <div class="contentArea">
                    <div class="section-title">매출 관리</div>
                    <!-- 차트 -->
                    <div id="chart" style="margin-bottom: 40px;"></div>

                    <!-- 이 달의 수익 테이블 -->
                    <div class="monthlyRevenue">
                        <div style="font-weight:bold; font-size:18px; margin-bottom:10px;">이 달의 수익(원)</div>
                        <table>
                            <tr>
                                <th>판매 수익</th>
                                <th>맴버십 수익</th>
                                <th>광고 수익</th>
                                <th>총합</th>
                            </tr>
                            <tr>
                                <td>{{formatNumber(revenue.monthlyRevenue)}}</td>
                                <td>{{formatNumber(revenue.membershipFee)}}</td>
                                <td>{{formatNumber(revenue.monthlyAdRevenue)}}</td>
                                <td>{{formatNumber(revenue.totalMonthlyRevenue)}}</td>
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
                sessionId: "${sessionId}",
                revenue: {},
                currentMenu: "money",
                chart: null,
                options: {
                    series: [{
                        name: "매출액", // 韩语标题
                        data: [],
                    }],
                    chart: {
                        height: 350,
                        type: 'line',
                        zoom: { enabled: false },
                        toolbar: { show: false },
                        locales: [{
                            name: 'ko',
                            options: {
                                months: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                                shortMonths: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                                days: ['일', '월', '화', '수', '목', '금', '토'],
                                shortDays: ['일', '월', '화', '수', '목', '금', '토'],
                                toolbar: {
                                    exportToSVG: 'SVG로 내보내기',
                                    exportToPNG: 'PNG로 내보내기',
                                    exportToCSV: 'CSV로 내보내기',
                                    menu: '메뉴',
                                    selection: '선택',
                                    selectionZoom: '선택 확대',
                                    zoomIn: '확대',
                                    zoomOut: '축소',
                                    pan: '이동',
                                    reset: '초기화'
                                }
                            }
                        }],
                        defaultLocale: 'ko',
                    },
                    dataLabels: {
                        enabled: true,
                        style: {
                            fontSize: '12px',
                            colors: ['#3E2723'],
                        },
                        background: {
                            enabled: true,
                            borderRadius: 4,
                            foreColor: '#fff',
                        },
                        formatter: function (val) {
                            return val.toLocaleString('ko-KR'); 
                        }
                    },
                    stroke: {
                        curve: 'smooth',
                        width: 4,
                        colors: ['#E91E63'], 
                    },
                    markers: {
                        size: 5,
                        colors: ['#E91E63'],
                        strokeColors: '#fff',
                        strokeWidth: 2,
                        hover: { size: 7 },
                    },
                    title: {
                        text: '2025년 월별 매출 추이',
                        align: 'center',
                        style: {
                            fontSize: '20px',
                            fontWeight: 'bold',
                            color: '#3E2723',
                        }
                    },
                    grid: {
                        borderColor: '#f0e6dc',
                        row: {
                            colors: ['#fff', '#faf5f0'],
                            opacity: 0.5,
                        },
                    },
                    xaxis: {
                        categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                        labels: {
                            style: {
                                colors: '#3E2723',
                                fontSize: '13px',
                            }
                        }
                    },
                    yaxis: {
                        labels: {
                            formatter: val => val.toLocaleString('ko-KR'),
                            style: { colors: '#3E2723' }
                        },
                        title: {
                            text: '판매액 (원)',
                            style: { color: '#3E2723', fontWeight: 'bold' }
                        }
                    },
                    tooltip: {
                        theme: 'light',
                        y: {
                            formatter: val => val.toLocaleString('ko-KR') + ' 원'
                        }
                    },
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