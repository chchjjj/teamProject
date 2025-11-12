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

            /* Order Card - 优化版 */
            .orderCard {
                background-color: var(--white);
                border: 1px solid #e0e0e0;
                border-radius: 12px;
                padding: 24px;
                margin-bottom: 20px;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            }

            .orderCard:hover {
                box-shadow: 0 4px 16px rgba(62, 39, 35, 0.12);
                border-color: var(--peony);
            }

            /* 订单头部 */
            .orderHeader {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 20px;
                padding-bottom: 16px;
                border-bottom: 2px solid #f5f5f5;
            }

            .orderHeaderLeft {
                flex: 1;
            }

            .storeName {
                font-size: 18px;
                font-weight: 700;
                color: var(--espresso);
                margin-bottom: 6px;
            }

            .orderMeta {
                display: flex;
                gap: 12px;
                align-items: center;
                flex-wrap: wrap;
            }

            .orderDate {
                font-size: 13px;
                color: #999;
            }

            .orderId {
                font-size: 12px;
                color: #bbb;
                font-family: monospace;
            }

            /* 状态标签 */
            .statusBadge {
                display: inline-block;
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
                white-space: nowrap;
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

            /* 进度条区域 */
            .progressSection {
                background-color: #fafafa;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .progressHeader {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
            }

            .deliveryBadge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
            }

            .delivery-D {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .delivery-P {
                background-color: #fff3e0;
                color: #f57c00;
            }

            .progressStatus {
                font-size: 14px;
                font-weight: 600;
                color: var(--espresso);
            }

            /* 进度条 */
            .progressBar {
                position: relative;
                height: 8px;
                background-color: #e0e0e0;
                border-radius: 10px;
                overflow: hidden;
            }

            .progressFill {
                height: 100%;
                background: linear-gradient(90deg, var(--peony), #f0b8ca);
                border-radius: 10px;
                transition: width 0.6s ease;
                position: relative;
            }

            .progressFill::after {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
                animation: shimmer 2s infinite;
            }

            @keyframes shimmer {
                0% { transform: translateX(-100%); }
                100% { transform: translateX(100%); }
            }

            /* 商品列表 */
            .productList {
                margin-bottom: 20px;
            }

            .productItem {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                padding: 12px 0;
                border-bottom: 1px solid #f5f5f5;
            }

            .productItem:last-child {
                border-bottom: none;
            }

            .productInfo {
                flex: 1;
            }

            .productName {
                font-size: 15px;
                font-weight: 600;
                color: var(--espresso);
                margin-bottom: 6px;
            }

            .productOptions {
                font-size: 13px;
                color: #666;
                line-height: 1.6;
            }

            .productPrice {
                font-size: 15px;
                font-weight: 600;
                color: var(--espresso);
                white-space: nowrap;
                margin-left: 16px;
            }

            /* 订单摘要 */
            .orderSummary {
                background-color: #fafafa;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 16px;
            }

            .summaryRow {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 0;
                font-size: 13px;
                color: #666;
            }

            .summaryRow strong {
                color: var(--espresso);
            }

            .summaryRow.total {
                padding-top: 12px;
                margin-top: 8px;
                border-top: 2px solid #e0e0e0;
            }

            .totalAmount {
                font-size: 20px;
                font-weight: 700;
                color: var(--espresso);
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

                .orderCard {
                    padding: 16px;
                }

                .orderHeader {
                    flex-direction: column;
                    gap: 12px;
                }

                .productItem {
                    flex-direction: column;
                    gap: 8px;
                }

                .productPrice {
                    margin-left: 0;
                }

                .progressSection {
                    padding: 16px;
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
                    <button @click="fnDeleteAccount()">회원탈퇴</button>
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
                    <div v-else>
                        <div v-for="order in groupedOrdersList" :key="order.orderId" class="orderCard">
                            
                            <!-- 订单头部 -->
                            <div class="orderHeader">
                                <div class="orderHeaderLeft">
                                    <h3 class="storeName">{{ order.storeName }}</h3>
                                    <div class="orderMeta">
                                        <span class="orderDate">{{ order.orderDate }}</span>
                                        <span class="orderId">주문번호: {{ order.orderId }}</span>
                                    </div>
                                </div>
                                <span class="statusBadge" :class="'status-' + order.status">
                                    <span v-if="order.status==='P'">결제 완료</span>
                                    <span v-else-if="order.status==='C'">결제 수락</span>
                                    <span v-else-if="order.status==='S'">결제 대기</span>
                                </span>
                            </div>

                            <!-- 进度条区域 -->
                            <div class="progressSection">
                                <div class="progressHeader">
                                    <span class="deliveryBadge" :class="'delivery-' + order.deliveryType">
                                        <span v-if="order.deliveryType==='D'">📦 배송</span>
                                        <span v-else-if="order.deliveryType==='P'">🏪 픽업</span>
                                    </span>
                                    <span class="progressStatus">
                                        <span v-if="order.deliveryType==='D'">
                                            <span v-if="order.deliveryStatus==='Z'">주문신청</span>
                                            <span v-else-if="order.deliveryStatus==='A'">주문수락완료</span>
                                            <span v-else-if="order.deliveryStatus==='D'">배송중</span>
                                            <span v-else-if="order.deliveryStatus==='F'">배송완료</span>
                                        </span>
                                        <span v-else-if="order.deliveryType==='P'">
                                            <span v-if="order.deliveryStatus==='Z'">준비중</span>
                                            <span v-else-if="order.deliveryStatus==='A'">준비완료</span>
                                            <span v-else-if="order.deliveryStatus==='D'">픽업완료</span>
                                        </span>
                                    </span>
                                </div>
                                <div class="progressBar">
                                    <div class="progressFill" :style="{width: getProgressWidth(order)}"></div>
                                </div>
                            </div>

                            <!-- 商品列表 -->
                            <div class="productList">
                                <div v-for="orderDetail in Object.values(order.groupedDetails)" 
                                     :key="orderDetail.proName" 
                                     class="productItem">
                                    <div class="productInfo">
                                        <div class="productName">{{ orderDetail.proName }}</div>
                                        <div class="productOptions">
                                            <div v-if="orderDetail.letteringWord">
                                                🎨 레터링: {{ orderDetail.letteringWord }}
                                            </div>
                                            <div v-if="orderDetail.options && orderDetail.options.length > 0">
                                                <span v-for="(option, idx) in orderDetail.options" :key="idx">
                                                    {{ option.optionName }}: {{ option.valueName }}
                                                    ({{ formatNumber(option.priceDiff) }}원 × {{ option.addQuantity }})
                                                    <span v-if="idx < orderDetail.options.length - 1"> / </span>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="productPrice">
                                        {{ formatNumber(orderDetail.subtotal) }}원
                                    </div>
                                </div>
                            </div>

                            <!-- 订单摘要 -->
                            <div class="orderSummary">
                                <div class="summaryRow" v-if="order.deliveryType==='D'">
                                    <span>📍 배송 주소</span>
                                    <span>{{ order.fullAddress }}</span>
                                </div>
                                <div class="summaryRow" v-if="order.deliveryType==='D'">
                                    <span>🚚 희망 배송일</span>
                                    <span>{{ order.wishDeli }}</span>
                                </div>
                                <div class="summaryRow" v-if="order.deliveryType==='P'">
                                    <span>⏰ 픽업 시간</span>
                                    <span>{{ order.pickTime }}</span>
                                </div>
                                <div class="summaryRow" v-if="order.deliveryType==='D'">
                                    <span>배송비</span>
                                    <span>{{ formatNumber(order.deliveryFee) }}원</span>
                                </div>
                                <div class="summaryRow" v-if="order.chatYn==='Y'">
                                    <span>💬 채팅 추가 옵션</span>
                                    <span>{{ formatNumber(order.addOptionPrice) }}원</span>
                                </div>
                                <div class="summaryRow total">
                                    <strong>총 결제 금액</strong>
                                    <span class="totalAmount">{{ formatNumber(order.totalPrice) }}원</span>
                                </div>
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
                    orderId: "${orderId}",
                    orderList: [],
                    groupedOrdersList: []
                };
            },
            methods: {
                fnOrderList: function () {
                    let self = this;
                    let param = {
                        userId: self.userId,
                        orderId: self.orderId
                    };
                    $.ajax({
                        url: "/user/orderStatus.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.orderList = data.list;
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
                                deliveryStatus: order.deliveryStatus || "Z",
                                deliveryFee: Number(order.deliveryFee || 0),
                                totalPrice: Number(order.totalPrice || 0),
                                chatYn: order.chatYn,
                                addOptionPrice: Number(order.addOptionPrice || 0),
                                status: order.status || "S",
                                wishDeli: order.wishDeli || "시간 미지정",
                                pickTime: order.pickTime || "시간 미지정",
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
                },

                getProgressWidth: function(order) {
                    if (order.deliveryType === 'D') {
                        switch(order.deliveryStatus) {
                            case 'Z': return '10%';
                            case 'A': return '30%';
                            case 'D': return '70%';
                            case 'F': return '100%';
                            default: return '0%';
                        }
                    } else if (order.deliveryType === 'P') {
                        switch(order.deliveryStatus) {
                            case 'Z': return '30%';
                            case 'A': return '80%';
                            case 'D': return '100%';
                            default: return '0%';
                        }
                    }
                    return '0%';
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

                fnDeleteAccount:function(){ 
                    if(confirm("회원을 탈퇴하겠습니까?")){
                        location.href="/main.do";
                    }
                    return;
                },

                fnLogout: function () {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        let param = {};
                        $.ajax({
                            url: "/user/logout.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if(data.result=="success"){
                                    alert(data.msg+"! 홈페이지로 이동하겠습니다.");
                                    location.href = "/main.do";
                                }else{
                                    alert("로그아웃하는 도중에 오류가 발생하였습니다.");
                                }
                                    
                            }
                            
                        });
                    }
                },
            },

            mounted() {
                let self = this;
                self.fnOrderList();
            }
        });

        app.mount('#app');
    </script>