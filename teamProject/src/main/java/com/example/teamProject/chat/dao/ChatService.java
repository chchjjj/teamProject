package com.example.teamProject.chat.dao;

import java.util.List;

import com.example.teamProject.chat.model.Chat;

public interface ChatService {
	
	// 구매자,판매자 각 말풍선 내용 인서트 (일반 메세지)
	void insertChatMsg(Chat message);
	
	
	// chatId 가져오기
	String selectChatIdByOrderId(String orderId) throws Exception;	
	
	// storeId 가져오기
	String selectStoreIdByOrderId(String orderId) throws Exception;	
	
	// 채팅내용 가져오기 
	List<Chat> selectMsgByChatId(int chatId);	
	
	// 채팅 읽음 처리
	void markMessagesAsRead(List<Integer> messageIds);
	
	//추가 특정 유저(판매자/구매자)의 안 읽은 채팅 총 개수 가져오기
	int getTotalUnreadCount(java.util.Map<String, Object> params);
	
	//추가 특정 채팅방의 안 읽은 개수를 0으로
	void resetUnreadCount(String chatId);
	
	//추가 내 채팅방 목록 가져오기
	List<java.util.Map<String, Object>> selectChatList(java.util.Map<String, Object> params);
}
