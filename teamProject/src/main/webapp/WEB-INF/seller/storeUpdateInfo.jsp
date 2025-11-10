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
        .form-group:last-of-type { border-bottom: none; }
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
        textarea { min-height: 100px; resize: vertical; }
        .btn-action, .btn-secondary, .btn-primary {
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            padding: 8px 14px;
            font-size: 0.9em;
            transition: all 0.2s ease;
        }
        .btn-action { background-color: #d77b66; color: #fff; }
        .btn-action:hover { background-color: #b75a48; }
        .btn-secondary { background-color: #b8b0aa; color: #fff; }
        .btn-secondary:hover { background-color: #9a9088; }
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
        .address-line input#store-main-addr { flex-grow: 2; min-width: 180px; }
        .address-btn { width: 100%; margin-top: 0px; padding: 10px 15px; }
        .submit-area { margin-top: 30px; text-align: center; }
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
    </style>
</head>

<body>
    <div class="container">
        <main class="content">
            <h2>가게 정보 수정</h2>
            <div class="tabs">
                <button class="tab-button" onclick="location.href='/seller/userUpdateInfo.do'">개인 정보 수정 (USER_TBL)</button>
                <button class="tab-button active" onclick="location.href='/seller/storeInfoupdateInfo.do'">가게 정보 수정 (SELLER_INFO_TBL)</button>
            </div>
            <hr>
            <form action="/store/update.dox" method="POST" class="edit-form" id="storeEditForm">
                <input type="hidden" name="userId" value="${sessionId}">
                <input type="hidden" id="initial-store-id" value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}">
                <input type="hidden" id="store-zipcode" name="storeZipcode" value="${store.storeZipcode != null ? store.storeZipcode : ''}">
                <input type="hidden" id="store-detail-addr" name="storeAddrDetail" value="${store.storeAddrDetail != null ? store.storeAddrDetail : ''}">
                
                <div class="form-group">
                    <label for="store-id">가게 번호 (STORE_ID)</label>
                    <input type="text" id="store-id" name="storeId" 
                            value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}" 
                            placeholder="수정할 가게 번호를 반드시 입력하세요." required readonly>
                    <button type="button" class="btn-secondary" onclick="fnSearchStoreInfoById()">가게 정보 조회</button>
                </div>
                <div class="form-group">
                    <label for="store-name">가게 이름</label>
                    <input type="text" id="store-name" name="storeName" value="${store.storeName != null ? store.storeName : ''}">
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
                        <label><input type="radio" name="deliveryYn" value="Y" ${store.deliveryYn == 'Y' ? 'checked' : (store.deliveryYn == null ? '' : '')}> 가능</label>
                        <label><input type="radio" name="deliveryYn" value="N" ${store.deliveryYn == 'N' ? 'checked' : (store.deliveryYn == null ? 'checked' : '')}> 불가능</label>
                    </div>
                </div>
                <div class="form-group">
                    <label>채팅 여부 (`chatYn`)</label>
                    <div class="radio-group">
                        <label><input type="radio" name="chatYn" value="Y" ${store.chatYn == 'Y' ? 'checked' : (store.chatYn == null ? 'checked' : '')}> 가능</label>
                        <label><input type="radio" name="chatYn" value="N" ${store.chatYn == 'N' ? 'checked' : (store.chatYn == null ? '' : '')}> 불가능</label>
                    </div>
                </div>
                <div class="form-group store-intro-group">
                    <label for="store-intro">가게 소개</label>
                    <textarea id="store-intro" name="storeIntro" placeholder="가게 소개글을 입력하세요.">${store.storeIntro != null ? store.storeIntro : ''}</textarea>
                </div>
                <div class="submit-area">
                    <button type="button" class="btn-primary" onclick="fnUpdateStoreInfo()">정보 수정하기</button>
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
            data: { storeId: storeId },
            success: function(data) {
                let store = data.store;
                if (!store) store = data;

                // 서버에서 반환된 대문자 키를 사용하여 필드 값을 설정합니다.
                $('#store-id').val(store.STORE_ID || '');
                $('#store-name').val(store.STORE_NAME || '');
                
                // 💡 주소 단순화: 기본 주소 (Main) 필드에만 값을 채웁니다.
                // 서버로부터는 STORE_ADDR, STORE_ZIPCODE, STORE_ADDR_DETAIL을 모두 받아와 hidden 필드에 설정합니다.
                $('#store-zipcode').val(store.STORE_ZIPCODE || '');
                $('#store-main-addr').val(store.STORE_ADDR || ''); 
                $('#store-detail-addr').val(store.STORE_ADDR_DETAIL || ''); 
                
                // 라디오 버튼 상태 업데이트
                $('input:radio[name=deliveryYn][value=' + (store.DELIVERY_YN || 'N') + ']').prop('checked', true);
                $('input:radio[name=chatYn][value=' + (store.CHAT_YN || 'Y') + ']').prop('checked', true);

                let storeIntro = store.STORE_INTRO || '';
                try {
                    storeIntro = decodeURI(storeIntro.replace(/\\n/g, "%0A")); 
                } catch(e) { }
                
                $('#store-intro').val(storeIntro);
                
                console.log("가게 정보 조회 성공:", store);
            },
            error: function(xhr,status,error){
                console.error("가게 정보 조회 실패:", error);
                alert("가게 정보 조회에 실패했습니다. (500 에러가 아닌지 서버 콘솔을 다시 확인해주세요.)");
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

    /**
     * 💡 카카오 우편번호 서비스 API를 사용하여 주소 검색 기능을 구현합니다.
     * 이 함수는 /user/addr.do API가 작동하지 않을 때의 대체 솔루션입니다.
     */
    function fnSearchAddress() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 도로명 주소 (R) 또는 지번 주소 (J)를 선택하여 사용
                const fullAddr = data.roadAddress || data.jibunAddress; 
                const extraAddr = (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) ? data.bname : '';
                
                // 서버 호환성을 위해 hidden 필드에 우편번호(ZIPCODE)를 설정합니다.
                $('#store-zipcode').val(data.zonecode); 
                
                // 화면에 보이는 기본 주소(MAIN_ADDR) 필드에 값을 설정합니다. (readonly)
                $('#store-main-addr').val(fullAddr); 
                
                // 상세 주소(DETAIL_ADDR) 필드는 사용자 입력을 유도합니다.
                // 여기서는 주소 검색으로 채워지는 것이 아니므로, 초기화하고 포커스를 줍니다.
                $('#store-detail-addr').val(''); 
                $('#store-detail-addr').focus();
                
                alert(`주소 검색이 완료되었습니다. 상세 주소를 입력한 후 '정보 수정하기' 버튼을 눌러주세요. (우편번호: ${data.zonecode})`);
            }
        }).open();
    }

    function fnUpdateStoreInfo() {
        const form = $('#storeEditForm');
        const storeId = $('#store-id').val(); 
        if (!storeId || storeId.trim() === '') {
            alert("가게 번호 (STORE_ID)를 반드시 입력해야 합니다.");
            $('#store-id').focus();
            return;
        }

        let isValid = true;
        
        // **필수 필드 검증 로직 수정 (간소화)**
        const requiredFields = [
            { id: 'store-name', msg: "가게 이름" }, 
            { id: 'store-main-addr', msg: "가게 주소" }, // 주소는 검색을 통해 채워져야 하므로 필수
            { id: 'store-intro', msg: "가게 소개" }
        ];

        for (const field of requiredFields) {
            const val = $('#' + field.id).val();
            if (!val || val.trim() === '') {
                alert(`${field.msg}을(를) 입력/선택해주세요.`);
                $('#' + field.id).focus();
                isValid = false;
                break;
            }
        }
        
        // 라디오 버튼 검증 (선택되지 않은 경우 기본값으로 간주 가능하지만, 확실히 검증)
        if (form.find('input[name="deliveryYn"]:checked').length === 0) {
            alert("배달 여부를 선택해주세요.");
            isValid = false;
        }
        if (form.find('input[name="chatYn"]:checked').length === 0) {
            alert("채팅 여부를 선택해주세요.");
            isValid = false;
        }

        if (!isValid) return;
        
        // 🚨 디버깅을 위해 불필요한 콘솔 에러를 제거하거나 정확히 로깅합니다.
        console.log("모든 필수 필드 검증 완료. AJAX 호출 시작.");
        
        $.ajax({
            url: form.attr('action'),
            type: form.attr('method'),
            data: form.serialize(),
            success: function(response) {
                if (response.result === 'success' || response.success) {
                    alert("가게 정보가 성공적으로 수정되었습니다.");
                    fnGetStoreInfo(storeId);
                } else {
                    alert("정보 수정에 실패했습니다: " + (response.message || "서버에서 알 수 없는 오류 발생."));
                }
            },
            error: function(xhr,status,error){
                alert("서버 통신 오류로 정보 수정에 실패했습니다. 상태: " + status + ", 에러: " + error);
            }
        });
    }

    // 주소 수정 버튼은 주소 검색으로 대체되었으므로 기능 변경
    function fnUpdateAddress() {
        alert("주소는 '주소 검색' 버튼을 눌러 다시 설정할 수 있습니다. 변경 후 '정보 수정하기' 버튼을 눌러주세요.");
    }

    $(document).ready(function() {
        const initialStoreId = $('#initial-store-id').val();
        
        if (initialStoreId && initialStoreId.trim() !== "") {
            console.log("페이지 로드 시 감지된 STORE_ID:", initialStoreId);
            fnGetStoreInfo(initialStoreId);
        } else {
            console.log("페이지 로드 시 초기 STORE_ID가 감지되지 않았습니다.");
        }
    });
</script>

</body>
</html>