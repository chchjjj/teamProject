package com.example.teamProject.chat.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.chat.mapper.ChatMapper;
import com.example.teamProject.chat.model.Chat;

@Service
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	ChatMapper chatMapper;
	
	@Override
    public void insertBuyerChatMsg(Chat message) {
        chatMapper.insertBuyerChatMsg(message);
    }
	
}
