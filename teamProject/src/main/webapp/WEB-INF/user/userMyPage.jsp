<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>주문 내역</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div class="navBar">
                <!---->
                <div class="navButton">
                    <div>
                        <button @click="fnOrderHistory()">주문 내역</button>
                    </div>
                    <div>
                        <button @click="fnWishList()">찜한 상품</button>
                    </div>
                    <div>
                        <button @click="fnChatList()">채팅이력</button>
                    </div>
                    <div>
                        <button @click="fnReview()">내가 쓴 리뷰</button>
                    </div>
                    <div>
                        <button @click="fnQnA()">QnA</button>
                    </div>
                    <div>
                        <button @click="fnUserEdit()">정보수정</button>
                    </div>
                </div>

                <!--logout button-->
                <div class="logOut">
                    <div>
                        <button @click="fnLogout()">Logout</button>
                    </div>
                </div>

            </div>

            <!--내용 구역-->
            <div class="orderContainer">
                <div class="orderInfoArea">
                    <div class="storeSection">

                        <!--order层-->
                        <!--order级别的容器，循环-->
                        <div v-for="(order,orderIndex) in orderList" :key="order.orderId" class="orderCard">
                            <!--order内容级别的容器-->
                            <div class="orderCardContent">
                                <div class="orderSingle">
                                    <div>
                                        <h3 class="storeName">
                                            가게명:{{order.storeName}}
                                        </h3>
                                    </div>
                                    <!--orderDetail级别的容器，循环-->
                                    <div v-for="(orderDetail,orderDetailIndex) in order.orderDetailList"
                                        :key="orderDetailIndex" class="orderDetailCard">
                                        <!--orderDetail内容级别的容器-->
                                        <div class="orderDetailCardContent">
                                            <div>
                                                <h3 class="proName">
                                                    상품명:{{orderDetail.proName}}
                                                </h3>
                                            </div>
                                            <!--option的容器-->
                                            <ul>
                                            <!--option内容容器-->
                                               <li v-for="(option,optionIndex) in orderDetail.optionList"
                                        :key="optionIndex" class="optionCard">{{ option.optionName }} : {{ option.valueName }} (수량: {{ option.addQuantity }}개 / 추가금:
                                                    {{ formatNumber(option.priceDiff) }}원)</li>     
                                            </ul>
                                                
                                            <div>
                                                가격:{{orderDetail.price}}
                                            </div>
                                            <div>
                                                수량:{{orderDetail.quantity}}
                                            </div>
                                            <div>
                                                레터링:{{orderDetail.letteringWord}}
                                            </div>
                                            <div>
                                                합계:{{orderDetail.subtotal}}
                                            </div>
                                        </div>
                                        <!--orderDetail级别循环结束的地方-->
                                    </div>
                                    <div>
                                        채팅추가비:{{order.addOptionPrice}}
                                    </div>
                                    <div>
                                        배송방식:{{order.deliveryType}}
                                    </div>
                                    <div>
                                        배송비:{{order.deliveryFee}}
                                    </div>
                                    <div>
                                        주소:{{order.fullAddress}}
                                    </div>
                                    <div>
                                        주문 시간:{{order.orderDate}}
                                    </div>
                                    <div>
                                        <h3 class="totalPrice">
                                            총가격:{{order.totalPrice}}
                                        </h3>
                                    </div>
                                    <div>
                                        주문 번호:{{order.orderId}}
                                    </div>
                                </div>
                                <!--order容器停止的地方-->
                            </div>
                            <!--order循环停止的地方-->
                        </div>
                    </div>
                </div>
            </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    userId: "${sessionId}",
                    orderList:[],
                    orderDetailList:[],
                    optionList:[]
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                 fnOrderHistory: function () {
                    let self = this;
                    let param = { userId: self.userId };
                    $.ajax({
                        url: "/user/orderHistory.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.orderList = data.orderList;
                            console.log(data.orderList);
                            self.fnOrderList(self.orderList);
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
                },

                

                // fnBack:function(){
                //     location.href="/user/userMyPage.do";
                // },

                fnOrderHistory: function () {
                    location.href = "/user/orderHistory.do";
                },


                fnWishList: function () {
                    location.href = "/product/wishlist.do";
                },

                fnChatList: function () {
                    location.href = "/user/chatList.do";
                },


                fnReview: function () {
                    location.href = "/user/review.do";
                },

                fnQnA: function () {
                    location.href = "/user/qnA.do";
                },

                fnUserEdit: function () {
                    location.href = "/user/userEdit.do";
                },

                fnLogout: function () {

                }
            }, // methods


            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                // self.fnOrderHistory();
            }
        });

        app.mount('#app');
    </script>