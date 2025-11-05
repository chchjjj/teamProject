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
/* 4. 푸터 스타일 */
footer {
    width: 100%;
    /* 푸터 영역의 배경색을 메뉴바(#3E2723)보다 살짝 밝은 톤으로 설정 */
    background-color: #3E2723; 
    color: #f0f0f0; /* 텍스트 색상을 밝게 */
    padding: 5px 0;
    height: 230px;
}

.footer-inner {
    max-width: 1200px;
    margin: 0 auto;
    padding: 25px 20px;
    display: flex;
    justify-content: space-between; /* 항목들을 가로로 배치 */
    gap: 30px; /* 항목 간 간격 */
}

/* 푸터 내부 타이틀 스타일 */
.footer-inner h3, .footer-inner h4 {
    color: #FFEDAC; /* 밝은 노란색으로 제목 강조 */
    font-family: 'SebangGothic', sans-serif;
    margin-bottom: 15px;
}

.footer-logo {
    font-size: 24px;
    margin-bottom: 20px;
}

/* 회사 정보 영역 */
.footer-info p {
    font-size: 13px;
    line-height: 1.8;
}

.company-name {
    font-weight: bold;
    margin-bottom: 5px;
}

html, body {
    margin: 0; /* 기본 마진 제거 */
    padding: 0; /* 기본 패딩 제거 */
    height: 100%; /* 필수: 뷰포트 높이만큼 늘어나도록 설정 */
}

body {
    display: flex; /* body를 Flex 컨테이너로 설정 */
    flex-direction: column; /* 세로 정렬 */
    /* height: 100%; 대신 min-height: 100vh; 를 사용해도 됩니다. */
    min-height: 100vh; /* 뷰포트 전체 높이만큼 최소 높이 지정 (100% 대신 100vh 권장) */
}

/* 헤더, 본문, 푸터가 다음과 같은 HTML 구조를 가진다고 가정 */
/* <header>...</header> */
/* <main>...</main> */
/* <footer>...</footer> */

main {
    flex-grow: 1; /* 본문 컨텐츠 영역이 남은 공간을 모두 차지하도록 확장 */
    /* main 영역이 footer를 밀어내는 역할을 합니다. */
}

/* ⚠️ 핵심: Vue 앱 래퍼 요소(#app)가 남은 공간을 모두 차지하도록 설정 */
#app {
    flex-grow: 1; /* 남은 공간을 모두 차지하도록 확장 */
}

/* 푸터의 높이를 고정해야 한다면 flex-shrink: 0;도 추가할 수 있습니다. */
footer {
    flex-shrink: 0; /* 푸터는 줄어들지 않고 고정 높이 유지 */
    /* (기존 푸터 CSS 유지) */
}


    </style>
</head>
<body>
    <div id="footer">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <footer>
    <div class="footer-inner">
        <div class="footer-info">
            <p class="footer-logo" style="font-size: 20px;">디저트 연구소</p>
            <p class="company-name">디저트연구소 컴퍼니</p>
            <p class="address">
                주소: 서울특별시 강남구 베이킹로 1234 (01234)
            </p>
            <p class="registration-info">
                사업자등록번호: 123-45-67890 | 통신판매업신고: 2024-서울강남-00001
            </p>
            <p class="copyright">
                &copy; 2025 Dessert Lab Inc. All Rights Reserved.
            </p>
        </div>

        <div class="footer-links">
            <h4>고객 센터</h4>
            <p class="cs-phone">1588-XXXX</p>
            <p class="cs-time">평일 09:00 ~ 18:00 (주말/공휴일 휴무)</p>

        </div>

    </div>
</footer>
    </div>
</body>
</html>

<script>
    const footer = Vue.createApp({
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

    footer.mount('#footer');
</script>