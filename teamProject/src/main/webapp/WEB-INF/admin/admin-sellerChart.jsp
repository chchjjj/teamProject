<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 판매자별 실적 현황 ::</title>
        <link rel="stylesheet" href="/css/admin-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

        <style>
            /* 콘텐츠 영역 전체 레이아웃 */
            .contentArea {
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }

            /* 페이지 제목 */
            .pageTitle {
                font-size: 22px;
                font-weight: bold;
                color: #3E2723;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 3px solid #3E2723;
            }

            /* 차트 컨테이너 */
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

            /* 인기 상품 영역 */
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

            /* 테이블 스타일 최적화 */
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

            /* 순위 표시 */
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

            /* 빈 상태 */
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
                <!-- 네비게이션 바 (수정 안 함) -->
                <div class="navBar">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
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

                    <div class="logOut">
                        <div>
                            <button @click="fnLogout()">Logout</button>
                        </div>
                    </div>
                </div>

                <!-- 콘텐츠 영역 (최적화 완료) -->
                <div class="contentArea">
                    <!--년도 선택 -->
                    <div
                        style="display:flex; align-items:center; gap:15px; justify-content:center; width:100%; margin-bottom:20px;">
                        <button @click="changeYear(-1)">◀</button>
                        <span style="font-size:22px; font-weight:bold;">
                            {{storeName}} {{ year }}년 월별 매출 조회
                        </span>
                        <button @click="changeYear(1)">▶</button>

                    </div>


                    <!-- 월별 매출 차트 -->
                    <div class="chartContainer">
                        <!--<div class="chartTitle">월별 매출 현황 (원)</div>-->
                        <div id="chart"></div>
                    </div>

                    <!-- 인기 상품 리스트 -->
                    <div class="hotProductSection">
                        <div class="sectionTitle">해당 판매자의 가장 핫한 상품 TOP</div>
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
                                        <span class="rankBadge" :class="{
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
                watch: {
                    year() {
                        this.fnList();
                    },
                   
                },
                data() {
                    const now = new Date();
                    return {
                        year: now.getFullYear(),
                        storeName: "${storeName}",
                        storeId: "${storeId}",        // ⭐ 必须添加
                        sessionId: "${sessionId}",
                        productList: [],
                        sellerList: [],
                        chart: null,
                        currentMenu: 'money',
                        options: {
                            series: [{ name: "매출액", data: [] }],
                            chart: {
                                height: 350,
                                type: 'line',
                                zoom: { enabled: false },
                                selection: { enabled: true },
                                toolbar: { show: false },
                                locales: [{ name: 'ko', options: {} }],
                                defaultLocale: 'ko',
                            },
                            dataLabels: {
                                enabled: true,
                                style: { fontSize: '12px', colors: ['#3E2723'] },
                                background: { enabled: true, borderRadius: 4, foreColor: '#fff' },
                                formatter: function (val) {
                                    return val.toLocaleString('ko-KR');
                                }
                            },
                            stroke: { curve: 'smooth', width: 4, colors: ['#E91E63'] },
                            markers: {
                                size: 5,
                                colors: ['#E91E63'],
                                strokeColors: '#fff',
                                strokeWidth: 2,
                                hover: { size: 7 }
                            },
                            title: {
                                text: now.getFullYear() + '년 월별 매출 추이',
                                align: 'center',
                                style: { fontSize: '20px', fontWeight: 'bold', color: '#3E2723' }
                            },
                            grid: {
                                borderColor: '#f0e6dc',
                                row: { colors: ['#fff', '#faf5f0'], opacity: 0.5 }
                            },
                            xaxis: {
                                categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                                labels: { style: { colors: '#3E2723', fontSize: '13px' } }
                            },
                            yaxis: {
                                labels: {
                                    formatter: val => val.toLocaleString('ko-KR'),
                                    style: { colors: '#3E2723' }
                                },
                                title: { text: '판매액 (원)', style: { color: '#3E2723', fontWeight: 'bold' } }
                            },
                            tooltip: {
                                theme: 'light',
                                y: { formatter: val => val.toLocaleString('ko-KR') + ' 원' }
                            }
                        }
                    };
                },
                methods: {
                    changeYear(diff) {
                        this.year += diff;
                        this.month = 1;
                    },
                    fnList() {
                        let self = this;
                        let param = {
                            storeId: self.storeId,    // ⭐ 必须传递
                            year: self.year            // ⭐ 必须传递
                        };

                        $.ajax({
                            url: "/adseller/sales.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success(data) {
                                let monthlyData = Array(12).fill(0);

                                data.list.forEach(item => {
                                    monthlyData[item.MONTH - 1] = item.TOTAL;
                                });

                                self.chart.updateSeries([{
                                    name: "매출액",
                                    data: monthlyData
                                }]);

                                self.chart.updateOptions({
                                    title: { text: self.year + '년 월별 매출 추이' }
                                });

                                self.productList = data.productList;
                            }
                        });
                    },
                    formatNumber(num) {
                        if (!num && num !== 0) return '0';
                        return Number(num).toLocaleString('ko-KR');
                    },
                    fnBuyerManage() { location.href = "/admin/userlist.do"; },
                    fnSellerManage() { location.href = "/admin/sellerlist.do"; },
                    fnSalesManage() { location.href = "/admin/chart.do"; },
                    fnAdRequest() { location.href = "/admin/ad.do"; },
                    fnMembership() { location.href = "/admin/membership.do"; },
                    fnMonthlyFee() { location.href = "/admin/monthlyfee.do"; },
                    fnQandA() { location.href = "/admin/boardManage.do"; },
                    fnLogout() {
                        if (confirm("로그아웃 하시겠습니까?")) {
                            $.ajax({
                                url: "/user/logout.dox",
                                dataType: "json",
                                type: "POST",
                                data: {},
                                success(data) {
                                    if (data.result == "success") {
                                        alert(data.msg + "! 홈페이지로 이동하겠습니다.");
                                        location.href = "/main.do";
                                    } else {
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