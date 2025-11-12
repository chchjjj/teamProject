<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
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
    /* ---------------------------------------------------- */
    /* 1. Color Variables & Global Styles (Espresso Theme) */
    /* ---------------------------------------------------- */
    :root {
        --espresso: #3E2723; /* 주요 색상: 짙은 갈색 */
        --peony: #F4C9D6; /* 보조 색상: 분홍색 */
        --butter: #FFEDAC; /* 배경 및 하이라이트: 버터색 */
        --light-bg: #F4F4F4; /* 밝은 배경 */
        --white: #FFFFFF;
        --primary-color: var(--espresso);
        --secondary-color: var(--peony);
    }

    body {
        margin: 0;
        font-family: 'Malgun Gothic', sans-serif;
        background-color: var(--light-bg);
        display: flex;
        min-height: 100vh;
    }

    /* ---------------------------------------------------- */
    /* 2. Layout & Sidebar */
    /* ---------------------------------------------------- */
    .sidebar {
        width: 220px;
        background-color: var(--butter); /* 버터색 적용 */
        flex-shrink: 0;
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        padding-top: 20px;
        z-index: 10;
        box-shadow: 2px 0 5px rgba(0,0,0,0.1); /* 사이드바 그림자 추가 */
    }

    /* 콘텐츠 영역 (크기 키우고 중앙 정렬) */
    .content-area {
        flex-grow: 1;
        padding: 40px; /* 패딩 증가 */
        background-color: var(--light-bg);
        margin-left: 300px; /* 사이드바 공간 확보 */
        
        display: flex;
        flex-direction: column;
        /* align-items: center; */ /* 이 속성은 개별 요소의 margin: 0 auto; 와 중복될 수 있어 제거 */
        /* justify-content: flex-start; */ /* 이 속성도 제거하고 margin으로 대체 */
        
        /* 전체 content-area의 폭을 제한하고 중앙 정렬 */
        max-width: 12000px; /* 이전 600px -> 900px로 증가 */
        margin-right: auto; /* margin-left와 함께 중앙 정렬 */
        margin-left: 220px; /* 사이드바와 겹치지 않게 유지 */
    }

    .page-title {
        font-size: 28px; /* 폰트 크기 증가 */
        font-weight: 600; /* 폰트 굵기 조정 */
        margin-bottom: 40px; /* 간격 증가 */
        color: var(--espresso);
        padding-bottom: 15px; /* 패딩 증가 */
        border-bottom: 3px solid var(--espresso); /* 테두리 굵기 증가 */
        text-align: center;
        width: 120%; /* content-area의 max-width에 맞춰짐 */
    }

    /* ---------------------------------------------------- */
    /* 3. Order Card Styles (New Design 적용 및 크기 증가) */
    /* ---------------------------------------------------- */
    .order-card {
        background-color: var(--white);
        border: 1px solid #e0e0e0;
        padding: 30px; /* 패딩 증가 */
        margin-bottom: 20px; /* 간격 증가 */
        border-radius: 10px; /* 둥근 모서리 증가 */
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); /* 그림자 강화 */
        max-width: 1200px; /* 카드 자체의 최대 너비 */
        width: 140%;
        box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
    }

    .order-card:hover {
        box-shadow: 0 5px 18px rgba(62, 39, 35, 0.15); /* 호버 그림자 강화 */
        border-color: var(--peony);
    }

    .order-info-header {
        display: flex; /* 주문 상세 보기 버튼과 같은 줄에 오도록 */
        justify-content: space-between; /* 양쪽 정렬 */
        align-items: center; /* 수직 중앙 정렬 */
        font-weight: 700; /* 폰트 굵기 조정 */
        margin-bottom: 20px; /* 간격 증가 */
        border-bottom: 2px solid var(--butter);
        padding-bottom: 10px; /* 패딩 조정 */
        color: var(--primary-color);
        font-size: 18px; /* 폰트 크기 증가 */
    }
    
    .order-info-header .view-detail-button {
        padding: 8px 15px; /* 버튼 패딩 증가 */
        background-color: var(--peony); /* 피오니 색상 */
        color: var(--primary-color); /* 에스프레소 색상 */
        border: 1px solid var(--peony);
        border-radius: 5px;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .order-info-header .view-detail-button:hover {
        background-color: #f0b8ca; /* 약간 어두운 피오니 */
        border-color: #f0b8ca;
        transform: translateY(-1px);
    }

    .order-detail-flex {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px; /* 간격 증가 */
    }

    .product-image {
        width: 100px; /* 이미지 크기 증가 */
        height: 100px; /* 이미지 크기 증가 */
        background-color: var(--butter);
        border: 1px solid var(--peony);
        margin-right: 20px;
        flex-shrink: 0;
        border-radius: 8px; /* 둥근 모서리 증가 */
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 12px; /* 폰트 크기 증가 */
        color: var(--primary-color);
    }

    .product-info {
        flex-grow: 1;
    }

    .product-info strong {
        font-size: 18px; /* 폰트 크기 증가 */
        display: block;
        margin-bottom: 8px; /* 간격 증가 */
        color: var(--espresso);
    }

    .product-info p {
        font-size: 14px; /* 폰트 크기 증가 */
        color: #666; /* 색상 조정 */
        margin: 0;
        line-height: 1.5; /* 줄 간격 조정 */
    }

    .price-area {
        font-size: 24px; /* 가격 폰트 크기 키움 */
        font-weight: bold;
        color: var(--espresso);
        text-align: right;
        flex-shrink: 0;
        width: 120px; /* 너비 증가 */
    }

    .no-orders {
        text-align: center;
        color: #999;
        padding: 40px; /* 패딩 증가 */
        border: 1px dashed var(--peony);
        border-radius: 10px;
        margin-top: 30px; /* 간격 증가 */
        max-width: 850px;
        width: 100%;
        box-sizing: border-box;
    }

    /* ---------------------------------------------------- */
    /* 4. Pagination & Utility Buttons */
    /* ---------------------------------------------------- */
    .pagination {
        text-align: center;
        margin-top: 40px; /* 간격 증가 */
        width: 100%;
        max-width: 850px;
    }
    
    .pagination button,
    button {
        padding: 12px 18px; /* 패딩 증가 */
        border-radius: 8px; /* 둥근 모서리 증가 */
        font-size: 14px; /* 폰트 크기 증가 */
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        margin: 0 8px; /* 간격 증가 */

        background-color: var(--white);
        color: var(--primary-color);
        border: 1px solid var(--primary-color);
    }

    .pagination button:hover,
    button:hover {
        background-color: var(--primary-color);
        color: var(--white);
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(62, 39, 35, 0.4); /* 그림자 강화 */
    }

    .pagination button.active {
        background-color: var(--peony);
        color: var(--primary-color);
        border: 1px solid var(--peony);
    }

    .pagination button:disabled {
        cursor: not-allowed;
        opacity: 0.5;
        background-color: #eee;
        color: #999;
        border-color: #ccc;
    }


    /* ---------------------------------------------------- */
    /* 5. Responsive adjustments */
    /* ---------------------------------------------------- */
    @media (max-width: 768px) {
        body {
            flex-direction: column;
        }

        .sidebar {
            position: static;
            width: 100%;
            height: auto;
            padding-top: 10px;
            box-shadow: none; /* 모바일에서는 그림자 제거 */
        }

        .content-area {
            margin-left: 0;
            padding: 20px 15px;
            width: 100%; /* 전체 너비 사용 */
            max-width: 100%; /* 최대 너비 제한 해제 */
            align-items: center; /* 내부 콘텐츠 중앙 정렬 */
        }
        
        .page-title {
            font-size: 22px;
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--espresso);
        }

        .order-card {
            padding: 20px;
            max-width: 95%; /* 모바일에서 카드 너비 조정 */
        }
        
        .order-info-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
            font-size: 16px;
        }

        .order-info-header .view-detail-button {
            width: 100%; /* 버튼 너비 100% */
            margin-top: 10px;
        }


        .order-detail-flex {
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 10px;
        }

        .product-image {
            margin-right: 0;
            margin-bottom: 10px;
            width: 90px;
            height: 90px;
        }

        .product-info strong {
            font-size: 17px;
        }
        .product-info p {
            font-size: 13px;
        }

        .price-area {
            width: 100%;
            text-align: center;
            margin-top: 10px;
            font-size: 22px;
        }

        .no-orders, .pagination {
             max-width: 95%;
        }

        .pagination button {
            margin: 5px 3px;
            padding: 10px 12px;
            font-size: 12px;
        }
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

                            <button v-if="startPage > 1" @click="changePage(startPage - 1)"><<</button>

                            <span v-for="page in getPages()" :key="page" style="margin:0 5px;">
                                <button :style="{ fontWeight: currentPage === page ? 'bold' : 'normal' }"
                                    @click="changePage(page)">
                                    {{ page }}
                                </button>
                            </span>

                            <button v-if="endPage < totalPages" @click="changePage(endPage + 1)">>></button>

                            <button :disabled="currentPage === totalPages"
                                @click="changePage(currentPage + 1)">다음</button>
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
                        allOrders: [],      // 서버에서 받은 전체 데이터
                        pagedOrderList: [], // 현재 페이지 데이터
                        userId: "${sessionId}",  // 세션에서 받은 userId 사용 (건드리지 않음)
                        currentPage: 1,
                        pageSize: 10,       // ⭐ 페이지당 10개로 설정
                        totalPages: 1,
                        pageBlockSize: 10,  // ⭐ 페이지 번호를 10개씩 묶음
                        startPage: 1,
                        endPage: 1,
                    };
                },
                methods: {
                    goDetail: function (orderId) {
                        if (!orderId) {
                            console.error("Order ID가 누락되어 상세 페이지로 이동할 수 없습니다.");
                            return;
                        }
                        console.log("넘어가는 orderId:", orderId);

                        const form = document.createElement('form');
                        form.setAttribute('method', 'post');
                        form.setAttribute('action', '/seller/OrderHistoryViewDetail.do');

                        const hiddenField = document.createElement('input');
                        hiddenField.setAttribute('type', 'hidden');
                        hiddenField.setAttribute('name', 'orderId');
                        hiddenField.setAttribute('value', orderId);

                        form.appendChild(hiddenField);
                        document.body.appendChild(form);
                        form.submit();
                    },

                    fnList: function () {
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
                                console.log("서버 응답 데이터:", data);
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
                                this.calculatePageBlock(1); // 데이터 로드 후 블록 계산
                                this.changePage(1); // 1페이지로 이동
                            },
                            error: (xhr, status, error) => {
                                console.error("판매 내역 조회 실패:", status, error);
                                this.allOrders = [];
                                this.pagedOrderList = [];
                            }
                        });
                    },

                    // 페이지 블록을 계산하는 핵심 메소드
                    calculatePageBlock: function (page) {
                        const currentBlock = Math.ceil(page / this.pageBlockSize);
                        this.startPage = (currentBlock - 1) * this.pageBlockSize + 1;
                        this.endPage = Math.min(this.startPage + this.pageBlockSize - 1, this.totalPages);
                    },

                    // 현재 페이지 블록의 페이지 번호 목록 반환
                    getPages: function () {
                        const pages = [];
                        for (let i = this.startPage; i <= this.endPage; i++) {
                            pages.push(i);
                        }
                        return pages;
                    },

                    changePage: function (page) {
                        if (page < 1 || page > this.totalPages) return;

                        // 페이지 블록이 바뀌는지 확인하고 재계산
                        if (Math.ceil(this.currentPage / this.pageBlockSize) !== Math.ceil(page / this.pageBlockSize)) {
                            this.calculatePageBlock(page);
                        }

                        this.currentPage = page;
                        const start = (page - 1) * this.pageSize;
                        const end = start + this.pageSize;
                        this.pagedOrderList = this.allOrders.slice(start, end);
                    },

                    formatDate: function (date) {
                        if (window.moment && date) return moment(date).format('YYYY.MM.DD');
                        return date || '-';
                    },

                    formatNumber: function (number) {
                        if (number === null || number === undefined) return '0';
                        return number.toLocaleString();
                    }
                },

                mounted() {
                    if (this.userId) this.fnList();
                    else this.calculatePageBlock(1);
                }
            });

            app.mount('#app');
        </script>