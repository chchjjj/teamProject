<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Trends Chart</title>
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
    <!--이것을 추가해야 영어외의 언어가 정상적으로 작동-->
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <div id="app">
        <div id="chart"></div>
    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                chart: null,
                options: {
                    series: [{
                        name: "Sales",
                        data: []
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
                    error: function(xhr, status, error) {
                        console.error("Error fetching sales data:", error);
                    }
                });
            }
        },
        mounted() {
            let self = this;
            
            // Initialize the chart and store reference
            self.chart = new ApexCharts(document.querySelector("#chart"), self.options);
            self.chart.render();
            
            // Load data
            self.fnList();
        }
    });

    app.mount('#app');
</script>