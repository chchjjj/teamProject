<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>
                    <style>
                        /* 🎨 브라운 톤 색상 스키마 적용 (이전 요청의 색상 사용) */
                        :root {
                            --color-primary: #d77b66;
                            /* 메인 버튼, 활성 탭 */
                            --color-secondary: #b8b0aa;
                            /* 보조 버튼 */
                            --color-text-main: #5a3921;
                            /* 제목, 레이블 */
                            --color-bg-light: #fffaf8;
                            /* 입력 필드 배경 */
                            --color-bg-page: #fffaf8;
                            /* 페이지 배경 */
                            --color-bg-content: #fff;
                            /* 콘텐츠 배경 */
                            --color-border: #f3e5dc;
                            /* 구분선 */
                            --color-accent: #f3b8a0;
                            /* 강조선 */
                        }

                        /* ===== 1. 기본 설정 ===== */
                        body {
                            font-family: 'Noto Sans KR', 'Malgun Gothic', sans-serif;
                            margin: 0;
                            padding: 0;
                            background-color: var(--color-bg-page);
                            color: #333;
                        }

                        /* ===== 2. 전체 레이아웃 (Sidebar + Content) ===== */
                        .container {
                            display: flex;
                            gap: 20px;
                            max-width: 1200px;
                            /* 기존 1400px에서 1200px로 조정 (이전 요청 기준) */
                            margin: 40px auto;
                            /* 상하 40px로 조정 (이전 요청 기준) */
                            padding: 0 20px;
                            /* min-height는 content가 알아서 늘어나도록 제거 */
                        }

                        /* ===== 3. 사이드바 ===== */
                        .sidebar {
                            width: 240px;
                            /* 250px에서 240px로 조정 (이전 요청 기준) */
                            min-width: 240px;
                            flex-shrink: 0;
                            background: linear-gradient(180deg, #fffdf5 0%, #fff7e5 100%);
                            /* 브라운 계열 그라데이션 */
                            padding: 20px 0;
                            border-radius: 12px;
                            /* 8px에서 12px로 조정 (이전 요청 기준) */
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                        }

                        .logo {
                            padding: 0 20px 20px;
                            font-size: 1.2em;
                            font-weight: bold;
                            color: var(--color-primary);
                            /* 색상 변경 */
                            border-bottom: 1px solid var(--color-border);
                            margin-bottom: 10px;
                        }

                        .menu ul {
                            list-style: none;
                            padding: 0;
                            margin: 0;
                        }

                        .menu li a {
                            display: block;
                            padding: 15px 20px;
                            text-decoration: none;
                            color: #8c6e5a;
                            /* 텍스트 색상 조정 */
                            font-weight: 500;
                            transition: background-color 0.2s;
                        }

                        .menu li a:hover {
                            background-color: #f7f0e8;
                            /* 호버 색상 조정 */
                        }

                        .menu li.active a {
                            background-color: var(--color-bg-content);
                            color: var(--color-text-main);
                            font-weight: bold;
                            border-left: 5px solid var(--color-primary);
                            /* 활성 색상 변경 */
                        }


                        /* ===== 4. 메인 콘텐츠 스타일 ===== */
                        .content {
                            flex-grow: 1;
                            background: var(--color-bg-content);
                            padding: 30px 40px;
                            /* 패딩 조정 (이전 요청 기준) */
                            border-radius: 12px;
                            /* 8px에서 12px로 조정 */
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                        }

                        .content h2 {
                            font-size: 1.4em;
                            font-weight: 700;
                            color: var(--color-text-main);
                            border-left: 5px solid var(--color-accent);
                            /* 좌측 강조선 */
                            padding-left: 10px;
                            padding-bottom: 0;
                            border-bottom: none;
                            /* 기존 border-bottom 제거 */
                            margin-bottom: 20px;
                        }

                        /* 탭 스타일 */
                        .tabs {
                            display: flex;
                            border-bottom: 2px solid var(--color-border);
                            /* 색상 변경 */
                            margin-bottom: 20px;
                        }

                        .tab-button {
                            padding: 8px 16px;
                            /* 패딩 조정 */
                            border: none;
                            background: none;
                            /* 배경 제거 */
                            cursor: pointer;
                            font-size: 0.95em;
                            /* 폰트 크기 조정 */
                            color: #8c6e5a;
                            /* 텍스트 색상 조정 */
                            font-weight: 500;
                            margin-right: 5px;
                            border-radius: 4px 4px 0 0;
                            border-bottom: 3px solid transparent;
                            transition: all 0.2s ease;
                        }

                        .tab-button.active {
                            background-color: var(--color-bg-content);
                            border-bottom: 3px solid var(--color-primary);
                            /* 활성 색상 변경 */
                            font-weight: 700;
                            /* bold에서 700으로 */
                            color: var(--color-primary);
                        }


                        /* ===== 5. 폼 스타일 ===== */
                        .edit-form {
                            display: flex;
                            flex-direction: column;
                            gap: 4px;
                            /* 폼 그룹 간 간격 조정 (개별 padding으로 간격 조절) */
                        }

                        .form-group {
                            display: flex;
                            flex-wrap: wrap;
                            align-items: center;
                            gap: 10px;
                            padding: 10px 0;
                            /* 상하 패딩을 15px에서 10px로 조정 */
                            border-bottom: 1px solid #f5eee9;
                            /* 색상 변경 */
                        }

                        .form-group:last-of-type {
                            border-bottom: none;
                        }

                        .form-group label {
                            width: 120px;
                            min-width: 120px;
                            font-weight: 600;
                            /* bold에서 600으로 */
                            color: var(--color-text-main);
                            font-size: 0.95em;
                            flex-shrink: 0;
                            padding-right: 0;
                            /* 20px에서 0으로 조정 */
                        }

                        .form-group input:not([type="button"]):not([type="submit"]),
                        .form-group textarea {
                            flex: 1;
                            /* flex-grow: 1 */
                            padding: 8px 12px;
                            /* 패딩 조정 */
                            /* margin-right: 10px; 유지 */
                            border: 1px solid #e6d7ce;
                            /* 색상 변경 */
                            border-radius: 6px;
                            /* 4px에서 6px로 조정 */
                            font-size: 0.9em;
                            background-color: var(--color-bg-light);
                            min-width: 150px;
                            box-sizing: border-box;
                        }

                        .form-group input:focus,
                        .form-group textarea:focus {
                            border-color: var(--color-primary);
                            box-shadow: 0 0 0 3px rgba(215, 123, 102, 0.1);
                            outline: none;
                        }

                        textarea {
                            min-height: 100px;
                            resize: vertical;
                        }

                        /* ===== 6. 버튼 스타일 ===== */
                        .btn-action,
                        .btn-secondary,
                        .btn-primary {
                            border: none;
                            border-radius: 6px;
                            cursor: pointer;
                            font-weight: 600;
                            padding: 8px 14px;
                            /* 패딩 조정 */
                            font-size: 0.9em;
                            transition: all 0.2s ease;
                        }

                        .btn-action {
                            background-color: var(--color-primary);
                            color: #fff;
                        }

                        .btn-action:hover {
                            background-color: #b75a48;
                        }

                        .btn-secondary {
                            background-color: var(--color-secondary);
                            color: #fff;
                        }

                        .btn-secondary:hover {
                            background-color: #9a9088;
                        }

                        .btn-primary {
                            /* 기존 스타일 대신 이전 요청의 그라데이션 사용 */
                            background: linear-gradient(135deg, #d77b66, #b75a48);
                            color: #fff;
                            font-size: 1em;
                            padding: 12px 28px;
                            box-shadow: 0 4px 10px rgba(215, 123, 102, 0.2);
                        }

                        .btn-primary:hover {
                            background: linear-gradient(135deg, #c96c57, #a54a3c);
                        }

                        /* 개별 수정 버튼 공통 너비 및 정렬 보강 */
                        .form-group .btn-action,
                        .form-group .btn-secondary {
                            min-width: 80px;
                            text-align: center;
                            flex-shrink: 0;
                        }


                        /* ===== 7. 특정 필드 그룹 스타일 재정의 ===== */

                        /* 아이디 필드 그룹 전용 설정 (ReadOnly) */
                        .form-group.readonly input {
                            background-color: #f5f5f5;
                            /* 밝은 회색으로 변경 */
                            color: #777;
                            border-style: dashed;
                        }

                        /* 비밀번호 그룹 스타일 재조정 */
                        .password-group {
                            display: flex;
                            /* form-group의 display: flex 재확인 */
                            flex-wrap: nowrap;
                            align-items: center;
                            gap: 10px;
                        }

                        .password-group input {
                            flex-grow: 1;
                            margin-right: 0;
                            /* input 내부 마진 제거 */
                            min-width: 100px;
                            /* 너무 줄어들지 않도록 최소 너비 설정 */
                        }

                        .password-group input:nth-child(4) {
                            /* 새 비밀번호 확인 필드 */
                            margin-right: 10px;
                            /* 버튼과의 간격 확보 */
                        }

                        /* 💡 주소 그룹 스타일 (간격 최소화) */
                        .form-group.address-group {
                            /* 기존 form-group 상하 padding (10px 0)보다 적게 줍니다. */
                            padding: 3px 0;
                            /* 상하 패딩을 축소하여 영역 전체를 작게 만듭니다. */
                            flex-direction: column;
                            /* 레이블과 입력 필드를 분리 */
                            align-items: flex-start;
                            gap: 0;
                        }

                        .form-group.address-group>label {
                            /* 직접적인 자식 label */
                            display: block;
                            padding-bottom: 0px;
                            width: 100%;
                            margin-bottom: 4px;
                            /* 레이블과 첫 번째 입력줄 사이 간격 */
                            min-width: 100px;
                            font-size: 0.95em;
                            font-weight: 600;
                            color: var(--color-text-main);
                        }

                        .address-line {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            width: 100%;
                            margin-bottom: 4px;
                            /* 다음 줄과의 간격 최소화 */
                            flex-wrap: nowrap;
                        }

                        .address-line input {
                            margin-right: 0;
                            padding: 8px 12px;
                            /* 패딩 통일 */
                            border-radius: 6px;
                            /* 둥근 모서리 통일 */
                            border: 1px solid #e6d7ce;
                            /* 테두리 통일 */
                            background-color: var(--color-bg-light);
                            /* 배경색 통일 */
                        }

                        .address-line input#zipcode {
                            max-width: 120px;
                            /* 100px -> 120px로 확대 */
                            flex-grow: 0;
                            flex-shrink: 0;
                        }

                        .address-line input#main-addr {
                            flex-grow: 2;
                            margin-right: 0;
                            min-width: 180px;
                            /* 너비 확보를 위해 최소 너비 추가/확대 */
                        }

                        .address-line .btn-secondary {
                            margin-right: 0;
                        }

                        .detail-addr {
                            margin-bottom: 8px;
                            /* 주소 필드와 하단 버튼 사이의 간격 */
                            width: 100%;
                            /* 너비 확보 */
                        }

                        .detail-addr input {
                            flex-grow: 1;
                            /* 추가: 나머지 공간 채우기 */
                            min-width: 180px;
                            /* 최소 너비 확보 */
                        }

                        .address-btn {
                            width: 100%;
                            margin-left: 0;
                            display: block;
                            margin-top: 0px;
                            padding: 10px 15px;
                            /* 일반 버튼 패딩보다 약간 크게 */
                        }

                        /* ===== 8. 제출 영역 ===== */
                        .submit-area {
                            margin-top: 30px;
                            text-align: center;
                        }
                    </style>
            </head>

   <body>
                    <div class="container">
                        <%-- 인클루드된 sellerSideBar.jsp가 여기에 표시됩니다. --%>

                            <main class="content">
                                    <h2>회원 정보 수정</h2>

                                    <div class="tabs">
                                            <button class="tab-button"
                                        onclick="location.href='/seller/userUpdateInfo.do'">개인 정보 수정 (USER_TBL)</button>
                                            <button class="tab-button store-active"
                                        onclick="location.href='/seller/storeInfoupdateInfo.do'">가게 정보 수정
                                        (SELLER_INFO_TBL)</button>
                                        </div>

                                    
                            <hr>

                                    <form action="/store/update.dox" method="POST" class="edit-form"
                                id="storeEditForm">
                                            
                                            <%-- Hidden 필드로 사용자 ID 전송 (JSP EL 사용) --%>
                                                <input type="hidden" name="userId" id="hidden-seller-id"
                                            value="${sessionId}">
                                        <div class="form-group">
                                            <label for="store-id">가게 번호 (STORE_ID)</label>
                                            <input type="text" id="store-id" name="storeId" value="${store.storeId}"
                                                placeholder="수정할 가게 번호를 반드시 입력하세요." required>
                                            <button type="button" class="btn-secondary" onclick="fnSearchStoreInfoById()">가게
                                                정보 조회</button>
                                        </div>

                                                <div class="form-group">
                                                        <label for="store-name">가게 이름</label>
                                                        <%-- 1. storeName: 가게 이름 --%>
                                                            <input type="text" id="store-name" name="storeName"
                                                    value="${store.storeName}">
                                                            <button type="button" class="btn-action"
                                                    onclick="fnUpdateStoreField('storeName')">수정</button>
                                                        </div>
                                                
                                                <div class="form-group">
                                                        <label>멤버십</label>
                                                        <div class="membership-info">
                                                                <%-- 2. isMembership: 멤버십 상태 --%>
                                                                    현재 상태: **<span
                                                    id="is-membership">${store.isMembership}</span>** <button
                                                    type="button" class="btn-action" onclick="fnToggleMembership()">
                                                                            <span id="membership-action">
                                                                                    <%-- JSP EL을 사용하여 초기 버튼 텍스트 설정
                                                            --%>
                                                                                        ${store.isMembership eq 'Y'
                                                            ? '해지' : '가입'}
                                                                            </span>
                                                                        </button>
                                                            </div>
                                                        </div>

                                                <div class="form-group address-group">
                                                        <label>가게 주소</label>
                                                        <div class="address-line">
                                                
                                                                    <button type="button" class="btn-secondary"
                                                    onclick="fnSearchAddress()">주소 검색</button>
                                                                    <%-- 4. storeAddrMain: 기본 주소 --%>
                                                                        <input type="text" id="store-main-addr"
                                                        name="storeAddrMain" value="${store.storeAddrMain}"
                                                        placeholder="기본 주소" readonly>
                                                            </div>
                                                        
                                                            <button type="button" class="btn-action address-btn"
                                                onclick="fnUpdateAddress()">수정</button>
                                                        </div>

                                                <div class="form-group store-intro-group">
                                                        <label for="store-intro">가게 소개</label>
                                                        <%-- 6. storeIntro: 가게 소개 --%>
                                                            <textarea id="store-intro" name="storeIntro"
                                                placeholder="가게 소개글을 입력하세요.">${store.storeIntro}</textarea>
                                                        </div>
                                                
                                                <div class="form-group operation-setup-group">
                                                        <label>운영 설정</label>
                                                        
                                                        <%-- 7. deliveryYn: 배송 가능 여부 --%>
                                                            <div class="radio-group">
                                                                    <label>배송 가능 여부:</label>
                                                                    <input type="radio" id="delivery-possible"
                                                    name="deliveryYn" value="Y" ${store.deliveryYn eq 'Y' ? 'checked'
                                                    : '' }>
                                                                    <label for="delivery-possible">가능</label>
                                                                    <input type="radio" id="delivery-impossible"
                                                    name="deliveryYn" value="N" ${store.deliveryYn eq 'N' ? 'checked'
                                                    : '' }>
                                                                    <label for="delivery-impossible">불가능</label>
                                                                </div>
                                                            
                                                            <%-- 8. chatYn: 채팅 기능 여부 --%>
                                                                <div class="radio-group">
                                                                        <label>채팅 기능 여부:</label>
                                                                        <input type="radio" id="chat-use"
                                                            name="chatYn" value="Y" ${store.chatYn eq 'Y' ? 'checked' : ''
                                                            }>
                                                                        <label for="chat-use">사용</label>
                                                                        <input type="radio" id="chat-notuse"
                                                            name="chatYn" value="N" ${store.chatYn eq 'N' ? 'checked' : ''
                                                            }>
                                                                        <label for="chat-notuse">미사용</label>
                                                                    </div>
                                                            </div>

                                                <div class="submit-area">
                                                        <button type="button" class="btn-primary"
                                                onclick="fnUpdateStoreInfo()">정보 수정하기</button>
                                                        </div>

                                                </form>
                                        
                                </main>
                            </div>
            </body>
<script>
    // 현재 로그인된 사용자 ID를 JSP EL로 가져옵니다. (사용은 되지만, 조회는 storeId 기반)
    const CURRENT_SELLER_ID = "${sessionId}";

    /**
     * 가게 정보를 AJAX로 조회하여 화면에 바인딩하는 함수
     * @param {string} storeId - 조회할 가게의 고유 ID (STORE_ID)
     */
    function fnGetStoreInfo(storeId) {
        // 💡 [필수 검증] storeId가 유효한지 확인
        if (!storeId || storeId.trim() === "") {
            console.warn("조회할 가게 번호(storeId)가 없어 AJAX 조회를 건너뜁니다.");
            return;
        }

        $.ajax({
            url: "/store/info.dox",
            dataType: "json",
            type: "POST",
            data: { storeId: storeId },
            success: function (data) {
                // 서버 응답 구조: { "store": { ... }, "result": "success" } 가정

                // 1. 서버 응답 구조 유연하게 처리: data.store가 있으면 그걸 쓰고, 없으면 data 자체를 store로 간주
                let store = null;
                if (data.result === 'success' && data.store) {
                    store = data.store;
                } else if (data.result === 'success' && data.STORE_ID) { 
                    // 혹시나 result=success인데 store 래퍼가 없는 경우 대비 (권장하지 않음)
                    store = data;
                }

                if (store) {
                    // ⭐ 바인딩 로직
                    $('#store-id').val(store.STORE_ID || ''); 
                    $('#store-name').val(store.STORE_NAME || '');

                    const membershipStatus = store.MEMBERSHIP === 'Y' ? 'Y' : 'N';
                    const membershipAction = membershipStatus === 'Y' ? '해지' : '가입';
                    $('#is-membership').text(membershipStatus);
                    $('#membership-action').text(membershipAction);

                    // 주소 필드 바인딩 (DB 스키마에 없는 필드는 주석 처리 유지)
                    // $('#store-zipcode').val(store.STORE_ZIPCODE || ''); 
                    $('#store-main-addr').val(store.STORE_ADDR || ''); 
                    // $('#store-detail-addr').val(store.STORE_ADDR_DETAIL || '');

                    $('#store-intro').val(store.STORE_INTRO || '');

                    // 라디오 버튼 체크 로직은 HTML에서 EL로 초기화되었으나, AJAX 조회 후 갱신
                    $(`input[name="deliveryYn"][value="${store.DELIVERY_YN || 'N'}"]`).prop('checked', true);
                    $(`input[name="chatYn"][value="${store.IS_CHAT_ENABLED || 'N'}"]`).prop('checked', true);

                    console.log("✅ 가게 정보 화면 바인딩 성공 (storeId 기반 조회):", store);

                } else if (data.result === 'not_found' || data.result === 'fail') {
                    // 서버에서 데이터 없음을 명확히 알릴 때
                    console.error("가게 정보 조회 실패: 유효한 가게 데이터를 찾을 수 없습니다.", data);
                    alert("가게 정보를 찾을 수 없습니다. (ID 확인 필요)");
                    
                } else {
                    // 기타 데이터 구조 오류
                    console.error("가게 정보 조회 실패: 서버 응답 데이터 구조 오류", data);
                    alert("가게 정보를 불러오는데 실패했습니다. (서버 응답 확인 필요)");
                }
            },
            error: function (xhr, status, error) {
                console.error("가게 정보 조회 실패:", error);
                alert("서버 통신 오류로 가게 정보를 불러올 수 없습니다. (400 Bad Request 또는 500 Internal Server Error 확인)");
            }
        });
    }


    /**
     * '가게 정보 조회' 버튼 클릭 시 실행
     */
    function fnSearchStoreInfoById() {
        const storeId = $('#store-id').val(); 

        // 1. 필수 입력 검증
        if (!storeId || storeId.trim() === '') {
            alert("조회할 가게 번호를 입력해주세요.");
            $('#store-id').focus();
            return;
        }

        // 2. 조회 함수 실행
        fnGetStoreInfo(storeId);
    }

    // ... (fnUpdateStoreInfo, fnSearchAddress, jusoCallBack 함수는 로직 변경 없음) ...
    // (fnToggleMembership, fnUpdateStoreField, fnUpdateAddress 함수는 정의가 없으므로 그대로 두었습니다.)

    /**
     * 전체 정보 수정하기 (버튼 클릭 시 실행)
     */
    function fnUpdateStoreInfo() {
        const form = $('#storeEditForm');
        const storeId = $('#store-id').val(); // STORE_ID 값 가져오기

        // 💡 [필수 검증] STORE_ID 필수 입력 검증
        if (!storeId || storeId.trim() === '') {
            alert("가게 번호 (STORE_ID)를 반드시 입력해야 합니다.");
            $('#store-id').focus(); 
            return; 
        }

        // 폼 데이터 직렬화 (storeId 포함 모든 name 속성 값이 전송됨)
        const serializedData = form.serialize();

        $.ajax({
            url: form.attr('action'), // /store/update.dox
            type: form.attr('method'), // POST
            data: serializedData,
            success: function (response) {
                // 서버 응답 구조에 따라 변경
                if (response.result === 'success' || response.success) {
                    alert("가게 정보가 성공적으로 수정되었습니다.");
                    // 💡 [수정] 정보 수정 후, storeId를 인수로 전달하여 화면 재조회
                    fnGetStoreInfo(storeId); 
                } else {
                    alert("정보 수정에 실패했습니다: " + (response.message || "알 수 없는 오류"));
                }
            },
            error: function (xhr, status, error) {
                console.error("전체 정보 수정 실패:", error);
                alert("서버 통신 오류로 정보 수정에 실패했습니다.");
            }
        });
    }

    /**
     * (예시) 주소 검색 처리 함수 (Daum/Kakao Postcode API 연동 필요)
     */
    function fnSearchAddress() {
        window.open(
            "/user/addr.do",
            "jusoPopup",
            "width=500,height=600,scrollbars=yes"
        );
    }

    /**
     * 도로명주소 안내시스템 API 팝업으로부터 정보를 받는 콜백 함수
     */
    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo) {
        // 1. 우편번호 업데이트
        // $('#store-zipcode').val(zipNo); // DB에 없는 필드

        // 2. 메인 주소 업데이트
        $('#store-main-addr').val(roadAddrPart1); 

        // 3. 상세 주소 업데이트 및 포커스 이동
        // $('#store-detail-addr').val(addrDetail || ''); // DB에 없는 필드
        // $('#store-detail-addr').focus();

        console.log("✅ 주소 업데이트 완료 (도로명주소 API):", {
            zipNo: zipNo,
            roadAddrPart1: roadAddrPart1,
            addrDetail: addrDetail
        });
    }
    
    // 페이지 로드 완료 후 정보 조회 함수 실행
    $(document).ready(function () {
        // 초기 로드 시 HTML 필드에 이미 설정되어 있는 storeId 값을 가져옵니다.
        const initialStoreId = $('#store-id').val();

        if (initialStoreId) {
            // 💡 storeId를 인수로 전달하며 함수 실행
            fnGetStoreInfo(initialStoreId); 
        } else {
            console.warn("페이지 초기 로드에 필요한 storeId 값이 HTML에 설정되어 있지 않습니다.");
        }
    });
</script>

            </html>