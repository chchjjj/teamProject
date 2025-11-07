<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구매화면</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
    /* 1. CSS 변수 정의 (변경 없음) */
    :root {
        /* 메인 컬러: 네비게이션 및 버튼에 사용되는 진한 갈색 */
        --main-bg-color: #3C2F2F; 
        /* 배경색: RGB (240, 226, 182) 밝은 베이지색 */
        --sub-bg-color: #F0E2B6; 
        /* 카드 내부 배경색 (흰색 유지) */
        --card-bg-color: #FFFFFF;
        /* 강조 버튼/링크 색상 */
        --primary-color: #6B574C; 
        /* 일반 텍스트 색상 */
        --text-color: #333333;
        /* 연한 테두리 색상 */
        --border-color: #E0E0E0;
        /* 밝은 배경 도트 패턴 색상 (배경색과 동일하게) */
        --light-dot-bg-color: rgba(0,0,0,0.35); /* 살짝 투명한 검은색으로 은은한 도트 효과 */
    }
    
    /* 2. body 및 전체 배경 스타일 (변경 없음) */
    body {
        /* ★★★ 메인/헤더 상단과 동일한 밝은 베이지색 배경 ★★★ */
        background-color: var(--sub-bg-color); 
        
        /* ★★★ 헤더 상단과 동일한 은은한 도트 패턴 적용 ★★★ */
        background-image: radial-gradient(circle at 1px 1px, var(--light-dot-bg-color) 1px, transparent 0);
        /* 도트 간 간격 조정 (30px 유지) */
        background-size: 30px 30px; 
        
        min-height: 100vh;
        font-family: 'Malgun Gothic', 'Dotum', sans-serif;
        color: var(--text-color);
        margin: 0; /* body 기본 마진 제거 */
    }

    /* ================= 헤더 전용 스타일 ================= */

    /* 3. 상단 헤더 영역 (로고, 검색창) */
    .top-header {
        background-color: var(--sub-bg-color); /* 밝은 베이지색 배경 */
        /* 도트 패턴은 body에서 상속받음 */
        padding: 10px 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .header-inner {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;
    }

    .logo img {
        height: 50px; /* 로고 이미지 높이 조정 */
    }

    /* 검색 영역 */
    .search-and-user-area {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .search-box {
        display: flex;
        border: 2px solid var(--primary-color); /* 검색창 테두리 색상 */
        border-radius: 20px;
        overflow: hidden;
        background-color: var(--card-bg-color); /* 흰색 */
    }

    .search-box input {
        border: none;
        padding: 8px 15px;
        outline: none;
        width: 250px;
        font-size: 15px;
    }

    .search-box button {
        background-color: transparent;
        border: none;
        cursor: pointer;
        padding: 0 10px;
        color: var(--primary-color);
    }
    
    /* 유저 메뉴 (찜, 로그인/로그아웃) (변경 없음) */
    .user-menu img {
        cursor: pointer;
        height: 30px; /* 아이콘 크기 조정 */
        margin-left: 10px;
        vertical-align: middle;
    }

    .admin-notice {
        background-color: red;
        color: white;
        text-align: center;
        font-weight: bold;
        padding: 5px 0;
        /* 수정됨: 14px -> 16px */
        font-size: 16px; 
    }

    /* 4. 메인 네비게이션 영역 (카테고리 메뉴) (변경 없음) */
    .main-nav-container {
        /* ★★★ 진한 갈색 배경 적용 ★★★ */
        background-color: var(--main-bg-color); 
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .nav-inner {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .main-menu {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        justify-content: space-around; /* 메뉴 항목 간격 균등하게 분배 */
    }

    .menu-item {
        position: relative;
    }

    .menu-item a {
        display: block;
        padding: 15px 20px;
        text-decoration: none;
        color: white; /* ★★★ 메뉴 텍스트 색상 ★★★ */
        font-weight: bold;
        transition: background-color 0.2s;
    }

    .menu-item a:hover {
        background-color: #5A473D; /* 마우스 호버 시 살짝 어둡게 */
    }

    /* 드롭다운 서브메뉴 (변경 없음) */
    .submenu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background-color: var(--main-bg-color); /* 진한 갈색 */
        list-style: none;
        padding: 0;
        margin: 0;
        min-width: 150px;
        z-index: 10;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .dropdown:hover .submenu {
        display: block; /* 마우스 오버 시 서브메뉴 표시 */
    }

    .submenu li a {
        padding: 10px 20px;
        font-weight: normal;
    }

    /* ================= 메인 콘텐츠 영역 스타일 (font-size 수정됨) ================= */

    /* 5. 메인 콘텐츠 컨테이너 설정 (변경 없음) */
    #app-container {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 40px 20px;
        width: 100%;
        box-sizing: border-box;
    }

    /* 6. 주문 카드 스타일 (변경 없음) */
    #app {
        width: 100%;
        max-width: 900px;
        background-color: var(--card-bg-color); 
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    
    /* (상품 정보, 구분선, 배송지/주문고객 정보, 버튼 스타일 등) */

    .order-item-card {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 15px 0;
        border-bottom: 1px dashed var(--border-color);
    }

    .order-item-card:last-of-type {
        border-bottom: none;
        padding-bottom: 0;
    }
    
    .item-details {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }
    
    .item-details > div {
        /* 수정됨: 14px -> 16px (일반 상세 정보) */
        font-size: 16px; 
    }
    
    .item-details .delivery-type {
        color: var(--primary-color); 
        font-weight: 500;
    }

    .item-details .pro-name {
        font-weight: bold;
        /* 수정됨: 16px -> 18px (상품명 강조) */
        font-size: 18px; 
        margin-bottom: 5px;
    }

    .item-meta {
        text-align: right;
        min-width: 100px;
    }

    .item-meta .total-price {
        font-weight: bold;
        /* 수정됨: 18px -> 20px (개별 상품 가격 강조) */
        font-size: 20px; 
        color: var(--primary-color);
        margin-bottom: 5px;
    }

    .separator {
        border: none;
        border-top: 1px solid var(--border-color);
        margin: 20px 0;
    }
    
    .info-section {
        padding: 20px 0;
        display: flex;
        flex-direction: column;
        gap: 15px;
        color: var(--text-color); 
    }
    
    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 24px; 
    }
    
    .total-payment {
        padding: 20px 0;
        border-top: 2px solid var(--border-color);
        font-size: 30px; 
        font-weight: bold;
        text-align: right;
        color: var(--primary-color);
    }

    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.2s;
        margin-left: 20px;
        font-size: 22px;
    }
    
    .btn-delivery {
        background-color: transparent;
        color: var(--primary-color);
        border: 1px solid var(--primary-color);
        font-size: 18px; 
        padding: 8px 16px;
        margin-left: 10px;
    }
    
    .btn-delivery:hover {
        background-color: var(--primary-color);
        color: var(--card-bg-color);
    }

    .btn-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 30px;
    }

    .btn-cancel {
        background-color: #F0F0F0;
        color: var(--text-color);
        font-weight: normal;
    }
    
    .btn-cancel:hover {
        background-color: #E0E0E0;
    }

    .btn-primary {
        background-color: var(--primary-color);
        color: white;
    }

    .btn-primary:hover {
        background-color: #5A473D;
    }
