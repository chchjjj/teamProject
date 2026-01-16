    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>제품 등록 및 수정 - 디저트 연구소</title>

                <%-- JQuery, Vue, Flatpickr 라이브러리 추가 --%>
                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
                    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
                    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

                    <style>
        /* 색상 변수 정의 (두 번째 스타일 시트에서 가져옴) */
        :root {
            --espresso: #3E2723;
            --peony: #F4C9D6;
            --butter: #FFEDAC;
            --light-bg: #F4F4F4;
            --white: #FFFFFF;
            --primary-color: var(--espresso);
            --secondary-color: var(--peony);
            --accent-color: #FF5733; /* Flatpickr 날짜 강조색 유지 */
        }

        /* 기본 스타일 재정의 (폰트 및 배경) */
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            background-color: var(--light-bg);
        }

        .container {
            display: flex;
            gap: 20px;
            max-width: 1400px;
            margin: 20px auto;
        }

        /* 사이드바 스타일 (상품 등록 페이지에 맞게 재조정, 두 번째 스타일 시트의 .content-area 컨셉 반영) */
        .sidebar {
            width: 250px;
            flex-shrink: 0;
            /* 여기서는 상품 등록 페이지를 위해 간단한 레이아웃만 유지 */
        }

        .content {
            flex-grow: 1;
            background-color: var(--white);
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        }

        h2 {
            border-bottom: 2px solid var(--primary-color); /* 에스프레소 색상 적용 */
            padding-bottom: 10px;
            margin-bottom: 30px;
            color: var(--primary-color); /* 제목 색상 적용 */
        }

        /* 폼 요소 스타일 */
        .register-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex-grow: 1;
        }

        .form-group label {
            font-weight: bold;
            color: var(--primary-color); /* 라벨 색상 적용 */
            margin-bottom: 5px;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group select { /* select도 포함 */
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        
        .form-group input[type="text"]:focus,
        .form-group input[type="number"]:focus,
        .form-group select:focus {
            border-color: var(--primary-color); /* 포커스 시 에스프레소 색상 적용 */
            outline: none;
        }

        /* 이미지 섹션 스타일 */
        .image-container {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .thumbnail-box {
            width: 250px;
            height: 250px;
            background-color: var(--peony); /* 피오니 색상 적용 */
            display: flex;
            justify-content: center;
            align-items: center;
            border: 1px dashed var(--primary-color); /* 에스프레소 점선 적용 */
            flex-shrink: 0;
            color: var(--primary-color);
            font-weight: bold;
        }

        .image-upload-area {
            display: flex;
            flex-direction: column;
            gap: 15px;
            flex-grow: 1;
        }

        /* 옵션 및 카테고리 섹션 */
        .basic-info-section {
            display: flex;
            flex-direction: column;
            gap: 15px;
            flex-grow: 1;
        }

        .category-options {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        /* 옵션 추가/삭제 스타일 */
        .option-management-section {
            border: 1px solid var(--butter); /* 버터색 테두리 적용 */
            padding: 20px;
            border-radius: 4px;
            background-color: #fffaf0; /* 버터색 계열의 연한 배경색 */
        }

        .top-option-item {
            border: 1px solid var(--peony); /* 피오니색 테두리 적용 */
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            background-color: var(--white);
        }

        .top-option-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .top-option-header h4 {
            margin: 0;
            font-size: 1.1em;
            color: var(--primary-color); /* 에스프레소 색상 적용 */
        }

        .sub-option-list {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-top: 10px;
        }

        .sub-option-item {
            display: flex;
            align-items: center;
            gap: 10px;
            background-color: var(--light-bg); /* 연한 배경색 적용 */
            padding: 8px;
            border-radius: 3px;
            border: 1px solid #ddd;
        }

        /* 버튼 스타일 (두 번째 스타일 시트의 디자인 컨셉 적용) */
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 6px; /* 버튼 둥글기 증가 */
            cursor: pointer;
            font-weight: 600; /* 폰트 두께 증가 */
            transition: background-color 0.2s, box-shadow 0.2s;
        }

        .btn-primary { /* 등록/저장 버튼 */
            background-color: var(--primary-color); /* 에스프레소 배경색 */
            color: var(--white);
        }

        .btn-secondary { /* 취소 버튼 */
            background-color: var(--secondary-color); /* 피오니 배경색 */
            color: var(--primary-color); /* 에스프레소 글자색 */
            border: 1px solid var(--secondary-color);
        }

        .btn-danger { /* 삭제 버튼 */
            background-color: #dc3545;
            color: white;
        }
        
        .btn-add { /* 옵션 추가 버튼 */
            background-color: var(--butter); /* 버터색 배경색 */
            color: var(--primary-color); /* 에스프레소 글자색 */
            border: 1px solid var(--butter);
        }

        .btn-add:hover {
            background-color: #ffd852; /* 약간 어두운 버터색 */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .btn-primary:hover {
            background-color: #2a1b18; /* 약간 어두운 에스프레소 */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary:hover {
            background-color: #f0b8ca; /* 약간 어두운 피오니 */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .main-action-buttons {
            text-align: center;
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .main-action-buttons .btn {
            padding: 12px 30px;
            font-size: 1.1em;
        }

        /* Flatpickr 스타일 오버라이드 (날짜 선택기) */
        .flatpickr-calendar {
            z-index: 9999;
        }

        .flatpickr-day.selected,
        .flatpickr-day.startRange,
        .flatpickr-day.endRange,
        .flatpickr-day.selected.inRange,
        .flatpickr-day.startRange.inRange,
        .flatpickr-day.endRange.inRange {
            background: var(--accent-color); /* 판매 불가 날짜 강조색 유지 */
            border-color: var(--accent-color);
            color: white;
        }
    </style>
            </head>

            <body>
                <div class="container">
                    <%-- sellerSideBar.jsp가 여기에 인클루드됩니다. --%>

                        <main class="content" id="productRegisterApp">
                            <h2>{{ proNo ? '제품 정보 수정' : '새 제품 등록' }}</h2>

                            <form id="productForm" @submit.prevent="fnSubmitProduct">
                                <input type="hidden" name="proNo" :value="proNo">

                                <%-- 1. 이미지 업로드 섹션 --%>
                                    <div class="image-container">
                                        <div class="thumbnail-box">
                                            <img :src="thumbnailUrl || '/img/default_thumbnail.png'" alt="썸네일 이미지"
                                                style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                            <span v-if="!thumbnailUrl">썸네일</span>
                                        </div>

                                        <div class="image-upload-area">
                                            <%-- 썸네일 --%>
                                                <div class="form-row">
                                                    <label>썸네일 (필수)</label>
                                                    <input type="file" id="thumbnailFile"
                                                        @change="handleFileChange('thumbnail', $event)" accept="image/*"
                                                        required>
                                                </div>

                                                <%-- 하위 이미지 --%>
                                                    <div class="form-group">
                                                        <label>하위 이미지 (최대 5개)</label>
                                                        <input type="file" id="detailFiles"
                                                            @change="handleFileChange('detail', $event)" accept="image/*"
                                                            multiple>
                                                        <div v-if="detailFiles.length > 0">{{ detailFiles.length }}개 파일 선택됨
                                                        </div>
                                                    </div>

                                                    <%-- 롱 이미지 --%>
                                                        <div class="form-group">
                                                            <label>상세 설명 (Long 이미지)</label>
                                                            <input type="file" id="longFile"
                                                                @change="handleFileChange('long', $event)" accept="image/*">
                                                        </div>
                                        </div>
                                    </div>

                                    <%-- 2. 기본 정보 섹션 --%>
                                        <div class="basic-info-section">

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label for="proName">상품 이름</label>
                                                    <input type="text" id="proName" name="proName" v-model="product.proName"
                                                        required>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group" style="flex-grow: 1;">
                                                    <label for="proInfo">제품 설명</label>
                                                    <textarea id="proInfo" name="proInfo" v-model="product.proInfo" rows="5"
                                                        placeholder="상품의 상세 설명, 재료, 유의사항 등을 입력하세요."
                                                        style="padding: 10px; border: 1px solid #ccc; border-radius: 4px; width: 100%; box-sizing: border-box; resize: vertical;"></textarea>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group" style="width: 30%;">
                                                    <label for="price">최소 가격</label>
                                                    <input type="number" id="price" name="price"
                                                        v-model.number="product.price" required min="0">
                                                </div>

                                                <div class="form-group" style="width: 30%;">
                                                    <label for="deliveryFee">배송비</label>
                                                    <input type="number" id="deliveryFee" name="deliveryFee"
                                                        v-model.number="product.deliveryFee" required min="0">
                                                </div>
                                                <div class="form-group" style="width: 40%;">
                                                    <label>픽업/배송 불가 날짜 설정</label>
                                                    <input type="text" id="disabledDatesInput" placeholder="불가 날짜 선택 (클릭)">
                                                    <button type="button" class="btn btn-secondary"
                                                        @click="clearDisabledDates">불가 날짜 초기화</button>
                                                </div>
                                            </div>

                                            <div class="basic-info-section">
                                                <div class="category-options">
                                                    <label>카테고리:</label>
                                                    <input type="radio" id="categoryCake" value="케이크"
                                                        v-model="product.proType"><label for="categoryCake">케이크</label>
                                                    <input type="radio" id="categoryBakery" value="쿠키"
                                                        v-model="product.proType"><label for="categoryBakery">쿠키</label>
                                                    <input type="radio" id="categoryChocolate" value="초콜릿"
                                                        v-model="product.proType"><label for="categoryChocolate">초콜릿</label>


                                                    <label style="margin-left: 20px;">레터링 가능:</label>
                                                    <input type="radio" id="letteringY" value="Y"
                                                        v-model="product.lettering"><label for="letteringY">O</label>
                                                    <input type="radio" id="letteringN" value="N"
                                                        v-model="product.lettering"><label for="letteringN">X</label>
                                                </div>
                                            </div>

                                            <%-- 3. 옵션 관리 섹션 --%>
                                                <div class="option-management-section">
                                                    <h3>상품 옵션 관리</h3>

                                                    <%-- 상위 옵션 목록 --%>
                                                        <div v-for="(topOpt, topIndex) in options" :key="topOpt.id"
                                                            class="top-option-item">
                                                            <div class="top-option-header">
                                                                <h4>상위 옵션 {{ topIndex + 1 }} : {{ topOpt.optionName || "이름 없음" }}</h4>
                                                                <div>
                                                                    <label>수량 선택 가능:
                                                                        <input type="checkbox"
                                                                            v-model="topOpt.isQuantitySelectAble"
                                                                            true-value="Y" false-value="N">
                                                                    </label>
                                                                    <button type="button" class="btn btn-danger btn-sm"
                                                                        @click="removeTopOption(topIndex)">삭제</button>
                                                                </div>
                                                            </div>

                                                            <div class="form-row">
                                                                <input type="text" placeholder="상위 옵션명 (예: 케이크 크기)"
                                                                    v-model="topOpt.optionName" required
                                                                    style="flex-grow: 1;">
                                                            </div>

                                                            <%-- 하위 옵션 목록 --%>
                                                                <div class="sub-option-list">
                                                                    <div v-for="(subOpt, subIndex) in topOpt.subOptions"
                                                                        :key="subOpt.id" class="sub-option-item">
                                                                        <input type="text" placeholder="값 이름 (예: 미니)"
                                                                            v-model="subOpt.valueName" required>
                                                                        <input type="number"
                                                                            placeholder="+ 추가 금액 (0이면 추가금 없음)"
                                                                            v-model.number="subOpt.priceDiff" min="0">
                                                                        <button type="button" class="btn btn-danger"
                                                                            @click="removeSubOption(topIndex, subIndex)">삭제</button>
                                                                    </div>
                                                                </div>

                                                                <button type="button" class="btn btn-add"
                                                                    @click="addSubOption(topIndex)"
                                                                    style="margin-top: 10px;">하위 옵션 추가</button>
                                                        </div>

                                                        <%-- 옵션 추가 버튼 --%>
                                                            <button type="button" class="btn btn-add"
                                                                @click="addTopOption">상위 옵션 추가</button>
                                                            <p style="margin-top: 15px; font-size: 0.9em; color: gray;">
                                                                * 상위 옵션(예: 크기)을 추가하고, 하위 옵션(예: 미니, 1호, 2호)과 추가 금액을 설정하세요.
                                                            </p>
                                                </div>
                                        </div>

                                        <%-- 4. 등록/수정 버튼 --%>
                                            <div class="main-action-buttons">
                                                <button type="submit" class="btn btn-primary">
                                                    {{ proNo ? "제품 수정하기" : "제품 등록하기" }}
                                                </button>
                                                <button type="button" class="btn btn-secondary"
                                                    onclick="history.back()">목록으로</button>
                                            </div>
                            </form>

                        </main>
                </div>
            </body>

            </html>

            <script>
                // UUID 또는 임시 ID를 생성하는 유틸리티 함수
                let nextTopOptionId = 1;
                let nextSubOptionId = 1;

                // Vue 앱 초기화
                const app = Vue.createApp({
                    data() {
                        // JSP EL이 비어있으면 ''로, 아니면 실제 값으로 설정 (수정 모드 대비)
                        const proNoFromJSP = "${proNo}" === "" ? null : parseInt("${proNo}");
                        // 🌟 Controller에서 Model로 주입한 storeId 값을 받습니다.
                        const storeIdFromJSP = "${storeId}" === "" ? null : parseInt("${storeId}");

                        return {
                            proNo: proNoFromJSP, // 제품 번호 (null이면 등록 모드, 값이 있으면 수정 모드)
                            userId: "${sessionId}",
                            storeId: storeIdFromJSP,// 👈 Vue 데이터로 storeId 정의 (console 확인용)

                            // 폼 데이터 모델
                            product: {
                                userId: "${sessionId}",
                                storeId: storeIdFromJSP, // 👈 상품 정보(product)에도 storeId 추가 (서버 전송용)
                                proName: '',
                                price: 0,
                                deliveryFee: 0,
                                proType: '케이크', // 기본값 "케이크"
                                lettering: 'N',   // 기본값
                                proInfo: '',

                            },

                            // 이미지 파일 관리 (서버 전송용)
                            thumbnailFile: null,
                            detailFiles: [],
                            longFile: null,
                            thumbnailUrl: null, // 미리보기 URL

                            // 옵션 데이터 구조 (화면 관리 및 서버 전송용)
                            options: [], // [{ id, optionName, isQuantitySelectAble, subOptions: [{ id, valueName, priceDiff }] }]

                            // Flatpickr 관련
                            disabledDates: [], // 저장된 불가 날짜 (DB에서 로드될 예정)
                            datePicker: null,
                        };
                    },
                    methods: {
                        // ************ 파일 핸들링 ************
                        handleFileChange(type, event) {
                            const files = event.target.files;
                            if (!files || files.length === 0) return;

                            if (type === 'thumbnail') {
                                this.thumbnailFile = files[0];
                                // 미리보기
                                this.thumbnailUrl = URL.createObjectURL(files[0]);
                            } else if (type === 'detail') {
                                // 최대 5개 제한
                                this.detailFiles = Array.from(files).slice(0, 5);
                            } else if (type === 'long') {
                                this.longFile = files[0];
                            }
                        },

                        // ************ 옵션 관리 ************
                        addTopOption() {
                            this.options.push({
                                id: 'new-' + nextTopOptionId++,
                                optionName: '',
                                isQuantitySelectAble: 'N',
                                subOptions: []
                            });
                        },
                        removeTopOption(index) {
                            if (confirm('상위 옵션을 삭제하시겠습니까? 해당 하위 옵션도 모두 삭제됩니다.')) {
                                this.options.splice(index, 1);
                            }
                        },
                        addSubOption(topIndex) {
                            this.options[topIndex].subOptions.push({
                                id: 'new-' + nextSubOptionId++,
                                valueName: '',
                                priceDiff: 0
                            });
                        },
                        removeSubOption(topIndex, subIndex) {
                            this.options[topIndex].subOptions.splice(subIndex, 1);
                        },

                        // ************ Flatpickr (픽업 불가 날짜) ************
                        initFlatpickr() {
                            const self = this;
                            // Flatpickr 초기화 시 'range' 모드와 'multiple' 모드를 함께 사용하여 범위/개별 날짜를 모두 선택 가능하게 합니다.
                            self.datePicker = flatpickr("#disabledDatesInput", {
                                locale: "ko",
                                mode: "multiple", // 여러 날짜를 개별적으로 선택 가능
                                enableTime: false,
                                dateFormat: "Y-m-d",
                                minDate: "today",
                                // DB에서 로드된 disabledDates 배열을 사용하도록 설정
                                defaultDate: self.disabledDates.map(date => {
                                    // DB 데이터가 범위(객체)인 경우와 개별 날짜(문자열)인 경우를 모두 처리해야 함.
                                    return typeof date === 'string' ? date : [date.from, date.to];
                                }),

                                onChange: function (selectedDates, dateStr, instance) {
                                    // 선택된 날짜 문자열 배열을 disabledDates 배열에 저장
                                    self.disabledDates = selectedDates.map(d => flatpickr.formatDate(d, "Y-m-d"));
                                    //console.log("선택된 불가 날짜:", self.disabledDates);
                                    // 이 배열을 서버에 저장할 문자열로 변환해야 합니다. (예: 2025-11-01,2025-11-05)
                                    // Note: 범위 선택 모드(range)를 사용하면 이 로직이 더 복잡해지므로, Simple 'multiple'이 권장됩니다.
                                },
                                // disable 옵션은 초기화 시에만 적용되므로, 실제 서버 전송 시에는 disabledDates 배열을 활용합니다.
                            });
                        },
                        clearDisabledDates() {
                            if (this.datePicker) {
                                this.datePicker.clear(); // 달력에서 선택된 날짜를 지웁니다.
                            }
                            this.disabledDates = []; // Vue 데이터도 초기화
                        },


                        // ************ 서버 전송 (등록/수정) ************
                        fnSubmitProduct() {
                            // ... (유효성 검사 등 기존 로직) ...

                            const formData = new FormData();

                            // 1. 기본 상품 정보 추가 (기존 코드)
                            for (const key in this.product) {
                                formData.append(key, this.product[key]);
                            }
                            if (this.proNo) formData.append('proNo', this.proNo);

                            // 🚨🚨🚨 파일 객체를 FormData에 추가하는 핵심 수정 부분 🚨🚨🚨

                            // 2. 썸네일 파일 추가 (서버에서 'thumbnailFile'이라는 이름으로 받음)
                            if (this.thumbnailFile) {
                                // 서버에서 요구하는 파트 이름 'thumbnailFile'을 정확히 사용
                                formData.append('thumbnailFile', this.thumbnailFile);
                            }

                            // 3. 하위 이미지 파일들 추가 (multiple 파일)
                            this.detailFiles.forEach((file, index) => {
                                // 서버에서 배열로 받을 수 있도록 같은 이름으로 반복 추가
                                formData.append('detailFiles', file);
                            });

                            // 4. 롱 이미지 파일 추가
                            if (this.longFile) {
                                formData.append('longFile', this.longFile);
                            }

                            // 5. 옵션 및 날짜 정보 추가 (기존 코드)
                            const optionsJson = JSON.stringify(this.options);
                            formData.append('optionsJson', optionsJson);
                            formData.append('disabledDatesStr', this.disabledDates.join(','));

                            

                            $.ajax({
                                url: "/seller/product/register.dox",
                                type: "POST",
                                data: formData,
                                processData: false,
                                contentType: false,
                                success: (response) => {
                                    if (response.success) {
                                        alert(this.proNo ? "제품 정보 수정 완료" : "제품 등록 완료");
                                        location.href = "/seller/productlist.do";
                                    } else {
                                        alert("실패: " + (response.message || "알 수 없는 오류"));
                                    }
                                },
                                error: (xhr, status, error) => {
                                    alert("서버 통신 오류: " + error);
                                }
                            });
                        }, loadProductDataForEdit() {
                            const self = this;
                            // proNo는 이미 data()에서 설정되어 있으므로 사용 가능
                            $.ajax({
                                url: '/seller/product/loadForEdit.dox', // 서버에서 단일 제품 및 옵션 정보를 가져오는 엔드포인트
                                type: 'GET',
                                data: { proNo: self.proNo },
                                success: (response) => {
                                    if (response.success && response.data) {
                                        // 1. 기본 상품 정보 로드
                                        const loadedProduct = response.data.product;
                                        self.product = {
                                            ...self.product, // 기존 storeId, userId 유지
                                            proName: loadedProduct.proName || loadedProduct.PRO_NAME,
                                            price: loadedProduct.price || loadedProduct.PRICE || 0,
                                            deliveryFee: loadedProduct.deliveryFee || loadedProduct.DELIVERY_FEE || 0,
                                            proType: loadedProduct.proType || loadedProduct.PRO_TYPE,
                                            lettering: loadedProduct.lettering || loadedProduct.LETTERING,
                                            proInfo: loadedProduct.proInfo || loadedProduct.PRO_INFO || '',
                                        };

                                        // 2. 이미지 정보 로드 및 미리보기 설정 (주요)
                                        self.thumbnailUrl = loadedProduct.thumbnailPath || loadedProduct.THUMBNAIL_PATH;
                                        // 수정 모드에서는 파일 객체 대신 경로를 저장해야 합니다. (기존 이미지 유지 로직 구현 시 필요)
                                        self.existingDetailImages = loadedProduct.detailImagePaths || loadedProduct.DETAIL_IMAGE_PATHS || [];
                                        self.existingLongImage = loadedProduct.longImagePath || loadedProduct.LONG_IMAGE_PATH;

                                        // 3. 옵션 정보 로드 및 Vue 형식으로 변환 (그룹화 로직 필요)
                                        // 서버에서 가져온 옵션 리스트(response.data.options)를 Vue 구조에 맞게 그룹화하여 self.options에 할당해야 합니다.
                                        // (이전 대화에서 논의된 복잡한 그룹화 로직이 서버에서 처리되어야 합니다.)

                                        // 4. 불가 날짜 로드
                                        self.disabledDates = response.data.disabledDatesStr ? response.data.disabledDatesStr.split(',') : [];
                                        self.initFlatpickr(); // 날짜 로드 후 캘린더를 다시 초기화

                                        //console.log("제품 데이터 로드 완료:", self.product);
                                    } else {
                                        alert('제품 정보를 불러오는데 실패했습니다.');
                                    }
                                },
                                error: (xhr) => {
                                    console.error('제품 로드 AJAX 오류:', xhr);
                                    alert('제품 정보를 불러오는 중 통신 오류가 발생했습니다.');
                                }
                            });
                        },


                    },
                    mounted() {
                        // Flatpickr 초기화
                        this.initFlatpickr();
                        //console.log("현재 userId:", this.userId);
                        //console.log("현재 storeId:", this.storeId); // 🌟 storeId가 정상적으로 출력되는지 확인하세요.
                        // 수정 모드인 경우 데이터 로드
                        if (this.proNo) {
                            this.loadProductDataForEdit();
                        }
                    }
                });

                app.mount('#productRegisterApp');
            </script>