package com.example.teamProject.payment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.payment.dao.PaymentService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PaymentController {

	@Autowired
	PaymentService paymentService;
	
	@RequestMapping("/payment/payment.do")
	public String payment(HttpServletRequest request, Model model, 
	                      @RequestParam HashMap<String, Object> map) throws Exception {

	    // 프론트에서 보낸 selectItem(JSON 문자열) 꺼내기
	    String selectItemJson = (String) map.get("selectItem");

	    // JSON → List 변환 (Gson 사용)
	    List<String> cartIdList = new ArrayList<>();
	    if (selectItemJson != null && !selectItemJson.isEmpty()) {
	        Gson gson = new Gson();
	        cartIdList = gson.fromJson(selectItemJson, new TypeToken<List<String>>(){}.getType());
	    }

	    // JSP에서 쓸 수 있도록 model에 담기
	    model.addAttribute("cartIdList", cartIdList);

	    System.out.println("선택된 cartId 목록: " + cartIdList);

	    // 결제 페이지로 이동
	    return "/payment/payment";
	}
	
	@RequestMapping(value = "/payment/cartList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		// 2. Controller(.dox)에서 리스트 형태로 변경 후 map에 넣기
		String json = map.get("cartIdList").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		
		//List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
		
		map.put("list", list);
		
		System.out.println(map);
		
		resultMap = paymentService.getCartList(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/addOrder.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOrder(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.addOrder(map);
	
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/addOrderDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOrderDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.addOrderDetail(map);
	
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/addOrderOption.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addOrderOption(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.addOrderOption(map);
	
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.getOrderList(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/delivery.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String delivery(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.editDelivery(map);
	
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/payment.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String payment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.addPayment(map);
		
		return new Gson().toJson(resultMap);
	}

}
