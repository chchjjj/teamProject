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
	
	@RequestMapping("/chat/chatSeller.do") 
    public String wish(Model model) throws Exception{

        return "/chat/chatSeller";
    }
	
	
}
