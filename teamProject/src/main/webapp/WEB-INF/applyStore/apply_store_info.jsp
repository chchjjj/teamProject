<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>가게 정보 입력</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <%-- 🌟 카카오(Daum) 우편번호 서비스 API 라이브러리 추가 --%>
            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

            <style>
                .form-container {
                    max-width: 650px;
                    margin: 30px auto;
                    padding: 40px 50px;
                    background-color: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                }

                h2,
                h3 {
                    text-align: center;
                    margin-bottom: 30px;
                    color: #333;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 8px;
                }

                .input-group {
                    display: flex;
                    /* 주소 필드와 버튼을 한 줄에 배치 */
                    gap: 10px;
                }

                .form-group input[type="text"],
                .form-group input[type="time"],
                .form-group textarea,
                .form-group select {
                    width: 100%;
                    padding: 10px 12px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    font-size: 15px;
                    transition: all 0.2s ease;
                }

                .form-group input[type="text"].addr-input {
                    flex-grow: 1;
                    /* 주소 입력 필드가 공간을 차지하도록 */
                }

                .form-group input:focus,
                .form-group textarea:focus,
                .form-group select:focus {
                    border-color: #3E2723;
                    outline: none;
                    box-shadow: 0 0 5px rgba(76, 175, 80, 0.2);
                }

                textarea {
                    min-height: 100px;
                    resize: vertical;
                }

                .radio-group {
                    display: flex;
                    gap: 20px;
                    align-items: center;
                    margin-top: 6px;
                }

                .radio-group label {
                    display: flex;
                    align-items: center;
                    font-weight: normal;
                    margin: 0;
                }

                .radio-group input[type="radio"] {
                    margin-right: 6px;
                }

                /* 버튼 */
                .submit-btn,
                .addr-search-btn {
                    display: block;
                    width: 100%;
                    background-color: #3E2723;
                    color: white;
                    font-size: 1.1em;
                    font-weight: bold;
                    padding: 14px 0;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: background-color 0.2s ease, transform 0.1s ease;
                }

                .addr-search-btn {
                    width: 120px;
                    /* 주소 검색 버튼 너비 조정 */
                    padding: 10px 0;
                    font-size: 0.9em;
                    background-color: #6c757d;
                }

                .submit-btn:hover {
                    background-color: #3E2723;
                    transform: translateY(-1px);
                }

                .addr-search-btn:hover {
                    background-color: #5a6268;
                }

                /* 반응형 */
                @media (max-width: 600px) {
                    .form-container {
                        padding: 25px 20px;
                    }

                    .form-group label {
                        font-size: 0.95em;
                    }

                    .submit-btn {
                        font-size: 1em;
                        padding: 12px 0;
                    }
                }

                /* 가게주소와 지역 선택이 같은 섹션인 경우를 대비 */
                #storeArea {
                    margin-top: 4px;
                }

                /* ===== 입점 신청하기 제목 스타일 ===== */
                .apply-title {
                    text-align: center;
                    font-size: 28px;
                    font-weight: 700;
                    color: #3E2723;
                    margin-top: 20px;
                    margin-bottom: 10px;
                    letter-spacing: -0.5px;
                }
            </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <h2 class="apply-title">입점 신청하기</h2>
                <a style="display: block; text-align: center;">
                    <img src="/img/입점광고.jpg" alt="입점광고">
                </a>
                <div class="form-container">

                    <form @submit.prevent="nextPage">
                        <div class="form-group">
                            <label for="userId">유저 ID :</label>
                            <input type="text" v-model="formData.userId" id="userId" required readonly>
                        </div>

                        <div class="form-group">
                            <label for="storeName">가게명:</label>
                            <input type="text" v-model="formData.storeName" id="storeName" required>
                        </div>

                        <div class="form-group">
                            <label for="businessNo">사업자등록번호:</label>
                            <div class="input-group"> 
                                <input type="text" placeholder="'-'는 제외하고 숫자 10자리를 입력해주세요." 
                                        v-model="formData.businessNo" 
                                        id="businessNo" 
                                        maxlength="10" 
                                        @input="formData.businessNo = formData.businessNo.replace(/[^0-9]/g, '')"
                                        :readonly="isBusinessNoChecked" 
                                        required>
                                        <!-- ▲ 숫자 10자리 정규식 & 중복확인 완료되면 입력칸 비활성화 -->
                                <button type="button" class="addr-search-btn" @click="fnCheckBusinessNo">중복확인</button>
                            </div>
                            <!-- ▼ 중복 확인 결과 메세지 영역 -->
                             <div v-if="bizCheckMsg" :style="{ color: bizCheckColor, fontSize: '13px', marginTop: '5px', fontWeight: 'bold' }">
                                {{ bizCheckMsg }}
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="storeIntro">가게소개:</label>
                            <textarea v-model="formData.storeIntro" id="storeIntro" required></textarea>
                        </div>

                        <div class="form-group">
                            <label>배송가능여부:</label>
                            <div class="radio-group">
                                <label><input type="radio" v-model="formData.deliveryYn" value="Y" required> 가능</label>
                                <label><input type="radio" v-model="formData.deliveryYn" value="N" required> 불가능</label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>채팅가능여부:</label>
                            <div class="radio-group">
                                <label><input type="radio" v-model="formData.isChatEnabled" value="Y" required>
                                    가능</label>
                                <label><input type="radio" v-model="formData.isChatEnabled" value="N" required>
                                    불가능</label>
                            </div>
                        </div>

                        <div class="form-group" v-if="formData.isChatEnabled === 'Y'">
                            <label>채팅 운영 시간:</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="time" v-model="formData.chatStart" id="chatStart" required
                                    style="flex-grow: 1;">
                                <span>~</span>
                                <input type="time" v-model="formData.chatEnd" id="chatEnd" required
                                    style="flex-grow: 1;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="storeAddr">가게주소:</label>
                            <div class="input-group">
                                <%-- 🌟 주소 입력 필드 (읽기 전용, 여기에 전체 주소 입력) --%>
                                    <input type="text" v-model="formData.storeAddr" id="storeAddr" required readonly
                                        class="addr-input" placeholder="주소 검색 버튼을 눌러 입력하세요">
                                    <%-- 🌟 주소 검색 버튼 --%>
                                        <button type="button" class="addr-search-btn" @click="fnSearchAddress">주소
                                            검색</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="storeArea">가게 지역:</label>
                            <select v-model="formData.storeArea" id="storeArea" required>
                                <option value="">지역을 선택하세요</option>
                                <option value="1">서울</option>
                                <option value="2">인천</option>
                                <option value="3">경기</option>
                                <option value="4">강원</option>
                                <option value="5">대전/세종/충청</option>
                                <option value="6">광주/전북/전남</option>
                                <option value="7">부산/대구/울산</option>
                                <option value="8">경북/경남</option>
                                <option value="9">제주</option>
                            </select>
                        </div>

                        <button type="submit" class="submit-btn">다음으로</button>
                    </form>
                </div>
                <div style="text-align: center; margin-bottom: 30px;">신청하신 입점 정보는 제출 후 관리자의 승인 절차를 거쳐야 하며, 승인 완료 시에만 상품 판매가 가능합니다.</div>
            </div>
            <%@ include file="/WEB-INF/main/footer.jsp" %>
                <script>
                    const app = Vue.createApp({
                        data() {
                            return {
                                formData: {
                                    userId: "${sessionId}",
                                    storeName: '<%= request.getParameter("storeName") != null ? request.getParameter("storeName") : "" %>',
                                    businessNo: '',
                                    storeIntro: '',
                                    deliveryYn: 'Y',
                                    isChatEnabled: 'N',
                                    chatStart: '09:00',
                                    chatEnd: '18:00',
                                    storeAddr: '', // 주소 API 결과를 받을 필드 (메인 주소 역할)
                                    storeArea: '',
                                    storePass: 'G',
                                    rejectReason: '(null)',
                                    gradeCode: 'A',
                                    membership: 'N',          
                                },

                                // 사업자번호 중복확인 관련
                                    isBusinessNoChecked: false, // 중복확인 완료 여부 플래그
                                    bizCheckMsg: '',           // 화면에 보여줄 메시지
                                    bizCheckColor: '',         // 메시지 색상 ('red' 또는 'green')
                            };
                        },
                        methods: {

                            // 사업자번호 중복확인
                            fnCheckBusinessNo() {
                                const self = this;

                                if(!this.formData.businessNo) {
                                    alert("사업자 번호를 입력해주세요.");
                                    return;
                                }

                                // 10자리 숫자 정규식 검사
                                const bizNoRegExp = /^[0-9]{10}$/;
                                if (!bizNoRegExp.test(this.formData.businessNo)) {
                                    alert("사업자등록번호는 숫자 10자리로 입력해주세요.");
                                    return;
                                }

                                // XXX-XX-XXXXX 형식으로 변환 (DB 확인용)
                                const formattedNo = self.formData.businessNo.replace(/(\d{3})(\d{2})(\d{5})/, '$1-$2-$3');

                                // 콘솔에서 변환된 형식이 XXX-XX-XXXXX 인지 확인해보세요!
                                console.log("변환된 번호:", formattedNo);

                                $.ajax({
                                    url: '/checkBizNo', 
                                    type: 'POST',
                                    data: { businessNo: formattedNo },
                                    success: function(res) {
                                        // 결과 처리 (res가 0이면 중복 없음, 1이상이면 중복)
                                        if (res === 0) {
                                            self.bizCheckMsg = "사용 가능한 사업자 번호입니다.";
                                            self.bizCheckColor = "green";
                                            self.isBusinessNoChecked = true; // 플래그 true (입력창 비활성화)
                                            
                                            // 실제 DB에 보낼 때는 하이픈이 포함된 값을 formData에 넣음
                                            self.formData.businessNo = formattedNo; 
                                        } else {
                                            self.bizCheckMsg = "중복된 사업자 번호입니다.";
                                            self.bizCheckColor = "red";
                                            self.isBusinessNoChecked = false; // 플래그 false 유지
                                        }
                                    },
                                    error: function(err) {
                                        alert("중복 확인 중 오류가 발생했습니다.");
                                    }
                                });
                            },


                            /**
                             * 🌟 주소 검색 처리 함수 (카카오/Daum Postcode API 연동)
                             * 우편번호와 상세 주소 필드는 제외하고, 검색된 전체 주소만 storeAddr에 반영합니다.
                             */
                            fnSearchAddress() {
                                const self = this;
                                new daum.Postcode({
                                    oncomplete: function (data) {
                                        // 도로명 주소(roadAddr) 또는 지번 주소(jibunAddr) 중 선택된 것을 사용
                                        let mainAddr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;

                                        // 🌟 Vue 데이터에 주소 값 반영
                                        self.formData.storeAddr = mainAddr;

                                        // console.log("✅ 주소 검색 완료 (storeAddr에 전체 주소 반영):", mainAddr);
                                    }
                                }).open({
                                    // 팝업 중앙 정렬 옵션 (모바일 대응에 유리)
                                    popupName: 'postcodePopup'
                                });
                            },

                            /**
                             * 다음 페이지(이미지 등록 페이지)로 이동 (데이터는 AJAX로 먼저 전송)
                             */
                            nextPage() {
                                const self = this;
                                const storeData = self.formData;

                                // 필수 입력값 체크 로직 (storeAddr 포함)
                                const requiredFields = ['userId', 'storeName', 'businessNo', 'storeIntro', 'deliveryYn', 'isChatEnabled', 'storeAddr', 'storeArea'];

                                for (const field of requiredFields) {
                                    if (!storeData[field] || String(storeData[field]).trim() === '') {
                                        alert('모든 필수 항목을 입력해주세요. (주소 포함)');
                                        return;
                                    }
                                }
                                
                                // 추가) 사업자등록번호 중복확인 여부 체크
                                if (!this.isBusinessNoChecked) {
                                    alert("사업자등록번호 중복 확인을 완료해주세요.");
                                    return;
                                }

                                // 채팅 가능인데 시작/종료 시간 없을 경우 체크
                                if (storeData.isChatEnabled === 'Y') {
                                    if (!storeData.chatStart || !storeData.chatEnd) {
                                        alert('채팅 가능을 선택한 경우, 채팅 시작 시간과 종료 시간을 설정해주세요.');
                                        return;
                                    }
                                }

                                // 시간 포맷 보정 (서버 형식에 맞게 초까지 채워줌)
                                if (storeData.chatStart.length <= 5) storeData.chatStart += ':00';
                                if (storeData.chatEnd.length <= 5) storeData.chatEnd += ':00';

                                // 채팅 불가능일 경우 시간 필드를 서버에서 무시하거나, 기본값으로 채우기
                                if (storeData.isChatEnabled === 'N') {
                                    storeData.chatStart = '00:00:00';
                                    storeData.chatEnd = '00:00:00';
                                }

                                // console.log("AJAX 전송 데이터:", storeData);

                                $.ajax({
                                    url: '/saveStoreInfo',
                                    type: 'POST',
                                    contentType: "application/json",
                                    data: JSON.stringify(storeData),
                                    dataType: "json",
                                    success: (response) => {
                                        if (response.success) {
                                            alert('가게 기본 정보가 성공적으로 저장되었습니다. 다음 단계로 이동합니다.');

                                            // 1. Form 태그 생성
                                            const form = document.createElement('form');
                                            form.setAttribute('method', 'post');
                                            form.setAttribute('action', '/applyStore/img.do'); // 다음 Controller URL

                                            // 2. storeName Hidden Input 생성
                                            const hiddenField = document.createElement('input');
                                            hiddenField.setAttribute('type', 'hidden');
                                            hiddenField.setAttribute('name', 'storeName'); // Controller @RequestParam 이름과 일치
                                            hiddenField.setAttribute('value', self.formData.storeName);

                                            // 3. Form 제출
                                            form.appendChild(hiddenField);
                                            document.body.appendChild(form);
                                            form.submit();

                                        } else {
                                            alert('입력된 정보를 확인해주세요. (서버 응답 오류)');
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        alert('서버 요청 중 오류 발생: ' + error);
                                        console.error('Ajax Error:', xhr.responseText);
                                    }
                                });
                            }
                        }
                    });
                    app.mount('#app');
                </script>
    </body>

    </html>