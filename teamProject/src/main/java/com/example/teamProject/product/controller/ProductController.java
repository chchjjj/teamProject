package com.example.teamProject.product.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.product.dao.ProductService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class ProductController {

	@Autowired
	ProductService ProductService;
	
	@RequestMapping("/productDetail.do") 
    public String productDetail(@RequestParam("proNo") int proNo, Model model) throws Exception{
		model.addAttribute("proNo", proNo);
        return "/product/productDetail";
    }
	
	@RequestMapping("/product/cart.do") 
    public String cart(Model model) throws Exception{

        return "/product/cart";
    }
	
	@RequestMapping("/product/wishlist.do") 
    public String wish(Model model) throws Exception{

        return "/product/wishList";
    }
	
	@RequestMapping(value = "/product/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String info(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getProInfo(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/TopOptlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String TopOptlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getTopOptList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/AllOptlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String AllOptlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getAllOptList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/cart.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cart(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getCartList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/cartDelete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartDelete(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectItem").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
		
		System.out.println(map);
		
		resultMap = ProductService.deleteCart(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/cartInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartInsert(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("subOptionList").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
		map.put("list", list);
		resultMap = ProductService.insertCart(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/cartItemQuantityUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartUpdate(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.updateCart(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/checkWishlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkWishlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.checkWishlist(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/WishlistAdd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String WishlistAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.WishlistInsert(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/WishlistDel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String WishlistDel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.WishlistDelete(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/reviewList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.getReviewList(map);
	    return new Gson().toJson(resultMap);
	}
	
	// 헤더 QnA 버튼으로 페이지 이동 후 QnA 리스트
	@RequestMapping(value = "/product/qna.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("Controller userId => " + map.get("userId"));
		resultMap = ProductService.getQnaList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/orderInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderInsert(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String json = map.get("subOptionList").toString(); //제이슨형태로 바꾸기 
		ObjectMapper mapper = new ObjectMapper();
		List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
		map.put("list", list); //리스트에 옵션에 대한 정보가 담김
		resultMap = ProductService.insertOrder(map);  
		return new Gson().toJson(resultMap);
	}
	
//	@RequestMapping(value = "/product/cartToOrder.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
//	@ResponseBody
//	public String cartToOrder(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
//		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		String json = map.get("subOptionList").toString(); //제이슨형태로 바꾸기 
//		ObjectMapper mapper = new ObjectMapper();
//		List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
//		map.put("list", list); //리스트에 옵션에 대한 정보가 담김
//		resultMap = ProductService.insertOrder(map);
//		return new Gson().toJson(resultMap);
//	}
}
