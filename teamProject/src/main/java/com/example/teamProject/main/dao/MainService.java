package com.example.teamProject.main.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.main.mapper.MainMapper;
import com.example.teamProject.main.model.Main;

@Service
public class MainService {
	
	@Autowired
	MainMapper mainMapper;
	
	// 메인페이지 상품 목록 불러오기
	public HashMap<String, Object> getProList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Main> list = mainMapper.selectMainProList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 헤더 QnA 클릭 시 QnA 전체 목록 불러오기
	public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectQnaList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}

}
