package com.example.teamProject.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminController {
	@RequestMapping("/admin/list.do")
	public String area(Model model) throws Exception{
       return "/admin-ad"; // 기본 확장자 파일을 jsp로 잡아놨기에 확장자 생략
   }

}
