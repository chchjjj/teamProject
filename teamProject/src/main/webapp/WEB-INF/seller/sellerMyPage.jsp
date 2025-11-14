<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 고객 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
   <style>
                /* Page Specific Styles (새로운 디자인 적용) */
                :root {
                    --espresso: #3E2723;
                    --peony: #F4C9D6;
                    --butter: #FFEDAC;
                    --light-bg: #F4F4F4;
                    --white: #FFFFFF;
                    --primary-color: var(--espresso);
                    /* 주요 버튼 색상을 에스프레소로 통일 */
                    --secondary-color: var(--peony);
                    /* 보조 버튼 색상을 피오니로 통일 */
                }

                body {
                    margin: 0;
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: var(--light-bg);
                }

                /* 1. Header (기존 스타일 유지 및 색상 변수 적용) */
                .header-container {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 10px 20px;
                    background-color: var(--white);
                    border-bottom: 1px solid #ddd;
                }

                .search-area {
                    display: flex;
                    align-items: center;
                }

                .search-area input {
                    padding: 8px;
                    border: 1px solid #ccc;
                    margin-right: 5px;
                    border-radius: 4px;
                }

                /* 2. Main Wrapper & Sidebar (색상 변수 적용) */
                .main-wrapper {
                    display: flex;
                    min-height: calc(100vh - 50px);
                    /* 헤더 높이만큼 조정 */
                }

                .sidebar {
                    width: 220px;
                    background-color: var(--butter);
                    /* 버터색 적용 */
                    flex-shrink: 0;
                    position: fixed;
                    top: 0;
                    left: 0;
                    bottom: 0;
                    padding-top: 20px;
                }

                .sidebar-menu {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                }

                .sidebar-menu li {
                    margin: 0;
                    padding: 0;
                }

                .sidebar-menu a {
                    display: block;
                    padding: 15px 20px;
                    text-decoration: none;
                    color: var(--espresso);
                    /* 글자색을 에스프레소로 변경 */
                    font-weight: bold;
                    transition: background-color 0.2s, color 0.2s;
                }

                .sidebar-menu a:hover {
                    background-color: var(--espresso);
                    color: var(--white);
                }

                .sidebar-menu .active a {
                    background-color: var(--espresso);
                    color: var(--white);
                    border-left: 5px solid var(--peony);
                    /* 활성 표시 색상을 피오니로 변경 */
                    padding-left: 15px;
                }

                /* 3. Content Area */
                .content-area {
                    flex-grow: 1;
                    padding: 30px;
                    background-color: var(--light-bg);
                    /* 배경색을 light-bg로 유지 */
                    margin-left: 220px;
                }

                .page-title {
                    font-size: 24px;
                    font-weight: 300;
                    margin-bottom: 20px;
                    color: var(--espresso);
                    /* 제목 색상 적용 */
                    padding-bottom: 10px;
                    border-bottom: 2px solid var(--espresso);
                }

                /* 4. Store Card (orderCard 스타일 반영) */
                .store-card {
                    background-color: var(--white);
                    border: 1px solid #e0e0e0;
                    border-radius: 8px;
                    padding: 20px;
                    margin-bottom: 20px;
                    transition: all 0.3s ease;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                }

                .store-card:hover {
                    box-shadow: 0 3px 15px rgba(62, 39, 35, 0.1);
                    border-color: var(--espresso);
                }

                .store-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 15px;
                    padding-bottom: 12px;
                    border-bottom: 2px solid var(--butter);
                    /* 버터색 구분선 적용 */
                }

                .store-name-section {
                    display: flex;
                    align-items: center;
                }

                .store-name-section h3 {
                    margin: 0;
                    font-size: 18px;
                    color: var(--espresso);
                    /* 상점 이름 색상 적용 */
                    margin-right: 15px;
                }

                .membership-info span {
                    /* statusBadge 컨셉 적용 */
                    display: inline-block;
                    padding: 4px 10px;
                    border-radius: 15px;
                    font-size: 12px;
                    font-weight: 600;
                    background-color: var(--peony);
                    /* 피오니 배경색 */
                    color: var(--espresso);
                    /* 에스프레소 글자색 */
                }

                .store-intro p {
                    background-color: #fafafa;
                    border-left: 3px solid var(--peony);
                    /* 피오니색 강조선 적용 */
                    padding: 15px;
                    border-radius: 4px;
                    color: #555;
                    margin-top: 10px;
                    margin-bottom: 20px;
                    font-size: 14px;
                }

                /* 5. Buttons (actionButtons 스타일 반영) */
                .management-buttons {
                    display: 200px;
                    gap: 8px;
                    margin-top: 15px;
                    padding-top: 15px;
                    border-top: 1px solid #f0f0f0;
                }

                .management-buttons button {
                    flex: 1;
                    padding: 10px 15px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    background-color: var(--white);
                    color: var(--primary-color);
                    border: 1px solid var(--primary-color);
                }

                .management-buttons button:hover {
                    background-color: var(--primary-color);
                    color: var(--white);
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
                }

                .management-buttons .primary-btn {
                    /* 수정하기 버튼 (강조) */
                    background-color: var(--secondary-color);
                    /* 피오니 배경색 */
                    color: var(--primary-color);
                    /* 에스프레소 글자색 */
                    border: 1px solid var(--secondary-color);
                }

                .management-buttons .primary-btn:hover {
                    background-color: #f0b8ca;
                    /* 약간 어두운 피오니 */
                    color: var(--primary-color);
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(244, 201, 214, 0.4);
                }

                /* 일반 버튼 (검색 버튼 등에 사용될 수 있는 스타일) */
                button {
                    padding: 8px 15px;
                    /* 약간 더 크게 조정 */
                    border: 1px solid #ccc;
                    background-color: #f0f0f0;
                    cursor: pointer;
                    margin-left: 5px;
                    border-radius: 4px;
                    font-weight: 500;
                    transition: all 0.2s ease;
                }

                button:hover {
                    background-color: #e0e0e0;
                }

                /* Responsive adjustments (새로운 CSS의 미디어 쿼리 적용) */
                @media (max-width: 768px) {
                    .sidebar {
                        position: static;
                        width: 100%;
                        height: auto;
                        padding-top: 10px;
                    }

                    .sidebar-menu {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: space-around;
                        padding: 0 10px;
                    }

                    .sidebar-menu a {
                        padding: 10px 15px;
                        text-align: center;
                        border-left: none !important;
                        border-bottom: 3px solid transparent;
                    }

                    .sidebar-menu .active a {
                        border-left: none;
                        border-bottom: 3px solid var(--peony);
                        padding-left: 15px;
                    }

                    .content-area {
                        margin-left: 0;
                        padding: 20px 15px;
                    }

                    .management-buttons {
                        flex-direction: column;
                    }

                    .store-header {
                        flex-direction: column;
                        align-items: flex-start;
                        gap: 10px;
                    }
                }
            </style>
