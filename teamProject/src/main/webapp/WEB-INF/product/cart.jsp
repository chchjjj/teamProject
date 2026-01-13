<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>장바구니</title>
        <!-- <link rel="stylesheet" href="/css/cart-style.css"> -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            /* =========================
   공통 톤 & 리셋
========================= */
            body {
                background-color: #f5f6f8;
            }

            /* =========================
   상단 필터
========================= */
            .chat-filter-container {
                margin: 24px 0 32px;
                text-align: center;
            }

            .chat-filter-container button {
                background-color: #ffffff;
                border: 1px solid #ddd;
                color: #3E2723;
                font-weight: 600;
                padding: 10px 22px;
                margin: 0 6px;
                border-radius: 999px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .chat-filter-container button:hover {
                background-color: #f1f3f5;
            }

            .chat-filter-container button.active {
                background-color: #3E2723;
                color: #fff;
                border-color: #222;
            }

            /* =========================
   전체 레이아웃
========================= */
            .product-detail-container {
                display: flex;
                gap: 40px;
                align-items: flex-start;
                max-width: 1280px;
                margin: 0 auto;
                padding: 40px 20px 80px;
            }

            /* =========================
   메인 영역
========================= */
            .product-main-area {
                flex: 1;
            }

            /* =========================
   상품 카드 영역
========================= */
            .product-selection-section {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .product-card {
                background-color: #fff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.04);
                transition: transform 0.15s ease, box-shadow 0.15s ease;
            }

            .product-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.06);
            }

            .product-card input[type="checkbox"] {
                accent-color: #222;
                transform: scale(1.2);
            }

            /* =========================
   상품 내부 정보
========================= */
            .store-name {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .options-list {
                font-size: 14px;
                color: #555;
            }

            .item-info {
                display: flex;
                justify-content: space-between;
                gap: 24px;
                margin-top: 16px;
            }

            .item-left {
                display: flex;
                gap: 20px;
                flex: 1;
            }

            .item-image-placeholder {
                width: 120px;
                height: 120px;
                background-color: #f1f3f5;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                color: #888;
                overflow: hidden;
            }

            .item-text p {
                margin: 6px 0;
                font-size: 14px;
                color: #444;
            }

            .item-right {
                text-align: right;
                min-width: 120px;
            }

            .item-final-price {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 12px;
            }

            /* =========================
   수량 버튼
========================= */
            .quantity-control {
                display: flex;
                align-items: center;
                justify-content: flex-end;
                gap: 8px;
            }

            .quantity-btn {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                border: 1px solid #ccc;
                background-color: #fff;
                cursor: pointer;
                font-weight: 600;
            }

            .quantity-btn:hover {
                background-color: #f1f3f5;
            }

            /* =========================
   주문 버튼
========================= */
            .order-button-container {
                margin-top: 5px;
                text-align: right;
            }

            .order-button {
                padding: 12px 28px;
                border-radius: 999px;
                border: none;
                background-color: #3E2723;
                color: #fff;
                font-weight: 600;
                cursor: pointer;
            }

            .order-button:hover {
                opacity: 0.9;
            }

            /* =========================
   사이드 요약 패널
========================= */
            .cart-summary-panel {
                width: 320px;
                padding: 28px;
                border-radius: 20px;
                background-color: #ffffff;
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.06);
                position: sticky;
                top: 120px;
            }

            .cart-summary-panel h3 {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 20px;
            }

            .summary-count {
                font-size: 14px;
                color: #555;
                margin-bottom: 16px;
            }

            .summary-item-list {
                list-style: none;
                padding: 0;
                margin: 0 0 20px;
            }

            .summary-item-list li {
                display: flex;
                justify-content: space-between;
                font-size: 14px;
                margin-bottom: 10px;
            }

            .summary-item-name {
                color: #444;
                max-width: 70%;
            }

            .summary-item-price {
                font-weight: 600;
            }

            .summary-total {
                display: flex;
                justify-content: space-between;
                font-size: 18px;
                font-weight: 700;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }

            /* =========================
   장바구니 비어있을 때
========================= */
            .empty-cart-message {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 40px 0;
            }

            .empty-cart-box {
                text-align: center;
                background-color: #fff;
                padding: 48px 60px;
                border-radius: 20px;
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.06);
            }

            .empty-cart-icon {
                font-size: 56px;
                margin-bottom: 16px;
            }

            .empty-cart-title {
                font-size: 20px;
                font-weight: 700;
                color: #222;
                margin-bottom: 12px;
            }

            .empty-cart-desc {
                font-size: 14px;
                color: #666;
                line-height: 1.6;
            }
            
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <div class="product-detail-container">
                    <!-- 사이드바 -->
                    <div class="cart-summary-panel">
                        <h3>선택 상품 요약</h3>

                        <p class="summary-count">
                            선택 상품 개수: <strong>{{ selectedSummary.count }}</strong>개
                        </p>

                        <ul class="summary-item-list">
                            <li v-for="item in selectedSummary.items" :key="item.cartId">
                                <div class="summary-item-name">
                                    {{ item.proName }}
                                </div>
                                <div class="summary-item-price">
                                    {{ formatNumber(item.totalPrice + item.deliveryFee) }}원
                                </div>
                            </li>
                        </ul>

                        <div class="summary-total">
                            <span>총 결제금액</span>
                            <strong>{{ formatNumber(selectedSummary.totalPrice) }}원</strong>
                        </div>
                    </div>
                    <!-- 제품 메인 -->
                    <div class="product-main-area">
                        <div class="chat-filter-container">
                            <button @click="fnSetFilter('N')" :class="{active: chatYnFilter === 'N'}">채팅 미신청 주문
                                보기</button>
                            <button @click="fnSetFilter('Y')" :class="{active: chatYnFilter === 'Y'}">채팅 신청 주문
                                보기</button>
                        </div>

                        <div class="product-info-area">
                            <div class="product-selection-section">

                                <label v-for="(group, groupIndex) in filteredCartList" :key="group.cartId"
                                    class="product-card" :class="{'selected-product': groupIndex === 0}">
                                    <input type="checkbox" name="product_option" :value="group.cartId"
                                        v-model="selectItem">
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
                                                        {{ opt.topOpt }} : {{ opt.subOpt }} (수량: {{ opt.cartOptQuantity
                                                        }}개
                                                        / 추가금:
                                                        {{ formatNumber(opt.subOptPrice) }}원)
                                                    </li>
                                                </ul>
                                                <p class="item-description">총 {{ group.options.length }}개 옵션 선택</p>
                                            </div>
                                            <div class="item-info">
                                                <div class="item-left">
                                                    <div class="item-image-placeholder">
                                                        <div v-if="!group.filePath || !group.fileName">
                                                            판매자 등록 썸네일
                                                        </div>
                                                        <img v-else :src="(group.filePath + group.fileName).trim()"
                                                            alt="상품 이미지" class="product-image"
                                                            style="width: 100%; height: auto; border-radius: 10px;">
                                                    </div>

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
                                                            formatNumber(group.optionPrice) }})+ 배송비({{
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
                                                        {{ formatNumber((group.totalPrice) + group.deliveryFee) }}원
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
                                        <div class="empty-cart-box">
                                            <div class="empty-cart-icon">🛒</div>
                                            <p class="empty-cart-title">장바구니가 비어 있어요</p>
                                            <p class="empty-cart-desc">
                                                마음에 드는 상품을 담아보세요.<br>
                                                선택한 상품은 여기에서 한눈에 확인할 수 있습니다.
                                            </p>
                                        </div>
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
                    chatYnFilter: 'N',//chatting过滤开关
                    cartdel: false
                };
            },
            computed: {
                selectedSummary() {
                    const selectedGroups = this.groupedCartList.filter(group =>
                        this.selectItem.includes(group.cartId)
                    );

                    let totalPrice = 0;

                    selectedGroups.forEach(item => {
                        totalPrice += item.totalPrice + item.deliveryFee;
                    });

                    return {
                        count: selectedGroups.length,
                        items: selectedGroups.map(item => ({
                            cartId: item.cartId,
                            proName: item.proName,
                            totalPrice: item.totalPrice,
                            deliveryFee: item.deliveryFee
                        })),
                        totalPrice: totalPrice
                    };
                },

                // 필터링된 목록 반환
                filteredCartList() {//筛选好的groupedcartlist
                    if (this.chatYnFilter === 'ALL') {
                        return this.groupedCartList;
                    }

                    return this.groupedCartList.filter(item => item.chatYn === this.chatYnFilter);//chatyn是原来产品跟着的，chattnfilter是用户指定的
                }
            },
            methods: {
                fnSetFilter: function (filterValue) {
                    this.chatYnFilter = filterValue;
                    this.selectItem = []; //선택 초기화 (체크박스 해제)
                },

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
                            self.fnGroupCartList(self.cartList);
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
                },

                //点击购买
                fnBuy: function () {
                    let self = this;
                    if (self.selectItem.length === 0) {
                        alert("주문할 상품을 선택해주세요.");
                        return;
                    }

                    self.cartdel = true;
                    const selectedItemsData = self.groupedCartList.filter(group =>
                        self.selectItem.includes(group.cartId)
                    );

                    const hasDelivery = selectedItemsData.some(item => item.deliveryType === 'D');
                    const hasPickup = selectedItemsData.some(item => item.deliveryType === 'P');

                    if (hasDelivery && hasPickup) {
                        alert("픽업 상품과 배달 상품은 동시에 주문할 수 없습니다.");
                        return; //  주문 중단
                    }
                    // console.log("선택된 상품 데이터:", selectedItemsData);


                    const selectedOrderList = self.fnGroupedOrderList(selectedItemsData);

                    let param = {
                        userId: self.userId,
                        cartItems: JSON.stringify(selectedOrderList) //문자열로 전송
                    };


                    $.ajax({
                        url: "/product/cartToOrder.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert("주문이 완료되었습니다!");

                            self.fnAllRemove(true);
                            const deliveryType = selectedItemsData[0].deliveryType; // 선택한 상품들의 배송유형 동일함
                            const orderIdList = data.orderIdList; // 서버에서 반환한 주문 ID 리스트

                            pageChange("/payment/payment.do", { orderIdList: data.orderIdList });
                            // if (deliveryType === 'D') {
                            //     pageChange("/payment/deliveryPayment.do", { orderIdList: data.orderIdList });
                            // } else if (deliveryType === 'P') {
                            //     pageChange("/payment/pickUpPayment.do", { orderIdList: data.orderIdList });
                            // } else {
                            //     alert("배송 유형을 확인할 수 없습니다.");
                            // }
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
                    $.ajax({
                        url: "/product/cartDelete.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (!self.cartdel) {
                                alert("삭제되었습니다!");
                            }
                            self.fnCart();
                        }
                    });
                },
                formatNumber: function (value) {
                    if (value === undefined || value === null) return '0';
                    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                },



                fnGroupedOrderList: function (selectedItemsData) {
                    const stores = {};

                    selectedItemsData.forEach(cart => {
                        const storeId = cart.storeId;
                        if (!storeId) return;

                        if (!stores[storeId]) {
                            stores[storeId] = {
                                userId: this.userId,
                                storeId: storeId,
                                storeName: cart.storeName,
                                fullAddress: cart.userAddr || '주소없음',
                                letteringWord: cart.letteringWord || '',
                                deliveryFee: Number(cart.deliveryFee || 0),
                                deliveryType: cart.deliveryType || 'P',
                                chatYn: cart.chatYn || 'N',
                                userName: cart.userName,
                                phone: cart.phone,
                                storeAddr: cart.storeAddr,
                                items: [],
                                orderSubtotal: 0
                            };
                        }

                        const productDetail = {
                            proNo: cart.proNo,
                            storeId: cart.storeId,
                            proName: cart.proName,
                            quantity: cart.itemQty,
                            price: Number(cart.defPrice || 0),
                            letteringWord: cart.letteringWord || '',
                            options: [],
                            subtotal: 0
                        };

                        let optionsSum = 0;
                        if (cart.options && Array.isArray(cart.options)) {
                            cart.options.forEach(opt => {
                                const priceDiff = Number(opt.subOptPrice || 0);
                                const addQuantity = Number(opt.cartOptQuantity || 1);
                                const optionTotal = priceDiff * addQuantity;

                                productDetail.options.push({
                                    topOptionId: opt.topOptionId,
                                    subOptionId: opt.subOptionId,
                                    optionName: opt.topOpt || '',
                                    valueName: opt.subOpt || '',
                                    priceDiff: priceDiff,
                                    addQuantity: addQuantity,
                                    optionTotal: optionTotal
                                });

                                optionsSum += optionTotal;
                            });
                        }

                        // SUBTOTAL = (PRICE + SUM(PRICE_DIFF * ADD_QUANTITY)) * QUANTITY
                        productDetail.subtotal = (productDetail.price + optionsSum) * productDetail.quantity;

                        stores[storeId].items.push(productDetail);
                        stores[storeId].orderSubtotal += productDetail.subtotal;
                    });

                    for (const storeId in stores) {
                        const store = stores[storeId];
                        store.orderTotalPrice = store.orderSubtotal +
                            (store.deliveryType === 'D' ? store.deliveryFee : 0);
                    }

                    // console.log("=== 최종 주문 데이터 ===");
                    // console.log(JSON.stringify(Object.values(stores), null, 2));

                    return Object.values(stores);
                },





                fnGroupCartList: function (list) {
                    const grouped = {};
                    if (!Array.isArray(list) || list.length === 0) {
                        this.groupedCartList = [];
                        // console.log("장바구니 목록이 비어 있거나 올바르지 않아 그룹화하지 않습니다.");
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
                                userName: item.userName,
                                phone: item.phone,
                                userAddr: item.userAddr,
                                storeAddr: item.storeAddr,

                                cartId: cartId,
                                storeName: item.storeName,
                                storeId: item.storeId,
                                proNo: item.proNo,
                                proName: item.proName || item.PRO_NAME,
                                defPrice: defPrice,
                                options: [],
                                totalPrice: item.defPrice,
                                totalAddPrice: 0,
                                itemQty: cartQuantity,
                                cartOptQuantity: item.cartOptQuantity,
                                letteringWord: item.letteringWord || item.LETTERING_WORD || "",
                                chatYn: item.chatYn || item.CHAT_YN || "N",
                                deliveryFee: deliveryFee,
                                deliveryType: deliveryType,

                                filePath: item.filePath,
                                fileName: item.fileName
                            };
                        }
                        grouped[cartId].options.push({
                            topOpt: item.topOpt || item.TOP_OPT,
                            subOpt: item.subOpt || item.SUB_OPT,
                            topOptionId: item.topOptionId,
                            subOptionId: item.subOptionId,
                            subOptPrice: subOptPrice,
                            cartOptQuantity: optQty,
                        });

                        if (subOptPrice > 0) {
                            const addedAmount = subOptPrice * optQty;
                            grouped[cartId].totalPrice += addedAmount;
                            grouped[cartId].totalAddPrice += addedAmount;
                            grouped[cartId].optionPrice = grouped[cartId].totalPrice - grouped[cartId].defPrice;

                        }
                    });
                    this.groupedCartList = Object.values(grouped);
                    for (let i = 0; i < this.groupedCartList.length; i++) {
                        this.groupedCartList[i].totalPrice = this.groupedCartList[i].totalPrice * this.groupedCartList[i].itemQty;

                    }
                    this.groupedCartList = this.groupedCartList.slice().reverse();
                    // console.log("그룹화된 장바구니 ===>", this.groupedCartList);
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
                    const newTotalPrice = (group.defPrice + group.totalAddPrice) * newItemQty;

                    const param = {
                        cartId: cartId,
                        newQuantity: newItemQty,
                        finalPrice: newTotalPrice + group.deliveryFee // 배송비 합산해서 서버로 전달
                    };
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
                // console.log("로그인 아이디 ===> " + self.userId);
                self.fnCart();
            }
        });
        app.mount('#app');
    </script>