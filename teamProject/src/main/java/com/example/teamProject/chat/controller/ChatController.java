package com.example.teamProject.chat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.teamProject.chat.dao.ChatService;

@Controller
public class ChatController {
	@Autowired
	ChatService chatService;
	
	// 판매자 기준 채팅방
	@RequestMapping("/chat/chatSeller.do") 
    public String chatSeller(Model model) throws Exception{

        return "/chat/chatSeller";
    }
	
	// 구매자 기준 채팅방
	@RequestMapping("/chat/chatBuyer.do") 
    public String chatBuyer(Model model) throws Exception{

        return "/chat/chatBuyer";
    }
	
	
}
