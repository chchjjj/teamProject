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
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <div class="mainPageContainer">
                <!-- 导航栏 -->
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

                <!-- 内容区 -->
                <div v-for="product in productList">
                    {{ product.storeName }}
                </div>

                <div id="chart"></div>

                <div>
                    <div>가장 핫한 상품</div>
                    <table>
                        <tr>
                            <th>상품명</th>
                            <th>판매량</th>
                        </tr>
                        <tr v-for="product in productList">
                            <td>{{ product.proName }}</td>
                            <td>{{ product.totalAmount }}</td>
                        </tr>
                    </table>
                </div>

                <div v-for="seller in sellerList">
                    <span>{{ seller.percentile }}</span>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        storeName: "${storeName}",
                        productList: [],
                        sellerList: [],
                        chart: null,
                        options: {
                            series: [{ name: '', data: [] }],
                            chart: { height: 350, type: 'bar' },
                            plotOptions: {
                                bar: { borderRadius: 10, dataLabels: { position: 'top' } }
                            },
                            dataLabels: {
                                enabled: true,
                                formatter: val => val,
                                offsetY: -20,
                                style: { fontSize: '12px', colors: ["#304758"] }
                            },
                            xaxis: {
                                categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                                position: 'bottom',
                                axisBorder: { show: false },
                                axisTicks: { show: false },
                                tooltip: { enabled: true }
                            },
                            yaxis: { labels: { show: false } },
                            title: { text: '', align: 'center' }
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
                                    self.chart.updateSeries([{ name: "Sales", data: monthlyData }]);
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
                    fnLogout() {
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
                    self.chart = new ApexCharts(document.querySelector("#chart"), self.options);
                    self.chart.render();
                    self.fnList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>