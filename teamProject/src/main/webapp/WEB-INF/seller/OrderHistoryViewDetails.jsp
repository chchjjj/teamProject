<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/main/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 상세 이미지</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>

    <style>
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: #f4f4f4;
            margin-left: 220px; /* 사이드바 공간 */
        }

        .page-title {
            color: #5d5ddb; /* 이미지와 유사한 색상으로 설정 */
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 30px;
        }

        /* 주문 상세 카드 스타일 */
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
            background-color: #fffaf0; /* 문구/메시지 상자 강조 */
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
        
    </style>
</head>

<body>
    <script>
        // URL에서 orderId 파라미터 값을 가져옵니다.
        const urlParams = new URLSearchParams(window.location.search);
        const initialOrderId = urlParams.get('orderId') || '';
    </script>

    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">주문 상세 이미지 (임시)</h1> <div v-if="loading" class="detail-card" style="text-align:center;">
                    주문 상세 정보를 불러오는 중입니다...
                </div>
                
                <div v-else-if="orderDetail" class="detail-card">
                    <div class="order-header">
                        주문자: {{ orderDetail.userName }} | 픽업일: {{ formatDate(orderDetail.pickupDate) }}
                    </div>

                    <div class="product-area">
                        <div class="product-image">
                            <img v-if="orderDetail.productImage" :src="orderDetail.productImage" alt="제품 썸네일"
                                style="max-width:100%; max-height:100%;">
                            <div v-else>제품 썸네일</div>
                        </div>

                        <div class="options-list">
                            <strong style="font-size: 18px; display: block; margin-bottom: 10px;">
                                {{ orderDetail.proName }}
                            </strong>

                            <div>
                                <span>크기:</span>
                                <span class="option-value">{{ orderDetail.sizeOption }} (+{{ formatNumber(orderDetail.sizePrice) }}원)</span>
                            </div>

                            <div>
                                <span>시트:</span>
                                <span class="option-value">{{ orderDetail.sheetOption }} (+{{ formatNumber(orderDetail.sheetPrice) }}원)</span>
                            </div>

                            <div>
                                <span>디자인:</span>
                                <span class="option-value">{{ orderDetail.designOption }} (+{{ formatNumber(orderDetail.designPrice) }}원)</span>
                            </div>
                            
                            <div>
                                <span>맛:</span>
                                <span class="option-value">{{ orderDetail.tasteOption }} (+{{ formatNumber(orderDetail.tastePrice) }}원)</span>
                            </div>
                            
                            <div class="memo-box">
                                <strong>문구:</strong>
                                <div class="memo-content">{{ orderDetail.message }}</div>
                            </div>
                        </div>
                    </div>

                    <div class="total-price-area">
                        총액 **{{ formatNumber(orderDetail.totalPrice) }}**원
                    </div>

                    <p style="font-size: 11px; color: gray; text-align: right; margin-top: 5px;">
                        채팅 옵션 선택 주문은 빠른 비활성화
                    </p>
                    <button class="chat-button" @click="goToChat(orderDetail.chatRoomId)">
                        채팅방 이동
                    </button>
                    
                </div>
                
                <div v-else class="detail-card" style="text-align:center; color:red;">
                    주문 정보를 찾을 수 없습니다.
                </div>

            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    orderId: initialOrderId,
                    orderDetail: null, // 상세 정보 객체
                    loading: true
                };
            },
            methods: {
                // 주문 상세 정보 조회 (AJAX 통신)
                fnDetail() {
                    if (!this.orderId) {
                        console.error("주문 ID가 없습니다.");
                        this.loading = false;
                        return;
                    }
                    
                    this.loading = true;
                    $.ajax({
                        url: "/seller/orderDetail.dox", // 주문 상세 정보를 가져올 서버 URL
                        type: "POST",
                        dataType: "json",
                        data: { orderId: this.orderId },
                        success: (data) => {
                            this.loading = false;
                            
                            // 서버에서 받은 데이터 구조에 맞게 매핑 필요
                            // 예시: 데이터가 단일 객체로 온다고 가정
                            const detail = data.orderDetail || data; 
                            
                            // 데이터 매핑 (이미지 기반 임시 데이터)
                            if (detail && detail.주문번호) { // 실제 데이터 필드명에 맞게 수정 필요
                                this.orderDetail = {
                                    orderId: detail.주문번호,
                                    userName: detail.주문자명 || '홍길동', // 예시 데이터
                                    pickupDate: detail.픽업_날짜 || '2025-11-12 00:00:00', // 예시 데이터
                                    proName: detail.상품명 || '귀여운 생일 레터링 케이크', // 예시 데이터
                                    productImage: detail.상품이미지 || '',
                                    // 옵션 및 가격 데이터 (예시 데이터)
                                    sizeOption: 'M(지름 15cm)',
                                    sizePrice: 10000,
                                    sheetOption: '원형',
                                    sheetPrice: 0,
                                    designOption: 'A버전',
                                    designPrice: 2000,
                                    tasteOption: '초코맛',
                                    tastePrice: 2000,
                                    message: '볼수야 생일축하해~!',
                                    chatRoomId: detail.채팅방ID || 'chat_123',
                                    // 총액 계산: (상품 기본가) + 옵션 가격의 합. 
                                    // 여기서는 임시로 하드코딩된 옵션 가격을 포함한 총액을 사용
                                    totalPrice: 19500 + 10000 + 0 + 2000 + 2000 // 23500원 예시
                                };
                            } else {
                                this.orderDetail = null; // 데이터 없을 시 null 설정
                            }
                        },
                        error: (xhr, status, error) => {
                            this.loading = false;
                            console.error("주문 상세 조회 실패:", status, error);
                            this.orderDetail = null;
                        }
                    });
                },
                
                // 날짜 포맷팅 함수
                formatDate(date) {
                    if (window.moment && date) return moment(date).format('YYYY년 MM월 DD일');
                    return date || '-';
                },
                
                // 숫자 포맷팅 함수
                formatNumber(number) {
                    if (number === null || number === undefined) return '0';
                    return number.toLocaleString();
                },

                // 채팅방 이동 함수 (실제 채팅 로직으로 연결)
                goToChat(chatRoomId) {
                    if (chatRoomId) {
                        alert(`채팅방 ID: ${chatRoomId} 로 이동합니다.`);
                        // window.location.href = `/chat/room.do?roomId=${chatRoomId}`;
                    } else {
                        alert("채팅방 정보가 없습니다.");
                    }
                }
            },
            mounted() {
                this.fnDetail(); // 페이지 로드 시 상세 정보 조회
            }
        });

        app.mount('#app');
    </script>
</body>

</html>