<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>주문 상세 관리</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
            <script src="/js/page-change.js"></script>

            <style>
                :root {
                    --espresso: #3E2723;
                    --peony: #F4C9D6;
                    --primary-color: var(--espresso);
                    --accent-green: #28a745;
                    --accent-red: #dc3545;
                    --light-bg: #f8f9fa;
                    --white: #FFFFFF;
                }

                body {
                    margin: 0;
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: var(--light-bg);
                }

                .content-area {
                    flex-grow: 1;
                    padding: 30px;
                    margin-left: 220px;
                    box-sizing: border-box;
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .page-title {
                    font-size: 24px;
                    font-weight: 900;
                    margin-bottom: 30px;
                    color: var(--primary-color);
                    text-align: center;
                    padding-bottom: 10px;
                    border-bottom: 2px solid var(--primary-color);
                }

                .detail-card {
                    position: relative;
                    border: 1px solid #ddd;
                    padding: 50px 30px 30px 30px;
                    border-radius: 12px;
                    background-color: var(--white);
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                }

                /* 상태 배지 */
                .statusBadge {
                    position: absolute;
                    top: 15px;
                    right: 20px;
                    padding: 6px 15px;
                    border-radius: 20px;
                    font-weight: bold;
                    font-size: 13px;
                    z-index: 10;
                }

                .status-P {
                    background-color: #28a745;
                    color: white;
                }

                /* 결제완료 */
                .status-C {
                    background-color: #007bff;
                    color: white;
                }

                /* 준비중 */
                .status-D,
                .status-R {
                    background-color: #fd7e14;
                    color: white;
                }

                /* 배송/픽업대기 */
                .status-F {
                    background-color: #6c757d;
                    color: white;
                }

                /* 완료 */
                .status-X {
                    background-color: #dc3545;
                    color: white;
                }

                /* 취소 */

                .order-header {
                    font-weight: bold;
                    margin-bottom: 20px;
                    padding-bottom: 10px;
                    border-bottom: 1px solid #eee;
                    color: #666;
                    font-size: 13px;
                }

                .product-area {
                    display: flex;
                    gap: 25px;
                    margin-bottom: 30px;
                }

                .product-image {
                    width: 180px;
                    height: 180px;
                    background-color: #f8f8f8;
                    border: 1px solid #eee;
                    border-radius: 8px;
                    overflow: hidden;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                .product-image img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .options-list {
                    flex-grow: 1;
                }

                .price-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 8px 0;
                    border-bottom: 1px dashed #eee;
                    font-size: 14px;
                }

                .total-price-area {
                    text-align: right;
                    margin-top: 20px;
                    font-size: 26px;
                    font-weight: bold;
                    color: var(--primary-color);
                }

                .memo-box {
                    border: 1px solid #eee;
                    padding: 12px;
                    margin-top: 10px;
                    border-radius: 6px;
                    background-color: #fffaf0;
                    border-left: 4px solid var(--primary-color);
                }

                .memo-box strong {
                    font-size: 12px;
                    color: var(--primary-color);
                }

                /* 상태 관리 섹션 */
                .status-management {
                    margin-top: 30px;
                    padding: 20px;
                    background: #fdfdfd;
                    border: 1px solid #eee;
                    border-radius: 10px;
                }

                .status-btn-group {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-top: 15px;
                }

                .btn-status {
                    flex: 1;
                    min-width: 100px;
                    padding: 10px;
                    border: 1px solid var(--espresso);
                    background: white;
                    color: var(--espresso);
                    border-radius: 6px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .btn-status:hover {
                    background: #efebe9;
                }

                .btn-status.active {
                    background: var(--espresso);
                    color: white;
                }

                .btn-cancel {
                    border-color: #dc3545;
                    color: #dc3545;
                }

                .btn-cancel:hover {
                    background: #fff5f5;
                }

                .action-group {
                    display: flex;
                    justify-content: flex-end;
                    gap: 10px;
                    margin-top: 25px;
                }

                .btn-main {
                    padding: 12px 25px;
                    background: var(--espresso);
                    color: white;
                    border: none;
                    border-radius: 6px;
                    font-weight: bold;
                    cursor: pointer;
                }
            </style>
        </head>

        <body>

            <script>
                const initialOrderId = '${orderId}' || new URLSearchParams(window.location.search).get('orderId');
            </script>

            <div id="app">
                <div class="main-wrapper">
                    <div class="content-area">
                        <h1 class="page-title">주문 관리 시스템</h1>

                        <div v-if="loading" class="detail-card" style="text-align:center;">
                            <p>주문 데이터를 불러오는 중...</p>
                        </div>

                        <div v-else-if="orderDetail" class="detail-card">
                            <span class="statusBadge" :class="'status-' + orderDetail.status">
                                [[ getStatusName(orderDetail.status) ]]
                            </span>

                            <div class="order-header">
                                주문번호: [[ orderDetail.orderId ]] | 주문자: [[ orderDetail.userName ]] |
                                유형: <strong :style="{color: orderDetail.deliveryYn === 'Y' ? '#007bff' : '#fd7e14'}">
                                    [[ orderDetail.deliveryYn === 'Y' ? '배달 주문' : '픽업 주문' ]]
                                </strong>
                            </div>

                            <div class="product-area">
                                <div class="product-image">
                                    <img v-if="orderDetail.productImage" :src="orderDetail.productImage" alt="상품">
                                    <span v-else>No Image</span>
                                </div>
                                <div class="options-list">
                                    <h2 style="margin:0 0 15px 0;">[[ orderDetail.proName ]]</h2>
                                    <div class="price-row"><span>기본 금액</span><span>[[
                                            formatNumber(orderDetail.productPrice) ]]원</span></div>
                                    <div class="memo-box">
                                        <strong>선택 옵션</strong>
                                        <div style="font-size:14px;">[[ orderDetail.optionDetails ]]</div>
                                    </div>
                                    <div v-if="orderDetail.message !== '요청사항 없음'" class="memo-box"
                                        style="border-left-color: #007bff; background-color: #f0f7ff;">
                                        <strong>요청사항/레터링</strong>
                                        <div style="font-size:14px;">[[ orderDetail.message ]]</div>
                                    </div>
                                    <div class="price-row" style="margin-top:10px;"><span>옵션 합계</span><span>+ [[
                                            formatNumber(orderDetail.autoOptionPriceDiff +
                                            orderDetail.manualOptionPrice) ]]원</span></div>
                                    <div class="total-price-area">총 [[ formatNumber(orderDetail.totalPrice) ]]원</div>
                                </div>
                            </div>

                            <div class="status-management">
                                <div style="font-weight: bold; font-size: 15px; color: #333; margin-bottom: 5px;">📍 단계별
                                    상태 변경</div>
                                <div style="font-size: 12px; color: #888; margin-bottom: 15px;">* 현재 단계는 강조 표시되어 있습니다.
                                    클릭 시 상태가 변경됩니다.</div>

                                <div class="status-btn-group">
                                    <button class="btn-status" :class="{active: orderDetail.status === 'C'}"
                                        @click="fnUpdateStatus('C')">결제수락</button>

                                    <template v-if="orderDetail.deliveryYn === 'Y'">
                                        <button class="btn-status" :class="{active: orderDetail.status === 'D'}"
                                            @click="fnUpdateStatus('D')">배송시작</button>
                                        <button class="btn-status" :class="{active: orderDetail.status === 'F'}"
                                            @click="fnUpdateStatus('F')">배송완료</button>
                                    </template>

                                    <template v-else>
                                        <button class="btn-status" :class="{active: orderDetail.status === 'R'}"
                                            @click="fnUpdateStatus('R')">픽업대기</button>
                                        <button class="btn-status" :class="{active: orderDetail.status === 'F'}"
                                            @click="fnUpdateStatus('F')">픽업완료</button>
                                    </template>

                                    <button class="btn-status btn-cancel" @click="fnUpdateStatus('X')">주문취소</button>
                                </div>
                            </div>

                            <div class="action-group">
                                <button class="btn-main" style="background:#666;"
                                    @click="goToOptionAdd(orderDetail.orderId)">옵션/금액 추가</button>
                                <button class="btn-main" @click="goToChat(orderDetail.orderId)">채팅 상담하기</button>
                            </div>
                        </div>

                        <div v-else class="detail-card" style="text-align:center; color:red;">
                            주문 정보를 찾을 수 없습니다.
                        </div>
                    </div>
                </div>
            </div>

            <script>
                const { createApp } = Vue;

                createApp({
                    delimiters: ['[[', ']]'],
                    data() {
                        return {
                            orderId: initialOrderId,
                            orderDetail: null,
                            loading: true
                        };
                    },
                    methods: {
                        fnDetail() {
                            if (!this.orderId) return;
                            this.loading = true;
                            $.ajax({
                                url: "/seller/orderDetail.dox",
                                type: "POST",
                                data: { orderId: this.orderId },
                                success: (data) => {
                                    if (data && data.orderDetail) {
                                        const od = Array.isArray(data.orderDetail) ? data.orderDetail[0] : data.orderDetail;
                                        this.orderDetail = {
                                            orderId: od.ORDER_ID,
                                            status: od.STATUS,
                                            deliveryYn: od.DELIVERY_YN || 'N', // 배달 여부 추가
                                            userName: od.USER_NAME || '-',
                                            proName: od.PRO_NAME || '-',
                                            totalPrice: od.TOTAL_PRICE || 0,
                                            productPrice: od.PRODUCT_PRICE || 0,
                                            manualOptionPrice: od.MANUAL_OPTION_PRICE || 0,
                                            autoOptionPriceDiff: od.AUTO_OPTION_PRICE_DIFF || 0,
                                            optionDetails: od.OPTION_DETAILS || '선택 옵션 없음',
                                            message: od.LETTERING_WORD || '요청사항 없음',
                                            productImage: od.PRO_IMAGE_URL || ''
                                        };
                                    }
                                    this.loading = false;
                                }
                            });
                        },
                       fnUpdateStatus(newStatus) {
    // 상태 코드에 맞는 한글 이름 매핑
    const statusMap = {
        'P': '결제완료',
        'C': '결제수락',
        'D': '배송시작',
        'R': '픽업대기',
        'F': '완료처리',
        'X': '주문취소'
    };

    const statusName = statusMap[newStatus];
    
    // 유효하지 않은 상태 코드 체크
    if (!statusName) {
        alert('유효하지 않은 상태 코드입니다: ' + newStatus);
        console.error('Invalid status code:', newStatus);
        return;
    }

    if (!confirm(`주문을 [${statusName}] 상태로 변경하시겠습니까?`)) {
        return;
    }

    $.ajax({
        url: "/seller/updateOrderStatus.dox",
        type: "POST",
        data: { 
            orderId: this.orderId, 
            status: newStatus 
        },
        success: (res) => {
            if (res.status === "success") {
                alert("상태가 성공적으로 변경되었습니다.");
                this.fnDetail(); // 업데이트 후 화면 갱신
            } else {
                alert("변경 실패: " + (res.message || "알 수 없는 오류"));
            }
        },
        error: (xhr, status, error) => {
            alert("서버 통신 오류가 발생했습니다.");
            console.error('Ajax Error:', error);
            console.error('Response:', xhr.responseText);
        }
    });
},
                        getStatusName(status) {
                            const names = { 'P': '결제완료', 'C': '준비중', 'D': '배송중', 'R': '픽업대기', 'F': '완료', 'X': '취소' };
                            return names[status] || status;
                        },
                        formatNumber(num) { return Number(num).toLocaleString(); },
                        goToOptionAdd(id) { window.location.href = `/seller/order/addOption.do?orderId=${id}`; },
                        goToChat(id) { pageChange("/chat/chatSeller.do", { orderId: id }); }
                    },
                    mounted() { this.fnDetail(); }
                }).mount('#app');
            </script>
        </body>

        </html>