<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 구매자 채팅방 ::</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/chat-style.css">
        <style>

        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">
                <!-- html 코드는 id가 app인 태그 안에서 작업 -->
                <div class="chat-room-container">
                    <header class="chat-header">
                        <h3>🛒 주문번호 : ${orderId} 채팅방</h3>
                    </header>

                    <div class="messages-area">

                        <div class="message-bubble other">
                            <div class="message-content">
                                무슨 문의사항이 있으신가요?
                            </div>
                            <div class="message-info">
                                <span class="sent-time">12:00</span>
                            </div>
                        </div>

                        <div class="message-bubble my">
                            <div class="message-info">
                                <span class="read-status">1</span>
                                <span class="sent-time">12:05</span>
                            </div>
                            <div class="message-content">
                                배송 날짜를 다음 주로 변경하고 싶어요.
                            </div>
                        </div>

                    </div>

                    <footer class="chat-footer">
                        <textarea placeholder="메시지를 입력하세요."></textarea>
                        <button>전송</button>
                    </footer>
                </div>

            </div>
            <%@ include file="/WEB-INF/main/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)

                    // 채팅에 필요한 구매자 & 주문내역 정보
                    userId : "${sessionId}",
                    chatId : "${chatId}",
                    orderId : "${orderId}",
                    orderDetailId : "${orderDetailId}",
                    orderOptionId : "${orderOptionId}",


                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnList: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list;
                        }
                    });
                },

            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;

            }
        });

        app.mount('#app');
    </script>