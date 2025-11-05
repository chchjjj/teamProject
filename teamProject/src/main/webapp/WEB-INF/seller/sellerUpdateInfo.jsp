<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 사이드바 인클루드 --%>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 수정 - DessertLab</title>
    
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

    /* 1. 컨테이너: 사이드바와 콘텐츠를 가로로 배치 */
    .container {
        display: flex;
        /* 사이드바와 콘텐츠 사이에 약간의 간격 추가 (선택 사항) */
        gap: 20px; 
        max-width: 1400px; /* 전체 최대 너비 지정 (선택 사항) */
        margin: 20px auto; /* 중앙 정렬 */
        min-height: calc(100vh - 40px); /* 뷰포트 전체 높이에서 상하 마진 제외 */
    }

    /* 2. 사이드바 (왼쪽 메뉴) 스타일 */
    .sidebar {
        width: 250px;
        min-width: 250px;
        flex-shrink: 0; /* 내용이 많아도 너비가 줄어들지 않도록 고정 */
        background-color: #f8f8e0;
        padding: 20px 0;
        box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        box-sizing: border-box; 
        border-radius: 8px; /* 컨테이너 중앙 정렬 시 보기 좋도록 */
    }

    .logo {
        padding: 0 20px 20px;
        font-size: 1.2em;
        font-weight: bold;
        color: #4CAF50;
        border-bottom: 1px solid #ddd;
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
        color: #333;
        font-weight: 500;
        transition: background-color 0.2s;
    }

    .menu li a:hover {
        background-color: #eee;
    }

    .menu li.active a {
        background-color: #fff; 
        color: #333;
        font-weight: bold;
        border-left: 5px solid #007bff;
    }

    /* 3. 메인 콘텐츠 스타일 */
    .content {
        flex-grow: 1; /* 남은 공간을 모두 차지 */
        background-color: #fff;
        padding: 40px;
        /* 컨테이너에 gap을 설정했으므로, content의 바깥 마진을 줄여도 됩니다. */
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
    .tabs {
        display: flex;
        margin-bottom: 20px;
    }

    .tab-button {
        padding: 10px 15px;
        border: none;
        background-color: #f0f0f0;
        cursor: pointer;
        font-size: 1em;
        margin-right: 5px;
        border-radius: 4px 4px 0 0;
        border-bottom: 3px solid transparent;
        transition: background-color 0.2s, border-bottom 0.2s;
    }

    .tab-button.active {
        background-color: #fff;
        border-bottom: 3px solid #007bff;
        font-weight: bold;
    }

    /* 4. 폼 스타일 */
    .edit-form {
        display: flex;
        flex-direction: column;
    }

    .form-group {
        display: flex;
        align-items: center;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
    }

    .form-group:last-of-type {
        border-bottom: none;
    }

    .form-group label {
        width: 120px;
        min-width: 120px; 
        font-weight: bold;
        flex-shrink: 0;
        padding-right: 20px;
    }

    .form-group input:not([type="button"]):not([type="submit"]),
    .form-group textarea {
        flex-grow: 1;
        padding: 10px;
        margin-right: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        min-width: 150px;
    }
    
    /* 버튼 기본 스타일 */
    .btn-action, .btn-secondary, .btn-primary {
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.2s;
    }
    
    /* 🚨 레이아웃 개선 CSS 시작 (주요 개선 부분) 🚨 */
    
    /* 개별 수정 버튼 공통 너비 및 정렬 보강 */
    .form-group .btn-action,
    .form-group .btn-secondary {
        min-width: 80px; 
        text-align: center;
        flex-shrink: 0; 
    }

    /* 아이디 필드 그룹 전용 설정 (ReadOnly 버튼 너비 고정) */
    .form-group.readonly input {
        flex-grow: 1;
        margin-right: 10px; 
        background-color: #f0f0f0; /* 읽기 전용 색상 유지 */
        color: #555;
    }
    
    /* 비밀번호 그룹 스타일 재조정 */
    .password-group {
        flex-wrap: nowrap; /* 너비가 확보되면 한 줄 유지 */
        align-items: center;
    }

    .password-group input {
        flex-grow: 1;
        width: auto; /* width: calc(30% - 15px) 대신 flex-grow 사용 */
        margin-right: 10px;
    }

    .password-group input:nth-child(4) { /* 새 비밀번호 확인 필드 */
        margin-right: 10px; /* 버튼과의 간격을 통일 */
    }
    
    /* 주소 그룹 스타일 재조정 */
    .address-group {
        /* 레이블과 입력 필드를 분리하기 위해 flex-direction: column; 적용 */
        flex-direction: column;
        align-items: flex-start;
        display: flex; /* 주소 관련 필드를 다시 flexbox로 관리 */
        padding: 15px 0;
    }
    
    .address-group label {
         display: block; 
         padding-bottom: 10px;
         width: 100%; /* 라벨이 한 줄 전체 차지 */
    }
    
    .address-line {
        display: flex;
        align-items: center;
        width: 100%; /* 부모(form-group)의 100% 사용 */
        margin-bottom: 10px; 
        flex-wrap: nowrap; 
    }

    .address-line input {
        margin-right: 10px;
    }

    .address-line input#zipcode {
        max-width: 100px;
        flex-grow: 0;
        flex-shrink: 0;
    }

    .address-line input#main-addr {
        flex-grow: 2;
        margin-right: 10px; 
    }
    
    .detail-addr {
        margin-bottom: 15px;
    }

    .address-btn {
         width: 100%; /* 주소 그룹 아래에서 전체 너비를 차지 */
         margin-left: 0; 
         display: block;
         margin-top: 10px;
    }

    /* 🚨 레이아웃 개선 CSS 종료 🚨 */

    .btn-action {
        background-color: #007bff;
        color: white;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-primary {
        background-color: #4CAF50;
        color: white;
        padding: 15px 30px;
        font-size: 1.1em;
    }

    .btn-action:hover { background-color: #0056b3; }
    .btn-secondary:hover { background-color: #5a6268; }
    .btn-primary:hover { background-color: #45a049; }

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
                <button class="tab-button active" onclick="location.href='/seller/userUpdateInfo.do'">개인 정보 수정 (USER_TBL)</button>
                <button class="tab-button" onclick="location.href='/seller/storeInfoupdateInfo.do'">가게 정보 수정 (SELLER_INFO_TBL)</button>
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
                    <input type="password" id="current-pw" name="currentPw" placeholder="현재 비밀번호 확인">
                    <input type="password" id="new-pw" name="newPw" placeholder="새 비밀번호 (입력 시 변경)">
                    <input type="password" id="confirm-pw" name="confirmPw" placeholder="새 비밀번호 확인">
                    <button type="button" class="btn-action" onclick="fnUpdatePassword()">비밀번호 변경</button>
                </div>

                <div class="form-group">
                    <label for="user-name">닉네임/이름</label>
                    <input type="text" id="user-name" name="userName">
                    <button type="button" class="btn-action" onclick="fnUpdateField('userName')">수정</button>
                </div>

                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email">
                    <button type="button" class="btn-action" onclick="fnUpdateField('email')">수정</button>
                </div>

                <div class="form-group">
                    <label for="phone">연락처</label>
                    <input type="tel" id="phone" name="phone">
                    <button type="button" class="btn-action" onclick="fnUpdateField('phone')">수정</button>
                </div>

                <div class="form-group address-group">
                    <label>개인 주소</label>
                    <div class="address-line">
                        <input type="text" id="zipcode" name="zipcode" placeholder="우편번호">
                        <button type="button" class="btn-secondary" onclick="fnSearchAddress()">주소 검색</button>
                        <input type="text" id="main-addr" name="addrMain" placeholder="기본 주소">
                    </div>
                    <div class="address-line detail-addr">
                        <input type="text" id="detail-addr" name="addrDetail" placeholder="상세 주소">
                    </div>
                    <button type="button" class="btn-action address-btn" onclick="fnUpdateAddress()">수정</button>
                </div>

                <div class="submit-area">
                    <%-- 전체 폼을 전송하는 대신, 개별 필드 수정 버튼을 활용하거나 이 버튼을 통해 모든 정보를 한 번에 업데이트 --%>
                    <button type="button" class="btn-primary" onclick="fnUpdateMemberInfo()">전체 정보 수정하기</button>
                </div>

            </form>
        </main>
    </div>
</body>
<script>
    // 현재 로그인된 사용자 ID를 JSP EL로 가져옵니다.
    const CURRENT_USER_ID = "${sessionId}";

    function fnGetMemberInfo() {
        if (!CURRENT_USER_ID) {
            alert("로그인 정보가 없습니다.");
            return;
        }

        $.ajax({
            url: "/seller/info.dox", 
            dataType: "json",
            type: "POST",
            data: { userId: CURRENT_USER_ID },
            success: function (data) {
                // 서버 응답 객체 구조 (data.info)와 키 대소문자 (대문자) 일치
                if (data && data.info) {
                    const member = data.info; // 👈 data.info로 접근
                    
                    // 아이디 (읽기 전용 필드)
                    // 키: USER_ID
                    $('#user-id').val(member.USER_ID || CURRENT_USER_ID);
                    
                    // 기본 정보
                    // 키: USER_NAME, EMAIL, PHONE
                    $('#user-name').val(member.USER_NAME || ''); 
                    $('#email').val(member.EMAIL || '');         
                    $('#phone').val(member.PHONE || '');         
                    
                    // 주소 정보
                    // 키: USER_ADDR
                    $('#zipcode').val(''); 
                    $('#main-addr').val(member.USER_ADDR || ''); 
                    $('#detail-addr').val(''); 

                    console.log("✅ 회원 정보 화면 바인딩 성공:", member);

                } else {
                    console.error("회원 정보 조회 실패: 데이터 구조 오류 또는 데이터 없음", data);
                    alert("회원 정보를 불러오는데 실패했습니다.");
                }
            },
            error: function (xhr, status, error) {
                console.error("회원 정보 조회 실패:", error);
                alert("서버 통신 오류로 회원 정보를 불러올 수 없습니다.");
            }
        });
    }

    /**
     * (예시) 개별 필드 수정 처리 함수
     * @param {string} fieldName - 수정할 필드의 name 속성 값
     */
    function fnUpdateField(fieldName) {
        // 실제로는 fieldName에 따라 해당 필드의 값만 AJAX로 업데이트하는 로직이 들어갑니다.
        alert(fieldName + " 필드 수정 로직 실행 (서버와 연동 필요)");
    }
    
    /**
     * (예시) 비밀번호 변경 처리 함수
     */
    function fnUpdatePassword() {
        const currentPw = $('#current-pw').val();
        const newPw = $('#new-pw').val();
        const confirmPw = $('#confirm-pw').val();

        if (!currentPw || !newPw || !confirmPw) {
            alert("현재 비밀번호와 새 비밀번호를 모두 입력해주세요.");
            return;
        }
        
        if (newPw !== confirmPw) {
             alert("새 비밀번호와 확인이 일치하지 않습니다.");
             return;
        }

        // 실제 AJAX 비밀번호 변경 로직 (currentPw, newPw 전송)
        alert("비밀번호 변경 로직 실행 (서버와 연동 필요)");
    }
    
    /**
     * (예시) 주소 검색 처리 함수 (Daum/Kakao Postcode API 연동 필요)
     */
    function fnSearchAddress() {
        alert("주소 검색 API (예: 다음 우편번호) 연동 필요");
        // 여기에 Daum Postcode API 호출 코드가 들어갑니다.
    }
    
    /**
     * (예시) 주소 수정 처리 함수
     */
    function fnUpdateAddress() {
        // 실제로는 우편번호, 기본 주소, 상세 주소를 묶어서 업데이트하는 로직이 들어갑니다.
        alert("주소 정보 수정 로직 실행 (서버와 연동 필요)");
    }

    /**
     * 전체 정보 수정하기 (버튼 클릭 시 실행)
     */
    function fnUpdateMemberInfo() {
        const form = $('#memberEditForm');
        
        // 비밀번호 필드는 제외하고 나머지 필드를 직렬화하여 전송할 수 있습니다.
        const serializedData = form.serializeArray().filter(item => 
            !['currentPw', 'newPw', 'confirmPw'].includes(item.name)
        );

        $.ajax({
            url: form.attr('action'), // /member/update.dox
            type: form.attr('method'), // POST
            data: serializedData,
            success: function(response) {
                if (response.success) { // 서버 응답 구조에 따라 변경
                    alert("회원 정보가 성공적으로 수정되었습니다.");
                    // 필요 시 페이지 새로고침 또는 재조회
                    fnGetMemberInfo();
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
        fnGetMemberInfo();
    });
</script> 
</html>