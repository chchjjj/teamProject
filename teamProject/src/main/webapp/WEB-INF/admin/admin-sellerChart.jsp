<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <link rel="stylesheet" href="/css/admin-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

        <style>
            /* 内容区域整体布局 */
            .contentArea {
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }

            /* 页面标题 */
            .pageTitle {
                font-size: 28px;
                font-weight: bold;
                color: #3E2723;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 3px solid #3E2723;
            }

            /* 图表容器 */
            .chartContainer {
                background-color: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .chartTitle {
                font-size: 20px;
                font-weight: bold;
                color: #3E2723;
                margin-bottom: 20px;
                padding-left: 10px;
                border-left: 4px solid #FFEDAC;
            }

            #chart {
                width: 100%;
            }

            /* 热门商品区域 */
            .hotProductSection {
                background-color: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .sectionTitle {
                font-size: 20px;
                font-weight: bold;
                color: #3E2723;
                margin-bottom: 20px;
                padding-left: 10px;
                border-left: 4px solid #FFEDAC;
            }

            /* 表格样式优化 */
            table {
                width: 100%;
                border-collapse: collapse;
                font-family: 'Arial', sans-serif;
                background-color: white;
            }

            th {
                background-color: #3E2723;
                color: #FFEDAC;
                padding: 12px 15px;
                text-align: center;
                font-weight: bold;
                border: none;
            }

            td {
                padding: 12px 15px;
                text-align: center;
                border-bottom: 1px solid #e0e0e0;
                color: #333;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #F4C9D6;
                transition: background-color 0.3s ease;
            }

            tbody tr:last-child td {
                border-bottom: none;
            }

            /* 排名标识 */
            .rankBadge {
                display: inline-block;
                width: 28px;
                height: 28px;
                line-height: 28px;
                border-radius: 50%;
                background: linear-gradient(135deg, #FFD700, #FFA500);
                color: white;
                font-weight: bold;
                font-size: 14px;
                margin-right: 8px;
            }

            .rankBadge.rank2 {
                background: linear-gradient(135deg, #C0C0C0, #A9A9A9);
            }

            .rankBadge.rank3 {
                background: linear-gradient(135deg, #CD7F32, #8B4513);
            }

            .rankBadge.others {
                background: linear-gradient(135deg, #9E9E9E, #757575);
            }

            /* 空状态 */
            .emptyState {
                text-align: center;
                padding: 40px;
                color: #999;
                font-size: 16px;
            }

            .emptyState::before {
                content: "";
                display: block;
                font-size: 48px;
                margin-bottom: 15px;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <div class="mainPageContainer">
                <!-- 导航栏 (不修改) -->
                <div class="navBar">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
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

                    <div class="logOut">
                        <div>
                            <button @click="fnLogout()">Logout</button>
                        </div>
                    </div>
                </div>

                <!-- 内容区域 (优化后) -->
                <div class="contentArea">
                    <div class="pageTitle">매출 관리</div>

                    <!-- 月度销售图表 -->
                    <div class="chartContainer">
                        <div class="chartTitle">월별 매출 현황</div>
                        <div id="chart"></div>
                    </div>

                    <!-- 热门商品列表 -->
                    <div class="hotProductSection">
                        <div class="sectionTitle"> 가장 핫한 상품 TOP 10</div>
                        <table v-if="productList && productList.length > 0">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">순위</th>
                                    <th>상품명</th>
                                    <th style="width: 150px;">판매량</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(product, index) in productList" :key="index">
                                    <td>
                                        <span class="rankBadge" 
                                              :class="{
                                                  'rank2': index === 1,
                                                  'rank3': index === 2,
                                                  'others': index > 2
                                              }">
                                            {{ index + 1 }}
                                        </span>
                                    </td>
                                    <td style="text-align: left; font-weight: 500;">
                                        {{ product.proName }}
                                    </td>
                                    <td style="font-weight: bold; color: #3E2723;">
                                        {{ product.totalAmount ? product.totalAmount.toLocaleString() : 0 }} 개
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div v-else class="emptyState">
                            판매 데이터가 없습니다
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        storeName: "${storeName}",
                        sessionId: "${sessionId}",
                        productList: [],
                        sellerList: [],
                        chart: null,
                        currentMenu: 'money',
                        options: {
                            series: [{ name: '매출', data: [] }],
                            chart: { 
                                height: 350, 
                                type: 'bar',
                                toolbar: {
                                    show: true
                                }
                            },
                            plotOptions: {
                                bar: { 
                                    borderRadius: 8, 
                                    dataLabels: { position: 'top' },
                                    columnWidth: '60%'
                                }
                            },
                            dataLabels: {
                                enabled: true,
                                formatter: val => val ? val.toLocaleString() : 0,
                                offsetY: -20,
                                style: { 
                                    fontSize: '12px', 
                                    colors: ["#3E2723"],
                                    fontWeight: 'bold'
                                }
                            },
                            xaxis: {
                                categories: ["1월", "2월", "3월", "4월", "5월", "6월",
                                    "7월", "8월", "9월", "10월", "11월", "12월"],
                                position: 'bottom',
                                axisBorder: { show: false },
                                axisTicks: { show: false },
                                labels: {
                                    style: {
                                        colors: '#666',
                                        fontSize: '12px'
                                    }
                                }
                            },
                            yaxis: { 
                                labels: { 
                                    show: true,
                                    formatter: val => val ? val.toLocaleString() : 0,
                                    style: {
                                        colors: '#666',
                                        fontSize: '12px'
                                    }
                                }
                            },
                            colors: ['#3E2723'],
                            fill: {
                                type: 'gradient',
                                gradient: {
                                    shade: 'light',
                                    type: "vertical",
                                    shadeIntensity: 0.25,
                                    gradientToColors: ['#FFEDAC'],
                                    inverseColors: false,
                                    opacityFrom: 0.85,
                                    opacityTo: 0.85,
                                    stops: [50, 100]
                                }
                            },
                            grid: {
                                borderColor: '#f1f1f1',
                                strokeDashArray: 4
                            },
                            title: { 
                                text: '', 
                                align: 'center' 
                            }
                        }
                    };
                },
                methods: {
                    fnList() {
                        let self = this;
                        $.ajax({
                            url: "/adseller/sales.dox",
                            dataType: "json",
                            type: "POST",
                            data: { storeName: self.storeName },
                            success: function (data) {
                                if (data.result === "success" && data.list && data.list.length > 0) {
                                    let salesData = data.list[0];
                                    let monthlyData = [
                                        salesData.JAN || 0, salesData.FEB || 0, salesData.MAR || 0, salesData.APR || 0,
                                        salesData.MAY || 0, salesData.JUN || 0, salesData.JUL || 0, salesData.AUG || 0,
                                        salesData.SEP || 0, salesData.OCT || 0, salesData.NOV || 0, salesData.DEC || 0
                                    ];
                                    self.chart.updateSeries([{ name: "매출", data: monthlyData }]);
                                }
                                self.productList = data.productList;
                            }
                        });
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
                    }
                },
                mounted() {
                    let self = this;
                    self.chart = new ApexCharts(document.querySelector("#chart"), self.options);
                    self.chart.render();
                    self.fnList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>