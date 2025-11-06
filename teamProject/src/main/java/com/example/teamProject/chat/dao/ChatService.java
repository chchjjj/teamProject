package com.example.teamProject.chat.dao;

import java.util.List;

import com.example.teamProject.chat.model.Chat;

public interface ChatService {
	
	// 구매자,판매자 각 말풍선 내용 인서트
	void insertChatMsg(Chat message);
	
	
	// 채팅내용 가져오기 
	List<Chat> selectMsgByChatId(int chatId);	
	
}
