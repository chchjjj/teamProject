package com.example.teamProject.payment.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	@Transactional
	public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			//List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) map.get("list");
			System.out.println("map 안에 담긴 값은 ===>" + map);
			
			//주문 목록 출력
			List<Payment> OrderList = paymentMapper.selectOrderList(map);
			
			//수령인 전화번호 가져오기
			List<Payment> phoneList = paymentMapper.selectPhoneList(map);
			
			resultMap.put("list", OrderList); 
			resultMap.put("phoneList", phoneList);
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
	
	public HashMap<String, Object> checkDelivery(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Payment info = paymentMapper.selectOrderAddress(map);
			resultMap.put("info", info); 
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
			List<Object> orderIdList = (List<Object>) map.get("orderIdList");
			List<Map<String, Object>> groupedOrdersList = (List<Map<String, Object>>) map.get("groupedOrdersList");
			System.out.println("맵=>" + map);
	        System.out.println("주문리스트=>" + groupedOrdersList);
         
	        if (groupedOrdersList == null || groupedOrdersList.isEmpty()) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "결제할 게 없습니다.");
	            return resultMap; 
	        }
	        
	        for (int i = 0; i < groupedOrdersList.size(); i++) {
	        	HashMap<String, Object> order = (HashMap<String, Object>) groupedOrdersList.get(i);
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
	            paymentMapper.updateOrderStatus(paymentMap);
	       	 	resultMap.put("result", "success");
	        }	
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}
	
	@Transactional
	public HashMap<String, Object> addDeliPayment(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Object> orderIdList = (List<Object>) map.get("orderIdList");
			List<Map<String, Object>> groupedOrdersList = (List<Map<String, Object>>) map.get("groupedOrdersList");
			System.out.println("맵=>" + map);
	        System.out.println("주문리스트=>" + groupedOrdersList);
         
	        if (groupedOrdersList == null || groupedOrdersList.isEmpty()) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "결제할 게 없습니다.");
	            return resultMap; 
	        }
	        
	        for (int i = 0; i < groupedOrdersList.size(); i++) {
	        	HashMap<String, Object> order = (HashMap<String, Object>) groupedOrdersList.get(i);
	        	// 공통 데이터
//	        	String orderId = (String) map.get("orderId");
//	        	String totalPrice = (String) order.get("totalPrice");
	        	int orderId = Integer.parseInt(order.get("orderId").toString());
	            int totalPrice = Integer.parseInt(order.get("totalPrice").toString());
	            String selectedDate = (String) map.get("selectedDate");
	            
	            System.out.println("selectedDate 변환 결과:" + selectedDate);
	        	
	        	// payment_tbl로 넘길 데이터 구성
	            HashMap<String, Object> paymentMap = new HashMap<>();
	            paymentMap.put("orderId", orderId);
	            paymentMap.put("totalPrice", totalPrice);
	            paymentMap.put("selectedDate", selectedDate);
	            
	            
	            paymentMapper.insertPayment(paymentMap);
	            paymentMapper.updateDeliveryWishDeli(paymentMap);
	            paymentMapper.updateOrderStatus(paymentMap);
	       	 	resultMap.put("result", "success");
	        }	
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	@Transactional
	public HashMap<String, Object> addPickPayment(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Object> orderIdList = (List<Object>) map.get("orderIdList");
			List<Map<String, Object>> groupedOrdersList = (List<Map<String, Object>>) map.get("groupedOrdersList");
			System.out.println("맵=>" + map);
	        System.out.println("주문리스트=>" + groupedOrdersList);
         
	        if (groupedOrdersList == null || groupedOrdersList.isEmpty()) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "결제할 게 없습니다.");
	            return resultMap; 
	        }
	        
	        for (int i = 0; i < groupedOrdersList.size(); i++) {
	        	HashMap<String, Object> order = (HashMap<String, Object>) groupedOrdersList.get(i);
	        	// 공통 데이터
//	        	String orderId = (String) map.get("orderId");
//	        	String totalPrice = (String) order.get("totalPrice");
	        	int orderId = Integer.parseInt(order.get("orderId").toString());
	            int totalPrice = Integer.parseInt(order.get("totalPrice").toString());
	            String selectedDate = (String) map.get("selectedDate");
	            System.out.println("selectedDate 변환 결과:" + selectedDate);
	        	
	        	// payment_tbl로 넘길 데이터 구성
	            HashMap<String, Object> paymentMap = new HashMap<>();
	            paymentMap.put("orderId", orderId);
	            paymentMap.put("totalPrice", totalPrice);
	            paymentMap.put("selectedDate", selectedDate);
	            
	            
	            paymentMapper.insertPayment(paymentMap);
	            paymentMapper.updatePickUpDate(paymentMap);
	            paymentMapper.updateOrderStatus(paymentMap);
	       	 	resultMap.put("result", "success");
	        }	
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	public HashMap<String, Object> addAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			paymentMapper.insertAddress(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	public HashMap<String, Object> addressList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Payment> list = paymentMapper.selectUserAddress(map);
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	public HashMap<String, Object> removeAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			paymentMapper.deleteUserAddress(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	public HashMap<String, Object> useAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Object> orderIdList = (List<Object>) map.get("list");
			System.out.println("맵=>" + map);
	        System.out.println("주문아이디리스트=>" + orderIdList);
         
	        if (orderIdList == null || orderIdList.isEmpty()) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "주문한 게 없습니다.");
	            return resultMap;
	        }
	        
	        for (int i = 0; i < orderIdList.size(); i++) {
	        	Object order = orderIdList.get(i);
	        	// 공통 데이터
	        	//String orderId = (String) map.get("orderId");
	        	int orderId = (Integer)order;
	        	
	            HashMap<String, Object> paymentMap = new HashMap<>();
	            //map.put("orderId", orderId);
	            paymentMap.put("orderId", orderId);
	            paymentMap.put("fullAddress", map.get("fullAddress"));
	            paymentMap.put("phone", map.get("phone"));
	            
	            System.out.println("반복문 속 paymentMap: " + paymentMap);
	            
	            paymentMapper.updateOrderAddress(paymentMap);
	            paymentMapper.updateDeliveryPhone(paymentMap);
	        }
	        
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	

	
	
	
	
}
