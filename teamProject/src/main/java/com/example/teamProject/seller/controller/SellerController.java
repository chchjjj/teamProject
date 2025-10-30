package com.example.teamProject.seller.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.seller.dao.SellerService;
import com.google.gson.Gson;

import org.springframework.web.bind.annotation.RequestMethod;



@Controller
public class SellerController {
	
	 @Autowired
	 SellerService sellerService;
	
	@RequestMapping("/seller/list.do") 
    public String area(Model model) throws Exception{

        return "/seller/addComplete";
    }
	
	@RequestMapping("/seller/storeList.do") 
    public String myPage(Model model) throws Exception{

        return "/seller/sellerMyPage";
    }

	@RequestMapping(value = "/store/list.dox",  method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String storeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = sellerService.getStoreList(map);
		
		return new Gson().toJson(resultMap);
	}
	

}
