<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/main/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 판매 내역</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>

    <style>
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: #f4f4f4;
            margin-left: 220px;
        }

        .order-card {
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .order-info-header {
            font-weight: bold;
            margin-bottom: 10px;
            border-bottom: 1px dashed #eee;
            padding-bottom: 5px;
            color: #333;
        }

        .order-detail-flex {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .product-image {
            width: 100px;
            height: 100px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            margin-right: 15px;
            flex-shrink: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 12px;
            color: #999;
        }

        .product-info {
            flex-grow: 1;
        }

        .product-info strong {
            font-size: 16px;
            display: block;
            margin-bottom: 5px;
        }

        .price-area {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            text-align: right;
            flex-shrink: 0;
            width: 100px;
        }

        .no-orders {
            text-align: center;
            color: #999;
            padding: 20px;
        }

        .pagination button {
            margin: 0 3px;
            padding: 5px 10px;
            cursor: pointer;
        }

        .pagination button:disabled {
            cursor: not-allowed;
            opacity: 0.5;
        }
    </style>
</head>

<body>
    <script>
        var sessionId = '<%= session.getAttribute("userId") != null ? session.getAttribute("userId") : "" %>';
    </script>

    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">마이페이지 (판매자) - 판매 내역</h1>

                <div v-if="pagedOrderList.length === 0" class="no-orders">
                    조회된 판매 내역이 없습니다.
                </div>

                <div class="order-list" v-else>
                    <div v-for="order in pagedOrderList" :key="order.orderId" class="order-card">
                        <div class="order-info-header">
                            주문 ID: {{ order.orderId }} | 주문자: {{ order.userName }} | 주문일: {{
                            formatDate(order.pickupDate) }}

                            <button @click="goDetail(order.orderId)">주문상세 보기</button>

                        </div>

                        <div class="order-detail-flex">
                            <div class="product-image">
                                <img v-if="order.productImage" :src="order.productImage" alt="상품 이미지"
                                    style="max-width:100%; max-height:100%;">
                                <div v-else>상품 이미지</div>
                            </div>

                            <div class="product-info">
                                <strong>{{ order.proName }}</strong>
                                <p style="font-size:14px; margin:5px 0 10px 0;">
                                    {{ order.pickupDate ? '픽업일' : '도착예정일' }}: {{ formatDate(order.pickupDate ||
                                    order.deliveryDate) }}
                                </p>
                                <p style="font-size:13px; color:#666;">
                                    연락처: {{ order.userPhone || '-' }} / 배송지: {{ order.address || '매장 픽업' }}
                                </p>
                                <p style="font-size:13px; color:#888;">
                                    옵션: {{ order.options || '옵션 정보 없음' }} / 수량: {{ order.cnt }}개
                                </p>
                            </div>

                            <div class="price-area">
                                {{ formatNumber(order.totalPrice) }}원
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pagination" v-if="totalPages > 1" style="text-align:center; margin-top:20px;">
                    <button :disabled="currentPage === 1" @click="changePage(currentPage - 1)">이전</button>
                    <span v-for="page in totalPages" :key="page" style="margin:0 5px;">
                        <button :style="{ fontWeight: currentPage === page ? 'bold' : 'normal' }"
                            @click="changePage(page)">
                            {{ page }}
                        </button>
                    </span>
                    <button :disabled="currentPage === totalPages"
                        @click="changePage(currentPage + 1)">다음</button>
                </div>

            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    allOrders: [],      // 서버에서 받은 전체 데이터
                    pagedOrderList: [], // 현재 페이지 데이터
                    userId: "${sessionId}",  // 세션에서 받은 userId 사용 (건드리지 않음)
                    currentPage: 1,
                    pageSize: 3,
                    totalPages: 1,
                };
            },
            methods: {
                goDetail(orderId) {
                    if (!orderId) {
                        console.error("Order ID가 누락되어 상세 페이지로 이동할 수 없습니다.");
                        return;
                    }

                    // 디버깅용
                    console.log("넘어가는 orderId:", orderId);

                    const form = document.createElement('form');
                    form.setAttribute('method', 'post');
                    form.setAttribute('action', '/seller/OrderHistoryViewDetails.do');

                    const hiddenField = document.createElement('input');
                    hiddenField.setAttribute('type', 'hidden');
                    hiddenField.setAttribute('name', 'orderId');
                    hiddenField.setAttribute('value', orderId);

                    form.appendChild(hiddenField);
                    document.body.appendChild(form);
                    form.submit();
                },

                fnList() {
                    if (!this.userId) {
                        console.warn("userId가 없어 판매 내역을 조회할 수 없습니다.");
                        return;
                    }

                    $.ajax({
                        url: "/seller/orderList.dox",
                        type: "POST",
                        dataType: "json",
                        data: { userId: this.userId },
                        success: (data) => {
                            console.log("서버 응답 데이터:", data); // 디버깅용
                            this.allOrders = (data.list || []).map(o => ({
                                orderId: o.ORDER_ID,
                                userName: o.USER_NAME,
                                userPhone: o.USER_PHONE,
                                proName: o.PRO_NAME,
                                totalPrice: (o.PRICE || 0) + (o.PRICE_DIFF || 0),
                                pickupDate: o.PICKUP_DELIVERY_DATE,
                                deliveryDate: o.PICKUP_DELIVERY_DATE,
                                options: `${o.OPTION_NAME || '옵션 없음'}: ${o.VALUE_NAME || '기본'}`,
                                cnt: 1,
                                productImage: o.PRO_IMAGE_URL || ''
                            }));
                            this.totalPages = Math.ceil(this.allOrders.length / this.pageSize);
                            this.changePage(1);
                        },
                        error: (xhr, status, error) => {
                            console.error("판매 내역 조회 실패:", status, error);
                            this.allOrders = [];
                            this.pagedOrderList = [];
                        }
                    });
                },

                changePage(page) {
                    if (page < 1 || page > this.totalPages) return;
                    this.currentPage = page;
                    const start = (page - 1) * this.pageSize;
                    const end = start + this.pageSize;
                    this.pagedOrderList = this.allOrders.slice(start, end);
                },

                formatDate(date) {
                    if (window.moment && date) return moment(date).format('YYYY.MM.DD');
                    return date || '-';
                },

                formatNumber(number) {
                    if (number === null || number === undefined) return '0';
                    return number.toLocaleString();
                }
            },

            mounted() {
                if (this.userId) this.fnList();
            }
        });

        app.mount('#app');
    </script>
</body>

</html>
