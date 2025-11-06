<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구매화면</title>
    <link rel="stylesheet" href="/css/cart-style.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    
    <%@ include file="/WEB-INF/main/header.jsp" %>
        <div id="app">
            <div v-for="item in orderList">
                <div>
                    상품명: {{item.proName}}
                </div>
                <div>
                    배송 선택: {{item.deliveryType}}
                </div>
                <hr>
            </div>
            <div>
                배송지: <button @click="fnDelivery">배송지선택</button>
            </div>
            <div>
                주문고객: {{toName}}
            </div>
            <div>
                전화번호: {{toPhone}}
            </div>
            

            <div>
                <button>취소하기</button>

                <!-- 첫번째 줄 거는 테스트 편의용, 두번째 거가 실제 사용용 -->
                <button @click="fnPayHistory('1', '1')">결제하기</button>
                <!-- <button @click="fnPayment">결제하기</button> -->

            </div>

        </div>
    <%@ include file="/WEB-INF/main/footer.jsp" %>
</body>
</html>

<script>
    IMP.init("imp44302855");
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                toName: "${sessionName}", //받을 사람
                toPhone: "${sessionPhone}", //받을 사람의 휴대폰 번호
                orderList: [], //화면에 보이는 정보, 배송 정보 확정 전 단계, ORDER_TBL + ORDER_DETAIL_TBL + ORDER_OPTION_TBL
                
                
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
                console.log(self.orderIdList);
                let orderIdList = JSON.stringify(self.orderIdList);
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
                 window.open("/payment/addressPopUp.do", "addressPopUp", "width=700, height=500, top=100, left=100");
            },

            //결제 버튼을 누르면 이 함수를 실행
            fnPayment: function(){
                let self = this;
                IMP.request_pay({
				    pg: "html5_inicis",
				    pay_method: "card",
				    merchant_uid: "merchant_" + new Date().getTime(),
				    name: "1", //상품이름, 원래는 다음과 같은 형식이다: self.info.foodName,
				    amount: 1, //실제 결제금액은 1원, 원래는 self.info.totalPrice
				    buyer_tel: "010-0000-0000",
				  }	, function (rsp) { // callback
			   	      if (rsp.success) {
			   	        // 결제 성공 시
						//alert("성공");
						console.log(rsp);
                        self.fnPayHistory(rsp.imp_uid, rsp.paid_amount);
			   	      } else {
			   	        // 결제 실패 시
						alert("실패");
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
                        } else {
                            alert("오류가 발생했습니다!");
                        }
                    }
                });
            },

           
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