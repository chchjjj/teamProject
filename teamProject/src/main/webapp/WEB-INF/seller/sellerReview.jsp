<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 리뷰 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
   <style>
    /* ---------------------------------------------------- */
    /* 1. Color Variables & Global Styles (Espresso Theme) */
    /* ---------------------------------------------------- */
    :root {
        --espresso: #3E2723; /* 주요 색상: 짙은 갈색 */
        --peony: #F4C9D6; /* 보조 색상: 분홍색 */
        --butter: #FFEDAC; /* 배경 및 하이라이트: 버터색 */
        --light-bg: #F4F4F4; /* 밝은 배경 */
        --white: #FFFFFF;
        --primary-color: var(--espresso);
        --secondary-color: var(--peony);
    }

    body {
        margin: 0;
        font-family: 'Malgun Gothic', sans-serif;
        background-color: var(--light-bg);
    }

    /* ---------------------------------------------------- */
    /* 2. Layout & Header & Sidebar */
    /* ---------------------------------------------------- */
    .header-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 20px;
        background-color: var(--white);
        /* 흰색 적용 */
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

    .main-wrapper {
        display: flex;
        /* min-height를 100vh로 설정하여 푸터가 없어도 전체 화면을 차지하게 함 */
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
        padding-left: 15px;
    }

    .content-area {
        flex-grow: 1;
        padding: 30px;
        background-color: var(--light-bg);
        /* light-bg로 유지 */
        margin-left: 220px;
        box-sizing: border-box;
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


    /* ---------------------------------------------------- */
    /* 3. Review Card Styles (New Design 적용) */
    /* ---------------------------------------------------- */
    .review-card {
        display: flex;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 8px;
        background-color: var(--white);
        /* 흰색 배경으로 변경 */
        border: 1px solid #e0e0e0;
        /* 테두리 추가 */
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        /* 그림자 강화 */
        transition: all 0.3s ease;
    }

    .review-card:hover {
        box-shadow: 0 4px 15px rgba(62, 39, 35, 0.1);
        border-color: var(--peony);
        /* 호버 시 피오니색 강조 */
    }

    .review-image-area {
        width: 120px;
        /* 크기 약간 줄임 */
        height: 120px;
        /* 크기 약간 줄임 */
        background-color: var(--butter);
        /* 버터색 배경 적용 */
        border: 1px solid var(--peony);
        /* 피오니색 테두리 적용 */
        margin-right: 20px;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--espresso);
        /* 에스프레소 폰트 */
        font-weight: bold;
        flex-shrink: 0;
        font-size: 13px;
    }

    .review-content-area {
        flex-grow: 1;
        position: relative;
    }

    .review-meta {
        margin-bottom: 10px;
        font-size: 14px;
        color: var(--primary-color);
        /* 에스프레소 색상 적용 */
        padding-bottom: 5px;
        border-bottom: 1px dashed var(--butter);
        /* 버터색 점선 구분선 */
    }

    .review-meta strong {
        margin-right: 15px;
        color: var(--primary-color);
    }

    .review-meta span {
        color: #666;
    }

    .review-body {
        font-size: 16px;
        margin-top: 5px;
        margin-bottom: 15px;
        /* 간격 조정 */
        color: #333;
    }

    .review-rating {
        font-size: 22px;
        /* 폰트 크기 키움 */
        font-weight: bold;
        color: var(--peony);
        /* 피오니색으로 별점 강조 */
        display: block;
        /* 별점 단독 줄 사용 */
    }

    .delete-button {
        position: absolute;
        top: 0px;
        /* 위치 조정 */
        right: 0px;
        padding: 8px 12px;
        /* 버튼 크기 조정 */
        border: 1px solid var(--primary-color);
        /* 에스프레소 테두리 */
        background-color: var(--white);
        /* 흰색 배경 */
        color: var(--primary-color);
        /* 에스프레소 글자색 */
        cursor: pointer;
        border-radius: 6px;
        /* 둥근 모서리 */
        font-size: 13px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .delete-button:hover {
        background-color: var(--peony);
        border-color: var(--peony);
        color: var(--primary-color);
        transform: translateY(-1px);
    }

    /* ---------------------------------------------------- */
    /* 4. Pagination (New Design 적용) */
    /* ---------------------------------------------------- */
    .pagination {
        display: flex;
        justify-content: center;
        margin-top: 30px;
    }

    .pagination a {
        margin: 0 5px;
        padding: 10px 15px;
        /* 크기 조정 */
        text-decoration: none;
        border-radius: 6px;
        font-weight: 600;
        transition: all 0.3s ease;

        /* 기본 스타일: 에스프레소 테두리/글자, 흰색 배경 */
        background-color: var(--white);
        color: var(--primary-color);
        border: 1px solid var(--primary-color);
    }

    .pagination a:hover {
        background-color: var(--primary-color);
        color: var(--white);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
    }

    .pagination .current {
        background-color: var(--secondary-color);
        /* 현재 페이지는 피오니색으로 강조 */
        color: var(--primary-color);
        border: 1px solid var(--secondary-color);
        box-shadow: 0 2px 8px rgba(244, 201, 214, 0.4);
    }

    /* ---------------------------------------------------- */
    /* 5. Responsive adjustments */
    /* ---------------------------------------------------- */
    @media (max-width: 768px) {
        body {
            flex-direction: column;
        }
        
        /* 사이드바는 이전 요청과 동일하게 100% 너비로 고정 해제 */
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

        /* 리뷰 카드 모바일 레이아웃 조정 */
        .review-card {
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .review-image-area {
            margin-right: 0;
            margin-bottom: 15px;
        }

        .delete-button {
            position: static;
            /* 모바일에서 상대 위치로 변경 */
            margin-top: 10px;
            width: calc(100% - 24px);
            /* 중앙 정렬을 위해 전체 너비 조정 */
        }
    }
</style>
</head>

<body>

    <div id="app">
        <div class="main-wrapper">
            
            <div class="content-area">
                <h1 class="page-title" style="display: none;">리뷰 관리</h1> 
            
                <div v-if="pagedReviews.length > 0">
                    <div v-for="review in pagedReviews" :key="review.REVIEW_ID" class="review-card">
                     
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
                    <p style="text-align: center; padding: 50px; color: #666; background-color: #f9f9f9; border-radius: 5px;">
                        <span v-if="reviewList && reviewList.length > 0">선택된 페이지에 리뷰가 없습니다.</span>
                        <span v-else>아직 받은 리뷰가 없습니다.</span>
                    </p>
                </div>

                <div class="pagination" v-if="totalPages > 1">
                    <a @click.prevent="fnChangePage(currentPage - 1)" 
                       :class="{ 'disabled': currentPage === 1 }">&lt;</a>
                    
                    <a v-for="page in totalPages" :key="page" 
                       @click.prevent="fnChangePage(page)"
                       :class="{ 'current': currentPage === page }">
                        {{ page }}
                    </a>
                    
                    <a @click.prevent="fnChangePage(currentPage + 1)" 
                       :class="{ 'disabled': currentPage === totalPages }">&gt;</a>
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
                reviewList: [], 
                currentPage: 1, 
                itemsPerPage: 4, 
                userId: "${sessionId}",
            };
        },
        computed: {
            totalPages() {
                return Math.ceil(this.reviewList.length / this.itemsPerPage);
            },
            pagedReviews() {
                const start = (this.currentPage - 1) * this.itemsPerPage;
                const end = start + this.itemsPerPage;
                
                return this.reviewList.slice(start, end);
            }
        },
        methods: {
            fnReviewList: function () {
                let self = this;
                let param = {
                    userId: self.userId
                };
                
                $.ajax({
                    url: "/seller/review/list.dox", 
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.reviewList = data.list; 
                        self.currentPage = 1;
                    },
                    error: function (xhr, status, error) {
                        console.error("리뷰 목록 조회 실패:", error);
                    }
                });
            },
            fnChangePage: function(page) {
                if (page >= 1 && page <= this.totalPages) {
                    this.currentPage = page;
                }
            },
            fnDeleteReview: function(reviewId) {
                if (confirm(reviewId + "번 리뷰를 삭제 요청 목록에 추가하시겠습니까?")) {
                    alert("삭제 요청이 완료 되었습니다.");
                }
            }
        },
        mounted() {
            this.fnReviewList();
        }
    });

    app.mount('#app');
</script>