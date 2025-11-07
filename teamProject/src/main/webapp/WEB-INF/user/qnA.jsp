<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내가 쓴 Q&A</title>

    <link rel="stylesheet" href="/css/admin-style.css">
    <link rel="stylesheet" href="/css/navbar.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: "Noto Sans KR", sans-serif;
        }

        /* ---- 콘텐츠 전체 영역 ---- */
        .content-area {
            margin-left: 270px;
            padding: 60px 80px;
            max-width: 1100px;
            box-sizing: border-box;
            min-height: 100vh;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 40px;
            text-align: center;
            color: #3E2723;
        }

        /* ---- QnA 리스트 ---- */
        .qna-list {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .qna-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 25px 28px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.06);
            transition: all 0.25s ease;
            cursor: pointer;
        }

        .qna-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 14px rgba(0, 0, 0, 0.08);
        }

        .qna-question {
            font-size: 17px;
            font-weight: 600;
            color: #333;
        }

        .qna-meta {
            font-size: 13px;
            color: #888;
            margin-top: 6px;
        }

        .qna-answer {
            font-size: 15px;
            color: #444;
            background: #f9f9f9;
            border-radius: 10px;
            margin-top: 12px;
            padding: 14px 18px;
            line-height: 1.6;
            display: none;
        }

        .qna-answer.show {
            display: block;
        }

        /* ---- 페이징 ---- */
        .paging {
            text-align: center;
            margin-top: 40px;
        }

        .paging a,
        .paging button {
            background: none;
            border: none;
            color: #444;
            margin: 0 6px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.2s;
        }

        .paging a:hover,
        .paging button:hover {
            color: #3E2723;
            font-weight: 600;
        }

        .paging a.active {
            font-weight: 700;
            color: #3E2723;
            border-bottom: 2px solid #3E2723;
            padding-bottom: 2px;
        }

        @media (max-width: 1024px) {
            .content-area {
                margin-left: 240px;
                padding: 40px 40px;
            }
        }

        @media (max-width: 768px) {
            .content-area {
                margin-left: 0;
                padding: 30px 25px;
            }
        }
    </style>
</head>

<body>
    <div id="app">
        <!-- 사이드바 (navbar.css에서 스타일 관리) -->
        <div class="navBar">
            <div>
                <div class="logoArea" @click="fnHome()">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                </div>
                <div class="navButton">
                    <button @click="fnOrderHistory()">주문 내역</button>
                    <button @click="fnWishList()">찜한 상품</button>
                    <button @click="fnChatList()">채팅이력</button>
                    <button @click="fnReview()">내가 쓴 리뷰</button>
                    <button class="active" @click="fnQnA()">QnA</button>
                    <button @click="fnUserEdit()">정보수정</button>
                </div>
            </div>
            <div class="logOut">
                <button @click="fnLogout()">Logout</button>
            </div>
        </div>

        <!-- 본문 -->
        <div class="content-area">
            <div class="page-title">Q&A</div>

            <div class="qna-list">
                <div class="qna-card" v-for="qnA in qnAList" :key="qnA.questionId" @click="toggleAnswer(qnA)">
                    <div class="qna-question">{{ qnA.questionContent }}</div>
                    <div class="qna-meta">
                        질문자: {{ qnA.userId }} ｜ 작성일: {{ qnA.questionDate }} ｜ 상태:
                        <span v-if="qnA.answerContent" style="color:chocolate">완료</span>
                        <span v-else>대기</span>
                    </div>
                    <div class="qna-answer" :class="{show: qnA.showAnswer}">
                        <template v-if="qnA.answerContent">
                            <strong>답변자:</strong> {{ qnA.storeId }}<br>
                            <span>{{ qnA.answerContent }}</span><br>
                            <small style="color:#888;">{{ qnA.answerDate }}</small>
                        </template>
                        <template v-else>
                            <em>아직 답변이 등록되지 않았습니다.</em>
                        </template>
                    </div>
                </div>
            </div>

            <div class="paging" v-if="pageNum > 1">
                <button v-if="page > 1" @click="fnPre()">◀</button>
                <a v-for="num in pageRangeList" :key="num" @click="fnChange(num)" :class="{active: page === num}">
                    {{ num }}
                </a>
                <button v-if="page < pageNum" @click="fnNext()">▶</button>
            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userId: "${sessionId}",
                    qnAList: [],
                    page: 1,
                    pageSize: 5,
                    pageRange: 5,
                    pageRangeList: [],
                    pageNum: 0,
                    totalRows: 0
                };
            },
            methods: {
                fnQnAList() {
                    let self = this;
                    $.ajax({
                        url: "/user/qnA.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: self.userId,
                            offset: (self.page - 1) * self.pageSize,
                            fetchRows: self.pageSize
                        },
                        success(data) {
                            self.qnAList = data.qnAList.map(item => ({ ...item, showAnswer: false }));
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
                    this.fnQnAList();
                },
                fnPre() {
                    if (this.page > 1) this.page--;
                    this.fnQnAList();
                },
                fnNext() {
                    if (this.page < this.pageNum) this.page++;
                    this.fnQnAList();
                },
                toggleAnswer(qnA) {
                    qnA.showAnswer = !qnA.showAnswer;
                },
                fnHome() { location.href = "/main.do"; },
                fnOrderHistory() { location.href = "/user/orderHistory.do"; },
                fnWishList() { location.href = "/product/wishlist.do"; },
                fnChatList() { location.href = "/user/chatList.do"; },
                fnReview() { location.href = "/user/review.do"; },
                fnQnA() { location.href = "/user/qnA.do"; },
                fnUserEdit() { location.href = "/user/userEdit.do"; },
                fnLogout() { location.href = "/logout.do"; }
            },
            mounted() {
                this.fnQnAList();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>
