<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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
        <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <!-- html代码必须在id是app的tag里面进行 -->
         <div v-for="product in productList">{{product.storeName}}</div>
         <div id="chart"></div>


         <div>
            <div>
                가장 핫한 상품
            </div>
            <div>
                <table>
                    <tr>
                        <th>
                            상품명
                        </th>
                        <th>
                            판메량
                        </th>
                    </tr>
                    <tr v-for="product in productList">
                        <td>
                            {{product.proName}}
                        </td>
                        <td>
                            {{product.totalAmount}}
                        </td>
                    </tr>
                </table>
            </div>
         </div>

         <div v-for="seller in sellerList">
            <span>{{seller.percentile}}</span>
         </div>


    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                storeName:"${storeName}",
                productList:[],
                // 변수 - (key : value)
                options : {
                    series: [{
                        name: '',
                        data: []
                    }],
                    chart: {
                        height: 350,
                        type: 'bar',
                    },
                    plotOptions: {
                        bar: {
                            borderRadius: 10,
                            dataLabels: {
                                position: 'top', // top, center, bottom
                            },
                        }
                    },
                    dataLabels: {
                        enabled: true,
                        formatter: function (val) {
                            return val;
                        },
                        offsetY: -20,
                        style: {
                            fontSize: '12px',
                            colors: ["#304758"]
                        }
                    },

                    xaxis: {
                        categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        position: 'bottom',
                        axisBorder: {
                            show: false
                        },
                        axisTicks: {
                            show: false
                        },
                        crosshairs: {
                            fill: {
                                type: 'gradient',
                                gradient: {
                                    colorFrom: '#D8E3F0',
                                    colorTo: '#BED1E6',
                                    stops: [0, 100],
                                    opacityFrom: 0.4,
                                    opacityTo: 0.5,
                                }
                            }
                        },
                        tooltip: {
                            enabled: true,
                        }
                    },
                    yaxis: {
                        axisBorder: {
                            show: false
                        },
                        axisTicks: {
                            show: false,
                        },
                        labels: {
                            show: false,
                            formatter: function (val) {
                                return val + "%";
                            }
                        }

                    },
                    title: {
                        text: '',
                        floating: true,
                        offsetY: 330,
                        align: 'center',
                        style: {
                            color: '#444'
                        }
                    }
                }
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    storeName:self.storeName
                };
                $.ajax({
                    url: "/adseller/sales.dox",
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
                    
                        self.productList=data.productList;
                            
                    }
                });
            },

           
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // 先创建图表实例
    self.chart = new ApexCharts(document.querySelector("#chart"), self.options);
    
    // 渲染图表（此时显示空图表）
    self.chart.render();
            self.fnList();
            
        }
    });

    app.mount('#app');
</script>