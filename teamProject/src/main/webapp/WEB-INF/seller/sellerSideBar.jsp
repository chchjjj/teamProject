<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String currentUri = request.getRequestURI(); %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>판매자마이페이지</title>

    <style>
        /* =======================
           🎨 Color Variables
        ======================= */
        :root {
            --espresso: #3E2723;
            --peony: #F4C9D6;
            --butter: #FFEDAC;
            --light-bg: #F4F4F4;
            --white: #FFFFFF;
        }

        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            margin-left: 250px;
            padding-top: 0;
        }

        /* =======================
           📚 Sidebar Navigation
        ======================= */
        .navBar {
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            height: 100vh;
            background-color: var(--espresso);
            display: flex;
            flex-direction: column;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            overflow-y: auto;
            animation: slideInLeft 0.3s ease;
        }

        /* Logo Area */
        .logoArea {
            background-color: rgba(0, 0, 0, 0.2);
            padding: 30px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logoArea img {
            max-width: 150px;
            height: auto;
            object-fit: contain;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logoArea img:hover {
            transform: scale(1.05);
        }

        /* Navigation Buttons */
        .navButton {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            gap: 5px;
        }

        .navButton button {
            background-color: transparent;
            color: var(--white);
            border: none;
            padding: 15px 25px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-align: left;
            border-left: 4px solid transparent;
            letter-spacing: 0.5px;
        }

        .navButton button:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-left-color: var(--peony);
            padding-left: 30px;
        }

        .navButton button.active {
            background-color: rgba(255, 255, 255, 0.15);
            border-left-color: var(--butter);
            font-weight: 600;
            color: var(--butter);
        }

        /* Icon animation */
        .navButton button::before {
            content: '▸ ';
            opacity: 0;
            margin-right: 5px;
            transition: opacity 0.3s ease;
        }

        .navButton button:hover::before,
        .navButton button.active::before {
            opacity: 1;
        }

        /* Logout / Withdrawal Section */
        .logOut {
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            background-color: rgba(0, 0, 0, 0.2);
        }

        .logOut button {
            width: 100%;
            background-color: var(--peony);
            color: var(--espresso);
            border: none;
            padding: 15px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
        }

        .logOut button:hover {
            background-color: #f0b8ca;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(244, 201, 214, 0.4);
        }

        .logOut button:active {
            transform: translateY(0);
        }

        /* Scrollbar */
        .navBar::-webkit-scrollbar {
            width: 6px;
        }

        .navBar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
        }

        /* Animation */
        @keyframes slideInLeft {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                margin-left: 0;
            }
            .navBar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
                width: 280px;
            }
            .navBar.active {
                transform: translateX(0);
            }
        }
    </style>
</head>

<body>
    

    <nav class="navBar" id="sidebar">
        <div class="logoArea">
            <a href="javascript:;" onclick="location.href='/main.do'">
                <img src="/img/로고.png" alt="로고">
            </a>
        </div>

        <div class="navButton">
            <button class="<%= currentUri.contains("/seller/storeList.do") ? "active" : "" %>" onclick="location.href='/seller/storeList.do'">가게 정보</button>
            <button class="<%= currentUri.contains("/seller/sales.do") ? "active" : "" %>" onclick="location.href='/seller/sales.do'">매출</button>
            <button class="<%= currentUri.contains("/seller/salesHistory.do") ? "active" : "" %>" onclick="location.href='/seller/salesHistory.do'">판매 내역</button>
            <button class="<%= currentUri.contains("/seller/sellerReview.do") ? "active" : "" %>" onclick="location.href='/seller/sellerReview.do'">리뷰 관리</button>
            <button class="<%= currentUri.contains("/seller/order/calendarView.do") ? "active" : "" %>" onclick="location.href='/seller/order/calendarView.do'">캘린더</button>
            <button class="<%= currentUri.contains("/seller/userUpdateInfo.do") ? "active" : "" %>" onclick="location.href='/seller/userUpdateInfo.do'">정보 수정</button>
            <button class="<%= currentUri.contains("/seller/sellerViewQnA.do") ? "active" : "" %>" onclick="location.href='/seller/sellerViewQnA.do'">Q&A 게시판</button>
            <button class="<%= currentUri.contains("/user/userMyPage.do") ? "active" : "" %>" onclick="location.href='/user/userMyPage.do'">구매자 마이페이지</button>
        </div>

        <div class="logOut">
            <button onclick="confirmAndRedirect(event)">회원탈퇴</button>
        </div>
    </nav>

    <script>
        // 모바일 토글
        function toggleMenu() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('active');
            document.body.classList.toggle('menu-open');
        }

        // 회원 탈퇴 확인
        function confirmAndRedirect(event) {
            event.preventDefault();
            const confirmDelete = confirm("정말로 회원 탈퇴하시겠습니까?\n모든 정보가 삭제되며 되돌릴 수 없습니다.");
            if (confirmDelete) {
                location.href = "http://localhost:8087/user/login.do";
            }
        }
    </script>
</body>
</html>
