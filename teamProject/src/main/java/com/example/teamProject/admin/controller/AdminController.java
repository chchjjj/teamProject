package com.example.teamProject.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminController {
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
	public String sellerchart(Model model) throws Exception{
       return "/admin/admin-sellerChart"; 
   }
	
	@RequestMapping("/admin/userinfo.do")
	public String userinfo(Model model) throws Exception{
       return "/admin/admin-userInfo"; 
   }
	
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
	@RequestMapping("/admin/list.do")
	public String area(Model model) throws Exception{
       return "/admin/admin-ad"; // 기본 확장자 파일을 jsp로 잡아놨기에 확장자 생략
   }









}//class
