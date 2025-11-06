package com.example.teamProject.payment.controller;

import java.util.ArrayList;
import java.util.Arrays;
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
	public String payment(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map)
			throws Exception {

		// 바로 주문하는 경우(productDetail.jsp) orderId 넘겨받기
		request.setAttribute("orderId", map.get("orderId"));

		// cart.jsp에서 보낸 selectItem(JSON 문자열) 꺼내기
		String selectItemJson = (String) map.get("orderIdList");

		// JSON → List 변환 (Gson 사용)
		List<String> orderIdList = new ArrayList<>();
		if (selectItemJson != null && !selectItemJson.isEmpty()) {
			Gson gson = new Gson();
			orderIdList = gson.fromJson(selectItemJson, new TypeToken<List<String>>() {
			}.getType());
		}

		// JSP에서 쓸 수 있도록 model에 담기
		model.addAttribute("orderIdList", orderIdList);

		System.out.println("cart.do에서 넘어온 orderIdList 목록: " + orderIdList);

		// 결제 페이지로 이동
		return "/payment/payment";
	}
	
	@RequestMapping("/payment/addressPopUp.do")
	public String login(Model model) throws Exception {
		
		return "/payment/addressPopUp";
	}

	@RequestMapping(value = "/payment/orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    System.out.println(map);
		ObjectMapper mapper = new ObjectMapper();
	    String json = map.get("orderIdList").toString();
	    // JSON 배열로 변환
	    List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {});
//	    List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
	    
	    System.out.println("list ==> " + list);
//	    
	    map.put("list", list);
	    resultMap = paymentService.getOrderList(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/cartRemove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartDelete(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		// 2. Controller(.dox)에서 리스트 형태로 변경 후 map에 넣기
		String json = map.get("cartIdList").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {
		});

		// List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});

		map.put("list", list);

		System.out.println(map);

		resultMap = paymentService.removeCartList(map);

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
		
		// 2. Controller(.dox)에서 리스트 형태로 변경 후 map에 넣기
		//String json = (String) map.get("cartItems");
		String json = map.get("orderList").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Object> orderList = mapper.readValue(json, new TypeReference<List<Object>>() {});

		//List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});

		map.put("orderList", orderList);

		System.out.println("payment map 안에 담긴 값은 ===>" + map);
		
		resultMap = paymentService.addPayment(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/addAddress.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.addAddress(map);
 
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/addressList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addressList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.addressList(map);
 
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/removeAddress.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.removeAddress(map);
 
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/payment/useAddress.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String useAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.useAddress(map);
 
		return new Gson().toJson(resultMap);
	}
}
