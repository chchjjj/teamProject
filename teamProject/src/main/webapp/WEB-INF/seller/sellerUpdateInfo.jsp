<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- 사이드바 인클루드 --%>
        <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>회원 정보 수정 - DessertLab</title>

                <%-- JQuery 라이브러리 추가 --%>
                    <script src="https://code.jquery.com/jquery-3.7.1.js"
                        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
                        crossorigin="anonymous"></script>

                    <%-- 💡 주소 검색을 위한 Daum Postcode API 스크립트 추가 --%>
                        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

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
                                padding: 5px 0;
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
                                min-width: 120px;
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

                            .address-line input#zipcode {
                                max-width: 100px;
                                flex-grow: 0;
                                flex-shrink: 0;
                            }

                            .address-line input#main-addr {
                                flex-grow: 2;
                                margin-right: 0;
                                /* input#main-addr의 우측 마진 제거 */
                            }

                            .address-line .btn-secondary {
                                margin-right: 0;
                            }

                            .detail-addr {
                                margin-bottom: 8px;
                                /* 주소 필드와 하단 버튼 사이의 간격 */
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
                                <%-- 탭 버튼 클릭 시 페이지 이동 또는 폼 토글 기능 추가 필요 --%>
                                    <button class="tab-button active"
                                        onclick="location.href='/seller/userUpdateInfo.do'">개인 정보 수정 (USER_TBL)</button>
                                    <button class="tab-button"
                                        onclick="location.href='/seller/storeInfoupdateInfo.do'">가게 정보 수정
                                        (SELLER_INFO_TBL)</button>
                            </div>

                            <hr>

                            <%-- form action은 자바스크립트에서 처리할 것이므로 일단 "#" 또는 실제 컨트롤러 주소로 설정 --%>
                                <form action="/member/update.dox" method="POST" class="edit-form" id="memberEditForm">

                                    <%-- Hidden 필드로 사용자 ID 전송 (JSP EL 사용) --%>
                                        <input type="hidden" name="userId" id="hidden-user-id" value="${sessionId}">

                                        <div class="form-group readonly">
                                            <label for="user-id">아이디</label>
                                            <%-- 데이터는 JQuery로 로딩됨 --%>
                                                <input type="text" id="user-id" name="userIdDisplay" readonly>
                                                <button type="button" class="btn-secondary">변경 불가</button>
                                        </div>

                                        <div class="form-group password-group">
                                            <label for="current-pw">비밀번호</label>
                                            <input type="password" id="current-pw" name="currentPw"
                                                placeholder="현재 비밀번호 확인">
                                            <input type="password" id="new-pw" name="newPw"
                                                placeholder="새 비밀번호 (입력 시 변경)">
                                            <input type="password" id="confirm-pw" name="confirmPw"
                                                placeholder="새 비밀번호 확인">
                                            <button type="button" class="btn-action" onclick="fnUpdatePassword()">비밀번호
                                                변경</button>
                                        </div>

                                        <div class="form-group">
                                            <label for="user-name">닉네임/이름</label>
                                            <input type="text" id="user-name" name="userName">
                                            <button type="button" class="btn-action"
                                                onclick="fnUpdateField('userName')">수정</button>
                                        </div>

                                        <div class="form-group">
                                            <label for="email">이메일</label>
                                            <input type="email" id="email" name="email">
                                            <button type="button" class="btn-action"
                                                onclick="fnUpdateField('email')">수정</button>
                                        </div>

                                        <div class="form-group">
                                            <label for="phone">연락처</label>
                                            <input type="tel" id="phone" name="phone">
                                            <button type="button" class="btn-action"
                                                onclick="fnUpdateField('phone')">수정</button>
                                        </div>

                                        <div class="form-group address-group">
                                            <label>개인 주소</label>
                                            <div class="address-line">
                                                <input type="text" id="zipcode" name="zipcode" placeholder="우편번호">
                                                <button type="button" class="btn-secondary"
                                                    onclick="fnSearchAddress()">주소 검색</button>
                                                <input type="text" id="main-addr" name="addrMain" placeholder="기본 주소">
                                            </div>
                                            <div class="address-line detail-addr">
                                                <input type="text" id="detail-addr" name="addrDetail"
                                                    placeholder="상세 주소">
                                            </div>
                                            <button type="button" class="btn-action address-btn"
                                                onclick="fnUpdateAddress()">수정</button>
                                        </div>

                                        <div class="submit-area">
                                            <button type="button" class="btn-primary" onclick="fnUpdateMemberInfo()">전체
                                                정보 수정하기</button>
                                        </div>

                                </form>
                        </main>
                </div>
            </body>
            <script>
                // 현재 로그인된 사용자 ID를 JSP EL로 가져옵니다.
                const CURRENT_USER_ID = "${sessionId}";

                /**
                 * 1. 회원 정보 조회 및 화면 바인딩 함수 (주소 분리 로직 수정 반영)
                 */
                function fnGetMemberInfo() {
                    if (!CURRENT_USER_ID) {
                        alert("로그인 정보가 없습니다.");
                        return;
                    }

                    $.ajax({
                        url: "/seller/info.dox",
                        dataType: "json",
                        type: "POST",
                        // 조회 시에도 키를 통일하여 보내는 것을 권장하지만, 서버에서 'userId'를 받는다면 유지해도 무방합니다.
                        data: { userId: CURRENT_USER_ID },
                        success: function (data) {
                            if (data && data.info) {
                                const member = data.info;

                                // 조회된 데이터의 키가 대문자(USER_ID, PHONE 등)라고 가정하고 바인딩합니다.
                                $('#user-id').val(member.USER_ID || CURRENT_USER_ID);
                                $('#user-name').val(member.USER_NAME || '');
                                $('#email').val(member.EMAIL || '');
                                $('#phone').val(member.PHONE || '');

                                // 💡 주소 정보 분리 바인딩
                                const fullAddress = member.USER_ADDR || '';
                                let zipCode = '';
                                let mainAddress = '';
                                let detailAddress = '';

                                const addressParts = fullAddress.trim().split(/\s+/);

                                if (addressParts.length >= 3) {
                                    zipCode = addressParts[0];
                                    mainAddress = addressParts[1];
                                    detailAddress = addressParts.slice(2).join(' ');
                                } else if (addressParts.length === 2) {
                                    zipCode = addressParts[0];
                                    mainAddress = addressParts[1];
                                } else if (addressParts.length === 1 && fullAddress.includes('-')) {
                                    zipCode = addressParts[0];
                                } else {
                                    mainAddress = fullAddress;
                                }

                                $('#zipcode').val(zipCode);
                                $('#main-addr').val(mainAddress);
                                $('#detail-addr').val(detailAddress);

                                console.log("✅ 회원 정보 화면 바인딩 성공:", member);
                            } else {
                                console.error("회원 정보 조회 실패: 데이터 구조 오류 또는 데이터 없음", data);
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("회원 정보 조회 실패:", error);
                        }
                    });
                }

                /**
                 * 2. 주소 검색 처리 함수 (Kakao Postcode API 연동)
                 */
                function fnSearchAddress() {
                    if (typeof daum === 'undefined' || typeof daum.Postcode === 'undefined') {
                        alert("주소 검색 API가 로드되지 않았습니다. <head>에 스크립트를 추가했는지 확인해주세요.");
                        return;
                    }

                    new daum.Postcode({
                        oncomplete: function (data) {
                            let fullAddr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;

                            $('#zipcode').val(data.zonecode);
                            $('#main-addr').val(fullAddr);

                            $('#detail-addr').val('');
                            $('#detail-addr').focus();
                        }
                    }).open();
                }

                // 개별 수정 버튼 함수들은 전체 수정 버튼을 사용하도록 안내합니다.
                function fnUpdateField(fieldName) { alert("이제 '전체 정보 수정하기' 버튼을 사용해 주세요."); }
                function fnUpdatePassword() { alert("이제 '전체 정보 수정하기' 버튼을 사용해 주세요."); }
                function fnUpdateAddress() { alert("이제 '전체 정보 수정하기' 버튼을 사용해 주세요."); }


                /**
                 * 3. ✨ 전체 정보 수정하기 (버튼 클릭 시 실행) - 통합 로직
                 */
                function fnUpdateMemberInfo() {
                    const form = $('#memberEditForm');

                    // --- 비밀번호 유효성 검사 및 데이터 준비 ---
                    const currentPw = $('#current-pw').val();
                    const newPw = $('#new-pw').val();
                    const confirmPw = $('#confirm-pw').val();

                    if (newPw || confirmPw || currentPw) {
                        if (!currentPw) {
                            alert("비밀번호를 변경하려면 현재 비밀번호를 입력해야 합니다.");
                            $('#current-pw').focus();
                            return;
                        }
                        if (!newPw || !confirmPw) {
                            alert("새 비밀번호를 입력하려면 새 비밀번호와 확인을 모두 입력해주세요.");
                            return;
                        }
                        if (newPw !== confirmPw) {
                            alert("새 비밀번호와 확인이 일치하지 않습니다.");
                            $('#confirm-pw').focus();
                            return;
                        }
                    }

                    // --- 주소 필드 통합 및 데이터 준비 ---
                    const zipcode = $('#zipcode').val();
                    const addrMain = $('#main-addr').val();
                    const addrDetail = $('#detail-addr').val();

                    let userAddr = '';
                    if (zipcode && addrMain) {
                        // 주소 정보를 MyBatis의 USER_ADDR에 저장할 단일 문자열 형태로 만듭니다.
                        userAddr = zipcode + " " + addrMain + " " + (addrDetail.trim() || '');
                    } else if (zipcode || addrMain) {
                        alert("주소를 수정하려면 우편번호와 기본 주소를 모두 입력해야 합니다.");
                        return;
                    }

                    // --- 최종 데이터 구성: 서버(Controller/Mapper)의 기대 키와 일치하도록 대문자 키 사용 ---
                    const updateData = {
                        // 🚨 핵심 수정 부분: USER_ID로 키 변경
                        USER_ID: CURRENT_USER_ID,

                        USER_NAME: $('#user-name').val(),
                        EMAIL: $('#email').val(),
                        PHONE: $('#phone').val(),
                        USER_ADDR: userAddr
                    };

                    // 비밀번호 필드에 값이 있다면, USER_PWD 키를 추가
                    if (newPw) {
                        updateData.USER_PWD = newPw;
                        updateData.CURRENT_PWD = currentPw;
                    }

                    // --- AJAX 전송 ---
                    $.ajax({
                        url: "/member/update.dox",
                        type: "POST",
                        data: updateData,
                        success: function (response) {
                            if (response.success) {
                                alert("회원 정보가 성공적으로 수정되었습니다.");
                                // 비밀번호 필드 초기화 및 정보 재조회
                                $('#current-pw').val('');
                                $('#new-pw').val('');
                                $('#confirm-pw').val('');
                                fnGetMemberInfo();
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
                    fnGetMemberInfo();
                });
            </script>

            </html>