<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구매화면</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
    <style>
    /* 1. CSS 변수 정의 (변경 없음) */
    :root {
        /* 메인 컬러: 네비게이션 및 버튼에 사용되는 진한 갈색 */
        --main-bg-color: #3C2F2F; 
        /* 배경색: RGB (240, 226, 182) 밝은 베이지색 */
        --sub-bg-color: #F0E2B6; 
        /* 카드 내부 배경색 (흰색 유지) */
        --card-bg-color: #FFFFFF;
        /* 강조 버튼/링크 색상 */
        --primary-color: #6B574C; 
        /* 일반 텍스트 색상 */
        --text-color: #333333;
        /* 연한 테두리 색상 */
        --border-color: #E0E0E0;
        /* 밝은 배경 도트 패턴 색상 (배경색과 동일하게) */
        --light-dot-bg-color: rgba(0,0,0,0.35); /* 살짝 투명한 검은색으로 은은한 도트 효과 */
    }
    
    /* 2. body 및 전체 배경 스타일 (변경 없음) */
    body {
        /* ★★★ 메인/헤더 상단과 동일한 밝은 베이지색 배경 ★★★ */
        background-color: var(--sub-bg-color); 
        
        /* ★★★ 헤더 상단과 동일한 은은한 도트 패턴 적용 ★★★ */
        background-image: radial-gradient(circle at 1px 1px, var(--light-dot-bg-color) 1px, transparent 0);
        /* 도트 간 간격 조정 (30px 유지) */
        background-size: 30px 30px; 
        
        min-height: 100vh;
        font-family: 'Malgun Gothic', 'Dotum', sans-serif;
        color: var(--text-color);
        margin: 0; /* body 기본 마진 제거 */
    }

    /* ================= 헤더 전용 스타일 ================= */

    /* 3. 상단 헤더 영역 (로고, 검색창) */
    .top-header {
        background-color: var(--sub-bg-color); /* 밝은 베이지색 배경 */
        /* 도트 패턴은 body에서 상속받음 */
        padding: 10px 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .header-inner {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;
    }

    .logo img {
        height: 50px; /* 로고 이미지 높이 조정 */
    }

    /* 검색 영역 */
    .search-and-user-area {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .search-box {
        display: flex;
        border: 2px solid var(--primary-color); /* 검색창 테두리 색상 */
        border-radius: 20px;
        overflow: hidden;
        background-color: var(--card-bg-color); /* 흰색 */
    }

    .search-box input {
        border: none;
        padding: 8px 15px;
        outline: none;
        width: 250px;
        font-size: 15px;
    }

    .search-box button {
        background-color: transparent;
        border: none;
        cursor: pointer;
        padding: 0 10px;
        color: var(--primary-color);
    }
    
    /* 유저 메뉴 (찜, 로그인/로그아웃) (변경 없음) */
    .user-menu img {
        cursor: pointer;
        height: 30px; /* 아이콘 크기 조정 */
        margin-left: 10px;
        vertical-align: middle;
    }

    .admin-notice {
        background-color: red;
        color: white;
        text-align: center;
        font-weight: bold;
        padding: 5px 0;
        /* 수정됨: 14px -> 16px */
        font-size: 16px; 
    }

    /* 4. 메인 네비게이션 영역 (카테고리 메뉴) (변경 없음) */
    .main-nav-container {
        /* ★★★ 진한 갈색 배경 적용 ★★★ */
        background-color: var(--main-bg-color); 
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .nav-inner {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .main-menu {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        justify-content: space-around; /* 메뉴 항목 간격 균등하게 분배 */
    }

    .menu-item {
        position: relative;
    }

    .menu-item a {
        display: block;
        padding: 15px 20px;
        text-decoration: none;
        color: white; /* ★★★ 메뉴 텍스트 색상 ★★★ */
        font-weight: bold;
        transition: background-color 0.2s;
    }

    .menu-item a:hover {
        background-color: #5A473D; /* 마우스 호버 시 살짝 어둡게 */
    }

    /* 드롭다운 서브메뉴 (변경 없음) */
    .submenu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background-color: var(--main-bg-color); /* 진한 갈색 */
        list-style: none;
        padding: 0;
        margin: 0;
        min-width: 150px;
        z-index: 10;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .dropdown:hover .submenu {
        display: block; /* 마우스 오버 시 서브메뉴 표시 */
    }

    .submenu li a {
        padding: 10px 20px;
        font-weight: normal;
    }

    /* ================= 메인 콘텐츠 영역 스타일 (font-size 수정됨) ================= */

    /* 5. 메인 콘텐츠 컨테이너 설정 (변경 없음) */
    #app-container {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 40px 20px;
        width: 100%;
        box-sizing: border-box;
    }

    /* 6. 주문 카드 스타일 (변경 없음) */
    #app {
        width: 100%;
        max-width: 950px;
        background-color: var(--card-bg-color); 
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    
    /* (상품 정보, 구분선, 배송지/주문고객 정보, 버튼 스타일 등) */

    .order-item-card {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 15px 0;
        border-bottom: 1px dashed var(--border-color);
    }

    .order-item-card:last-of-type {
        border-bottom: none;
        padding-bottom: 0;
    }
    
    .item-details {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }
    
    .item-details > div {
        /* 수정됨: 14px -> 16px (일반 상세 정보) */
        font-size: 16px; 
    }
    
    .item-details .delivery-type {
        color: var(--primary-color); 
        font-weight: 500;
    }

    .item-details .pro-name {
        font-weight: bold;
        /* 수정됨: 16px -> 18px (상품명 강조) */
        font-size: 18px; 
        margin-bottom: 5px;
    }

    .item-meta {
        text-align: right;
        min-width: 100px;
    }

    .item-meta .total-price {
        font-weight: bold;
        /* 수정됨: 18px -> 20px (개별 상품 가격 강조) */
        font-size: 20px; 
        color: var(--primary-color);
        margin-bottom: 5px;
    }

    .separator {
        border: none;
        border-top: 1px solid var(--border-color);
        margin: 20px 0;
    }
    
    .info-section {
        padding: 20px 0;
        display: flex;
        flex-direction: column;
        gap: 15px;
        color: var(--text-color); 
    }
    
    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 22px; 
    }
    
    .total-payment-line {
        padding: 20px 0;
        border-top: 2px solid var(--border-color);
        font-weight: bold;
        text-align: right;
        color: var(--primary-color);

        display: flex;
        align-items: center;              /* 세로 중앙 정렬 */
    }

    .total-payment{
        font-size: 28px; 
        margin-left: auto; /* 👉 왼쪽 내용과 가능한 한 멀리 */
    }

    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.2s;
        margin-left: 20px;
        font-size: 22px;
    }
    
    .btn-delivery {
        background-color: transparent;
        color: var(--primary-color);
        border: 1px solid var(--primary-color);
        font-size: 18px; 
        padding: 8px 16px;
        margin-left: 10px;
    }
    
    .btn-delivery:hover {
        background-color: var(--primary-color);
        color: var(--card-bg-color);
    }

    .btn-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 30px;
    }

    .btn-cancel {
        background-color: #F0F0F0;
        color: var(--text-color);
        font-weight: normal;
    }
    
    .btn-cancel:hover {
        background-color: #E0E0E0;
    }

    .btn-primary {
        background-color: var(--primary-color);
        color: white;
    }

    .btn-primary:hover {
        background-color: #5A473D;
    }
    
    .date-input{
        display: none;
    }

    .delivery-date-btn{
        background-color: transparent;
        color: var(--primary-color);
        border: 1px solid var(--primary-color);
        font-size: 18px; 
        padding: 8px 16px;
        margin-left: 10px;
    }

     .delivery-date-btn:hover {
        background-color: var(--primary-color);
        color: var(--card-bg-color);
    }

    .orderId{
        font-size: 14px;
        color: #999;  /* ✅ 회색으로 변경 */
        font-weight: normal;
        margin-left: 10px;
    }
    .chat-instructions{
        font-size: 12px;
        flex: 1;
        text-overflow: ellipsis;
        margin-right: 50px;
    }

    /* 판매처 헤더 스타일 */
    .store-header {
        background-color: #f8f9fa;
        padding: 0px 20px;
        border-radius: 8px;
        margin-bottom: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-left: 4px solid var(--primary-color);
    }

    .store-name-header {
        font-weight: bold;
        font-size: 18px;
        color: var(--text-color);
    }

    /* 판매처 그룹 컨테이너 */
    .store-group {
        margin-bottom: 30px;
        padding: 15px;
        background-color: #fafafa;
        border-radius: 12px;
    }

    /* 판매처별 소계 */
    .store-subtotal {
        text-align: right;
        padding: 10px 0;
        border-top: 1px solid #e0e0e0;
        margin-top: 10px;
    }

    .title {
        margin-bottom: 20px; 
        color: var(--primary-color); 
        text-align: center; 
        font-size: 30px;
    }
    
    
    </style>
