<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가게 정보 수정 - DessertLab</title>
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <style>
        :root {
            --color-primary: #d77b66;
            --color-secondary: #b8b0aa;
            --color-text-main: #5a3921;
            --color-bg-light: #fffaf8;
            --color-bg-page: #faf7f5;
            --color-bg-content: #fff;
            --color-border: #f3e5dc;
            --color-accent: #f3b8a0;
        }

        body {
            font-family: 'Noto Sans KR', 'Malgun Gothic', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--color-bg-page);
            color: #333;
        }

        .container {
            display: flex;
            gap: 20px;
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .content {
            flex-grow: 1;
            background: var(--color-bg-content);
            padding: 40px 50px;
            border-radius: 16px;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.06);
        }

        .content h2 {
            font-size: 1.8em;
            font-weight: 700;
            color: var(--color-text-main);
            margin-bottom: 10px;
            padding-bottom: 15px;
            border-bottom: 3px solid var(--color-accent);
        }

        .tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--color-border);
        }

        .tab-button {
            padding: 12px 20px;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 0.95em;
            color: #8c6e5a;
            font-weight: 500;
            border-radius: 8px 8px 0 0;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .tab-button.active {
            background-color: #fff5f0;
            border-bottom: 3px solid var(--color-primary);
            font-weight: 700;
            color: var(--color-primary);
        }

        .tab-button:hover:not(.active) {
            background-color: #fafafa;
        }

        .edit-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-group {
            display: grid;
            grid-template-columns: 140px 1fr auto;
            align-items: center;
            gap: 15px;
            padding: 18px 20px;
            background-color: #fafafa;
            border-radius: 10px;
            transition: all 0.2s ease;
        }

        .form-group:hover {
            background-color: #f5f5f5;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .form-group label {
            font-weight: 600;
            color: var(--color-text-main);
            font-size: 0.95em;
        }

        .form-group input:not([type="button"]):not([type="submit"]):not([type="radio"]),
        .form-group textarea {
            padding: 10px 14px;
            border: 1px solid #e6d7ce;
            border-radius: 8px;
            font-size: 0.95em;
            background-color: var(--color-bg-content);
            transition: all 0.2s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(215, 123, 102, 0.1);
            outline: none;
            background-color: #fff;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
            grid-column: 2 / 4;
        }

        /* 라디오 버튼 그룹 */
        .radio-group {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .radio-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
        }

        .radio-group input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--color-primary);
        }

        /* 주소 그룹 */
        .form-group.address-group {
            grid-template-columns: 140px 1fr;
        }

        .address-content {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .address-content input {
            flex: 1;
        }

        /* 가게 소개 그룹 */
        .form-group.store-intro-group {
            grid-template-columns: 140px 1fr;
            align-items: flex-start;
        }

        .form-group.store-intro-group label {
            padding-top: 10px;
        }

        /* 이미지 업로드 그룹 */
        .image-upload-group {
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 15px;
            padding: 18px 20px;
            background-color: #fafafa;
            border-radius: 10px;
        }

        .image-upload-group label {
            font-weight: 600;
            color: var(--color-text-main);
            font-size: 0.95em;
        }

        .image-upload-box {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .image-preview {
            background: linear-gradient(135deg, #f8f4f1 0%, #faf6f3 100%);
            border: 2px dashed #e0cfc2;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .image-preview:hover {
            border-color: var(--color-primary);
            box-shadow: 0 4px 12px rgba(215, 123, 102, 0.1);
        }

        .image-preview.profile {
            width: 140px;
            height: 140px;
        }

        .image-preview.banner {
            width: 100%;
            max-width: 400px;
            height: 150px;
        }

        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-upload-box input[type="file"] {
            font-size: 0.9em;
            padding: 8px;
            border: 1px solid #e6d7ce;
            border-radius: 8px;
            cursor: pointer;
        }

        .image-upload-box input[type="file"]::-webkit-file-upload-button {
            background-color: var(--color-secondary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            margin-right: 10px;
        }

        /* 버튼 스타일 */
        .btn-action,
        .btn-secondary {
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            padding: 10px 18px;
            font-size: 0.9em;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .btn-action {
            background-color: var(--color-primary);
            color: #fff;
            box-shadow: 0 2px 6px rgba(215, 123, 102, 0.2);
        }

        .btn-action:hover {
            background-color: #c96c57;
            box-shadow: 0 4px 10px rgba(215, 123, 102, 0.3);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: var(--color-secondary);
            color: #fff;
        }

        .btn-secondary:hover {
            background-color: #9a9088;
        }

        /* 제출 버튼 */
        .submit-area {
            margin-top: 40px;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #d77b66, #b75a48);
            color: #fff;
            font-size: 1.05em;
            padding: 15px 50px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(215, 123, 102, 0.3);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #c96c57, #a54a3c);
            box-shadow: 0 6px 20px rgba(215, 123, 102, 0.4);
            transform: translateY(-2px);
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .form-group {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .address-content {
                flex-direction: column;
                align-items: stretch;
            }

            .image-preview.banner {
                width: 100%;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <main class="content">
            <h2>가게 정보 수정</h2>

            <div class="tabs">
                <button class="tab-button" onclick="location.href='/seller/userUpdateInfo.do'">
                    개인 정보 수정
                </button>
                <button class="tab-button active" onclick="location.href='/seller/storeInfoupdateInfo.do'">
                    가게 정보 수정
                </button>
            </div>

            <form action="/store/update.dox" method="POST" enctype="multipart/form-data" class="edit-form" id="storeEditForm">
                <input type="hidden" name="userId" value="${sessionId}">
                <input type="hidden" id="initial-store-id" value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}">
                <input type="hidden" id="store-zipcode" name="storeZipcode" value="${store.storeZipcode != null ? store.storeZipcode : ''}">
                <input type="hidden" id="store-detail-addr" name="storeAddrDetail" value="${store.storeAddrDetail != null ? store.storeAddrDetail : ''}">

                <div class="form-group">
                    <label for="store-id">가게 번호</label>
                    <input type="text" id="store-id" name="storeId" value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}" placeholder="가게 번호를 입력하세요">
                    <button type="button" class="btn-secondary" onclick="fnSearchStoreInfoById()">조회</button>
                </div>

                <div class="form-group">
                    <label for="store-name">가게 이름</label>
                    <input type="text" id="store-name" name="storeName" value="${store.storeName != null ? store.storeName : ''}" placeholder="가게 이름">
                    <button type="button" class="btn-action" onclick="alert('전체 수정 버튼을 이용해주세요.')">개별 수정</button>
                </div>

                <div class="form-group address-group">
                    <label>가게 주소</label>
                    <div class="address-content">
                        <input type="text" id="store-main-addr" name="storeAddrMain" value="${store.storeAddrMain != null ? store.storeAddrMain : ''}" placeholder="주소 검색을 통해 입력하세요" readonly required>
                        <button type="button" class="btn-secondary" onclick="fnSearchAddress()">주소 검색</button>
                    </div>
                </div>

                <div class="form-group">
                    <label>배달 가능 여부</label>
                    <div class="radio-group">
                        <label>
                            <input type="radio" name="deliveryYn" value="Y" ${store.deliveryYn=='Y' ? 'checked' : ''}>
                            배달 가능
                        </label>
                        <label>
                            <input type="radio" name="deliveryYn" value="N" ${store.deliveryYn=='N' ? 'checked' : (store.deliveryYn==null ? 'checked' : '')}>
                            배달 불가
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label>채팅 가능 여부</label>
                    <div class="radio-group">
                        <label>
                            <input type="radio" name="chatYn" value="Y" ${store.chatYn=='Y' ? 'checked' : (store.chatYn==null ? 'checked' : '')}>
                            채팅 가능
                        </label>
                        <label>
                            <input type="radio" name="chatYn" value="N" ${store.chatYn=='N' ? 'checked' : ''}>
                            채팅 불가
                        </label>
                    </div>
                </div>

                <div class="form-group store-intro-group">
                    <label for="store-intro">가게 소개</label>
                    <textarea id="store-intro" name="storeIntro" placeholder="가게 소개글을 입력하세요">${store.storeIntro != null ? store.storeIntro : ''}</textarea>
                </div>

                <!-- 가게 프로필 이미지 (필요시 주석 해제) -->
                <!--
                <div class="image-upload-group">
                    <label>프로필 이미지</label>
                    <div class="image-upload-box">
                        <div class="image-preview profile">
                            <img id="storeProfilePreview" src="/img/default-profile.png" alt="프로필">
                        </div>
                        <input type="file" id="storeProfileImg" name="storeProfileImg" accept="image/*" onchange="previewImage(this, 'storeProfilePreview')">
                    </div>
                </div>
                -->

                <!-- 가게 배너 이미지 (필요시 주석 해제) -->
                <!--
                <div class="image-upload-group">
                    <label>배너 이미지</label>
                    <div class="image-upload-box">
                        <div class="image-preview banner">
                            <img id="storeBannerPreview" src="/img/default-banner.png" alt="배너">
                        </div>
                        <input type="file" id="storeBannerImg" name="storeBannerImg" accept="image/*" onchange="previewImage(this, 'storeBannerPreview')">
                    </div>
                </div>
                -->

                <div class="submit-area">
                    <button type="button" class="btn-primary" onclick="fnUpdateStoreInfo()">
                        가게 정보 수정하기
                    </button>
                </div>
            </form>
        </main>
    </div>

    <script>
        function fnGetStoreInfo(storeId) {
            if (!storeId || storeId.trim() === "") return;
            $.ajax({
                url: "/store/infoUpdate.dox",
                dataType: "json",
                type: "POST",
                data: { storeId: parseInt(storeId, 10) },
                success: function (data) {
                    let store = data.store || data;
                    
                    $('#store-id').val(store.STORE_ID || '');
                    $('#store-name').val(store.STORE_NAME || '');
                    $('#store-main-addr').val(store.STORE_ADDR || '');
                    
                    $('input:radio[name=deliveryYn][value=' + (store.DELIVERY_YN || 'N') + ']').prop('checked', true);
                    $('input:radio[name=chatYn][value=' + (store.CHAT_YN || 'Y') + ']').prop('checked', true);
                    
                    let storeIntro = store.STORE_INTRO || '';
                    try {
                        storeIntro = decodeURI(storeIntro.replace(/\\n/g, "%0A"));
                    } catch (e) {}
                    
                    $('#store-intro').val(storeIntro);
                },
                error: function (xhr, status, error) {
                    console.error("가게 정보 조회 실패:", error);
                    alert("가게 정보 조회에 실패했습니다.");
                }
            });
        }

        function fnSearchStoreInfoById() {
            const storeId = $('#store-id').val();
            if (!storeId || storeId.trim() === '') {
                alert("조회할 가게 번호를 입력해주세요.");
                $('#store-id').focus();
                return;
            }
            fnGetStoreInfo(storeId);
        }

        function fnSearchAddress() {
            new daum.Postcode({
                oncomplete: function (data) {
                    const fullAddr = data.roadAddress || data.jibunAddress;
                    $('#store-zipcode').val(data.zonecode);
                    $('#store-main-addr').val(fullAddr);
                    $('#store-detail-addr').val('');
                    $('#store-detail-addr').focus();
                    alert('주소 검색이 완료되었습니다. 상세 주소를 입력한 후 정보 수정하기 버튼을 눌러주세요.');
                }
            }).open();
        }

        function fnUpdateStoreInfo() {
            const form = document.getElementById('storeEditForm');
            const storeId = $('#store-id').val();

            if (!storeId || storeId.trim() === '') {
                alert("가게 번호를 입력해주세요.");
                $('#store-id').focus();
                return;
            }

            if (isNaN(storeId.trim()) || !/^\d+$/.test(storeId.trim())) {
                alert("가게 번호는 숫자만 입력해야 합니다.");
                $('#store-id').focus();
                return;
            }

            const requiredFields = [
                { id: 'store-name', msg: "가게 이름" },
                { id: 'store-main-addr', msg: "가게 주소" },
                { id: 'store-intro', msg: "가게 소개" }
            ];

            for (const field of requiredFields) {
                const val = $('#' + field.id).val();
                if (!val || val.trim() === '') {
                    alert(field.msg + '을(를) 입력해주세요.');
                    $('#' + field.id).focus();
                    return;
                }
            }

            if ($('input[name="deliveryYn"]:checked').length === 0) {
                alert("배달 여부를 선택해주세요.");
                return;
            }

            if ($('input[name="chatYn"]:checked').length === 0) {
                alert("채팅 여부를 선택해주세요.");
                return;
            }

            const formData = new FormData(form);
            formData.set('storeId', parseInt(storeId.trim(), 10));

            $.ajax({
                url: form.action,
                type: form.method,
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    if (response.result === 'success' || response.success) {
                        alert("가게 정보가 성공적으로 수정되었습니다.");
                        fnGetStoreInfo(formData.get('storeId'));
                    } else {
                        alert("정보 수정에 실패했습니다: " + (response.message || "서버 오류"));
                    }
                },
                error: function (xhr, status, error) {
                    console.error("서버 통신 오류:", xhr.responseText);
                    alert("서버 통신 오류로 정보 수정에 실패했습니다.");
                }
            });
        }

        function previewImage(input, previewId) {
            if (!input.files || !input.files[0]) return;
            const reader = new FileReader();
            reader.onload = function (e) {
                $('#' + previewId).attr('src', e.target.result);
            };
            reader.readAsDataURL(input.files[0]);
        }

        $(document).ready(function () {
            const initialStoreId = $('#initial-store-id').val();
            if (initialStoreId && initialStoreId.trim() !== "") {
                fnGetStoreInfo(initialStoreId);
            }
        });
    </script>
</body>
</html>