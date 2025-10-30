<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 디저트 연구소 ::</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>

        <!-- mitt 불러오기 -->
        <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script> 

        <style>

        </style>
    </head>

    <body>
        <!-- 헤더 -->
        <%@ include file="/WEB-INF/main/header.jsp" %>

            <div id="app">
                <!-- html 코드는 id가 app인 태그 안에서 작업 -->

                <div class="container">





                    <main class="content-container">

                        <div class="main-content-top">
                            <section class="banner-slider">
                                <div class="slider-controls">
                                    <button class="prev">〈</button>
                                    <span>멤버십 가게 광고 배너</span>
                                    <button class="next">〉</button>
                                </div>
                            </section>

                            <div class="top-actions">
                                <button class="action-btn location-btn" @click="fnMapDessert()">
                                    <!-- 내 주변 가게찾기 버튼-->
                                </button>
                                <button class="action-btn cart-btn" @click="fnCart()">
                                    <!-- 장바구니 버튼 -->

                                </button>
                            </div>
                        </div>

                        <section class="main-category">
                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '' }"
                                @click.prevent="selectedCategory = ''; fnList()">전체</a>

                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '케이크' }"
                                @click.prevent="selectedCategory = '케이크'; fnList()">케이크</a>

                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '쿠키' }"
                                @click.prevent="selectedCategory = '쿠키'; fnList()">쿠키</a>

                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '초콜릿/사탕' }"
                                @click.prevent="selectedCategory = '초콜렛'; fnList()">초콜릿/사탕</a>
                        </section>

                        <hr class="divider">

                        <section class="product-list-section">

                            <!-- 지역별 / 인기순 조회 -->
                            <div>
                                <!-- 지역별 조회-->
                                <div class="product-list-section">
                                    <select v-model="area" @change="fnList">
                                        <option value="">:: 지역조회(전체) ::</option> <!--전체-->
                                        <option value="1">:: 서울 ::</option>
                                        <option value="2">:: 인천 ::</option>
                                        <option value="3">:: 경기 ::</option>
                                        <option value="4">:: 강원 ::</option>
                                        <option value="5">:: 대전/세종/충청 ::</option>
                                        <option value="6">:: 광주/전북/전남 ::</option>
                                        <option value="7">:: 부산/대구/울산 ::</option>
                                        <option value="8">:: 경북/경남 ::</option>
                                        <option value="9">:: 제주 ::</option>

                                    </select>

                                    <!--정렬 조건(번호,제목 : 오름차순 / 조회수 : 내림차순 / 시간순 : 내림차순)-->
                                    <select v-model="order" @change="fnList">
                                        <option value="1">:: 조회순 ::</option>
                                        <option value="2">:: 판매순 ::</option>
                                        <option value="3">:: 최신순 ::</option>
                                    </select>
                                </div>

                            </div>
                            <div class="product-grid">
                                <div class="product-item" v-for="item in list" @click="fnProDetail(item.proNo)">
                                    <div class="product-image-placeholder">판매자 등록 썸네일</div>
                                    <p class="product-title">{{item.proName}}</p>
                                    <p>{{item.storeName}}</p>
                                    <p :class="{ 'chat-disabled': item.isChatEnabled !== 'Y' }">
                                        채팅: {{ item.isChatEnabled === 'Y' ? '가능' : '불가능' }}
                                    </p>
                                    <p class="product-price">{{item.price}}원 ~</p>
                                    <p class="product-delivery">배송비: {{item.deliveryFee}}원</p>
                                </div>
                            </div>

                            <div class="pagination">
                                <a href="#">&lt;</a>
                                <a href="#" class="active">1</a>
                                <a href="#">2</a>
                                <a href="#">3</a>
                                <a href="#">&gt;</a>
                            </div>
                        </section>

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

                    // 메인 상단 - 멤버쉽 화면 홍보 이미지
                    productImages: [
                        '/img/member_cookies.jpg',
                        '/img/member_cake.jpg'
                        // ...
                    ],

                    list: [],
                    userId: "${userId}", // 로그인 했을 시 전달 받은 아이디
                    area: "", // 디폴트 : 전체 지역 조회
                    order: 1, // 디폴트 :  조회순 정렬
                    selectedCategory: '', // 디폴트

                    proNo : "", // 상품번호
                    keyword: "" // 검색 키워드 변수 추가

                };
            },

            methods: {
                // 함수(메소드) - (key : function())
                fnList: function () {
                    let self = this;
                    let param = {
                        // 선택할 때마다 새로 목록 가져오게 해야함(위에서 @change 처리함)
                        area: self.area,
                        order: self.order,
                        category: self.selectedCategory,
                        keyword: self.keyword
                    };
                    $.ajax({
                        url: "/main/list.dox", // 상품 리스트 조회주소 넣어야함
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      

                        }
                    });
                },

                // 내 주변 디저트 찾기
                fnMapDessert: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                    } else {
                        pageChange("", { userId: self.userId }); // 주변 디저트 찾기 페이지 주소 넣어야 함
                    }

                },

                // 장바구니 이동 
                fnCart: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                    } else {
                        pageChange("", { userId: self.userId }); // 장바구니 페이지 주소 넣어야 함
                    }
                },

                // 리스트에서 상품 클릭시 상세페이지 이동
                fnProDetail: function (proNo) {
                    let self = this;
                    console.log(proNo); // main 화면에서 클릭한 상품번호 출력(확인완료)
                    pageChange("/productDetail.do", { proNo : proNo });  // 상세페이지로 proNo 넘겨줌            
                }

            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnList();
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트


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