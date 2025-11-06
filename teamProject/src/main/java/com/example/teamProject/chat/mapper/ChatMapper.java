package com.example.teamProject.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.chat.model.Chat;

@Mapper
public interface ChatMapper {
	
	// 발송메세지 저장
	void insertChatMsg(Chat message);
	
	
	// 기존 채팅방(말풍선 이력) 불러오기
	List<Chat> selectMsgByChatId(int chatId);
	
	
}
