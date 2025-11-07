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
        <style>

            body{
                background-color: #f1f1f1;
            }

            .form-container {
                max-width: 650px;
                /* margin: 60px auto; */
                margin-top: 5px;
                margin-bottom: 60px;
                margin-left: auto;
                margin-right: auto;
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
            .submit-btn {
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

            .submit-btn:hover {
                background-color: #3E2723;
                transform: translateY(-1px);
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
            #storeAddr,
            #storeArea {
                margin-top: 4px;
            }

            /* ===== 입점 신청하기 제목 스타일 ===== */
            .apply-title {
                text-align: center;
                font-size: 25px;
                font-weight: 700;
                color: #3E2723;
                margin-top: 20px;
                margin-bottom: 10px;
                letter-spacing: -0.5px;
            }

            .infoImage{
                align-items: center;
                width: 100%;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <h3 class="apply-title">입점 신청</h3>
                <div class="form-container">
                    <img class=infoImage src="/img/입점광고.jpg" alt="입점신청배너">
                    <form @submit.prevent="nextPage">
                        <div class="form-group">
                            <label for="userId">유저 ID :</label>
                            <input type="text" v-model="formData.userId" id="userId" required>
                        </div>

                        <div class="form-group">
                            <label for="storeName">가게명:</label>
                            <input type="text" v-model="formData.storeName" id="storeName" required>
                        </div>

                        <div class="form-group">
                            <label for="businessNo">사업자등록번호:</label>
                            <input type="text" v-model="formData.businessNo" id="businessNo" required>
                        </div>

                        <div class="form-group">
                            <label for="storeIntro">가게소개:</label>
                            <textarea v-model="formData.storeIntro" id="storeIntro" required></textarea>
                        </div>

                        <div class="form-group">
                            <label>배송가능여부:</label><br>
                            <label><input type="radio" v-model="formData.deliveryYn" value="Y" required> 가능</label>
                            <label><input type="radio" v-model="formData.deliveryYn" value="N" required> 불가능</label>
                        </div>

                        <div class="form-group">
                            <label>채팅가능여부:</label><br>
                            <label><input type="radio" v-model="formData.isChatEnabled" value="Y" required> 가능</label>
                            <label><input type="radio" v-model="formData.isChatEnabled" value="N" required> 불가능</label>
                        </div>

                        <div class="form-group" v-if="formData.isChatEnabled === 'Y'">
                            <label for="chatStart">채팅 시작시간:</label>
                            <input type="time" v-model="formData.chatStart" id="chatStart" required>
                            ~
                            <label for="chatEnd">채팅 종료시간:</label>
                            <input type="time" v-model="formData.chatEnd" id="chatEnd" required>
                        </div>

                        <div class="form-group">
                            <label for="storeAddr">가게주소:</label>
                            <input type="text" v-model="formData.storeAddr" id="storeAddr" required>
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
            </div>
            <%@ include file="/WEB-INF/main/footer.jsp" %>
              <script>
    const app = Vue.createApp({
        data() {
            return {
                formData: {
                    userId: "${sessionId}",
                    // JSP Expression을 통해 URL 파라미터 값(storeName)을 안전하게 가져옵니다.
                    storeName: '<%= request.getParameter("storeName") != null ? request.getParameter("storeName") : "" %>',
                    businessNo: '',
                    storeIntro: '',
                    deliveryYn: 'Y',
                    isChatEnabled: 'N',
                    chatStart: '09:00',
                    chatEnd: '18:00',
                    storeAddr: '',
                    storeArea: '',
                    storePass: 'G',
                    rejectReason: '(null)',
                    gradeCode: 'A',
                    membership: 'N'
                }
            };
        },
        methods: {
            nextPage() {
                const self = this; // AJAX 성공 시 Vue 인스턴스에 접근하기 위해 사용
                const storeData = self.formData;
                
                // v-model로 바인딩된 값이 아직 반영 안 됐을 경우를 대비한 보험 코드 (유지)
                if (!storeData.storeName || storeData.storeName.trim() === '') {
                    storeData.storeName = document.getElementById('storeName').value.trim();
                }

                // 필수 입력값 체크 로직 (유지)
                for (const [key, value] of Object.entries(storeData)) {
                    if (value === '' || value == null) {
                        alert('모든 필수 항목을 입력해주세요.');
                        return;
                    }
                }

                console.log("AJAX 요청 전 storeName 값:", storeData.storeName);

                // 시간 포맷 보정 (유지)
                if (storeData.chatStart.length <= 5) storeData.chatStart += ':00';
                if (storeData.chatEnd.length <= 5) storeData.chatEnd += ':00';

                $.ajax({
                    url: '/saveStoreInfo',
                    type: 'POST',
                    contentType: "application/json",
                    data: JSON.stringify(storeData),
                    dataType: "json",
                    success: (response) => {
                        if (response.success) {
                            // ⭐⭐⭐ 핵심 수정 부분: Hidden Form을 만들어 POST로 다음 페이지 이동 ⭐⭐⭐
                            const currentStoreName = self.formData.storeName; 
                            
                            console.log("--- POST 전송 시작 ---");
                            console.log("   - 전송할 storeName 값:", currentStoreName);
                            
                            // 1. Form 태그 생성
                            const form = document.createElement('form');
                            form.setAttribute('method', 'post'); // POST 방식 명시
                            form.setAttribute('action', '/applyStore/img.do'); // 다음 Controller URL
                            
                            // 2. storeName Hidden Input 생성
                            const hiddenField = document.createElement('input');
                            hiddenField.setAttribute('type', 'hidden');
                            hiddenField.setAttribute('name', 'storeName'); // Controller @RequestParam 이름과 일치
                            hiddenField.setAttribute('value', currentStoreName); // 실제 값 (인코딩 불필요)
                            
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