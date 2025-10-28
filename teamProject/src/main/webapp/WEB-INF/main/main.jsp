<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>:: 디저트 연구소 ::</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        
    .main-membership{
        margin-top: 20px;
        margin-left: 20px;
    }

    .main-membership img{
        width: 400px;      
        height: 300px;
        border-radius: 10px;
    }

    .container {
        width: 860px;
        margin: 0 auto;
    }

    #cart{
        width: 400px ;
        height: 170px;
        box-sizing: border-box;
        border-radius: 10px;        
    }

    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->

        <!-- 헤더 -->
        <%@ include file="/WEB-INF/main/header.jsp" %>

        <div class="container">

            <!-- 멤버십 가게 광고 패널 / 내 주변 가게 찾기 / 장바구니 -->
            <div>★ 디저트 연구소 추천 상품! </div> 
            <span class="main-membership">
                <button><</button>
                <img src="/img/member_cookies.jpg" alt="멤버쉽 광고 패널">
                <button>></button>
            </span>
            <span>
                <button id="cart">장바구니</button>
            </span>
            <div>
                
            </div>




        </div>                 
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)

                // 메인 상단 - 멤버쉽 화면 홍보 이미지
                productImages: [
                    '/img/member_cookies.jpg',
                    '/img/member_cake.jpg'
                    // ...
                ],
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