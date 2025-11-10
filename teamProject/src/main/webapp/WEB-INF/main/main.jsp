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

        <!-- mitt 불러오기 (이거 먼저!)-->
        <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script>

        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>

        <link rel="icon" href="data:,">

        <style>
            .ad {
                width: 1000px;
                height: 140px
            }

            button {
                cursor: pointer;
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

                        <div class="main-content-top">
                            <section class="banner-slider">
                                <div class="slider-controls">
                                    <button class="prev" @click="fnPrevSlide">〈</button>
                                    <!-- <span>멤버십 가게 광고 배너</span> -->
                                    <button class="next" @click="fnNextSlide">〉</button>
                                </div>
                                <div class="slides-wrapper">
                                    <div class="slide" v-for="(img, i) in memberProlist" :key="i"
                                        :style="{ backgroundImage: 'url(' + (img.filePath + img.fileName).trim() + ')' }"
                                        v-show="i === currentSlide" @click="fnProDetail(img.proNo)">
                                    </div>
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
                                @click.prevent="selectedCategory = ''; page = 1; fnList()"></a>

                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '케이크' }"
                                @click.prevent="selectedCategory = '케이크'; page = 1; fnList()"></a>

                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '쿠키' }"
                                @click.prevent="selectedCategory = '쿠키'; page = 1; fnList()"></a>

                            <a href="#" class="category-btn" :class="{ active: selectedCategory === '초콜렛' }"
                                @click.prevent="selectedCategory = '초콜렛'; page = 1; fnList()"></a>
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
                            <div v-if="list.length === 0" class="no-product">
                                선택한 조건에 맞는 상품이 없습니다.
                            </div>
                            <div v-else class="product-grid">
                                <div class="product-item" v-for="item in list" @click="fnProDetail(item.proNo)">
                                    <div class="product-image-wrapper">
                                        <div class="product-image-placeholder" v-if="!item.filePath || !item.fileName">
                                            판매자 등록 썸네일
                                        </div>
                                        <img v-else :src="(item.filePath + item.fileName).trim()" alt="상품 이미지"
                                            class="product-image"
                                            style="width: 100%; height: auto; border-radius: 10px;">
                                        <!-- 멤버쉽 Y이면 추천 딱지 표시 -->
                                        <img v-if="item.membership === 'Y'" class="recommend-badge"
                                            src="/img/recommend.png" alt="추천 딱지">
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
                            <div class="pagination">
                                <!-- 페이지 숫자 양옆 화살표 (fnMove) -->
                                <a href="#" @click="fnMove(-1)" v-if="page != 1">&lt;</a>
                                <a href="#" v-for="num in index" :key="num" @click="fnPage(num)"
                                    :class="{ active : page == num }">
                                    {{num}}
                                </a>
                                <a href="#" @click="fnMove(+1)" v-if="page != index">&gt;</a>
                            </div>

                        </section>

                        <section class="external-ad">
                            <!-- <p>외부 광고</p> -->
                            <a href="/main/ad-link.do" target="_blank" @click="fnAdClick">
                                <img class="ad" src="/img/아래광고배너.png" alt="아래 광고 배너">
                            </a>
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

                    // 메인 상단 - 멤버쉽 화면 홍보 이미지
                    productImages: [
                        '/img/member_cookies.jpg',
                        '/img/member_cake.jpg'
                        // ...
                    ],

                    list: [],
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                    memberProlist: [], // 멤버쉽 판매자 상품 사진 리스트
                    currentSlide: 0, // 멤버쉽 홍보 : 첫 번째 슬라이드

                    area: "", // 디폴트 : 전체 지역 조회
                    order: 1, // 디폴트 :  조회순 정렬
                    selectedCategory: '', // 디폴트

                    proNo: "", // 상품번호
                    keyword: "", // 검색 키워드 변수 추가

                    pageSize: 8, // 한 페이지에 출력할 게시글 개수 (8개로 기본값)
                    page: 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index: 0, // 최대 페이지 값 (표현할 페이지 개수)

                    adInfo: {}, // 현재 진행 중인 배너광고(1개) 값의 전체 정보 (AD_TBL)
                    adHistoryInfo: {}, // 배너광고의 히스토리 정보 (AD_HISTORY_TBL)

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
                        keyword: self.keyword,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize
                    };
                    $.ajax({
                        url: "/main/list.dox", // 상품 리스트 조회주소 넣어야함
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      
                            //self.index = Math.ceil(data.cnt / self.pageSize);
                            self.index = Math.max(1, Math.ceil(data.cnt / self.pageSize)); //최소 1페이지 보장
                        }
                    });
                },

                // 멤버쉽 가입 판매자 상품 홍보 사진 리스트 가져오기
                fnMemberProImg: function () {
                    let self = this;
                    $.ajax({
                        url: "/main/memberProImg.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            // Vue data로 넣으면 v-for가 자동 렌더링
                            self.memberProlist = data.list;
                        },
                        error: function (err) {
                            console.error("fnMemberProImg Ajax 에러:", err);
                        }
                    });
                },

                // 멤버십 홍보사진 - 이전 슬라이드
                fnPrevSlide() {
                    let self = this;
                    if (self.currentSlide > 0) {
                        self.currentSlide--;
                    } else {
                        self.currentSlide = self.memberProlist.length - 1; // 마지막 슬라이드로 이동
                    }
                },

                // 멤버십 홍보사진 - 다음 슬라이드
                fnNextSlide() {
                    let self = this;
                    if (self.currentSlide < self.memberProlist.length - 1) {
                        self.currentSlide++;
                    } else {
                        self.currentSlide = 0; // 첫 슬라이드로 이동
                    }
                },

                // 내 주변 디저트 찾기
                fnMapDessert: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                    } else {
                        pageChange("/main/storeFinder.do", { userId: self.userId });
                    }
                },

                // 장바구니 이동 
                fnCart: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                    } else {
                        pageChange("/product/cart.do", { userId: self.userId });
                    }
                },

                // 리스트에서 상품 클릭시 상세페이지 이동
                fnProDetail: function (proNo) {
                    let self = this;
                    console.log(proNo); // main 화면에서 클릭한 상품번호 출력(확인완료)
                    pageChange("/productDetail.do", { proNo: proNo });  // 상세페이지로 proNo 넘겨줌            
                },

                // 페이지 초기화
                fnPageSizeChange: function () {
                    let self = this;
                    self.page = 1; // 페이지 초기화
                    self.fnList();
                },

                // 페이지 숫자 클릭시 리스트를 페이지에 맞게 갱신   
                fnPage: function (num) { // 파라미터로 클릭한 num 보내주기
                    let self = this;
                    self.page = num; // 현재 페이지를 num의 숫자로 반영
                    self.fnList(); // 반영 후 기준으로 리스트 재호출
                },

                // 페이지 숫자 양옆 화살표 버튼 누르면 페이지 이동
                fnMove: function (move) {
                    let self = this;
                    self.page += move; // 현재 페이지를 -1 또는 +1 
                    self.fnList();
                },

                // 하단 광고배너 값(AD_TBL) 가져오기 (클릭시 카운팅 알맞게 들어가도록)
                fnGetAdInfo: function () {
                    let self = this;
                    let param = {
                    };
                    $.ajax({
                        url: "/main/adInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.adInfo = data.info;
                            console.log("진행중 광고ID:", self.adInfo.adId); // 광고 ID 몇번인지(시퀀스)
                        }
                    });
                },

                // 하단 광고배너의 PER_MONTH 값 가져오기 (AD_HISTORY_TBL)
                fnAdPerMonth: function () {
                    let self = this;
                    let param = {
                    };
                    $.ajax({
                        url: "/main/adPerMonth.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.adHistoryInfo = data.info;
                            console.log("현재월:", self.adHistoryInfo.perMonth); // 광고진행월 PER_MONTH 컬럼값 찾기
                        }
                    });
                },

                // 하단 광고배너 클릭시 카운팅 올리기 
                fnAdClick: function () {
                    let self = this;
                    let param = {
                        adId: self.adInfo.adId,
                        currentMonth: self.adHistoryInfo.perMonth
                    };
                    $.ajax({
                        url: "/main/adUpdate.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //alert("클릭 및 카운트");
                        }
                    });
                },

            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트

                // Vue가 DOM 렌더링 완료 후 실행
                self.$nextTick(() => {
                    self.fnMemberProImg();
                });

                self.fnGetAdInfo(); // 광고 id 불러오기
                self.fnAdPerMonth(); // 광고 perMonth 불러오기

                // 1. URL에서 파라미터 확인 (검색키워드 or 카테고리)
                const urlParams = new URLSearchParams(window.location.search);
                const keyword = urlParams.get('keyword');
                const category = urlParams.get('category');

                // 2. 키워드 유무에 따라 다르게 리스트 호출
                if (keyword) {
                    self.keyword = keyword;  // Vue data에 넣기
                    self.fnList();           // fnList 실행
                } else if (category) {
                    //  3. 또는 카테고리 파라미터가 있을 때
                    console.log("URL에서 받은 category:", category);
                    self.selectedCategory = category;
                    self.fnList();
                }
                else {
                    // 이도저도 아니면 기본 목록 호출
                    self.fnList();
                }


                // 헤더에서 keyword (검색어) 이벤트 수신
                window.emitter.on('keyword', (keyword) => {
                    console.log("헤더에서 받은 검색어:", keyword);
                    self.keyword = keyword;
                    self.fnList(); // 메인에서 검색 실행
                });

                // 헤더 메뉴 중 '카테고리' 하위 메뉴 클릭 이벤트 수신
                window.emitter.on('categoryClick', (categoryName) => {
                    console.log("카테고리 클릭:", categoryName);
                    self.selectedCategory = categoryName;
                    self.fnList(); // 해당 카테고리 상품만 조회
                });

                // 자동 슬라이드
                self.autoSlide = setInterval(() => {
                    if (self.memberProlist.length > 0) {
                        self.currentSlide = (self.currentSlide + 1) % self.memberProlist.length;
                    }
                }, 3000);

            }, // mounted 끝나고 next 옵션 시작

            beforeUnmount() {
                clearInterval(this.autoSlide);
            } // ← Options 객체 마지막 속성이므로 쉼표 없음

        });


        app.mount('#app');
    </script>
    