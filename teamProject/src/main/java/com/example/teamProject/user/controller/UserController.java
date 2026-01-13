package com.example.teamProject.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.user.dao.UserService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UserController {
	
	@Value("${JUSO_API_KEY}")
    private String jusoApiKey;
	
	@Autowired
	UserService userService;
	
	@RequestMapping("/user/login.do")
	public String login(Model model) throws Exception {
		
		return "/user/login";
	}
	
	@RequestMapping("/user/join.do")
	public String join(Model model) throws Exception {
		
		return "/user/join";
	}
	
	@RequestMapping("/user/addr.do")
	public String addr(Model model) throws Exception {
		model.addAttribute("jusoApiKey", jusoApiKey);
		return "/user/jusoPopup";
	}
	
//	@RequestMapping("/product/wishlist.do")
//	public String wishList(Model model) throws Exception {
//		return "/product/wishList";
//	}
	
	@RequestMapping("/user/userMyPage.do")
	public String userMyPage(Model model) throws Exception {
		return "/user/userMyPage";
	}
	
	@RequestMapping("/user/findId.do")
	public String findId(Model model) throws Exception {
		return "/user/findId";
	}
	
	@RequestMapping("/user/newPwd.do")
	public String newPwd(Model model) throws Exception {
		return "/user/newPwd";
	}
	
	@RequestMapping("/user/chatList.do")
	public String chatHistory(Model model) throws Exception {
		return "/user/chatList";
	}
	
	@RequestMapping("/user/orderHistory.do")
	public String orderHistory(Model model) throws Exception {
		return "/user/orderHistory";
	}
	
	@RequestMapping("/user/review.do")
	public String review(Model model) throws Exception {
		return "/user/review";
	}
	
	@RequestMapping("/user/userEdit.do")
	public String userEdit(Model model) throws Exception {
		return "/user/userEdit";
	}
	
	@RequestMapping("/user/qnA.do")
	public String qnA(Model model) throws Exception {
		return "/user/qnA";
	}
	
	@RequestMapping("/user/orderStatus.do")
    public String orderStatus(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("orderId",map.get("orderId"));
        return "/user/orderStatus";
	}
	
	@RequestMapping("/user/reviewInsert.do")
    public String reviewInsert(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("orderDetailId",map.get("orderDetailId"));
        return "/user/reviewInsert";
       
	}
	
	
	@RequestMapping(value = "/user/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.login(map);
		
		

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.logout(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.addUser(map);
	
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.userIdCheck(map);

		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/user/phoneCheck.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String phoneCheck(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.phoneCheck(map);

		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/user/auth.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String auth(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.userAuth(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/resetPassword.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userUpdatePassword(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = userService.resetPassword(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/findId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = userService.findId(map);

		return new Gson().toJson(resultMap);
	}
	
	
	@RequestMapping(value = "/user/orderHistory.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderHistory(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = userService.SelectOrderList(map);
	    return new Gson().toJson(resultMap);
	}
	
	
	@RequestMapping(value = "/user/reviewlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = userService.SelectReviewList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/qnA.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnAList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = userService.SelectQnAList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.SelectUser(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	

	
	@RequestMapping(value = "/user/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userupdate(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.UpdateUser(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/orderStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = userService.SelectOrder(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/orderDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = userService.SelectOrderDetail(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/chat.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String chatList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = userService.SelectChatList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	

	@RequestMapping(value = "/user/reviewInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewInsert(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = userService.InsertReview(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	// 구매자 마이페이지 - 결제 전 상태 건 주문취소하면 ORDER_TBL의 STATUS X로 바꾸기
	@RequestMapping(value = "/user/orderCancel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderCancel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    // 서비스 호출 (주문 상태를 'X'로 변경하고 결과 맵을 받아옴)
	    resultMap = userService.updateOrderCancel(map);
	    
	    // 파라미터 확인용 로그 (orderId가 잘 들어오는지 확인)
	    System.out.println("주문 취소 요청 파라미터: " + map);
	    
	    return new Gson().toJson(resultMap);
	}
	
	
	
}
