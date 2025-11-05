package com.example.teamProject.chat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.chat.dao.ChatServiceImpl;
import com.example.teamProject.chat.model.Chat;

@Controller
public class ChatController {
	
	@Autowired
	ChatServiceImpl chatService;
	
	// 판매자 기준 채팅방
	@RequestMapping("/chat/chatSeller.do") 
    public String chatSeller(Model model) throws Exception{

        return "/chat/chatSeller";
    }
	
	// 구매자 기준 채팅방
	@RequestMapping("/chat/chatBuyer.do") 
    public String chatBuyer(Model model) throws Exception{	
		
        return "/chat/chatBuyer";
    }
	
	// 카페글 내용 추가 & WebSocket 메시지 수신 및 DB 저장
//	@MessageMapping("/sendMessage") 
//	// 클라이언트에서 "/app/sendMessage"로 요청 시 실행
//    @SendTo("/topic/public") 
//	// 메시지를 "/topic/public"을 구독하는 모든 사용자에게 전송
//    public String sendMessage(String message) {
//        System.out.println("Received message: " + message); // 로그 확인
//        return message;
//    }
	
	// WebSocket 메시지 수신 및 DB 저장
	@MessageMapping("/sendMessage")
    @SendTo("/topic/public")
    public Chat sendMessage(Chat message) {
        System.out.println("웹소켓 수신 메시지: " + message);
        // 1. DB 저장
        try {
            chatService.insertBuyerChatMsg(message);
            System.out.println("메시지 DB 저장 완료: " + message.getContent());
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("메시지 DB 저장 실패");
        }
        // 2. 클라이언트로 메시지 전달
        return message;
    }
	
	
	// [추가] 채팅방 ID로 메시지 목록을 가져오는 REST API
    @GetMapping("/api/chat/messages/{chatId}")
    @ResponseBody // JSON 형태로 응답
    public List<Chat> getMessagesByChatId(@PathVariable("chatId") int chatId) {
        try {
            List<Chat> messages = chatService.selectMsgByChatId(chatId);
            System.out.println(chatId + " 채팅방 기존 메시지 " + messages.size() + "개 로드");
            return messages;
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 처리: 예외 발생 시 빈 리스트 반환 또는 적절한 HTTP 상태 코드와 함께 오류 메시지 반환
            return List.of(); 
        }
    }
	
	
	
}
