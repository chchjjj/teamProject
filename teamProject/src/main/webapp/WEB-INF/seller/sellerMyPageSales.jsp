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
        --table-row-stripe: #f9f9f9; /* 격자 무늬 배경 */
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
        border-collapse: collapse; /* 테두리 병합 */
        text-align: left;
        font-size: 14px;
        min-width: 500px; /* 테이블이 너무 작아지는 것 방지 */
    }

    /* 테이블 헤더 스타일 */
    .data-table thead {
        background-color: var(--table-header-bg); /* 에스프레소 배경 */
        color: var(--white); /* 흰색 글자 */
    }

    .data-table th {
        padding: 12px 15px;
        font-weight: 600;
        text-transform: uppercase;
        border: none; /* 헤더의 기본 테두리 제거 */
    }
    
    /* 테이블 본문 셀 스타일 */
    .data-table td {
        padding: 12px 15px;
        border-bottom: 1px solid #eeeeee; /* 얇은 구분선 */
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
        transform: none; /* 테이블 호버와 충돌 방지 */
        box-shadow: none;
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
            <div class="page-title">가게 관리 및 월별 매출</div>

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
            <h2>User04의 월별 매출 그래프</h2>
            <div id="chart_div" style="width:90%; height:500px;"></div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        list: [],        // 가게 목록
                         userId: "${sessionId}",
                        salesData: []    // 월별 매출
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

                        let chartData = [['월', '매출']];
                        this.salesData.forEach(item => {
                            chartData.push([item.MONTH, Number(item.TOTAL)]);
                        });

                        var data = google.visualization.arrayToDataTable(chartData);

                        var options = {
                            title: `${user.userId}의 월별 매출`,
                            legend: { position: 'none' },
                            vAxis: { format: '₩#,###' },
                            height: 500,
                            bar: { groupWidth: '30%' }
                        };

                        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
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