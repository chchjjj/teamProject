<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/main/header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가게 이미지 업로드</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <style>
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        .form-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 40px 50px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
        }
        .info-section {
            background-color: #f0f3f6;
            border-left: 5px solid #4CAF50;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        .file-upload-section {
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .upload-btn {
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            font-size: 0.95em;
            border: none;
        }
        .submit-btn, .fetch-btn {
            width: 100%;
            padding: 14px 0;
            background-color: #000;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
            margin-top: 10px;
        }
        .fetch-btn {
            background-color: #4CAF50;
        }
        .fetch-btn:hover {
            background-color: #43a047;
        }
        .submit-btn:hover {
            background-color: #333;
        }
        .result-box {
            margin-top: 15px;
            padding: 10px;
            background-color: #eaf0f6;
            border-left: 4px solid #4CAF50;
            border-radius: 6px;
        }
        .store-id-box {
            margin-top: 15px;
        }
        .store-id-box input {
            width: 100%;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 1em;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="form-container">
        <div class="info-section">
            <h3>가게 이미지 업로드</h3>
            <p><strong>유저 아이디:</strong> {{ userId }}</p>
            <input type="hidden" id="userId" v-model="userId">
            <div>
                <button type="button" class="fetch-btn" @click="fetchStoreId">가게 번호 조회</button>
                <div class="result-box" v-if="storeId !== null">
                    <strong>조회된 가게 번호:</strong> {{ storeId }}
                </div>
                <div class="result-box" v-if="storeId === null && searched">
                    조회된 가게가 없습니다.
                </div>
                <!-- 테스트용 가게번호 입력박스 -->
                <div class="store-id-box">
                    <label for="storeIdInput">가게 번호 (테스트용, 수정 불가):</label>
                    <input type="text" id="storeIdInput" v-model="storeId" readonly placeholder="조회 후 자동 입력됨">
                </div>
            </div>
        </div>

        <form @submit.prevent="submitForm">
            <div class="file-upload-section">
                <label for="profileImage" class="upload-btn">프로필 이미지 (160x160)</label>
                <input type="file" id="profileImage" @change="handleFileChange('profileImage')" hidden>
                <span>{{ profileImageName }}</span>
            </div>
            <div class="file-upload-section">
                <label for="bannerImage" class="upload-btn">배너 이미지</label>
                <input type="file" id="bannerImage" @change="handleFileChange('bannerImage')" hidden>
                <span>{{ bannerImageName }}</span>
            </div>
            <button type="submit" class="submit-btn">입점 신청</button>
        </form>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            userId: new URLSearchParams(window.location.search).get('userId'),
            storeId: null,
            searched: false,
            profileImageName: '선택된 파일 없음',
            bannerImageName: '선택된 파일 없음',
            files: {
                profileImage: null,
                bannerImage: null
            }
        };
    },
    methods: {
        fetchStoreId() {
            if (!this.userId) {
                alert('유저 아이디가 존재하지 않습니다.');
                return;
            }

            $.ajax({
                url: '/getStoreIdByUserId.do',  // 서버에서 처리할 URL
                type: 'GET',
                data: { userId: this.userId },
                dataType: 'json',
                success: (response) => {
                    this.searched = true;
                    if (response.success && response.storeId) {
                        this.storeId = response.storeId; // 테스트 박스에도 자동 입력됨
                    } else {
                        this.storeId = null;
                    }
                },
                error: (xhr, status, error) => {
                    alert('서버 오류 발생: ' + error);
                    console.error(xhr.responseText);
                }
            });
        },
        handleFileChange(fileType) {
            const file = document.getElementById(fileType).files[0];
            if (file) {
                this.files[fileType] = file;
                this[fileType + 'Name'] = file.name;
            } else {
                this.files[fileType] = null;
                this[fileType + 'Name'] = '선택된 파일 없음';
            }
        },
        submitForm() {
            if (!this.userId) {
                alert('유저 아이디가 존재하지 않습니다.');
                return;
            }
            if (!this.storeId) {
                alert('먼저 가게 번호를 조회해주세요.');
                return;
            }

            const formData = new FormData();
            formData.append('profileImage', this.files.profileImage);
            formData.append('bannerImage', this.files.bannerImage);
            formData.append('userId', this.userId);
            formData.append('storeId', this.storeId);

            $.ajax({
                url: '/saveStoreImages.do',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success(response) {
                    alert(response.success ? '입점 신청이 완료되었습니다.' : '이미지 업로드 실패');
                },
                error() {
                    alert('서버 오류가 발생했습니다.');
                }
            });
        }
    }
});
app.mount('#app');
</script>
</body>
</html>
