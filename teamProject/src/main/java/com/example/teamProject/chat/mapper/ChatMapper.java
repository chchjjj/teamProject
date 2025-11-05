package com.example.teamProject.chat.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.chat.model.Chat;

@Mapper
public interface ChatMapper {
	
	// 구매자 발송메세지 저장
	void insertBuyerChatMsg(Chat message);
	
}
