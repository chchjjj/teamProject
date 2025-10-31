package com.example.teamProject.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.admin.model.Admin;
import com.example.teamProject.user.model.User;

@Mapper
public interface AdminMapper {
	
	
	//1.사용자 관리
		//userlist 
		List <Admin> userListSelect(HashMap<String, Object> map);
		
		//userdeleteall
		int userListDelete (HashMap<String, Object> map);
		
		//usercnt
		int userCount(HashMap<String, Object> map);
		
		//userview
		Admin userSelect(HashMap<String, Object> map);
		
		//userupdate
		int userUpdate(HashMap<String, Object> map);
		
		//2.판매자 관리	
		//sellerlist 
		List <Admin> sellerListSelect(HashMap<String, Object> map);
				
		//sellerdeleteall
		int sellerListDelete (HashMap<String, Object> map);
				
		//sellercnt
		int sellerCount(HashMap<String, Object> map);
				
		//sellerview
		Admin sellerSelect(HashMap<String, Object> map);
				
		//sellerupdate
		int sellerUpdate(HashMap<String, Object> map);
		
		//membership관리
		List <Admin> membershipListSelect(HashMap<String, Object> map);
		
		//user의 구매정보
		Admin orderSelect(HashMap<String, Object> map);
		
		//판매자 상세: 월 판매량 따라 차트 구현
		List <HashMap> salesTrendsSelect(HashMap<String, Object> map);


}
