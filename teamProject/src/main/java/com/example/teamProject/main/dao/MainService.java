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
	
	// 메인페이지 상품 목록 불러오기 & 상품 개수세기 (페이징)
	public HashMap<String, Object> getProList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectMainProList(map);
			int cnt = mainMapper.selectMainCnt(map); // 게시된 상품 개수
			resultMap.put("list", list); 
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 헤더 QnA 클릭 시 QnA 전체목록 불러오기 & 게시글 개수세기(페이징)
	public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectQnaList(map); // QnA 전체목록
			int cnt = mainMapper.selectQnaCnt(map); // QnA 게시글 개수
			resultMap.put("list", list); 
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 로그인세션 유저 (특정값) 찾기 ('내 주변 디저트 찾기' & '마이페이지')
		public HashMap<String, Object> getUser(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				Main main = mainMapper.selectUser(map);						
				resultMap.put("info", main); // (키, 밸류)			
				resultMap.put("result", "success");
			} catch (Exception e) {
				// TODO: handle exception
				resultMap.put("result", "fail");
				System.out.println(e.getMessage());
			}			
			return resultMap;
		}

}
