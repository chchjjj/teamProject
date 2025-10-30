package com.example.teamProject.user.mapper;

import java.util.HashMap;
import org.apache.ibatis.annotations.Mapper;
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
	
	//비밀번호 수정
	int updateUserPass(HashMap<String, Object> map);
	
}