</head>

<body>
    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">마이페이지 (판매자)</h1>

                <div v-for="item in list" :key="item.storeId" class="store-card">
                    <div class="store-header">
                        <div class="store-name-section">
                            <h3>{{ item.storeName }}</h3>
                        </div>
                        <div class="membership-info">
                            <span>멤버십 사용 중</span>
                        </div>
                    </div>

                    <div class="store-intro">
                        <p>{{ item.description }}</p>
                    </div>

                    <div class="management-buttons">
                        <button @click="fnGoProductList(item.storeId)">
                            상품 관리
                        </button>
                        <button @click="fnGoStoreUpdate(item.storeId)" class="primary-btn">수정하기</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>

<script>
const app = Vue.createApp({
    data() {
        return {
            list: [],
            userId: "${sessionId}",
            storeName: "",
            storeId: ""
        };
    },
    methods: {
        fnalert() {
            alert("아직준비중입니다. !!");
        },
        fnList() {
            let self = this;
            let param = {
                userId: self.userId,
                storeName: self.storeName,
                storeId: self.storeId
            };
            $.ajax({
                url: "/store/list.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function (data) {
                    self.list = data.list || [];
                    //console.log("가게 목록 조회 성공:", data);
                },
                error: function (xhr, status, error) {
                    console.error("가게 목록 조회 실패:", error);
                    self.list = [];
                }
            });
        },
        fnGoProductList(storeId) {
            if (!storeId) {
                alert("선택된 가게 ID가 없습니다.");
                return;
            }
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/seller/productlist.do';
            const hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = 'storeId';
            hiddenInput.value = storeId;
            form.appendChild(hiddenInput);
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
        },
        fnGoStoreUpdate(storeId) {
            if (!storeId) {
                alert("선택된 가게 ID가 없습니다.");
                return;
            }
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/seller/storeInfoupdateInfo.do';
            const hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = 'storeId';
            hiddenInput.value = storeId;
            form.appendChild(hiddenInput);
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
        }
    },
    mounted() {
        this.fnList();
    }
});

app.mount('#app');
</script>
