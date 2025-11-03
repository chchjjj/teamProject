<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Black Coffee!</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* 기본 설정 */
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', 'Apple SD Gothic Neo', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5; /* 전체 페이지 배경색 */
            color: #333;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* 1. 헤더 (Header) 및 네비게이션 */
        header {
            background-color: #e8e6df; /* 상단 배경색 (투썸 웹사이트의 은은한 베이지 톤 참고) */
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            padding: 15px 0;
        }

        .nav-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .logo {
            font-size: 1.5em;
            font-weight: bold;
            color: #000;
        }

        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
        }

        .nav-menu li {
            margin-left: 30px;
        }

        .nav-menu a {
            display: block;
            padding: 5px 10px;
            font-size: 0.95em;
            color: #333;
            font-weight: 500;
            transition: color 0.2s;
        }

        .nav-menu a:hover {
            color: #a0522d; /* 커피를 연상시키는 갈색 계열 */
        }

        /* 2. 메인 콘텐츠 (Main Content) */
        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* 3. 히어로 섹션 (Hero Section) - 이미지 및 슬라이더 */
        .hero-section {
            position: relative;
            width: 100%;
            margin-top: 20px;
            overflow: hidden;
        }

        .image-slider {
            position: relative;
            width: 100%;
            height: 700px; /* 적당한 높이 설정 */
            display: flex;
            justify-content: center;
            align-items: flex-start; /* 이미지를 상단에 배치하도록 변경 (혹은 center) */
            
            /* ⭐️⭐️⭐️ 수정: 그라데이션 대신 단색 베이지 톤으로 통일 ⭐️⭐️⭐️ */
            background-color: #d8c2a9;
        }

        .coffee-image {
            /* ⭐️⭐️⭐️ 핵심 수정: 이미지/텍스트 오버레이의 기준점 & 크기 설정 ⭐️⭐️⭐️ */
            position: relative; /* 자식 요소(오버레이)의 기준점 */
            width: 450px; /* 광고 이미지의 폭을 고정하여 중앙에 배치 */
            max-width: 90%; 
            height: 100%; /* 부모와 동일한 높이 */
            display: flex; /* 내부 요소(이미지)를 정렬하기 위해 flex 사용 */
            justify-content: center; 
            align-items: center;
            margin: 0;
            padding: 0;
        }

        /* ⭐️ 핵심 수정: 이미지 크기 조절 (coffee-image에 맞게) ⭐️ */
        .coffee-image img {
            width: 100%;
            height: 100%;
            object-fit: contain; /* 비율을 유지하며 컨테이너에 맞춥니다. */
            display: block;
        }
        
        /* ⭐️ 텍스트 오버레이 스타일 (coffee-image에 맞춰짐) ⭐️ */
        .ad-text-overlay {
            position: absolute; /* 부모(.coffee-image)를 기준으로 위치 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            text-align: center;
            color: #ffde00; 
            pointer-events: none; 
            padding-top: 50px;
        }

        .title-main {
            font-size: 3em;
            font-weight: 900;
            margin-bottom: 0;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.4);
        }

        .title-sub {
            font-size: 1.2em;
            font-weight: 500;
            color: #fff; /* 서브 타이틀은 흰색으로 */
            margin-top: 5px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }
        
        .price {
            position: absolute;
            bottom: 120px; /* 이미지 하단으로부터 위치 조정 */
            left: 50%;
            transform: translateX(-50%);
            font-size: 1.8em;
            font-weight: bold;
            color: #ffde00;
        }

        .description {
            position: absolute;
            bottom: 40px;
            left: 50%;
            transform: translateX(-50%);
            width: 90%;
            font-size: 0.75em;
            line-height: 1.4;
            color: #fff;
            opacity: 0.8;
        }

        /* 4. 슬라이더 컨트롤 */
        .slider-control {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            align-items: center;
            background-color: rgba(0, 0, 0, 0.6); /* 어두운 배경 */
            color: #fff;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }

        .arrow {
            cursor: pointer;
            font-size: 1.2em;
            font-weight: bold;
            padding: 0 10px;
            user-select: none; /* 드래그 방지 */
        }

        .page-indicator {
            margin: 0 5px;
}
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <header>
            <nav class="nav-container">
                <div class="logo">BLACK COFFEE</div>
                <ul class="nav-menu">
                    <li><a href="#">브랜드 소개</a></li>
                    <li><a href="#">메뉴 이야기</a></li>
                    <li><a href="#">커피 & 디저트</a></li>
                    <li><a href="#">멤버십 & 이벤트</a></li>
                    <li><a href="#">창업 안내</a></li>
                    <li><a href="#">새 소식 & 공지</a></li>
                </ul>
            </nav>
        </header>

        <main class="main-content">
            <div class="hero-section">
                <div class="image-slider">
                    <div class="coffee-image"> 
                        <img src="/img/광고페이지1.jpg" alt="광고사진1">                       
                    </div>                    
                </div>
                
                <div class="slider-control">
                    <span class="arrow left-arrow">←</span>
                    <span class="page-indicator">1 / 2</span>
                    <span class="arrow right-arrow">→</span>
                </div>
            </div>
        </main>
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