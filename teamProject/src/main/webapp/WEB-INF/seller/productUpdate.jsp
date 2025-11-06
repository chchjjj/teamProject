<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>

<%-- 
    JSP 스크립틀릿과 표현식을 사용하여 Controller에서 전달받는 Model 데이터를 변수에 저장합니다.
    (JSTL 태그를 사용하지 않음)
--%>
<%
    // Controller에서 Model에 담아준 데이터를 가져옵니다.
    // 값이 없을 경우 (등록 모드)에는 null 또는 빈 문자열로 처리
    Object proNoObj = request.getAttribute("proNo");
    String proNo = (proNoObj != null) ? proNoObj.toString() : "";
    
    String productJson = (String) request.getAttribute("productJson");
    String optionsJson = (String) request.getAttribute("optionsJson");
    String disabledDatesStr = (String) request.getAttribute("disabledDatesStr");
    
    // 세션 정보 (Controller에서 Model에 담아주지 않았다면 세션에서 직접 가져와야 함)
    // 여기서는 Controller가 Model에 담아준다고 가정하고 예시로 둡니다.
    String sessionId = (String) request.getAttribute("sessionId"); 
    if (sessionId == null) {
        // Model에 없다면 세션에서 직접 가져오는 예시 코드
        // sessionId = (String) session.getAttribute("LOGIN_ID");
        sessionId = "SELLER_TEST_001"; // 임시값
    }

    // 페이지 타이틀 설정
    String pageTitle = (proNo != null && !proNo.isEmpty()) ? "제품 정보 수정" : "새 제품 등록";
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - 디저트 연구소</title>
    
    <%-- JQuery, Vue, Flatpickr 라이브러리 추가 --%>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
    
    <style>
        /* (스타일 시트 내용은 이전과 동일합니다.) */
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
            <h2><%= pageTitle %></h2>
            
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
                            <label>썸네일 <span v-if="!proNo">(필수)</span></label>
                            <input type="file" id="thumbnailFile" @change="handleFileChange('thumbnail', $event)" accept="image/*" :required="!proNo">
                        </div>
                        
                        <%-- 하위 이미지 --%>
                        <div class="form-group">
                            <label>하위 이미지 (최대 5개)</label>
                            <input type="file" id="detailFiles" @change="handleFileChange('detail', $event)" accept="image/*" multiple>
                            <div v-if="detailFiles.length > 0">{{ detailFiles.length }}개 파일 선택됨</div>
                            <div v-if="proNo && existingDetailImages.length > 0">
                                **기존 이미지:** {{ existingDetailImages.length }}개
                                <button type="button" class="btn btn-secondary btn-sm" @click="clearExistingImages('detail')">기존 이미지 유지</button>
                            </div>
                        </div>

                        <%-- 롱 이미지 --%>
                        <div class="form-group">
                            <label>상세 설명 (Long 이미지)</label>
                            <input type="file" id="longFile" @change="handleFileChange('long', $event)" accept="image/*">
                            <div v-if="proNo && existingLongImage">
                                **기존 이미지:** {{ existingLongImage.substring(existingLongImage.lastIndexOf('/') + 1) }}
                                <button type="button" class="btn btn-secondary btn-sm" @click="clearExistingImages('long')">기존 이미지 유지</button>
                            </div>
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
                    
                    <div class="basic-info-section">
                        <div class="category-options">
                            <label>카테고리:</label>
                            <input type="radio" id="categoryCake" value="케이크" v-model="product.proType"><label for="categoryCake">케이크</label>
                            <input type="radio" id="categoryBakery" value="베이커리" v-model="product.proType"><label for="categoryBakery">베이커리</label>
                            <input type="radio" id="categoryChocolate" value="초콜릿/사탕" v-model="product.proType"><label for="categoryChocolate">초콜릿/사탕</label>
                            <input type="radio" id="categoryOther" value="OTHER" v-model="product.proType"><label for="categoryOther">기타</label>
                            
                            <label style="margin-left: 20px;">레터링 가능:</label>
                            <input type="radio" id="letteringY" value="Y" v-model="product.lettering"><label for="letteringY">O</label>
                            <input type="radio" id="letteringN" value="N" v-model="product.lettering"><label for="letteringN">X</label>

                            <label style="margin-left: 20px;">상품 상태:</label>
                            <input type="radio" id="statusY" value="Y" v-model="product.status"><label for="statusY">판매 중</label>
                            <input type="radio" id="statusN" value="N" v-model="product.status"><label for="statusN">판매 중지</label>
                        </div>
                    </div>

                    <%-- 3. 옵션 관리 섹션 --%>
                    <div class="option-management-section">
                        <h3>상품 옵션 관리</h3>

                        <%-- 상위 옵션 목록 (Vue.js) --%>
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

                            <%-- 하위 옵션 목록 (Vue.js) --%>
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
    let nextTopOptionId = 1000;
    let nextSubOptionId = 10000;

    // EL 데이터 처리 (Controller에서 Model에 담아준 데이터)
    // ----------------------------------------------------
    const proNoFromJSP = "<%= proNo %>" === "" ? null : parseInt("<%= proNo %>");
    const sessionIdFromJSP = "<%= sessionId %>";
    
    // JSP 표현식으로 JSON 문자열을 직접 가져옵니다.
    // 주의: JSON 문자열 내부에 줄 바꿈이나 특수 문자가 있다면 Controller에서 미리 escape 처리해야 합니다.
    const productJsonStr = "<%= productJson %>";
    const optionsJsonStr = "<%= optionsJson %>";
    const disabledDatesStrFromJSP = "<%= disabledDatesStr %>";

    let initialProduct = {};
    if (productJsonStr && productJsonStr !== "null") {
        try {
            // Vue.js에서 파싱하기 위해 안전하게 처리된 JSON 문자열을 파싱
            initialProduct = JSON.parse(productJsonStr);
        } catch (e) {
            console.error("제품 기본 정보 JSON 파싱 오류:", e);
        }
    }

    let initialOptions = [];
    if (optionsJsonStr && optionsJsonStr !== "null") {
        try {
            // Vue.js에서 파싱하기 위해 안전하게 처리된 JSON 문자열을 파싱
            initialOptions = JSON.parse(optionsJsonStr);
        } catch (e) {
            console.error("옵션 정보 JSON 파싱 오류:", e);
        }
    }
    
    // disabledDatesStr 데이터 처리
    const initialDisabledDates = disabledDatesStrFromJSP && disabledDatesStrFromJSP !== "null" 
        ? disabledDatesStrFromJSP.split(',') 
        : [];
    // ----------------------------------------------------


    // Vue 앱 초기화
    const app = Vue.createApp({
        data() {
            return {
                proNo: proNoFromJSP, // 제품 번호 (null이면 등록 모드, 값이 있으면 수정 모드)
                userId : sessionIdFromJSP, 
                
                // 폼 데이터 모델
                product: {
                    userId : sessionIdFromJSP,
                    proName: initialProduct.proName || '',
                    price: initialProduct.price || 0,
                    deliveryFee: initialProduct.deliveryFee || 0,
                    proType: initialProduct.proType || '케이크', // 기본값 "케이크"
                    lettering: initialProduct.lettering || 'N' ,  // 기본값
                    status: initialProduct.status || 'Y' // 기본값 'Y'
                },

                // 이미지 파일 관리 (서버 전송용)
                thumbnailFile: null,
                detailFiles: [],
                longFile: null,
                
                // 기존 이미지 정보 (수정 모드에서만 사용)
                thumbnailUrl: initialProduct.thumbnailPath || null, // 기존 썸네일 URL
                existingDetailImages: initialProduct.detailImagePaths || [], // 기존 하위 이미지 URL 배열
                existingLongImage: initialProduct.longImagePath || null, // 기존 롱 이미지 URL

                // 옵션 데이터 구조 초기화
                options: initialOptions, 
                
                // Flatpickr 관련 초기화
                disabledDates: initialDisabledDates, // 저장된 불가 날짜
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
                    // 새 파일이 선택되면 기존 이미지는 전송하지 않도록 관리 
                    this.existingDetailImages = [];
                } else if (type === 'long') {
                    this.longFile = files[0];
                    this.existingLongImage = null; 
                }
            },
            clearExistingImages(type) {
                // 수정 모드에서 파일을 다시 업로드하지 않고 기존 이미지를 유지하고 싶을 때
                if (type === 'detail') {
                    this.detailFiles = [];
                    // 실제 기존 이미지 경로를 다시 로드해야 함 (이 예시에서는 로드했다고 가정)
                    alert('기존 이미지가 유지됩니다. 새로운 파일을 업로드하려면 다시 선택하세요.');
                } else if (type === 'long') {
                    this.longFile = null;
                    alert('기존 이미지가 유지됩니다. 새로운 파일을 업로드하려면 다시 선택하세요.');
                }
            },
            
            // ************ 옵션 관리 ************
            addTopOption() {
                this.options.push({
                    id: 'new-' + nextTopOptionId++, // 프런트엔드 임시 ID
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
                    id: 'new-' + nextSubOptionId++, // 프런트엔드 임시 ID
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
                
                self.datePicker = flatpickr("#disabledDatesInput", {
                    locale: "ko",
                    mode: "multiple", 
                    enableTime: false,
                    dateFormat: "Y-m-d",
                    minDate: "today",
                    
                    // DB에서 로드된 disabledDates 배열을 초기값으로 설정
                    defaultDate: self.disabledDates, 
                    
                    onChange: function (selectedDates, dateStr, instance) {
                        // 선택된 날짜 문자열 배열을 disabledDates 배열에 저장
                        self.disabledDates = selectedDates.map(d => flatpickr.formatDate(d, "Y-m-d"));
                        console.log("선택된 불가 날짜:", self.disabledDates);
                    },
                });
            },
            clearDisabledDates() {
                if (this.datePicker) {
                    this.datePicker.clear(); 
                }
                this.disabledDates = []; // Vue 데이터도 초기화
            },


            // ************ 서버 전송 (등록/수정) ************
            fnSubmitProduct() {
                // 1. 필수 체크 (등록 모드일 때만 썸네일 파일 필수)
                if (!this.proNo && !this.thumbnailFile) {
                    alert('새 제품 등록 시 썸네일 이미지는 필수입니다.');
                    return;
                }
                
                if (this.options.length === 0) {
                    alert('최소 1개 이상의 상위 옵션을 등록해야 합니다.');
                    return;
                }

                // 2. FormData 객체 생성 (파일 전송을 위해 필수)
                const formData = new FormData();

                // 3. 기본 정보 추가
                for (const key in this.product) {
                    formData.append(key, this.product[key]);
                }
                // proNo 추가 
                if(this.proNo) {
                     formData.append('proNo', this.proNo);
                }

                // 4. 파일 추가
                if (this.thumbnailFile) {
                    formData.append('thumbnailFile', this.thumbnailFile);
                }
                // detailFiles (새 파일이 있으면 전송)
                this.detailFiles.forEach(file => {
                    formData.append('detailFiles', file);
                });
                
                if (this.longFile) {
                    formData.append('longFile', this.longFile);
                }
                // 기존 이미지를 유지할 경우, 서버는 파일이 없으면 기존 경로를 사용하도록 처리해야 합니다.

                // 5. 옵션 데이터 추가 (JSON 문자열로 변환하여 전송)
                const optionsJson = JSON.stringify(this.options);
                formData.append('optionsJson', optionsJson);
                
                // 6. 불가 날짜 추가 (콤마로 구분된 문자열로 전송)
                formData.append('disabledDatesStr', this.disabledDates.join(','));


                // 7. AJAX 전송
                // /seller/product/register.dox 또는 /seller/product/update.dox
                const url = this.proNo ? "/seller/product/update.dox" : "/seller/product/register.dox";

                $.ajax({
                    url: url,
                    type: "POST",
                    data: formData,
                    processData: false, // FormData 사용 시 필수
                    contentType: false, // FormData 사용 시 필수
                    success: (response) => {
                        if (response.success) { 
                            alert(this.proNo ? "제품 정보가 성공적으로 수정되었습니다." : "제품이 성공적으로 등록되었습니다.");
                            // 등록/수정 후 판매자 상품 목록 페이지로 이동
                            location.href = "/seller/sellerProductList.do"; 
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
        },
        mounted() {
            // Flatpickr 초기화
            this.initFlatpickr();
        }
    });

    app.mount('#productRegisterApp');
</script>