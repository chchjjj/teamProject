<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <!-- Navbar CSS -->
    <link rel="stylesheet" href="/css/navbar.css">

    <style>
        .content {
            padding: 40px;
            background-color: var(--light-bg);
            min-height: 100vh;
        }

        .chat-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .chat-card {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px 25px;
            position: relative;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .chat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .chat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .store-name {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--espresso);
        }

        .chat-meta {
            color: #666;
            font-size: 0.9rem;
        }

        .chat-body {
            margin-top: 6px;
            font-size: 0.95rem;
            color: #444;
        }

        .unread-badge {
            background-color: red;
            color: white;
            border-radius: 50%;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 7px;
            position: absolute;
            top: 15px;
            right: 20px;
            line-height: 1;
            display: inline-block;
        }

        .empty-msg {
            text-align: center;
            color: #777;
            margin-top: 100px;
            font-size: 1.1rem;
        }
    </style>
</head>

<body>
    <div id="app">
        <!-- Sidebar -->
        <div class="navBar">
            <div class="logoArea">
                <div class="logo">
                    <a href="javascript:;" onclick="location.href='/main.do'">
                        <img src="/img/로고.png" alt="쇼핑몰 로고">
                    </a>
                </div>
            </div>

            <div class="navButton">
                <button @click="fnOrderHistory()">주문 내역</button>
                <button @click="fnWishList()">찜한 상품</button>
                <button @click="fnChatList()" class="active">채팅이력</button>
                <button @click="fnReview()">내가 쓴 리뷰</button>
                <button @click="fnQnA()">QnA</button>
                <button @click="fnUserEdit()">정보수정</button>
                <button @click="fnDeleteAccount()">회원탈퇴</button>
            </div>

            <div class="logOut">
                <button @click="fnLogout()">Logout</button>
            </div>
        </div>

        <!-- Main Content -->
        <div class="content">
            <h2 style="margin-bottom: 20px; color: var(--espresso);">채팅 목록</h2>

            <div v-if="chatList.length === 0" class="empty-msg">
                현재 열려있는 채팅이 없습니다.
            </div>

            <div class="chat-list">
                <div class="chat-card" v-for="chat in chatList" :key="chat.chatId" @click="fnChat(chat.orderId)">
                    <div class="chat-header">
                        <div class="store-name">{{ chat.storeName }}</div>
                        <div class="chat-meta">{{ chat.createdAt }}</div>
                    </div>
                    <div class="chat-body">
                        <div><strong>상품명:</strong> {{ chat.proName }} 등 상품</div>
                        <div><strong>주문번호:</strong> {{ chat.orderId }}</div>
                    </div>

                    <div v-if="chat.unreadCount > 0" class="unread-badge">{{ chat.unreadCount }}</div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    chatList: [],
                    userId: "${sessionId}"
                };
            },
            methods: {
                fnchatList() {
                    let self = this;
                    $.ajax({
                        url: "/user/chat.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: self.userId },
                        success(data) {
                            self.chatList = data.chatList;
                        }
                    });
                },
                fnOrderHistory() { location.href = "/user/orderHistory.do"; },
                fnWishList() { location.href = "/product/wishlist.do"; },
                fnChatList() { location.href = "/user/chatList.do"; },
                fnReview() { location.href = "/user/review.do"; },
                fnQnA() { location.href = "/user/qnA.do"; },
                fnUserEdit() { location.href = "/user/userEdit.do"; },
                fnDeleteAccount:function(){ 
                    if(confirm("회원을 탈퇴하겠습니까?")){
                        location.href="/main.do";
                    }
                    return;
                },
                fnLogout() {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        $.ajax({
                            url: "/user/logout.dox",
                            type: "POST",
                            dataType: "json",
                            success(data) {
                                if (data.result === "success") {
                                    alert(data.msg + "! 홈페이지로 이동하겠습니다.");
                                    location.href = "/main.do";
                                } else alert("로그아웃하는 도중 오류 발생");
                            }
                        });
                    }
                },
                fnChat(orderId) {
                    pageChange("/chat/chatBuyer.do", { orderId: orderId});
                }
            },
            mounted() {
                this.fnchatList();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>
