<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 판매자 채팅방 ::</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/chat-style.css">
        <!-- 채팅관련 -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

        <!-- 채팅 기존 말풍선 불러오기 관련 -->
         <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

         
        <style>

        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
              <div id="app">
                <div class="chat-room-container">
                <header class="chat-header">
                    <h3>🛒 주문번호 : {{ orderId }} 채팅방 - 판매자</h3>
                </header>

                <div class="messages-area" id="chatBox">
                    <div v-for="(msg, idx) in messages" :key="idx" :class="['message-bubble', msg.sender === userId ? 'my' : 'other']">
                    <div class="message-content">{{ msg.content }}</div>
                    </div>
                </div>

                <footer class="chat-footer">
                    <textarea v-model="newMessage" placeholder="메시지를 입력하세요" @keyup.enter="sendMessage"></textarea>
                    <button @click="sendMessage">전송</button>
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
                // 변수

                stompClient: null,
                newMessage: "",
                messages: [], 
                userId: "${sessionId}",
                // 단일 테스트 위해 막아둠
                // chatId: "${chatId}",
                // orderId: "${orderId}",
                // orderDetailId: "${orderDetailId}",
                // orderOptionId: "${orderOptionId}"

                chatId: 1001,   // 임시 chatId
                orderId: 2001, // 임시 orderId
                storeId: 3001, // DB 컬럼에 값이 필요하면

                };
            },
            methods: {
                connect() {
                    const socket = new SockJS('/ws-chat');
                    this.stompClient = Stomp.over(socket);

                    this.stompClient.connect({}, (frame) => {
                        console.log("WebSocket 연결 성공: " + frame);
                        this.stompClient.subscribe('/topic/public', (message) => {
                            const msg = JSON.parse(message.body);
                            this.messages.push(msg);
                            // 💡 메시지를 받은 후 DOM 업데이트를 기다린 후 스크롤 이동
                            this.$nextTick(() => { 
                                this.scrollToBottom();
                            });
                        });
                    }, (error) => {
                        console.error("WebSocket 연결 실패: ", error);
                    });
                },
                sendMessage() {
                    if (!this.newMessage.trim()) return;
                    if (!this.stompClient || !this.stompClient.connected) {
                        console.warn("웹소켓이 연결되지 않았습니다.");
                        return;
                    }
                    const chatMessage = {
                        sender: this.userId,
                        content: this.newMessage,
                        chatId: this.chatId,
                        // 아래 2개는 우선 임시
                        orderId: this.orderId,
                        storeId: this.storeId
                    };
                    this.stompClient.send("/app/sendMessage", {}, JSON.stringify(chatMessage));
                    this.newMessage = "";
                },

                // 기존 메세지 로드 메소드
                loadMessages() {
                    const url = `/api/chat/messages/${chatId}`;
                    axios.get(url)
                        .then(response => {
                            // Vue data의 messages 배열에 기존 메시지 할당
                            this.messages = response.data; 
                            console.log("기존 메시지 로드 성공: ", this.messages.length + "개");
                            this.$nextTick(() => {
                                // 메시지 로드 후 스크롤을 가장 아래로 이동
                                this.scrollToBottom();
                            });
                        })
                        .catch(error => {
                            console.error("기존 메시지 로드 실패: ", error);
                        });
                },
                
                // [추가] 스크롤 최하단 이동 메서드
                scrollToBottom() {
                    const chatBox = document.getElementById('chatBox');
                    if (chatBox) {
                        chatBox.scrollTop = chatBox.scrollHeight;
                    }
                },

            },
            mounted() {
                this.connect();               //  WebSocket 연결
                this.loadMessages();         // [추가] 기존 메시지 로드
                console.log("로그인 아이디 ==> " + this.userId); // 로그인한 아이디 잘 넘어오나 테스트
            },
            beforeUnmount() {
                if (this.stompClient) {
                    this.stompClient.disconnect();
                }
            }
        });

        app.mount('#app');
    </script>