package com.example.teamProject.chat.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.chat.mapper.ChatMapper;
import com.example.teamProject.chat.model.Chat;

@Service
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	ChatMapper chatMapper;
	
	// 채팅방 가져오기
	@Override
	public String selectChatIdByOrderId(String orderId) throws Exception {
	    return chatMapper.selectChatIdByOrderId(orderId);
	}
	
	// 구매자,판매자 각 말풍선 내용 인서트
	@Override
    public void insertChatMsg(Chat message) {
        chatMapper.insertChatMsg(message);
    }	
	
	// 기존 채팅내용 가져오기
	@Override
    public List<Chat> selectMsgByChatId(int chatId) {
        return chatMapper.selectMsgByChatId(chatId);
    }
	
	
}
