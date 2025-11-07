<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>내가 쓴 리뷰</title>

        <!-- 스타일시트 -->
        <link rel="stylesheet" href="/css/productDetail-style.css">
        <link rel="stylesheet" href="/css/navbar.css">

        <!-- 라이브러리 -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
            body {
                background-color: #fff;
                font-family: "Noto Sans KR", sans-serif;
            }

            .content-area {
                margin: 40px 60px;
                padding-left: 260px;
                /* navbar 공간 확보 */
            }

            .review-header {
                font-size: 22px;
                font-weight: 600;
                margin-bottom: 30px;
            }

            .review-list {
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            .review-card {
                display: flex;
                align-items: flex-start;
                gap: 20px;
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 20px;
                background-color: #fafafa;
                transition: box-shadow 0.2s ease, transform 0.1s ease;
                cursor: pointer;
            }

            .review-card:hover {
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                transform: translateY(-2px);
            }

            .review-image {
                width: 120px;
                height: 120px;
                background-color: #f2f2f2;
                border-radius: 8px;
                flex-shrink: 0;
                overflow: hidden;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .review-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .review-info {
                flex: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .review-meta {
                font-size: 14px;
                color: #555;
                margin-bottom: 8px;
            }

            .review-content {
                font-size: 15px;
                color: #333;
                margin-bottom: 10px;
                line-height: 1.4;
            }

            .review-rating {
                color: #ffb400;
                font-weight: 600;
            }

            .paging {
                text-align: center;
                margin-top: 30px;
            }

            .paging a,
            .paging button {
                background: none;
                border: none;
                color: #444;
                margin: 0 5px;
                font-size: 15px;
                cursor: pointer;
            }

            .paging a.active {
                font-weight: bold;
                color: #3E2723;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- 왼쪽 사이드바 -->
            <div class="navBar">
                <!-- Logo Area -->
                <div class="logoArea">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="navButton">
                    <button @click="fnOrderHistory()" class="active">주문 내역</button>
                    <button @click="fnWishList()">찜한 상품</button>
                    <button @click="fnChatList()">채팅이력</button>
                    <button @click="fnReview()">내가 쓴 리뷰</button>
                    <button @click="fnQnA()">QnA</button>
                    <button @click="fnUserEdit()">정보수정</button>
                </div>

                <!-- Logout Button -->
                <div class="logOut">
                    <button @click="fnLogout()">Logout</button>
                </div>
            </div>

            <!--  본문 영역 -->
            <div class="content-area">
                <div class="review-header">내가 쓴 리뷰</div>

                <div class="review-list">
                    <div v-if="reviewList.length === 0">등록된 리뷰가 없습니다.</div>

                    <div v-for="review in reviewList" :key="review.reviewId" class="review-card">
                        <div class="review-image">
                            <img v-if="review.reviewImg" :src="review.reviewImg" alt="후기사진">
                            <span v-else>후기사진</span>
                        </div>

                        <div class="review-info">
                            <div class="review-meta">
                                닉네임: {{review.userName || '익명'}} <br>
                                작성일: {{review.cDateTime || '0000-00-00'}}
                            </div>
                            <div class="review-content">
                                {{review.reviewContent || '후기내용이 없습니다.'}}
                            </div>
                            <div class="review-rating">
                                별점: {{review.rating}} / 5
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이징 -->
                <div class="paging" v-if="pageNum > 1">
                    <button v-if="page > 1" @click="fnPre()">◀</button>
                    <a v-for="num in pageRangeList" :key="num" @click="fnChange(num)"
                        :class="{active: page === num}">{{num}}</a>
                    <button v-if="page < pageNum" @click="fnNext()">▶</button>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        userId: "${sessionId}",
                        reviewList: [],
                        page: 1,
                        pageSize: 5,
                        pageRange: 5,
                        pageRangeList: [],
                        pageNum: 0,
                        totalRows: 0
                    };
                },
                methods: {
                    fnReviewList() {
                        let self = this;
                        $.ajax({
                            url: "/user/reviewlist.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                userId: self.userId,
                                offset: (self.page - 1) * self.pageSize,
                                fetchRows: self.pageSize
                            },
                            success(data) {
                                self.reviewList = data.reviewList;
                                self.totalRows = data.totalRows;
                                self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                                self.fnPageRange();
                            }
                        });
                    },
                    fnPageRange() {
                        let start = Math.floor((this.page - 1) / this.pageRange) * this.pageRange + 1;
                        let end = Math.min(start + this.pageRange - 1, this.pageNum);
                        this.pageRangeList = [];
                        for (let i = start; i <= end; i++) this.pageRangeList.push(i);
                    },
                    fnChange(num) {
                        this.page = num;
                        this.fnReviewList();
                    },
                    fnPre() {
                        if (this.page > 1) this.page--;
                        this.fnReviewList();
                    },
                    fnNext() {
                        if (this.page < this.pageNum) this.page++;
                        this.fnReviewList();
                    },

                    fnHome() { location.href = "/main.do" },
                    fnOrderHistory() { location.href = "/user/orderHistory.do"; },
                    fnWishList() { location.href = "/product/wishlist.do"; },
                    fnChatList() { location.href = "/user/chatList.do"; },
                    fnReview() { location.href = "/user/review.do"; },
                    fnQnA() { location.href = "/user/qnA.do"; },
                    fnUserEdit() { location.href = "/user/userEdit.do"; },
                    fnLogout: function () {
                        if (confirm("로그아웃 하시겠습니까?")) {
                            let param = {};
                            $.ajax({
                                url: "/user/logout.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    if (data.result == "success") {
                                        alert(data.msg + "! 홈페이지로 이동하겠습니다.");
                                        location.href = "/main.do";
                                    } else {
                                        alert("로그아웃하는 도중에 오류가 발생하였습니다.");
                                    }

                                }

                            });
                        }
                    },
                },
                mounted() {
                    this.fnReviewList();
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>