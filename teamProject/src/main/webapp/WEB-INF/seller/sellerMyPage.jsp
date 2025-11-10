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
        body {
            margin: 0;
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f4f4f4;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: white;
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
        }

        .main-wrapper {
            display: flex;
            min-height: calc(100vh - 50px);
        }

        .sidebar {
            width: 220px;
            background-color: #ffedac;
            flex-shrink: 0;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            padding-top: 20px;
        }

        .sidebar-menu li {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .sidebar-menu a {
            display: block;
            padding: 15px 20px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            transition: background-color 0.2s;
        }

        .sidebar-menu a:hover {
            background-color: #3e2723;
        }

        .sidebar-menu .active a {
            background-color: #3e2723;
            color: white;
            border-left: 5px solid #000;
            padding-left: 15px;
        }

        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: white;
            margin-left: 220px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 300;
            margin-bottom: 20px;
        }

        .store-card {
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .store-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .store-name-section {
            display: flex;
            align-items: center;
        }

        .store-name-section h3 {
            margin: 0;
            font-size: 18px;
            margin-right: 15px;
        }

        .membership-info {
            font-size: 14px;
            color: #666;
        }

        .store-intro p {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            color: #555;
            margin-top: 10px;
            margin-bottom: 20px;
        }

        .management-buttons button {
            padding: 8px 15px;
            border: 1px solid #ccc;
            background-color: white;
            cursor: pointer;
            margin-right: 5px;
            border-radius: 4px;
        }

        .management-buttons .primary-btn {
            background-color: #007bff;
            color: white;
            border: 1px solid #007bff;
        }

        button {
            padding: 5px 10px;
            border: 1px solid #ccc;
            background-color: #f0f0f0;
            cursor: pointer;
            margin-left: 5px;
            border-radius: 4px;
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
                    console.log("가게 목록 조회 성공:", data);
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
