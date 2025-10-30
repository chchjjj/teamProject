<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

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
            .form-group textarea {
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
        </style>
    </head>

    <body>
        <div id="app">
            <div class="form-container">
                <form @submit.prevent="nextPage">
                    <div class="form-group">
                        <label for="storeName">가게명:</label>
                        <input type="text" v-model="formData.storeName" id="storeName" name="storeName" required>
                    </div>
                    <div class="form-group">
                        <label for="businessNumber">사업자등록번호:</label>
                        <input type="text" v-model="formData.businessNumber" id="businessNumber" name="businessNumber"
                            required>
                    </div>
                    <div class="form-group">
                        <label for="storeExplanation">가게소개:</label>
                        <textarea v-model="formData.storeExplanation" id="storeExplanation" name="storeExplanation"
                            required></textarea>
                    </div>
                    <div class="form-group">
                        <label>배송가능여부:</label>
                        <label><input type="radio" v-model="formData.delivery" value="Y" required> 가능</label>
                        <label><input type="radio" v-model="formData.delivery" value="N" required> 불가능</label>
                    </div>
                    <div class="form-group">
                        <label>채팅가능여부:</label>
                        <label><input type="radio" v-model="formData.chat" value="Y" required> 가능</label>
                        <label><input type="radio" v-model="formData.chat" value="N" required> 불가능</label>
                    </div>
                    <div class="form-group">
                        <label for="chatStart">채팅 시작시간:</label>
                        <input type="time" v-model="formData.chatStart" id="chatStart" required>
                        ~
                        <label for="chatEnd">채팅 종료시간:</label>
                        <input type="time" v-model="formData.chatEnd" id="chatEnd" required>
                    </div>
                    <div class="form-group">
                        <label for="storeAddress">가게주소:</label>
                        <input type="text" v-model="formData.storeAddress" id="storeAddress" required>
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
                            storeName: '',
                            businessNumber: '',
                            storeExplanation: '',
                            delivery: 'Y',
                            chat: 'Y',
                            chatStart: '',
                            chatEnd: '',
                            storeAddress: ''
                        }
                    };
                },
                methods: {
                    nextPage() {
                        // 세션에 가게 정보 저장 (서버에서 처리 후 리디렉션)
                        $.ajax({
                            url: '/saveStoreInfo', // 서버에 정보 저장 요청
                            type: 'POST',
                            data: this.formData,
                            success: function (response) {
                                if (response.success) {
                                    window.location.href = 'storeImage.jsp'; // 가게 이미지 업로드 페이지로 이동
                                } else {
                                    alert('입력된 정보를 확인해주세요.');
                                }
                            },
                            error: function () {
                                alert('서버 오류');
                            }
                        });
                    }
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>