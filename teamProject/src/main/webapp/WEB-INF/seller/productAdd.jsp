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
        /* 기본 스타일 초기화 */
        body { font-family: 'Malgun Gothic', '맑은 고딕', sans-serif; background-color: #f4f4f4; }
        .container { display: flex; gap: 20px; max-width: 1400px; margin: 20px auto; }
        .sidebar { width: 250px; flex-shrink: 0; }
        .content { flex-grow: 1; background-color: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.05); }

        h2 { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 30px; }
        
        /* 메인 폼 레이아웃 */
        .register-form { display: flex; flex-direction: column; gap: 20px; }
        .form-row { display: flex; align-items: center; gap: 10px; }
        .form-group { display: flex; flex-direction: column; gap: 8px; flex-grow: 1; }
        .form-group label { font-weight: bold; margin-bottom: 5px; }
        .form-group input[type="text"],
        .form-group input[type="number"] { padding: 10px; border: 1px solid #ccc; border-radius: 4px; width: 100%; box-sizing: border-box; }
        
        /* 이미지 섹션 스타일 */
        .image-container { display: flex; gap: 20px; margin-bottom: 30px; }
        .thumbnail-box { width: 250px; height: 250px; background-color: #eee; display: flex; justify-content: center; align-items: center; border: 1px dashed #aaa; flex-shrink: 0; }
        .image-upload-area { display: flex; flex-direction: column; gap: 15px; flex-grow: 1; }
        
        /* 옵션 및 카테고리 섹션 */
        .basic-info-section { display: flex; flex-direction: column; gap: 15px; flex-grow: 1; }
        .category-options { display: flex; align-items: center; gap: 20px; }
        .category-options label { margin-right: 5px; font-weight: normal; }

        /* 옵션 추가/삭제 스타일 */
        .option-management-section { border: 1px solid #ddd; padding: 20px; border-radius: 4px; background-color: #f9f9f9; }
        .top-option-item { border: 1px solid #ccc; padding: 15px; margin-bottom: 15px; border-radius: 4px; background-color: #fff; }
        .top-option-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .top-option-header h4 { margin: 0; font-size: 1.1em; color: #007bff; }
        .sub-option-list { display: flex; flex-direction: column; gap: 5px; margin-top: 10px; }
        .sub-option-item { display: flex; align-items: center; gap: 10px; background-color: #f3f3f3; padding: 8px; border-radius: 3px; }
        
        /* 버튼 스타일 */
        .btn { padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; font-weight: 500; transition: background-color 0.2s; }
        .btn-primary { background-color: #4CAF50; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-add { background-color: #007bff; color: white; }
        .btn-add:hover { background-color: #0056b3; }
        .btn-primary:hover { background-color: #45a049; }
        .btn-danger:hover { background-color: #c82333; }
        
        .main-action-buttons { text-align: center; margin-top: 30px; }
        .main-action-buttons .btn { padding: 12px 30px; font-size: 1.1em; }

        /* Flatpickr 스타일 오버라이드 */
        .flatpickr-calendar { z-index: 9999; }
        .flatpickr-day.selected, .flatpickr-day.startRange, .flatpickr-day.endRange, .flatpickr-day.selected.inRange, .flatpickr-day.startRange.inRange, .flatpickr-day.endRange.inRange {
            background: #FF5733; /* 판매 불가 날짜를 강조 */
            border-color: #FF5733;
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
                        <img :src="thumbnailUrl || '/img/default_thumbnail.png'" alt="썸네일 이미지" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                        <span v-if="!thumbnailUrl">썸네일</span>
                    </div>

                    <div class="image-upload-area">
                        <%-- 썸네일 --%>
                        <div class="form-row">
                            <label>썸네일 (필수)</label>
                            <input type="file" id="thumbnailFile" @change="handleFileChange('thumbnail', $event)" accept="image/*" required>
                        </div>
                        
                        <%-- 하위 이미지 --%>
                        <div class="form-group">
                            <label>하위 이미지 (최대 5개)</label>
                            <input type="file" id="detailFiles" @change="handleFileChange('detail', $event)" accept="image/*" multiple>
                            <div v-if="detailFiles.length > 0">{{ detailFiles.length }}개 파일 선택됨</div>
                        </div>

                        <%-- 롱 이미지 --%>
                        <div class="form-group">
                            <label>상세 설명 (Long 이미지)</label>
                            <input type="file" id="longFile" @change="handleFileChange('long', $event)" accept="image/*">
                        </div>
                    </div>
                </div>
                
                <%-- 2. 기본 정보 섹션 --%>
                <div class="basic-info-section">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="proName">상품 이름</label>
                            <input type="text" id="proName" name="proName" v-model="product.proName" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group" style="width: 30%;">
                            <label for="price">최소 가격</label>
                            <input type="number" id="price" name="price" v-model.number="product.price" required min="0">
                        </div>
                        <div class="form-group" style="width: 30%;">
                            <label for="deliveryFee">배송비</label>
                            <input type="number" id="deliveryFee" name="deliveryFee" v-model.number="product.deliveryFee" required min="0">
                        </div>
                        <div class="form-group" style="width: 40%;">
                            <label>픽업/배송 불가 날짜 설정</label>
                            <input type="text" id="disabledDatesInput" placeholder="불가 날짜 선택 (클릭)">
                            <button type="button" class="btn btn-secondary" @click="clearDisabledDates">불가 날짜 초기화</button>
                        </div>
                    </div>
                    
                    <div class="category-options">
                        <label>카테고리:</label>
                        <input type="radio" id="categoryCake" value="CAKE" v-model="product.category"><label for="categoryCake">케이크</label>
                        <input type="radio" id="categoryBakery" value="BAKERY" v-model="product.category"><label for="categoryBakery">베이커리</label>
                        <input type="radio" id="categoryChocolate" value="CHOCOLATE" v-model="product.category"><label for="categoryChocolate">초콜릿/사탕</label>
                        <input type="radio" id="categoryOther" value="OTHER" v-model="product.category"><label for="categoryOther">기타</label>
                        
                        <label style="margin-left: 20px;">레터링 가능:</label>
                        <input type="radio" id="letteringY" value="Y" v-model="product.lettering"><label for="letteringY">O</label>
                        <input type="radio" id="letteringN" value="N" v-model="product.lettering"><label for="letteringN">X</label>
                    </div>

                    <%-- 3. 옵션 관리 섹션 --%>
                    <div class="option-management-section">
                        <h3>상품 옵션 관리</h3>

                        <%-- 상위 옵션 목록 --%>
                        <div v-for="(topOpt, topIndex) in options" :key="topOpt.id" class="top-option-item">
                            <div class="top-option-header">
                                <h4>상위 옵션 {{ topIndex + 1 }} : {{ topOpt.optionName || '이름 없음' }}</h4>
                                <div>
                                    <label>수량 선택 가능: 
                                        <input type="checkbox" v-model="topOpt.isQuantitySelectAble" true-value="Y" false-value="N">
                                    </label>
                                    <button type="button" class="btn btn-danger btn-sm" @click="removeTopOption(topIndex)">삭제</button>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <input type="text" placeholder="상위 옵션명 (예: 케이크 크기)" v-model="topOpt.optionName" required style="flex-grow: 1;">
                            </div>

                            <%-- 하위 옵션 목록 --%>
                            <div class="sub-option-list">
                                <div v-for="(subOpt, subIndex) in topOpt.subOptions" :key="subOpt.id" class="sub-option-item">
                                    <input type="text" placeholder="값 이름 (예: 미니)" v-model="subOpt.valueName" required>
                                    <input type="number" placeholder="+ 추가 금액 (0이면 추가금 없음)" v-model.number="subOpt.priceDiff" min="0">
                                    <button type="button" class="btn btn-danger" @click="removeSubOption(topIndex, subIndex)">삭제</button>
                                </div>
                            </div>
                            
                            <button type="button" class="btn btn-add" @click="addSubOption(topIndex)" style="margin-top: 10px;">하위 옵션 추가</button>
                        </div>

                        <%-- 옵션 추가 버튼 --%>
                        <button type="button" class="btn btn-add" @click="addTopOption">상위 옵션 추가</button>
                        <p style="margin-top: 15px; font-size: 0.9em; color: gray;">
                            * 상위 옵션(예: 크기)을 추가하고, 하위 옵션(예: 미니, 1호, 2호)과 추가 금액을 설정하세요.
                        </p>
                    </div>
                </div>
                
                <%-- 4. 등록/수정 버튼 --%>
                <div class="main-action-buttons">
                    <button type="submit" class="btn btn-primary">{{ proNo ? '제품 수정하기' : '제품 등록하기' }}</button>
                    <button type="button" class="btn btn-secondary" onclick="history.back()">목록으로</button>
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

            return {
                proNo: proNoFromJSP, // 제품 번호 (null이면 등록 모드, 값이 있으면 수정 모드)
                userId : "${sessionId}",
                
                // 폼 데이터 모델
                product: {
                    userId : "${sessionId}",
                    proName: '',
                    price: 0,
                    deliveryFee: 0,
                    category: 'CAKE', // 기본값
                    lettering: 'N'    // 기본값
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
                        console.log("선택된 불가 날짜:", self.disabledDates);
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
                if (!this.proNo && !this.thumbnailFile) {
                    alert('썸네일 이미지는 필수입니다.');
                    return;
                }
                
                if (this.options.length === 0) {
                    alert('최소 1개 이상의 상위 옵션을 등록해야 합니다.');
                    return;
                }

                // 1. FormData 객체 생성 (파일 전송을 위해 필수)
                const formData = new FormData();

                // 2. 기본 정보 추가
                for (const key in this.product) {
                    formData.append(key, this.product[key]);
                  
                }
                // proNo 추가 (등록 시 null, 수정 시 값)
                if(this.proNo) {
                     formData.append('proNo', this.proNo);
                }

                // 3. 파일 추가
                if (this.thumbnailFile) {
                    formData.append('thumbnailFile', this.thumbnailFile);
                }
                this.detailFiles.forEach(file => {
                    formData.append('detailFiles', file);
                });
                if (this.longFile) {
                    formData.append('longFile', this.longFile);
                }
                
                // 4. 옵션 데이터 추가 (JSON 문자열로 변환하여 전송)
                // 서버에서 JSON 문자열을 받아 List<Map> 형태로 변환해야 합니다.
                const optionsJson = JSON.stringify(this.options);
                formData.append('optionsJson', optionsJson);
                
                // 5. 불가 날짜 추가 (콤마로 구분된 문자열로 전송)
                formData.append('disabledDatesStr', this.disabledDates.join(','));


                // 6. AJAX 전송
                const url = this.proNo ? "/seller/product/update.dox" : "/seller/product/register.dox";

                $.ajax({
                    url: url,
                    type: "POST",
                    data: formData,
                    processData: false, // FormData 사용 시 필수
                    contentType: false, // FormData 사용 시 필수
                    success: (response) => {
                        if (response.success) { // 서버 응답 구조에 따라 변경
                            alert(this.proNo ? "제품 정보가 성공적으로 수정되었습니다." : "제품이 성공적으로 등록되었습니다.");
                            // 등록/수정 후 판매자 상품 목록 페이지로 이동 (예시 경로)
                            location.href = "/seller/productList.do"; 
                        } else {
                            alert("처리 실패: " + (response.message || "알 수 없는 오류"));
                        }
                    },
                    error: (xhr, status, error) => {
                        console.error("서버 통신 오류:", error);
                        alert("서버 통신 오류로 작업을 완료할 수 없습니다.");
                    }
                });
            },
            
            // ************ 수정 모드 데이터 로드 (더미 데이터 예시) ************
            loadProductDataForEdit() {
                // 이 함수는 실제 서버에서 proNo를 기반으로 데이터를 로드해야 합니다.
                if (!this.proNo) return; 

                console.log(`제품 번호 ${proNo}에 대한 데이터 로드 시작...`);
                
                // **TODO: 실제 AJAX 호출로 서버에서 데이터 로드**

                // --- 더미 데이터 (예시) ---
                this.product = {
                    proName: '딸기 생크림 케이크',
                    price: 25000,
                    deliveryFee: 3000,
                    category: 'CAKE', 
                    lettering: 'Y'    
                };
                this.thumbnailUrl = 'https://via.placeholder.com/250x250?text=Loaded+Image'; // 기존 이미지 URL
                this.disabledDates = ["2025-11-20", "2025-12-25"]; // 기존 불가 날짜 로드

                // 기존 옵션 로드
                this.options = [
                    { id: 101, optionName: '케이크 크기', isQuantitySelectAble: 'N', subOptions: [
                        { id: 201, valueName: '미니', priceDiff: 0 },
                        { id: 202, valueName: '1호', priceDiff: 5000 },
                    ]},
                    { id: 102, optionName: '촛불', isQuantitySelectAble: 'Y', subOptions: [
                        { id: 203, valueName: '일반 촛불', priceDiff: 0 },
                        { id: 204, valueName: '숫자 촛불', priceDiff: 1000 },
                    ]}
                ];
                // 더미 데이터의 ID로 nextId 값 업데이트
                nextTopOptionId = 103; 
                nextSubOptionId = 205; 
                
                // Flatpickr에 로드된 불가 날짜 바인딩
                this.datePicker.setDate(this.disabledDates, true); 
                // -----------------------------
            },
            
        },
        mounted() {
            // Flatpickr 초기화
            this.initFlatpickr();
           console.log(this.userId);
            // 수정 모드인 경우 데이터 로드
            if (this.proNo) {
                this.loadProductDataForEdit();
            }
        }
    });

    app.mount('#productRegisterApp');
</script>