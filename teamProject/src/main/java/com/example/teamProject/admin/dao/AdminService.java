package com.example.teamProject.admin.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.admin.mapper.AdminMapper;
import com.example.teamProject.admin.model.Admin;
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
			List <Admin> userList= adminMapper.userListSelect(map);
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
		
		Admin user= adminMapper.userSelect(map);	
		
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
	
	
	//2.판매자 관리
	
		public HashMap<String, Object> SelectSellerList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//sllerlist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> sellerList= adminMapper.sellerListSelect(map);
				resultMap.put("sellerList",sellerList);
				int totalRows=adminMapper.sellerCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
		public HashMap<String, Object> DeleteSellerList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt=adminMapper.sellerListDelete(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		public HashMap<String, Object> SelectSeller(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			Admin seller= adminMapper.sellerSelect(map);	
			
			resultMap.put("seller",seller);
			resultMap.put("result","success");
			return resultMap;
		}
		
		
		public HashMap<String, Object> UpdateSeller(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			int cnt= adminMapper.sellerUpdate(map);
			resultMap.put("result","success");
			return resultMap;
		}
		
		
		//3.membership
		public HashMap<String, Object> SelectMembershipList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			//membershiplist 
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List <Admin> membershipList= adminMapper.membershipListSelect(map);
				resultMap.put("membershipList",membershipList);
				int totalRows=adminMapper.sellerCount(map);
				resultMap.put("totalRows",totalRows);
				resultMap.put("result","success");
			}catch(Exception e) {
				resultMap.put("result","fail");
				System.out.println(e.getMessage());		
			}	
			 return resultMap;
					
		}
		
	
	

}
