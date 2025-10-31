<!-- sidebar.jsp -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String currentUri = request.getRequestURI(); %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사이드바</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #ffedac; /* 기본 색상 */
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        .logo {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo img {
            width: 80%;
            max-width: 150px;
            height: auto;
        }

        .sidebar-menu {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu li {
            padding: 0;
            margin: 0;
        }

        .sidebar-menu li a {
            display: block;
            padding: 15px 20px;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            color: white; /* 글자 색상 */
            background-color: #3e2723; /* 기본 강조색 */
            transition: background-color 0.3s;
        }

        /* 활성화 메뉴는 그대로 강조색 유지 */
        .sidebar-menu .active a {
            background-color: #3e2723; /* 강조 색상 */
        }

        /* 메뉴에 마우스 hover 시 조금 밝게 */
        .sidebar-menu li a:hover {
            background-color: #5d4037; /* 약간 밝게 변경 */
        }

        .sidebar-menu li:last-child {
            margin-top: 50px;
        }
    </style>
</head>

<body>

    <div class="sidebar">
        <!-- 로고 -->
        <div class="logo">
            <a href="javascript:;" onclick="location.href='/main.do'">
                <img src="/img/로고.png" alt="쇼핑몰 로고">
            </a>
        </div>

        <!-- 사이드바 메뉴 -->
        <ul class="sidebar-menu">
            <li class="<%= currentUri.contains("/seller/storeList.do") ? "active" : "" %>">
                <a href="javascript:;" onclick="location.href='/seller/storeList.do'">가게 정보</a>
            </li>
            <li class="<%= currentUri.contains("/seller/sales.do") ? "active" : "" %>">
                <a href="javascript:;" onclick="location.href='/seller/sales.do'">매출</a>
            </li>
            <li class="<%= currentUri.contains("/seller/salesHistory.do") ? "active" : "" %>">
                <a href="#">판매 내역</a>
            </li>
            <li class="<%= currentUri.contains("/seller/customer.do") ? "active" : "" %>">
                <a href="#">고객 관리(채팅)</a>
            </li>
            <li class="<%= currentUri.contains("/seller/review.do") ? "active" : "" %>">
                <a href="#">리뷰 관리(임시)</a>
            </li>
            <li class="<%= currentUri.contains("/seller/calendar.do") ? "active" : "" %>">
                <a href="#">캘린더</a>
            </li>
            <li class="<%= currentUri.contains("/seller/edit.do") ? "active" : "" %>">
                <a href="#">정보 수정</a>
            </li>
            <li class="<%= currentUri.contains("/seller/delete.do") ? "active" : "" %>">
                <a href="#">회원탈퇴</a>
            </li>
        </ul>
    </div>

</body>

</html>
