package com.example.teamProject.user.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {
	// 테스트 (1~2)
	
	@RequestMapping("/user/list.do")
	public String area(Model model) throws Exception{

        return "/user/default"; // 기본 확장자 파일을 jsp로 잡아놨기에 확장자 생략
    }
}
