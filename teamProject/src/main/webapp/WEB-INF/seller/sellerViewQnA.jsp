<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 QnA 게시판</title>
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
    padding: 40px 80px;  /* 🔥 좌우 패딩 증가 */
    margin-left: 240px;
    max-width: 1400px;   /* 🔥 최대 너비 제한 */
    margin-right: auto;  /* 🔥 오른쪽 자동 여백 */
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

        .store-info {
            margin-bottom: 24px;
            padding: 16px 20px;
            background: linear-gradient(135deg, var(--butter) 0%, #FFE89C 100%);
            border-radius: 12px;
            color: var(--espresso);
            font-weight: 600;
            box-shadow: var(--shadow-sm);
        }

        /* QnA Table */
        .qna-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            font-size: 14px;
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-md);
        }

        .qna-table th {
            background: linear-gradient(135deg, var(--butter) 0%, #FFE89C 100%);
            font-weight: 700;
            color: var(--espresso);
            padding: 16px 12px;
            text-align: center;
            border-bottom: 2px solid var(--espresso);
            font-size: 13px;
        }

        .qna-table td {
            padding: 16px 12px;
            text-align: center;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            transition: var(--transition);
        }

        .qna-table tbody tr {
            transition: var(--transition);
            cursor: pointer;
        }

        .qna-table tbody tr:hover {
            background-color: rgba(244, 201, 214, 0.1);
        }

        .qna-table .content-col {
            text-align: left;
            font-weight: 500;
        }

        .qna-table .content-col strong {
            color: #e74c3c;
            font-size: 16px;
            margin-right: 8px;
        }

        /* Status Badge */
        .status-btn {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 16px;
            font-weight: 700;
            font-size: 12px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .completed {
            background: linear-gradient(135deg, var(--peony) 0%, #F0B8CA 100%);
            color: var(--espresso);
        }

        .waiting {
            background: linear-gradient(135deg, var(--butter) 0%, #FFE89C 100%);
            color: var(--espresso);
        }

        /* Answer Row */
        .answer-row {
            background: linear-gradient(135deg, #FFF5F7 0%, #FFF9E5 100%);
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .answer-row td {
            padding: 24px !important;
        }

        .answer-content {
            background: var(--white);
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid var(--peony);
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
        }

        .answer-content strong {
            color: #3498db;
            font-size: 16px;
            display: block;
            margin-bottom: 8px;
        }

        .answer-content p {
            color: #555;
            line-height: 1.6;
            white-space: pre-wrap;
            margin: 0;
        }

        /* Answer Form */
        .answer-form-area {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .answer-form-area textarea {
            width: 100%;
            min-height: 120px;
            padding: 14px;
            border: 2px solid #E0E0E0;
            border-radius: 8px;
            resize: vertical;
            background-color: var(--white);
            font-family: inherit;
            font-size: 14px;
            transition: var(--transition);
            outline: none;
        }

        .answer-form-area textarea:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(62, 39, 35, 0.1);
        }

        .answer-form-area button {
            align-self: flex-end;
            padding: 10px 24px;
            background: linear-gradient(135deg, var(--secondary-color) 0%, #F0B8CA 100%);
            color: var(--primary-color);
            border: 1px solid var(--secondary-color);
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(244, 201, 214, 0.3);
        }

        .answer-form-area button:hover {
            background: linear-gradient(135deg, #F0B8CA 0%, var(--secondary-color) 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(244, 201, 214, 0.5);
        }

        .answer-form-area button:active {
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
            margin-top: 20px;
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

            .qna-table,
            .qna-table thead,
            .qna-table tbody,
            .qna-table th,
            .qna-table td,
            .qna-table tr {
                display: block;
            }

            .qna-table thead tr {
                position: absolute;
                top: -9999px;
                left: -9999px;
            }

            .qna-table tr {
                border: 1px solid #ddd;
                margin-bottom: 12px;
                border-radius: 12px;
                overflow: hidden;
                background-color: var(--white);
                box-shadow: var(--shadow-sm);
            }

            .qna-table td {
                border: none;
                position: relative;
                padding-left: 50%;
                text-align: right;
                font-size: 13px;
                border-bottom: 1px solid #f0f0f0;
            }

            .qna-table td:before {
                content: attr(data-label);
                position: absolute;
                left: 12px;
                width: 45%;
                padding-right: 10px;
                white-space: nowrap;
                text-align: left;
                font-weight: 700;
                color: var(--espresso);
            }

            .qna-table .content-col {
                text-align: right;
            }

            .answer-row td {
                padding: 16px !important;
            }

            .answer-form-area button {
                width: 100%;
            }
        }
    </style>
</head>

<body>
    <div id="qna-app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">상품 QnA 게시판</h1>

                <div class="store-info" v-if="storeName">
                    현재 조회 중인 가게: {{ storeName }}
                </div>

                <table class="qna-table" v-if="qnaList.length > 0">
                    <thead>
                        <tr>
                            <th width="10%">번호</th>
                            <th width="45%">질문 내용</th>
                            <th width="15%">작성자</th>
                            <th width="15%">작성일</th>
                            <th width="10%">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template v-for="(item, index) in qnaList" :key="item.questionId">
                            <tr @click="toggleAnswer(index)">
                                <td data-label="번호">{{ item.questionId }}</td>
                                <td data-label="질문 내용" class="content-col">
                                    <strong>Q.</strong> {{ item.questionContent }}
                                </td>
                                <td data-label="작성자">{{ item.userId }}</td>
                                <td data-label="작성일">{{ item.questionDate }}</td>
                                <td data-label="상태">
                                    <span v-if="item.answerContent" class="status-btn completed">
                                        완료
                                    </span>
                                    <span v-else class="status-btn waiting">
                                        대기
                                    </span>
                                </td>
                            </tr>

                            <tr v-if="activeIndex === index" class="answer-row">
                                <td colspan="5">
                                    <div class="answer-content">
                                        <strong>A.</strong>
                                        <p>{{ item.answerContent || '답변이 아직 없습니다.' }}</p>
                                    </div>

                                    <div class="answer-form-area">
                                        <textarea v-model="item.answerInput" placeholder="답변 내용을 입력하세요."></textarea>
                                        <button @click.stop="saveAnswer(item)">
                                            {{ item.answerContent ? '답변 수정' : '답변 등록' }}
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </template>
                    </tbody>
                </table>

                <div v-else class="empty-state">
                    등록된 QnA가 없습니다.
                </div>
            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;

        const qnaApp = createApp({
            data() {
                return {
                    storeName: '<%= request.getAttribute("storeName") != null ? request.getAttribute("storeName") : "" %>',
                    qnaList: [],
                    activeIndex: -1,
                    loading: true,
                    userId: "${sessionId}",
                };
            },
            methods: {
                toggleAnswer(index) {
                    if (this.activeIndex !== index) {
                        this.qnaList[index].answerInput = this.qnaList[index].answerContent || '';
                    }
                    this.activeIndex = this.activeIndex === index ? -1 : index;
                },

                fetchQnAList() {
                    this.loading = true;
                    $.ajax({
                        url: "/seller/qnaList.dox",
                        method: "POST",
                        dataType: "json",
                        data: {
                            userId: this.userId,
                        },
                        success: (res) => {
                            if (res.result === 'success' && res.list) {
                                this.qnaList = res.list.map(item => ({
                                    questionId: item.QUESTION_ID,
                                    questionContent: item.QUESTION_CONTENT,
                                    userId: item.USER_ID,
                                    questionDate: item.QUESTION_DATE,
                                    answerContent: item.ANSWER_CONTENT,
                                    answerInput: item.ANSWER_CONTENT || '',
                                    answerDate: item.ANSWER_DATE,
                                    proType: item.PRO_TYPE,
                                    status: item.STATUS,
                                    price: item.PRICE,
                                    storeName: item.STORE_NAME,
                                    proNo: item.PRO_NO
                                }));
                            } else {
                                this.qnaList = [];
                            }
                        },
                        error: (xhr, status, error) => {
                            alert("QnA 목록을 불러오는 데 실패했습니다.");
                            console.error("QnA 목록 로드 실패:", status, error);
                        },
                        complete: () => {
                            this.loading = false;
                        }
                    });
                },

                saveAnswer(item) {
                    if (!item.answerInput || item.answerInput.trim() === '') {
                        alert("답변 내용을 입력해 주세요.");
                        return;
                    }

                    if (!item.questionId) {
                        alert("질문 번호가 없어 답변을 등록할 수 없습니다.");
                        return;
                    }

                    if (confirm(`${item.answerContent ? '답변을 수정' : '답변을 등록'}하시겠습니까?`)) {
                        $.ajax({
                            url: "/seller/qnaSesponse.dox",
                            method: "POST",
                            dataType: "json",
                            data: {
                                questionId: item.questionId,
                                answerContent: item.answerInput.trim(),
                            },
                            success: (res) => {
                                if (res.result === 'success') {
                                    alert(`${item.answerContent ? '답변이 수정' : '답변이 등록'}되었습니다.`);
                                    item.answerContent = item.answerInput.trim();
                                    this.activeIndex = -1;
                                } else {
                                    alert(`답변 ${item.answerContent ? '수정' : '등록'}에 실패했습니다.`);
                                }
                            },
                            error: (xhr, status, error) => {
                                alert("서버 통신 중 오류가 발생했습니다.");
                                console.error("답변 저장 실패:", status, error);
                            }
                        });
                    }
                }
            },
            mounted() {
                this.fetchQnAList();
            }
        });

        qnaApp.mount('#qna-app');
    </script>
</body>

</html>