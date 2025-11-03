package com.example.teamProject.user.dao;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.example.teamProject.user.mapper.UserMapper;
import com.example.teamProject.user.model.User;
import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

	@Autowired
	UserMapper userMapper;
	
	@Autowired
	HttpSession session;

	// 비밀번호 해시 객체 생성
	@Autowired
	PasswordEncoder passwordEncoder;

	public HashMap<String, Object> login(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			User user = userMapper.login(map);
			String result = "";
			String message = "";

			// ---------조건 처리 여기부터----------

			// 수업 때 한 코드 복붙 후 수정함
			if (user != null) {
				// 아이디가 존재, 비밀번호 비교하기 전

				// 사용자가 보낸 비밀번호 map에서 꺼낸 후 해시화한 값과
				// user 객체 안에 있는 password와 비교
				Boolean loginFlg = passwordEncoder.matches((String) map.get("userPass"), user.getUserPass());
				//System.out.println("map.get(userPass) =>" + (String) map.get("userPass"));
				//System.out.println("user.getUserPass() => " + user.getUserPass());
				
				if (loginFlg) {
					// 아이디, 비밀번호를 정상 입력했을 경우

					// 로그인 성공
					// cnt값을 0으로 초기화
					
					message = "로그인 성공!";
					result = "success";
					
					session.setAttribute("sessionId", user.getUserId());
					session.setAttribute("sessionName", user.getUserName());
					session.setAttribute("sessionRole", user.getRole());
					session.setAttribute("sessionPhone", user.getPhone());
					resultMap.put("url", "/main.do");
					
					//밑에 주석처리 한거는 혹시라도 관리자 여부에 따라 이동할 페이지를 다르게 하고 싶을 때 사용하면 된다.
//					if (user.getRole().equals("A")) {
//						resultMap.put("url", "/admin/main.do");
//					} else {
//						resultMap.put("url", "/main.do");
//					}

				} else {
					// 아이디는 맞지만, 비밀번호가 다른 경우
					//userMapper.updateCntIncrease(map);
					message = "패스워드를 확인해주세요.";
					result = "fail";
				}

			} else {
				// 아이디가 없음
				message = "아이디가 존재하지 않습니다.";
				result = "fail";
			}

		

			// ------------여기까지---------

			resultMap.put("result", result);
			resultMap.put("msg", message);

		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("msg", "통신 에러");
			System.out.println(e.getMessage());
		}

		return resultMap;
	}
	
	public HashMap<String, Object> logout(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		//세션정보 삭제 방법
		//1개씩 키값을 이용해 삭제하거나, 전체를 한번에 삭제하는 방법이 있음
		
		String message = session.getAttribute("sessionName") + "님 로그아웃 되었습니다.";
		resultMap.put("msg", message);
		
		//session.removeAttribute("sessionId"); //1개씩 삭제
		
		session.invalidate(); //세션정보 전체 삭제
		
		return resultMap;
	}
	

	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		// 비밀번호 암호화(해시)
		String hashPwd = passwordEncoder.encode((String) map.get("userPass"));
		map.put("hashPwd", hashPwd);

		try {
			int cnt = userMapper.userAdd(map);
			if (cnt > 0) {
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

	public HashMap<String, Object> userIdCheck(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		User user = userMapper.userCheck(map);
		String result = user != null ? "true" : "false";

		resultMap.put("result", result);

		return resultMap;
	}

	public HashMap<String, Object> userAuth(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			int cnt = userMapper.authUser(map);

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

	public HashMap<String, Object> resetPassword(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			User user = userMapper.userCheck(map);
			boolean pwdFlg = passwordEncoder.matches((String) map.get("userPass"), user.getUserPass());
			if(pwdFlg) {
				resultMap.put("result", "fail");
				resultMap.put("msg", "비밀번호가 이전과 동일합니다.");
			} else {
				String hashPwd = passwordEncoder.encode((String)map.get("userPass"));
				map.put("hashPwd", hashPwd);
				int cnt = userMapper.updateUserPass(map);
				resultMap.put("result", "success");
				resultMap.put("msg", "수정되었습니다."); 
			}
			
			
			
			
		}catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}

	public HashMap<String, Object> findId(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			User user = userMapper.selectFindId(map);
			resultMap.put("result", "true");
			resultMap.put("info", user);
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		
		
		

		return resultMap;
	}

}
