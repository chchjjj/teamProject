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
                                                    {{ opt.topOpt }} : {{ opt.subOpt }} (수량: {{ opt.cartOptQuantity }}개 / 추가금:
                                                    {{ formatNumber(opt.subOptPrice) }}원)
                                                </li>
                                            </ul>
                                            <p class="item-description">총 {{ group.options.length }}개 옵션 선택</p>
                                        </div>
                                        <div class="item-info">
                                            <div class="item-left">
                                                <div class="item-image-placeholder"></div>
                                                <div class="item-text">


                                                    <p class="item-chat-status">
                                                        💬 채팅 신청 여부:
                                                        <span v-if="group.chatYn === 'Y'"
                                                            style="color: green; font-weight: bold;">신청</span>
                                                        <span v-else style="color: gray;">미신청</span>
                                                    </p>
                                                    <p class="item-lettering-word"
                                                        v-if="group.letteringWord && group.letteringWord.length > 0">
                                                        레터링 문구:
                                                        <span style="font-style: italic; color: #555;">
                                                            "{{ group.letteringWord }}"
                                                        </span>
                                                    </p>
                                                    <p class="item-price-detail">
                                                        기본가격({{ formatNumber(group.defPrice) }}) + 옵션추가금({{
                                                        formatNumber(group.totalPrice - group.defPrice) }})+ 배송비({{
                                                        formatNumber(group.deliveryFee) }})
                                                    </p>
                                                    <p class="item-delivery-type">
                                                        배송 방식:
                                                        <span v-if="group.deliveryType === 'D'"
                                                            style="color: green; font-weight: bold;">배달</span>
                                                        <span v-else-if="group.deliveryType === 'P'"
                                                            style="color: blue; font-weight: bold;">픽업</span>
                                                        <span v-else style="color: gray;">정보 없음</span>
                                                    </p>

                                                </div>

                                            </div>
                                            <div class="item-right">
                                                <p class="item-final-price">
                                                    {{ formatNumber((group.totalPrice) *
                                                    group.itemQty + group.deliveryFee) }}원
                                                </p>
                                                <div class="quantity-control">

                                                    <button class="quantity-btn"
                                                        @click.stop="fnChangeItemQuantity(group.cartId, -1)">-</button>
                                                    <input type="text" :value="group.itemQty" readonly
                                                        style="width: 30px; text-align: center;">
                                                    <button class="quantity-btn"
                                                        @click.stop="fnChangeItemQuantity(group.cartId, 1)">+</button>
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
                    userId: "${sessionId}",
                    cartList: [],
                    groupedCartList: [],
                    selectItem: [],
                };
            },
            methods: {
                fnCart: function () {
                    let self = this;
                    let param = { userId: self.userId };
                    $.ajax({
                        url: "/product/cart.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.cartList = data.list;
                            console.log(data.list);
                            self.fnGroupCartList(self.cartList);
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
                },
                fnBuy: function () {
                    let self = this;
                    if (self.selectItem.length === 0) {
                        alert("주문할 상품을 선택해주세요.");
                        return;
                    }
                    // 1. 선택된 cartId에 해당하는 상품 정보(옵션 포함)를 필터링
                    const selectedItemsData = self.groupedCartList.filter(group =>
                        self.selectItem.includes(group.cartId)
                    );

                    // console.log("선택된 상품 데이터:", selectedItemsData);

                    let param = {
                        userId: self.userId,
                        cartItems: JSON.stringify(selectedItemsData) //문자열로 전송
                    };
                    console.log(param)
                    $.ajax({
                        url: "/product/cartToOrder.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert("주문이 완료되었습니다!");
                                    // 결제 페이지로 이동 또는 주문 완료 페이지 이동
                                    alert(data.orderIdList);
                                    pageChange("/payment/payment.do", { orderIdList: data.orderIdList });
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
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
                formatNumber: function (value) {
                    if (value === undefined || value === null) return '0';
                    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                },

                fnGroupCartList: function (list) {
                    const grouped = {};
                    if (!Array.isArray(list) || list.length === 0) {
                        this.groupedCartList = [];
                        console.log("장바구니 목록이 비어 있거나 올바르지 않아 그룹화하지 않습니다.");
                        return;
                    }
                    list.forEach(item => {
                        const cartId = item.cartId || item.CART_ID;
                        if (!cartId) return;
                        const defPrice = Number(item.defPrice || item.DEF_PRICE || 0);
                        const subOptPrice = Number(item.subOptPrice || item.SUB_OPT_PRICE || 0);
                        const optQty = Number(item.cartOptQuantity || item.CART_OPT_QUANTITY || 1);
                        const cartQuantity = Number(item.cartQuantity || item.CART_QUANTITY || 1);
                        const deliveryFee = Number(item.deliveryFee || item.DELIVERY_FEE || 0); //배송비
                        const deliveryType = item.deliveryType || item.DELIVERY_TYPE || "기본배송";
                        if (!grouped[cartId]) {
                            grouped[cartId] = {
                                cartId: cartId,
                                storeName: item.storeName,
                                storeId : item.storeId,
                                proNo : item.proNo,
                                proName: item.proName || item.PRO_NAME,
                                defPrice: defPrice,
                                options: [],
                                totalPrice: item.defPrice,
                                totalAddPrice: 0,
                                itemQty: cartQuantity,
                                cartOptQuantity : item.cartOptQuantity,
                                letteringWord: item.letteringWord || item.LETTERING_WORD || "",
                                chatYn: item.chatYn || item.CHAT_YN || "N",
                                deliveryFee: deliveryFee,
                                deliveryType: deliveryType,
                            };
                        }
                        grouped[cartId].options.push({
                            topOpt: item.topOpt || item.TOP_OPT,
                            subOpt: item.subOpt || item.SUB_OPT,
                            topOptionId : item.topOptionId,
                            subOptionId : item.subOptionId,                            
                            subOptPrice: subOptPrice,
                            cartOptQuantity: optQty,
                        });
                        if (subOptPrice > 0) {
                            const addedAmount = subOptPrice * optQty;
                            grouped[cartId].totalPrice += addedAmount;
                            grouped[cartId].totalAddPrice += addedAmount;
                        }
                    });
                    this.groupedCartList = Object.values(grouped);
                    console.log("그룹화된 장바구니 ===>", this.groupedCartList);
                },
                fnChangeItemQuantity: function (cartId, amount) {
                    let self = this;
                    const group = self.groupedCartList.find(g => g.cartId === cartId);
                    if (!group) return;
                    let newItemQty = group.itemQty + amount;
                    if (newItemQty < 1) {
                        alert("상품 수량은 1개 미만으로 설정할 수 없습니다.");
                        return;
                    }
                    const pricePerItem = group.totalPrice - group.deliveryFee;
                    const finalCalculatedPrice = (group.totalPrice * newItemQty) + group.deliveryFee;
                    const param = { cartId: cartId, newQuantity: newItemQty, finalPrice: finalCalculatedPrice };
                    $.ajax({
                        url: "/product/cartItemQuantityUpdate.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {     
                                self.fnCart();
                        }
                    });
                    group.itemQty = newItemQty;
                }
            },
            mounted() {
                let self = this;
                console.log("로그인 아이디 ===> " + self.userId);
                self.fnCart();
            }
        });
        app.mount('#app');
    </script>