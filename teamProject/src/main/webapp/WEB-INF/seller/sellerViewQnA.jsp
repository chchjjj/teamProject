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
        /* (CSS 코드는 이전과 동일합니다. 생략) */
        body { margin: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f4f4; }
        .main-wrapper { display: flex; min-height: 100vh; }
        .content-area { flex-grow: 1; padding: 30px; background-color: white; margin-left: 220px; box-sizing: border-box; max-width: 1200px; margin: 0 auto; padding-top: 30px; }
        .page-title { font-size: 24px; font-weight: 700; margin-bottom: 20px; color: #333; }
        
        /* QnA 테이블 스타일 */
        .qna-table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 14px; }
        .qna-table th, .qna-table td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        .qna-table th { background-color: #f8f8f8; font-weight: 600; color: #555; }
        .qna-table td { color: #333; }
        
        /* 답변 상태 스타일 */
        .status-N { color: #dc3545; font-weight: bold; } /* 미답변: 빨간색 */
        .status-Y { color: #28a745; font-weight: bold; } /* 답변 완료: 초록색 */

        /* 내용 및 제목 정렬 */
        .qna-table .content-col { text-align: left; }
        
        /* 버튼 스타일 */
        .action-button { background-color: #007bff; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; transition: background-color 0.2s; }
        .action-button:hover { background-color: #0056b3; }

        /* 모달 스타일 */
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
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
                            <th width="10%">번호</th>
                            <th width="45%">질문 내용</th>
                            <th width="15%">작성자 ID</th>
                            <th width="15%">작성일</th>
                            <th width="5%">답변 상태</th>
                            <th width="10%">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="qnaList.length === 0">
                            <td colspan="6" style="text-align: center; padding: 30px;">
                                <p v-if="loading">QnA 목록을 불러오는 중입니다...</p>
                                <p v-else>등록된 QnA가 없습니다.</p>
                            </td>
                        </tr>
                        <tr v-for="(qna, index) in qnaList" :key="qna.questionId">
                            <td>{{ qnaList.length - index }}</td>
                            <td class="content-col">{{ qna.questionContent }}</td>
                            <td>{{ qna.userId }}</td> 
                            <td>{{ qna.questionDate }}</td>
                            
                            <td :class="qna.answerContent && qna.answerContent.trim() !== '' ? 'status-Y' : 'status-N'">
                                {{ qna.answerContent && qna.answerContent.trim() !== '' ? '완료' : '미답변' }}
                            </td>
                            <td>
                                <button class="action-button" @click="showAnswerModal(qna)">
                                    {{ qna.answerContent && qna.answerContent.trim() !== '' ? '답변 수정' : '답변 등록' }}
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div v-if="isModalOpen" class="modal-backdrop">
                    <div class="modal-content">
                        <h2>{{ currentQnA.answerContent && currentQnA.answerContent.trim() !== '' ? '답변 수정' : '답변 등록' }}</h2>
                        <p>질문: {{ currentQnA.questionContent }}</p>
                        <textarea v-model="answerText" rows="5" style="width: 100%; margin-bottom: 10px;"></textarea>
                        <div style="display: flex; justify-content: flex-end; gap: 10px;">
                            <button class="action-button" @click="submitAnswer">저장</button>
                            <button class="action-button" style="background-color: #6c757d;" @click="isModalOpen = false">닫기</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script>
        const { createApp } = Vue;

        const qnaApp = createApp({
            data() {
                // 현재 로그인된 사용자의 가게 이름을 서버로부터 받아옵니다.
                const storeNameFromServer = '<%= request.getAttribute("storeName") != null ? request.getAttribute("storeName") : "" %>';
                // 세션에서 userId를 가져옵니다. (JSP EL을 사용하려면 ${sessionId} 대신 이렇게 쓰는 것이 안전합니다.)
                const userIdFromSession = '<%= session.getAttribute("userId") != null ? session.getAttribute("userId") : "" %>'; 

                return {
                    storeName: storeNameFromServer || '스윗디저트',  // 로그인된 사용자의 가게 이름
                    qnaList: [],
                    loading: true,
                    isModalOpen: false,
                    currentQnA: null,
                    answerText: '',
                    // ⚠️ 세션 값을 가져오는 방식 통일: JSP EL 대신 스크립틀릿이나 위에서 정의한 변수 사용
                    userId: "${sessionId}",  
                };
            },
            methods: {
                // 서버에서 QnA 목록을 불러오는 AJAX 통신 로직
                fetchQnAList() {
                    this.loading = true;
                    this.qnaList = [];

                    const targetStoreName = this.storeName;

                    if (!targetStoreName || targetStoreName.trim() === '') {
                        console.warn("가게 이름이 없어 목록을 조회하지 않습니다.");
                        this.loading = false;
                        return;
                    }

                    $.ajax({
                        url: "/seller/qnaList.dox",
                        method: "POST",
                        dataType: "json",
                        data: {
                            userId: this.userId, // 로그인된 사용자 ID를 서버로 전송
                        },
                        success: (res) => {
                            if (res.result === 'success' && res.list) {
                                this.qnaList = res.list;
                                console.log("QnA 목록 조회 성공:", this.qnaList.length + "건");
                            } else {
                                this.qnaList = [];
                                console.warn("QnA 목록 조회 결과 없음 또는 실패:", res.message);
                            }
                        },
                        error: (xhr, status, error) => {
                            console.error("QnA 목록 로드 실패:", error);
                            alert("QnA 목록을 불러오는 데 실패했습니다. (HTTP " + xhr.status + ")");
                        },
                        complete: () => {
                            this.loading = false;
                        }
                    });
                },

                // 답변 등록/수정 모달을 여는 메서드
                showAnswerModal(qna) {
                    this.currentQnA = qna;
                    // Model 필드명: answerContent를 사용하여 기존 답변을 채워넣음
                    // 서버에서 "답변이 등록되지않았습니다." 와 같은 문자열을 보내는 경우를 처리
                    const answer = qna.answerContent;
                    this.answerText = (answer && answer.trim() !== '' && answer !== '답변이 등록되지않았습니다.') ? answer : '';
                    this.isModalOpen = true;
                },

                // 답변을 서버에 제출하는 메서드 (추후 구현 필요)
                submitAnswer() {
                    if (!this.answerText.trim()) {
                        alert("답변 내용을 입력해주세요.");
                        return;
                    }

                    // 🚨 [TODO] 답변 등록/수정 AJAX 통신 로직을 여기에 추가해야 합니다.
                    console.log("답변 제출 데이터:", {
                        questionId: this.currentQnA.questionId,
                        answerContent: this.answerText,
                        // ... 기타 필요한 데이터 (예: 판매자 ID)
                    });

                    alert("[임시] 답변 제출: Question ID=" + this.currentQnA.questionId + " (실제 통신 로직 구현 필요)");

                    // 성공했다고 가정하고 모달 닫고 목록 새로고침
                    this.isModalOpen = false;
                    this.fetchQnAList();
                }
            },
            mounted() {
                // 페이지 로드 시 초기 가게 이름으로 목록을 불러옵니다.
                if (this.storeName) {
                    this.fetchQnAList();
                }
            }
        });

        qnaApp.mount('#qna-app');
    </script>
</body>

</html>