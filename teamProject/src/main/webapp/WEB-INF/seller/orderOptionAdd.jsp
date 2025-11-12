<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>옵션 추가/수정</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>

 <style>
    /* ---------------------------------------------------- */
    /* Color Variables (Espresso/Peony Theme) */
    /* ---------------------------------------------------- */
    :root {
        --espresso: #3E2723;
        --peony: #F4C9D6;
        --butter: #FFEDAC;
        --primary-color: var(--espresso); /* 주요 색상: 에스프레소 */
        --secondary-color: var(--peony); /* 보조 색상: 피오니 */
        --light-bg: #f4f4f4; /* 밝은 배경 */
        --white: #FFFFFF;
        --text-dark: #333;
    }

    /* ---------------------------------------------------- */
    /* 1. 중앙 정렬 및 전체 레이아웃 수정 */
    /* ---------------------------------------------------- */
    body, html {
        height: 100%;
        margin: 0;
        font-family: 'Malgun Gothic', sans-serif;
        background-color: var(--light-bg);
    }
    
    /* 화면 전체를 아우르는 컨테이너 (사이드바가 없다고 가정하고 중앙 정렬) */
    .main-container {
        display: flex;
        justify-content: center; /* 수평 중앙 정렬 */
        align-items: center; /* 수직 중앙 정렬 */
        min-height: 100vh;
        width: 100%;
        padding: 0;
    }

    .content-area {
        /* flex-grow: 1; 이 속성 대신 중앙 정렬을 위해 수정 */
        padding: 30px;
        background-color: var(--light-bg);
        margin: auto; /* 상하좌우 auto로 설정하여 flex 컨테이너 내부에서 중앙 정렬 */
        /* min-width: 300px; */ /* 중앙 정렬을 위해 max-width는 detail-card에 맡기고, content-area는 중앙에 위치하도록 함 */
    }
    /* ---------------------------------------------------- */

    .page-title {
        color: var(--primary-color);
        /* 에스프레소 색상 적용 */
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        margin-bottom: 30px;
    }

    .detail-card {
        max-width: 600px;
        /* 이전에 이미 중앙 정렬됨 */
        margin: 0 auto; 
        border: 1px solid #ccc;
        padding: 25px;
        border-radius: 10px;
        background-color: var(--white);
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-weight: bold;
        color: var(--text-dark);
        /* 기본 텍스트 색상 유지 */
        margin-bottom: 8px;
        font-size: 16px;
    }

    .form-group input[type="number"],
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-sizing: border-box;
        font-size: 15px;
    }
    /* 입력 필드에 포커스 시 에스프레소 테두리 적용 */
    .form-group input[type="number"]:focus,
    .form-group textarea:focus {
        border-color: var(--primary-color);
        outline: none;
        box-shadow: 0 0 5px rgba(62, 39, 35, 0.3); /* 에스프레소 쉐도우 */
    }

    .form-group textarea {
        resize: vertical;
        min-height: 100px;
    }

    .button-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 30px;
    }

    .action-button {
        width: 120px;
        padding: 10px;
        background-color: var(--primary-color);
        /* 에스프레소 색상 적용 */
        color: var(--white);
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-align: center;
        font-weight: bold;
        font-size: 14px;
        transition: background-color 0.2s, transform 0.2s;
    }

    .action-button:hover {
        background-color: #5d4037;
        /* 에스프레소보다 약간 밝게 (호버 효과) */
        transform: translateY(-1px);
    }

    .cancel-button {
        background-color: #6c757d;
        /* 취소 버튼은 차분한 회색 유지 */
    }

    .cancel-button:hover {
        background-color: #5a6268;
        transform: translateY(-1px);
    }
</style>
</head>

