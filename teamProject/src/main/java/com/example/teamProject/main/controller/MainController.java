package com.example.teamProject.main.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {	
	
	//@Autowired	
	//@RequestMapping	
	//@ResponseBody
	
	@RequestMapping("/main.do") 
    public String main(Model model) throws Exception{

        return "/main/main";
    }
	
	@RequestMapping("/main/header.do") 
    public String header(Model model) throws Exception{

        return "/main/header";
    }
	
}
