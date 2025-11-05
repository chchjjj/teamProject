package com.example.teamProject.chat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

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
	
	
}
