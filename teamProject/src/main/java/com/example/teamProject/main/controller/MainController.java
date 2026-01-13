package com.example.teamProject.main.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.main.dao.MainService;
import com.google.gson.Gson;

@Controller
public class MainController {	
	
	@Autowired
	MainService mainService;
	
	// 메인페이지
	@RequestMapping("/main.do") 
    public String main(Model model) throws Exception{
        return "/main/main";
    }
	
	// 헤더
	@RequestMapping("/main/header.do") 
    public String header(Model model) throws Exception{
        return "/main/header";
    }
	
	// 풋터
	@RequestMapping("/main/footer.do") 
    public String footer(Model model) throws Exception{
        return "/main/footer";
    }
	
	// 헤더메뉴 '알레르기 프리'
	@RequestMapping("/main/allergyFree.do") 
    public String allergy(Model model) throws Exception{
        return "/main/allergySearch";
    }
	
	// 헤더메뉴 QnA
	@RequestMapping("/main/qna.do") 
    public String qna(Model model) throws Exception{
        return "/main/qna";
    }
	
	// 메인페이지 내 '내 주변 디저트 찾기'
	@RequestMapping("/main/storeFinder.do") 
	   public String storeFind(Model model) throws Exception{
		return "/main/storeFinder";
	   }
	
	// 광고배너 클릭 시 연결페이지
		@RequestMapping("/main/ad-link.do") 
	    public String ad(Model model) throws Exception{
	        return "/main/ad-link";
	    }
	
	// 메인 화면 상품 리스트
	@RequestMapping(value = "/main/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String proList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getProList(map);
		return new Gson().toJson(resultMap);
	}
	
	// '알레르기 프리' 원재료 리스트
	@RequestMapping(value = "/main/ingre-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ingreList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getIngreList(map);
		return new Gson().toJson(resultMap);
	}
	
	// '알레르기 프리' 원재료 미포함 상품 리스트
	@RequestMapping(value = "/main/ingre-pro-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ingreProList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getIngreProList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 헤더 QnA 버튼으로 페이지 이동 후 QnA 리스트
	@RequestMapping(value = "/main/qna.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("Controller userId => " + map.get("userId"));
		resultMap = mainService.getQnaList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 로그인한 고객 정보 가져오기 ('내 주변 디저트 찾기' & '마이페이지' 권한 구분)
	@RequestMapping(value = "/main/userInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userAddr(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap = mainService.getUser(map); 
		System.out.println("서버 최종 응답 데이터: " + resultMap);
		return new Gson().toJson(resultMap); // 결과를 resultMap에 담음
	}
	
	// '내 주변 디저트 찾기' 에서 가게 리스트 불러오기
	@RequestMapping(value = "/main/storeList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getSellerList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 광고 배너 정보 (AD_ID) 불러오기
	@RequestMapping(value = "/main/adInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String adInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap = mainService.getAdInfo(map); 
		System.out.println("서버 최종 응답 데이터: " + resultMap);
		return new Gson().toJson(resultMap); // 결과를 resultMap에 담음
	}
	
	// 광고 배너 히스토리 불러오기
	@RequestMapping(value = "/main/adPerMonth.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String adHistory(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap = mainService.getAdHistory(map); 
		System.out.println("서버 최종 응답 데이터: " + resultMap);
		return new Gson().toJson(resultMap); // 결과를 resultMap에 담음
	}
	
	// 광고배너 클릭시 클릭수 & 총비용 증가
	@RequestMapping(value = "/main/adUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateAd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.updateAdClick(map);
		return new Gson().toJson(resultMap);
	}
	
	// 멤버십 가입정보
	@RequestMapping(value = "/main/checkmembership.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkmembership(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap = mainService.getMembership(map); 
		System.out.println("멤버십 가입여부 " + resultMap);
		return new Gson().toJson(resultMap); // 결과를 resultMap에 담음
	}
	
	// 메인페이지 - 멤버쉽 가입 판매자 상품 이미지 목록 목록
	@RequestMapping(value = "/main/memberProImg.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberProImgList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getMemberProImgList(map);
		return new Gson().toJson(resultMap);
	}
	
}
