<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 QnA 게시판</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" 
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
        crossorigin="anonymous"></script>
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

        /* 검색 영역 스타일 추가 */
        .search-area {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            background-color: #f9f9f9;
            align-items: center;
        }
        .search-area input[type="text"] {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 200px;
        }
        .search-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .search-button:hover {
            background-color: #1e7e34;
        }
    </style>
</head>

<body>

    <div id="qna-app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">상품 QnA 게시판</h1>
                
                <div class="search-area">
                    <label for="proNo-input" style="font-weight: bold;">상품 번호 검색:</label>
                    <input type="text" id="proNo-input" v-model="searchProNo" placeholder="상품 번호를 입력하세요" @keyup.enter="searchQnA">
                    <button class="search-button" @click="searchQnA">검색</button>
                </div>
                <p>현재 조회 중인 상품 번호: **{{ proNo }}**</p>

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
                            <td :class="qna.isAnswered === 'Y' ? 'status-Y' : 'status-N'">
                                {{ qna.isAnswered === 'Y' ? '완료' : '미답변' }}
                            </td>
                            <td>
                                <button class="action-button" @click="showAnswerModal(qna)">
                                    {{ qna.isAnswered === 'Y' ? '답변 수정' : '답변 등록' }}
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
                <div v-if="isModalOpen" class="modal-backdrop">
                    <div class="modal-content">
                        <h2>{{ currentQnA.isAnswered === 'Y' ? '답변 수정' : '답변 등록' }}</h2>
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
                // 페이지 로드 시 URL 파라미터에서 상품 번호를 가져옵니다.
                const initialProNo = '<%= request.getParameter("proNo") != null ? request.getParameter("proNo") : "" %>';

                return {
                    // **현재 화면에 표시되는 QnA 목록의 상품 번호**
                    proNo: initialProNo || '1', 
                    // **검색 입력 필드에 바인딩할 변수**
                    searchProNo: initialProNo, 
                    qnaList: [],
                    loading: true,
                    isModalOpen: false,
                    currentQnA: null,
                    answerText: '',
                };
            },
            methods: {
                // 검색 버튼 클릭 시 호출
                searchQnA() {
                    // 1. 입력된 상품 번호로 현재 조회 상품 번호를 업데이트합니다.
                    if (this.searchProNo.trim()) {
                        this.proNo = this.searchProNo.trim();
                        // 2. 새로운 상품 번호로 목록을 다시 불러옵니다.
                        this.fetchQnAList();
                    } else {
                        alert("검색할 상품 번호를 입력해주세요.");
                    }
                },
                
                // 서버에서 QnA 목록을 불러오는 AJAX 통신 로직
                fetchQnAList() {
                    this.loading = true;
                    this.qnaList = [];

                    const targetProNo = this.proNo; // 현재 조회 중인 proNo를 사용

                    if (!targetProNo || targetProNo === 'null' || targetProNo.trim() === '') {
                        console.warn("상품 번호가 없어 목록을 조회하지 않습니다.");
                        this.loading = false;
                        return;
                    }

                    $.ajax({
                        url: "/seller/qnaList.dox", 
                        method: "POST",
                        dataType: "json",
                        data: {
                            proNo: targetProNo // 현재 proNo 값을 서버에 보냅니다.
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
                    // 기존 답변이 있으면 텍스트 영역에 채워넣음
                    this.answerText = qna.answerContent && qna.answerContent !== '답변이 등록되지않았습니다.' ? qna.answerContent : '';
                    this.isModalOpen = true;
                },

                // 답변을 서버에 제출하는 메서드 (추후 구현 필요)
                submitAnswer() {
                    if (!this.answerText.trim()) {
                        alert("답변 내용을 입력해주세요.");
                        return;
                    }

                    // 🚨 [TODO] 답변 등록/수정 AJAX 통신 로직 추가 필요
                    alert("[임시] 답변 제출: Question ID=" + this.currentQnA.questionId + ", 상품 번호=" + this.proNo);
                    
                    // 성공했다고 가정하고 모달 닫고 목록 새로고침
                    this.isModalOpen = false;
                    this.fetchQnAList(); 
                }
            },
            mounted() {
                // 페이지 로드 시 초기 상품 번호로 목록을 불러옵니다.
                if (this.proNo) {
                    this.fetchQnAList();
                }
            }
        });

        qnaApp.mount('#qna-app');
    </script>
</body>

</html>