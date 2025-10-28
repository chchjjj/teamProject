package com.example.teamProject.user.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.user.mapper.UserMapper;
import com.example.teamProject.user.model.User;

@Service
public class UserService {

	@Autowired
	UserMapper userMapper;
	
	public HashMap<String, Object> login(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			User user = userMapper.login(map);
			String result = "";
			String message = "";
			
			if(user != null) {
				result = "success";
				message = "로그인 성공";
			} else {
				result = "fail";
				message = "로그인 실패";
			}
			resultMap.put("result", result);
			resultMap.put("msg", message);
		
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("msg", "통신 에러");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addUser(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			int cnt = userMapper.userAdd(map);
			if(cnt > 0) {
				resultMap.put("result", "success");
			} else {
				resultMap.put("result", "fail");
			}
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		
		return resultMap;
	}
	
	public HashMap<String, Object> userIdCheck(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		User user = userMapper.userCheck(map);
		String result = user != null ? "true" : "false";
		
		resultMap.put("result", result);
		
		return resultMap;
	}
	
	
}
