<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 판매자 전용 사이드바 포함 (경로가 정확하다는 가정 하에 작성) --%>
<%@ include file="/WEB-INF/main/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 리뷰 관리</title>
    <%-- jQuery 및 Vue.js 라이브러리 로드 --%>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <style>
        /* 기본 스타일 및 레이아웃 (이전 스타일 유지) */
        body { margin: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f4f4; }
        
        /* 헤더 영역 스타일 (이미지 상단 반영) */
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
            /* 사이드바가 고정(fixed)되어 있으므로, 100vh 대신 flex-grow: 1을 이용해 콘텐츠 영역 채우기 */
            min-height: 100vh;
        }
        
        /* 우측 콘텐츠 영역 */
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: white;
            /* 사이드바 폭만큼 왼쪽 마진 설정 (이전 CSS 기반) */
            margin-left: 220px; 
            box-sizing: border-box;
        }

        .page-title {
            font-size: 24px;
            font-weight: 300;
            margin-bottom: 20px;
        }

        /* === 리뷰 카드 전용 스타일 (디자인 이미지 반영) === */
        .review-card {
            display: flex;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #e0e0e0; /* 이미지의 밝은 회색 배경 반영 */
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .review-image-area {
            width: 150px;
            height: 150px;
            background-color: #ccc; /* 후기사진 회색 블록 */
            margin-right: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #555;
            font-weight: bold;
            flex-shrink: 0;
        }

        .review-content-area {
            flex-grow: 1;
            position: relative;
        }

        .review-meta {
            margin-bottom: 10px;
            font-size: 14px;
            color: #333;
        }

        .review-meta strong {
             margin-right: 15px;
        }

        .review-meta span {
            color: #666;
        }

        .review-body {
            font-size: 16px;
            margin-top: 5px;
            margin-bottom: 20px;
            color: #333;
        }

        .review-rating {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        
        .delete-button {
            position: absolute;
            top: 5px;
            right: 5px;
            padding: 5px 10px;
            border: 1px solid #c0c0c0;
            background-color: #f0f0f0; 
            color: #555;
            cursor: pointer;
            border-radius: 4px;
            font-size: 12px;
        }
        
        /* 페이지네이션 스타일 */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
        .pagination a {
            margin: 0 5px;
            padding: 5px 10px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
            min-width: 20px;
            text-align: center;
        }
        .pagination .current {
            background-color: #555;
            color: white;
            border: 1px solid #555;
        }
    </style>
</head>

<body>
    <%-- 이미지의 상단 헤더 영역 구성 --%>
    <div class="header-container">
        <div class="search-area">
            <%-- 로고/사이트명 영역 --%>
            <h1 style="font-size: 20px; margin: 0; color: #333;">디저트 연구소</h1>
            <input type="text" placeholder="검색 키워드를 입력해주세요" style="margin-left: 30px;">
            <button>검색</button>
        </div>
        <div>
            <span>2.체포보</span>
            <span style="margin-left: 15px;">OOO님 환영합니다</span>
            <a href="#" style="text-decoration: none; font-size: 20px; margin-left: 10px;">👤</a>
        </div>
    </div>
    
    <div id="app">
        <div class="main-wrapper">
            <%-- 사이드바는 sellerSideBar.jsp에 의해 채워집니다. --%>
            
            <div class="content-area">
                <h1 class="page-title" style="display: none;">리뷰 관리</h1> <%-- 제목은 디자인에 명시되어 있지 않아 숨김처리 --%>
                
                <%-- 리뷰 목록 출력 영역 --%>
                <div v-if="reviewList.length > 0">
                    <div v-for="review in reviewList" :key="review.REVIEW_ID" class="review-card">
                        <div class="review-image-area">
                            후기사진
                            <%-- 실제 이미지 경로가 있다면 <img :src="review.IMAGE_URL" alt="리뷰 사진"> 사용 --%>
                        </div>
                        <div class="review-content-area">
                            <div class="review-meta">
                                <strong>{{ review.USER_ID }} (닉네임)</strong>
                                <span>작성일: {{ review.CDATETIME }}</span>
                            </div>
                            <div class="review-body">
                                {{ review.REVIEW_CONTENT }}
                            </div>
                            <div class="review-rating">
                                별점 : {{ review.RATING }}
                            </div>
                            <button @click="fnDeleteReview(review.REVIEW_ID)" class="delete-button">
                                삭제(삭제요청)
                            </button>
                        </div>
                    </div>
                </div>
                <div v-else>
                    <p style="text-align: center; padding: 50px; color: #666; background-color: #f9f9f9; border-radius: 5px;">아직 받은 리뷰가 없습니다.</p>
                </div>

                <%-- 페이지네이션 영역 (이미지 참조: <12345678>) --%>
                <div class="pagination">
                    <a href="#">&lt;</a>
                    <a href="#" class="current">1</a>
                    <a href="#">2</a>
                    <a href="#">3</a>
                    <a href="#">4</a>
                    <a href="#">5</a>
                    <a href="#">6</a>
                    <a href="#">7</a>
                    <a href="#">8</a>
                    <a href="#">&gt;</a>
                </div>
                
            </div>
        </div>
    </div>
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 첫 번째 SQL 쿼리 분석 결과에 따라 컬럼명이 대문자로 가정됨
                reviewList: [
                    // Vue 데이터 테스트를 위한 임시 더미 데이터 (주석 처리 또는 제거 후 사용)
                    /*
                    { REVIEW_ID: 1, USER_ID: 'user1', CDATETIME: '2025-10-25', REVIEW_CONTENT: '진짜 맛있어요! 포장도 깔끔하고 다음에 또 주문할게요.', RATING: 4 },
                    { REVIEW_ID: 2, USER_ID: 'user_kim', CDATETIME: '2025-10-20', REVIEW_CONTENT: '전체적으로 만족합니다. 진상 후기 내용', RATING: 1 }
                    */
                ],
                userId: "${sessionId}", // 서버 세션에서 판매자 ID를 가져옴
            };
        },
        methods: {
            /**
             * 판매자에게 달린 리뷰 목록을 서버에서 조회합니다.
             */
            fnReviewList: function () {
                let self = this;
                let param = {
                    userId: self.userId
                };
                
                // 백엔드 API 엔드포인트를 /review/list.dox 로 가정합니다.
                $.ajax({
                    url: "/review/list.dox", 
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // 서버 응답 형태가 { list: [...] } 형태라고 가정합니다.
                        self.reviewList = data.list; 
                        console.log("리뷰 목록 로드 성공:", data);
                    },
                    error: function (xhr, status, error) {
                        console.error("리뷰 목록 조회 실패:", error);
                        // 실제 서비스에서는 사용자에게 오류를 알리는 처리가 필요합니다.
                    }
                });
            },
            
            /**
             * 리뷰 삭제 요청 버튼 클릭 시 처리 로직
             */
            fnDeleteReview: function(reviewId) {
                if (confirm(reviewId + "번 리뷰를 삭제 요청 목록에 추가하시겠습니까?")) {
                   // 여기에 서버로 삭제 요청을 보내는 Ajax 코드를 구현합니다.
                   alert("리뷰 ID: " + reviewId + " 삭제 요청 처리 (통신 로직 구현 필요)");
                }
            }
        },
        mounted() {
            // 페이지 로드 시 리뷰 목록을 즉시 조회
            this.fnReviewList();
        }
    });

    app.mount('#app');
</script>

</html>