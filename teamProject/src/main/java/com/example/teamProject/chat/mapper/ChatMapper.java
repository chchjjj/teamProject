package com.example.teamProject.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.teamProject.chat.model.Chat;

@Mapper
public interface ChatMapper {
	
	// 발송메세지 저장
	void insertChatMsg(Chat message);
	
	// 주문번호로 chatId 찾기
    String selectChatIdByOrderId(String orderId) throws Exception;
    
	// 주문번호로 storeId 찾기
    String selectStoreIdByOrderId(String orderId) throws Exception;    	
	
	// 기존 채팅방(말풍선 이력) 불러오기
	List<Chat> selectMsgByChatId(int chatId);
	
	// 읽음처리
	int updateMessagesAsRead(List<Integer> msgIds);
	
	
}
