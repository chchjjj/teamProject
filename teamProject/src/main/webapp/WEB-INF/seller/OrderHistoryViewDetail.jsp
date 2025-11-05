<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 상세</title> <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>

    <style>
        /* (스타일 시트 내용은 생략하고 유지) */
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: #f4f4f4;
            margin-left: 220px;
        }

        .page-title {
            color: #5d5ddb;
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 30px;
        }

        .detail-card {
            max-width: 600px;
            margin: 0 auto;
            border: 1px solid #ccc;
            padding: 25px;
            border-radius: 10px;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .order-header {
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            color: #333;
            font-size: 16px;
        }

        .product-area {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            align-items: flex-start;
        }

        .product-image {
            width: 150px;
            height: 150px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            flex-shrink: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 14px;
            color: #999;
            border-radius: 5px;
        }

        .options-list {
            flex-grow: 1;
        }

        .options-list div {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
            border-bottom: 1px dashed #eee;
            font-size: 14px;
            color: #555;
        }

        .options-list div:last-of-type {
            border-bottom: none;
            margin-bottom: 10px;
        }

        .option-value {
            font-weight: bold;
            color: #333;
        }

        .total-price-area {
            text-align: right;
            margin-top: 20px;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            padding-top: 10px;
            border-top: 2px solid #5d5ddb;
        }

        .chat-button {
            display: block;
            width: 150px;
            padding: 10px;
            margin-left: auto;
            margin-top: 15px;
            background-color: #5d5ddb;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            font-weight: bold;
        }

        .memo-box {
            border: 1px solid #ddd;
            padding: 10px;
            margin-top: 15px;
            border-radius: 5px;
            background-color: #fffaf0;
        }

        .memo-box strong {
            display: block;
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
        }

        .memo-content {
            font-size: 15px;
            color: #333;
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
        }
    </style>
</head>

<body>
    <script>
        // ⭐ 1. Model에 담긴 orderId를 EL(${orderId})을 사용해 가져옵니다.
        var initialOrderId = '${orderId}';
        
        // 2. 혹시 Controller를 거치지 않고 직접 접근했거나, POST 요청이 아니어서 파라미터가 누락된 경우를 대비해 
        //    쿼리스트링에서도 orderId를 확인하여 최종적으로 orderId를 확정합니다.
        if (initialOrderId === 'null' || initialOrderId === '') {
            initialOrderId = new URLSearchParams(window.location.search).get('orderId') || '';
        }
        
        // 최종적으로 orderId가 비어 있으면 Vue에서 에러 처리할 것입니다.
    </script>

    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">주문 상세</h1>

                <div v-if="loading" class="detail-card" style="text-align:center;">
                    주문 상세 정보를 불러오는 중입니다...
                </div>

                <div v-else-if="orderDetail" class="detail-card">
                    <div class="order-header">
                        주문 ID: [[ orderDetail.orderId ]] | 주문자: [[ orderDetail.userName ]] | 픽업일: [[ formatDate(orderDetail.pickupDate) ]]
                    </div>

                    <div class="product-area">
                        <div class="product-image">
                            <img v-if="orderDetail.productImage" :src="orderDetail.productImage" alt="제품 썸네일"
                                style="max-width:100%; max-height:100%;">
                            <div v-else>제품 썸네일</div>
                        </div>

                        <div class="options-list">
                            <strong style="font-size: 18px; display: block; margin-bottom: 10px;">
                                [[ orderDetail.proName ]]
                            </strong>

                            <div class="memo-box" v-if="orderDetail.message">
                                <strong>문구/요청사항:</strong>
                                <div class="memo-content">[[ orderDetail.message ]]</div>
                            </div>
                            
                            <div v-if="orderDetail.valueName">
                                <span>선택 옵션</span>
                                <span class="option-value">[[ orderDetail.valueName ]]</span>
                            </div>
                        </div>
                    </div>

                    <div class="total-price-area">
                        총액 [[ formatNumber(orderDetail.totalPrice) ]]원
                    </div>

                    <div class="button-group">
                        <button class="action-button option-add-button" @click="goToOptionAdd(orderDetail.orderId)">
                            옵션 추가
                        </button>
                        <button class="action-button" @click="goToChat(orderDetail.orderId)">
                            채팅방 이동
                        </button>
                    </div>
                </div>

                <div v-else class="detail-card" style="text-align:center; color:red;">
                    주문 정보를 찾을 수 없습니다. (ID: [[ orderId || '없음' ]])
                </div>
            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            delimiters: ['[[', ']]'],
            data() {
                return {
                    // ⭐ 수정된 initialOrderId 변수 사용
                    orderId: "${orderId}", 
                    orderDetail: null,
                    loading: true
                };
            },
            methods: {
                fnDetail() {
                    if (!this.orderId || this.orderId === 'null') { // 'null' 문자열 방지
                        console.error("주문 ID가 없습니다.");
                        this.loading = false;
                        this.orderDetail = null; // orderDetail도 null로 설정하여 정보 없음 표시
                        return;
                    }

                    this.loading = true;
                    $.ajax({
                        url: "/seller/orderDetail.dox",
                        type: "POST",
                        dataType: "json",
                        data: { orderId: this.orderId },
                        success: (data) => {
                            if (!data || data.status !== "success" || !data.orderDetail) {
                                this.orderDetail = null;
                                this.loading = false;
                                return;
                            }

                            const od = data.orderDetail;
                            this.orderDetail = {
                                orderId: od.ORDER_ID,
                                userName: od.USER_NAME || od.STORE_NAME || '-',
                                proName: od.PRO_NAME || '-',
                                pickupDate: od.PICKUP_DATE || od.ORDER_DATE || '-',
                                totalPrice: (od.PRICE || 0) + (od.OPTION_PRICE || 0) + (od.DELIVERY_FEE || 0),
                                valueName: od.OPTION_VALUE || '-',
                                message: od.MESSAGE || '-',
                                chatRoomId: od.CHAT_ROOM_ID || '',
                                productImage: od.PRO_IMAGE_URL || '',
                                chatYN: od.CHAT_YN || 'N'
                            };

                            this.loading = false;
                        },
                        error: (xhr, status, error) => {
                            console.error("주문 상세 조회 실패:", status, error);
                            this.orderDetail = null;
                            this.loading = false;
                        }
                    });
                },

                goToChat(orderId) {
                    if (!orderId) {
                        alert("주문 정보가 없습니다.");
                        return;
                    }

                    $.ajax({
                        url: "/seller/chat.dox",
                        type: "POST",
                        dataType: "json",
                        data: { orderId: orderId },
                        success: (res) => {
                            console.log("채팅 호출 결과:", res);

                            if (res && res.status === "success") {
                                if (res.canChat) {
                                    window.location.href = `/seller/sellerChat.do?orderId=${orderId}`;
                                } else {
                                    alert("현재 주문은 채팅 기능을 사용할 수 없습니다.");
                                }
                            } else {
                                alert(res.message || "채팅 서버 호출에 실패했습니다.");
                            }
                        },
                        error: (xhr, status, error) => {
                            console.error("채팅 이동 실패:", status, error);
                            alert("채팅 서버 호출 중 오류가 발생했습니다.");
                            console.log("서버 응답:", xhr.responseText);
                        }
                    });
                },

                goToOptionAdd(orderId) {
                    console.log(`주문 ID ${orderId}에 대한 옵션 추가 페이지로 이동합니다.`);
                    window.location.href = `/seller/order/addOption.do?orderId=${orderId}`;
                    alert(`[옵션 추가] 버튼 클릭: 주문 ID ${orderId}`);
                },
                

                formatDate(date) {
                    if (!date) return '-';
                    const m = moment(new Date(date));
                    return m.isValid() ? m.format('YYYY.MM.DD') : date;
                },

                formatNumber(number) {
                    return number != null ? Number(number).toLocaleString() : '0';
                }
            },
            mounted() {
                this.fnDetail();
            }
        });

        app.mount('#app');
    </script>
</body>

</html>