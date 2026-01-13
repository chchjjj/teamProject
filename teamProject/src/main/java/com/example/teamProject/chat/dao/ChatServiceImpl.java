package com.example.teamProject.chat.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.chat.mapper.ChatMapper;
import com.example.teamProject.chat.model.Chat;
//추가
import org.springframework.transaction.annotation.Transactional;

@Service
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	ChatMapper chatMapper;
	
	// chatId 가져오기
	@Override
	public String selectChatIdByOrderId(String orderId) throws Exception {
	    return chatMapper.selectChatIdByOrderId(orderId);
	}
	
	// storeId 가져오기
	@Override
	public String selectStoreIdByOrderId(String orderId) throws Exception {
	    return chatMapper.selectStoreIdByOrderId(orderId);
	}
	
	
	// 구매자,판매자 각 말풍선 내용 인서트
//	@Override
//    public void insertChatMsg(Chat message) {
//        chatMapper.insertChatMsg(message);
//    }	
//	
	//교체
	@Override
	@Transactional
    public void insertChatMsg(Chat message) {
        // 메시지 저장 (CHAT_MSG_TBL)
        chatMapper.insertChatMsg(message);
        // 상태 업데이트 (CHAT_TBL) - Mapper에 이 메소드가 있어야 함
        chatMapper.updateChatRoomStatus(message);
    }
	
	// 기존 채팅내용 가져오기
	@Override
	public int getTotalUnreadCount(java.util.Map<String, Object> params) {
		return chatMapper.getTotalUnreadCount(params);
	}

	@Override
	public void resetUnreadCount(String chatId) {
		chatMapper.resetUnreadCount(chatId);
	}

	@Override
	public List<java.util.Map<String, Object>> selectChatList(java.util.Map<String, Object> params) {
		return chatMapper.selectChatList(params);
	}
	
	
	// 추가 채팅 내역 조회 (인터페이스에 있으므로 반드시 구현)
	@Override
	public List<Chat> selectMsgByChatId(int chatId) {
	    return chatMapper.selectMsgByChatId(chatId);
	}

	// 추가 읽음 처리 (인터페이스에 있으므로 반드시 구현)
	@Override
	public void markMessagesAsRead(List<Integer> messageIds) {
	    if (messageIds == null || messageIds.isEmpty()) return;
	    chatMapper.updateMessagesAsRead(messageIds);
	}

	
	
	
}
