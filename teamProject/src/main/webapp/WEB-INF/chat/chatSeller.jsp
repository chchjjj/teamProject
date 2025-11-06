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
            button {
                padding: 8px 15px;
                background-color: #555;
                /* 어두운 계열 (헤더 QnA 버튼과 유사하게) */
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.3s;
                height: 38px;
                display: block; /* 버튼을 블록 레벨 요소로 만듭니다 */
                margin: 20px auto;
            }
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
                <div><button @click="fnGoBack">돌아가기</button></div>
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
                chatId: "${chatId}",
                orderId: "${orderId}",
                storeId: "${storeId}", 
                // orderDetailId: "${orderDetailId}",
                // orderOptionId: "${orderOptionId}"

                // chatId: 1001,   // 임시 chatId
                // orderId: 2001, // 임시 orderId
                // storeId: 3001, // DB 컬럼에 값이 필요하면

                };
            },
            methods: {
                // orderId로 채팅방 찾아오기
                async loadChatId() {
                    try {
                        const res = await axios.get(`/api/chat/findChatId/${orderId}`);
                        if (res.data) {
                            this.chatId = res.data.chatId;
                            this.storeId = res.data.storeId;
                            console.log("조회된 chatId: " + this.chatId);
                            console.log("조회된 storeId: " + this.storeId);

                            // chatId를 얻은 뒤 기존 메시지 로드
                            this.loadMessages();
                        } else {
                            console.warn("채팅방이 존재하지 않습니다. chatId: null");
                        }
                    } catch (error) {
                        console.error("조회 실패: ", error);
                    }
                },

                // 웹소켓 연결
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
                loadChatHistory: function() {
                    if (!this.orderId) {
                        this.loading = false;
                        return;
                    }

                    this.loading = true;
                    
                    $.ajax({
                        url: '/api/seller/chat/' + this.orderId + '/history',
                        type: 'GET',
                        dataType: 'json',
                        context: this,
                        success: function(response) {
                            console.log("채팅 기록 로드 성공:", response);
                            
                            // 💡 화살표 함수(Arrow Function)를 사용하여 this 스코프 문제 해결
                            this.messages = response.map((msg) => {
                                
                                const senderIdFromData = msg.USER_ID; 

                                return {
                                    id: msg.MSG_ID, 
                                    content: msg.MESSAGE,
                                    // 발신자 ID 설정
                                    sender: senderIdFromData, 
                                    // senderId와 currentUserId를 비교하여 이름 설정
                                    senderName: senderIdFromData === this.currentUserId ? '사장님' : '고객', 
                                    timestamp: msg.SENT_AT ? new Date(msg.SENT_AT) : new Date(),
                                };
                            });
                            
                            this.markMessagesAsRead(); 

                            this.$nextTick(function() {
                                this.scrollToBottom();
                            });
                        },
                        error: function(xhr, status, error) {
                            console.error("채팅 기록 로드 실패:", error);
                            alert("채팅 기록을 불러오는 데 실패했습니다.");
                            this.messages = [];
                        },
                        complete: function() {
                            // 💡 AJAX 호출이 끝난 후 반드시 loading 상태 해제
                            this.loading = false; 
                        }
                    });
                },
                
                // [추가] 스크롤 최하단 이동 메서드
                scrollToBottom() {
                    const chatBox = document.getElementById('chatBox');
                    if (chatBox) {
                        chatBox.scrollTop = chatBox.scrollHeight;
                    }
                },

                // 뒤로가기 버튼
                fnGoBack : function() {
                    window.history.back(); 
                }

            },
            async mounted() {
                this.connect();               //  WebSocket 연결
                await this.loadChatId(); // ✅ chatId를 먼저 조회
                
                console.log("로그인 아이디 ==> " + this.userId); // 로그인한 아이디 잘 넘어오나 테스트
                console.log("주문번호 ==> " + this.orderId); // 주문번호 잘 넘어오나 테스트
                console.log("채팅방 id ==> " + this.chatId); // 채팅방번호 잘 넘어오나 테스트
                console.log("가게 id ==> " + this.storeId); // 채팅방번호 잘 넘어오나 테스트

                //this.loadMessages();         // [추가] 기존 메시지 로드

            },
            beforeUnmount() {
                if (this.stompClient) {
                    this.stompClient.disconnect();
                }
            }
        });

        app.mount('#app');
    </script>