<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <link rel="stylesheet" href="/css/cart-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <div class="product-detail-container">
                    <div class="product-info-area">
                        <div class="product-selection-section">

                            <label v-for="(group, groupIndex) in groupedCartList" :key="group.cartId"
                                class="product-card" :class="{'selected-product': groupIndex === 0}">

                                <input type="checkbox" name="product_option" :value="group.cartId" v-model="selectItem">


                                <div class="product-card-content">

                                    <div class="product-details">
                                        <h3 class="store-name">🛒 {{ group.proName }} (기본가: {{
                                            formatNumber(group.defPrice) }}원)</h3>

                                        <div class="options-list"
                                            style="margin-top: 10px; border-top: 1px dashed #ccc; padding-top: 10px; text-align: left;">
                                            <p style="font-weight: bold; margin-bottom: 5px;">선택 옵션:</p>
                                            <ul style="list-style-type: none; padding-left: 0;">
                                                <li v-for="(opt, optIndex) in group.options" :key="optIndex"
                                                    style="margin-bottom: 5px; font-size: 0.9em;">
                                                    {{ opt.topOpt }} : {{ opt.subOpt }}
                                                    (수량: {{ opt.optQty }}개 / 추가금: {{ formatNumber(opt.subOptPrice) }}원)
                                                </li>
                                            </ul>
                                        </div>

                                        <div class="item-info">
                                            <div class="item-left">
                                                <div class="item-image-placeholder"></div>
                                                <div class="item-text">
                                                    <p class="item-delivery">픽업 정보 (TODO: 데이터 필드 추가 필요)</p>
                                                    <p class="item-description">총 {{ group.options.length }}개 옵션 선택</p>
                                                    <p class="item-price-detail">기본가격({{ formatNumber(group.defPrice)
                                                        }}) + 옵션추가금({{ formatNumber(group.totalPrice - group.defPrice)
                                                        }})</p>
                                                </div>
                                            </div>
                                            <div class="item-right">
                                                <p class="item-final-price">{{ formatNumber(group.totalPrice) }}원</p>
                                                <div class="quantity-control">
                                                    <button class="quantity-btn" disabled>-</button>
                                                    <input type="text">
                                                    <button class="quantity-btn" disabled>+</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </label>

                            <div class="product-selection-section">
                                <div v-if="groupedCartList.length === 0" class="empty-cart-message">
                                    <p>장바구니에 담긴 상품이 없습니다.</p>
                                </div>

                                <div class="order-button-container">
                                    <button class="order-button" @click="fnAllRemove">삭제하기</button>
                                </div>
                                <div class="order-button-container">
                                    <button class="order-button" @click="fnBuy()">주문하기</button>
                                </div>
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
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                    cartList: [],
                    groupedCartList: [],
                    selectItem: [],
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnCart: function () {
                    let self = this;
                    let param = {
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/product/cart.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.cartList = data.list;
                            console.log(data.list);
                            // 서버 데이터를 가져온 후 그룹화 함수 호출
                            self.fnGroupCartList(self.cartList);
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
                },
                fnBuy: function () {
                    let self = this;
                    // 선택된 항목이 없을 경우 안내
                    if (self.selectItem.length === 0) {
                        alert("주문할 상품을 선택해주세요.");
                        return;
                    }
                    pageChange("/payment/payment.do", { selectItem: JSON.stringify(self.selectItem) });  // 상세페이지로 proNo 넘겨줌  
                },
                fnAllRemove: function () {
                    let self = this;

                    var fList = JSON.stringify(self.selectItem);
                    var param = { selectItem: fList };
                    console.log(self.selectItem);
                    $.ajax({
                        url: "/product/cartDelete.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert("삭제되었습니다!");
                            self.fnCart();

                        }
                    });

                },
                // 숫자 포맷팅 함수 (1000 -> 1,000)
                formatNumber: function (value) {
                    if (value === undefined || value === null) return '0';
                    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                },

                // 💡 CART_ID 기준으로 장바구니 항목을 그룹화하는 함수 (옵션추가금 버그 수정)
                fnGroupCartList: function (list) {
                    const grouped = {};

                    if (!Array.isArray(list) || list.length === 0) {
                        this.groupedCartList = [];
                        console.log("장바구니 목록이 비어 있거나 올바르지 않아 그룹화하지 않습니다.");
                        return;
                    }

                    list.forEach(item => {
                        // 1. 필드명 안전하게 추출 및 숫자 변환
                        const cartId = item.cartId || item.CART_ID;
                        if (!cartId) return;

                        // 숫자로 확실하게 변환하여 0으로 초기화 (데이터가 없거나, null/undefined/문자열이 와도 안전하게 처리)
                        const defPrice = Number(item.defPrice || item.DEF_PRICE || 0);
                        const subOptPrice = Number(item.subOptPrice || item.SUB_OPT_PRICE || 0); // 👈 옵션 추가금 처리 강화
                        const optQty = Number(item.optQtt || item.OPT_QTT || 1); // 👈 수량 처리 강화

                        // 2. 그룹 초기화 (해당 cartId가 처음 등장하는 경우)
                        if (!grouped[cartId]) {
                            grouped[cartId] = {
                                cartId: cartId,
                                proName: item.proName || item.PRO_NAME,
                                defPrice: defPrice,
                                options: [],
                                totalPrice: defPrice, // 기본 가격으로 초기화
                                totalAddPrice: 0     // 총 옵션 추가금 합계를 별도로 관리
                            };
                        }

                        // 3. 옵션 추가
                        grouped[cartId].options.push({
                            topOpt: item.topOpt || item.TOP_OPT,
                            subOpt: item.subOpt || item.SUB_OPT,
                            optQty: optQty,
                            subOptPrice: subOptPrice, // 숫자로 변환된 1500이 저장됨
                        });

                        // 4. 총액 계산 및 옵션 추가금 합계 누적
                        // 옵션 추가 금액이 0보다 큰 경우에만 상품의 최종 가격에 반영
                        if (subOptPrice > 0) {
                            const addedAmount = subOptPrice * optQty;
                            grouped[cartId].totalPrice += addedAmount;
                            grouped[cartId].totalAddPrice += addedAmount;
                        }
                    });

                    this.groupedCartList = Object.values(grouped);
                    console.log("그룹화된 장바구니 ===>", this.groupedCartList);
                },
                // 수량 변경 함수 (그룹화된 리스트 인덱스 기준)
                fnChangeQuantity: function (cartId, optionIndex, amount) {
                    // TODO: 이 함수는 옵션별 수량 변경 시 사용 가능
                    // 현재 구조는 CART_ID 단위의 섹션이므로, 섹션 전체 수량 변경이 더 일반적일 수 있음.
                    // 섹션 전체 수량 변경 로직 (PRO_NAME이 같으므로 사실상 상품 전체 수량 변경)은 복잡해지니
                    // 여기서는 옵션별 수량 변경 로직을 가정하고, 필요 시 상품 전체 수량 변경 로직으로 확장하세요.
                    console.log(`[TODO] CART_ID ${cartId}의 옵션 ${optionIndex} 수량 변경 로직 필요`);
                },
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId); // 로그인한 아이디 잘 넘어오나 테스트
                self.fnCart();
            }
        });

        app.mount('#app');
    </script>