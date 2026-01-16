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
        }

        .sidebar-menu a:hover {
            background-color: rgba(62, 39, 35, 0.08);
            transform: translateX(4px);
        }

        .sidebar-menu .active a {
            background-color: var(--espresso);
            color: var(--white);
            box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
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

        /* Review Card */
        .review-card {
            display: flex;
            padding: 20px;
            margin-bottom: 16px;
            border-radius: 12px;
            background-color: var(--white);
            border: 1px solid rgba(0, 0, 0, 0.06);
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .review-card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--peony) 0%, var(--butter) 100%);
            opacity: 0;
            transition: var(--transition);
        }

        .review-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            border-color: var(--espresso);
        }

        .review-card:hover:before {
            opacity: 1;
        }

        .review-content-area {
            flex-grow: 1;
            position: relative;
        }

        .review-meta {
            margin-bottom: 12px;
            font-size: 13px;
            color: var(--primary-color);
            padding-bottom: 10px;
            border-bottom: 1px dashed #E0E0E0;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .review-meta strong {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 14px;
        }

        .review-meta span {
            color: #666;
            font-size: 12px;
        }

        .review-body {
            font-size: 15px;
            margin-top: 8px;
            margin-bottom: 12px;
            color: #333;
            line-height: 1.6;
        }

        .review-rating {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--peony) 0%, #F0B8CA 100%);
            color: var(--espresso);
            box-shadow: 0 2px 8px rgba(244, 201, 214, 0.4);
        }

        .delete-button {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 8px 14px;
            border: 1px solid var(--primary-color);
            background-color: var(--white);
            color: var(--primary-color);
            cursor: pointer;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            transition: var(--transition);
        }

        .delete-button:hover {
            background-color: var(--primary-color);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
        }

        .delete-button:active {
            transform: translateY(0);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            font-size: 15px;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 40px;
            gap: 6px;
        }

        .pagination a {
            padding: 10px 14px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            transition: var(--transition);
            background-color: var(--white);
            color: var(--primary-color);
            border: 1px solid #E0E0E0;
            cursor: pointer;
            min-width: 40px;
            text-align: center;
        }

        .pagination a:hover:not(.disabled):not(.current) {
            background-color: var(--primary-color);
            color: var(--white);
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
        }

        .pagination .current {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #F0B8CA 100%);
            color: var(--primary-color);
            border: 1px solid var(--secondary-color);
            box-shadow: 0 2px 8px rgba(244, 201, 214, 0.4);
            font-weight: 700;
        }

        .pagination .disabled {
            opacity: 0.3;
            cursor: not-allowed;
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

            .review-card {
                flex-direction: column;
                padding: 16px;
            }

            .delete-button {
                position: static;
                margin-top: 12px;
                width: 100%;
            }

            .review-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 6px;
            }

            .pagination {
                flex-wrap: wrap;
                gap: 4px;
            }

            .pagination a {
                padding: 8px 12px;
                font-size: 12px;
                min-width: 36px;
            }
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">리뷰 관리</h1>
            
                <div v-if="pagedReviews.length > 0">
                    <div v-for="review in pagedReviews" :key="review.REVIEW_ID" class="review-card">
                        <div class="review-content-area">
                            <div class="review-meta">
                                <strong>{{ review.USER_ID }}</strong>
                                <span>{{ review.CDATETIME }}</span>
                            </div>
                            <div class="review-body">
                                {{ review.REVIEW_CONTENT }}
                            </div>
                            <div class="review-rating">
                                ★ {{ review.RATING }}
                            </div>
                            <button @click="fnDeleteReview(review.REVIEW_ID)" class="delete-button">
                                삭제 요청
                            </button>
                        </div>
                    </div>
                </div>
                <div v-else class="empty-state">
                    <p v-if="reviewList && reviewList.length > 0">선택된 페이지에 리뷰가 없습니다.</p>
                    <p v-else>아직 받은 리뷰가 없습니다.</p>
                </div>

                <div class="pagination" v-if="totalPages > 1">
                    <a @click.prevent="fnChangePage(currentPage - 1)" 
                       :class="{ 'disabled': currentPage === 1 }">
                        ◀
                    </a>
                    
                    <a v-for="page in totalPages" :key="page" 
                       @click.prevent="fnChangePage(page)"
                       :class="{ 'current': currentPage === page }">
                        {{ page }}
                    </a>
                    
                    <a @click.prevent="fnChangePage(currentPage + 1)" 
                       :class="{ 'disabled': currentPage === totalPages }">
                        ▶
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>

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
                    alert("삭제 요청이 완료되었습니다.");
                }
            }
        },
        mounted() {
            this.fnReviewList();
        }
    });

    app.mount('#app');
</script>

</html>