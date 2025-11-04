<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 사용자 요청에 따라 사이드바를 별도의 JSP 파일로 인클루드합니다. --%>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>가게 정보 수정 - DessertLab</title>
    
    <%-- JQuery 라이브러리 추가 (정보 조회 및 수정에 사용) --%>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

    <style>
    /* 기본 초기화 및 폰트 */
    body {
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f4;
        color: #333;
    }

    /* 1. 컨테이너: 사이드바와 콘텐츠를 가로로 배치 (수정 반영) */
    .container {
        display: flex;
        gap: 20px; 
        max-width: 1400px; 
        margin: 20px auto; 
        min-height: calc(100vh - 40px);
    }

    /* 2. 사이드바 (왼쪽 메뉴) 스타일 (수정 반영) */
    .sidebar {
        width: 250px;
        min-width: 250px;
        flex-shrink: 0; 
        background-color: #f8f8e0;
        padding: 20px 0;
        box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        box-sizing: border-box; 
        border-radius: 8px; 
    }

    /* (사이드바 내부 메뉴 스타일은 생략) */

    /* 3. 메인 콘텐츠 스타일 (수정 반영) */
    .content {
        flex-grow: 1; 
        background-color: #fff;
        padding: 40px;
        margin: 0; 
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
    }

    .content h2 {
        margin-top: 0;
        border-bottom: 2px solid #007bff;
        padding-bottom: 10px;
    }

    /* 탭 스타일 */
    .tabs { display: flex; margin-bottom: 20px; }
    .tab-button {
        padding: 10px 15px; border: none; background-color: #f0f0f0; cursor: pointer;
        font-size: 1em; margin-right: 5px; border-radius: 4px 4px 0 0;
        border-bottom: 3px solid transparent; transition: background-color 0.2s, border-bottom 0.2s;
    }
    .tab-button.store-active { 
        background-color: #fff; border-bottom: 3px solid #007bff; font-weight: bold; 
    }

    /* 4. 폼 스타일 */
    .edit-form { display: flex; flex-direction: column; }
    .form-group { display: flex; align-items: center; padding: 15px 0; border-bottom: 1px solid #eee; }
    .form-group:last-of-type { border-bottom: none; }
    .form-group label {
        width: 120px; min-width: 120px; font-weight: bold; flex-shrink: 0; padding-right: 20px; 
    }
    .form-group input:not([type="button"]):not([type="submit"]):not([type="radio"]),
    .form-group textarea {
        flex-grow: 1; padding: 10px; margin-right: 10px; border: 1px solid #ccc;
        border-radius: 4px; min-width: 150px;
    }
    
    /* 버튼 스타일 */
    .btn-action, .btn-secondary, .btn-primary {
        padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer;
        font-weight: bold; transition: background-color 0.2s;
    }
    .form-group .btn-action, .form-group .btn-secondary { min-width: 80px; text-align: center; flex-shrink: 0; }
    .btn-action { background-color: #007bff; color: white; }
    .btn-secondary { background-color: #6c757d; color: white; }
    .btn-primary { background-color: #4CAF50; color: white; padding: 15px 30px; font-size: 1.1em; }
    .btn-action:hover { background-color: #0056b3; }
    .btn-secondary:hover { background-color: #5a6268; }
    .btn-primary:hover { background-color: #45a049; }
    
    /* 멤버십 정보 그룹 */
    .membership-info { flex-grow: 1; display: flex; align-items: center; gap: 10px; }
    .membership-info .btn-action { margin-right: 0; }
    
    /* 가게 소개 그룹 */
    .store-intro-group { align-items: flex-start; }
    .store-intro-group textarea { min-height: 150px; resize: vertical; margin-right: 0; }
    
    /* 주소 그룹 조정 */
    .address-group { flex-direction: column; align-items: flex-start; }
    .address-group > label { padding-bottom: 10px; margin-right: 0; }
    .address-line { display: flex; align-items: center; width: 100%; margin-bottom: 10px; flex-wrap: nowrap; }
    .address-line input { margin-right: 10px; }
    .address-line input#store-zipcode { max-width: 100px; flex-grow: 0; flex-shrink: 0; }
    .address-line input#store-main-addr { flex-grow: 2; }
    .address-line.detail-addr { margin-bottom: 15px; }
    .address-line.detail-addr input { flex-grow: 1; }
    .address-btn { width: calc(100% - 10px); margin-top: 5px; }
    
    /* 운영 설정 그룹 */
    .operation-setup-group { border-top: 1px solid #eee; padding-top: 20px; flex-wrap: wrap; }
    .operation-setup-group > label { width: 100%; padding-bottom: 10px; }

    /* 라디오 버튼 그룹 레이아웃 */
    .radio-group { display: flex; align-items: center; gap: 5px; margin-right: 30px; }
    .radio-group input[type="radio"] { margin-right: 5px; width: auto; }
    .radio-group label { width: auto; font-weight: normal; padding-right: 0; }

    .submit-area { margin-top: 30px; text-align: center; }
</style>
</head>
<body>
    <div class="container">
        <%-- 인클루드된 sellerSideBar.jsp가 여기에 표시됩니다. --%>

        <main class="content">
            <h2>회원 정보 수정</h2>

            <div class="tabs">
                <button class="tab-button" onclick="location.href='/seller/userUpdateInfo.do'">개인 정보 수정 (USER_TBL)</button>
                <button class="tab-button store-active" onclick="location.href='/seller/storeInfoupdateInfo.do'">가게 정보 수정 (SELLER_INFO_TBL)</button>
            </div>
            
            <hr>

            <form action="/store/update.dox" method="POST" class="edit-form" id="storeEditForm">
                
                <%-- Hidden 필드로 사용자 ID 전송 (JSP EL 사용) --%>
                <input type="hidden" name="userId" id="hidden-seller-id" value="${sessionId}"> 

                <div class="form-group">
                    <label for="store-name">가게 이름</label>
                    <%-- 1. storeName: 가게 이름 --%>
                    <input type="text" id="store-name" name="storeName" value="${store.storeName}">
                    <button type="button" class="btn-action" onclick="fnUpdateStoreField('storeName')">수정</button>
                </div>
                
                <div class="form-group">
                    <label>멤버십</label>
                    <div class="membership-info">
                        <%-- 2. isMembership: 멤버십 상태 --%>
                        현재 상태: **<span id="is-membership">${store.isMembership}</span>** <button type="button" class="btn-action" onclick="fnToggleMembership()">
                            <span id="membership-action">
                                <%-- JSP EL을 사용하여 초기 버튼 텍스트 설정 --%>
                                ${store.isMembership eq 'Y' ? '해지' : '가입'}
                            </span>
                        </button>
                    </div>
                </div>

                <div class="form-group address-group">
                    <label>가게 주소</label>
                    <div class="address-line">
                        <%-- 3. storeZipcode: 우편번호 --%>
                        <input type="text" id="store-zipcode" name="storeZipcode" value="${store.storeZipcode}" placeholder="우편번호" readonly>
                        <button type="button" class="btn-secondary" onclick="fnSearchAddress()">주소 검색</button>
                        <%-- 4. storeAddrMain: 기본 주소 --%>
                        <input type="text" id="store-main-addr" name="storeAddrMain" value="${store.storeAddrMain}" placeholder="기본 주소" readonly>
                    </div>
                    <div class="address-line detail-addr">
                        <%-- 5. storeAddrDetail: 상세 주소 --%>
                        <input type="text" id="store-detail-addr" name="storeAddrDetail" value="${store.storeAddrDetail}" placeholder="상세 주소">
                    </div>
                    <button type="button" class="btn-action address-btn" onclick="fnUpdateAddress()">수정</button>
                </div>

                <div class="form-group store-intro-group">
                    <label for="store-intro">가게 소개</label>
                    <%-- 6. storeIntro: 가게 소개 --%>
                    <textarea id="store-intro" name="storeIntro" placeholder="가게 소개글을 입력하세요.">${store.storeIntro}</textarea>
                </div>
                
                <div class="form-group operation-setup-group">
                    <label>운영 설정</label>
                    
                    <%-- 7. deliveryYn: 배송 가능 여부 --%>
                    <div class="radio-group">
                        <label>배송 가능 여부:</label>
                        <input type="radio" id="delivery-possible" name="deliveryYn" value="Y" ${store.deliveryYn eq 'Y' ? 'checked' : ''}>
                        <label for="delivery-possible">가능</label>
                        <input type="radio" id="delivery-impossible" name="deliveryYn" value="N" ${store.deliveryYn eq 'N' ? 'checked' : ''}>
                        <label for="delivery-impossible">불가능</label>
                    </div>
                    
                    <%-- 8. chatYn: 채팅 기능 여부 --%>
                    <div class="radio-group">
                        <label>채팅 기능 여부:</label>
                        <input type="radio" id="chat-use" name="chatYn" value="Y" ${store.chatYn eq 'Y' ? 'checked' : ''}>
                        <label for="chat-use">사용</label>
                        <input type="radio" id="chat-notuse" name="chatYn" value="N" ${store.chatYn eq 'N' ? 'checked' : ''}>
                        <label for="chat-notuse">미사용</label>
                    </div>
                </div>

                <div class="submit-area">
                    <button type="button" class="btn-primary" onclick="fnUpdateStoreInfo()">정보 수정하기</button>
                </div>

            </form>
        </main>
    </div>
</body>
<script>
    // 현재 로그인된 사용자 ID를 JSP EL로 가져옵니다.
    const CURRENT_SELLER_ID = "${sessionId}";

    /**
     * 가게 정보를 AJAX로 조회하여 화면에 바인딩하는 함수
     * 서버에서는 모든 키를 카멜 케이스로 반환한다고 가정합니다.
     */
    function fnGetStoreInfo() {
        if (!CURRENT_SELLER_ID || CURRENT_SELLER_ID === "") {
            console.warn("판매자 로그인 정보가 없어 AJAX 조회를 건너뜁니다.");
            // 로그인 정보가 JSP EL로 바인딩되지 않은 경우, 서버에서 넘겨받은 store 객체로 초기화 상태 유지
            return;
        }

        // 💡 서버 API 엔드포인트: /seller/info.dox 대신 /store/info.dox를 사용하도록 수정합니다.
        // 이는 JSP form action과 일관성을 유지하기 위함입니다.
        $.ajax({
            url: "/store/info.dox", 
            dataType: "json",
            type: "POST",
            data: { userId: CURRENT_SELLER_ID },
            success: function (data) {
                // 서버에서 { "store": { storeName: "..." } } 형태로 카멜 케이스로 응답한다고 가정합니다.
                if (data && data.store) {
                    const store = data.store;
                    
                    // 1. 가게 이름
                    $('#store-name').val(store.storeName || '');
                    
                    // 2. 멤버십 정보
                    const membershipStatus = store.isMembership === 'Y' ? 'Y' : 'N';
                    const membershipAction = membershipStatus === 'Y' ? '해지' : '가입';
                    $('#is-membership').text(membershipStatus); 
                    $('#membership-action').text(membershipAction);
                    
                    // 3, 4, 5. 주소 정보
                    $('#store-zipcode').val(store.storeZipcode || '');
                    $('#store-main-addr').val(store.storeAddrMain || '');
                    $('#store-detail-addr').val(store.storeAddrDetail || '');
                    
                    // 6. 가게 소개
                    $('#store-intro').val(store.storeIntro || '');
                    
                    // 7. 운영 설정 (배송 가능 여부)
                    $(`input[name="deliveryYn"][value="${store.deliveryYn || 'N'}"]`).prop('checked', true);
                    
                    // 8. 운영 설정 (채팅 기능 여부)
                    $(`input[name="chatYn"][value="${store.chatYn || 'N'}"]`).prop('checked', true);

                    console.log("✅ 가게 정보 화면 바인딩 성공:", store);

                } else {
                    console.error("가게 정보 조회 실패: 데이터 구조 오류 또는 데이터 없음", data);
                    alert("가게 정보를 불러오는데 실패했습니다.");
                }
            },
            error: function (xhr, status, error) {
                console.error("가게 정보 조회 실패:", error);
                alert("서버 통신 오류로 가게 정보를 불러올 수 없습니다.");
            }
        });
    }

    /**
     * (예시) 개별 필드 수정 처리 함수
     * @param {string} fieldName - 수정할 필드의 name 속성 값 (카멜 케이스)
     */
    function fnUpdateStoreField(fieldName) {
        alert(fieldName + " 필드 수정 로직 실행 (서버와 연동 필요)");
    }
    
    /**
     * (예시) 주소 검색 처리 함수 (Daum/Kakao Postcode API 연동 필요)
     */
    function fnSearchAddress() {
        alert("주소 검색 API (예: 다음 우편번호) 연동 필요");
        // 여기에 Daum Postcode API 호출 로직을 추가하여 우편번호와 기본 주소를 업데이트해야 합니다.
    }
    
    /**
     * (예시) 주소 수정 처리 함수
     */
    function fnUpdateAddress() {
        alert("주소 정보 수정 로직 실행 (서버와 연동 필요)");
    }
    
    /**
     * (예시) 멤버십 가입/해지 토글 함수
     */
    function fnToggleMembership() {
        const currentStatus = $('#is-membership').text();
        const nextAction = currentStatus === 'Y' ? '해지' : '가입';
        alert("멤버십 " + nextAction + " 로직 실행 (서버와 연동 필요)");
    }

    /**
     * 전체 정보 수정하기 (버튼 클릭 시 실행)
     */
    function fnUpdateStoreInfo() {
        const form = $('#storeEditForm');
        
        // 폼 데이터 직렬화 (모든 name 속성(카멜 케이스)이 전송됨)
        const serializedData = form.serialize();

        $.ajax({
            url: form.attr('action'), // /store/update.dox
            type: form.attr('method'), // POST
            data: serializedData,
            success: function(response) {
                // 서버 응답 구조에 따라 변경
                if (response.result === 'success' || response.success) { 
                    alert("가게 정보가 성공적으로 수정되었습니다.");
                    // 정보가 수정되었으므로 화면 재조회
                    fnGetStoreInfo();
                } else {
                    alert("정보 수정에 실패했습니다: " + (response.message || "알 수 없는 오류"));
                }
            },
            error: function(xhr, status, error) {
                console.error("전체 정보 수정 실패:", error);
                alert("서버 통신 오류로 정보 수정에 실패했습니다.");
            }
        });
    }

    // 페이지 로드 완료 후 정보 조회 함수 실행
    $(document).ready(function() {
        // 서버에서 데이터를 다시 가져와서 화면을 최신 상태로 업데이트
        fnGetStoreInfo();
    });
</script> 
</html>