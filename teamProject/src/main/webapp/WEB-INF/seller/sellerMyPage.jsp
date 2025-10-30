<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 고객 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* 기본 스타일 초기화 및 레이아웃 설정 */
        body { margin: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f4f4; }
        
        /* 헤더 영역 스타일 */
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: white;
            border-bottom: 1px solid #ddd;
        }
        .search-area { display: flex; align-items: center; }
        .search-area input { padding: 8px; border: 1px solid #ccc; margin-right: 5px; }
        
        /* 메인 컨테이너 (사이드바 + 콘텐츠) */
        .main-wrapper {
            display: flex; /* Flexbox로 좌우 영역 분할 */
            min-height: calc(100vh - 50px); /* 헤더 높이를 제외한 최소 높이 */
        }

        /* 좌측 메뉴 (사이드바) */
        .sidebar {
            width: 200px;
            background-color: #e9e9e9;
            padding: 20px 0;
            flex-shrink: 0; /* 너비가 줄어들지 않도록 고정 */
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
            color: #333;
            font-weight: bold;
            transition: background-color 0.2s;
        }
        .sidebar-menu a:hover {
            background-color: #d1d1d1;
        }
        /* 현재 활성화된 메뉴 스타일 */
        .sidebar-menu .active a {
            background-color: #6a95f9; /* 활성화 색상 */
            color: white;
            border-left: 5px solid #0056b3;
            padding-left: 15px;
        }

        /* 우측 콘텐츠 영역 */
        .content-area {
            flex-grow: 1; /* 남은 공간 모두 차지 */
            padding: 30px;
            background-color: white;
        }
        .page-title {
            font-size: 24px;
            font-weight: 300;
            margin-bottom: 20px;
        }

        /* 가게 정보 카드 스타일 */
        .store-card {
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
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
        
        /* 버튼 공통 스타일 */
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
            
            <div class="sidebar">
                <ul class="sidebar-menu">
                    <li class="active"><a href="#" >가게 정보</a></li>
                    <li><a href="#">매출</a></li>
                    <li><a href="#">판매 내역</a></li>
                    <li ><a href="#">고객 관리(채팅)</a></li>
                    <li><a href="#">리뷰 관리(임시)</a></li>
                    <li><a href="#">캘린더</a></li>
                    <li><a href="#">정보 수정</a></li>
                    <li style="margin-top: 50px;"><a href="#">회원탈퇴</a></li>
                </ul>
            </div>
            
            <div class="content-area">
                <h1 class="page-title">마이페이지 (판매자)</h1>
                
                <div v-for="item in list" :key="item.id" class="store-card">
                    <div class="store-header">
                        <div class="store-name-section">
                            <h3>{{ item.storeName  }}</h3>
                            <button>가게 이름 수정하기</button>
                        </div>
                        <div class="membership-info">
                            <span>멤버십 사용 중</span>
                            <!-- 조인해야해서 잠시 주석할게요 -->
                            <!-- <span style="font-weight: bold; color: #007bff;" >{{ item.membership  }}까지</span> -->
                        </div>
                    </div>
                    
                    <div class="store-intro">
                        <p>{{ item.description }}</p>
                    </div>
                    
                    <div class="management-buttons">
                        <button>프로필 이미지 수정</button>
                        <button>배너 이미지 수정</button>
                        <button>상품 관리</button>
                        <button class="primary-btn">수정하기</button>
                    </div>
                </div>

            </div>
        </div>

    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
            list : [],
            userId : '',
            
            };
        },
        methods: {
           
            fnList: function () {
                let self = this;
                let param = {
                    userId: 'user04'
                    // 로그인해서 정보를 받아야하는데 로그인을 못해서 임시로 했어요
                };
                $.ajax({
                    url: "/store/list.dox", 
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                         self.list = data.list;
                    },
                     error: function (xhr, status, error) {
                        console.error("가게 목록 조회 실패:", error);
                        self.list = []; 
                    }
                });
            }
        }, // methods
        mounted() {
            // 페이지 로딩 시 목록 데이터를 가져오려면 아래 주석을 해제합니다.
            this.fnList();
        }
    });

    app.mount('#app');
</script>