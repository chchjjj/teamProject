package com.example.teamProject.main.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.main.dao.MainService;
import com.google.gson.Gson;

@Controller
public class MainController {	
	
	@Autowired
	MainService mainService;

	@RequestMapping("/main.do") 
    public String main(Model model) throws Exception{

        return "/main/main";
    }
	
	@RequestMapping("/main/header.do") 
    public String header(Model model) throws Exception{

        return "/main/header";
    }
	
	@RequestMapping("/main/footer.do") 
    public String footer(Model model) throws Exception{

        return "/main/footer";
    }
	
	@RequestMapping("/main/qna.do") 
    public String qna(Model model) throws Exception{

        return "/main/qna";
    }
	
	// 메인 화면 상품 리스트
	@RequestMapping(value = "/main/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String proList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getProList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 헤더 QnA 버튼으로 페이지 이동 후 QnA 리스트
	@RequestMapping(value = "/main/qna.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getQnaList(map);
		return new Gson().toJson(resultMap);
	}
	
}
