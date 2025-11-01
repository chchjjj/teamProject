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
    <!-- cartId 가 필요해요! -->
    <%@ include file="/WEB-INF/main/header.jsp" %>
        <div id="app">
            <!-- cart.jsp에서 잘 가져다쓰기 -->
            <div>
                배송지: <button>배송지선택</button>
            </div>
            <div>
                주문고객: {{toName}}
            </div>
            <div>
                전화번호: {{toPhone}}
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
                cartId: "${cartId}",
                toName: "${sessionName}", //받을 사람
                toPhone: "${sessionPhone}", //받을 사람의 휴대폰 번호
                cartInfo: {}
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            
            //cart에서 선택한 주문을 여기서 보여주는 함수
            fnInfo: function () {
                let self = this;
                let param = {
                    cartId : self.cartId
                };
                $.ajax({
                    url: "/payment/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data); // 테스트용
                        self.cartInfo = data.info;
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
				    name: "", //원래는 다음과 같은 형식이다: self.info.foodName,
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
            fnPayHistory: function(uid, amount){
                let self = this;
                let param = {
                    uid: uid,
                    amount: amount
                    // 그 외 기타 등등
                };
                $.ajax({
                    url: "/product/payment.dox",
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
            self.fnInfo();
            console.log("cartId ===> " + self.cartId); // 테스트용
            console.log("toName ===> " + self.toName); // 테스트용
            console.log("toPhone ===> " + self.toPhone); // 테스트용
        }
    });

    app.mount('#app');
</script>