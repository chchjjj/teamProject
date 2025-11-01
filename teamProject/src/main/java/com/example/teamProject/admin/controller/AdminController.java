package com.example.teamProject.admin.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.admin.dao.AdminService;
import com.example.teamProject.user.dao.UserService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	
	@RequestMapping("/admin/main.do")
	public String main(Model model) throws Exception{
       return "/admin/admin-main"; 
   }
	
	@RequestMapping("/admin/userlist.do")
	public String userlist(Model model) throws Exception{
       return "/admin/admin-userList";
   }
	
	@RequestMapping("/admin/sellerlist.do")
	public String sellerlist(Model model) throws Exception{
       return "/admin/admin-sellerList"; 
   }
	
	
	@RequestMapping("/admin/sellerchart.do")
    public String sellerchart(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("storeId",map.get("storeId"));
        return "/admin/admin-sellerChart";
	}
	
//	@RequestMapping("/admin/userinfo.do")
//	public String userinfo(Model model) throws Exception{
//       return "/admin/admin-userInfo"; 
//   }
	
	@RequestMapping("/admin/membership.do")
	public String adminmembership(Model model) throws Exception{
       return "/admin/admin-membership"; 
   }
	
	@RequestMapping("/admin/chart.do")
	public String chart(Model model) throws Exception{
       return "/admin/admin-chart"; 
   }
	
	@RequestMapping("/admin/ad.do")
	public String ad(Model model) throws Exception{
       return "/admin/admin-ad"; 
   }
	
	@RequestMapping("/admin/boardManage.do")
	public String board(Model model) throws Exception{
       return "/admin/admin-boardManage"; 
   }
	
	@RequestMapping("/admin/useredit.do")
    public String userEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("userId",map.get("userId"));
        return "/admin/admin-userEdit";
	}
	
	@RequestMapping("/admin/userinfo.do")
    public String order(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("userId",map.get("userId"));
        return "/admin/admin-userInfo";
	}
	
	@RequestMapping("/admin/selleredit.do")
    public String sellerEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("storeId",map.get("storeId"));
        return "/admin/admin-sellerEdit";
	}
	
	
	
	
	
	@RequestMapping(value = "/aduser/userlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectUserList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/aduser/deleteall.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String DeleteList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectItem").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
		System.out.println(map);
		resultMap=adminService.DeleteUserList(map);
		return new Gson().toJson(resultMap);
		
	}
	
	
	@RequestMapping(value = "/aduser/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.SelectUser(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/aduser/order.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userorder(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.SelectOrder(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/aduser/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userupdate(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.UpdateUser(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	//판매자
	@RequestMapping(value = "/adseller/sellerlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectSellerList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "adseller/deleteall.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String DeleteSellerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectItem").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
		System.out.println(map);
		resultMap=adminService.DeleteUserList(map);
		return new Gson().toJson(resultMap);
		
	}
	
	
	@RequestMapping(value = "/adseller/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.SelectSeller(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/adseller/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerupdate(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.UpdateSeller(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	
	@RequestMapping(value = "/adseller/sales.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sales(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectSales(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	//멤버십
	@RequestMapping(value = "/admembership/membershiplist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String membershipList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectMembershipList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}


	
	//매출 차트
	@RequestMapping(value = "/adsale/salestrends.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String salestrends(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectSalesTrends(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	
	//qnA & review
	@RequestMapping(value = "/adboard/qnalist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectQnAList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/adboard/reviewlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		
		resultMap = adminService.SelectReviewList(map);
		
		System.out.println(map);
		
		return new Gson().toJson(resultMap);
	}
	
	
	@RequestMapping(value = "adboard/qnadeleteall.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String DeleteQnAList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectItem").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
		System.out.println(map);
		resultMap=adminService.DeleteQnAList(map);
		return new Gson().toJson(resultMap);
		
	}
	
	
	@RequestMapping(value = "adboard/reviewdeleteall.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String DeleteReviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectItem").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
		System.out.println(map);
		resultMap=adminService.DeleteReviewList(map);
		return new Gson().toJson(resultMap);
		
	}
	






}//class
