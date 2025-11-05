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
                /* (기존 CSS 스타일 유지) */
                body {
                    margin: 0;
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: #f4f4f4;
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
                    max-width: 1200px;
                    margin: 0 auto;
                    padding-top: 30px;
                }

                .page-title {
                    font-size: 24px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    color: #333;
                }

                .qna-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                    font-size: 14px;
                }

                .qna-table th,
                .qna-table td {
                    border: 1px solid #ddd;
                    padding: 12px;
                    text-align: center;
                }

                .qna-table th {
                    background-color: #f8f8f8;
                    font-weight: 600;
                    color: #555;
                }

                .qna-table td {
                    color: #333;
                }

                .status-cell {
                    text-align: center;
                }

                .status-btn {
                    padding: 5px 10px;
                    border-radius: 4px;
                    color: white;
                    font-weight: bold;
                }

                .completed {
                    background-color: #28a745;
                }

                .waiting {
                    background-color: #dc3545;
                }

                .qna-table .content-col {
                    text-align: left;
                }

                .action-button {
                    background-color: #007bff;
                    color: white;
                    border: none;
                    padding: 8px 15px;
                    border-radius: 4px;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }

                .action-button:hover {
                    background-color: #0056b3;
                }

                .answer-row {
                    background-color: #f9f9f9;
                }

                .answer-content {
                    padding: 15px;
                }

                .answer-content strong {
                    color: #3498db;
                }

                /* 추가된 스타일 */
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
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-sizing: border-box;
                    resize: vertical;
                }

                .answer-form-area button {
                    align-self: flex-end;
                    /* 버튼을 오른쪽으로 정렬 */
                    background-color: #ff9800;
                    /* 주황색 버튼 */
                }

                .answer-form-area button:hover {
                    background-color: #e68900;
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

                                        console.log("매핑된 QnA 리스트:", this.qnaList);
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