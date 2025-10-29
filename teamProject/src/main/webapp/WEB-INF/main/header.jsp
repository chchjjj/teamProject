<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>헤더</title>
        <link rel="stylesheet" href="/css/main-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=search" />
        <style>
        </style>
    </head>

    <body>
        <div id="header">

            <header class="top-header">
                <div class="header-inner">
                    <div class="logo">
                        <a href="/main.do">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    <div class="search-and-user-area">
                        <div class="search-box">
                            <input type="text" placeholder="검색 키워드를 입력해주세요.">
                            <button>
                                <span class="material-symbols-outlined">
                                    search
                                </span>
                            </button>
                        </div>
                        <div class="user-menu">
                            <img src="/img/찜.png" alt="찜 목록"></a>
                            <img src="/img/마이페이지.png" alt="마이페이지">
                        </div>
                    </div>
                </div>
            </header>

            <nav class="main-nav-container">
                <div class="nav-inner">
                    <ul class="main-menu">
                        <li class="menu-item dropdown">
                            <a href="#">카테고리</a>
                            <ul class="submenu">
                                <li><a href="#">케이크</a></li>
                                <li><a href="#">쿠키</a></li>
                                <li><a href="#">초콜릿/사탕</a></li>
                            </ul>
                        </li>
                        <li class="menu-item dropdown">
                            <a href="#">베스트</a>
                            <ul class="submenu">
                                <li><a href="#">인기 상품 1위</a></li>
                                <li><a href="#">인기 상품 2위</a></li>
                                <li><a href="#">인기 상품 3위</a></li>
                            </ul>
                        </li>
                        <li class="menu-item"><a href="#">알레르기 프리</a></li>
                        <li class="menu-item"><a href="#">입점하기</a></li>
                        <li class="menu-item"><a href="#">마이페이지</a></li>
                        <li class="menu-item"><a href="#">QnA</a></li>
                    </ul>
                </div>
            </nav>
            </div>
    </body>

    </html>

    <script>
        const header = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    isLogin: false, // 기본은 로그아웃 상태
                    keyword: "", // 검색어
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

        header.mount('#header');
    </script>