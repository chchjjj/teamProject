<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 작성</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <!-- Navbar CSS -->
    <link rel="stylesheet" href="/css/navbar.css">
    
    <style>
        .review-wrapper {
            background: #f5f5f5;
            min-height: 100vh;
            padding: 20px;
        }
        
        .review-container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }
        
        .review-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #666;
            font-size: 14px;
        }
        
        .info-value {
            color: #333;
            font-size: 14px;
            font-weight: 500;
        }
        
        .section {
            margin: 30px 0;
        }
        
        .section-label {
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 15px;
        }
        
        .star-rating {
            display: flex;
            gap: 8px;
            justify-content: center;
            padding: 15px 0;
        }
        
        .star {
            font-size: 36px;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
            user-select: none;
        }
        
        .star.active {
            color: #ffb800;
        }
        
        .rating-text {
            text-align: center;
            font-size: 14px;
            color: #666;
            margin-top: 8px;
        }
        
        textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            resize: vertical;
            box-sizing: border-box;
        }
        
        textarea:focus {
            outline: none;
            border-color: #4a90e2;
        }
        
        .char-count {
            text-align: right;
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
        }
        
        .btn-cancel {
            background: #f0f0f0;
            color: #666;
        }
        
        .btn-submit {
            background:  #F4C9D6;
            color: black;
        }
        
        .btn-submit:hover {
            background: #eba3b9fd;
        }
        
        .btn-cancel:hover {
            background: #e0e0e0;
        }
        
        @media (max-width: 768px) {
            .review-container {
                margin: 20px;
                padding: 25px;
            }
            
            .star {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- Navbar - 완전히 보존 -->
        <div class="navBar">
            <div class="logoArea">
                <div class="logo">
                    <a href="javascript:;" onclick="location.href='/main.do'">
                        <img src="/img/로고.png" alt="쇼핑몰 로고">
                    </a>
                </div>
            </div>

            <div class="navButton">
                <button @click="fnOrderHistory()" class="active">주문 내역</button>
                <button @click="fnWishList()">찜한 상품</button>
                <button @click="fnChatList()">채팅이력</button>
                <button @click="fnReview()">내가 쓴 리뷰</button>
                <button @click="fnQnA()">QnA</button>
                <button @click="fnUserEdit()">정보수정</button>
                <button @click="fnDeleteAccount()">회원탈퇴</button>
            </div>

            <div class="logOut">
                <button @click="fnLogout()">Logout</button>
            </div>
        </div>

        <button class="menuToggle" @click="toggleMenu">☰</button>

        <!-- 리뷰 작성 영역 -->
        <div class="review-wrapper">
            <div class="review-container">
                <h1 class="review-title">리뷰 작성</h1>
                
                <div>
                    <div class="info-row">
                        <span class="info-label">주문번호</span>
                        <span class="info-value">{{order.orderId}}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">주문자</span>
                        <span class="info-value">{{order.userName}}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">가게</span>
                        <span class="info-value">{{order.storeName}}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">상품</span>
                        <span class="info-value">{{order.proName}}</span>
                    </div>
                </div>
                
                <div class="section">
                    <div class="section-label">평점</div>
                    <div class="star-rating">
                        <span 
                            v-for="star in 5" 
                            :key="star"
                            class="star"
                            :class="{ active: star <= rating }"
                            @click="rating = star"
                        >
                            {{ star <= rating ? '★' : '☆' }}
                        </span>
                    </div>
                    <div class="rating-text">
                        <span v-if="rating > 0">{{ rating }}점</span>
                        <span v-else>별점을 선택하세요</span>
                    </div>
                </div>
                
                <div class="section">
                    <div class="section-label">리뷰 내용</div>
                    <textarea 
                        v-model="reviewContent"
                        placeholder="상품에 대한 후기를 작성해주세요."
                        maxlength="1000"
                    ></textarea>
                    <div class="char-count">{{ reviewContent.length }} / 1000</div>
                </div>
                
                <div class="button-group">
                    <button class="btn btn-cancel" @click="fnCancel">취소</button>
                    <button class="btn btn-submit" @click="fnReviewInsert">등록</button>
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
                order: {},
                orderDetailId: "${orderDetailId}",
                userId: "${sessionId}",
                rating: 0,
                reviewContent: ""
            };
        },
        methods: {
            fnOrderSelect: function () {
                
                let self = this;
                let param = {
                    userId: self.userId,
                    orderDetailId: self.orderDetailId
                };
                $.ajax({
                    url: "/user/orderDetail.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.detailList && data.detailList.length > 0) {
                            self.order = data.detailList[0];
                        }
                    }
                });
            },

            fnReviewInsert: function() {
                let self = this;
                
                // 유효성 검사
                if (!self.rating) {
                    alert("별점을 선택해주세요.");
                    return;
                }
                
                if (!self.reviewContent.trim()) {
                    alert("리뷰 내용을 입력해주세요.");
                    return;
                }
                
                let param = {
                    orderId:self.order.orderId,
                    orderDetailId: self.orderDetailId,
                    proNo: self.order.proNo,
                    userId: self.userId,
                    storeId: self.order.storeId,
                    storeName: self.order.storeName,
                    rating: self.rating,
                    reviewContent: self.reviewContent
                };
                
                
                $.ajax({
                    url: "/user/reviewInsert.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("리뷰 등록 성공!");
                        location.href = "/user/review.do";
                    }
                });
            },

            fnCancel: function() {
                location.href = "/user/review.do";
            },

            toggleMenu: function () {
                document.querySelector('.navBar').classList.toggle('active');
                document.body.classList.toggle('menu-open');
            },

            fnHome() { location.href = "/main.do" },
            fnOrderHistory: function () { location.href = "/user/orderHistory.do" },
            fnWishList: function () { location.href = "/product/wishlist.do" },
            fnChatList: function () { location.href = "/user/chatList.do" },
            fnReview: function () { location.href = "/user/review.do" },
            fnQnA: function () { location.href = "/user/qnA.do" },
            fnUserEdit: function () { location.href = "/user/userEdit.do" },
            fnDeleteAccount: function () {
                if (confirm("회원을 탈퇴하겠습니까?")) {
                    location.href = "/main.do";
                }
            },
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
            }
        },
        mounted() {
            let self = this;
            self.fnOrderSelect();
        }
    });

    app.mount('#app');
</script>