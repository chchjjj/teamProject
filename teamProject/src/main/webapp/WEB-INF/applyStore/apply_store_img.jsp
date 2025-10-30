<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가게 이미지 업로드</title>
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

        .file-upload-section {
            margin-bottom: 30px;
            text-align: right;
        }

        .upload-btn {
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border-radius: 5px;
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

        .info-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f0f0f0;
            border-radius: 5px;
        }

        .info-section h3 {
            margin: 0;
            font-size: 1.2em;
        }
    </style>
</head>

<body>
    <div id="app">
        <!-- 가게 정보 표시 영역 -->
        <div class="form-container">
            <div class="info-section">
                <h3>가게 정보</h3>
                <p><strong>가게 번호:</strong> {{ storeId }}</p>
                <p><strong>가게 이름:</strong> {{ storeName }}</p>
                <p><strong>유저 아이디:</strong> {{ userId }}</p>
            </div>

            <form @submit.prevent="submitForm">
                <div class="file-upload-section">
                    <label for="profileImage" class="upload-btn">가게 프로필 이미지 업로드 (160 x 160)</label>
                    <input type="file" id="profileImage" @change="handleFileChange('profileImage')" hidden>
                    <span>{{ profileImageName }}</span>
                </div>
                <div class="file-upload-section">
                    <label for="bannerImage" class="upload-btn">가게 배너 이미지</label>
                    <input type="file" id="bannerImage" @change="handleFileChange('bannerImage')" hidden>
                    <span>{{ bannerImageName }}</span>
                </div>
                <button type="submit" class="submit-btn">입점신청</button>
            </form>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    profileImageName: '선택된 파일 없음',
                    bannerImageName: '선택된 파일 없음',
                    files: {
                        profileImage: null,
                        bannerImage: null
                    },
                    storeId: '${storeId}',           // JSP에서 가져온 가게 번호
                    storeName: '${storeName}',       // JSP에서 가져온 가게 이름
                    userId: '${userId}'         // JSP에서 가져온 유저 아이디
                };
            },
            methods: {
                handleFileChange(fileType) {
                    const fileInput = document.getElementById(fileType);
                    const file = fileInput.files[0];
                    if (file) {
                        this.files[fileType] = file;
                        if (fileType === 'profileImage') {
                            this.profileImageName = file.name;
                        } else if (fileType === 'bannerImage') {
                            this.bannerImageName = file.name;
                        }
                    } else {
                        this.files[fileType] = null;
                        if (fileType === 'profileImage') {
                            this.profileImageName = '선택된 파일 없음';
                        } else if (fileType === 'bannerImage') {
                            this.bannerImageName = '선택된 파일 없음';
                        }
                    }
                },
                submitForm() {
                    let formData = new FormData();
                    formData.append('profileImage', this.files.profileImage);
                    formData.append('bannerImage', this.files.bannerImage);

                    $.ajax({
                        url: '/saveStoreImages.do', // 서버에 이미지 저장 요청
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (response) {
                            if (response.success) {
                                alert('입점 신청이 완료되었습니다.');
                            } else {
                                alert('이미지 업로드 실패');
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
