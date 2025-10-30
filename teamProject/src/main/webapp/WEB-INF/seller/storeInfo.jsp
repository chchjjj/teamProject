<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
      
  
    .page-container {
        padding: 20px;
        max-width: 900px;
        margin: 0 auto;
    }

    h2 {
        text-align: left;
        color: #333;
        margin-bottom: 20px;
        border-bottom: 2px solid #eee;
        padding-bottom: 10px;
    }

    table {
        width: 100%;
        margin-top: 15px;
    }
    
    /* 상태별 텍스트 색상 */
    .status-completed {
        color: green;
        font-weight: bold;
    }
    .status-pending {
        color: orange;
        font-weight: bold;
    }

    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="page-container">
    
    
    <table>
        
        <tbody>
            <tr v-for="(item, index) in salesList" :key="item.orderId">
                <td>{{ salesList.length - index }}</td> <td>{{ item.orderId }}</td>
                <td>{{ item.productName }}</td>
                <td>{{ item.quantity }}개</td>
                <td>{{ item.amount.toLocaleString() }}원</td>
                <td>{{ item.orderDate }}</td>
                <td>
                    <span :class="{'status-completed': item.status === '완료', 'status-pending': item.status === '취소 요청'}">
                        {{ item.status }}
                    </span>
                </td>
            </tr>
        </tbody>
    </table>
</div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>