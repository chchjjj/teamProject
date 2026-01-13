package com.example.teamProject.chat.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.teamProject.chat.model.Chat;
import com.example.teamProject.user.model.User;

@Mapper
public interface ChatMapper {
	
	// 발송메세지 저장 (텍스트, 이미지 공통)
	void insertChatMsg(Chat message);
	
	// 주문번호로 chatId 찾기
    String selectChatIdByOrderId(String orderId) throws Exception;
    
	// 주문번호로 storeId 찾기
    String selectStoreIdByOrderId(String orderId) throws Exception;    	
	
	// 기존 채팅방(말풍선 이력) 불러오기
	List<Chat> selectMsgByChatId(int chatId);
	
	// 읽음처리
	int updateMessagesAsRead(List<Integer> msgIds);
	
	//추가
	//채팅방의 안 읽은 개수 증가 및 마지막 메시지 업데이트
    void updateChatRoomStatus(Chat chat);
    
    //채팅방 입장 시 안 읽은 개수 0으로 초기화
    void resetUnreadCount(@Param("chatId") String chatId);
    
    // 추가: 내 안 읽은 메시지 총합 가져오기 (알림 배지용)
 	int getTotalUnreadCount(java.util.Map<String, Object> params);
 	
 	//  추가: 내 채팅방 리스트 가져오기 (목록 페이지용)
 	List<java.util.Map<String, Object>> selectChatList(java.util.Map<String, Object> params);
	
}