<body>
    <script>
        var initialOrderId = '<%= request.getParameter("orderId") != null ? request.getParameter("orderId") : "" %>';
    </script>

    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">주문 옵션 추가/수정</h1>

                <div class="detail-card">
                    <form @submit.prevent="submitOptionAdd">
                        <input type="hidden" name="orderId" :value="optionData.orderId">

                        <div class="order-info-header" style="margin-bottom: 20px;">
                            <p style="font-size: 16px; color: #5d5ddb; font-weight: bold;">
                                주문 번호: {{ optionData.orderId || '로드 중...' }}
                            </p>
                            <p style="font-size: 14px; color: #666;">
                                기타 옵션 금액 및 레터링 문구를 추가하거나 수정할 수 있습니다.
                            </p>
                        </div>

                        <div class="form-group">
                            <label for="addOptionPrice">기타 옵션 금액 </label>
                            <input type="number" id="addOptionPrice" name="addOptionPrice"
                                v-model.number="optionData.addOptionPrice"
                                placeholder="추가 금액을 입력하세요 (숫자만)" min="0" required>
                            <p style="font-size: 12px; color: #999; margin-top: 5px;">
                                * ORDER_TBL의 ADD_OPTION_PRICE 필드에 반영됩니다.
                            </p>
                        </div>

                        <div class="form-group">
                            <label for="letteringWord">레터링 문구/기타</label>
                            <textarea id="letteringWord" name="letteringWord"
                                v-model="optionData.letteringWord"
                                placeholder="레터링 문구를 입력하세요. (문구없음이 기본값)" maxlength="300"></textarea>
                            <p style="font-size: 12px; color: #999; margin-top: 5px;">
                                * ORDER_TBL의 LETTERING_WORD 필드에 반영됩니다.
                            </p>
                        </div>

                        <div class="button-group">
                            <button type="button" class="action-button cancel-button" @click="goBack">취소/돌아가기</button>
                            <button type="submit" class="action-button">옵션 정보 저장</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


</body>

</html>
<script>
    // 💡 핵심: initialOrderId 변수는 이미 JSP 구문으로 URL의 orderId 값을 정확히 가져오고 있습니다.
    // var initialOrderId = '<%= request.getParameter("orderId") != null ? request.getParameter("orderId") : "" %>';
    // 이 변수에 "67"과 같은 값이 담기게 됩니다.

    const app = Vue.createApp({
        // Vue.js 템플릿 구분자를 변경하지 않았으므로, '{{ ... }}'를 그대로 사용합니다.
        // delimiters: ['[[', ']]'], // (주석 처리)

        data: function() {
            return {
                optionData: {
                    // ⭐ 이 부분이 수정 없이도 URL의 값을 가져오도록 설정되었습니다.
                    // JSP에서 설정된 initialOrderId 변수의 값이 여기에 들어갑니다.
                    orderId: initialOrderId, 
                    addOptionPrice: 0,
                    letteringWord: ''
                }
            };
        },
        methods: {
            submitOptionAdd: function() {
                if (!this.optionData.orderId) {
                    alert("주문 ID가 유효하지 않습니다.");
                    return;
                }

                if (this.optionData.addOptionPrice < 0 || isNaN(this.optionData.addOptionPrice)) {
                    alert("옵션 금액은 0 이상의 숫자여야 합니다.");
                    return;
                }

                if (!confirm("주문 ID " + this.optionData.orderId + "의 옵션을 저장하시겠습니까?\n\n- 금액: " + this.formatNumber(this.optionData.addOptionPrice) + "원\n- 문구: " + (this.optionData.letteringWord || '(없음)'))) {
                    return;
                }


                $.ajax({
                    url: "/seller/optionAdd.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        orderId: this.optionData.orderId,
                        addOptionPrice: this.optionData.addOptionPrice,
                        letteringWord: this.optionData.letteringWord
                    },
                    success: function(res) {
                        if (res && res.status === "success") {
                            alert("옵션 정보가 성공적으로 저장되었습니다.");
                            window.location.href = "/seller/OrderHistoryViewDetail.do?orderId=" + initialOrderId;
                        } else {
                            alert(res.message || "옵션 정보 저장 중 오류가 발생했습니다.");
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("옵션 저장 통신 실패:", status, error);
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            goBack: function() {
                window.location.href = "/seller/OrderHistoryViewDetail.do?orderId=" + this.optionData.orderId;
            },

            formatNumber: function(number) {
                return number != null ? number.toLocaleString() : '0';
            }
        },
        mounted() {
            if (!this.optionData.orderId) {
                alert("잘못된 접근입니다. 주문 ID가 필요합니다.");
                window.history.back();
            }
        }
    });

    app.mount('#app');
</script>