<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
            기본 설정 body {
                font-family: 'Noto Sans KR', sans-serif;
                background-color: #f4f5f7;
                /* 은은한 배경색 */
                margin: 0;
                padding: 0;
            }

            /* 1. 전체 컨테이너 */
            .page-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            
            }

            /* 2. 상단 배너/헤더 공간 */
            .store-banner {
                width: 100%;
                height: 200px;

                display: flex;
                justify-content: center;
                align-items: center;
                color: rgb(58, 58, 58);
                font-size: 2em;
                font-weight: 700;
                border-radius: 12px;
                margin-bottom: 80px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            /* 3. 프로필 정보 + 상품 리스트를 포함하는 메인 영역 */
            .main-content {
                display: grid;
                grid-template-columns: 300px 1fr;
                /* 왼쪽 프로필 고정, 오른쪽 상품 리스트 확장 */
                gap: 30px;
            }

            /* 4. 가게 프로필 (왼쪽) - 요즘은 보통 카드로 깔끔하게 만듭니다. */
            .store-profile-card {
                background-color: #ffffff;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                text-align: center;
                position: sticky;
                /* 스크롤해도 따라오도록 설정 (요즘 트렌드) */
                top: 20px;
                align-self: start;
            }

            .seller-image {
                width: 120px;
                height: 120px;
                background-color: #fff0f5;
                /* 핑크빛 배경 */
                border-radius: 50%;
                /* 원형 이미지 */
                border: 4px solid #ff7f99;
                /* 강조 테두리 */
                margin: 0 auto 15px auto;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 0.9em;
                color: #ff7f99;
            }

            .store-info-text h2 {
                margin: 0 0 5px 0;
                color: #333;
                font-size: 1.5em;
            }

            .store-info-text p {
                margin: 5px 0;
                color: #666;
                font-size: 0.9em;
            }

            .store-info-text button {
                background-color: #58c0a2;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                margin-top: 15px;
                cursor: pointer;
                font-weight: bold;
            }

            /* 5. 상품 리스트 영역 (오른쪽) */
            .product-list-grid {
                display: grid;
                /* 3열 레이아웃. 화면 크기에 따라 자동으로 너비 조절 */
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            /* 6. 개별 상품 카드 */
            .product-card {
                background-color: #ffffff;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }

            .product-image {
                width: 100%;
                height: 200px;
                background-color: #e8e8e8;
                display: flex;
                justify-content: center;
                align-items: center;
                color: #999;
                font-size: 0.9em;
            }

            .product-details {
                padding: 15px;
                text-align: left;
            }

            .product-details h3 {
                font-size: 1em;
                margin: 0 0 5px 0;
                color: #333;
                /* 텍스트가 넘치면 ... 처리 */
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .product-details p {
                margin: 0;
                font-size: 0.9em;
                color: #999;
            }

            .price {
                font-size: 1.2em;
                font-weight: 700;
                color: #ff4500;
                /* 강조색 */
                margin-top: 8px;
            }

            /* 3-4. 상품 목록 섹션 */
            .product-list-section {
                padding-top: 10px;
            }

            .sort-options {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                font-size: 12px;
            }

            .sort-options span {
                margin-right: 15px;
                color: #888;
            }

            .product-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }

            .product-item {
                /* 기존 스타일 제거 및 재정의 */
                border: 1px solid #eee;
                padding: 15px;
                /* 패딩 증가 */
                text-align: left;
                border-radius: 8px;
                /* 둥근 모서리 */
                overflow: hidden;
                /* 내부 요소가 박스를 벗어나지 않도록 */
                cursor: pointer;
                /* 클릭 가능하다는 표시 */

                /* 쉐도우로 입체감 부여 */
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);

                /* 호버 효과를 위한 전환(Transition) 설정 */
                transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            }

            .product-item:hover {
                /* 1. 살짝 들어 올리는 효과 */
                transform: translateY(-5px);

                /* 2. 쉐도우를 강조하여 입체감 극대화 */
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
            }

            .product-image-placeholder {
                background-color: #f5f5f5;
                height: 180px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 10px;
                color: #aaa;
                font-size: 12px;
            }

            /*메인페이지 상품 섬네일 & 추천배지 감싸는 클래스*/
            .product-image-wrapper {
                position: relative;
                width: 100%;
                height: 150px;
                /* 썸네일 높이에 맞춰서 조정 */
                overflow: hidden;
                /* 딱지 제외, 썸네일만 영역 내로 */
            }

            /* 추천 뱃지 */
            .recommend-badge {
                position: absolute;
                top: 5px;
                /* 상단 여백 */
                right: 5px;
                /* 우측 여백 */
                width: 50px;
                /* 딱지 크기 */
                height: 50px;
            }

            .product-title {
                font-weight: bold;
                margin-bottom: 5px;
                font-size: 16px;
                color: #3E2723;
                /* 헤더의 진한 갈색과 통일 */
            }

            /* 👇 [추가] 가게 이름 스타일 */
            .product-item p:nth-child(3) {
                font-size: 13px;
                color: #777;
                margin-bottom: 5px;
            }

            /* 👇 [추가] 채팅이 불가능한 경우 빨간색으로 표시 */
            .product-item p.chat-disabled {
                color: #e74c3c !important;
                /* 상품 가격과 비슷한 빨간색으로 변경 */
                font-weight: bold;
            }

            /* 👇 [추가] 채팅 가능 여부 스타일 */
            .product-item p:nth-child(4) {
                font-size: 12px;
                color: #27ae60;
                /* 녹색 계열로 강조 */
                margin-bottom: 5px;
            }

            .product-price {
                color: #e74c3c;
                font-weight: bold;
                margin-bottom: 3px;
            }

            .product-delivery {
                font-size: 12px;
                color: #888;
            }

            .store-info-text h2 {
                color: #3E2723;
                font-size: 1.6em;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .store-info-text p {
                color: #555;
                font-size: 0.95em;
                line-height: 1.6;
                margin: 5px 0;
            }

            /*  채팅 가능 시간 */
            .store-info-text p:last-of-type {
                background-color: #fef4f7;
                border: 1px solid #ffd6e0;
                border-radius: 8px;
                display: inline-block;
                padding: 6px 10px;
                margin-top: 10px;
                font-size: 0.9em;
                color: #ff6f91;
                font-weight: 600;
            }

            /*  버튼 스타일 */
            .store-info-text button {
                background: linear-gradient(90deg, #ff9eb5 0%, #ff7f99 100%);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                margin-top: 20px;
                cursor: pointer;
                font-weight: bold;
                box-shadow: 0 4px 10px rgba(255, 143, 163, 0.4);
                transition: all 0.3s;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <!-- html 코드는 id가 app인 태그 안에서 작업 -->
                <div class="page-container">


                    <div class="store-banner" v-if="!storeInfo.filePath || !storeInfo.fileName">
                        판매자 등록 썸네일
                    </div>
                    <img v-else :src="(storeInfo.filePath + storeInfo.fileName).trim()" alt="상품 이미지"
                        class="product-image" style="width: 100%; height: auto; border-radius: 10px;">


                    <div class="main-content">

                        <div class="store-profile-card">
                            <div class="seller-image">
                                프로필 사진
                            </div>
                            <div class="store-info-text">
                                <h2>{{storeInfo.storeName}}</h2>
                                <p>{{storeInfo.storeIntro}}</p>
                                <p>가게 주소: {{storeInfo.storeAddr}}</p>
                                <p>
                                    채팅 답변 가능시간:
                                    {{ storeInfo.chatStart?.substring(11, 16) || '' }}
                                    ~
                                    {{ storeInfo.chatEnd?.substring(11, 16) || '' }}
                                </p>

                            </div>
                        </div>

                        <div class="product-list-grid">


                            <div class="product-item" v-for="item in list" @click="fnProDetail(item.proNo)">
                                <div class="product-image-wrapper">
                                    <div class="product-image-placeholder" v-if="!item.filePath || !item.fileName">
                                        판매자 등록 썸네일
                                    </div>
                                    <img v-else :src="(item.filePath + item.fileName).trim()" alt="상품 이미지"
                                        class="product-image" style="width: 100%; height: auto; border-radius: 10px;">
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
                    </div>
                </div>
            </div>
            <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    storeId: "${storeId}",
                    storeInfo: {},
                    list: [],
                    area: "", // 디폴트 : 전체 지역 조회
                    order: 1, // 디폴트 :  조회순 정렬
                    selectedCategory: '', // 디폴트

                    proNo: "", // 상품번호
                    keyword: "", // 검색 키워드 변수 추가

                    pageSize: 8, // 한 페이지에 출력할 게시글 개수 (8개로 기본값)
                    page: 1, // 현재 페이지(위치) - 최초 1페이지부터 시작 (OFFSET 다음에 오는 숫자)
                    index: 0, // 최대 페이지 값 (표현할 페이지 개수)
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnStoreInfo: function () {
                    let self = this;
                    let param = {
                        storeId: self.storeId
                    };
                    $.ajax({
                        url: "/product/sellerInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.storeInfo = data.info;
                            // console.log(self.storeInfo);
                        }
                    });
                },
                fnList: function () {
                    let self = this;
                    let param = {
                        // 선택할 때마다 새로 목록 가져오게 해야함(위에서 @change 처리함)
                        area: self.area,
                        order: self.order,
                        category: self.selectedCategory,
                        keyword: self.keyword,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize,


                        sellerPage: 23,
                        storeId: self.storeId
                    };
                    $.ajax({
                        url: "/main/list.dox", // 상품 리스트 조회주소 넣어야함
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // console.log(data);
                            self.list = data.list; // data에 있는 list 값을 변수 list에 담기      
                            self.index = Math.ceil(data.cnt / self.pageSize);
                        }
                    });
                },
                fnProDetail: function (proNo) {
                    let self = this;
                    // console.log(proNo); // main 화면에서 클릭한 상품번호 출력(확인완료)
                    pageChange("/productDetail.do", { proNo: proNo });  // 상세페이지로 proNo 넘겨줌            
                },
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                // console.log(self.storeId);
                self.fnStoreInfo();
                self.fnList();
            }
        });

        app.mount('#app');
    </script>