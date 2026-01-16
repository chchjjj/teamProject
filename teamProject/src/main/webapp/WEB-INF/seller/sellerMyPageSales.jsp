<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>판매자 마이페이지</title>


        <!-- jQuery & Vue -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!-- Google Charts -->
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

        <style>
            /* (기존 1. Color Variables & Global Styles 유지) */
            :root {
                --espresso: #3E2723;
                --peony: #F4C9D6;
                --butter: #FFEDAC;
                --light-bg: #F4F4F4;
                --white: #FFFFFF;
                --primary-color: var(--espresso);
                --secondary-color: var(--peony);
                --table-header-bg: var(--espresso);
                --table-row-stripe: #f9f9f9;
                /* 격자 무늬 배경 */
            }

            /* (기존 2. Layout 유지) */

            /* ---------------------------------------------------- */
            /* 6. Data Table Styles (새로 추가) */
            /* ---------------------------------------------------- */

            .data-table-container {
                /* 테이블이 넓을 경우 가로 스크롤 허용 */

                overflow-x: auto;
                margin-top: 20px;
                background-color: var(--white);
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                padding: 10px;
                /* .content-area 내에서 중앙 정렬을 원한다면 max-width 설정 */
                /* max-width: 1000px; */
                /* margin: 0 auto; */
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
                /* 테두리 병합 */
                text-align: left;
                font-size: 14px;
                min-width: 500px;
                /* 테이블이 너무 작아지는 것 방지 */
            }

            /* 테이블 헤더 스타일 */
            .data-table thead {
                background-color: var(--table-header-bg);
                /* 에스프레소 배경 */
                color: var(--white);
                /* 흰색 글자 */
            }

            .data-table th {
                padding: 12px 15px;
                font-weight: 600;
                text-transform: uppercase;
                border: none;
                /* 헤더의 기본 테두리 제거 */
            }

            /* 테이블 본문 셀 스타일 */
            .data-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #eeeeee;
                /* 얇은 구분선 */
                color: #333;
                vertical-align: middle;
            }

            /* 테이블 본문: 격자 무늬(Zebra Striping) */
            .data-table tbody tr:nth-child(even) {
                background-color: var(--table-row-stripe);
            }

            /* 테이블 본문: 호버 효과 (Peony 강조) */
            .data-table tbody tr:hover {
                background-color: var(--peony);
                cursor: pointer;
                color: var(--espresso);
                /* 폰트 굵기를 살짝 조정하여 호버 강조 */
                font-weight: 500;
            }

            /* 버튼 스타일 (테이블 내부에 버튼이 있을 경우) */
            .data-table .table-action-btn {
                padding: 5px 10px;
                font-size: 12px;
                font-weight: 500;
                border-radius: 4px;
                background-color: var(--white);
                color: var(--primary-color);
                border: 1px solid var(--primary-color);
                transition: background-color 0.2s;
            }

            .data-table .table-action-btn:hover {
                background-color: var(--primary-color);
                color: var(--white);
                transform: none;
                /* 테이블 호버와 충돌 방지 */
                box-shadow: none;
            }

            .report-section {
                margin: 40px auto 20px;
                padding: 30px;
                background-color: var(--white);
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(62, 39, 35, 0.05);
                /* 에스프레소 톤 그림자 */
                border: 1px solid #eee;
                width: 95%;
                /* 차트 너비 조절 */
            }

            .report-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .report-title {
                font-size: 24px !important;
                /* 기존 h2 스타일 덮어쓰기 */
                color: var(--espresso);
                font-weight: 700;
                margin-bottom: 8px;
            }

            .user-id {
                color: var(--espresso);
                border-bottom: 4px solid var(--peony);
                /* ID 밑에 핑크색 강조선 */
                padding-bottom: 2px;
            }

            .report-subtitle {
                color: #888;
                font-size: 14px;
                margin: 0;
            }

            /* 차트가 담길 그릇 */
            .chart-container {
                width: 100%;
            }

            #chart_div {
                width: 100%;
                height: 500px;
            }

            .page-title {
                font-size: 28px;
                font-weight: 800;
                color: var(--espresso);
                margin-bottom: 30px;
                padding-left: 15px;
                border-left: 6px solid var(--peony);
                /* 왼쪽에 핑크색 포인트 바 */
                display: flex;
                align-items: center;
                letter-spacing: -1px;
                background: linear-gradient(to right, #ffffff, #fdfdfd);
                padding-top: 10px;
                padding-bottom: 10px;
                border-radius: 0 8px 8px 0;
            }


            .page-title::after {
                content: 'Seller Administration';
                font-size: 12px;
                color: #bbb;
                margin-left: 15px;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-weight: 400;
            }
        </style>
    </head>

    <body>

        <!-- 사이드바 -->
        <div class="sidebar">
            <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
        </div>

        <!-- 메인 콘텐츠 영역 (Vue 앱) -->
        <div id="app" class="content-area">
            <header class="content-header">
                <div class="page-title">가게 관리 및 월별 매출</div>

                <div class="filter-section" style="margin-bottom: 20px; text-align: right;">
                    <label for="monthSelect" style="font-weight: bold; color: var(--espresso); margin-right: 10px;">데이터
                        필터:</label>
                    <select id="monthSelect" v-model="selectedMonth" @change="drawChart"
                        style="padding: 8px 15px; border-radius: 5px; border: 1px solid var(--peony); color: var(--espresso);">
                        <option value="all">전체 보기</option>
                        <option v-for="item in salesData" :key="item.MONTH" :value="item.MONTH">
                            {{ item.MONTH }}
                        </option>
                    </select>
                </div>

                <hr style="border: 0; height: 1px; background: #eee; margin-bottom: 30px;">
            </header>

            <!-- 가게 목록 -->
            <div v-for="(store, index) in list" :key="index" class="store-card">
                <div class="store-header">
                    <div class="store-name-section">
                        <h3>{{ store.storeName }}</h3>
                        <span class="membership-info">{{ store.membership }}</span>
                    </div>
                </div>
                <div class="store-intro">
                    <p>{{ store.intro }}</p>
                </div>
                <div class="management-buttons">
                    <button class="primary-btn">관리</button>
                    <button>삭제</button>
                </div>
            </div>

            <!-- 월별 매출 그래프 -->
            <div class="report-section">
                <div class="report-header">
                    <h2 class="report-title">
                        <span class="user-id">{{ userId }}</span> 님의 월별 매출 분석
                    </h2>
                    <p class="report-subtitle">최근 매출 데이터를 기반으로 집계된 결과입니다.</p>
                </div>

                <div class="chart-container">
                    <div id="chart_div"></div>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        list: [],        // 가게 목록
                        userId: "${sessionId}",
                        salesData: [],    
                        selectedMonth: "all"
                    }
                },
                methods: {
                    fnSales() {
                        let self = this;
                        $.ajax({
                            url: "/seller/sales.dox",
                            type: "POST",
                            dataType: "json",
                            data: { userId: self.userId },
                            success: function (data) {
                                self.salesData = data.list || [];
                                self.drawChart();
                            },
                            error: function (xhr, status, error) {
                                console.error("월별 매출 조회 실패:", error);
                                self.salesData = [];
                            }
                        });
                    },
                    drawChart() {
                        if (!Array.isArray(this.salesData) || this.salesData.length === 0) return;
                        let displayData = this.salesData;
            if (this.selectedMonth !== "all") {
                displayData = this.salesData.filter(item => item.MONTH === this.selectedMonth);
            }

                        let chartData = [['월', '매출', { role: 'style' }, { role: 'annotation' }]];

                        this.salesData.forEach(item => {
                            const total = Number(item.TOTAL);
                            chartData.push([
                                item.MONTH,
                                total,
                                'color: #F4C9D6; fill-opacity: 0.9;', // 막대 색상
                                total.toLocaleString() + '원' // 막대 위 금액 표시
                            ]);
                        });

                        const data = google.visualization.arrayToDataTable(chartData);

                        const options = {
                            title: '', // HTML로 제목을 따로 만들었으므로 여기선 지웁니다 (중요!)
                            fontName: 'Pretendard, sans-serif',
                            chartArea: {
                                left: '10%',
                                top: '10%',
                                width: '85%',
                                height: '75%'
                            },
                            bar: { groupWidth: '40%' },
                            annotations: {
                                textStyle: { fontSize: 13, bold: true, color: '#3E2723' },
                                alwaysOutside: true
                            },
                            vAxis: {
                                format: '#,###',
                                gridlines: { color: '#f0f0f0' },
                                textStyle: { color: '#aaa', fontSize: 11 }
                            },
                            hAxis: {
                                textStyle: { color: '#3E2723', fontSize: 14, bold: true }
                            },
                            legend: { position: 'none' },
                            animation: { startup: true, duration: 800, easing: 'out' }
                        };

                        const chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
                        chart.draw(data, options);
                    }
                },
                mounted() {
                    // Google Charts 로드 후 Ajax 호출
                    google.charts.load('current', { 'packages': ['corechart'] });
                    google.charts.setOnLoadCallback(() => {
                        this.fnSales();
                    });
                }
            });

            app.mount('#app');
        </script>

    </body>

    </html>