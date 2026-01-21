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
                /* 1. Color Variables & Global Styles */
                /* ---------------------------------------------------- */
                :root {
                    --espresso: #3E2723;
                    /* 짙은 갈색 */
                    --peony: #F4C9D6;
                    /* 분홍색 */
                    --butter: #FFEDAC;
                    /* 버터색 */
                    --light-bg: #F4F4F4;
                    /* 배경색 */
                    --white: #FFFFFF;
                    --primary-color: var(--espresso);
                    --secondary-color: var(--peony);
                }

                body {
                    margin: 0;
                    margin-left: 250px;
                    /* ⭐ 사이드바 너비만큼만 밀기 */
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: var(--light-bg);
                    /* display: flex 삭제 - body에 flex 필요 없음 */
                    min-height: 100vh;
                }

                /* ---------------------------------------------------- */
                /* 2. Layout & Sidebar */
                /* ---------------------------------------------------- */
                .sidebar {
                    width: 220px;
                    background-color: var(--butter);
                    flex-shrink: 0;
                    position: fixed;
                    top: 0;
                    left: 0;
                    bottom: 0;
                    padding-top: 20px;
                    z-index: 10;
                    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
                }

                /* 콘텐츠 영역: 창 가운데 정렬 */
                .content-area {
                    flex-grow: 1;
                    padding: 40px;
                    /* margin-left 완전히 삭제 */
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    min-width: 850px;
                    max-width: 1400px;
                    /* 최대 너비 설정 */
                    margin: 0 auto;
                    /* 좌우 중앙 정렬 */
                }

                .page-title {
                    font-size: 28px;
                    font-weight: 600;
                    margin-bottom: 40px;
                    color: var(--espresso);
                    padding-bottom: 15px;
                    border-bottom: 3px solid var(--espresso);
                    text-align: left;
                    width: 100%;
                    max-width: 1000px;
                }


                /* ---------------------------------------------------- */
                /* 3. Order Card Styles */
                /* ---------------------------------------------------- */
                .order-list {
                    width: 100%;
                    max-width: 1000px;
                }

                .order-card {
                    background-color: var(--white);
                    border: 1px solid #e0e0e0;
                    padding: 30px;
                    margin-bottom: 20px;
                    border-radius: 12px;
                    transition: all 0.3s ease;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    box-sizing: border-box;
                }

                .order-card:hover {
                    box-shadow: 0 8px 25px rgba(62, 39, 35, 0.1);
                    border-color: var(--peony);
                }

                .order-info-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-weight: 700;
                    margin-bottom: 20px;
                    border-bottom: 2px solid var(--butter);
                    padding-bottom: 12px;
                    color: var(--primary-color);
                    font-size: 18px;
                }

                .header-left {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .view-detail-button {
                    padding: 8px 18px;
                    background-color: var(--peony);
                    color: var(--primary-color);
                    border: none;
                    border-radius: 6px;
                    font-size: 13px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }

                .view-detail-button:hover {
                    background-color: #f0b8ca;
                    transform: translateY(-2px);
                }

                .order-detail-flex {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    gap: 20px;
                }

                .product-info {
                    flex-grow: 1;
                }

                .product-info strong {
                    font-size: 19px;
                    display: block;
                    margin-bottom: 10px;
                    color: var(--espresso);
                }

                .price-area {
                    font-size: 24px;
                    font-weight: 800;
                    color: var(--espresso);
                    text-align: right;
                    min-width: 140px;
                }

                .no-orders {
                    width: 100%;
                    max-width: 1000px;
                    text-align: center;
                    padding: 80px 0;
                    background: white;
                    border-radius: 12px;
                    color: #999;
                    font-size: 18px;
                    border: 1px dashed #ccc;
                }

                /* ---------------------------------------------------- */
                /* 4. Pagination */
                /* ---------------------------------------------------- */
                .pagination {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    gap: 8px;
                    margin-top: 40px;
                    width: 100%;
                    max-width: 1000px;
                    /* 카드 너비에 맞춰 중앙 정렬 */
                }

                .pagination button {
                    min-width: 40px;
                    height: 40px;
                    border-radius: 8px;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: pointer;
                    background-color: var(--white);
                    color: var(--primary-color);
                    border: 1px solid #ddd;
                    transition: all 0.2s ease;
                }

                .pagination button:hover:not(:disabled) {
                    background-color: var(--espresso);
                    color: var(--white);
                }

                .pagination button.active {
                    background-color: var(--peony) !important;
                    border-color: var(--peony) !important;
                    color: var(--primary-color) !important;
                }

                .pagination button:disabled {
                    opacity: 0.4;
                    cursor: not-allowed;
                }

                /* ---------------------------------------------------- */
                /* 5. Badges */
                /* ---------------------------------------------------- */
                .order-unread-badge {
                    min-width: 22px;
                    height: 22px;
                    background-color: #ff4d4f;
                    color: white;
                    font-size: 11px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: bold;
                }

                .new-order-tag {
                    background-color: #ff4d4f;
                    color: white;
                    font-size: 11px;
                    padding: 2px 8px;
                    border-radius: 4px;
                    font-weight: bold;
                }

                /* ---------------------------------------------------- */
                /* 6. Responsive */
                /* ---------------------------------------------------- */
                @media (max-width: 1100px) {
                    .content-area {
                        padding: 40px;
                        /* ⭐ padding-left 삭제 */
                    }
                }

                @media (max-width: 768px) {


                    .content-area {
                        margin-left: 0;
                        padding: 20px;
                        /* ⭐ padding-left 삭제 */
                        min-width: 100%;
                    }
                }

                .filter-search-container {
                    width: 100%;
                    max-width: 1000px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                    gap: 15px;
                    background: #fff;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    box-sizing: border-box;
                }

                .filter-buttons {
                    display: flex;
                    gap: 10px;
                }

                .filter-btn {
                    padding: 8px 16px;
                    border: 1px solid #ddd;
                    border-radius: 20px;
                    background: white;
                    cursor: pointer;
                    font-size: 14px;
                    transition: all 0.2s;
                }

                .filter-btn.active {
                    background-color: var(--espresso);
                    color: white;
                    border-color: var(--espresso);
                }

                .search-box {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    flex-grow: 1;
                    max-width: 400px;
                }

                .search-input {
                    flex-grow: 1;
                    padding: 10px 15px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    outline: none;
                }

                .search-input:focus {
                    border-color: var(--peony);
                }

                .date-filter {
                    display: flex;
                    align-items: center;
                }

                .date-select {
                    padding: 8px 16px;
                    border: 2px solid #E0E0E0;
                    border-radius: 20px;
                    background: white;
                    cursor: pointer;
                    font-size: 14px;
                    font-weight: 600;
                    color: var(--espresso);
                    transition: all 0.2s;
                    outline: none;
                    min-width: 140px;
                }

                .date-select:hover {
                    border-color: var(--espresso);
                }

                .date-select:focus {
                    border-color: var(--peony);
                    box-shadow: 0 0 0 3px rgba(244, 201, 214, 0.2);
                }

                .sort-filter {
                    display: flex;
                    align-items: center;
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
                        <h1 class="page-title"> 판매 내역</h1>

                        <div class="filter-search-container">
                            <div class="filter-buttons">
                                <button class="filter-btn" :class="{ active: filterType === 'all' }"
                                    @click="setFilter('all')">전체 보기</button>
                                <button class="filter-btn" :class="{ active: filterType === 'new' }"
                                    @click="setFilter('new')">NEW 주문만</button>
                                <button class="filter-btn" :class="{ active: filterType === 'chat' }"
                                    @click="setFilter('chat')">안읽은 채팅</button>
                            </div>
                            <div class="search-box">
                                <input type="text" v-model="searchKeyword" class="search-input"
                                    placeholder="주문 번호를 입력하세요" @keyup.enter="changePage(1)">
                                <button class="view-detail-button" @click="changePage(1)">검색</button>
                            </div>

                            <div class="date-filter">
                                <select v-model="dateFilter" @change="changePage(1)" class="date-select">
                                    <option value="all">전체 날짜</option>
                                    <option value="today">오늘</option>
                                    <option value="tomorrow">내일</option>
                                    <option value="week">이번 주</option>
                                    <option value="month">이번 달</option>
                                </select>
                            </div>

                            <div class="sort-filter">
                                <select v-model="sortOrder" @change="changePage(1)" class="date-select">
                                    <option value="newest">최신 주문순</option>
                                    <option value="oldest">오래된 주문순</option>
                                    <option value="deliveryAsc">배송일 빠른순</option>
                                    <option value="deliveryDesc">배송일 늦은순</option>
                                </select>
                            </div>

                        </div>

                        <div v-if="filteredOrders.length === 0" class="no-orders">
                            조회된 판매 내역이 없습니다.
                        </div>

                        <div class="order-list" v-else>
                            <div v-for="order in pagedOrderList" :key="order.orderId" class="order-card">
                                <div class="order-info-header">
                                    <div class="header-left">
                                        <span v-if="order.unreadCount > 0" class="order-unread-badge">{{
                                            order.unreadCount }}</span>
                                        주문 ID: {{ order.orderId }} |
                                        <span v-if="isNewOrder(order.orderDate)" class="new-order-tag">NEW</span>
                                        주문자: {{ order.userName }} |
                                        주문일: {{ formatDate(order.orderDate) }}
                                        <span v-if="order.status === 'X'"
                                            style="color: white; background-color: #ff4d4f; padding: 2px 8px; border-radius: 4px; font-size: 12px; margin-left: 10px; font-weight: bold;">주문취소</span>
                                    </div>
                                    <div class="header-buttons">
                                        <button class="view-detail-button" @click="goDetail(order.orderId)">주문상세
                                            보기</button>
                                    </div>
                                </div>
                                <div class="order-detail-flex">
                                    <div class="product-info">
                                        <strong>{{ order.proName }}</strong>
                                        <p style="font-size:14px; margin:5px 0 10px 0;">{{ order.pickupDate ? '픽업일' :
                                            '도착예정일' }}: {{ formatDate(order.pickupDate || order.deliveryDate) }}</p>
                                        <p style="font-size:13px; color:#666;">연락처: {{ order.userPhone || '-' }} / 배송지:
                                            {{ order.address || '매장 픽업' }}</p>
                                        <p style="font-size:13px; color:#888;">옵션: {{ order.options || '옵션 정보 없음' }} /
                                            수량: {{ order.cnt }}개</p>
                                    </div>
                                    <div class="price-area">{{ formatNumber(order.totalPrice) }}원</div>
                                </div>
                            </div>
                        </div>

                        <div class="pagination" v-if="totalPages > 1">
                            <button :disabled="currentPage === 1" @click="changePage(currentPage - 1)">이전</button>
                            <button v-for="page in getPages()" :key="page" :class="{ active: currentPage === page }"
                                @click="changePage(page)">{{ page }}</button>
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
                        pageSize: 5,       // ⭐ 페이지당 10개로 설정
                        totalPages: 1,
                        pageBlockSize: 10,  // ⭐ 페이지 번호를 10개씩 묶음
                        startPage: 1,
                        endPage: 1,
                        filterType: 'all', // 'all' 또는 'new'
                        searchKeyword: '', // 주문번호 검색어
                        dateFilter: 'all',
                        sortOrder: 'newest'
                    };
                },
                computed: {
                    filteredOrders() {
                        let list = this.allOrders;
                        if (this.filterType === 'chat') {
                            list = list.filter(order => order.unreadCount > 0);

                        }
                        if (this.dateFilter !== 'all') {
                            list = list.filter(order => this.matchesDateFilter(order));
                        }

                        // 1. "NEW 주문만" 필터링
                        if (this.filterType === 'new') {
                            list = list.filter(order => this.isNewOrder(order.orderDate));
                        }

                        // 2. 주문번호(ID) 검색어 필터링
                        if (this.searchKeyword) {
                            list = list.filter(order =>
                                String(order.orderId).includes(this.searchKeyword)
                            );
                        }

                        list = this.sortOrders(list);
                        return list;
                    }
                },
                methods: {
                    sortOrders: function (orders) {
                        const sorted = [...orders]; // 원본 배열 보호

                        switch (this.sortOrder) {
                            case 'newest':
                                // 최신 주문순 (주문일 기준)
                                return sorted.sort((a, b) =>
                                    moment(b.orderDate).valueOf() - moment(a.orderDate).valueOf()
                                );

                            case 'oldest':
                                // 오래된 주문순 (주문일 기준)
                                return sorted.sort((a, b) =>
                                    moment(a.orderDate).valueOf() - moment(b.orderDate).valueOf()
                                );

                            case 'deliveryAsc':
                                // 배송일 빠른순
                                return sorted.sort((a, b) => {
                                    const dateA = a.pickupDate || a.deliveryDate;
                                    const dateB = b.pickupDate || b.deliveryDate;
                                    if (!dateA) return 1;
                                    if (!dateB) return -1;
                                    return moment(dateA).valueOf() - moment(dateB).valueOf();
                                });

                            case 'deliveryDesc':
                                // 배송일 늦은순
                                return sorted.sort((a, b) => {
                                    const dateA = a.pickupDate || a.deliveryDate;
                                    const dateB = b.pickupDate || b.deliveryDate;
                                    if (!dateA) return 1;
                                    if (!dateB) return -1;
                                    return moment(dateB).valueOf() - moment(dateA).valueOf();
                                });

                            default:
                                return sorted;
                        }
                    },
                    goDetail: function (orderId) {
                        if (!orderId) {
                            console.error("Order ID가 누락되었습니다.");
                            return;
                        }
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
                    }, matchesDateFilter: function (order) {
                        const deliveryDate = order.pickupDate || order.deliveryDate;
                        if (!deliveryDate) return false;

                        const date = moment(deliveryDate);
                        const today = moment().startOf('day');

                        switch (this.dateFilter) {
                            case 'today':
                                return date.isSame(today, 'day');
                            case 'tomorrow':
                                return date.isSame(today.clone().add(1, 'day'), 'day');
                            case 'week':
                                return date.isBetween(today, today.clone().add(7, 'days'), 'day', '[]');
                            case 'month':
                                return date.isSame(today, 'month');
                            default:
                                return true;
                        }
                    },

                    // 2. 필터 변경 (필터 클릭 시 호출)
                    setFilter(type) {
                        this.filterType = type;
                        this.changePage(1); // 필터 바뀔 때 항상 1페이지로
                    },

                    // 3. 페이지 변경 (검색, 필터, 페이징 클릭 시 호출)
                    changePage(page) {
                        // totalPages 업데이트 (필터링된 결과 기준)
                        this.totalPages = Math.ceil(this.filteredOrders.length / this.pageSize) || 1;

                        if (page < 1 || page > this.totalPages) return;

                        this.currentPage = page;

                        // 페이지 블록 계산
                        this.calculatePageBlock(page);

                        // 중요: allOrders가 아니라 'filteredOrders'에서 잘라내야 함
                        const start = (page - 1) * this.pageSize;
                        const end = start + this.pageSize;
                        this.pagedOrderList = this.filteredOrders.slice(start, end);
                    },

                    // 4. 서버 데이터 로드
                    fnList: function () {
                        if (!this.userId || this.userId === "null" || this.userId === "") {
                            console.warn("userId가 없습니다.");
                            return;
                        }

                        $.ajax({
                            url: "/seller/orderList.dox",
                            type: "POST",
                            dataType: "json",
                            data: { userId: this.userId },
                            success: (data) => {
                                this.allOrders = (data.list || []).map(o => ({
                                    orderId: o.ORDER_ID,
                                    orderDate: o.ORDER_CREATED_AT,
                                    status: o.STATUS,
                                    userName: o.USER_NAME,
                                    userPhone: o.USER_PHONE,
                                    proName: o.PRO_NAME,
                                    totalPrice: (o.PRICE || 0) + (o.PRICE_DIFF || 0),
                                    pickupDate: o.PICKUP_DELIVERY_DATE,
                                    deliveryDate: o.PICKUP_DELIVERY_DATE,
                                    options: `${o.OPTION_NAME || '옵션 없음'}: ${o.VALUE_NAME || '기본'}`,
                                    cnt: 1,
                                    productImage: o.PRO_IMAGE_URL || '',
                                    unreadCount: o.UNREAD_COUNT || 0
                                }));
                                // 데이터 로드 후 필터 적용하여 1페이지 표시
                                this.changePage(1);
                            },
                            error: (xhr, status, error) => {
                                console.error("조회 실패:", error);
                            }
                        });
                    },

                    calculatePageBlock: function (page) {
                        const currentBlock = Math.ceil(page / this.pageBlockSize);
                        this.startPage = (currentBlock - 1) * this.pageBlockSize + 1;
                        this.endPage = Math.min(this.startPage + this.pageBlockSize - 1, this.totalPages);
                    },

                    getPages: function () {
                        const pages = [];
                        for (let i = this.startPage; i <= this.endPage; i++) {
                            pages.push(i);
                        }
                        return pages;
                    },

                    formatDate: function (date) {
                        if (window.moment && date) return moment(date).format('YYYY.MM.DD');
                        return date || '-';
                    },

                    formatNumber: function (number) {
                        if (number === null || number === undefined) return '0';
                        return number.toLocaleString();
                    },

                    isNewOrder: function (orderDate) {
                        if (!orderDate) return false;
                        const now = moment();
                        const orderTime = moment(orderDate, "MMM DD, YYYY, h:mm:ss A");
                        if (!orderTime.isValid()) return false;
                        const duration = moment.duration(now.diff(orderTime));
                        return duration.asHours() <= 24 && duration.asHours() >= 0;
                    }


                },

                mounted() {
                    if (this.userId) this.fnList();
                    else this.calculatePageBlock(1);
                    console.log("세션 userId:", this.userId);
                    if (this.userId) this.fnList();
                }
            });

            app.mount('#app');
        </script>