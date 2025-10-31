<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 내 주변 디저트 지점 찾기 ::</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>

        <!-- mitt 불러오기 -->
        <!-- <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script>  -->         
        

        <style>
            /* 제목 스타일 */
            .title {
                font-size: 28px;        /* 적당히 크고 눈에 띄게 */
                font-weight: 700;       /* 진하게 */
                font-family: 'GmarketSansMedium', sans-serif;
                color: #333;            /* 어두운 색상으로 가독성 확보 */
                margin-top: 30px;       /* 위에 간격 */
                margin-bottom: 25px;    /* 아래(목록 설정)와의 간격 */
                padding-bottom: 10px;   /* 구분선과 텍스트 사이의 간격 */
                text-align: left;       /* 왼쪽 정렬 */
            }

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

            /* 제목은 왼쪽 정렬 */
            table td:nth-child(1) {
                text-align: center;
                padding-left: 20px;
            }

            table td:nth-child(2) {
                text-align: left;
                white-space: nowrap;      /* 텍스트가 줄 바꿈 되는 것을 방지 */
            }
          
            /* N개씩 보기 */
            .pageSelect {
                padding: 8px 10px;
                border: 1px solid #ccc;
                border-radius: 4px; /* 살짝 둥근 모서리 */
                font-size: 13px;
                height: 35px; /* 버튼, 입력창과 높이 맞추기 */
                -moz-appearance: none;
                appearance: none;
                background-color: white;
                margin-bottom: 30px;
            }

            /* 검색 기능 컨테이너 스타일 */
            .search-area {
                display: flex; /* 요소들을 한 줄에 정렬 */
                gap: 10px; /* 요소들 사이의 간격 */
                justify-content: center; /* 가운데 정렬 (페이지 하단에 적용 시) */
                align-items: center;
                margin-top: 30px; /* 목록 위/아래 공간 확보 */
                margin-bottom: 30px;
            }

            /* 드롭다운 (select) 스타일 */
            .search-area select {
                padding: 8px 10px;
                border: 1px solid #ccc;
                border-radius: 4px; /* 살짝 둥근 모서리 */
                font-size: 14px;
                height: 38px; /* 버튼, 입력창과 높이 맞추기 */
                -webkit-appearance: none; /* 기본 화살표 숨기기 */
                -moz-appearance: none;
                appearance: none;
                background-color: white;
            }

            /* 입력 필드 (input) 스타일 */
            .search-area input {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
                flex-grow: 1; /* 남은 공간을 채우도록 너비 확장 */
                max-width: 300px; /* 최대 너비 지정으로 너무 길어지는 것을 방지 */
                height: 40px;
            }

            /* 검색 버튼 (button) 스타일 */
            .search-area button {
                padding: 8px 15px;
                background-color: #555; /* 어두운 계열 (헤더 QnA 버튼과 유사하게) */
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.3s;
                height: 38px;
            }

            .search-area button:hover {
                background-color: #333;
            }

            .info{
                margin-left: 30px;
                font-size: 12px;
                color:#666;
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
                        <h1 class="title">내 주변 디저트 지점 찾기</h1>
                        <hr class="divider">

                        <!-- 게시글 페이징 (N개씩 보기) -->
                        <select v-model="pageSize" @change="fnPageSizeChange" class="pageSelect">
                             <!-- 바꿀때마다 페이지 초기화 -->
                            <option value="5">:: 5개씩 ::</option>
                            <option value="10">:: 10개씩 ::</option>
                            <option value="20">:: 20개씩 ::</option>
                        </select>

                        <div>※ 현재 고객님의 마이페이지 주소를 기반으로 한 주변 디저트 지점 정보입니다. </div>
                        <div>
                            내 주소 : {{info.userAddr}}
                        </div>
                        
                        
                        

                         <!--페이징-->                        
                         <div class="pagination">
                            <!-- 페이지 숫자 양옆 화살표 (fnMove) -->
                            <a href="#" @click="fnMove(-1)" v-if="page != 1">&lt;</a>
                            <a href="#" v-for="num in index" :key="num" @click="fnPage(num)" :class="{ active : page == num }" >
                                {{num}} 
                            </a>
                            <a href="#" @click="fnMove(+1)" v-if="page != index">&gt;</a>
                        </div>
                      

                        <section class="external-ad">
                            <p>외부 광고</p>
                        </section>
                    </main>
                </div>
            </div>
            <!-- 푸터 -->
            <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        // mitt 전역 이벤트 버스 생성 (헤더, 메인 양쪽에서 동일하게 사용)
        //const emitter = mitt();

        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    info : {},
                    list: [],
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디

                    proNo : "", // 상품번호
                    keyword: "", // 헤더 검색 키워드 변수 추가

                    activeIndex: -1, // 현재 열려 있는 Q&A의 인덱스 (-1은 아무것도 열려있지 않음)

                    pageSize : 10, // 한 페이지에 출력할 게시글 개수 (10개로 기본값)
                    page : 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index : 0, // 최대 페이지 값 (표현할 페이지 개수)

                    myQnaOnly: false, // 나의 질문만 보기 여부

                    qnaKeyword : "", // 화면 하단 QnA 검색 키워드
                    searchOption : "all",

                };
            },

            methods: {
                // 함수(메소드) - (key : function())

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
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      

                        }
                    });
                },

                // 로그인 세션 사용자의 주소 불러오기
                fnUserInfo: function () {
                let self = this;
                let param = {
                    userId : self.userId
                };
                $.ajax({
                    url: "/main/userAddr.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) { // data에는 service에서 작성한 info와 result가 담김
                        self.info = data.info;
                    }
                });
                },

                // 페이지 초기화
                fnPageSizeChange: function() {
                    let self = this;
                    self.page = 1; 
                    self.fnQnaList();
                },           

                // 페이지 숫자 클릭시 리스트를 페이지에 맞게 갱신   
                fnPage : function(num){ // 파라미터로 클릭한 num 보내주기
                    let self = this; 
                    self.page = num; // 현재 페이지를 num의 숫자로 반영
                    self.fnQnaList(); // 반영 후 기준으로 리스트 재호출
                },

                // 페이지 숫자 양옆 화살표 버튼 누르면 페이지 이동
                fnMove : function(move){
                    let self = this; 
                    self.page += move; // 현재 페이지를 -1 또는 +1 
                    self.fnQnaList();
                },
                                

            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트 
                self.fnUserInfo();                           


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

    

        app.mount('#app');
    </script>