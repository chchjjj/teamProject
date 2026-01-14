package com.example.teamProject.chat.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.chat.dao.ChatServiceImpl;
import com.example.teamProject.chat.model.Chat;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ChatController {
	
	@Autowired
	ChatServiceImpl chatService;
	
	@Autowired
    private SimpMessagingTemplate messagingTemplate; // 추가
	
	// 판매자 기준 채팅방
	@RequestMapping("/chat/chatSeller.do") 
    public String chatSeller(
    		@RequestParam(value="orderId", required=false) String orderId,
    		Model model) throws Exception{		
		model.addAttribute("orderId", orderId);
	    System.out.println("판매자 화면에서 받은 orderId: " + orderId);
	    
        return "/chat/chatSeller";
    }
	
	// 구매자 기준 채팅방
	@RequestMapping("/chat/chatBuyer.do") 
    public String chatBuyer(
    		@RequestParam(value="orderId", required=false) String orderId,
    	    Model model) throws Exception{			
		
		model.addAttribute("orderId", orderId);
	    System.out.println("구매자 화면에서 받은 orderId: " + orderId);
	    
        return "/chat/chatBuyer";
    }
	
	// [신규] orderId로 chatId & storeId 조회 (axios용)
	@GetMapping("/api/chat/findChatId/{orderId}")
	@ResponseBody
	public Map<String, String> findChatIdByOrderId(@PathVariable("orderId") String orderId) {
	    Map<String, String> result = new HashMap<>();
	    try {
	        String chatId = chatService.selectChatIdByOrderId(orderId);
	        String storeId = chatService.selectStoreIdByOrderId(orderId);

	        result.put("chatId", chatId != null ? chatId : "");
	        result.put("storeId", storeId != null ? storeId : "");

	        System.out.println("Axios 요청으로 조회된 chatId: " + chatId);
	        System.out.println("Axios 요청으로 조회된 storeId: " + storeId);

	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("chatId", "");
	        result.put("storeId", "");
	        return result;
	    }
	}       
	
		
	// WebSocket 메시지 수신 및 DB 저장
//	@MessageMapping("/sendMessage")
//    @SendTo("/topic/public")
//    public Chat sendMessage(Chat message) {
//        System.out.println("웹소켓 수신 메시지: " + message);
//        // 1. DB 저장
//        try {
//            chatService.insertChatMsg(message);
//            System.out.println("구매자 메시지 DB 저장 완료: " + message.getContent());
//        } catch (Exception e) {
//            e.printStackTrace();
//            System.err.println("구매자 메시지 DB 저장 실패");
//        }
//        // 2. 클라이언트로 메시지 전달
//        return message;
//    }
	
	

	
	// WebSocket 메시지 수신 및 DB 저장 
	@MessageMapping("/sendMessage")
	@SendTo("/topic/public")
	public Chat sendMessage(Chat message) {
	    try {
	        if (message.getMessageType() == null || message.getMessageType().isEmpty()) {
	            message.setMessageType("TEXT");
	        }

	        // 1. DB 저장 (XML 수정 덕분에 저장 후 message 객체의 msgId 필드에 값이 자동으로 채워짐)
	        chatService.insertChatMsg(message);
	        
	        // 2. 확인용 로그 (콘솔에서 ID가 0이 아닌 숫자로 찍히는지 확인하세요)
	        System.out.println("메시지 저장 완료! 생성된 ID: " + message.getMsgId());
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    // 3. 이제 이 message 객체에는 msgId가 포함되어 구독자들에게 전달됨
	    return message;
	}
		
	// [추가] 채팅방 ID로 메시지 목록을 가져오는 REST API
    @GetMapping("/api/chat/messages/{chatId}")
    @ResponseBody // JSON 형태로 응답
    public List<Chat> getMessagesByChatId(@PathVariable("chatId") int chatId) {
        try {
        	//추가 채팅방 입장시 알림 0으로 초기화
        	chatService.resetUnreadCount(String.valueOf(chatId));
        	
            List<Chat> messages = chatService.selectMsgByChatId(chatId);
            System.out.println(chatId + " 채팅방 기존 메시지 " + messages.size() + "개 로드");
            return messages;
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 처리: 예외 발생 시 빈 리스트 반환 또는 적절한 HTTP 상태 코드와 함께 오류 메시지 반환
            return List.of(); 
        }
    }
	
    // 메세지 읽음 처리
    @PostMapping("/api/chat/markAsRead")
    @ResponseBody
    public void markMessagesAsRead(@RequestBody Map<String, Object> payload) {
        Object ids = payload.get("messageIds");

        if (ids instanceof List<?>) {
            @SuppressWarnings("unchecked")
            List<Integer> messageIds = (List<Integer>) ids;

            if (messageIds != null && !messageIds.isEmpty()) {
                chatService.markMessagesAsRead(messageIds);
            }
        }
    }
    
    // 메시지 읽음 상태를 실시간으로 브로드캐스트
    @MessageMapping("/readMessage")
    @SendTo("/topic/public")
    public Map<String, Object> readMessage(Map<String, Object> payload) {
        // payload 구조: { "chatId": 27, "messageIds": [114, 115], "readerId": "user01" }
        
        // 알림용 데이터에 type을 추가해서 프론트가 '메시지'인지 '읽음알림'인지 구분하게 함
        payload.put("type", "READ_UPDATE");
        
        return payload; 
    }
    
 // 사진첨부
    @PostMapping("/chat/uploadImage.do")
    @ResponseBody
    public Map<String, Object> uploadImage(@RequestParam("image") MultipartFile file,
                                           HttpServletRequest request) throws IOException {
        String uploadDir = request.getServletContext().getRealPath("/uploads/chat/");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        File dest = new File(dir, fileName);
        file.transferTo(dest);

        String imageUrl = request.getContextPath() + "/uploads/chat/" + fileName;

        Map<String, Object> result = new HashMap<>();
        result.put("imageUrl", imageUrl);
        return result;
    }

    
    //추가 안읽은 메시지 가져오기
    @GetMapping("/api/chat/totalUnread")
    @ResponseBody
    public int getTotalUnreadCount(@RequestParam Map<String, Object> params) {
        // params에는 세션에서 가져온 userId 또는 storeId가 담겨야 합니다.
        try {
            return chatService.getTotalUnreadCount(params);
        } catch (Exception e) {
            return 0;
        }
    }
	
}
