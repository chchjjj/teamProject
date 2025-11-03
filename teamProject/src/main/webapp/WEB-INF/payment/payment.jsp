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
            <div>
                <label>픽업: <input type="radio" v-model="deliveryType" value="P"></label>
                <br>
                <label>배송: <input type="radio" v-model="deliveryType" value="D"></label>
            </div>
            <div>
                배송지: <button>배송지선택</button>
            </div>
            <div>
                주문고객: {{toName}}
            </div>
            <div>
                전화번호: {{toPhone}}
            </div>

            <div>
                <button>취소하기</button>
                <button @click="fnDelivery">결제하기</button> <!-- 배송비가 확정이 되야 결제가 가능, 그래서 일부러 fnDelivery를 실행 -->
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
                cartIdList : "${cartIdList}", //장바구니에서 주문하기 버튼 누르는 경우 필요
                toName: "${sessionName}", //받을 사람
                toPhone: "${sessionPhone}", //받을 사람의 휴대폰 번호
                cartList: [], //CART_TBL + CART_OPTION_TBL
                orderList: [], //화면에 보이는 정보, 배송 정보 확정 전 단계, ORDER_TBL + ORDER_DETAIL_TBL + ORDER_OPTION_TBL
                deliveryType : "D", // 배송 또는 픽업 선택
                
                //order 관련 변수
                // 1. 바로 구매 버튼을 누른 경우 order 테이블에서 사용 / 2. 장바구니 담고 나서 구매하는 경우 바로 이 페이지에서 생성한 주문번호
                orderId : "${orderId}", //이전 페이지에서 orderId로 받을 때
                orderIdList : "${orderIdList}" //이 페이지에서 order 관련 테이블의 데이터에 접근할 때
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            
            //CART에서 선택한 주문들을 여기서 보여주는 함수
            fnCartList: function () {
                let self = this;
                let param = {
                    cartIdList : self.cartIdList
                };
                $.ajax({
                    url: "/payment/cartList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);// 테스트용
                        self.cartList = data.list;
                    }
                });
            },

            //ORDER TBL 에 INSERT
            fnAddOrder: function () {
                let self = this;
                let param = {
                    cartList : self.cartList
                };
                $.ajax({
                    url: "/payment/addOrder.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("ORDER_TBL INSERT");// 테스트용
                        console.log(data);// 테스트용
                        self.fnAddOrderDetail();
                    }
                });
            },

            //ORDER_DETAIL_TBL 에 INSERT
            fnAddOrderDetail: function(){
                let self = this;
                let param = {
                    cartList : self.cartList
                };
                $.ajax({
                    url: "/payment/addOrderDetail.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("ORDER_DETAIL_TBL INSERT");// 테스트용
                        console.log(data);// 테스트용
                        self.fnAddOrderOption();
                    }
                });
            },

            //ORDER_OPTION_TBL 에 INSERT
            fnAddOrderOption: function(){
                let self = this;
                let param = {
                    cartList : self.cartList
                };
                $.ajax({
                    url: "/payment/addOrderOption.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("ORDER_OPTION_TBL INSERT");// 테스트용
                        console.log(data);// 테스트용
                        self.fnOrderList(); //이제야 비로소 화면 출력 가능
                    }
                });
            },

            //이 페이지 화면에 출력하게될 정보를 찾는 함수
            fnOrderList: function(){
                let self = this;
                let param = {
                    orderIdList : self.orderIdList
                };
                $.ajax({
                    url: "/payment/orderList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("Order 리스트 출력");// 테스트용
                        console.log(data);// 테스트용
                        self.orderList = data.list;
                    }
                });
            },

            //ORDER_TBL의 배송지, 배송비, 총 결제금액, 배송/픽업 선택 업데이트
            fnDelivery: function(){
                let self = this;
                let param = {
                    //일단은 배송/픽업 선택 바뀌는지만 보도록 하겠음
                    deliveryType : self.deliveryType,
                    orderId : self.orderId
                };
                $.ajax({
                    url: "/payment/delivery.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.fnPayment()
                    }
                });
            },

            //결제 버튼을 누르면 이 함수를 실행
            fnPayment: function(){
                let self = this;
                IMP.request_pay({
				    pg: "html5_inicis",
				    pay_method: "card",
				    merchant_uid: "merchant_" + new Date().getTime(),
				    name: "1", //상품이름, 원래는 다음과 같은 형식이다: self.info.foodName,
				    amount: 1, //결제금액은 1원, 원래는 self.info.totalPrice
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
                    orderIdList: self.orderIdList
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
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;

            //주문번호를 받은 경우
            if("${orderId}") {
                self.fnOrderList();
                console.log("self.fnOrderList(); 실행중");
                console.log("orderId 값은 => " + self.orderId);
            }

            //장바구니 번호를 받은 경우
            else if("${cartIdList}"){
                self.fnCartList();
                self.fnAddOrder();
                console.log("cartIdList ===> " + self.cartIdList); // 테스트용
                console.log("self.cartList.proName ===> " + self.cartList.proName); // 테스트용
            }
            
        }
    });

    app.mount('#app');
</script>