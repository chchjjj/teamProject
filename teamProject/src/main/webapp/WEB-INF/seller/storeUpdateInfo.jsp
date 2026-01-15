<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>가게 정보 수정 - DessertLab</title>
            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
            <style>
                body {
                    font-family: 'Noto Sans KR', 'Malgun Gothic', sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #fffaf8;
                }

                .container {
                    display: flex;
                    gap: 20px;
                    max-width: 1200px;
                    margin: 40px auto;
                    padding: 0 20px;
                }

                .sidebar {
                    width: 240px;
                    min-width: 240px;
                    flex-shrink: 0;
                    background: linear-gradient(180deg, #fffdf5 0%, #fff7e5 100%);
                    padding: 20px 0;
                    border-radius: 12px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                }

                .content {
                    flex-grow: 1;
                    background: #fff;
                    padding: 30px 40px;
                    border-radius: 12px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                }

                h2 {
                    font-size: 1.4em;
                    font-weight: 700;
                    border-left: 5px solid #f3b8a0;
                    padding-left: 10px;
                    margin-bottom: 20px;
                }

                .tabs {
                    display: flex;
                    border-bottom: 2px solid #f3e5dc;
                    margin-bottom: 20px;
                }

                .tab-button {
                    padding: 8px 16px;
                    border: none;
                    background: none;
                    cursor: pointer;
                    font-size: 0.95em;
                    color: #8c6e5a;
                    font-weight: 500;
                    margin-right: 5px;
                    border-radius: 4px 4px 0 0;
                    border-bottom: 3px solid transparent;
                }

                .tab-button.active {
                    color: #d77b66;
                    border-bottom: 3px solid #d77b66;
                    font-weight: 700;
                }

                .edit-form {
                    display: flex;
                    flex-direction: column;
                    gap: 4px;
                }

                .form-group {
                    display: flex;
                    flex-wrap: wrap;
                    align-items: center;
                    gap: 10px;
                    padding: 10px 0;
                    border-bottom: 1px solid #f5eee9;
                }

                .form-group:last-of-type {
                    border-bottom: none;
                }

                .form-group label {
                    width: 120px;
                    min-width: 120px;
                    font-weight: 600;
                    color: #5a3921;
                    font-size: 0.95em;
                    flex-shrink: 0;
                }

                .form-group input:not([type="button"]):not([type="submit"]),
                .form-group textarea {
                    flex: 1;
                    padding: 8px 12px;
                    border: 1px solid #e6d7ce;
                    border-radius: 6px;
                    font-size: 0.9em;
                    background-color: #fffaf8;
                    min-width: 150px;
                    box-sizing: border-box;
                }

                .form-group input:focus,
                .form-group textarea:focus {
                    border-color: #d77b66;
                    box-shadow: 0 0 0 3px rgba(215, 123, 102, 0.1);
                    outline: none;
                }

                textarea {
                    min-height: 100px;
                    resize: vertical;
                }

                .btn-action,
                .btn-secondary,
                .btn-primary {
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-weight: 600;
                    padding: 8px 14px;
                    font-size: 0.9em;
                    transition: all 0.2s ease;
                }

                .btn-action {
                    background-color: #d77b66;
                    color: #fff;
                }

                .btn-action:hover {
                    background-color: #b75a48;
                }

                .btn-secondary {
                    background-color: #b8b0aa;
                    color: #fff;
                }

                .btn-secondary:hover {
                    background-color: #9a9088;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #d77b66, #b75a48);
                    color: #fff;
                    font-size: 1em;
                    padding: 12px 28px;
                    box-shadow: 0 4px 10px rgba(215, 123, 102, 0.2);
                }

                .btn-primary:hover {
                    background: linear-gradient(135deg, #c96c57, #a54a3c);
                }

                .form-group.address-group {
                    padding: 3px 0;
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 0;
                }

                .form-group.address-group>label {
                    display: block;
                    width: 100%;
                    margin-bottom: 4px;
                }

                .address-line {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    width: 100%;
                }

                .address-line input {
                    padding: 8px 12px;
                    border-radius: 6px;
                    border: 1px solid #e6d7ce;
                    background-color: #fffaf8;
                }

                /* 우편번호, 상세 주소 필드를 삭제했으므로 관련 CSS는 삭제 */
                .address-line input#store-main-addr {
                    flex-grow: 2;
                    min-width: 180px;
                }

                .address-btn {
                    width: 100%;
                    margin-top: 0px;
                    padding: 10px 15px;
                }

                .submit-area {
                    margin-top: 30px;
                    text-align: center;
                }

                .radio-group {
                    display: flex;
                    gap: 20px;
                    align-items: center;
                    flex: 1;
                }

                .radio-group label {
                    width: auto;
                    min-width: unset;
                }

                /* ===== 9. 가게 이미지 업로드 영역 ===== */

                .image-upload-group {
                    display: flex;
                    align-items: flex-start;
                    gap: 20px;
                    padding: 15px 0;
                    border-bottom: 1px solid #f5eee9;
                }

                .image-upload-group label {
                    width: 120px;
                    font-weight: 600;
                    color: var(--color-text-main);
                    font-size: 0.95em;
                }

                .image-upload-box {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .image-preview {
                    background-color: #f8f4f1;
                    border: 1px dashed #e0cfc2;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    overflow: hidden;
                }

                /* 프로필 이미지 (정사각형) */
                .image-preview.profile {
                    width: 120px;
                    height: 120px;
                    border-radius: 8px;
                }

                /* 배너 이미지 (가로형) */
                .image-preview.banner {
                    width: 320px;
                    height: 120px;
                    border-radius: 8px;
                }

                .image-preview img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .image-upload-box input[type="file"] {
                    font-size: 0.85em;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <main class="content">
                    <h2>가게 정보 수정</h2>
                    <div class="tabs">
                        <button class="tab-button" onclick="location.href='/seller/userUpdateInfo.do'">개인 정보 수정
                            (USER_TBL)</button>
                        <button class="tab-button active" onclick="location.href='/seller/storeInfoupdateInfo.do'">가게 정보
                            수정 (SELLER_INFO_TBL)</button>
                    </div>
                    <hr>
                    <form action="/store/update.dox" method="POST" enctype="multipart/form-data" class="edit-form"
                        id="storeEditForm">


                        <input type="hidden" name="userId" value="${sessionId}">
                        <input type="hidden" id="initial-store-id"
                            value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}">
                        <input type="hidden" id="store-zipcode" name="storeZipcode"
                            value="${store.storeZipcode != null ? store.storeZipcode : ''}">
                        <input type="hidden" id="store-detail-addr" name="storeAddrDetail"
                            value="${store.storeAddrDetail != null ? store.storeAddrDetail : ''}">

                        <div class="form-group">
                            <label for="store-id">가게 번호 (STORE_ID)</label>
                            <input type="text" id="store-id" name="storeId"
                                value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}"
                                placeholder="수정할 가게 번호를 반드시 입력하세요.">
                            <button type="button" class="btn-secondary" onclick="fnSearchStoreInfoById()">가게 정보
                                조회</button>
                        </div>
                        <div class="form-group">
                            <label for="store-name">가게 이름</label>
                            <input type="text" id="store-name" name="storeName"
                                value="${store.storeName != null ? store.storeName : ''}">
                            <button type="button" class="btn-action" onclick="alert('전체 수정 버튼을 이용해주세요.')">개별 수정</button>
                        </div>

                        <div class="form-group">
                            <label>가게 주소 (Main)</label>
                            <input type="text" id="store-main-addr" name="storeAddrMain"
                                value="${store.storeAddrMain != null ? store.storeAddrMain : ''}"
                                placeholder="주소 검색을 통해 기본 주소를 입력하세요" readonly required>
                            <button type="button" class="btn-secondary" onclick="fnSearchAddress()">주소 검색</button>
                        </div>
                        <div class="form-group">
                            <label>배달 여부 </label>
                            <div class="radio-group">
                                <label><input type="radio" name="deliveryYn" value="Y" ${store.deliveryYn=='Y'
                                        ? 'checked' : (store.deliveryYn==null ? '' : '' )}> 가능</label>
                                <label><input type="radio" name="deliveryYn" value="N" ${store.deliveryYn=='N'
                                        ? 'checked' : (store.deliveryYn==null ? 'checked' : '' )}> 불가능</label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>채팅 여부 (`chatYn`)</label>
                            <div class="radio-group">
                                <label><input type="radio" name="chatYn" value="Y" ${store.chatYn=='Y' ? 'checked' :
                                        (store.chatYn==null ? 'checked' : '' )}> 가능</label>
                                <label><input type="radio" name="chatYn" value="N" ${store.chatYn=='N' ? 'checked' :
                                        (store.chatYn==null ? '' : '' )}> 불가능</label>
                            </div>
                        </div>
                        <div class="form-group store-intro-group">
                            <label for="store-intro">가게 소개</label>
                            <textarea id="store-intro" name="storeIntro"
                                placeholder="가게 소개글을 입력하세요.">${store.storeIntro != null ? store.storeIntro : ''}</textarea>
                        </div>
                        <!-- 가게 프로필 이미지 등록 -->
                        <!-- <div class="image-upload-group">
                            <label>가게 프로필</label>
                            <div class="image-upload-box">
                                <div class="image-preview profile">
                                    <img id="storeProfilePreview" src="/img/default-profile.png" alt="가게 프로필 미리보기">
                                </div>
                                <input type="file" id="storeProfileImg" name="storeProfileImg" accept="image/*"
                                    onchange="previewImage(this, 'storeProfilePreview')">
                            </div>
                        </div> -->

                        <!-- 가게 배너 이미지 등록 -->
                        <!-- <div class="image-upload-group">
                            <label>가게 배너</label>
                            <div class="image-upload-box">
                                <div class="image-preview banner">
                                    <img id="storeBannerPreview" src="/img/default-banner.png" alt="가게 배너 미리보기">
                                </div>
                                <input type="file" id="storeBannerImg" name="storeBannerImg" accept="image/*"
                                    onchange="previewImage(this, 'storeBannerPreview')">
                            </div>
                        </div> -->

                        <div class="submit-area">
                            <button type="button" class="btn-primary" onclick="fnUpdateStoreInfo()">정보 수정하기</button>
                        </div>
                    </form>
                </main>
            </div>

            <script>
                // ✅ 가게 정보 조회
                function fnGetStoreInfo(storeId) {
                    if (!storeId || storeId.trim() === "") return;
                    $.ajax({
                        url: "/store/infoUpdate.dox",
                        dataType: "json",
                        type: "POST",
                        data: { storeId: parseInt(storeId, 10) }, // ✅ 숫자로 전송
                        success: function (data) {
                            let store = data.store;
                            if (!store) store = data;

                            $('#store-id').val(store.STORE_ID || '');
                            $('#store-name').val(store.STORE_NAME || '');
                            $('#store-main-addr').val(store.STORE_ADDR || '');

                            // 라디오 버튼 상태 갱신
                            $('input:radio[name=deliveryYn][value=' + (store.DELIVERY_YN || 'N') + ']').prop('checked', true);
                            $('input:radio[name=chatYn][value=' + (store.CHAT_YN || 'Y') + ']').prop('checked', true);

                            let storeIntro = store.STORE_INTRO || '';
                            try {
                                storeIntro = decodeURI(storeIntro.replace(/\\n/g, "%0A"));
                            } catch (e) { }

                            $('#store-intro').val(storeIntro);
                            //console.log("가게 정보 조회 성공:", store);
                        },
                        error: function (xhr, status, error) {
                            console.error("가게 정보 조회 실패:", error);
                            alert("가게 정보 조회에 실패했습니다. (서버 로그를 확인해주세요)");
                        }
                    });
                }

                // ✅ 입력된 STORE_ID로 가게 정보 조회
                function fnSearchStoreInfoById() {
                    const storeId = $('#store-id').val();
                    if (!storeId || storeId.trim() === '') {
                        alert("조회할 가게 번호를 입력해주세요.");
                        $('#store-id').focus();
                        return;
                    }
                    fnGetStoreInfo(storeId);
                }

                // ✅ 다음 우편번호 API
                function fnSearchAddress() {
                    new daum.Postcode({
                        oncomplete: function (data) {
                            const fullAddr = data.roadAddress || data.jibunAddress;
                            const extraAddr = (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) ? data.bname : '';

                            $('#store-zipcode').val(data.zonecode);
                            $('#store-main-addr').val(fullAddr);
                            $('#store-detail-addr').val('');
                            $('#store-detail-addr').focus();

                            alert(`주소 검색이 완료되었습니다. 상세 주소를 입력한 후 '정보 수정하기' 버튼을 눌러주세요. (우편번호: ${data.zonecode})`);
                        }
                    }).open();
                }

                // ✅ 가게 정보 수정
                function fnUpdateStoreInfo() {
                    const form = document.getElementById('storeEditForm');
                    const storeId = $('#store-id').val();

                    // 1. STORE_ID 검증
                    if (!storeId || storeId.trim() === '') {
                        alert("가게 번호 (STORE_ID)를 반드시 입력해야 합니다.");
                        $('#store-id').focus();
                        return;
                    }
                    if (isNaN(storeId.trim()) || !/^\d+$/.test(storeId.trim())) {
                        alert("가게 번호는 숫자만 입력해야 합니다.");
                        $('#store-id').focus();
                        return;
                    }

                    // 2. 필수 입력값 검증
                    const requiredFields = [
                        { id: 'store-name', msg: "가게 이름" },
                        { id: 'store-main-addr', msg: "가게 주소" },
                        { id: 'store-intro', msg: "가게 소개" }
                    ];

                    for (const field of requiredFields) {
                        const val = $('#' + field.id).val();
                        if (!val || val.trim() === '') {
                            alert(`${field.msg}을(를) 입력해주세요.`);
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

                    // ✅ FormData 생성 (파일 + 일반 데이터 포함)
                    const formData = new FormData(form);

                    // ✅ STORE_ID 숫자형 강제 처리 (Oracle 대비)
                    formData.set('storeId', parseInt(storeId.trim(), 10));

                    // (선택) 업로드 파일 로그 확인
                    /*
                    console.log("프로필 이미지:", $('#storeProfileImg')[0].files[0]);
                    console.log("배너 이미지:", $('#storeBannerImg')[0].files[0]);
                    */

                    // 3. AJAX 전송
                    $.ajax({
                        url: form.action,
                        type: form.method,
                        data: formData,
                        processData: false, // ❗ 필수
                        contentType: false, // ❗ 필수
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


                // ✅ 주소 개별 수정 버튼(대체 알림)
                function fnUpdateAddress() {
                    alert("주소는 '주소 검색' 버튼을 눌러 다시 설정할 수 있습니다. 변경 후 '정보 수정하기' 버튼을 눌러주세요.");
                }

                // ✅ 페이지 로드시 초기 STORE_ID 감지 후 자동 조회
                $(document).ready(function () {
                    const initialStoreId = $('#initial-store-id').val();
                    if (initialStoreId && initialStoreId.trim() !== "") {
                        // console.log("페이지 로드 시 감지된 STORE_ID:", initialStoreId);
                        fnGetStoreInfo(initialStoreId);
                    } else {
                        //console.log("페이지 로드 시 초기 STORE_ID가 감지되지 않았습니다.");
                    }
                });
                /**
 * 이미지 미리보기 공통 함수
 */
                function previewImage(input, previewId) {
                    if (!input.files || !input.files[0]) return;

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        $('#' + previewId).attr('src', e.target.result);
                    };
                    reader.readAsDataURL(input.files[0]);
                }

            </script>


        </body>

        </html>