package com.example.teamProject.chat.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.chat.mapper.ChatMapper;

@Service
public class ChatService {
	@Autowired
	ChatMapper chatMapper;
}
