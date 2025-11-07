<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>주문 내역</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>

        <!-- Navbar CSS -->
        <link rel="stylesheet" href="/css/navbar.css">

        <style>
            /* Page Specific Styles */
            :root {
                --espresso: #3E2723;
                --peony: #F4C9D6;
                --butter: #FFEDAC;
                --light-bg: #F4F4F4;
                --white: #FFFFFF;
            }

            body {
                background-color: var(--light-bg);
            }

            /* Main Container */
            .orderContainer {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .pageTitle {
                font-size: 22px;
                color: var(--espresso);
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid var(--espresso);
            }

            .orderInfoArea {
                background-color: transparent;
            }

            /* Order Card */
            .orderCard {
                background-color: var(--white);
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                padding: 18px;
                margin-bottom: 18px;
                transition: all 0.3s ease;
            }

            .orderCard:hover {
                box-shadow: 0 3px 15px rgba(62, 39, 35, 0.1);
                border-color: var(--espresso);
            }

            /* Store Header */
            .storeName {
                font-size: 17px;
                color: var(--espresso);
                margin-bottom: 12px;
                padding-bottom: 12px;
                border-bottom: 2px solid var(--butter);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .statusBadge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-P {
                background-color: #e8f5e9;
                color: #2e7d32;
            }

            .status-C {
                background-color: #e3f2fd;
                color: #1565c0;
            }

            .status-S {
                background-color: #fff3e0;
                color: #e65100;
            }

            /* Product Detail Card */
            .orderDetailCard {
                background-color: #fafafa;
                border-left: 3px solid var(--peony);
                padding: 15px;
                margin: 10px 0;
                border-radius: 6px;
            }

            .proName {
                font-size: 16px;
                color: var(--espresso);
                margin-bottom: 10px;
                font-weight: 600;
            }

            .detailRow {
                padding: 5px 0;
                color: #555;
                font-size: 13px;
                line-height: 1.5;
            }

            .detailRow strong {
                color: var(--espresso);
                min-width: 70px;
                display: inline-block;
                font-size: 13px;
            }

            /* Delivery Badge */
            .deliveryBadge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
                margin: 3px 0;
            }

            .delivery-D {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .delivery-P {
                background-color: #fff3e0;
                color: #f57c00;
            }

            /* Options List */
            ul {
                list-style: none;
                padding: 0;
                margin: 8px 0;
            }

            .optionCard {
                background-color: var(--white);
                padding: 8px 12px;
                margin: 5px 0;
                border-radius: 5px;
                border-left: 2px solid var(--butter);
                font-size: 12px;
                color: #666;
            }

            .optionCard strong {
                color: var(--espresso);
                font-size: 12px;
            }

            .optionCard small {
                color: #999;
                font-size: 11px;
            }

            /* Order Summary */
            .summaryRow {
                padding: 6px 0;
                color: #555;
                font-size: 13px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #f5f5f5;
            }

            .summaryRow strong {
                color: var(--espresso);
                font-size: 13px;
            }

            .summaryRow span {
                font-size: 13px;
            }

            .totalPrice {
                font-size: 20px;
                color: var(--espresso);
                font-weight: bold;
                margin: 12px 0 8px 0;
                text-align: right;
            }

            /* Action Buttons */
            .actionButtons {
                display: flex;
                gap: 8px;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid #f0f0f0;
            }

            .actionButtons button {
                flex: 1;
                padding: 10px 15px;
                border: none;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btnChat {
                background-color: var(--peony);
                color: var(--espresso);
            }

            .btnChat:hover {
                background-color: #f0b8ca;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(244, 201, 214, 0.4);
            }

            .btnStatus {
                background-color: var(--espresso);
                color: var(--white);
            }

            .btnStatus:hover {
                background-color: #2c1b18;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(62, 39, 35, 0.3);
            }

            /* Empty State */
            .emptyState {
                text-align: center;
                padding: 60px 20px;
                color: #999;
                background-color: var(--white);
                border-radius: 8px;
            }

            .emptyState h3 {
                font-size: 20px;
                margin-bottom: 12px;
                color: #666;
            }

            .emptyState p {
                font-size: 14px;
            }

            /* Animation */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .orderCard {
                animation: fadeIn 0.3s ease;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .orderContainer {
                    padding: 20px 15px;
                }

                .pageTitle {
                    font-size: 22px;
                }

                .orderCard {
                    padding: 15px;
                }

                .storeName {
                    font-size: 16px;
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .actionButtons {
                    flex-direction: column;
                }

                .summaryRow {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 5px;
                }
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- Left Sidebar Navigation -->
            <div class="navBar">
                <!-- Logo Area -->
                <div class="logoArea">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <!--로고 클릭시 홈페이지 새로고침 -->
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="navButton">
                    <button @click="fnOrderHistory()" class="active">주문 내역</button>
                    <button @click="fnWishList()">찜한 상품</button>
                    <button @click="fnChatList()">채팅이력</button>
                    <button @click="fnReview()">내가 쓴 리뷰</button>
                    <button @click="fnQnA()">QnA</button>
                    <button @click="fnUserEdit()">정보수정</button>
                </div>

                <!-- Logout Button -->
                <div class="logOut">
                    <button @click="fnLogout()">Logout</button>
                </div>
            </div>

            <!-- Mobile Menu Toggle (hidden on desktop) -->
            <button class="menuToggle" @click="toggleMenu">☰</button>

            <!-- Main Content -->
            <div class="orderContainer">
                <h1 class="pageTitle">📦 주문 내역</h1>

                <div class="orderInfoArea">
                    <!-- Empty State -->
                    <div v-if="groupedOrdersList.length === 0" class="emptyState">
                        <h3>주문 내역이 없습니다</h3>
                        <p>주문하신 내역이 여기에 표시됩니다</p>
                    </div>

                    <!-- Order List -->
                    <div class="storeSection" v-else>
                        <div v-for="(order, orderIndex) in groupedOrdersList" :key="order.orderId" class="orderCard">
                            <!-- Store Name & Status -->
                            <h3 class="storeName">
                                {{ order.storeName }}
                                <span class="statusBadge" :class="'status-' + order.status">
                                    <span v-if="order.status==='P'">결제 완료</span>
                                    <span v-else-if="order.status==='C'">결제 수락</span>
                                    <span v-else-if="order.status==='S'">결제 대기</span>
                                </span>
                            </h3>

                            <!-- Order Details -->
                            <div v-for="(orderDetail, orderDetailIndex) in Object.values(order.groupedDetails)"
                                :key="orderDetailIndex" class="orderDetailCard">

                                <h4 class="proName">{{ orderDetail.proName }}</h4>
                                <div class="detailRow">
                                    <strong>가격:</strong> {{ formatNumber(orderDetail.price) }}원
                                </div>

                                <!-- Delivery Type -->
                                <div class="detailRow">
                                    <span class="deliveryBadge" :class="'delivery-' + order.deliveryType">
                                        <span v-if="order.deliveryType==='D'">📦 {{ order.wishDeli }} 예약배송</span>
                                        <span v-else-if="order.deliveryType==='P'">🏪 {{ order.pickTime }} 픽업</span>
                                    </span>
                                </div>

                                <!-- Options -->
                                <ul v-if="orderDetail.options && orderDetail.options.length > 0">
                                    <li v-for="(option, optionIndex) in orderDetail.options" :key="optionIndex"
                                        class="optionCard">
                                        <strong>{{ option.optionName }} :</strong> {{ option.valueName }}
                                        <br>
                                        <small>{{ formatNumber(option.priceDiff) }}원 × {{ option.addQuantity }}개 = {{
                                            formatNumber(option.optionTotal) }}원</small>
                                    </li>
                                </ul>

                                <!-- Product Info -->
                                <div class="detailRow">
                                    <strong>수량:</strong> {{ orderDetail.quantity }}개
                                </div>
                                <div class="detailRow" v-if="orderDetail.letteringWord">
                                    <strong>레터링:</strong> {{ orderDetail.letteringWord }}
                                </div>
                                <div class="detailRow"
                                    style="font-size: 14px; font-weight: 600; color: var(--espresso); border-top: 1px solid #e0e0e0; margin-top: 8px; padding-top: 8px;">
                                    <strong>소계:</strong> {{ formatNumber(orderDetail.subtotal) }}원
                                </div>
                            </div>

                            <!-- Order Summary -->
                            <div class="summaryRow" v-if="order.chatYn==='Y'">
                                <strong>채팅:</strong>
                                <span>사용 (추가비: {{ formatNumber(order.addOptionPrice) }}원)</span>
                            </div>
                            <div class="summaryRow" v-if="order.deliveryType==='D'">
                                <strong>배송비:</strong>
                                <span>{{ formatNumber(order.deliveryFee) }}원</span>
                            </div>
                            <div class="summaryRow" v-if="order.deliveryType==='P'">
                                <strong>픽업시간:</strong>
                                <span>{{order.pickTime}}</span>
                            </div>
                            <div class="summaryRow" v-if="order.deliveryType==='D'">
                                <strong>주소:</strong>
                                <span>{{ order.fullAddress }}</span>
                            </div>
                            <div class="summaryRow" v-if="order.deliveryType==='P'">
                                <strong>주소:</strong>
                                <span>{{ order.storeAddr }}</span>
                            </div>
                            <div class="summaryRow">
                                <strong>주문 시간:</strong>
                                <span>{{ order.orderDate }}</span>
                            </div>
                            <div class="summaryRow" style="border-bottom: none;">
                                <strong>주문 번호:</strong>
                                <span style="color: #999; font-size: 12px;">{{ order.orderId }}</span>
                            </div>

                            <h3 class="totalPrice">총 {{ formatNumber(order.totalPrice) }}원</h3>

                            <!-- Action Buttons -->
                            <div class="actionButtons">
                                <button class="btnChat"
                                    @click="fnChat(order.orderId, order.storeId)">
                                    💬 채팅방으로
                                </button>
                                <button class="btnStatus" @click="fnPayment(order.orderId)">
                                    💰 바로 결제
                                </button>
                                <button class="btnStatus" @click="fnOrderStatus(order.orderId)">
                                    📋 주문현황
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userId: "${sessionId}",
                    orderList: [],
                    groupedOrdersList: []
                };
            },
            methods: {
                fnOrderList: function () {
                    let self = this;
                    let param = { userId: self.userId };
                    $.ajax({
                        url: "/user/orderHistory.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.orderList = data.list;
                            console.log(data.list);
                            self.fnGroupOrderList(self.orderList);
                        },
                        error: function (xhr, status, error) {
                            console.error("주문내역 로드 실패:", status, error);
                        }
                    });
                },

                fnGroupOrderList: function (list) {
                    const groupedOrders = {};

                    if (!Array.isArray(list) || list.length === 0) {
                        this.groupedOrdersList = [];
                        return;
                    }

                    list.forEach(order => {
                        const orderId = order.orderId;
                        if (!orderId) return;

                        if (!groupedOrders[orderId]) {
                            groupedOrders[orderId] = {
                                orderId: order.orderId,
                                storeName: order.storeName,
                                fullAddress: order.fullAddress,
                                orderDate: order.orderDate,
                                deliveryType: order.deliveryType || "D",
                                deliveryFee: Number(order.deliveryFee || 0),
                                totalPrice: Number(order.totalPrice || 0),
                                chatYn: order.chatYn,
                                addOptionPrice: Number(order.addOptionPrice || 0),
                                status: order.status || "S",
                                wishDeli: order.wishDeli || "시간 미지정",
                                pickTime: order.pickTime || "시간 미지정",
                                storeAddr:order.storeAddr,
                                storeId: order.storeId,
                                groupedDetails: {}
                            };
                        }

                        const orderDetailId = order.orderDetailId;
                        if (!orderDetailId) return;

                        if (!groupedOrders[orderId].groupedDetails[orderDetailId]) {
                            groupedOrders[orderId].groupedDetails[orderDetailId] = {
                                proName: order.proName,
                                subtotal: Number(order.subtotal || 0),
                                price: Number(order.price || 0),
                                letteringWord: order.letteringWord || "",
                                quantity: Number(order.quantity || 1),
                                options: []
                            };
                        }

                        if (order.orderOptionId) {
                            const exists = groupedOrders[orderId].groupedDetails[orderDetailId].options
                                .find(opt => opt.orderOptionId === order.orderOptionId);

                            if (!exists) {
                                groupedOrders[orderId].groupedDetails[orderDetailId].options.push({
                                    orderOptionId: order.orderOptionId,
                                    topOptionId: order.topOptionId,
                                    subOptionId: order.subOptionId,
                                    optionName: order.optionName || "옵션",
                                    valueName: order.valueName || "",
                                    priceDiff: Number(order.priceDiff || 0),
                                    addQuantity: Number(order.addQuantity || 0),
                                    optionTotal: Number(order.optionTotal || 0)
                                });
                            }
                        }
                    });

                    this.groupedOrdersList = Object.values(groupedOrders);
                    console.log("최종 주문 목록:", this.groupedOrdersList);
                },

                formatNumber: function (num) {
                    if (!num && num !== 0) return '0';
                    return Number(num).toLocaleString('ko-KR');
                },

                toggleMenu: function () {
                    document.querySelector('.navBar').classList.toggle('active');
                    document.body.classList.toggle('menu-open');
                },

                fnHome() { location.href = "/main.do" },

                fnOrderHistory: function () {
                    location.href = "/user/orderHistory.do";
                },

                fnWishList: function () {
                    location.href = "/product/wishlist.do";
                },

                fnChatList: function () {
                    location.href = "/user/chatList.do";
                },

                fnReview: function () {
                    location.href = "/user/review.do";
                },

                fnQnA: function () {
                    location.href = "/user/qnA.do";
                },

                fnUserEdit: function () {
                    location.href = "/user/userEdit.do";
                },

                fnLogout: function () {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        location.href = "/user/logout.do";
                    }
                },

                fnChat: function (orderId, storeId) {
                    pageChange("/chat/chatBuyer.do", { orderId: orderId, storeId: storeId });
                },

                fnOrderStatus: function (orderId) {
                    pageChange("/user/orderStatus.do", { orderId: orderId });
                },

                fnPayment: function (orderId) {
                    pageChange("/payment/payment.do", { orderId: orderId });
                }
            },

            mounted() {
                let self = this;
                self.fnOrderList();
            }
        });

        app.mount('#app');
    </script>