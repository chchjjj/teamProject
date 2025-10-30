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
                                <div class="main-image-box">제품 이미지</div>
                                <div class="thumbnail-list">
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                </div>
                            </div>

                            <div class="option-section">
                                <h2 class="product-name">{{infoList.proName}}</h2>
                                <p class="store-name">{{infoList.storeName}}</p>
                                <div>{{infoList.proInfo}}</div>
                                <div class="price-and-action">
                                    <p class="price">{{infoList.price}} 원~</p>
                                    <br>
                                    <p class="shipping-fee">배송비 {{infoList.deliveryFee}}</p>
                                    <img src="/img/좋아요누르기전.png" alt="찜 목록"></a>
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

                                        <select v-model="selectedOptions[topOption.topOptionId]" class="form-select"
                                            @change="handleOptionChange(topOption.topOptionId)">

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
                                    <label>문구:<input placeholder="레터링 문구를 입력하세요."></label>
                                </div>

                                <div class="action-buttons">
                                    <button class="buy-btn">구매</button>
                                    <button class="cart">장바구니</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-menu">
                            <button class="tab-btn active">상세정보</button>
                            <button class="tab-btn">리뷰</button>
                            <button class="tab-btn">QnA</button>
                        </div>

                        <div class="tab-content">
                        </div>
                    </main>
                </div>

            </div>
            <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    proNo: "${proNo}",
                    infoList: {},
                    topList: [],
                    allOptList: [],

                    // 1. **핵심**: 화면 출력을 위한 그룹화된 옵션 목록
                    groupedOptions: [],

                    // 2. 선택된 옵션 상태를 저장할 객체
                    selectedOptions: {},

                    // 💡 3. 새로 추가: 선택된 수량을 저장할 객체
                    selectedQuantities: {},

                    // 💡 날짜 선택 관련 data 추가
                    selectedDate: null,
                    datePicker: null,

                    // 💡 [수정] 오류의 원인: Flatpickr disable 옵션에서 참조하는 변수 추가
                    disabledDates: [
                        "2025-11-01", 
                        "2025-11-05", 
                        {
                            from: "2025-11-10", 
                            to: "2025-11-15"
                        }
                    ] 
                };
            },
            computed: {
                // 💡 계산된 속성: 버튼에 표시될 텍스트 (날짜와 시간이 포함되도록 문구 수정)
                selectedDateDisplay() {
                    if (this.selectedDate) {
                        return this.selectedDate + ' (변경)';
                    }
                    return '픽업/배송 날짜 및 시간 선택';
                }
            },
            methods: {
                // 함수(메소드) - (key : function())
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
                            console.log(data.info);
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
                            console.log(data.list);
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
                            console.log(data.list);
                            self.allOptList = data.list;
                        }
                    });
                },
                // **새로 추가할 그룹화 함수**
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
                    console.log("옵션 그룹화 완료:", this.groupedOptions);
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

                        // 💡 핵심 1: 시간 선택 기능 활성화
                        enableTime: true,
                        // 💡 핵심 2: 시간 선택 시 캘린더가 닫히지 않도록(필수 아님)
                        closeOnSelect: false,
                        // 💡 핵심 3: 날짜와 시간을 모두 포함하는 형식 지정 (Y-m-d H:i)
                        dateFormat: "Y-m-d H:i",

                        inline: false,
                        minDate: "today",
                        disable: self.disabledDates,

                        onChange: function (selectedDates, dateStr, instance) {
                            if (selectedDates.length > 0) {
                                // 선택된 날짜+시간 문자열을 Vue data에 저장
                                self.selectedDate = dateStr;
                                console.log("선택된 날짜 및 시간:", self.selectedDate);
                                // 사용자가 '확인' 버튼을 누르거나(옵션) 수동으로 닫을 수 있도록 close() 제거
                                // instance.close(); 
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
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                console.log(self.proNo)
                self.fnInfo();
                self.fnTopOpt();
                self.fnAllOpt();

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
            }
        });

        app.mount('#app');
    </script>