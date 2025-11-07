<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 원재료 미포함 상품찾기 ::</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>

        <!-- mitt 불러오기 -->
        <!-- <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script>  -->

        <style>
            /* QnA 제목 스타일 */
            .title {
                font-size: 28px;
                font-weight: 700;
                color: #333;
                margin-top: 30px;
                margin-bottom: 25px;
                padding-bottom: 10px;
                /* 구분선과 텍스트 사이의 간격 */
                text-align: left;
                /* 왼쪽 정렬 */
            }

            /* 새 목록 컨테이너 스타일 */
            .ingredient-list {
                display: flex;
                flex-wrap: wrap;
                /* 줄바꿈 허용 */
                justify-content: flex-start;
                /* 왼쪽부터 정렬 */
                gap: 15px;
                /* 아이템 간 간격 */
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 15px;
                margin-top: 20px;
            }

            /* 목록 아이템 스타일 */
            .ingredient-item {
                flex: 1 1 calc(33% - 20px);
                /* 3열 정렬 (간격 고려) */
                box-sizing: border-box;
                padding: 10px;
                border: 1px solid #eee;
                border-radius: 4px;
                display: flex;
                align-items: flex-start;
                min-height: 45px;
                transition: all 0.2s ease;
            }

            .ingredient-item:hover {
                background-color: #f9f9f9;
                border-color: #aaa;
            }

            .ingredient-label {
                display: flex;
                align-items: center;
                gap: 10px;
                width: 100%;
                cursor: pointer;
            }

            /* 체크되었을 때 시각 효과 */
            .ingredient-checkbox:checked+.ingredient-text {
                font-weight: bold;
                color: #d47fa6;
            }

            .item-checkbox {
                margin-right: 10px;
                margin-top: 4px;
                /* 체크박스 위치 조정 */
            }

            .item-content {
                flex-grow: 1;
                text-align: left;
            }

            .ingredient-name {
                font-weight: 600;
                font-size: 14px;
                color: #333;
            }

            .ingredient-description {
                font-size: 12px;
                color: #666;
                margin-top: 3px;
                line-height: 1.4;
            }

            /* 검색 기능 컨테이너 스타일 */
            .search-area {
                /* ... 기존 스타일 유지 ... */
                justify-content: flex-end;
                /* '검색' 버튼을 오른쪽으로 배치 */
            }

            /* 페이징 스타일 추가 (기존 코드에 없으므로 간단히 추가) */
            .pagination {
                text-align: center;
                margin-top: 20px;
            }

            .pagination a {
                display: inline-block;
                padding: 5px 10px;
                margin: 0 5px;
                border: 1px solid #ccc;
                text-decoration: none;
                color: #333;
                border-radius: 4px;
            }

            .pagination a.active {
                background-color: #555;
                color: white;
                border-color: #555;
            }


            /* 검색 기능 컨테이너 스타일 */
            .search-area {
                display: flex;
                /* 요소들을 한 줄에 정렬 */
                gap: 10px;
                /* 요소들 사이의 간격 */
                justify-content: center;
                /* 가운데 정렬 (페이지 하단에 적용 시) */
                align-items: center;
                margin-top: 30px;
                /* 목록 위/아래 공간 확보 */
                margin-bottom: 30px;
            }

            /* 검색 버튼 (button) 스타일 */
            .search-area button {
                padding: 8px 15px;
                background-color: #555;
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

            .info {
                font-size: 14px;
                color: #666;
                margin-bottom: 30px;
            }

            .no-result {
                text-align: center;
                color: #636161;
                margin-top: 50px;
                font-size: 15px;
                padding: 10px;
                border: 1px dashed #c2c0c0;
                border-radius: 8px;
                background-color: #f9f9f9;
                margin-bottom: 100px;
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
                        <h1 class="title">알레르기 원재료 미포함 제품 찾기</h1>
                        <hr class="divider">

                        <div class="info">※ 원재료 체크 후 '검색' 버튼을 누르시면 해당 재료가 미포함된 상품이 조회됩니다.</div>


                        <div class="ingredient-list">
                            <label class="ingredient-item" v-for="item in ingreList" :key="item.ingredientName">
                                <input type="checkbox" class="item-checkbox" v-model="ingreName"
                                    :value="item.ingredientName">
                                <div class="item-content">
                                    <div class="ingredient-name">
                                        {{item.ingredientName}}
                                    </div>
                                    <div class="ingredient-description">
                                        {{item.ingredientDescription}}
                                    </div>
                                </div>
                            </label>
                        </div>

                        <!-- 검색기능 -->
                        <div class="search-area">
                            <button @click="fnIngreProList">검색</button>
                        </div>

                        <!-- 해당하는 상품이 없을 경우 -->
                        <div v-if="emptyMessage" class="no-result">
                            {{ emptyMessage }}
                        </div>

                        <!-- 상품목록 (해당하는 상품 있을 경우) -->
                        <div v-else class="product-grid">
                            <div class="product-item" v-for="item in proList" @click="fnProDetail(item.proNo)">
                                <div class="product-image-wrapper">
                                    <div class="product-image-placeholder">판매자 등록 썸네일</div>
                                    <!-- 멤버쉽 Y이면 추천 딱지 표시 -->
                                    <img v-if="item.membership === 'Y'" class="recommend-badge" src="/img/recommend.png"
                                        alt="추천 딱지">
                                </div>
                                <p class="product-title">{{item.proName}}</p>
                                <p>{{item.storeName}}</p>
                                <p :class="{ 'chat-disabled': item.isChatEnabled !== 'Y' }">
                                    채팅: {{ item.isChatEnabled === 'Y' ? '가능' : '불가능' }}
                                </p>
                                <p class="product-price">{{item.price}}원 ~</p>
                                <p class="product-delivery">배송비: {{item.deliveryFee}}원</p>
                            </div>
                        </div>


                        <!--페이징-->
                        <div class="pagination" v-if="proList && proList.length > 0">
                            <!-- 페이지 숫자 양옆 화살표 (fnMove) -->
                            <a href="#" @click="fnMove(-1)" v-if="page != 1">&lt;</a>
                            <a href="#" v-for="num in index" :key="num" @click="fnPage(num)"
                                :class="{ active : page == num }">
                                {{num}}
                            </a>
                            <a href="#" @click="fnMove(+1)" v-if="page != index">&gt;</a>
                        </div>

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
                    list: [],
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                    proNo: "", // 상품번호
                    keyword: "", // 헤더 검색 키워드 변수 추가

                    pageSize: 4, // 한 페이지에 출력할 게시글 개수 (4개로 기본값)
                    page: 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index: 0, // 최대 페이지 값 (표현할 페이지 개수)

                    ingreList: [], // 전체 원재료 목록
                    ingreName: [], // 체크한 원재료 목록 담기
                    proList: [], //  원재료 '검색' 결과 상품 목록 (fnIngreProList 결과)
                    emptyMessage: "",
                };
            },

            methods: {
                // 함수(메소드) - (key : function())                

                // 원재료 리스트 전체 불러오기
                fnIngreList: function () {
                    let self = this;
                    let param = {
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize
                    };
                    $.ajax({
                        url: "/main/ingre-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.ingreList = data.list; // data에 있는 list 값을 변수 list에 담기                                 
                        }
                    });
                },

                // '검색' 클릭 시 해당 원재료 미포함 상품 불러오기
                fnIngreProList: function () {
                    let self = this;
                    // 배열이 아닐 때 강제로 배열로 변환 
                    let names = Array.isArray(self.ingreName) ? self.ingreName : [self.ingreName];

                    let param = {
                        ingreName: self.ingreName,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize
                    };
                    $.ajax({
                        url: "/main/ingre-pro-list.dox",
                        dataType: "json",
                        type: "POST",
                        traditional: true, // ★★ 매우 중요 (배열 전송시 HashMap으로 인식시키기)
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.proList = data.list; // data에 있는 list 값을 변수 list에 담기 
                            self.index = Math.ceil(data.cnt / self.pageSize);

                            // 결과가 없으면 메시지 표시
                            if (!data.list || data.list.length === 0) {
                                self.emptyMessage = "해당 원재료를 포함하지 않는 상품이 없습니다.";
                            } else {
                                self.emptyMessage = ""; // 기존 메시지 초기화
                            }
                        }
                    });
                },

                // 리스트에서 상품 클릭시 상세페이지 이동
                fnProDetail: function (proNo) {
                    let self = this;
                    console.log(proNo); // main 화면에서 클릭한 상품번호 출력(확인완료)
                    pageChange("/productDetail.do", { proNo: proNo });  // 상세페이지로 proNo 넘겨줌            
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
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      

                        }
                    });
                },

                fnPageSizeChange: function () {
                    let self = this;
                    self.page = 1; // 페이지 초기화
                    self.fnIngreList();
                },

                // 페이지 숫자 클릭시 리스트를 페이지에 맞게 갱신   
                fnPage: function (num) { // 파라미터로 클릭한 num 보내주기
                    let self = this;
                    self.page = num; // 현재 페이지를 num의 숫자로 반영
                    self.fnIngreList(); // 반영 후 기준으로 리스트 재호출
                },

                // 페이지 숫자 양옆 화살표 버튼 누르면 페이지 이동
                fnMove: function (move) {
                    let self = this;
                    self.page += move; // 현재 페이지를 -1 또는 +1 
                    self.fnIngreList();
                },


            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트

                // 원재료 목록 가져오기
                self.fnIngreList();

                self.index = 1;


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