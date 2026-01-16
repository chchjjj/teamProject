<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>회원 정보 수정 - DessertLab</title>

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

                .form-group input:not([type="button"]):not([type="submit"]) {
                    padding: 10px 14px;
                    border: 1px solid #e6d7ce;
                    border-radius: 8px;
                    font-size: 0.95em;
                    background-color: var(--color-bg-content);
                    transition: all 0.2s ease;
                }

                .form-group input:focus {
                    border-color: var(--color-primary);
                    box-shadow: 0 0 0 3px rgba(215, 123, 102, 0.1);
                    outline: none;
                    background-color: #fff;
                }

                .form-group.readonly {
                    background-color: #f0f0f0;
                }

                .form-group.readonly input {
                    background-color: #fafafa;
                    color: #999;
                    border-style: dashed;
                }

                /* 비밀번호 그룹 특별 스타일 */
                .password-group {
                    grid-template-columns: 140px 1fr 1fr 1fr auto;
                    gap: 10px;
                }

                .password-group input {
                    min-width: 0;
                }

                /* 주소 그룹 개선 */
                .address-group {
                    grid-template-columns: 140px 1fr;
                    gap: 12px;
                }

                .address-content {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .address-line {
                    display: flex;
                    gap: 10px;
                    align-items: center;
                }

                .address-line input {
                    flex: 1;
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

                .btn-secondary.disabled {
                    background-color: #ddd;
                    cursor: not-allowed;
                    opacity: 0.6;
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

                    .password-group {
                        grid-template-columns: 1fr;
                    }

                    .address-group {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <div class="container">
                <main class="content">
                    <h2>회원 정보 수정</h2>

                    <div class="tabs">
                        <button class="tab-button active" onclick="location.href='/seller/userUpdateInfo.do'">
                            개인 정보 수정
                        </button>
                        <button class="tab-button" onclick="location.href='/seller/storeInfoupdateInfo.do'">
                            가게 정보 수정
                        </button>
                    </div>

                    <form class="edit-form" id="memberEditForm">
                        <input type="hidden" name="userId" id="hidden-user-id" value="${sessionId}">

                        <div class="form-group readonly">
                            <label for="user-id">아이디</label>
                            <input type="text" id="user-id" name="userIdDisplay" readonly>
                            <button type="button" class="btn-secondary disabled">변경 불가</button>
                        </div>

                        <div class="form-group password-group">
                            <label for="current-pw">비밀번호</label>
                            <input type="password" id="current-pw" name="currentPw" placeholder="현재 비밀번호">
                            <input type="password" id="new-pw" name="newPw" placeholder="새 비밀번호">
                            <input type="password" id="confirm-pw" name="confirmPw" placeholder="비밀번호 확인">
                            <!-- <button type="button" class="btn-action" onclick="fnUpdatePassword()">변경</button> -->
                        </div>

                        <div class="form-group">
                            <label for="user-name">닉네임/이름</label>
                            <input type="text" id="user-name" name="userName">
                            <button type="button" class="btn-action" onclick="fnUpdateMemberInfo()">수정</button>
                        </div>

                        <div class="form-group">
                            <label for="email">이메일</label>
                            <input type="email" id="email" name="email">
                            <button type="button" class="btn-action" onclick="fnUpdateMemberInfo()">수정</button>
                        </div>

                        <div class="form-group">
                            <label for="phone">연락처</label>
                            <input type="tel" id="phone" name="phone">
                            <button type="button" class="btn-action" onclick="fnUpdateMemberInfo()">수정</button>
                        </div>

                        <div class="form-group address-group">
                            <label>개인 주소</label>
                            <div class="address-content">
                                <div class="address-line">
                                    <input type="text" id="user-addr" name="userAddr" placeholder="우편번호와 기본 주소"
                                        readonly>
                                    <button type="button" class="btn-secondary" onclick="fnSearchAddress()">주소
                                        검색</button>
                                </div>
                                <button type="button" class="btn-action" onclick="fnUpdateMemberInfo()">주소 수정</button>
                            </div>
                        </div>

                        <div class="submit-area">
                            <button type="button" class="btn-primary" onclick="fnUpdateMemberInfo()">
                                전체 정보 수정하기
                            </button>
                        </div>
                    </form>
                </main>
            </div>
        </body>

        <script>
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
                        if (data && data.info) {
                            const member = data.info;
                            $('#user-id').val(member.USER_ID || CURRENT_USER_ID);
                            $('#user-name').val(member.USER_NAME || '');
                            $('#email').val(member.EMAIL || '');
                            $('#phone').val(member.PHONE || '');
                            $('#user-addr').val(member.USER_ADDR || '');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("회원 정보 조회 실패:", error);
                    }
                });
            }

            function fnSearchAddress() {
                if (typeof daum === 'undefined' || typeof daum.Postcode === 'undefined') {
                    alert("주소 검색 API가 로드되지 않았습니다.");
                    return;
                }

                new daum.Postcode({
                    oncomplete: function (data) {
                        let fullAddr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                        const combinedAddress = '(' + data.zonecode + ') ' + fullAddr + ' ';
                        $('#user-addr').val(combinedAddress);
                        $('#user-addr').prop('readonly', false);
                        $('#user-addr').focus();
                    }
                }).open();
            }

            function fnUpdateField(fieldName) {
                alert("이제 '전체 정보 수정하기' 버튼을 사용해 주세요.");
            }

            function fnUpdatePassword() {
                alert("이제 '전체 정보 수정하기' 버튼을 사용해 주세요.");
            }

            function fnUpdateAddress() {
                alert("이제 '전체 정보 수정하기' 버튼을 사용해 주세요.");
            }

            function fnUpdateMemberInfo() {
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

                const userAddr = $('#user-addr').val().trim();

                const updateData = {
                    USER_ID: CURRENT_USER_ID,
                    USER_NAME: $('#user-name').val(),
                    EMAIL: $('#email').val(),
                    PHONE: $('#phone').val(),
                    USER_ADDR: userAddr
                };

                if (newPw) {
                    updateData.USER_PWD = newPw;
                    updateData.CURRENT_PWD = currentPw;
                }

                $.ajax({
                    url: "/member/update.dox",
                    type: "POST",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(updateData),
                    success: function (response) {
                        if (response.status === "success") {
                            alert("회원 정보가 성공적으로 수정되었습니다.");
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

            $(document).ready(function () {
                fnGetMemberInfo();
            });
        </script>

        </html>