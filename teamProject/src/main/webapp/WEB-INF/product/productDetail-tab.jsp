<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="/css/productDetail-style.css">
        <link rel="stylesheet" href="/css/detail-qna.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            /* QnA 모달(팝업) 관련 CSS */
            .qna-modal-overlay {
                position: fixed;
                /* 화면 전체를 덮도록 고정 */
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                /* 반투명 검은색 배경 */
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
                /* 다른 요소 위에 표시 */
            }

            .qna-modal {
                background: #fff;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                width: 90%;
                max-width: 500px;
                /* 적당한 최대 너비 설정 */
                animation: fadeIn 0.3s ease-out;
                /* 부드러운 등장 효과 */
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }

            .modal-header h3 {
                margin: 0;
                color: #3E2723;
                font-size: 1.25rem;
            }

            .modal-close-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #6c757d;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #495057;
            }

            .qna-modal input[type="text"],
            .qna-modal textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ced4da;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .modal-actions {
                margin-top: 25px;
                text-align: right;
            }

            .btn-primary,
            .btn-secondary {
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                margin-left: 10px;
            }

            .btn-primary {
                background-color: #3E2723;
                color: white;
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.95);
                }

                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }
        </style>
    </head>

    <body>

        <div id="tab">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div class="product-detail-container">
                <div class="tab-menu">
                    <button class="tab-btn" :class="{ active: currentTab === 'detail' }"
                        @click="currentTab = 'detail'">상세정보</button>

                    <button class="tab-btn" :class="{ active: currentTab === 'review' }"
                        @click="selectTab('review')">리뷰</button>

                    <button class="tab-btn" :class="{ active: currentTab === 'qna' }"
                        @click="selectTab('qna')">QnA</button>
                </div>

                <div class="tab-content">

                    <div v-if="currentTab === 'detail'">
                        <p>제품 상세 설명.</p>
                    </div>

                    <div v-if="currentTab === 'review'"> <!--후기 탭-->
                        <section class="review-list">
                            <div class="review-block" v-for="item in reviewList">
                                <div class="review-photo-area">
                                    후기사진
                                </div>
                                <div class="review-content-area">
                                    <div class="review-meta">
                                        <span class="nickname">{{item.userName}}</span>
                                        <span class="date">{{item.cdatetime}}</span>
                                    </div>
                                    <p class="review-text">{{item.reviewContent}}</p>
                                    <div class="rating">
                                        <span class="rating-label">별점:</span>
                                        <span class="rating-stars">
                                            <span v-for="n in 5" :key="n">
                                                <i v-if="n <= item.rating" class="fas fa-star"></i>
                                                <i v-else class="far fa-star"></i>
                                            </span>
                                        </span>
                                    </div>
                                </div>
                            </div>

                        </section>

                    </div>

                    <div v-if="currentTab === 'qna'"> <!--큐엔에이 탭-->
                        <h1 class="qna-title">Q&A</h1>
                        <hr class="divider">


                        <table>
                            <colgroup>
                                <col style="width: 10%;">
                                <col style="width: 57%;">
                                <col style="width: 8%;">
                                <col style="width: 10%;">
                                <col style="width: 15%;">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>답변 상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template v-for="(item, index) in list" :key="item.questionId">
                                    <tr @click="toggleAnswer(index)" style="cursor: pointer;">
                                        <td>{{item.questionId}}</td>
                                        <td>
                                            <strong style="color: #c0392b;">Q.</strong> {{item.questionContent}}
                                        </td>
                                        <td>{{item.userName}}</td>
                                        <td>{{item.questionDate}}</td>
                                        <td class="status-cell">
                                            <span v-if="item.answerContent" class="status-btn completed">
                                                완료
                                            </span>
                                            <span v-else class="status-btn waiting">
                                                대기
                                            </span>
                                        </td>
                                    </tr>

                                    <tr v-if="item.answerContent" v-show="activeIndex === index" class="answer-row">
                                        <td colspan="5"
                                            style="padding: 20px 30px 20px 60px; text-align: left; background-color: #f9f9f9;">
                                            <div class="answer-content">
                                                <strong style="color: #3498db;">A.</strong>
                                                <p style="margin-top: 5px;">{{item.answerContent}}</p>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                        <!-- QnA 작성 버튼 -->
                        <div class="qna-write-container">
                            <button class="qna-write-btn" @click="fnWriteQna">Q&A 작성</button>
                        </div>

                        <!--페이징-->
                        <div class="pagination">
                            <!-- 페이지 숫자 양옆 화살표 (fnMove) -->
                            <a href="#" @click="fnMove(-1)" v-if="page != 1">&lt;</a>
                            <a href="#" v-for="num in index" :key="num" @click="fnPage(num)"
                                :class="{ active : page == num }">
                                {{num}}
                            </a>
                            <a href="#" @click="fnMove(+1)" v-if="page != index">&gt;</a>
                        </div>

                    </div>

                    <div v-if="showQnaModal" class="qna-modal-overlay">
                        <div class="qna-modal">
                            <div class="modal-header">
                                <h3>Q&A 질문 등록</h3>
                                <button class="modal-close-btn" @click="closeQnaModal">&times;</button>
                            </div>

                            <div class="modal-body">
                                <div class="form-group">
                                    <label for="qnaContent">내용</label>
                                    <textarea id="qnaContent" v-model="qnaContents" rows="6"
                                        placeholder="300자 이내로 작성하여주세요." required></textarea>
                                </div>

                                <div class="modal-actions">
                                    <button class="btn-primary" @click="submitQna">등록하기</button>
                                    <button class="btn-secondary" @click="closeQnaModal">취소</button>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </body>

    </html>

    <script>
        const tab = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    proNo: "${proNo}",
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                    // ⭐ [추가] 현재 활성화된 탭을 저장하는 변수
                    currentTab: 'detail', // 'detail', 'review', 'qna' 중 하나

                    list: [],

                    keyword: "", // 헤더 검색 키워드 변수 추가

                    activeIndex: -1, // 현재 열려 있는 Q&A의 인덱스 (-1은 아무것도 열려있지 않음)

                    pageSize: 10, // 한 페이지에 출력할 게시글 개수 (10개로 기본값)
                    page: 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index: 0, // 최대 페이지 값 (표현할 페이지 개수)

                    myQnaOnly: false, // 나의 질문만 보기 여부

                    qnaKeyword: "", // 화면 하단 QnA 검색 키워드
                    searchOption: "all",

                    reviewList: [],

                    showQnaModal: false, // 팝업 표시 여부
                    qnaContents: '',
                    infoList: {}

                };
            },
            methods: {
                // 함수(메소드) - (key : function())

                //탭 선택 및 내용 불러오기 함수
                selectTab(tabName) {
                    this.currentTab = tabName;

                    // 선택한 탭에 따라 AJAX 요청을 분기 처리
                    if (tabName === 'review') {
                        this.fnReviewList();
                    } else if (tabName === 'qna') {

                    } else if (tabName === 'detail') {
                        // '상세정보'는 기본적으로 HTML에 포함되거나 별도 처리가 필요 없을 수 있습니다.
                    }
                },

                // 리뷰 목록 불러오기
                fnReviewList() {
                    let self = this;

                    let param = {
                        proNo: self.proNo
                    };
                    $.ajax({
                        url: "/product/reviewList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.reviewList = data.list
                            console.log(data.result);
                        }
                    });
                },

                fnPageSizeChange: function () {
                    let self = this;
                    self.page = 1; // 페이지 초기화
                    self.fnQnaList1();
                },

                fnQnaList1: function () {
                    let self = this;
                    let param = {
                        proNo: self.proNo,
                        qnaKeyword: self.qnaKeyword,
                        searchOption: self.searchOption,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize
                    };

                    // '나의 질문' 보기 체크 시(myQnaOnly가 true일 때) userId 추가
                    if (self.myQnaOnly && self.userId) {
                        param.userId = self.userId;
                    }

                    $.ajax({
                        url: "/product/qna.dox", // QnA 리스트 조회주소 
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      
                            self.index = Math.ceil(data.cnt / self.pageSize);
                            // 게시글 총개수를 몇페이지씩 표시할지 기준으로 나누고, 소수점 발생시 올림처리 => index에 넣기
                        }
                    });
                },

                // QnA 답변을 보이거나 숨기는 토글 함수
                toggleAnswer: function (index) {
                    let self = this;
                    // 만약 이미 열려있는 항목을 다시 클릭하면 닫고 (-1로 설정)
                    if (self.activeIndex === index) {
                        self.activeIndex = -1;
                    }
                    // 다른 항목을 클릭하면 새 항목을 열기
                    else {
                        self.activeIndex = index;
                    }
                },

                // 헤더 검색창에 내용 검색했을 때 main 쪽에서 검색되도록
                fnList: function () {
                    let self = this;
                    let param = {
                        keyword: self.keyword
                    };
                    $.ajax({
                        url: "/main/list.dox", // 상품 리스트 조회주소 
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data.list);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      

                        }
                    });
                },
                fnInfo: function () {
                    let self = this;
                    let param = {
                        proNo: self.proNo
                    };
                    $.ajax({
                        url: "/product/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.infoList = data.info;
                        }
                    });
                },

                // 페이지 숫자 클릭시 리스트를 페이지에 맞게 갱신   
                fnPage: function (num) { // 파라미터로 클릭한 num 보내주기
                    let self = this;
                    self.page = num; // 현재 페이지를 num의 숫자로 반영
                    self.fnQnaList1(); // 반영 후 기준으로 리스트 재호출
                },

                // 페이지 숫자 양옆 화살표 버튼 누르면 페이지 이동
                fnMove: function (move) {
                    let self = this;
                    self.page += move; // 현재 페이지를 -1 또는 +1 
                    self.fnQnaList1();
                },
                fnWriteQna: function () {
                    this.showQnaModal = true;
                },

                // ⭐ [추가] 팝업 닫기 함수
                closeQnaModal: function () {
                    this.showQnaModal = false;
                },

                // ⭐ [추가] QnA 등록 처리 함수
                submitQna: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                        return;
                    }
                    // 필수 입력 값 검증
                    if (!self.qnaContents) {
                        alert("내용을 입력해주세요.");
                        return;
                    }

                    // 서버로 전송할 데이터 준비
                    let param = {
                        proNo: self.proNo, // 상품 번호
                        userId: self.userId, // 작성자 ID
                        qnaContents: self.qnaContents, // 작성 내용
                        storeId: self.infoList.storeId
                    };
                    $.ajax({
                        url: "/product/qnaInsert.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result === 'success') {
                                alert("질문이 등록되었습니다.");
                                self.closeQnaModal(); // 팝업 닫기
                                self.fnQnaList1(); // QnA 목록 새로고침
                            } else {
                                alert("질문 등록에 실패했습니다.");
                            }
                        },
                        error: function () {
                            alert("서버 통신 오류가 발생했습니다.");
                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                // QnA 목록 가져오기
                self.fnQnaList1();
                self.fnReviewList();
                self.fnInfo();
                // 헤더에서 keyword (검색어) 이벤트 수신 (주석처리해도 되네?)
                // emitter.on('keyword', (keyword) => {
                //     console.log("헤더에서 받은 검색어:", keyword);
                //     self.keyword = keyword;
                //     self.fnList(); // 메인에서 검색 실행
                // });

                // 헤더 메뉴 중 '카테고리' 하위 메뉴 클릭 이벤트 수신
                emitter.on('categoryClick', (categoryName) => {
                    console.log("카테고리 클릭:", categoryName);
                    self.selectedCategory = categoryName;
                    self.fnList(); // 해당 카테고리 상품만 조회
                });
            }
        });

        tab.mount('#tab');
    </script>