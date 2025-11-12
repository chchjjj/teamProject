<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>제품상세</title>
        <link rel="stylesheet" href="/css/productDetail-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
        <!--페이지 이동-->
        <script src="/js/page-change.js"></script>
        <style>
            .date-input {
                display: none;
            }

            /* 픽업/배송 날짜 버튼이 선택된 날짜를 표시할 수 있도록 스타일 조정 */
            .delivery-date-btn.selected {
                background-color: #4CAF50;
                /* 선택 완료 시 색상 변경 */
                color: white;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">

                <div class="product-detail-container">
                    <main class="product-detail-page">
                        <div class="product-info-area">

                            <div class="image-section">
                                <div class="main-image-box">
                                    <div v-if="!infoList.filePath || !infoList.fileName">
                                        판매자 등록 썸네일
                                    </div>
                                    <img v-else :src="(infoList.filePath + infoList.fileName).trim()" alt="상품 이미지"
                                        class="product-image" style="width: 100%; height: auto; border-radius: 10px;">
                                </div>

                            </div>

                            <div class="option-section">
                                <h2 class="product-name">{{infoList.proName}}</h2>
                                <p class="store-name" @click="fnSeller(infoList.storeId)">{{infoList.storeName}}</p>
                                <div>{{infoList.proInfo}}</div>
                                <div class="price-and-action">
                                    <p class="price">{{infoList.price}} 원~</p>
                                    <br>
                                    <p class="shipping-fee">배송비(포장비) {{infoList.deliveryFee}} </p>

                                    <span v-if="isWished">
                                        <img src="/img/좋아요누른후.png" alt="찜 완료" @click="fnwish" class="wish-icon">
                                    </span>
                                    <span v-else class="like">
                                        <img src="/img/좋아요누르기전.png" alt="찜하기" @click="fnwish" class="wish-icon">
                                    </span>

                                </div>
                                <div class="delivery-type-radios" style="margin-bottom: 10px;">

                                    <label :class="{ 'disabled-label': infoList.deliveryYn === 'N' }">
                                        <input type="radio" v-model="deliveryType" value="D"
                                            :disabled="infoList.deliveryYn === 'N'"> 배송
                                    </label>
                                    <span v-if="infoList.deliveryYn === 'N'" class="delivery-yn-info">
                                        (배송 불가 상품)
                                    </span>
                                    <label>
                                        <input type="radio" v-model="deliveryType" value="P"> 픽업(장바구니에 담을시 날짜선택은 최종
                                        결제단계에서 진행됩니다.)
                                    </label>
                                </div>
                                <div class="delivery-date-selection">
                                    <input type="text" id="deliveryDateInput" class="date-input">
                                    <button class="delivery-date-btn" @click="openCalendar">
                                        {{ selectedDateDisplay }}
                                    </button>

                                </div>

                                <div class="option-selectors">
                                    <div class="option-item" v-for="topOption in groupedOptions"
                                        :key="topOption.topOptionId">

                                        <select v-model="selectedOptions[topOption.topOptionId]" class="form-select">

                                            <option :value="null" disabled selected>
                                                :: {{topOption.optionName}} ::
                                            </option>

                                            <option v-for="subOption in topOption.subOptions"
                                                :key="subOption.subOptionId" :value="subOption">

                                                {{ subOption.valueName }}
                                                <template v-if="subOption.priceDiff > 0">
                                                    (+ {{ subOption.priceDiff.toLocaleString() }}원)
                                                </template>
                                            </option>
                                        </select>

                                        <div class="quantity-selector" v-if="topOption.isQuantitySelectAble === 'Y'">
                                            <button @click="decreaseQuantity(topOption.topOptionId)"> &lt; </button>
                                            <div class="quantity-display">
                                                {{ selectedQuantities[topOption.topOptionId] || 1 }}
                                            </div>
                                            <button @click="increaseQuantity(topOption.topOptionId)"> &gt; </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="lettering-input-area" v-if="infoList.lettering === 'Y'">
                                    <label>문구:<input v-model="letteringText" placeholder="레터링 문구를 입력하세요."></label>
                                </div>
                                <div class="chat-selection-area" v-if="infoList.isChatEnabled === 'Y'">
                                    <label style="display: block; margin-bottom: 10px; font-weight: bold;">
                                        채팅 상담 신청
                                    </label>
                                    <div class="chat-toggle-buttons">
                                        <button :class="{ 'selected': isChatRequested === 'Y' }"
                                            @click="isChatRequested = 'Y'">
                                            채팅 신청 (추가금액 발생 가능)
                                        </button>
                                        <button :class="{ 'selected': isChatRequested === 'N' }"
                                            @click="isChatRequested = 'N'">
                                            채팅 필요 X
                                        </button>
                                    </div>
                                </div>
                                <div class="total-price-display">
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <p>총 금액: <strong>{{ totalPrice.toLocaleString() }}</strong> 원</p>

                                        <!--  전체 수량 조절 버튼 -->
                                        <div class="quantity-selector">
                                            <button @click="decreaseTotalQuantity"> &lt; </button>
                                            <div class="quantity-display">{{ totalQuantity }}</div>
                                            <button @click="increaseTotalQuantity"> &gt; </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="action-buttons">
                                    <button class="buy-btn" @click="fnBuy">구매</button>
                                    <button class="cart" @click="fnCart">장바구니</button>
                                </div>
                            </div>
                        </div>

                    </main>
                </div>

            </div>
            <%@ include file="/WEB-INF/product/productDetail-tab.jsp" %>
                <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    proNo: "${proNo}",
                    userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                    userInfo: {},
                    infoList: {},
                    topList: [],
                    allOptList: [],
                    isChatRequested: 'N',

                    // 1. **핵심**: 화면 출력을 위한 그룹화된 옵션 목록
                    groupedOptions: [],

                    // 2. 선택된 옵션 상태를 저장할 객체
                    selectedOptions: {},

                    // 💡 3. 새로 추가: 선택된 수량을 저장할 객체
                    selectedQuantities: {},

                    // 💡 날짜 선택 관련 data 추가
                    selectedDate: null,
                    datePicker: null,

                    // 판매자가 막은 날짜
                    disabledDates: [
                    ],
                    letteringText: "",
                    // 전체 상품 수량
                    totalQuantity: 1,

                    isWished: '',
                    deliveryType: 'P'
                };
            },
            computed: {
                // 💡 계산된 속성: 버튼에 표시될 텍스트 (날짜와 시간이 포함되도록 문구 수정)
                selectedDateDisplay() {
                    if (this.selectedDate) {
                        return this.selectedDate + ' (변경)';
                    }
                    return '픽업/배송 날짜 및 시간 선택';
                },
                // ✅ 총 금액 계산
                totalPrice() {
                    let total = 0;

                    // 1️⃣ 기본 상품 가격
                    if (this.infoList.price) {
                        total += Number(this.infoList.price);
                    }

                    // 2️⃣ 선택한 옵션 가격들
                    for (const [topId, subOption] of Object.entries(this.selectedOptions)) {
                        if (subOption && subOption.priceDiff !== undefined) {
                            const qty = this.selectedQuantities[topId] || 1;
                            total += subOption.priceDiff * qty;
                        }
                    }

                    // 3️⃣ 전체 수량 적용
                    total *= this.totalQuantity;

                    // 4️⃣ 🚚 배송비 추가 (배송 유형이 'DELIVERY'이고, 배송비 정보가 있을 경우)
                    if (this.deliveryType === 'D' && this.infoList.deliveryFee !== undefined && this.infoList.deliveryFee !== null) {
                        // 'DELIVERY' 대신 'D'로 변경
                        // 배송비는 전체 수량에 곱하지 않고 한 번만 추가됩니다.
                        total += Number(this.infoList.deliveryFee);
                    }
                    return total;
                }
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnBuy: function (proNo) {
                    let self = this;
                    //유효성 검사
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                        return;
                    }
                    if (!self.fnCheckRequiredSelections()) {
                        return; // 필수 옵션 미선택 시 함수 종료
                    }
                    // 2선택 옵션 그룹화
                    let subOptionList = [];
                    for (const [topId, subOption] of Object.entries(self.selectedOptions)) {
                        if (subOption && subOption.subOptionId) {
                            const quantity = self.selectedQuantities[topId] || 1;
                            subOptionList.push({
                                topOptionId: topId,
                                subOptionId: subOption.subOptionId,
                                quantity: quantity,
                                priceDiff: subOption.priceDiff
                            });
                        }
                    }
                    subOptionList = JSON.stringify(subOptionList);
                    let finalDeliveryFee = 0;
                    if (self.deliveryType === 'D') {
                        // 'D' (배송)일 경우에만 실제 배송비를 사용합니다.
                        finalDeliveryFee = self.infoList.deliveryFee;
                    }
                    if (self.isChatRequested === 'Y') { // 채팅신청한 경우
                        alert("채팅방이 개설되었습니다. 마이페이지에서 확인해주세요.")
                        let param = {
                            chatYn: 'Y',
                            userId: self.userId,
                            proNo: self.proNo,
                            storeId: self.infoList.storeId,
                            orderQuantity: self.totalQuantity,
                            totalPrice: self.totalPrice,
                            totalQuantity: self.totalQuantity,
                            deliveryType: self.deliveryType,
                            letteringWord: self.letteringText,
                            isChatRequested: self.isChatRequested,
                            subOptionList: subOptionList, // 옵션 리스트
                            storeName: self.infoList.storeName, // ORDER_TBL에 저장
                            deliveryFee: finalDeliveryFee, // ORDER_TBL에 저장
                            productPrice: self.infoList.price, // 상품 단가 정보
                            proName: self.infoList.proName,

                            // 배송 테이블에 넣을 것
                            userName: self.userInfo.userName,
                            phone: self.userInfo.phone,
                            address: self.userInfo.address,
                            deliveryDate: self.selectedDate,

                            // 픽업 테이블에 넣을 것
                            storeAddr: self.infoList.storeAddr,

                            subtotal : (self.totalPrice - finalDeliveryFee) // 배송비 제외금액
                        };
                        // console.log("주문 데이터:", param);
                        $.ajax({
                            url: "/product/orderInsert.dox", // 서버 주문 처리 URL
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                if (data.result === "success") {
                                    // alert("주문이 완료되었습니다!");
                                    // 결제 페이지로 이동 또는 주문 완료 페이지 이동
                                    // pageChange("/order/complete.do", { orderId: data.orderId });
                                } else {
                                    alert("주문 처리 중 오류가 발생했습니다.");
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("주문 AJAX 에러:", status, error);
                            }
                        });

                    } else { // 채팅신청 안한 경우
                        let param = {
                            chatYn: 'N',
                            userId: self.userId,
                            proNo: self.proNo,
                            storeId: self.infoList.storeId,
                            orderQuantity: self.totalQuantity,
                            totalPrice: self.totalPrice,
                            totalQuantity: self.totalQuantity,
                            deliveryType: self.deliveryType,
                            deliveryDate: self.selectedDate,
                            letteringWord: self.letteringText,
                            isChatRequested: self.isChatRequested,
                            subOptionList: subOptionList, // 옵션 리스트
                            storeName: self.infoList.storeName, // ORDER_TBL에 저장
                            deliveryFee: finalDeliveryFee, // ORDER_TBL에 저장
                            productPrice: self.infoList.price, // 상품 단가 정보
                            proName: self.infoList.proName,

                            // 배송 테이블에 넣을 것
                            userName: self.userInfo.userName,
                            phone: self.userInfo.phone,
                            address: self.userInfo.userAddr,

                            // 픽업 테이블에 넣을 것
                            storeAddr: self.infoList.storeAddr,


                            deliveryDate: self.selectedDate,

                            subtotal : (self.totalPrice - finalDeliveryFee) // 배송비 제외금액
                        };
                        // console.log("주문 데이터:", param);
                        $.ajax({
                            url: "/product/orderInsert.dox", // 서버 주문 처리 URL
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                if (data.result === "success") {
                                    alert("결제페이지로 넘어갑니다. 결제를 바로 진행하지 않으셔도, 마이페이지에서 언제든지 구매하실 수 있습니다.");
                                    // alert(data.orderId);
                                    pageChange("/payment/payment.do", { orderId: data.orderId });
                                    // if (self.deliveryType === 'D') {
                                    //     pageChange("/payment/deliveryPayment.do", { orderId: data.orderId });
                                    // } else if (self.deliveryType === 'P') {
                                    //     pageChange("/payment/pickUpPayment.do", { orderId: data.orderId });
                                    // }

                                } else {
                                    alert("주문 처리 중 오류가 발생했습니다.");
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("주문 AJAX 에러:", status, error);
                            }
                        });


                    }

                },
                fnInfo: function () {
                    let self = this;
                    let param = {
                        proNo: self.proNo
                    };
                    $.ajax({
                        url: "/product/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                            self.infoList = data.info;

                        }
                    });
                },
                fnTopOpt: function () {
                    let self = this;
                    let param = {
                        proNo: self.proNo
                    };
                    $.ajax({
                        url: "/product/TopOptlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // console.log(data.list);
                            self.topList = data.list;

                        }
                    });
                },
                fnAllOpt: function () {
                    let self = this;
                    let param = {
                        proNo: self.proNo
                    };
                    $.ajax({
                        url: "/product/AllOptlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                            self.allOptList = data.list;
                        }
                    });
                },
                // 옵션 선택 유효성 검사 함수
                fnCheckRequiredSelections: function () {
                    let self = this;

                    // 1. 모든 상위 옵션에 대해 선택된 하위 옵션이 있는지 확인
                    const allOptionsSelected = self.groupedOptions.every(topOption => {
                        // topOptionId를 키로 selectedOptions 객체에서 값을 확인
                        return self.selectedOptions[topOption.topOptionId] !== null;
                    });

                    if (!allOptionsSelected) {
                        alert("모든 필수 옵션을 선택해 주세요.");
                        return false;
                    }

                    // 2. 픽업/배송 날짜 선택 여부 확인
                    if (!self.selectedDate) {
                        alert("픽업/배송 날짜 및 시간을 선택해 주세요.");
                        return false;
                    }

                    // 모든 검사 통과
                    return true;
                },
                // 장바구니 옵션 선택 유효성 검사 함수
                fnCheckRequiredSelectionsCart: function () {
                    let self = this;

                    // 1. 모든 상위 옵션에 대해 선택된 하위 옵션이 있는지 확인
                    const allOptionsSelected = self.groupedOptions.every(topOption => {
                        // topOptionId를 키로 selectedOptions 객체에서 값을 확인
                        return self.selectedOptions[topOption.topOptionId] !== null;
                    });

                    if (!allOptionsSelected) {
                        alert("모든 필수 옵션을 선택해 주세요.");
                        return false;
                    }

                    // 모든 검사 통과
                    return true;
                },
                // 전체 수량 조절
                increaseTotalQuantity() {
                    this.totalQuantity++;
                },
                decreaseTotalQuantity() {
                    if (this.totalQuantity > 1) this.totalQuantity--;
                },
                fnCart: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                        return;
                    }
                    // 하위 옵션 선택 내역 수집
                    //유효성 검사
                    if (!self.fnCheckRequiredSelectionsCart()) {
                        return; // 필수 옵션 미선택 시 함수 종료
                    }
                    let subOptionList = [];

                    for (const [topId, subOption] of Object.entries(self.selectedOptions)) {
                        if (subOption && subOption.subOptionId) {
                            const quantity = self.selectedQuantities[topId] || 1;
                            subOptionList.push({
                                subOptionId: subOption.subOptionId,
                                cartOptQuantity: quantity,
                                priceDiff: subOption.priceDiff
                            });
                        }
                    }
                    subOptionList = JSON.stringify(subOptionList); // 백앤드로 리스트를 넘기는게 안되므로 리스트를 제이슨형태로 변환 후 파람으로 넘겨줘야함
                    let finalDeliveryFee = 0;
                    if (self.deliveryType === 'D') {
                        // 'D' (배송)일 경우에만 실제 배송비를 사용합니다.
                        finalDeliveryFee = self.infoList.deliveryFee;
                    }
                    if (self.isChatRequested === 'Y') {
                        let param = {
                            chatYn: 'Y',
                            userId: self.userId,
                            proNo: self.proNo,
                            storeId: self.infoList.storeId,
                            cartQuantity: self.totalQuantity,
                            totalPrice: self.totalPrice,
                            letteringText: self.letteringText,
                            subOptionList: subOptionList, // 옵션 리스트
                            isChatRequested: self.isChatRequested, // 채팅여부
                            deliveryFee: finalDeliveryFee, //배송비
                            deliveryType: self.deliveryType, // 픽업 배송
                            // 배송 테이블에 넣을 것
                            userName: self.userInfo.userName,
                            phone: self.userInfo.phone,
                            address: self.userInfo.address,
                            deliveryDate: self.selectedDate,

                            // 픽업 테이블에 넣을 것
                            storeAddr: self.infoList.storeAddr,
                        };
                        // console.log("장바구니 전송 데이터:", param);
                        // console.log("subOptionList", subOptionList);
                        $.ajax({
                            url: "/product/cartInsert.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert("장바구니에 추가되었습니다.")
                            }
                        });
                    } else {
                        let param = {
                            chatYn: 'N',
                            userId: self.userId,
                            proNo: self.proNo,
                            storeId: self.infoList.storeId,
                            cartQuantity: self.totalQuantity,
                            totalPrice: self.totalPrice,
                            letteringText: self.letteringText,
                            subOptionList: subOptionList, // 옵션 리스트
                            isChatRequested: self.isChatRequested, // 채팅여부
                            deliveryFee: finalDeliveryFee, //배송비
                            deliveryType: self.deliveryType, // 픽업 배송

                            // 배송 테이블에 넣을 것
                            userName: self.userInfo.userName,
                            phone: self.userInfo.phone,
                            address: self.userInfo.address,
                            deliveryDate: self.selectedDate,

                            // 픽업 테이블에 넣을 것
                            storeAddr: self.infoList.storeAddr,
                        };
                        // console.log("장바구니 전송 데이터:", param);
                        // console.log("subOptionList", subOptionList);
                        $.ajax({
                            url: "/product/cartInsert.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert("장바구니에 추가되었습니다.")
                            }
                        });
                    }
                },
                // 그룹화 함수
                groupOptions() {
                    const grouped = new Map();

                    this.allOptList.forEach(item => {
                        const topId = item.topOptionId;

                        // Map에 해당 상위 옵션이 없으면 새로운 그룹을 생성
                        if (!grouped.has(topId)) {
                            grouped.set(topId, {
                                topOptionId: topId,
                                optionName: item.optionName,
                                isQuantitySelectAble: item.isQuantitySelectAble,
                                subOptions: []
                            });

                            // 사용자의 선택 상태 초기화
                            this.selectedOptions[topId] = null;
                        }

                        // 하위 옵션(값)을 해당 그룹에 추가
                        if (item.subOptionId) {
                            grouped.get(topId).subOptions.push({
                                subOptionId: item.subOptionId,
                                valueName: item.valueName,
                                priceDiff: item.priceDiff
                            });
                        }
                    });

                    // Map의 값을 배열로 변환하여 화면 출력용 데이터에 저장
                    this.groupedOptions = Array.from(grouped.values());
                    // console.log("옵션 그룹화 완료:", this.groupedOptions);
                },
                // 수량 조절 함수
                increaseQuantity(topOptionId) {
                    // 초기값이 없을 경우 1로 설정, 있을 경우 1 증가
                    let currentQty = this.selectedQuantities[topOptionId] || 1;
                    this.selectedQuantities[topOptionId] = currentQty + 1;
                },
                decreaseQuantity(topOptionId) {
                    let currentQty = this.selectedQuantities[topOptionId] || 1;
                    // 최소 수량은 1
                    if (currentQty > 1) {
                        this.selectedQuantities[topOptionId] = currentQty - 1;
                    }
                },
                // 캘린더 관련 메소드
                // 💡 Flatpickr 초기화 및 연결 메서드
                initFlatpickr() {
                    const self = this;
                    self.datePicker = flatpickr("#deliveryDateInput", {
                        locale: "ko",

                        //  1: 시간 선택 기능 활성화
                        enableTime: true,
                        //  2: 시간 선택 시 캘린더가 닫히지 않도록(필수 아님)
                        closeOnSelect: false,
                        //  3: 날짜와 시간을 모두 포함하는 형식 지정 (Y-m-d H:i)
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

                // 💡 버튼 클릭 시 달력 열기 메서드
                openCalendar() {
                    if (this.datePicker) {
                        this.datePicker.open();
                    }
                },
                fnCheckWish: function () { // 찜 여부 확인
                    let self = this;
                    $.ajax({
                        url: "/product/checkWishlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: self.userId, proNo: self.proNo },
                        success: function (data) {
                            self.isWished = data.isWished; // true or false

                        }
                    });
                },
                fnwish: function () {
                    let self = this;
                    if (self.userId == "" || self.userId == null) {
                        alert("로그인 후 이용해주세요!");
                        location.href = "/user/login.do"; // 로그인 페이지 이동
                        return;
                    }
                    if (self.isWished) {
                        let param = {
                            userId: self.userId,
                            proNo: self.proNo
                        };
                        $.ajax({
                            url: "/product/WishlistDel.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert("찜 목록에서 제거되었습니다.");
                                location.reload();
                            }
                        });
                    }
                    else {
                        let param = {
                            userId: self.userId,
                            proNo: self.proNo
                        };
                        $.ajax({
                            url: "/product/WishlistAdd.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert("찜 목록에서 추가되었습니다.");
                                location.reload();
                            }
                        });
                    }
                },
                fnUserInfo: function () {
                    let self = this;
                    let param = {
                        userId: "${sessionId}",
                    };
                    $.ajax({
                        url: "/product/userInfo.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                            self.userInfo = data.info;
                        }
                    });
                },
                fnSeller: function (storeId) {
                    let self = this;
                    pageChange("/product/sellerStore.do", { storeId: storeId });
                }


            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                // console.log(self.proNo)
                self.fnInfo();
                self.fnTopOpt();
                self.fnAllOpt();
                self.fnCheckWish();
                self.fnUserInfo();

                // 임시로, 모든 데이터가 로드될 시간을 주고 그룹화 함수 실행 (비동기 이슈 발생 가능)
                setTimeout(() => {
                    self.groupOptions();
                    // 💡 옵션 그룹화 후, 수량 초기값 설정 (모든 수량 선택 가능 옵션에 1로 초기화)
                    self.groupedOptions.forEach(opt => {
                        if (opt.isQuantitySelectAble === 'Y') {
                            self.selectedQuantities[opt.topOptionId] = 1;
                        }
                    });
                    // 💡 Flatpickr 초기화 호출
                    self.initFlatpickr();
                }, 300); // 0.5초 대기 후 그룹화

                self.disableDateInfo();
            }
        });

        app.mount('#app');
    </script>