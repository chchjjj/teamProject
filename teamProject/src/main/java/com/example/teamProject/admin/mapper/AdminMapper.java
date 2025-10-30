package com.example.teamProject.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.user.model.User;

@Mapper
public interface AdminMapper {
	
	
	//1.사용자 관리
		//userlist 
		List <User> userListSelect(HashMap<String, Object> map);
		
		//userdeleteall
		int userListDelete (HashMap<String, Object> map);
		
		//usercnt
		int userCount(HashMap<String, Object> map);
		
		//userview
		User userSelect(HashMap<String, Object> map);
		
		//userupdate
		int userUpdate(HashMap<String, Object> map);
		
		

}
