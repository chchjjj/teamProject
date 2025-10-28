<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>헤더</title>
    <link rel="stylesheet" href="/css/main-style.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        
        
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->

        <!-- 헤더 -->
        <header>
            <!-- 왼쪽 상단 로고 -->
            <div class="logo">
                <a href="javascript:;" onclick="window.location.reload()">
                    <!--로고 클릭시 홈페이지 새로고침 -->
                    <img src="/img/logo.jpg" alt="쇼핑몰 로고">
                </a>                
            </div>
            <!-- 검색창 -->
            <div class="search-bar">
                <input v-model="keyword" @keyup.enter="fnList" type="text" placeholder="원하시는 상품을 입력해주세요!">
                <!-- @keyup.enter : 키워드 입력 후 엔터쳐도 검색버튼 적용되도록 -->                
                <button @click="fnList">검색</button>
                
            </div>
            <!-- 로그인 여부에 따라 버튼 다르게 보이도록 -->
            <div v-if="!isLogin" class="login-btn">
                <button>로그인</button>
                <button>회원가입</button>                
            </div>
            <div v-else class="logout-btn">
                <button>로그아웃</button>
                <button>장바구니</button>                
            </div>
            <nav>
                <ul>                    
                    <li>카테고리</li>
                    <li>베스트</li>
                    <li>후기</li>
                    <li>마이페이지</li>
                </ul>
            </nav>            
        </header>




         
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                isLogin : false, // 기본은 로그아웃 상태
                keyword : "", // 검색어
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