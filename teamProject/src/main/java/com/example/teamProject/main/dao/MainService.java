package com.example.teamProject.main.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.main.mapper.MainMapper;
import com.example.teamProject.main.model.Main;

@Service
public class MainService {
	
	@Autowired
	MainMapper mainMapper;
	
	// 메인페이지 상품 목록 불러오기 & 상품 개수세기 (페이징)
	public HashMap<String, Object> getProList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectMainProList(map);
			int cnt = mainMapper.selectMainCnt(map); // 게시된 상품 개수
			resultMap.put("list", list); 
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 헤더 QnA 클릭 시 QnA 전체목록 불러오기 & 게시글 개수세기(페이징)
	public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectQnaList(map); // QnA 전체목록
			int cnt = mainMapper.selectQnaCnt(map); // QnA 게시글 개수
			resultMap.put("list", list); 
			resultMap.put("cnt", cnt);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 로그인세션 유저 (특정값) 찾기 ('내 주변 디저트 찾기' & '마이페이지')
	public HashMap<String, Object> getUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Main main = mainMapper.selectUser(map);						
			resultMap.put("info", main); // (키, 밸류)			
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}			
		return resultMap;
	}
		
	// '내 주변 디저트 찾기'에서 가게(판매자) 목록 불러오기
	public HashMap<String, Object> getSellerList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectSeller(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// '알레르기 프리' 메뉴에서 원재료 목록 불러오기
	public HashMap<String, Object> getIngreList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectIngreList(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// '알레르기 프리' 메뉴에서 선택한 원재료 '미포함' 상품 목록
	public HashMap<String, Object> getIngreProList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectIngreProList(map);
			int cnt = mainMapper.selectMainCnt(map); // 게시된 상품 개수
			resultMap.put("list", list); 
			resultMap.put("cnt", cnt); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}	
	
	// 광고 배너의 AD_ID 값 찾기 (현재 '진행중' 상태인 유일값)
	public HashMap<String, Object> getAdInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Main main = mainMapper.selectAdInfo(map);						
			resultMap.put("info", main); // (키, 밸류)			
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}			
		return resultMap;
	}
	
	// 광고 배너의 PER_MONTH 찾기 (AD_HISTORY_TBL)
	public HashMap<String, Object> getAdHistory(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Main main = mainMapper.selectAdHistory(map);						
			resultMap.put("info", main); // (키, 밸류)			
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}			
		return resultMap;
	}
	
	// 광고 배너 클릭시 카운팅 & 총비용 업뎃
	@Transactional
	public HashMap<String, Object> updateAdClick(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {			
			Main main = mainMapper.selectAdUnitCost(map);	// 광고 클릭단가 구해서
			map.put("clickUnitCost", main.getClickUnitCost());
			int cnt1 = mainMapper.updateAdClick(map); // 광고 테이블 클릭수 업뎃
			int cnt2 = mainMapper.updateAdHistory(map); // 광고 히스토리 테이블 클릭수&총비용 업뎃
			
			System.out.println("AD_ID: " + map.get("adId"));
			System.out.println("클릭단가: " + main.getClickUnitCost());
			System.out.println("AD_TBL 업데이트 수: " + cnt1 + ", AD_HISTORY_TBL 업데이트 수: " + cnt2);
						
			resultMap.put("info", main); // (키, 밸류)			
			resultMap.put("result", "success");
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}			
		return resultMap;
	}
	
	// 멤버쉽 가입 판매자 상품 이미지 목록 목록
	public HashMap<String, Object> getMemberProImgList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();		
		try {
			List<Main> list = mainMapper.selectMemberProImg(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}	
	

}