</style>
</head>
<body>
    
    <%@ include file="/WEB-INF/main/header.jsp" %>
    
    <div id="app-container">
        <div id="app">
            <h2 style="margin-top: 0; color: var(--primary-color); text-align: center; font-size: 30px;">주문 상세 내역</h2>
            <div class="order-list">
                <div v-for="item in orderList" class="order-item-card">
                    
                    <div class="item-details">
                        <div class="pro-name">
                            {{item.proName}}
                        </div>
                        <div class="delivery-type">
                            배송 선택: {{item.deliveryType}}
                        </div>
                        <div>
                            판매처: {{item.storeName}}
                        </div>
                    </div>

                    <div class="item-meta">
                        <div class="total-price">
                            {{item.totalPrice.toLocaleString('ko-KR')}} 원
                        </div>
                        <div>
                            수량: {{item.quantity}} 개
                        </div>
                    </div>

                    </div>
                </div>
            
            <hr class="separator"> <div class="info-section">
                
                <div class="info-row">
                    <span>배송 정보</span>
                    <button @click="fnDelivery" class="btn btn-delivery">배송지 선택/변경</button>
                </div>
                
                <div class="info-row">
                    <span>주문 고객:</span>
                    <span>{{toName}}</span>
                </div>
                
                <div class="info-row">
                    <span>전화번호:</span>
                    <span>{{toPhone}}</span> 
                </div>

            </div>
            
            <div class="total-payment">
                총 결제 금액: {{paymentPrice.toLocaleString('ko-KR')}} 원
            </div>
            
            <div class="btn-group">
                <button @click="fnGoBack" class="btn btn-cancel">취소하기</button>

                <button @click="fnPayment" class="btn btn-primary">결제하기</button>

            </div>

        </div>
    </div>
    
    <%@ include file="/WEB-INF/main/footer.jsp" %>
    
    <script>
        IMP.init("imp44302855");
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    toName: "${sessionName}", //받을 사람
                    toPhone: "${sessionPhone}", //받을 사람의 휴대폰 번호
                    orderList: [], //화면에 보이는 정보, 배송 정보 확정 전 단계, ORDER_TBL + ORDER_DETAIL_TBL + ORDER_OPTION_TBL
                    deliveryType: "", //배달인지 픽업인지 (배달이면 D, 픽업이면 P)
                    paymentPrice: 0, //최종 결제금액
                    
                    //order 관련 변수
                    // 1. 바로 구매 버튼을 누른 경우 order 테이블에서 사용 / 2. 장바구니 담고 나서 구매하는 경우 바로 이 페이지에서 생성한 주문번호
                    orderId : "${orderId}", //이전 페이지에서 orderId로 받을 때
                    orderIdList : []//이 페이지에서 order 관련 테이블의 데이터에 접근할 때 사용
                };
            },
            methods: {
                // 함수(메소드) - (key : function())

                
                fnOrderList: function(){
                    let self = this;
                    console.log("JSON.stringify 이전: " + self.orderIdList);
                    let orderIdList = JSON.stringify(self.orderIdList);
                    console.log("JSON.stringify 이후: " + orderIdList);
                    let param = {
                        orderIdList : orderIdList
                    };
                    $.ajax({
                        url: "/payment/orderList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log("Order 리스트 출력");// 테스트용
                            console.log(data);// 테스트용
                            self.orderList = data.list; //order 테이블 정보만 담으면 된다.
                            self.deliveryType = data.list.deliveryType; //배달인지 픽업인지
                            // self.paymentPrice = data.list.totalPrice;

                            for(let i=0; i<self.orderList.length; i++){
                                self.paymentPrice += self.orderList[i].totalPrice;
                                console.log("self.orderList[i].totalPrice:" + self.orderList[i].totalPrice);
                            }
                        }
                    });
                },

                //결제 성공까지 했을 때 필요 없어진 장바구니 목록을 지우는 함수
                fnCartDelete: function(){
                    let self = this;
                    cartIdList = JSON.stringify(self.cartIdList);
                    let param = {
                        cartIdList : cartIdList
                    };
                    $.ajax({
                        url: "/payment/cartRemove.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log("장바구니 비우기");// 테스트용
                            console.log(data);// 테스트용
                            
                            
                        }
                    });
                },

                //ORDER_TBL의 배송지, 배송비, 총 결제금액, 배송/픽업 선택 업데이트
                fnDelivery: function(){
                    let self = this;
                    window.open("/payment/addressPopUp.do?orderIdList="+self.orderIdList, "addressPopUp", "width=700, height=500, top=100, left=100");
                },

                //결제 버튼을 누르면 이 함수를 실행
                fnPayment: function(){
                    let self = this;
                    IMP.request_pay({
                        pg: "html5_inicis",
                        pay_method: "card",
                        merchant_uid: "merchant_" + new Date().getTime(),
                        name: self.orderList[0].proName, //상품이름, 대표로 제일 첫번째 상품명을 보여준다.
                        amount: 1, //실제 결제금액은 1원, 원래는 self.info.totalPrice
                        buyer_tel: self.toPhone, // 구매자 휴대폰 번호
                        buyer_name: self.toName // 구매자 성함
                      } , function (rsp) { // callback
                          if (rsp.success) {
                            // 결제 성공 시
                            //alert("성공");
                            console.log(rsp);
                            self.fnPayHistory(rsp.imp_uid, rsp.paid_amount);
                          } else {
                            // 결제 실패 시
                            //alert("실패");
                          }
                    });
                },

                //PAYMENT_TBL에 결제내역을 추가하는 쿼리문
                fnPayHistory: function(uid, amount){
                    let self = this;
                    let param = {
                        uid: uid,
                        amount: amount,
                        orderList: JSON.stringify(self.orderList)
                        // 그 외 기타 등등
                    };
                    $.ajax({
                        url: "/payment/payment.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if(data.result == "success"){
                                alert("결제되었습니다!");
                                location.href="/main.do";
                            } else {
                                alert("오류가 발생했습니다!");
                                location.href="/main.do";
                            }
                        }
                    });
                },

                fnGoBack: function(){
                    window.history.back();
                }

                
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                let orderId = self.orderId.trim(); // 혹시 모를 공백 제거

                //주문번호를 장바구니에서 받지 않은 경우
                if(orderId && orderId.length > 0) {
                    console.log("orderId 값이 존재하며 orderId 값은 => " + self.orderId);
                    self.orderIdList.push(orderId);
                } 
                
                //주문번호를 장바구니에서 받는 경우
                else {
                    let str = "${orderIdList}";
                    self.orderIdList = JSON.parse(str); //파싱을 해줘야 문자열을 리스트로 바꿀 수 있다.
                    
                }

                console.log("최종적으로 사용할 orderIdList 값은 => " + self.orderIdList);
                self.fnOrderList();
                
                
                
                
            }
        });

        app.mount('#app');
    </script>
</body>
</html>