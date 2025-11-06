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
                        <div v-for="(order, orderIndex) in groupedOrdersList" :key="order.orderId" class="orderCard">
                            <div class="orderCardContent">
                                <div class="orderSingle">
                                    <div>
                                        <h3 class="storeName">가게명: {{ order.storeName }}</h3>
                                    </div>

                                    <!--orderDetail级别循环（groupedDetails是对象，需要Object.values转换成数组）-->
                                    <div v-for="(orderDetail, orderDetailIndex) in Object.values(order.groupedDetails)"
                                        :key="orderDetailIndex" class="orderDetailCard">
                                        <div class="orderDetailCardContent">
                                            <div>
                                                <h3 class="proName">상품명: {{ orderDetail.proName }}</h3>
                                            </div>

                                            <!--option循环-->
                                            <ul>
                                                <li v-for="(option, optionIndex) in orderDetail.options"
                                                    :key="optionIndex" class="optionCard">
                                                    <!--这里假设optionName和valueName有对应值，如果没有可以用subOptionId/topOptionId-->
                                                    옵션: {{ option.optionName }} / {{ option.optionValue}}
                                                    (수량: {{ option.addQuantity }}개 / 추가금: {{
                                                    formatNumber(option.priceDiff) }}원)
                                                </li>
                                            </ul>

                                            <div>가격: {{ orderDetail.price }}</div>
                                            <div>수량: {{ orderDetail.quantity || 1 }}</div>
                                            <div>레터링: {{ orderDetail.letteringWord }}</div>
                                            <div>합계: {{ orderDetail.subtotal }}</div>
                                        </div>

                                    </div>
                                    <div>채팅유무(Y/N):{{ order.chatYn }}</div>
                                    <div>채팅추가비: {{ order.addOptionPrice || 0 }}</div>
                                    <div>배송방식: {{ order.deliveryType }}</div>
                                    <div>배송비: {{ order.deliveryFee }}</div>
                                    <div>주소: {{ order.fullAddress }}</div>
                                    <div>주문 시간: {{ order.orderDate }}</div>
                                    <div>
                                        <h3 class="totalPrice">총가격: {{ order.totalPrice }}</h3>
                                    </div>
                                    <div>주문 번호: {{ order.orderId }}</div>
                                </div>
                            </div>
                            <div v-if="order.chatYn==='Y'">
                                <button @click="fnChat(order.oderId,order.chatId)">채팅방으로</button>
                            </div>
                            <div>
                                <button @click="fnDelivery(order.orderId,order.deliveryType)">주문상태 자세히</button>
                            </div>
                        </div>


                        <!--order循环结束-->
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
                    orderList: [],
                    groupedOrdersList: [],
                    optionList: []
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnOrderList: function () {
                    let self = this;
                    let param = { userId: self.userId };
                    $.ajax({
                        url: "/user/orderHistory.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.orderList = data.list;
                            console.log(data.list);
                            self.fnGroupOrderList(self.orderList);
                        },
                        error: function (xhr, status, error) {
                            console.error("장바구니 로드 실패:", status, error);
                        }
                    });
                },

                fnGroupOrderList: function (list) {
                    //groupedOrdersList里面的每个order就是groupedOrders
                    //为什么包着订单的是map，而包着detail的是数组：因为订单是唯一的可以方便查找，一个订单里可能有多件商品，每个商品是一个明细
                    const groupedOrders = {};

                    //处理list是假值的情况
                    if (!Array.isArray(list) || list.length === 0) {
                        this.groupedOrdersList = [];
                        console.log("장바구니 목록이 비어 있거나 올바르지 않아 그룹화하지 않습니다.");
                        return;
                    }

                    //循环list中的每一个order
                    list.forEach(order => {
                        //每个orderId依次装进const orderId里面
                        const orderId = order.orderId;
                        //如果orderId不存在或是假值直接返回，不再继续执行代码
                        if (!orderId) return;


                        //处理带数字的万一没有值的情况
                        const deliveryType = order.deliveryType || "기본배송종류";
                        const deliveryFee = Number(order.deliveryFee || 0);
                        const totalPrice = Number(order.totalPrice || 0);
                        const addOptionPrice = Number(order.addOptionPrice || 0);
                        //1.假如groupedOrders[orderId]不存在（就是以前没有添加过，就添加）
                        if (!groupedOrders[orderId]) {
                            groupedOrders[orderId] = {
                                orderId: order.orderId,
                                storeName: order.storeName,
                                fullAddress: order.fullAddress,
                                orderDate: order.orderDate,
                                deliveryType: deliveryType,
                                deliveryFee: deliveryFee,
                                totalPrice: totalPrice,
                                chatYn: order.chatYn,
                                //添加完立刻再添加一个装details的map
                                addOptionPrice: addOptionPrice,
                                groupedDetails: {}
                            };

                        }

                        //2.装details
                        const orderDetailId = order.orderDetailId;

                        const quantity = Number(order.quantity || 0);
                        const subtotal = Number(order.subtotal || 0);
                        const price = Number(order.price || 0);
                        if (!groupedOrders[orderId].groupedDetails[orderDetailId]) {
                            groupedOrders[orderId].groupedDetails[orderDetailId] = {
                                proName: order.proName,
                                subtotal: subtotal,
                                price: price,
                                letteringWord: order.letteringWord || "",
                                quantity: quantity,
                                //添加完立刻加一个list装option
                                options: []
                            }
                        }

                        //3.因为option是最后添加的东西，用list
                        const addQuantity = Number(order.addQuantity || 0);
                        const optionName = order.optionName || "옵션 미선택"
                        // groupedOrders[orderId].groupedDetails[orderDetailId].options = groupedOrders[orderId].groupedDetails[orderDetailId].options || [];可以省略
                        groupedOrders[orderId].groupedDetails[orderDetailId].options.push({
                            topOptionId: order.topOptionId,
                            subOptionId: order.subOptionId,
                            optionName: optionName,
                            valueName: order.valueName,
                            priceDiff: order.priceDiff,
                            addQuantity: addQuantity
                        });


                    });

                    this.groupedOrdersList = Object.values(groupedOrders);
                },


                // formatNumber 함수 추가
                formatNumber: function (num) {
                    if (!num) return '0';
                    return Number(num).toLocaleString('ko-KR');
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

                },

                fnChat:function(orderId,chatId){
                    pageChange("/chat/chatBuyer.do",{orderId:orderId,chatId:chatId});
                }
            }, // methods


            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnOrderList();
            }
        });

        app.mount('#app');
    </script>