</head>
<body>
    
    <%@ include file="/WEB-INF/main/header.jsp" %>
    
    <div id="app-container">
        <div id="app">
            <h2 class="title">주문 상세 내역</h2>
            
            <div class="info-section">
                
                <div v-if="deliveryType=='D'" class="info-row">
                    <!-- <span>배송 정보:</span>
                    <span>{{groupedOrdersList[0].fullAddress}}</span> -->
                    <span>배송 정보: {{groupedOrdersList[0].fullAddress}}</span>
                    <button @click="fnDelivery" class="btn btn-delivery">배송지 선택/변경</button>
                </div>

                <!-- 달력 여기부터 -->
                <div class="info-row" v-if="orderId.length <= 0">
                    날짜/시간:

                    <!-- 숨겨진 실제 input -->
                    <input type="text" id="deliveryDateInput" class="date-input" >

                    <!-- 사용자가 클릭하는 버튼 -->
                    <button class="btn delivery-date-btn" @click="openCalendar">
                        {{ selectedDateDisplay }}
                    </button>
                </div>
                <!-- 달력 여기까지 -->
                
                <div class="info-row">
                    <span>주문 고객:</span>
                    <span>{{toName}}</span>
                </div>
                
                <div class="info-row">
                    <span>전화번호:</span>
                    <span v-if="toPhone">{{maskPhone(toPhone)}}</span> 
                    <span v-else>{{maskPhone("${sessionPhone}")}}</span> 
                </div>

            </div>
            
            <div class="total-payment-line">
                <span class="chat-instructions">
                    ※ 채팅옵션을 선택한 고객께서는 필요시 결제 전 마이페이지 통해 문의 부탁드립니다.
                </span>
                <span class="total-payment">총 결제 금액: {{paymentPrice.toLocaleString('ko-KR')}} 원</span>
            </div>
            
            <div class="btn-group">
                
                <button @click="fnGoBack" class="btn btn-cancel">메인으로</button>
                <button @click="fnCheck" class="btn btn-primary">결제하기</button>
            </div>

            <hr class="separator"> 

            <div class="order-list">
            <!-- 판매처별 그룹 -->
                <div v-for="item in groupedOrdersList" :key="item.orderId" class="store-group">
                    
                    <!-- 판매처 헤더 (소계 포함) -->
                    <div class="store-header">
                        <div>
                            <span class="store-name-header">🏪 {{ item.storeName }}</span>
                            <span class="orderId" style="margin-left: 15px;">(주문번호: {{item.orderId}})</span>
                        </div>
                        <!-- ✅ 판매처별 소계를 헤더 오른쪽에 배치 -->
                        <div class="item-meta">
                            <span v-if="deliveryType=='D'" style="margin-right: 30px;">
                                *배송비는 미포함한 금액입니다.
                            </span>
                            <span class="total-price">
                                {{ calculateStoreTotal(item.groupedDetails).toLocaleString('ko-KR') }} 원
                            </span>
                        </div>
                    </div>
                    
                    <!-- 해당 판매처의 상품들 -->
                    <div v-for="(jitem, index) in item.groupedDetails" :key="index" class="order-item-card">
                        <div class="item-details">
                            <div class="pro-name">
                                {{jitem.proName}} <span class="orderId">(수량 : {{jitem.quantity}} 개)</span>
                                
                                <div v-if="jitem.options && jitem.options.length > 0" style="margin-top: 10px;">
                                    <p style="font-weight: bold; margin-bottom: 5px; padding-left: 20px; font-size: 0.8em;">선택 옵션:</p>
                                    <ul style="list-style-type: none; padding-left: 40px;">
                                        <li v-for="opt in getSortedOptions(jitem.options)" :key="opt.orderOptionId" style="margin-bottom: 3px; font-size: 0.6em;">
                                            {{ opt.topOpt }} : {{ opt.subOpt }}
                                            <span v-if="opt.cartOptQuantity > 1"> (수량: {{ opt.cartOptQuantity }} 개)</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    
                        <div class="item-meta">
                            <div class="store-subtotal-header">
                                {{jitem.subtotal.toLocaleString('ko-KR')}} 원
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        
            
        </div>
    </div>
    
    <%@ include file="/WEB-INF/main/footer.jsp" %>
    
    <script>
        IMP.init("imp44302855");
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    userId: "${sessionId}", //사용자 아이디
                    toName: "${sessionName}", //받을 사람
                    toPhone: "", //받을 사람의 휴대폰 번호
                    orderList: [], //배송 정보 확정 전 단계, ORDER_TBL + ORDER_DETAIL_TBL + ORDER_OPTION_TBL
                    deliveryType: "", //배달인지 픽업인지 (배달이면 D, 픽업이면 P)
                    paymentPrice: 0, //최종 결제금액
                    proNameKind: 0, // 한 주문 안의 상품 종류
                    kind: 0, //상품 갯수
                    
                    //order_tbl 관련 변수
                    orderId : "${orderId}", //이전 페이지에서 orderId로 받을 때
                    orderIdList : [], //이 페이지에서 order 관련 테이블의 데이터에 접근할 때 사용
                    groupedOrdersList: [], //주문들을 그룹화한 리스트

                    //달력
                    disabledDates: [
                        "2025-11-01",
                        "2025-11-05",
                        { from: "2025-11-10", to: "2025-11-15" }
                    ],
                    selectedDate: null, // 달력 정보
                    datePicker: null,   // flatpickr 객체를 저장할 변수

                    //판매자가 지정한 날짜 비활성화 기능 적용하는 법
                    disabledDates: [],

                    //장바구니 삭제 기능 구현
                    selectItem: [], // 장바구니 페이지에서 선택한 장바구니 목록
                    cartList: [], //전체 장바구니 목록
                    groupedCartList: [], //옵션 장바구니 목록
                };
            },

            computed: {
                selectedDateDisplay() {
                    if (this.selectedDate) {
                        return this.selectedDate + ' (변경)';
                    }
                    return '픽업/배송 날짜 및 시간 선택';
                }
            },

            methods: {
                // 함수(메소드) - (key : function())

                //주문 목록 출력
                fnOrderList: function(){
                    let self = this;
                    // console.log("JSON.stringify 이전: " + self.orderIdList);
                    let orderIdList = JSON.stringify(self.orderIdList);
                    // console.log("JSON.stringify 이후: " + orderIdList);
                    let param = {
                        orderIdList : orderIdList
                    };
                    $.ajax({
                        url: "/payment/orderList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log("Order 리스트 출력");// 테스트용
                            console.log(data);// 테스트용
                            self.orderList = data.list;
                            // ✅ phoneList 존재 여부 확인 후 할당
                            if (data.phoneList && data.phoneList.length > 0) {
                                self.toPhone = data.phoneList[0].phone;
                            } else {
                                console.log("phoneList가 비어있습니다.");
                                self.toPhone = ""; // 기본값 설정
                            }
                            self.fnGroupOrderList(self.orderList);
                            self.deliveryType = data.list[0].deliveryType; //배달인지 픽업인지
                            console.log("self.deliveryType[0] ===> " + data.list[0].deliveryType);
                        }
                    });
                },

                //장바구니 목록 조회
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
                            console.log(data);
                            self.fnGroupCartList(self.cartList);
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
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
                    console.log("그룹화된 장바구니 ===>", this.groupedCartList);
                },

                //결제 성공까지 했을 때 필요 없어진 장바구니 목록을 지우는 함수
                fnCartDelete: function(){
                    let self = this;
                    selectItem = JSON.stringify(self.selectItem);
                    let param = {
                        selectItem : selectItem
                    };
                    $.ajax({
                        url: "/payment/cartRemove.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log("장바구니 비우기");// 테스트용
                            console.log(data);// 테스트용
                        }
                    });
                },

                //ORDER_TBL의 배송지, 배송비, 총 결제금액, 배송/픽업 선택 업데이트
                fnDelivery: function(){
                    let self = this;
                    window.open("/payment/addressPopUp.do?orderIdList="+self.orderIdList, "addressPopUp", "width=700, height=500, top=100, left=100");
                },

                //결제 진행전 유효성 검사
                fnCheck: function(){
                    let self = this;

                    if (!self.groupedOrdersList || self.groupedOrdersList.length === 0) {
                        alert("결제할 상품 정보가 없습니다.");
                        return;
                    }

                    //장바구니 O, 배달하는 경우
                    if(self.deliveryType=='D' && self.orderId.length <= 0){
                        if ((self.selectedDate == null || self.selectedDate == "") && self.orderId.length < 1) {
                            alert("날짜를 선택해주세요!");
                            return;
                        }
                        let param = {
                            orderId: self.groupedOrdersList[0].orderId
                        };
                        $.ajax({
                            url: "/payment/checkDelivery.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if(data.info.fullAddress != "주소없음" && data.info.fullAddress != null && data.info.fullAddress != ""){
                                    self.fnPayment();
                                } else {
                                    alert("배송지 정보를 선택해주세요!");
                                }
                            }
                        });
                    }

                    //장바구니 O, 픽업하는 경우
                    if(self.deliveryType=='P' && self.orderId.length <= 0){
                        if ((self.selectedDate == null || self.selectedDate == "") && self.orderId.length < 1) {
                            alert("날짜를 선택해주세요!");
                            return;
                        }
                        self.fnPayment();
                    }

                    //장바구니 X, 배달하는 경우
                     if(self.deliveryType=='D' && self.orderId.length > 0){
                        let param = {
                            orderId: self.groupedOrdersList[0].orderId
                        };
                        $.ajax({
                            url: "/payment/checkDelivery.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if(data.info.fullAddress != "주소없음" && data.info.fullAddress != null && data.info.fullAddress != ""){
                                    self.fnPayment();
                                } else {
                                    alert("배송지 정보를 먼저 선택해주세요!");
                                }
                            }
                        });
                     }

                    //장바구니 X, 픽업하는 경우
                     if(self.deliveryType=='P' && self.orderId.length > 0){
                        self.fnPayment();
                     }
                },

                //결제 api 실행 함수
                fnPayment: function(){
                    let self = this;
                    let proName;

                    if(self.kind > 1){
                        proName = self.groupedOrdersList[0].groupedDetails[0].proName + " 외 " +  (self.kind - 1) + "종";
                    } else{
                        proName = self.groupedOrdersList[0].groupedDetails[0].proName;
                    }
                    IMP.request_pay({
                        pg: "html5_inicis",
                        pay_method: "card",
                        merchant_uid: "merchant_" + new Date().getTime(),
                        name: proName, //상품이름, 대표로 제일 첫번째 상품명을 보여준다.
                        amount: self.paymentPrice, //테스트를 위해 결제금액은 1원, 원래는 self.paymentPrice
                        buyer_tel: self.toPhone, // 구매자 휴대폰 번호
                        buyer_name: self.toName // 구매자 성함
                      } , function (rsp) { // callback
                          if (rsp.success) {
                            // 결제 성공 시
                            // alert("결제가 완료되었습니다.");
                            console.log(rsp);
                            
                            // 실제 구현용 여기부터
                            if(self.orderId.length > 0){
                                self.fnPayHistory(rsp.imp_uid, rsp.paid_amount); //바로 결제하는 경우
                            } else if(self.deliveryType == 'D'){
                                self.fnDeliPayHistory(rsp.imp_uid, rsp.paid_amount); //장바구니 거쳐서 배송 결제하는 경우
                            } else if(self.deliveryType == 'P'){
                                self.fnPickPayHistory(rsp.imp_uid, rsp.paid_amount); //장바구니 거쳐서 픽업 결제하는 경우
                            } else {
                                alert("잘못된 결제입니다!");
                                return;
                            }
                            // 실제 구현용 여기까지


                            //테스트 전용 여기부터
                                // if(self.orderId.length > 0){
                                //     self.fnPayHistory(1, 1); //바로 결제하는 경우
                                // } else if(self.deliveryType == 'D'){
                                //     self.fnDeliPayHistory(1, 1); //장바구니 거쳐서 배송 결제하는 경우
                                // } else if(self.deliveryType == 'P'){
                                //     self.fnPickPayHistory(1, 1); //장바구니 거쳐서 픽업 결제하는 경우
                                // } else {
                                //     alert("잘못된 결제입니다!");
                                //     return;
                                // }
                            //테스트 전용 여기까지


                          }
                            else {
                                // 결제 실패 시
                                alert(rsp.error_msg || "결제 실패");
                            } 
                    });
                },

                //PAYMENT_TBL에 결제내역을 추가하는 쿼리문
                fnPayHistory: function(uid, amount){
                    let self = this;
                    let param = {
                        uid: uid,
                        amount: amount,
                        groupedOrdersList: JSON.stringify(self.groupedOrdersList),  // ✅ 여기 변경
                        orderIdList: JSON.stringify(self.orderIdList), // ⭐ 추가
                    };
                    $.ajax({
                        url: "/payment/payment.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if(data.result == "success"){
                                alert("결제가 완료되었습니다.");
                                self.fnCartDelete();
                                location.href="/main.do";
                            } else {
                                alert("오류가 발생했습니다!");
                                location.href="/main.do";
                            }
                        }
                    });
                },

                //PAYMENT_TBL에 결제내역을 추가하는 쿼리문
                fnDeliPayHistory: function(uid, amount){
                    let self = this;
                    let param = {
                        uid: uid,
                        amount: amount,
                        groupedOrdersList: JSON.stringify(self.groupedOrdersList),  // ✅ 여기 변경
                        orderIdList: JSON.stringify(self.orderIdList), // ⭐ 추가
                        selectedDate: self.selectedDate
                    };
                    $.ajax({
                        url: "/payment/deliPayment.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if(data.result == "success"){
                                alert("결제가 완료되었습니다.");
                                self.fnCartDelete();
                                location.href="/main.do";
                            } else {
                                alert("오류가 발생했습니다!");
                                location.href="/main.do";
                            }
                        }
                    });
                },

                //PAYMENT_TBL에 결제내역을 추가하는 쿼리문
                fnPickPayHistory: function(uid, amount){
                    let self = this;
                    let param = {
                        uid: uid,
                        amount: amount,
                        groupedOrdersList: JSON.stringify(self.groupedOrdersList),  // ✅ 여기 변경
                        orderIdList: JSON.stringify(self.orderIdList), // ⭐ 추가
                        selectedDate: self.selectedDate
                    };
                    $.ajax({
                        url: "/payment/pickPayment.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if(data.result == "success"){
                                alert("결제가 완료되었습니다.");
                                self.fnCartDelete();
                                location.href="/main.do";
                            } else {
                                alert("오류가 발생했습니다!");
                                location.href="/main.do";
                            }
                        }
                    });
                },

                fnGoBack: function(){
                        //window.history.back();
                        window.location.href = "/main.do"; // 기본 이동 경로
                },

                fnGroupOrderList: function (list) {
                    let self = this;
                    const groupedOrders = {};

                    if (!Array.isArray(list) || list.length === 0) {
                        self.groupedOrdersList = [];
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
                                status: order.status || "S",
                                wishDeli: order.wishDeli || "시간 미지정",
                                pickTime: order.pickTime || "시간 미지정",
                                storeAddr: order.storeAddr,
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

                        // ✅ ORDER_OPTION_TBL 데이터 매핑 (중복 방지)
                        if (order.orderOptionId) {
                            const exists = groupedOrders[orderId].groupedDetails[orderDetailId].options
                                .find(opt => opt.orderOptionId === order.orderOptionId);

                            if (!exists) {
                                groupedOrders[orderId].groupedDetails[orderDetailId].options.push({
                                    orderOptionId: order.orderOptionId,
                                    topOptionId: order.topOptionId,
                                    subOptionId: order.subOptionId,
                                    topOpt: order.topOpt || "옵션",           // ✅ 상위 옵션 이름
                                    subOpt: order.subOpt || "",               // ✅ 하위 옵션 이름
                                    subOptPrice: Number(order.subOptPrice || order.priceDiff || 0), // ✅ 옵션 가격
                                    cartOptQuantity: Number(order.addQuantity || 0)  // ✅ 옵션 수량
                                });
                            }
                        }
                    });

                    // Object를 Array로 변환
                    self.groupedOrdersList = Object.values(groupedOrders).map(order => ({
                        ...order,
                        groupedDetails: Object.values(order.groupedDetails)
                    }));

                    self.groupedOrdersList = self.groupedOrdersList.slice().reverse();
                    console.log("최종 주문 목록:", self.groupedOrdersList);
                    
                    self.kind = self.groupedOrdersList.length;
                    for(let i=0; i<self.groupedOrdersList.length; i++){
                        self.paymentPrice += self.groupedOrdersList[i].totalPrice;
                        console.log("self.groupedOrdersList[i].totalPrice:" + self.groupedOrdersList[i].totalPrice);
                    }
                },

                initFlatpickr() {
                    const self = this;
                    self.datePicker = flatpickr("#deliveryDateInput", {
                        locale: "ko",

                        // 💡 핵심 1: 시간 선택 기능 활성화
                        enableTime: true,
                        // 💡 핵심 2: 시간 선택 시 캘린더가 닫히지 않도록(필수 아님)
                        closeOnSelect: false,
                        // 💡 핵심 3: 날짜와 시간을 모두 포함하는 형식 지정 (Y-m-d H:i)
                        dateFormat: "Y-m-d H:i",

                        inline: false,
                        minDate: "today",
                        disable: self.disabledDates,
                        positionElement: document.querySelector(".delivery-date-btn"),
                        onChange(selectedDates, dateStr) {
                            if (selectedDates.length > 0) {
                                self.selectedDate = dateStr;
                            }
                        },
                        onChange: function (selectedDates, dateStr, instance) {
                            if (selectedDates.length > 0) {
                                // 선택된 날짜+시간 문자열을 Vue data에 저장
                                self.selectedDate = dateStr;
                                // console.log("선택된 날짜 및 시간:", self.selectedDate);
                                // 사용자가 '확인' 버튼을 누르거나(옵션) 수동으로 닫을 수 있도록 close() 제거
                                // instance.close(); 
                            }
                        }
                    });
                },
                openCalendar() {
                    if (this.datePicker) {
                        this.datePicker.open();
                    }
                },

                //판매자가 지정한 날짜 비활성화 기능
                disableDateInfo() {
                    let self = this;
                    $.ajax({
                        url: "/product/disableDateInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: { proNo: self.proNo },
                        success: function (data) {
                            // 객체 배열 → 날짜 문자열 배열로 변환
                            self.disabledDates = Array.isArray(data.list) ?
                                data.list.map(item => item.disabledDate) : [];

                            // console.log("disabledDates:", self.disabledDates);

                            // Flatpickr 초기화 또는 기존 인스턴스에 적용
                            if (self.datePicker) {
                                self.datePicker.set('disable', self.disabledDates);
                            } else {
                                self.initFlatpickr();
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("disableDateInfo AJAX 에러:", error);
                            self.disabledDates = [];
                            if (self.datePicker) {
                                self.datePicker.set('disable', self.disabledDates);
                            } else {
                                self.initFlatpickr();
                            }
                        }
                    });
                },

                // 천 단위 콤마 찍기
                formatNumber: function (value) {
                    if (value === undefined || value === null) return '0';
                    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                },

                // ✅ 판매처별 소계 계산 함수 추가
                calculateStoreTotal: function(groupedDetails) {
                    let total = 0;
                    groupedDetails.forEach(detail => {
                        total += Number(detail.subtotal || 0);
                    });
                    return total;
                },

                // 휴대폰 번호 마스킹 처리 (010-1*3*-5*7* 형식)
                maskPhone: function(phone) {
                    if (!phone) return '';
                    // 숫자만 추출
                    const cleaned = phone.replace(/\D/g, '');
                    
                    if (cleaned.length === 11) {
                        // 010-1234-5678 형식
                        return cleaned.substring(0, 3) + '-' + 
                            cleaned[3] + '*' + cleaned[5] + '*' + '-' + 
                            cleaned[7] + '*' + cleaned[9] + '*';
                    } else if (cleaned.length === 10) {
                        // 010-123-4567 형식
                        return cleaned.substring(0, 3) + '-' + 
                            cleaned[3] + '*' + cleaned[5] + '-' + 
                            cleaned[6] + '*' + cleaned[8] + '*';
                    }
                    return phone; // 형식이 맞지 않으면 원본 반환
                },

                //상세 옵션 화면 출력 시 정렬 시키기
                getSortedOptions: function(options) {
                    if (!options || options.length === 0) return [];
                    
                    // 원본 배열을 변경하지 않도록 복사본 생성
                    return [...options].sort((a, b) => {
                        // topOpt 기준으로 오름차순 정렬
                        if (a.topOpt < b.topOpt) return -1;
                        if (a.topOpt > b.topOpt) return 1;
                        
                        // topOpt가 같으면 subOpt로 정렬
                        if (a.subOpt < b.subOpt) return -1;
                        if (a.subOpt > b.subOpt) return 1;
                        
                        return 0;
                    });
                }

                
                
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                let orderId = self.orderId.trim(); // 혹시 모를 공백 제거

                //주문번호를 장바구니에서 받지 않은 경우
                if(orderId && orderId.length > 0) {
                    console.log("orderId 값이 존재하며 orderId 값은 => " + self.orderId);
                    self.orderIdList.push(orderId);
                } 
                
                //주문번호를 장바구니에서 받는 경우
                else {
                    let str1 = "${orderIdList}";
                    self.orderIdList = JSON.parse(str1); //파싱을 해줘야 문자열을 리스트로 바꿀 수 있다.
                    
                    let str2 = "${selectItem}";
                    self.selectItem = JSON.parse(str2);
                }

                console.log("최종적으로 사용할 orderIdList 값은 => " + self.orderIdList);
                self.fnOrderList(); //주문 목록 출력
                self.fnCart(); // 장바구니 목록 가져오기

                // 옵션 등 데이터 로드 후
                setTimeout(() => {
                    self.initFlatpickr(); // 캘린더 초기화
                }, 300); // 0.3초 딜레이
            }
        });

        app.mount('#app');
    </script>
</body>
</html>