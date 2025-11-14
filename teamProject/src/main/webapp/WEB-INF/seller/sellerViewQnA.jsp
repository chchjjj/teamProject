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
        min-height: calc(100vh - 50px);
    }

    .sidebar {
        width: 220px;
        background-color: var(--butter);
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
        margin-left: 220px;
        box-sizing: border-box;
        /* 추가된 중앙 정렬 스타일은 제거했습니다. (사이드바가 있을 경우) */
        /* max-width: 1200px; */
        /* margin: 0 auto; */
        /* padding-top: 30px; */
    }

    .page-title {
        font-size: 24px;
        font-weight: 300;
        /* font-weight를 300으로 변경 */
        margin-bottom: 20px;
        color: var(--espresso);
        padding-bottom: 10px;
        border-bottom: 2px solid var(--espresso);
    }

    /* ---------------------------------------------------- */
    /* 3. Q&A Table Styles (New Design 적용) */
    /* ---------------------------------------------------- */
    .qna-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        font-size: 14px;
        background-color: var(--white);
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    }

    .qna-table th,
    .qna-table td {
        border: 1px solid #ddd;
        padding: 12px;
        text-align: center;
        border-left: none;
        border-right: none;
    }
    
    .qna-table th:first-child,
    .qna-table td:first-child {
        border-left: 1px solid #ddd;
    }

    .qna-table th:last-child,
    .qna-table td:last-child {
        border-right: 1px solid #ddd;
    }

    .qna-table th {
        background-color: var(--butter);
        /* 버터색 배경 */
        font-weight: 600;
        color: var(--espresso);
        /* 에스프레소 폰트 */
        border-top: 2px solid var(--espresso);
        /* 에스프레소 상단선 */
        border-bottom: 2px solid var(--espresso);
        /* 에스프레소 하단선 */
    }

    .qna-table td {
        color: #333;
        transition: background-color 0.2s;
    }
    
    .qna-table tbody tr:hover {
        background-color: #fcfcfc;
        /* 호버 효과 */
        cursor: pointer;
    }
    
    /* 4. Status Tags (상태 배지) */
    .status-cell {
        text-align: center;
    }

    .status-btn {
        padding: 5px 10px;
        border-radius: 15px;
        /* 알약 모양 */
        color: var(--espresso);
        /* 글자색을 에스프레소로 통일 */
        font-weight: 600;
        font-size: 12px;
        min-width: 60px;
        display: inline-block;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .completed {
        background-color: var(--peony);
        /* 답변 완료: 피오니 */
        border: 1px solid #f0b8ca;
    }

    .waiting {
        background-color: var(--butter);
        /* 답변 대기: 버터 */
        border: 1px solid #ffde7b;
    }

    .qna-table .content-col {
        text-align: left;
    }
    
    /* 5. Action Button (질문 보기/답변하기) */
    .action-button {
        background-color: var(--primary-color);
        /* 에스프레소 버튼 */
        color: var(--white);
        border: none;
        padding: 8px 15px;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s, transform 0.2s;
        font-size: 13px;
        font-weight: 600;
    }

    .action-button:hover {
        background-color: #5D4037;
        /* 약간 어두운 에스프레소 */
        transform: translateY(-1px);
    }

    /* 6. Answer Area (답변 내용) */
    .answer-row {
        background-color: var(--peony);
        /* 답변 행 배경을 피오니로 설정 */
    }

    .answer-content {
        padding: 15px;
        text-align: left !important;
        /* 답변 내용은 왼쪽 정렬 유지 */
        font-size: 14px;
        color: var(--primary-color);
        /* 답변 내용 글자색 에스프레소 */
    }

    .answer-content strong {
        color: var(--primary-color);
        /* 강조 글자색 에스프레소 */
        font-weight: 700;
    }

    /* 7. Answer Form (답변 작성 폼) */
    .answer-form-area {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-top: 10px;
    }

    .answer-form-area textarea {
        width: 100%;
        min-height: 100px;
        padding: 10px;
        border: 1px solid var(--primary-color);
        /* 에스프레소 테두리 */
        border-radius: 4px;
        box-sizing: border-box;
        resize: vertical;
        background-color: var(--white);
    }

    .answer-form-area button {
        align-self: flex-end;
        background-color: var(--secondary-color);
        /* 피오니 버튼 */
        color: var(--primary-color);
        /* 에스프레소 글자색 */
        border: 1px solid var(--secondary-color);
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .answer-form-area button:hover {
        background-color: #f0b8ca;
        /* 약간 어두운 피오니 */
        transform: translateY(-1px);
    }

    /* ---------------------------------------------------- */
    /* 8. Responsive adjustments */
    /* ---------------------------------------------------- */
    @media (max-width: 768px) {
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
            margin-bottom: 10px;
            border-radius: 8px;
            overflow: hidden;
            background-color: var(--white);
        }
        
        .qna-table td {
            border: none;
            position: relative;
            padding-left: 50%;
            text-align: right;
            font-size: 14px;
            border-bottom: 1px solid #eee;
        }
        
        .qna-table td:before {
            content: attr(data-label);
            position: absolute;
            left: 10px;
            width: 45%;
            padding-right: 10px;
            white-space: nowrap;
            text-align: left;
            font-weight: bold;
            color: var(--espresso);
        }

        .qna-table .content-col {
            text-align: right; /* 모바일에서는 내용도 오른쪽 정렬 */
        }
        
        .status-cell {
            text-align: right !important; /* 모바일에서 상태도 오른쪽 정렬 */
        }
        
        .action-button {
            width: 100%;
            margin-top: 10px;
        }

        .answer-content {
            border-top: 2px solid var(--espresso);
            /* 답변 내용 구분선 강조 */
        }
    }
</style>
        </head>

        <body>

            <div id="qna-app">
                <div class="main-wrapper">
                    <div class="content-area">
                        <h1 class="page-title">상품 QnA 게시판</h1>

                        <p>현재 조회 중인 가게: **{{ storeName }}**</p>

                        <table class="qna-table">
                            <thead>
                                <tr>
                                    <th width="10%"> 질문 번호</th>
                                    <th width="45%">질문 내용</th>
                                    <th width="15%">작성자 ID</th>
                                    <th width="15%">작성일</th>
                                    <th width="10%">답변 상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template v-for="(item, index) in qnaList" :key="item.questionId">
                                    <tr @click="toggleAnswer(index)" style="cursor: pointer;">
                                        <td>{{ item.questionId }}</td>
                                        <td>
                                            <strong style="color: #c0392b;">Q.</strong> {{ item.questionContent }}
                                        </td>
                                        <td>{{ item.userId }}</td>
                                        <td>{{ item.questionDate }}</td>
                                        <td class="status-cell">
                                            <span v-if="item.answerContent" class="status-btn completed">
                                                완료
                                            </span>
                                            <span v-else class="status-btn waiting">
                                                대기
                                            </span>
                                        </td>
                                    </tr>

                                    <tr v-if="activeIndex === index" class="answer-row">
                                        <td colspan="5" style="padding: 20px 30px 20px 60px; text-align: left;">
                                            <div class="answer-content">
                                                <strong style="color: #3498db;">A.</strong>
                                                <p style="margin-top: 5px; white-space: pre-wrap;">
                                                    {{ item.answerContent || '답변이 아직 없습니다.' }}
                                                </p>
                                            </div>

                                            <div class="answer-form-area">
                                                <textarea v-model="item.answerInput" placeholder="답변 내용을 입력하세요.">
                                        </textarea>
                                                <button class="action-button" @click.stop="saveAnswer(item)">
                                                    {{ item.answerContent ? '답변 수정' : '답변 등록' }}
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                            </tbody>

                        </table>

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
                            activeIndex: -1, // 현재 열려 있는 Q&A의 인덱스 (-1은 아무것도 열려있지 않음)
                            loading: true,
                            userId: "${sessionId}",
                            proNo: "",
                            keyword: "",

                            pageSize: 10,
                            page: 1,
                            index: 0,

                            qnaKeyword: "",
                        };
                    },
                    methods: {
                        // 질문 클릭 시 답변을 토글하는 메서드 (하나만 열리도록 유지)
                        toggleAnswer(index) {
                            // 열기 전에 기존 답변 내용을 answerInput에 복사
                            if (this.activeIndex !== index) {
                                this.qnaList[index].answerInput = this.qnaList[index].answerContent || '';
                            }

                            // 토글 로직: 이미 열려있으면 닫고, 아니면 열기
                            this.activeIndex = this.activeIndex === index ? -1 : index;
                        },

                        // QnA 목록을 서버에서 불러오는 메서드 (QUESTION_ID 매핑 확인)
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

                                        // ⭐ QUESTION_ID 매핑 확인 및 answerInput 필드 추가 ⭐
                                        this.qnaList = res.list.map(item => ({
                                            questionId: item.QUESTION_ID, // QUESTION_ID가 정확히 매핑되는지 확인
                                            questionContent: item.QUESTION_CONTENT,
                                            userId: item.USER_ID,
                                            questionDate: item.QUESTION_DATE,
                                            answerContent: item.ANSWER_CONTENT, // 실제 저장된 답변
                                            answerInput: item.ANSWER_CONTENT || '', // 답변 입력 필드 (수정 중인 내용)
                                            answerDate: item.ANSWER_DATE,
                                            proType: item.PRO_TYPE,
                                            status: item.STATUS,
                                            price: item.PRICE,
                                            storeName: item.STORE_NAME,
                                            proNo: item.PRO_NO // proNo도 혹시 모를 다른 용도를 위해 유지
                                        }));

                                        //console.log("매핑된 QnA 리스트:", this.qnaList);
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

                        // ⭐ 답변을 등록/수정하는 메서드 (questionId를 전송하도록 수정) ⭐
                        saveAnswer(item) {
                            if (!item.answerInput || item.answerInput.trim() === '') {
                                alert("답변 내용을 입력해 주세요.");
                                return;
                            }

                            // questionId가 존재하는지 확인
                            if (!item.questionId) {
                                alert("질문 번호(questionId)가 없어 답변을 등록할 수 없습니다. 목록 조회에 questionId가 포함되었는지 확인하세요.");
                                return;
                            }

                            if (confirm(`${item.answerContent ? '답변을 수정' : '답변을 등록'}하시겠습니까?`)) {

                                $.ajax({
                                    // Controller의 URL
                                    url: "/seller/qnaSesponse.dox",
                                    method: "POST",
                                    dataType: "json",
                                    data: {
                                        // ⭐ Controller의 파라미터(questionId, answerContent)에 맞게 데이터 전송 ⭐
                                        questionId: item.questionId,
                                        answerContent: item.answerInput.trim(),
                                    },
                                    success: (res) => {
                                        // Controller에서 반환되는 resultMap의 'result' 키를 확인
                                        if (res.result === 'success') {
                                            alert(`${item.answerContent ? '답변이 수정' : '답변이 등록'}되었습니다.`);

                                            // 화면의 데이터 업데이트
                                            item.answerContent = item.answerInput.trim();

                                            // 답변 등록/수정 후 열려있는 답변 창을 닫음
                                            this.activeIndex = -1;
                                        } else {
                                            // 백엔드에서 받은 상세 메시지를 출력할 수도 있습니다.
                                            alert(`답변 ${item.answerContent ? '수정' : '등록'}에 실패했습니다. (서버/DB 오류)`);
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
                        this.fetchQnAList(); // 페이지 로드 시 QnA 목록 불러오기
                    }
                });

                qnaApp.mount('#qna-app');
            </script>

        </body>

        </html>