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
            body {
                margin: 0;
                font-family: 'Malgun Gothic', sans-serif;
                background: #f4f4f4;
                display: flex;
            }

            .sidebar {
                width: 220px;
                background: #e9e9e9;
                padding: 20px 0;
                flex-shrink: 0;
                position: fixed;
                top: 0;
                bottom: 0;
            }

            .content-area {
                flex-grow: 1;
                margin-left: 220px;
                padding: 30px;
                background: #fff;
            }

            .page-title {
                font-size: 24px;
                font-weight: 300;
                margin-bottom: 20px;
            }

            .store-card {
                border: 1px solid #ddd;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .store-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 15px;
            }

            .store-name-section {
                display: flex;
                align-items: center;
            }

            .store-name-section h3 {
                margin: 0 15px 0 0;
                font-size: 18px;
            }

            .membership-info {
                font-size: 14px;
                color: #666;
            }

            .store-intro p {
                background: #f9f9f9;
                padding: 15px;
                border-radius: 4px;
                color: #555;
                margin: 10px 0 20px 0;
            }

            .management-buttons button {
                padding: 8px 15px;
                border: 1px solid #ccc;
                background: #fff;
                cursor: pointer;
                margin-right: 5px;
                border-radius: 4px;
            }

            .management-buttons .primary-btn {
                background: #007bff;
                color: #fff;
                border: 1px solid #007bff;
            }
        </style>
    </head>

    <body>

        <!-- 사이드바 -->
        <div class="sidebar">
            <%@ include file="/WEB-INF/main/sellerSideBar.jsp" %>
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
            <div id="chart_div" style="width:100%; height:500px;"></div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        list: [],        // 가게 목록
                        userId: 'user04',
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
                            bar: { groupWidth: '60%' }
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