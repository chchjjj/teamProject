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
            body{
                background-color: #f1f1f1;
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
                        
                        <!-- 사진 메시지 -->
                        <div v-if="msg.messageType === 'IMAGE' && msg.content" class="message-content">
                            <img 
                                :src="msg.content" 
                                alt="첨부 이미지" 
                                style="max-width:200px; border-radius:10px; cursor:pointer;"
                                @click="openModal(msg.content)"
                            >
                        </div>

                        <!-- 텍스트 메시지 -->
                        <div v-else="msg.messageType === 'TEXT'" class="message-content">
                            {{ msg.content }}
                        </div>

                        <!-- 메시지 상태 -->
                        <div class="message-status" v-if="msg.sender === userId">
                            <span v-if="msg.isRead === 'Y'">읽음</span>
                            <span v-else>전송됨</span>
                        </div>
                    </div>

                    <!-- 이미지 모달 -->
                    <div v-if="modalVisible" 
                        @click="closeModal"
                        style="position:fixed; top:0; left:0; width:100%; height:100%; 
                                background:rgba(0,0,0,0.8); display:flex; justify-content:center; align-items:center; z-index:1000;">
                        <img :src="modalImage" style="max-width:90%; max-height:90%; border-radius:10px;">
                        <a :href="modalImage" download
                        style="position:absolute; top:10px; right:10px; color:white; font-size:16px; text-decoration:none; background:rgba(0,0,0,0.5); padding:5px 10px; border-radius:5px;">
                        다운로드
                        </a>
                    </div>
                </div>

                <footer class="chat-footer">
                    <textarea v-model="newMessage" placeholder="메시지를 입력하세요" @keyup.enter="sendMessage"></textarea>
                    <button @click="sendMessage">전송</button>
                </footer>

                <div id="chatApp" class="chat-actions">
                    <!-- 파일 선택 -->
                    <input type="file" ref="imageInput" accept="image/*" style="display:none" @change="uploadImage">
                    <button @click="$refs.imageInput.click()" >사진 첨부</button>
                    <button @click="fnGoBack">돌아가기</button>
                    <button @click="fnAddOptionPrice">기타금액 변경</button>
                </div>
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
                chatId: "${chatId}",
                orderId: "${orderId}",
                storeId: "${storeId}", 
                stompClient: null,
                modalVisible: false,
                modalImage: "",
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
                            // console.log("조회된 chatId: " + this.chatId);
                            // console.log("조회된 storeId: " + this.storeId);

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
                        //console.log("WebSocket 연결 성공: " + frame);
                       this.stompClient.subscribe('/topic/public', (message) => {
                        try {
                            const msg = JSON.parse(message.body);
                            console.log("수신 데이터 확인:", msg);

                            if (msg.messageType === 'TEXT' || msg.messageType === 'IMAGE') {
                                if (msg.sender === this.userId) {
                                    // [발신자] 내가 보낸 메시지 처리
                                    this.messages = this.messages.map(m => {
                                        // 서버 필드명 msgId를 사용해야 함!
                                        if (!m.id && m.content === msg.content) {
                                            return { ...m, id: msg.msgId, isRead: msg.isRead }; 
                                        }
                                        return m;
                                    });
                                } else {
                                    // [수신자] 상대방 메시지 도착
                                    // 수신자 리스트에도 id를 msgId로 맞춰서 넣어줘야 나중에 읽음 알림과 비교 가능
                                    const newMsg = {
                                        id: msg.msgId, 
                                        content: msg.content,
                                        sender: msg.sender,
                                        isRead: msg.isRead,
                                        messageType: msg.messageType
                                    };
                                    this.messages.push(newMsg);

                                    // 도착하자마자 읽음 처리 함수 호출
                                    this.$nextTick(() => {
                                        this.markMessagesAsRead(); 
                                    });
                                }
                            }

                            // [읽음 알림 처리 부분]
                            if (msg.type === "READ_UPDATE" || (msg.messageIds && Array.isArray(msg.messageIds))) {
                                this.messages = this.messages.map(m => {
                                    if (msg.messageIds.includes(m.id)) {
                                        return { ...m, isRead: 'Y' };
                                    }
                                    return m;
                                });
                            }
                        } catch (e) {
                            console.error("메시지 처리 에러:", e);
                        }
                        this.$nextTick(() => this.scrollToBottom());
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

                    // 1. 서버로 보낼 데이터 준비
                    const chatMessage = {
                        sender: this.userId,
                        content: this.newMessage,
                        chatId: this.chatId,
                        orderId: this.orderId,
                        storeId: this.storeId,
                        messageType: "TEXT",
                        sentAt: new Date(), // 시간 표시용
                        isRead: 'N'
                    };

                    // 2. [중요] 화면에 즉시 추가하되, 나중에 서버에서 온 진짜 데이터와 교체하기 위해
                    // 일단 내 리스트에 넣습니다. (이때는 id가 없음)
                    this.messages.push(chatMessage);
                    
                    // 3. 서버 전송
                    this.stompClient.send("/app/sendMessage", {}, JSON.stringify(chatMessage));

                    // 4. 초기화
                    this.newMessage = "";
                    this.$nextTick(() => this.scrollToBottom());
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
                            // console.log("채팅 기록 로드 성공:", response);
                            
                            // 💡 화살표 함수(Arrow Function)를 사용하여 this 스코프 문제 해결
                            this.messages = response.map((msg) => {
                                
                                const senderIdFromData = msg.USER_ID; 
                                // const isUnread = msg.IS_READ !== 'Y' && senderIdFromData !== this.userId;

                                return {
                                    id: msg.MSG_ID, 
                                    content: msg.MESSAGE,
                                    // 발신자 ID 설정
                                    sender: senderIdFromData, 
                                    // senderId와 currentUserId를 비교하여 이름 설정
                                    senderName: senderIdFromData === this.currentUserId ? '사장님' : '고객', 
                                    timestamp: msg.SENT_AT ? new Date(msg.SENT_AT) : new Date(),
                                    isRead: msg.IS_READ, // 🚀 즉시 화면 반영 
                                    messageType: msg.MESSAGE_TYPE || 'TEXT'
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

                // 돌아가기 버튼
                fnGoBack : function() {
                    window.history.back(); 
                },

                // 기타옵션금액 변경 버튼
                fnAddOptionPrice : function(){
                    window.location.href = `/seller/order/addOption.do?orderId=${orderId}`;
                },

                // 이미지 클릭 → 모달 열기
                openModal(src) {
                    this.modalImage = src;
                    this.modalVisible = true;
                },
                // 모달 클릭 → 닫기
                closeModal() {
                    this.modalVisible = false;
                    this.modalImage = '';
                },

                // 메세지 읽음처리
                markMessagesAsRead() {
                    if (!this.messages.length || !this.chatId || !this.userId) return;

                    // 읽지 않은 메시지 ID만 추출
                    const unreadMsgIds = this.messages
                        .filter(msg => msg.sender !== this.userId && msg.isRead !== 'Y' && msg.id)
                        .map(msg => msg.id);
                    
                    console.log("추출된 읽지 않은 ID들:", unreadMsgIds); // 👈 이게 빈 배열이면 DB 업데이트 안 됨

                    if (unreadMsgIds.length === 0) return;

                    // console.log("읽음 처리할 메시지 ID 목록:", unreadMsgIds);

                    axios.post('/api/chat/markAsRead', {
                        chatId: this.chatId,
                        messageIds: unreadMsgIds,
                        readerId: this.userId
                    })
                    .then(res => {
                        // console.log("읽음 처리 완료:", res.data);

                        // 1) 화면에서도 바로 반영
                        this.messages = this.messages.map(msg => {
                            if (unreadMsgIds.includes(msg.id)) {
                                return { ...msg, isRead: 'Y' };
                            }
                            return msg;
                        });

                        // 2) 읽음 상태 WebSocket으로 다른 사용자에게도 알림
                        if (this.stompClient && this.stompClient.connected) {
                            const readNotification = {
                                type: "READ_UPDATE", // ⭐ 이 한 줄을 추가해서 subscribe 쪽이 인식하게 합니다.
                                chatId: this.chatId,
                                messageIds: unreadMsgIds,
                                readerId: this.userId
                            };
                            // console.log("읽음 알림 전송:", readNotification);
                            this.stompClient.send("/app/readMessage", {}, JSON.stringify(readNotification));
                        }
                    })
                    .catch(err => {
                        console.error("읽음 처리 실패:", err);
                    });
                },

                // 사진첨부
                uploadImage(event) {
                    const file = event.target.files[0];
                    if (!file) return;

                    const formData = new FormData();
                    formData.append("image", file);

                    fetch("/chat/uploadImage.do", {
                        method: "POST",
                        body: formData
                    })
                    .then(res => res.json())
                    .then(data => {
                        const imageUrl = data.imageUrl;

                        const chatMessage = {
                            chatId: this.chatId,
                            sender: this.userId,
                            content: imageUrl,
                            messageType: "IMAGE",
                            orderId: this.orderId,
                            storeId: this.storeId,
                            sentAt: new Date(),
                            isRead: 'N'
                        };

                        // ⭐ 핵심: 서버로 보내기 전에 내 화면에 먼저 띄웁니다.
                        this.messages.push(chatMessage);

                        // 서버로 전송
                        this.stompClient.send("/app/sendMessage", {}, JSON.stringify(chatMessage));
                        
                        this.$nextTick(() => this.scrollToBottom());
                    })
                    .catch(err => console.error("이미지 업로드 실패:", err));
                },

            },
            async mounted() {
                await this.loadChatId(); // ✅ chatId를 먼저 조회
                this.connect();               //  WebSocket 연결
                                
                // console.log("로그인 아이디 ==> " + this.userId); // 로그인한 아이디 잘 넘어오나 테스트
                // console.log("주문번호 ==> " + this.orderId); // 주문번호 잘 넘어오나 테스트
                // console.log("채팅방 id ==> " + this.chatId); // 채팅방번호 잘 넘어오나 테스트
                // console.log("가게 id ==> " + this.storeId); // 채팅방번호 잘 넘어오나 테스트

                if (this.orderId) {
                    this.loadChatHistory();
                }

            },
            beforeUnmount() {
                if (this.stompClient) {
                    this.stompClient.disconnect();
                }
            }
        });

        app.mount('#app');
    </script>