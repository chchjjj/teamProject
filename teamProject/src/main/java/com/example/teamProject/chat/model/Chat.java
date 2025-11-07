package com.example.teamProject.chat.model;

import java.util.Date;

import lombok.Data;

@Data
public class Chat {
	
	// DB 관련 
	private String userId;
	private int orderId;
	private int chatId;
	private int storeId;		
	private String orderDetailId; // 이건 혹시몰라서
	private String orderOptionId; // 이건 혹시몰라서
	
	// 실시간 메세지용 (카페글 내용)
	private String sender;
    private String message;
	private Date sentAt;
    
    public Chat() {}

    public Chat(String sender, String message, Date timestamp) {
        this.sender = sender;
        this.message = message;
        this.sentAt = timestamp;
    }
    
    private String content;	
	
}
