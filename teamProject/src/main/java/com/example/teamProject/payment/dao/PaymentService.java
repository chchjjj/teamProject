package com.example.teamProject.payment.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.payment.mapper.PaymentMapper;
import com.example.teamProject.payment.model.Payment;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper; 
	
	public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			//List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) map.get("list");
			System.out.println("map 안에 담긴 값은 ===>" + map);
			List<Payment> OrderList = paymentMapper.selectOrderList(map);
			resultMap.put("list", OrderList); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> removeCartList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			//List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) map.get("list");
			
			paymentMapper.deleteCartList(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	public HashMap<String, Object> editDelivery(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			paymentMapper.updateDelivery(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}
	
	

	@Transactional
	public HashMap<String, Object> addPayment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<HashMap<String, Object>> orderList = (List<HashMap<String, Object>>) map.get("orderList");
			System.out.println("맵=>" + map);
	        System.out.println("주문리스트=>" + orderList);
         
	        if (orderList == null || orderList.isEmpty()) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "결제할 게 없습니다.");
	            return resultMap;
	        }
	        
	        for (int i = 0; i < orderList.size(); i++) {
	        	HashMap<String, Object> order = orderList.get(i);
	        	// 공통 데이터
//	        	String orderId = (String) map.get("orderId");
//	        	String totalPrice = (String) order.get("totalPrice");
	        	int orderId = Integer.parseInt(order.get("orderId").toString());
	            int totalPrice = Integer.parseInt(order.get("totalPrice").toString());
	        	
	        	// payment_tbl로 넘길 데이터 구성
	            HashMap<String, Object> paymentMap = new HashMap<>();
	            paymentMap.put("orderId", orderId);
	            paymentMap.put("totalPrice", totalPrice);
	            
	            
	            paymentMapper.insertPayment(paymentMap);
	       	 	resultMap.put("result", "success");
	        }	
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	

	

	

	
	
	
	
}
