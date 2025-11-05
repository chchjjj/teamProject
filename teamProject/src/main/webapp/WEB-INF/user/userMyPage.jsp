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
            <div class="content">
                <div>

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
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnOrderHistory: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

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
            }
        });

        app.mount('#app');
    </script>