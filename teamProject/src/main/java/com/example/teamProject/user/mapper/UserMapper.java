package com.example.teamProject.user.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.admin.model.Admin;
import com.example.teamProject.user.model.User;

@Mapper
public interface UserMapper {
	
	// 로그인
	User login(HashMap<String, Object> map);
	
	// 회원가입 아이디 중복체크
	User userCheck(HashMap<String, Object> map);
		
	//회원가입
	int userAdd(HashMap<String, Object> map);

	//아이디, 이름, 번호를 가진 사람이 db에 있는지 확인하는 로직
	int authUser(HashMap<String, Object> map);
	
	//아이디 찾기
	User selectFindId(HashMap<String, Object> map);
	
	//비밀번호 수정
	int updateUserPass(HashMap<String, Object> map);
	
	//마이페이지
	//주문내역 가져요기
	List <User> selectOrderList (HashMap<String, Object> map);
	
	//review가져오기
	//list
	List <User> reviewListSelect(HashMap<String, Object> map);
	//count
	int reviewCount(HashMap<String, Object> map);
	
	//qnA가져오기
	//list
	List <User> qnAListSelect(HashMap<String, Object> map);
	//count
	int qnACount(HashMap<String, Object> map);
	
	
	//userview
	User userSelect(HashMap<String, Object> map);
			
	//userupdate
	int userUpdate(HashMap<String, Object> map);
	
	
	//주문형황 조회
	List <User> selectOrder (HashMap<String, Object> map);
}
