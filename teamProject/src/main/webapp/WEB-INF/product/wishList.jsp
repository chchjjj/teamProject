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
            .product-detail-container {


                padding: 0 440px;
                background-color: #ffffff;
                /* 상세 페이지 배경색 */
                border-radius: 12px;
                /* 원하는 둥글기 값 (예시: 12px) */
                overflow: hidden;
                /* 내부 요소가 모서리를 벗어나는 것을 막아줍니다. */
            }

            .product-info-area {
                display: flex;
                justify-content: space-between;
            }

            /* --- 상품 선택 섹션 스타일 --- */
            .product-selection-section {
                /* 이미지 상의 전체 컨테이너는 회색 배경입니다. */
                background-color: #ffffff;
                /* 회색 배경 */
                padding: 50px 30px;
                width: 100%;
                /* product-info-area 내에서 전체 너비 사용 */
                box-sizing: border-box;
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                /* 주문하기 버튼 오른쪽 정렬을 위해 사용 */


            }

            /* 상품/옵션 카드 */
            .product-card {
                display: block;
                /* label 전체를 클릭 가능하게 */
                background-color: #FFFFFF;
                border: 1px solid #4b4b4b;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                width: 100%;
                /* 부모 컨테이너 너비 채우기 */
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                cursor: pointer;
                box-sizing: border-box;

                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .product-card:hover {
                transform: translateY(-3px) scale(1.01);
                /* 위로 살짝 뜨는 효과 */
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                /* 그림자 강조 */
                border-color: #3E2723;
                /* 테두리 색 강조 (선택사항) */
            }

            .item-left {
                display: flex;
                align-items: stretch;
                gap: 15px;
                position: relative;
            }

            .item-text {
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                /* 위쪽 정렬 */
            }

            .item-image-placeholder {
                width: 150px;
                /* 이미지 너비 */
                flex-shrink: 0;
                height: auto;
                /* 이미지 높이 */
                background-color: #e0e0e0;
                /* 회색 배경으로 플레이스홀더 */
                border-radius: 8px;
                background-size: cover;
                /* 이미지 크기 맞춤 */
                background-position: center;
            }

            .item-text h3.store-name {
                font-size: 18px;
                font-weight: bold;
                color: #333;
                /* 진한 글씨 */
            }

            .item-text p.store-name {
                font-size: 16px;
                font-weight: 500;
                color: #555;
                /* 가게명 색상 */

            }

            .item-text p.store-name+p {
                margin-top: 0;
                margin-bottom: 8px;
            }

            .item-text p.store-name+p+p {
                margin-top: 0;
            }

            .item-text p {
                font-size: 14px;
                color: #666;
                /* 일반 텍스트 */
                margin: 2px 0;
            }

            .item-text p.delivery {
                font-weight: 500;
                color: #1a73e8;
                /* 배송비 강조 */
            }

            .item-text p.pro-info {
                font-size: 13px;
                color: #444;
                line-height: 1.4;
            }

            .item-text p.wish-date {
                font-size: 12px;
                color: #999;
            }

            .wishlist-title {
                width: 100%;
                text-align: left;
                margin-bottom: 30px;
                margin-top: 30px;
            }

            .wishlist-title h2 {
                font-size: 22px;
                font-weight: 700;
                color: #333;
                margin-bottom: 5px;
            }

            .wishlist-title p {
                font-size: 14px;
                color: #777;
                margin: 0;
            }

            .wishlist-grid {
                display: flex;
                flex-direction: column;
                /* 세로 방향 정렬 */
                gap: 20px;
                /* 카드 간격 */
                width: 100%;
            }

            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 40px 0;
                gap: 10px;
            }

            .pagination button {
                cursor: pointer;
                display: inline-block;
                padding: 8px 12px;
                margin: 0 3px;
                border: 1px solid #ddd;
                border-radius: 4px;
                color: #3E2723;
                transition: background-color 0.3s ease, color 0.3s ease, transform 0.2s ease;
            }

            .pagination button:hover {
                background-color: #b3b3b3;
                /* 노란색 */
                color: #fff;
                /* 흰색 글씨 */
                border-color: #b3b3b3;
                transform: scale(1.1);
                /* 살짝 커짐 */
            }

            /* 활성화된 버튼 스타일 */
            .pagination button.active {
                background-color: #3E2723;
                color: #fff;
                border-color: #3E2723;
                transform: scale(1.05);
            }



            .empty-wishlist {
                text-align: center;
                padding: 80px 0;
                color: #777;
                font-size: 16px;
                border: 1px dashed #ccc;
                border-radius: 8px;
                background-color: #fafafa;
                margin-bottom: 80px;
            }


            .icon {
                position: absolute;

                /* 위에서 15px */
                right: 25px;
                /* 오른쪽에서 15px */
            }

            .icon img {
                width: 45px;
                height: 45px;
                cursor: pointer;
                transition: transform 0.2s ease, opacity 0.2s ease;
            }

            .icon img:hover {
                transform: scale(1.1);
                opacity: 0.8;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <div class="product-detail-container">
                    <div class="wishlist-title">
                        <h2>{{ userId }}님의 위시리스트</h2>
                        <p>관심 있는 상품을 한눈에 확인해보세요.</p>
                    </div>

                    <!-- ✅ 2개씩 카드 보이게 -->
                    <div class="wishlist-grid" v-if="paginatedList.length > 0">
                        <label class="product-card" v-for="item in paginatedList" :key="item.cartId"
                            @click="fnProDt(item.proNo)">
                            <div class="item-left">
                                <div class="item-image-placeholder"
                                    :style="{ 'background-image': 'url(' + item.proImgUrl + ')' }"></div>
                                <div class="item-text">
                                    <h3 class="store-name">{{ item.proName }} ({{ item.price.toLocaleString() }}원)</h3>
                                    <p class="store-name">{{ item.storeName }}</p>
                                    <p class="delivery">배송비 : {{ item.deliveryFee }} 원</p>
                                    <p class="pro-info">레터링 : {{ item.lettering === 'Y' ? '가능' : '불가능' }}</p>
                                    <p class="pro-info">채팅 : {{ item.isChatEnabled === 'Y' ? '가능' : '불가능' }}</p>
                                    <p class="pro-info">{{ item.proInfo }}</p>
                                    <p class="wish-date">찜한 시간 : {{ item.wishAt }}</p>
                                </div>
                                <div class="icon">
                                    <span>
                                        <img src="/img/좋아요누른후.png" alt="찜 완료" @click.stop="fnwishdel(item.proNo)"
                                            class="wish-icon">
                                    </span>

                                </div>
                            </div>
                        </label>
                    </div>
                    <div v-else class="empty-wishlist">
                        <p>위시리스트가 비어있습니다.</p>
                    </div>


                    <!-- 페이징 버튼 -->
                    <div class="pagination" v-if="totalPages >= 1">
                        <button v-for="page in totalPages || 1" :key="page" :class="{ active: page === currentPage }"
                            @click="changePage(page)">
                            {{ page }}
                        </button>
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
                    userId: "${sessionId}",
                    list: [],
                    currentPage: 1,
                    itemsPerPage: 2 // 한 페이지에 2개씩
                };
            },
            computed: {
                // ✅ 현재 페이지에 보여줄 데이터
                paginatedList() {
                    const start = (this.currentPage - 1) * this.itemsPerPage;
                    const end = start + this.itemsPerPage;
                    return this.list.slice(start, end);
                },
                totalPages() {
                    return Math.ceil(this.list.length / this.itemsPerPage);
                }
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnWishList: function () {
                    let self = this;
                    let param = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/product/wishList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.list = data.wishList;
                            console.log(data.wishList);
                        }
                    });
                },
                fnwishdel: function (proNo) {
                    let self = this;
                    let param = {
                        userId: self.userId,
                        proNo: proNo
                    };

                    $.ajax({
                        url: "/product/WishlistDel.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert("찜 목록에서 제거되었습니다.");
                            location.reload();
                        }
                    });

                },
                fnProDt: function (proNo) {
                    let self = this;
                    console.log(proNo); // main 화면에서 클릭한 상품번호 출력(확인완료)
                    pageChange("/productDetail.do", { proNo: proNo });  // 상세페이지로 proNo 넘겨줌

                },
                changePage(page) {
                    this.currentPage = page;
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnWishList();
            }
        });

        app.mount('#app');
    </script>