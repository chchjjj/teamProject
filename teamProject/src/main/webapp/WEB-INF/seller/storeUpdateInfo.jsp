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
                        /* ===== 기본 설정 ===== */
                        body {
                            font-family: 'Noto Sans KR', 'Malgun Gothic', sans-serif;
                            margin: 0;
                            padding: 0;
                            background-color: #f8fafc;
                            color: #333;
                        }

                        /* ===== 전체 레이아웃 ===== */
                        .container {
                            display: flex;
                            gap: 24px;
                            max-width: 1400px;
                            margin: 40px auto;
                            padding: 0 20px;
                        }

                        /* ===== 사이드바 ===== */
                        .sidebar {
                            width: 250px;
                            background: linear-gradient(180deg, #fdfdf0 0%, #f9f7e8 100%);
                            padding: 25px 0;
                            border-radius: 16px;
                            box-shadow: 2px 4px 12px rgba(0, 0, 0, 0.05);
                        }

                        /* ===== 메인 콘텐츠 ===== */
                        .content {
                            flex: 1;
                            background: #fff;
                            padding: 40px 50px;
                            border-radius: 16px;
                            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
                        }

                        .content h2 {
                            font-size: 1.6em;
                            font-weight: 700;
                            color: #222;
                            border-left: 5px solid #007bff;
                            padding-left: 12px;
                            margin-bottom: 30px;
                        }

                        /* ===== 탭 ===== */
                        .tabs {
                            display: flex;
                            border-bottom: 2px solid #e5e7eb;
                            margin-bottom: 25px;
                        }

                        .tab-button {
                            padding: 10px 20px;
                            background: none;
                            border: none;
                            font-size: 1em;
                            cursor: pointer;
                            color: #6b7280;
                            font-weight: 500;
                            border-bottom: 3px solid transparent;
                            transition: all 0.2s ease;
                        }

                        .tab-button:hover {
                            color: #111827;
                        }

                        .tab-button.store-active {
                            color: #007bff;
                            border-bottom: 3px solid #007bff;
                            font-weight: 700;
                        }

                        /* ===== 폼 ===== */
                        .edit-form {
                            display: flex;
                            flex-direction: column;
                            gap: 20px;
                        }

                        .form-group {
                            display: flex;
                            flex-wrap: wrap;
                            align-items: center;
                            gap: 15px;
                            border-bottom: 1px solid #f1f5f9;
                            padding-bottom: 15px;
                        }

                        .form-group:last-of-type {
                            border-bottom: none;
                        }

                        .form-group label {
                            width: 130px;
                            font-weight: 600;
                            color: #374151;
                        }

                        .form-group input[type="text"],
                        .form-group textarea {
                            flex: 1;
                            padding: 10px 14px;
                            border: 1px solid #d1d5db;
                            border-radius: 8px;
                            font-size: 0.95em;
                            transition: border-color 0.2s, box-shadow 0.2s;
                        }

                        .form-group input:focus,
                        .form-group textarea:focus {
                            border-color: #007bff;
                            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
                            outline: none;
                        }

                        textarea {
                            min-height: 130px;
                            resize: vertical;
                        }

                        /* ===== 버튼 ===== */
                        .btn-action,
                        .btn-secondary,
                        .btn-primary {
                            border: none;
                            border-radius: 8px;
                            cursor: pointer;
                            font-weight: 600;
                            padding: 10px 18px;
                            font-size: 0.95em;
                            transition: all 0.2s ease;
                        }

                        .btn-action {
                            background-color: #007bff;
                            color: #fff;
                        }

                        .btn-action:hover {
                            background-color: #005fcc;
                        }

                        .btn-secondary {
                            background-color: #9ca3af;
                            color: #fff;
                        }

                        .btn-secondary:hover {
                            background-color: #6b7280;
                        }

                        .btn-primary {
                            background: linear-gradient(135deg, #007bff, #0056d2);
                            color: #fff;
                            font-size: 1.05em;
                            padding: 14px 32px;
                            box-shadow: 0 4px 10px rgba(0, 123, 255, 0.25);
                        }

                        .btn-primary:hover {
                            background: linear-gradient(135deg, #0069d9, #004bb5);
                        }

                        /* ===== 주소 입력 ===== */
                        .address-group {
                            flex-direction: column;
                            align-items: flex-start;
                        }

                        .address-line {
                            display: flex;
                            gap: 10px;
                            width: 100%;
                            margin-bottom: 10px;
                        }

                        .address-btn {
                            align-self: flex-end;
                        }

                        /* ===== 라디오 버튼 그룹 ===== */
                        .radio-group {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            flex-wrap: wrap;
                        }

                        .radio-group label {
                            font-weight: 500;
                        }

                        /* ===== 제출 영역 ===== */
                        .submit-area {
                            text-align: center;
                            margin-top: 40px;
                        }

                        .submit-area .btn-primary {
                            min-width: 220px;
                        }

                        /* ===== 멤버십 정보 ===== */
                        .membership-info {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            font-size: 0.95em;
                            color: #374151;
                        }

                        #is-membership {
                            font-weight: 700;
                            color: #007bff;
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
                                                                    <%-- 3. storeZipcode: 우편번호 --%>
                                                                        <input type="text" id="store-zipcode"
                                                    name="storeZipcode" value="${store.storeZipcode}" placeholder="우편번호"
                                                    readonly>
                                                                        <button type="button" class="btn-secondary"
                                                    onclick="fnSearchAddress()">주소 검색</button>
                                                                        <%-- 4. storeAddrMain: 기본 주소 --%>
                                                                            <input type="text" id="store-main-addr"
                                                        name="storeAddrMain" value="${store.storeAddrMain}"
                                                        placeholder="기본 주소" readonly>
                                                                        </div>
                                                            <div class="address-line detail-addr">
                                                                    <%-- 5. storeAddrDetail: 상세 주소 --%>
                                                                        <input type="text" id="store-detail-addr"
                                                    name="storeAddrDetail" value="${store.storeAddrDetail}"
                                                    placeholder="상세 주소">
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
                // 현재 로그인된 사용자 ID를 JSP EL로 가져옵니다.
                const CURRENT_SELLER_ID = "${sessionId}";

                /**
                 * 가게 정보를 AJAX로 조회하여 화면에 바인딩하는 함수
                 * **로그에 맞춰 대문자 스네이크 케이스 키로 데이터를 바인딩하도록 수정되었습니다.**
                 */
                function fnGetStoreInfo() {
                    if (!CURRENT_SELLER_ID || CURRENT_SELLER_ID === "") {
                        console.warn("판매자 로그인 정보가 없어 AJAX 조회를 건너뜁니다.");
                        return;
                    }

                    $.ajax({
                        url: "/store/info.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: CURRENT_SELLER_ID },
                        success: function (data) {
                            // 서버에서 { "store": { STORE_NAME: "...", ... } } 형태로 응답한다고 가정
                            if (data && data.store) {
                                // 💡 AJAX 응답 키를 대문자 스네이크 케이스로 접근하도록 수정
                                const store = data.store;

                                // 1. 가게 이름
                                $('#store-name').val(store.STORE_NAME || '');

                                // 2. 멤버십 정보
                                // 테이블 컬럼명 MEMBERSHIP을 가져오거나, 쿼리에서 IS_MEMBERSHIP으로 별칭 지정한 것을 가져와야 함.
                                const membershipStatus = store.IS_MEMBERSHIP === 'Y' ? 'Y' : 'N'; // 콘솔 로그 IS_MEMBERSHIP 사용
                                const membershipAction = membershipStatus === 'Y' ? '해지' : '가입';
                                $('#is-membership').text(membershipStatus);
                                $('#membership-action').text(membershipAction);

                                // 3, 4, 5. 주소 정보
                                $('#store-zipcode').val(store.STORE_ZIPCODE || '');       // STORE_ZIPCODE로 수정 (주소 관련 컬럼 키 확인 필요)
                                $('#store-main-addr').val(store.STORE_ADDR_MAIN || store.STORE_ADDR || ''); // 테이블 정의에 따라 STORE_ADDR_MAIN 또는 STORE_ADDR 사용
                                $('#store-detail-addr').val(store.STORE_ADDR_DETAIL || ''); // STORE_ADDR_DETAIL로 수정 (주소 관련 컬럼 키 확인 필요)

                                // 6. 가게 소개
                                $('#store-intro').val(store.STORE_INTRO || '');

                                // 7. 운영 설정 (배송 가능 여부)
                                // DELIVERY_YN 키는 서버 응답과 JSP EL에서 모두 사용 가능하여 충돌 가능성이 적음.
                                $(`input[name="deliveryYn"][value="${store.DELIVERY_YN || 'N'}"]`).prop('checked', true);

                                // 8. 운영 설정 (채팅 기능 여부)
                                // CHAT_YN 키는 서버 응답에서 IS_CHAT_ENABLED의 별칭으로 사용된다고 가정.
                                $(`input[name="chatYn"][value="${store.CHAT_YN || 'N'}"]`).prop('checked', true);

                                console.log("✅ 가게 정보 화면 바인딩 성공 (수정된 키 사용):", store);

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
                        success: function (response) {
                            // 서버 응답 구조에 따라 변경
                            if (response.result === 'success' || response.success) {
                                alert("가게 정보가 성공적으로 수정되었습니다.");
                                // 정보가 수정되었으므로 화면 재조회
                                fnGetStoreInfo();
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

                // 페이지 로드 완료 후 정보 조회 함수 실행
                $(document).ready(function () {
                    // 서버에서 데이터를 다시 가져와서 화면을 최신 상태로 업데이트
                    fnGetStoreInfo();
                });
            </script>

            </html>