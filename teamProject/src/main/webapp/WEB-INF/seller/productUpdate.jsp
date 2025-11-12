<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - 디저트 연구소</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

    <style>
        /* (스타일은 변경 사항 없음) */
        body { font-family: 'Malgun Gothic', '맑은 고딕', sans-serif; background-color: #f4f4f4; }
        .container { display: flex; gap: 20px; max-width: 1400px; margin: 20px auto; }
        .sidebar { width: 250px; flex-shrink: 0; }
        .content { flex-grow: 1; background-color: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
        h2 { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 30px; }
        .register-form { display: flex; flex-direction: column; gap: 20px; }
        .form-row { display: flex; align-items: center; gap: 10px; }
        .form-group { display: flex; flex-direction: column; gap: 8px; flex-grow: 1; }
        .form-group label { font-weight: bold; margin-bottom: 5px; }
        .form-group input[type="text"], .form-group input[type="number"] { padding: 10px; border: 1px solid #ccc; border-radius: 4px; width: 100%; box-sizing: border-box; }
        .image-container { display: flex; gap: 20px; margin-bottom: 30px; }
        .thumbnail-box { width: 250px; height: 250px; background-color: #eee; display: flex; justify-content: center; align-items: center; border: 1px dashed #aaa; flex-shrink: 0; }
        .image-upload-area { display: flex; flex-direction: column; gap: 15px; flex-grow: 1; }
        .basic-info-section { display: flex; flex-direction: column; gap: 15px; flex-grow: 1; }
        .category-options { display: flex; align-items: center; gap: 20px; }
        .category-options label { margin-right: 5px; font-weight: normal; }
        .option-management-section { border: 1px solid #ddd; padding: 20px; border-radius: 4px; background-color: #f9f9f9; }
        .top-option-item { border: 1px solid #ccc; padding: 15px; margin-bottom: 15px; border-radius: 4px; background-color: #fff; }
        .top-option-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .top-option-header h4 { margin: 0; font-size: 1.1em; color: #007bff; }
        .sub-option-list { display: flex; flex-direction: column; gap: 5px; margin-top: 10px; }
        .sub-option-item { display: flex; align-items: center; gap: 10px; background-color: #f3f3f3; padding: 8px; border-radius: 3px; }
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
        .flatpickr-calendar { z-index: 9999; }
        .flatpickr-day.selected, .flatpickr-day.startRange, .flatpickr-day.endRange,
        .flatpickr-day.selected.inRange, .flatpickr-day.startRange.inRange, .flatpickr-day.endRange.inRange {
            background: #FF5733;
            border-color: #FF5733;
            color: white;
        }
    </style>
</head>

<body>
<div class="container">
    <%-- sellerSideBar.jsp 포함 --%>
    <main class="content" id="productRegisterApp">
        <h2>${pageTitle}</h2>

        <form id="productForm" @submit.prevent="fnSubmitProduct">
            <input type="hidden" name="proNo" :value="proNo">
            
            <div class="image-container">
                <div class="thumbnail-box">
                    <img :src="thumbnailUrl || '/img/default_thumbnail.png'" alt="썸네일 이미지"
                            style="max-width: 100%; max-height: 100%; object-fit: contain;">
                    <span v-if="!thumbnailUrl">썸네일</span>
                </div>

                <div class="image-upload-area">
                    <div class="form-row">
                        <label>썸네일 <span v-if="!proNo">(필수)</span></label>
                        <input type="file" id="thumbnailFile"
                                @change="handleFileChange('thumbnail', $event)" accept="image/*"
                                :required="!proNo">
                    </div>

                    <div class="form-group">
                        <label>하위 이미지 (최대 5개)</label>
                        <input type="file" id="detailFiles" @change="handleFileChange('detail', $event)"
                                accept="image/*" multiple>
                        <div v-if="detailFiles.length > 0">**새 파일 선택됨:** {{ detailFiles.length }}개</div>
                        <div v-if="proNo && existingDetailImages.length > 0 && detailFiles.length === 0">
                            **기존 이미지 유지 중:** {{ existingDetailImages.length }}개
                            <button type="button" class="btn btn-secondary btn-sm"
                                    @click="clearExistingImages('detail')">새로 선택 취소
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>상세 설명 (Long 이미지)</label>
                        <input type="file" id="longFile" @change="handleFileChange('long', $event)"
                                accept="image/*">
                        <div v-if="proNo && existingLongImage && !longFile">
                            **기존 이미지 유지 중:** {{ existingLongImage.substring(existingLongImage.lastIndexOf('/') + 1) }}
                            <button type="button" class="btn btn-secondary btn-sm"
                                    @click="clearExistingImages('long')">새로 선택 취소
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="basic-info-section">
                <div class="form-row">
                    <div class="form-group">
                        <label for="proName">상품 이름</label>
                        <input type="text" id="proName" name="proName" v-model="product.proName"
                                required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group" style="width: 30%;">
                        <label for="price">최소 가격</label>
                        <input type="number" id="price" name="price" v-model.number="product.price"
                                required min="0">
                    </div>
                    <div class="form-group" style="width: 30%;">
                        <label for="deliveryFee">배송비</label>
                        <input type="number" id="deliveryFee" name="deliveryFee"
                                v-model.number="product.deliveryFee" required min="0">
                    </div>
                    <div class="form-group" style="width: 40%;">
                        <label>픽업/배송 불가 날짜 설정</label>
                        <input type="text" id="disabledDatesInput" placeholder="불가 날짜 선택 (클릭)">
                        <button type="button" class="btn btn-secondary" @click="clearDisabledDates">불가
                            날짜 초기화</button>
                    </div>
                </div>

                <div class="category-options">
                    <label>카테고리:</label>
                    <input type="radio" id="categoryCake" value="케이크" v-model="product.proType"><label
                            for="categoryCake">케이크</label>
                    <input type="radio" id="categoryBakery" value="쿠키"
                            v-model="product.proType"><label for="categoryBakery">쿠키</label>
                    <input type="radio" id="categoryChocolate" value="초콜릿"
                            v-model="product.proType"><label for="categoryChocolate">초콜릿</label>
                    <input type="radio" id="categoryOther" value="OTHER"
                            v-model="product.proType"><label for="categoryOther">기타</label>

                    <label style="margin-left: 20px;">레터링 가능:</label>
                    <input type="radio" id="letteringY" value="Y" v-model="product.lettering"><label
                            for="letteringY">O</label>
                    <input type="radio" id="letteringN" value="N" v-model="product.lettering"><label
                            for="letteringN">X</label>

                    <label style="margin-left: 20px;">상품 상태:</label>
                    <input type="radio" id="statusY" value="Y" v-model="product.status"><label
                            for="statusY">판매 중</label>
                    <input type="radio" id="statusN" value="N" v-model="product.status"><label
                            for="statusN">판매 중지</label>
                </div>
            </div>

            <div class="option-management-section">
                <h3>상품 옵션 관리</h3>
                <div v-for="(topOpt, topIndex) in options" :key="topOpt.id" class="top-option-item">
                    <div class="top-option-header">
                        <h4>상위 옵션 {{ topIndex + 1 }} : {{ topOpt.optionName || '이름 없음' }}</h4>
                        <div>
                            <label>수량 선택 가능:
                                <input type="checkbox" v-model="topOpt.isQuantitySelectAble"
                                        true-value="Y" false-value="N">
                            </label>
                            <button type="button" class="btn btn-danger btn-sm"
                                    @click="removeTopOption(topIndex)">삭제
                            </button>
                        </div>
                    </div>

                    <div class="form-row">
                        <input type="text" placeholder="상위 옵션명 (예: 케이크 크기)" v-model="topOpt.optionName"
                                required style="flex-grow: 1;">
                    </div>

                    <div class="sub-option-list">
                        <div v-for="(subOpt, subIndex) in topOpt.subOptions" :key="subOpt.id"
                                class="sub-option-item">
                            <input type="text" placeholder="값 이름 (예: 미니)" v-model="subOpt.valueName"
                                    required>
                            <input type="number" placeholder="+ 추가 금액 (0이면 추가금 없음)"
                                    v-model.number="subOpt.priceDiff" min="0">
                            <button type="button" class="btn btn-danger"
                                    @click="removeSubOption(topIndex, subIndex)">삭제
                            </button>
                        </div>
                    </div>

                    <button type="button" class="btn btn-add" @click="addSubOption(topIndex)"
                            style="margin-top: 10px;">하위 옵션 추가
                    </button>
                </div>

                <button type="button" class="btn btn-add" @click="addTopOption">상위 옵션 추가</button>
                <p style="margin-top: 15px; font-size: 0.9em; color: gray;">
                    * 상위 옵션(예: 크기)을 추가하고, 하위 옵션(예: 미니, 1호, 2호)과 추가 금액을 설정하세요.
                </p>
            </div>

            <div class="main-action-buttons">
                <button type="submit" class="btn btn-primary">{{ proNo ? '제품 수정하기' : '제품 등록하기' }}</button>
                <button type="button" class="btn btn-secondary" onclick="history.back()">목록으로</button>
            </div>
        </form>
    </main>
</div>

<script>
let nextTopOptionId = 1000;
let nextSubOptionId = 10000;

// JSP 변수 안전하게 전달 및 Null/빈 값 처리
const proNoValue = '${proNo}';
const sessionIdValue = '${sessionId}';
const disabledDatesStrValue = '${disabledDatesStr}';

// JSON 문자열 처리: null이거나 빈 문자열이면 "null" 문자열을 사용하고, 
// EL이 자동으로 처리하지 못한 이스케이프된 따옴표를 다시 복구합니다.
const productJsonStr = '${productJson != null ? productJson : "null"}'.replace(/\\"/g, '"');
const optionsJsonStr = '${optionsJson != null ? optionsJson : "null"}'.replace(/\\"/g, '"');

console.log('1. JSP에서 넘어온 원본 productJsonStr:', productJsonStr);
console.log('2. JSP에서 넘어온 원본 optionsJsonStr:', optionsJsonStr);

const proNoFromJSP = (proNoValue === 'null' || proNoValue.trim() === '' || proNoValue === '0') ? null : parseInt(proNoValue);
const sessionIdFromJSP = (sessionIdValue === 'null' || sessionIdValue.trim() === '') ? '' : sessionIdValue;
const disabledDatesFromJSP = (disabledDatesStrValue === 'null' || disabledDatesStrValue.trim() === '') ? [] : disabledDatesStrValue.split(',').filter(d => d.trim() !== '');

let initialProduct = {};
let initialOptions = [];

// 1. 제품 JSON 파싱 및 키 매핑 (🚨 수정됨: 키 매핑 로직 추가)
try { 
    if (productJsonStr !== 'null') {
        const parsed = JSON.parse(productJsonStr.replace(/&quot;/g, '"')); 
        
        // **DB 키 (SNAKE_CASE)를 Vue 키 (camelCase)로 매핑:**
        initialProduct = {
            storeId: parsed.STORE_ID || 0,
            proNo: parsed.PRO_NO || proNoFromJSP,
            userId: sessionIdFromJSP, // DB 데이터에 없으므로 세션ID 사용
            proName: parsed.PRO_NAME || '',
            price: parsed.PRICE || 0,
            deliveryFee: parsed.DELIVERY_FEE || 0,
            proType: parsed.PRO_TYPE || '케이크',
            lettering: parsed.LETTERING || 'N',
            status: parsed.STATUS || 'Y',
            // 이미지 경로는 DB 키 이름이 다를 수 있으므로 DB 키에 맞춰서 매핑
            thumbnailPath: parsed.THUMBNAIL_PATH || null, 
            detailImagePaths: parsed.DETAIL_IMAGE_PATHS || [],
            longImagePath: parsed.LONG_IMAGE_PATH || null
        };
        console.log('3. 파싱 및 매핑된 initialProduct:', initialProduct);
    }
} catch(e) { 
    console.error("제품 JSON 파싱 오류:", e); 
}

// 2. 옵션 JSON 파싱, 그룹화 및 ID 카운터 초기화 (🚨 핵심 수정됨: 그룹화 로직 추가)
try { 
    if (optionsJsonStr && optionsJsonStr !== 'null') {
        let optionsToParse = optionsJsonStr.replace(/&quot;/g, '"');
        // JSON 파싱을 위해 불필요한 이스케이프 문자 제거 시도
        optionsToParse = optionsToParse.replace(/\\/g, ''); 

        let parsedOptions = JSON.parse(optionsToParse); 
        
        if (Array.isArray(parsedOptions)) {
            
            // DB에서 TOP 옵션과 SUB 옵션이 하나의 리스트로 넘어왔으므로, TOP_OPTION_ID 기준으로 그룹화
            const groupedOptions = parsedOptions.reduce((acc, current) => {
                const topId = current.TOP_OPTION_ID || current.OPT_NO;
                if (!topId) return acc; // TOP ID가 없으면 무시

                if (!acc[topId]) {
                    // 상위 옵션 객체 생성 및 키 매핑
                    acc[topId] = {
                        id: topId,
                        optionName: current.OPTION_NAME, // TOP_OPTION_ID가 같으면 OPTION_NAME도 같다고 가정
                        isQuantitySelectAble: current.IS_QUANTITY_SELECTABLE || 'N',
                        subOptions: []
                    };
                }
                
                // 하위 옵션 객체 추가 및 키 매핑
                acc[topId].subOptions.push({
                    id: current.SUB_OPTION_ID || current.OPT_VALUE_NO,
                    valueName: current.VALUE_NAME,
                    priceDiff: current.PRICE_DIFF || 0,
                });
                return acc;
            }, {});

            initialOptions = Object.values(groupedOptions);

        } else {
            console.warn("경고: 옵션 JSON이 유효한 배열 형태가 아닙니다. 빈 배열로 초기화합니다.");
            initialOptions = []; 
        }
        
        console.log('4. 파싱 및 그룹화된 initialOptions:', initialOptions);
    }
    
    // ID 카운터 초기화 로직 (매핑된 initialOptions 사용)
    initialOptions.forEach(topOpt => {
        // topOpt.id (DB에서 가져온 TOP ID)를 사용하여 nextTopOptionId 업데이트
        const topId = parseInt(topOpt.id || 0);
        if(!isNaN(topId) && topId >= nextTopOptionId) nextTopOptionId = topId + 1;
        
        if (!topOpt.subOptions || !Array.isArray(topOpt.subOptions)) {
            topOpt.subOptions = []; 
        }

        topOpt.subOptions.forEach(subOpt => {
            // subOpt.id (DB에서 가져온 SUB ID)를 사용하여 nextSubOptionId 업데이트
            const subId = parseInt(subOpt.id || 0);
            if(!isNaN(subId) && subId >= nextSubOptionId) nextSubOptionId = subId + 1;
        });
        
        // Vue 렌더링을 위해 기본값 설정
        if (topOpt.isQuantitySelectAble === undefined) {
             topOpt.isQuantitySelectAble = 'N';
        }
    });

} catch(e) { 
    console.error("옵션 JSON 파싱 오류 (최종 처리):", e); 
    initialOptions = []; 
}


const app = Vue.createApp({
    data() {function getQueryParam(name) {
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(window.location.href);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}

// URL에서 'proNo' 값을 가져와서 숫자로 변환합니다.
// URL: http://localhost:8087/seller/productUpdate.do?proNo=118
const proNoFromURL = parseInt(getQueryParam('proNo')) || 0;
        return {
            storeId: initialProduct.storeId || 0,
            proNo: initialProduct.proNo || proNoFromJSP,
            userId: sessionIdFromJSP,
            product: {
                // 🚨 매핑된 initialProduct의 속성을 사용
                userId: sessionIdFromJSP,
                proName: initialProduct.proName || '',
                price: initialProduct.price || 0,
                deliveryFee: initialProduct.deliveryFee || 0,
                proType: initialProduct.proType || '케이크',
                lettering: initialProduct.lettering || 'N',
                status: initialProduct.status || 'Y',
                proNo: proNoFromURL,
            },
            thumbnailFile: null,
            detailFiles: [],
            longFile: null,
            // 🚨 매핑된 initialProduct의 이미지 경로를 사용
            thumbnailUrl: initialProduct.thumbnailPath || null, 
            existingDetailImages: initialProduct.detailImagePaths || [],
            existingLongImage: initialProduct.longImagePath || null,
            options: initialOptions, 
            disabledDates: disabledDatesFromJSP,
            datePicker: null
        };
    },
    methods: {
        handleFileChange(type, event) {
            const files = event.target.files;
            if(!files.length) return;
            if(type==='thumbnail'){ this.thumbnailFile=files[0]; this.thumbnailUrl=URL.createObjectURL(files[0]); }
            else if(type==='detail'){ this.detailFiles=Array.from(files).slice(0,5); this.existingDetailImages=[]; }
            else if(type==='long'){ this.longFile=files[0]; this.existingLongImage=null; }
        },
        clearExistingImages(type){
            if(type==='detail'){ 
                document.getElementById('detailFiles').value = ''; 
                this.detailFiles=[]; 
                alert('새로 선택을 취소하고 기존 이미지를 유지합니다.'); 
            }
            else if(type==='long'){ 
                document.getElementById('longFile').value = ''; 
                this.longFile=null; 
                alert('새로 선택을 취소하고 기존 이미지를 유지합니다.'); 
            }
        },
        addTopOption(){ this.options.push({id:'new-'+nextTopOptionId++, optionName:'', isQuantitySelectAble:'N', subOptions:[]}); },
        removeTopOption(index){ if(confirm('상위 옵션을 삭제하시겠습니까?')) this.options.splice(index,1); },
        addSubOption(topIndex){ this.options[topIndex].subOptions.push({id:'new-'+nextSubOptionId++, valueName:'', priceDiff:0}); },
        removeSubOption(topIndex, subIndex){ this.options[topIndex].subOptions.splice(subIndex,1); },
        initFlatpickr(){
            const self=this;
            self.datePicker=flatpickr("#disabledDatesInput", {
                mode:"multiple", dateFormat:"Y-m-d", locale:"ko",
                defaultDate:self.disabledDates,
                onChange(selectedDates){ self.disabledDates=selectedDates.map(d=>d.toISOString().split('T')[0]); }
            });
        },
        clearDisabledDates(){ this.disabledDates=[]; this.datePicker.clear(); },
       fnSubmitProduct() {
    // 1. Vue 데이터를 JSON 문자열로 변환
    const productData = this.product;
    const optionData = this.options;
    if (this.storeId === 0) {
        alert('상점 ID가 누락되어 제품 수정 요청을 보낼 수 없습니다.');
        return;
    }
    const formData = new FormData();
    // 2. FormData 객체를 생성하여 파일과 데이터를 담음
    formData.append('storeId', this.storeId);
    formData.append('proNo', this.proNo);
    formData.append('productJson', JSON.stringify(productData));
    formData.append('optionsJson', JSON.stringify(optionData));
    formData.append('disabledDates', this.disabledDates.join(','));
    
    // 파일 추가 (필요한 경우)
    if (this.thumbnailFile) formData.append('thumbnailFile', this.thumbnailFile);
    // ... 나머지 detailFiles, longFile, 기존 이미지 처리 로직 추가 ...

    // 3. 서버에 AJAX 요청 (수정 요청이므로 PUT 또는 POST 사용)
    $.ajax({
        url: '/seller/product/update.dox', // 실제 서버 수정 엔드포인트
        type: 'POST', // 스프링/JSP 환경에서 PUT 대신 POST를 많이 사용
        data: formData,
        contentType: false, // 파일 전송 시 필수
        processData: false, // 파일 전송 시 필수
        success: (response) => {
            alert('아직 준비중입니다.');
            location.href = '/seller/storeList.do'; // 목록 페이지로 이동
        },
        error: (error) => {
            console.error('제품 수정 오류:', error);
            alert('아직 준비중입니다.');
        }
    });
},
    },
    mounted(){
        this.initFlatpickr();
        console.log('초기 product:', this.product);
        console.log('초기 thumbnailUrl:', this.thumbnailUrl);
        console.log('초기 options:', this.options);
    }
});

app.mount('#productRegisterApp');
</script>
</body>
</html>