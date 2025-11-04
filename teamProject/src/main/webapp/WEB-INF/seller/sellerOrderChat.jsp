<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객 관리 (채팅)</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>

    <style>
        /* 기존 테이블 스타일은 채팅창에 필요 없으므로 생략하거나 주석 처리했습니다. */
        /* table, tr, td, th{ border : 1px solid black; border-collapse: collapse; padding : 5px 10px; text-align: center; } 
        th{ background-color: beige; } 
        tr:nth-child(even){ background-color: azure; } */
        
        /* 채팅창 관련 스타일 시작 */
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: #f4f4f4;
            margin-left: 220px;
        }
        
        .chat-container {
            max-width: 800px;
            height: 700px; 
            margin: 0 auto;
            border: 1px solid #ccc;
            border-radius: 10px;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            overflow: hidden; 
            position: relative; /* 하단 입력창 고정을 위해 필요 */
        }

        .chat-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background-color: #f8f8f8;
            font-weight: bold;
            text-align: center;
        }

        .chat-messages {
            flex-grow: 1; 
            padding: 20px;
            overflow-y: auto; 
            display: flex;
            flex-direction: column;
            gap: 15px;
            padding-bottom: 150px; /* 입력 영역 및 버튼 공간 확보 */
        }
        
        /* 메시지 정렬 및 말풍선 스타일 (이전과 동일) */
        .message-row-container { display: flex; flex-direction: column; }
        .message-row { display: flex; }
        .other .message-row { justify-content: flex-start; }
        .me .message-row { justify-content: flex-end; }
        .message-content { max-width: 60%; }
        .user-info { font-size: 13px; color: #555; margin-bottom: 5px; }

        .message-bubble {
            padding: 10px 15px;
            border-radius: 18px;
            line-height: 1.4;
            word-wrap: break-word; 
        }
        
        .other .message-bubble { background-color: #e6e6e6; color: #333; border-top-left-radius: 4px; }
        .me .message-bubble { background-color: #5d5ddb; color: white; border-top-right-radius: 4px; }

        .message-info { font-size: 12px; color: #999; margin-top: 4px; }
        .me .message-info { text-align: right; }
        
        /* 입력 영역 고정 */
        .chat-input-wrapper {
            position: absolute; /* .chat-container에 상대적으로 고정 */
            bottom: 0;
            width: 100%;
            display: flex;
            flex-direction: column;
            padding: 15px;
            border-top: 1px solid #eee;
            background-color: white;
            box-sizing: border-box;
            gap: 10px;
        }

        .input-fields {
            display: flex;
            width: 100%;
        }

        .input-fields input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
        }

        .input-fields button:last-child {
            padding: 10px 20px;
            background-color: #5d5ddb;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            white-space: nowrap;
        }
        
        .chat-footer button {
            padding: 8px 30px;
            background-color: #ddd;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: #333;
            width: 100%;
        }

        .back-button-area {
            text-align: center;
        }
        /* 채팅창 관련 스타일 끝 */
    </style>
</head>

<body>
    <script>
        // JSP에서 orderId 파라미터 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const initialOrderId = urlParams.get('orderId') || '1'; 
        // 로그인한 판매자 ID (현재 user04로 가정)
        const currentUserId = 'user04';
    </script>

    <div id="app"> 
        <div class="main-wrapper">
            <div class="content-area">
                <div class="chat-container">
                    
                    <div class="chat-header">
                        [[ currentChatRoomName ]]
                    </div>
                    
                    <div class="chat-messages" ref="chatMessages">
                        <div v-if="loading" style="text-align:center; color:#999;">채팅 기록을 불러오는 중...</div>
                        
                        <div v-for="message in messages" :key="message.id" 
                             :class="['message-row-container', message.senderId === currentUserId ? 'me' : 'other']">
                            
                            <div class="message-row">
                                <div class="message-content">
                                    <div v-if="message.senderId !== currentUserId" class="user-info">
                                        [[ message.senderName ]]
                                    </div>
                                    <div class="message-bubble">
                                        [[ message.content ]]
                                    </div>
                                    <div class="message-info">
                                        [[ formatTime(message.timestamp) ]]
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="chat-input-wrapper">
                        <div class="back-button-area">
                            <button @click="goBack">이전으로</button>
                        </div>

                        <div class="input-fields">
                            <button style="background-color: #ccc;">...</button>
                            <input type="text" v-model="newMessage" @keyup.enter="sendMessage" placeholder="메시지를 입력해주세요." />
                            <button @click="sendMessage">전송</button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        // Vue 인스턴스 생성 및 로직
        const app = Vue.createApp({
            delimiters: ['[[', ']]'],
            data() {
                return {
                    orderId: initialOrderId,
                    currentUserId: currentUserId,
                    currentChatRoomName: '000 고객님과 채팅방', // 더미 데이터
                    messages: [],
                    newMessage: '',
                    loading: true
                };
            },
            methods: {
                loadChatHistory() {
                    this.loading = true;
                    // --- [더미 데이터] ---
                    const dummyData = [
                        { id: 1, senderId: 'customer01', senderName: '000 고객님', content: '안녕하세요! 사장님 문의 드릴 게 있어요.', timestamp: new Date(2025, 10, 3, 10, 0) },
                        { id: 2, senderId: 'customer01', senderName: '000 고객님', content: '친구 사진이 들어간 케이크를 제작하고 싶은데 가능한가요? 그리고 시안 주변에 꽃 모양 조형물로 장식하고 싶은데 이렇게 하면 제작 비용이 얼마나 될까요?', timestamp: new Date(2025, 10, 3, 10, 1) },
                        { id: 3, senderId: this.currentUserId, senderName: '사장님', content: '문의하신 요청 가능합니다 !!', timestamp: new Date(2025, 10, 3, 10, 5) },
                        { id: 4, senderId: this.currentUserId, senderName: '사장님', content: '그림 추가 비용 5천원이 발생하는데 괜찮으실까요?', timestamp: new Date(2025, 10, 3, 10, 5) },
                        { id: 5, senderId: 'customer01', senderName: '000 고객님', content: '알겠습니다. 사장님 추가해 주시면 바로 결제 하겠습니다!', timestamp: new Date(2025, 10, 3, 10, 6) }
                    ];
                    // ------------------
                    setTimeout(() => { 
                        this.messages = dummyData;
                        this.loading = false;
                        this.$nextTick(() => {
                            this.scrollToBottom();
                        });
                    }, 500);
                },

                sendMessage() {
                    if (this.newMessage.trim() === '') return;
                    
                    const newMsg = {
                        id: Date.now(), 
                        senderId: this.currentUserId,
                        senderName: '사장님',
                        content: this.newMessage.trim(),
                        timestamp: new Date()
                    };

                    this.messages.push(newMsg);
                    this.newMessage = '';

                    this.$nextTick(() => {
                        this.scrollToBottom();
                    });
                    
                    console.log("메시지 전송됨:", newMsg.content);
                },

                scrollToBottom() {
                    const container = this.$refs.chatMessages;
                    if (container) {
                        container.scrollTop = container.scrollHeight;
                    }
                },
                
                formatTime(timestamp) {
                    if (!timestamp) return '';
                    return moment(timestamp).format('A hh:mm');
                },
                
                goBack() {
                    // 실제 이동할 페이지로 변경
                    console.log("이전 페이지로 이동");
                    // window.history.back(); 
                }
            },
            mounted() {
                this.loadChatHistory();
            }
        });

        app.mount('#app');
    </script>
</body>
</html>