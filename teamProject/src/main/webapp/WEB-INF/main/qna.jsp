<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: QnA ::</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>

        <!-- mitt 불러오기 -->
        <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script> 

        <style>
            table {
                width: 100%; /* 테이블 전체 너비 */
                border-collapse: collapse; /* 테이블 셀 경계선을 하나로 합침 */
                table-layout: fixed; /* 컬럼 너비를 고정된 비율로 설정 */
                margin-top: 20px;
                font-size: 14px;
            }

            /* 2. 테이블 헤더와 셀 스타일 */
            th, td {
                padding: 15px 10px; /* 셀 내부 여백을 넓직하게 설정 */
                border-bottom: 1px solid #eee; /* 하단에 옅은 회색 선 추가 */
                text-align: center; /* 기본 텍스트는 가운데 정렬 */
            }

            table .status-cell {
                /* 완료, 대기 부분 */
                text-align: center; 
                vertical-align: middle;
            }
            /* 제목은 왼쪽 정렬 */
            table td:nth-child(1) {
                text-align: center;
                padding-left: 20px;
            }

            table td:nth-child(2) {
                text-align: left;
                white-space: nowrap;      /* 텍스트가 줄 바꿈 되는 것을 방지 */
            }
            

            /* 5. 답변 상태 버튼 스타일 (이미지 '대기', '완료' 부분) */
            table .status-btn {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
                min-width: 50px;
                text-align: center;
                border: none;
                cursor: default;
            }

            /* 답변 상태별 색상 */
            table .status-btn.waiting { /* '대기' 상태 */
                background-color: #f0f0f0;
                color: #666;
            }

            table .status-btn.completed { /* '완료' 상태 */
                background-color: #e9f7ef; /* 옅은 녹색 */
                color: #27ae60; /* 진한 녹색 */
                border: 1px solid #27ae60;
            }

        </style>
    </head>

    <body>
        <!-- 헤더 -->
        <%@ include file="/WEB-INF/main/header.jsp" %>

            <div id="app">
                <!-- html 코드는 id가 app인 태그 안에서 작업 -->

                <div class="container">


                    <main class="content-container">                        

                        <hr class="divider">

                        <!-- 게시글 페이징 (N개씩 보기) -->
                        <select v-model="pageSize" @change="fnQnaList"> <!-- 바꿀때마다 목록 갱신 -->
                            <option value="5">5개씩</option>
                            <option value="10">10개씩</option>
                            <option value="20">20개씩</option>
                        </select>

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
                                <tr v-for="item in list">
                                    <td>{{item.questionId}}</td>
                                    <td>{{item.questionContent}}</td>
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
                            </tbody>
                        </table>                    
         

                        <div class="pagination">
                            <a href="#">&lt;</a>
                            <a href="#" class="active">1</a>
                            <a href="#">2</a>
                            <a href="#">3</a>
                            <a href="#">&gt;</a>
                        </div>


                      

                        <section class="external-ad">
                            <p>외부 광고</p>
                        </section>
                    </main>
                </div>
            </div>
    </body>

    </html>

    <script>
        // mitt 전역 이벤트 버스 생성 (헤더, 메인 양쪽에서 동일하게 사용)
        const emitter = mitt();

        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)

                    list: [],
                    userId: "${userId}", // 로그인 했을 시 전달 받은 아이디

                    proNo : "", // 상품번호
                    keyword: "", // 헤더 검색 키워드 변수 추가

                    pageSize : 5, // 한 페이지에 출력할 게시글 개수 (5개로 기본값)
                    page : 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index : 0, // 최대 페이지 값 (표현할 페이지 개수)

                    qnaKeyword : "" // 화면 하단 QnA 검색 키워드

                };
            },

            methods: {
                // 함수(메소드) - (key : function())
                fnQnaList: function () {
                    let self = this;
                    let param = {
                        qnaKeyword: self.qnaKeyword,
                        pageSize : self.pageSize,
                        page : (self.page-1) * self.pageSize
                    };
                    $.ajax({
                        url: "/main/qna.dox", // QnA 리스트 조회주소 
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      

                        }
                    });
                },
                                

            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트

                // QnA 목록 가져오기
                self.fnQnaList();               


                // 헤더에서 keyword (검색어) 이벤트 수신
                emitter.on('keyword', (keyword) => {
                    console.log("헤더에서 받은 검색어:", keyword);
                    self.keyword = keyword;
                    self.fnList(); // 메인에서 검색 실행
                });

                // 헤더 메뉴 중 '카테고리' 하위 메뉴 클릭 이벤트 수신
                emitter.on('categoryClick', (categoryName) => {
                    console.log("카테고리 클릭:", categoryName);
                    self.selectedCategory = categoryName;
                    self.fnList(); // 해당 카테고리 상품만 조회
                });

            }
        });

    

        app.mount('#app');
    </script>