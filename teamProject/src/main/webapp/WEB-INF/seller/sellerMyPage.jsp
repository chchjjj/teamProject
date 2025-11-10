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
                /* 기본 스타일 초기화 및 레이아웃 설정 */
                body {
                    margin: 0;
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: #f4f4f4;
                }

                /* 헤더 영역 스타일 */
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

                /* 메인 컨테이너 (사이드바 + 콘텐츠) */
                .main-wrapper {
                    display: flex;
                    min-height: calc(100vh - 50px);
                }

                /* 좌측 메뉴 (사이드바) */
                .sidebar {
                    width: 220px;
                    background-color: #ffedac;
                    /* 기본 컬러 */
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
                    /* 강조 색상 hover */
                }

                .sidebar-menu .active a {
                    background-color: #3e2723;
                    /* 강조 색상 */
                    color: white;
                    border-left: 5px solid #000;
                    padding-left: 15px;
                }

                /* 우측 콘텐츠 영역 */
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

                /* 가게 정보 카드 스타일 */
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
                    <div class="content-area">
                        <h1 class="page-title">마이페이지 (판매자)</h1>

                        <div v-for="item in list" :key="item.id" class="store-card">
                            <div class="store-header">
                                <div class="store-name-section">
                                    <h3>{{ item.storeName }}</h3>
                                   
                                </div>
                                <div class="membership-info">
                                    <span>멤버십 사용 중</span>
                                    <!-- <span style="font-weight: bold; color: #007bff;" >{{ item.membership  }}까지</span> -->
                                </div>
                            </div>

                            <div class="store-intro">
                                <p>{{ item.description }}</p>
                            </div>

                            <div class="management-buttons">


                                <div class="management-buttons">
                                    <button @click="fnGoProductList(item.storeId)">
                                        상품 관리
                                    </button>
                                    <button class="primary-btn">수정하기</button>
                                </div>
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
                    fnalert: function () {
                        alert("아직준비중입니다. !!");
                    },
                    fnList: function () {
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
                                // ⭐️ 중요: 서버 응답에 storeId가 포함되어 있어야 합니다.
                                self.list = data.list;
                                console.log("가게 목록 조회 성공:", data);
                            },
                            error: function (xhr, status, error) {
                                console.error("가게 목록 조회 실패:", error);
                                self.list = [];
                            }
                        });
                    },

                    /** ⭐️ 새로 추가된 함수: storeId를 POST 방식으로 /seller/productlist.do로 전송 */
                    fnGoProductList: function (storeId) {
                        // storeId가 유효한지 확인
                        if (!storeId) {
                            alert("선택된 가게 ID가 없습니다.");
                            return;
                        }

                        // 폼 생성 및 POST 전송 (GET 방식의 location.href 대신 사용)
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '/seller/productlist.do'; // 상품 목록 뷰 URL

                        // storeId를 숨겨진 입력 필드(input)로 추가
                        const hiddenInput = document.createElement('input');
                        hiddenInput.type = 'hidden';
                        hiddenInput.name = 'storeId'; // 서버에서 @RequestParam("storeId")로 받게 됨
                        hiddenInput.value = storeId;

                        form.appendChild(hiddenInput);
                        document.body.appendChild(form); // 폼을 문서에 잠시 추가
                        form.submit(); // POST 요청 전송
                        document.body.removeChild(form); // 전송 후 폼 제거
                    }
                },
                mounted() {
                    this.fnList();
                }
            });

            app.mount('#app');
        </script>