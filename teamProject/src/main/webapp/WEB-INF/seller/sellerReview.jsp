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
        body { margin: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f4f4; }
        
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
            min-height: 100vh;
        }
        
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: white;
            margin-left: 220px; 
            box-sizing: border-box;
        }

        .page-title {
            font-size: 24px;
            font-weight: 300;
            margin-bottom: 20px;
        }

        .review-card {
            display: flex;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #e0e0e0; 
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .review-image-area {
            width: 150px;
            height: 150px;
            background-color: #ccc; 
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
            cursor: pointer;
        }
        .pagination .current {
            background-color: #555;
            color: white;
            border: 1px solid #555;
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
                        <div class="review-image-area">
                            후기사진
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