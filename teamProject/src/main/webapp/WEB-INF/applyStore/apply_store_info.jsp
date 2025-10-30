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
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            background-color: #f7f7f7;
            padding: 20px;
        }

        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 40px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
        }

        .submit-btn {
            padding: 15px 40px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
        }

        .submit-btn:hover {
            background-color: #333;
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="form-container">
            <form @submit.prevent="nextPage">
                <div class="form-group">
                    <label for="userId">유저 ID (테스트용):</label>
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

                <div class="form-group">
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

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    formData: {
                        userId: '',
                        storeName: '',
                        businessNo: '',
                        storeIntro: '',
                        deliveryYn: 'Y',
                        isChatEnabled: 'Y',
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
                    const storeData = this.formData;

                    // 필수 입력값 체크
                    for (const [key, value] of Object.entries(storeData)) {
                        if (value === '' || value == null) {
                            alert('모든 필수 항목을 입력해주세요.');
                            return;
                        }
                    }

                    // 시간 포맷 보정 (HH:MM → HH:MM:SS)
                    if (storeData.chatStart.length <= 5) storeData.chatStart += ':00';
                    if (storeData.chatEnd.length <= 5) storeData.chatEnd += ':00';

                    $.ajax({
                        url: '/saveStoreInfo',
                        type: 'POST',
                        contentType: "application/json",
                        data: JSON.stringify(storeData),
                        dataType: "json",
                        success: function (response) {
                            if (response.success) {
                                
                                const userId = encodeURIComponent(storeData.userId);
                                
                                window.location.href = `/applyStore/img.do?userId=${userId}`;
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
