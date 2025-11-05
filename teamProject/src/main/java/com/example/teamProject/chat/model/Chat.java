package com.example.teamProject.chat.model;

import com.example.teamProject.main.model.Main;

import lombok.Data;

@Data
public class Chat {
	
	// DB 관련 
	private String userId;
	private String orderId;
	private String chatId;
	private String storeId;		
	private String orderDetailId; // 이건 혹시몰라서
	private String orderOptionId; // 이건 혹시몰라서
	
	// 실시간 메세지용 (카페글 내용)
	private String sender;
    private String message;
    
    public Chat() {}

    public Chat(String sender, String message) {
        this.sender = sender;
        this.message = message;
    }
    
    private String content;	
	
}
