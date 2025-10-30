package com.example.teamProject.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.admin.mapper.AdminMapper;
import com.example.teamProject.user.model.User;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;
	
	//1. 사용자 관리
	public HashMap<String, Object> SelectUserList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		//userlist 
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List <User> userList= adminMapper.userListSelect(map);
			resultMap.put("userList",userList);
			int totalRows=adminMapper.userCount(map);
			resultMap.put("totalRows",totalRows);
			resultMap.put("result","success");
		}catch(Exception e) {
			resultMap.put("result","fail");
			System.out.println(e.getMessage());		
		}	
		 return resultMap;
				
	}
	
	public HashMap<String, Object> DeleteUserList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt=adminMapper.userListDelete(map);
		resultMap.put("result","success");
		return resultMap;
	}
	
	public HashMap<String, Object> SelectUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		User user= adminMapper.userSelect(map);	
		
		resultMap.put("user",user);
		resultMap.put("result","success");
		return resultMap;
	}
	
	
	public HashMap<String, Object> UpdateUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt= adminMapper.userUpdate(map);
		resultMap.put("result","success");
		return resultMap;
	}
	
	
	

}
