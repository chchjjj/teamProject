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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/ko.min.js"></script>

    <style>
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
            position: relative;
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
            padding-bottom: 150px;
        }
        
        .message-row-container { display: flex; flex-direction: column; }
        .message-row { display: flex; }
        /* 💡 'other' (구매자) 메시지는 왼쪽 정렬 */
        .other .message-row { justify-content: flex-start; }
        /* 💡 'me' (판매자) 메시지는 오른쪽 정렬 */
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
        
        .chat-input-wrapper {
            position: absolute;
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
    </style>
</head>

<body>
    <div id="app"> 
        <div class="main-wrapper">
            <div class="content-area">
                <div class="chat-container">
                    
                    <div class="chat-header">
                        [[ currentChatRoomName ]]
                    </div>
                    
                    <div class="chat-messages" ref="chatMessages">
                        <div v-if="loading" style="text-align:center; color:#999;">채팅 기록을 불러오는 중...</div>
                        <div v-if="!loading && messages.length === 0" style="text-align:center; color:#999; margin-top: 50px;">
                            채팅 기록이 없습니다. 새로운 메시지를 보내 대화를 시작하세요!
                        </div>
                        
                        <div v-for="message in messages" :key="message.id" 
                              :class="['message-row-container', message.senderId === currentUserId ? 'me' : 'other']">
                            
                            <div class="message-row">
                                <div class="message-content">
                                    <div v-if="message.senderId !== currentUserId" class="user-info">
                                        [[ message.senderName || '고객' ]]
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
                            <button style="background-color: #ccc;">+</button> 
                            <input type="text" v-model="newMessage" @keyup.enter="handleSendMessage" placeholder="메시지를 입력해주세요." :disabled="!orderId" />
                            <button @click="handleSendMessage" :disabled="!orderId">전송</button>
                        </div>
                        <div v-if="!orderId" style="color: red; text-align: center;">주문 ID가 없어 메시지를 보낼 수 없습니다.</div>
                    </div>

                </div>
            </div>
        </div>
    </div>

<script>
        moment.locale('ko'); 

        const urlParams = new URLSearchParams(window.location.search);
        const initialOrderId = urlParams.get('orderId') ? parseInt(urlParams.get('orderId')) : null; 
        
        // 현재 로그인 ID
        const currentUserId = 'user04'; 
        
        const app = Vue.createApp({
            delimiters: ['[[', ']]'],
            data: function() {
                return {
                    orderId: initialOrderId,
                    currentUserId: currentUserId,
                    currentChatRoomName: initialOrderId ? '주문 번호 ' + initialOrderId + ' 채팅방' : '채팅방 정보 없음', 
                    messages: [],
                    newMessage: '',
                    loading: true
                };
            },
            methods: {
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
                                    senderId: senderIdFromData, 
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

                // ... (handleSendMessage, markMessagesAsRead 등 나머지 메서드는 그대로 유지) ...
                
                // 전송 로직
                handleSendMessage: function() {
                    if (this.newMessage.trim() === '' || !this.orderId) return;
                    
                    var messageContent = this.newMessage.trim();
                    this.newMessage = ''; 

                    var tempMessage = {
                        id: Date.now(), 
                        senderId: this.currentUserId,
                        senderName: '사장님',
                        content: messageContent,
                        timestamp: new Date(),
                        isPending: true 
                    };
                    this.messages.push(tempMessage);
                    this.scrollToBottom();

                    var postData = {
                        orderId: this.orderId,
                        senderId: this.currentUserId, 
                        senderName: '사장님', 
                        content: messageContent
                    };
                    
                    $.ajax({
                        url: '/api/seller/chat/message',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(postData),
                        context: this,
                        success: function(response) { 
                            console.log("메시지 전송 성공:", response);
                            var sentMsgIndex = this.messages.findIndex(function(m) { return m.id === tempMessage.id; });
                            if (sentMsgIndex !== -1) {
                                this.messages[sentMsgIndex].isPending = false;
                            }
                        },
                        error: function(xhr, status, error) { 
                            console.error("메시지 전송 실패:", error);
                            alert("메시지 전송에 실패했습니다.");
                            this.messages = this.messages.filter(function(m) { return m.id !== tempMessage.id; });
                        }
                    });
                },

                markMessagesAsRead: function() {
                    if (!this.orderId) return;
                    
                    $.ajax({
                        url: '/api/seller/chat/' + this.orderId + '/read?readerId=' + this.currentUserId,
                        type: 'PATCH',
                        success: function(response) {
                            console.log("메시지 읽음 처리 성공.");
                        },
                        error: function(xhr, status, error) {
                            console.error("메시지 읽음 처리 실패:", error);
                        }
                    });
                },

                scrollToBottom: function() {
                    var container = this.$refs.chatMessages;
                    if (container) {
                        container.scrollTop = container.scrollHeight;
                    }
                },
                
                formatTime: function(timestamp) {
                    if (!timestamp) return '';
                    // 💡 API 데이터가 ISO 8601 형식(T 포함)이므로 moment가 처리 가능합니다.
                    return moment(timestamp).format('A hh:mm'); 
                },
                
                goBack: function() {
                    console.log("이전 페이지로 이동");
                    // window.history.back(); 
                }
            },
            mounted: function() {
                if (this.orderId) {
                    this.loadChatHistory();
                }
            }
        });

        app.mount('#app');
    </script>
</body>
</html>