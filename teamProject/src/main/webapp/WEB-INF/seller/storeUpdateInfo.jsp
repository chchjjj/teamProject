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
        .address-line input#zipcode { max-width: 120px; flex-grow: 0; }
        .address-line input#main-addr { flex-grow: 2; min-width: 180px; }
        .address-btn { width: 100%; margin-top: 0px; padding: 10px 15px; }
        .submit-area { margin-top: 30px; text-align: center; }
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
                
                <div class="form-group">
                    <label for="store-id">가게 번호 (STORE_ID)</label>
                    <input type="text" id="store-id" name="storeId" 
                            value="${store.storeId != null ? store.storeId : (param.storeId != null ? param.storeId : '')}" 
                            placeholder="수정할 가게 번호를 반드시 입력하세요." required>
                    <button type="button" class="btn-secondary" onclick="fnSearchStoreInfoById()">가게 정보 조회</button>
                </div>
                <div class="form-group">
                    <label for="store-name">가게 이름</label>
                    <input type="text" id="store-name" name="storeName" value="${store.storeName != null ? store.storeName : ''}">
                    <button type="button" class="btn-action" onclick="alert('전체 수정 버튼을 이용해주세요.')">개별 수정</button>
                </div>
                <div class="form-group address-group">
                    <label>가게 주소</label>
                    <div class="address-line">
                        <button type="button" class="btn-secondary" onclick="fnSearchAddress()">주소 검색</button>
                        <input type="text" id="store-main-addr" name="storeAddrMain" value="${store.storeAddrMain != null ? store.storeAddrMain : ''}" placeholder="기본 주소" readonly>
                    </div>
                    <button type="button" class="btn-action address-btn" onclick="fnUpdateAddress()">수정</button>
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

                // 🟢 [수정됨] 서버에서 반환된 대문자 키를 사용하여 필드 값을 설정합니다.
                $('#store-id').val(store.STORE_ID || '');
                $('#store-name').val(store.STORE_NAME || '');
                
                // 주소: 클라이언트에서는 storeAddrMain이지만, 서버에서는 STORE_ADDR로 옴.
                $('#store-main-addr').val(store.STORE_ADDR || ''); 

                // 가게 소개: 클라이언트에서는 storeIntro이지만, 서버에서는 STORE_INTRO로 옴.
                // HTML 인코딩 문제를 해결하기 위해, 만약 JSON에 이스케이프된 문자열이 있다면 처리할 수 있도록 decodeURI를 적용합니다.
                // DB에서 읽어온 데이터는 자동으로 이스케이프되지 않았을 가능성이 높으므로, 일반적인 접근으로 우선 처리합니다.
                let storeIntro = store.STORE_INTRO || '';
                try {
                    // Java에서 "\n"이 이스케이프되어 JSON으로 넘어왔다면 decodeURI가 도움이 될 수 있습니다.
                    storeIntro = decodeURI(storeIntro.replace(/\\n/g, "%0A")); 
                } catch(e) {
                    // 오류 발생 시 원래 문자열 사용
                }
                
                $('#store-intro').val(storeIntro);
                
                console.log("가게 정보 조회 성공:", store);
            },
            error: function(xhr,status,error){
                console.error("가게 정보 조회 실패:", error);
                // 500 에러를 겪고 온 경우, 다시 에러가 발생하면 상세 메시지를 띄우는 것이 좋습니다.
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

    function fnUpdateStoreInfo() {
        const form = $('#storeEditForm');
    const storeId = $('#store-id').val(); // 👈 여기서 값을 가져옴
    if (!storeId || storeId.trim() === '') {
        alert("가게 번호 (STORE_ID)를 반드시 입력해야 합니다.");
        $('#store-id').focus();
        return;
    }
        $.ajax({
            url: form.attr('action'),
            type: form.attr('method'),
            data: form.serialize(),
            success: function(response) {
                if (response.result === 'success' || response.success) {
                    alert("가게 정보가 성공적으로 수정되었습니다.");
                    fnGetStoreInfo(storeId);
                } else {
                    alert("정보 수정에 실패했습니다: " + (response.message || "알 수 없는 오류"));
                }
            },
            error: function(xhr,status,error){
                alert("서버 통신 오류로 정보 수정에 실패했습니다.");
            }
        });
    }

    function fnSearchAddress() {
        window.open("/user/addr.do","jusoPopup","width=500,height=600,scrollbars=yes");
    }

    function fnUpdateAddress() {
        alert("주소 수정 로직이 필요합니다. 주소 검색 후 새로운 주소를 입력하고 전체 수정 버튼을 눌러주세요.");
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