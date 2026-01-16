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
        :root {
            --espresso: #3E2723;
            --peony: #F4C9D6;
            --butter: #FFEDAC;
            --light-bg: #F8F9FA;
            --white: #FFFFFF;
            --primary-color: var(--espresso);
            --secondary-color: var(--peony);
            --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.08);
            --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.12);
            --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.15);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
            background: linear-gradient(135deg, #F8F9FA 0%, #E9ECEF 100%);
            min-height: 100vh;
        }

        /* Header */
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 32px;
            background: linear-gradient(135deg, var(--white) 0%, #FAFAFA 100%);
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
        }

        .search-area {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-area input {
            padding: 10px 16px;
            border: 2px solid #E0E0E0;
            border-radius: 24px;
            font-size: 14px;
            transition: var(--transition);
            outline: none;
            width: 280px;
        }

        .search-area input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(62, 39, 35, 0.1);
        }

        /* Main Wrapper & Sidebar */
        .main-wrapper {
            display: flex;
            min-height: calc(100vh - 65px);
        }

        .sidebar {
            width: 240px;
            background: linear-gradient(180deg, var(--butter) 0%, #FFE89C 100%);
            flex-shrink: 0;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            padding-top: 80px;
            box-shadow: 4px 0 12px rgba(0, 0, 0, 0.05);
            z-index: 99;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0 12px;
        }

        .sidebar-menu li {
            margin-bottom: 4px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 14px 20px;
            text-decoration: none;
            color: var(--espresso);
            font-weight: 600;
            font-size: 15px;
            border-radius: 12px;
            transition: var(--transition);
            position: relative;
        }

        .sidebar-menu a:before {
            content: '●';
            margin-right: 12px;
            font-size: 8px;
            opacity: 0;
            transition: var(--transition);
        }

        .sidebar-menu a:hover {
            background-color: rgba(62, 39, 35, 0.08);
            transform: translateX(4px);
        }

        .sidebar-menu a:hover:before {
            opacity: 1;
        }

        .sidebar-menu .active a {
            background-color: var(--espresso);
            color: var(--white);
            box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
        }

        .sidebar-menu .active a:before {
            opacity: 1;
            color: var(--peony);
        }

        /* Content Area */
        .content-area {
            flex-grow: 1;
            padding: 40px;
            margin-left: 240px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 32px;
            color: var(--espresso);
            padding-bottom: 16px;
            border-bottom: 3px solid var(--espresso);
            display: inline-block;
            position: relative;
        }

        .page-title:after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--peony);
        }

        /* Store Card */
        .store-card {
            background: var(--white);
            border: 1px solid rgba(0, 0, 0, 0.06);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            position: relative;
            overflow: hidden;
        }

        .store-card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--peony) 0%, var(--butter) 100%);
            opacity: 0;
            transition: var(--transition);
        }

        .store-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--espresso);
        }

        .store-card:hover:before {
            opacity: 1;
        }

        .store-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
            padding-bottom: 10px;
            border-bottom: 1px solid #F5F5F5;
        }

        .store-name-section {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .store-name-section h3 {
            font-size: 16px;
            color: var(--espresso);
            font-weight: 700;
        }

        .membership-info span {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .membership-info .active {
            background: linear-gradient(135deg, var(--peony) 0%, #F0B8CA 100%);
            color: var(--espresso);
            box-shadow: 0 2px 8px rgba(244, 201, 214, 0.4);
        }

        .membership-info .inactive {
            background: linear-gradient(135deg, var(--espresso) 0%, #4a332f 100%);
            color: var(--white);
            box-shadow: 0 2px 8px rgba(62, 39, 35, 0.3);
        }

        .membership-info .inactive:hover {
            background: linear-gradient(135deg, #4a332f 0%, var(--espresso) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(62, 39, 35, 0.4);
        }

        .store-intro p {
            background: linear-gradient(135deg, #FAFAFA 0%, #F5F5F5 100%);
            border-left: 3px solid var(--peony);
            padding: 12px;
            border-radius: 6px;
            color: #555;
            margin-top: 8px;
            margin-bottom: 12px;
            font-size: 13px;
            line-height: 1.5;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        /* Buttons */
        .management-buttons {
            display: flex;
            gap: 6px;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #F0F0F0;
            justify-content: flex-start;
        }

        .management-buttons button {
            padding: 8px 12px;
            border: 1px solid var(--primary-color);
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            background-color: var(--white);
            color: var(--primary-color);
            position: relative;
            overflow: hidden;
        }

        .management-buttons button:before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: var(--primary-color);
            transform: translate(-50%, -50%);
            transition: width 0.5s, height 0.5s;
            z-index: 0;
        }

        .management-buttons button span {
            position: relative;
            z-index: 1;
        }

        .management-buttons button:hover:before {
            width: 300px;
            height: 300px;
        }

        .management-buttons button:hover {
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .management-buttons button:active {
            transform: translateY(0);
        }

        .management-buttons .primary-btn {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #F0B8CA 100%);
            color: var(--primary-color);
            border: 2px solid var(--secondary-color);
            box-shadow: 0 4px 12px rgba(244, 201, 214, 0.3);
        }

        .management-buttons .primary-btn:before {
            background: var(--espresso);
        }

        .management-buttons .primary-btn:hover {
            color: var(--white);
            box-shadow: 0 6px 20px rgba(244, 201, 214, 0.5);
        }

        /* 일반 버튼 */
        button {
            padding: 10px 20px;
            border: 2px solid #E0E0E0;
            background-color: var(--white);
            cursor: pointer;
            margin-left: 8px;
            border-radius: 24px;
            font-weight: 600;
            transition: var(--transition);
            color: #555;
        }

        button:hover {
            background-color: #F5F5F5;
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            font-size: 14px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
                padding-top: 0;
                background: linear-gradient(90deg, var(--butter) 0%, #FFE89C 100%);
            }

            .sidebar-menu {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-around;
                padding: 12px;
            }

            .sidebar-menu li {
                margin: 0;
                flex: 1 1 auto;
            }

            .sidebar-menu a {
                padding: 12px 16px;
                text-align: center;
                font-size: 13px;
                justify-content: center;
            }

            .sidebar-menu a:before {
                display: none;
            }

            .sidebar-menu .active a {
                border-bottom: 3px solid var(--peony);
            }

            .content-area {
                margin-left: 0;
                padding: 24px 16px;
            }

            .page-title {
                font-size: 24px;
                margin-bottom: 24px;
            }

            .management-buttons {
                flex-direction: column;
            }

            .store-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .search-area input {
                width: 100%;
                max-width: 200px;
            }
        }

        /* Loading Animation */
        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }

        .loading {
            animation: pulse 1.5s ease-in-out infinite;
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">마이페이지</h1>

                <div v-if="list.length === 0" class="empty-state loading">
                    <p>스토어 정보를 불러오는 중입니다...</p>
                </div>

                <div v-for="item in list" :key="item.storeId" class="store-card">
                    <div class="store-header">
                        <div class="store-name-section">
                            <h3>{{ item.storeName }}</h3>
                        </div>
                        <div class="membership-info">
                            <span 
                                v-if="membershipStatus[item.storeId]" 
                                class="active">
                                멤버십 중
                            </span>
                            <span 
                                v-else 
                                class="inactive"
                                @click="fnGoMembership(item.storeId)">
                                멤버십 가입하기
                            </span>
                        </div>
                    </div>

                    <div class="store-intro">
                        <p>{{ item.description }}</p>
                    </div>

                    <div class="management-buttons">
                        <button @click="fnGoProductList(item.storeId)">
                            <span>상품 관리</span>
                        </button>
                        <button @click="fnGoStoreUpdate(item.storeId)" class="primary-btn">
                            <span>수정하기</span>
                        </button>
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
            storeId: "",
            membershipStatus: {} // 각 스토어의 멤버십 상태를 저장
        };
    },
    methods: {
        fnalert() {
            alert("아직 준비중입니다!");
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
                    // 각 스토어의 멤버십 상태 설정
                    self.list.forEach(item => {
                        // membershipYn 또는 membership 필드명 둘 다 지원
                        self.membershipStatus[item.storeId] = 
                            item.membershipYn === 'Y' || item.membership === 'Y';
                    });
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
        },
        fnGoMembership(storeId) {
            if (!storeId) {
                alert("선택된 가게 ID가 없습니다.");
                return;
            }
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/product/membershipManage.do';
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

</html>