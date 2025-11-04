package com.example.teamProject.payment.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.payment.mapper.PaymentMapper;
import com.example.teamProject.payment.model.Payment;

@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper;

	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Payment> list = paymentMapper.selectCartList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	public HashMap<String, Object> addOrder(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			paymentMapper.insertOrder(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addOrderDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			paymentMapper.insertOrderDetail(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addOrderOption(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			paymentMapper.insertOrderOption(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}
	
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
			
            
         
         paymentMapper.insertPayment(map);
    	 resultMap.put("result", "success");
            
			
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	

	

	
	
	
	
}
