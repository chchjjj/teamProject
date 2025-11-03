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
	//		paymentMapper.insertOrder(map);
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
	//		paymentMapper.insertOrderDetail(map);
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
//			paymentMapper.insertOrderOption(map);
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
//			List<Payment> list = paymentMapper.selectOrderList(map);
//			resultMap.put("list", list);
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
			// 1. HashMap에서 orderIdList 추출
            // 클라이언트에서 배열로 넘겼기 때문에 List<Object> 형태로 추출 가능합니다.
            @SuppressWarnings("unchecked")
            List<Object> orderIdList = (List<Object>) map.get("orderIdList");
			
            
         // 2. 리스트의 각 요소에 대해 반복 처리
            if (orderIdList != null && !orderIdList.isEmpty()) {
                
                // 기타 공통 값 (uid, amount)은 미리 추출
                Object uid = map.get("uid");
                Object amount = map.get("amount"); // 리스트 반복 내부에서 사용하지 않을 수도 있지만, 예시로 추출
                
                for (Object orderIdObj : orderIdList) {
                    // orderId는 일반적으로 Long, Integer 또는 String일 수 있으므로 적절하게 변환합니다.
                    // 여기서는 String으로 가정하고 진행합니다.
                    String orderId = String.valueOf(orderIdObj);
                    
                    // 3. 반복되는 작업 수행 (예: addOrderDetail, addPayment 등)
                    
                    // 각 Order ID에 대한 로직을 수행하기 위한 새로운 맵 생성
                    HashMap<String, Object> orderDetailMap = new HashMap<>();
                    orderDetailMap.put("uid", uid);
                    orderDetailMap.put("orderId", orderId);
                    // orderDetailMap.put("amount", amount); // 필요한 경우 추가
                    
                    // 예시 1: addOrderDetail 함수 호출 (개별 주문 상세 처리)
                    // 이 함수 내부에서는 보통 Map을 받아 Mapper를 호출할 것입니다.
                    // addOrderDetail(orderDetailMap);
                    
                    // 예시 2: Mapper를 직접 호출하거나, 더 복잡한 비즈니스 로직 추가
                    // paymentMapper.insertOrderDetailForSingleId(orderDetailMap); 
                    
                    // 로그 기록
                    System.out.println("Processing orderId: " + orderId + " for uid: " + uid);
                }
                
                // 4. 리스트 전체 처리가 완료된 후 최종 결제 이력 저장 등의 로직 수행
                // 전체 결제 정보를 저장하는 로직을 여기에서 수행할 수 있습니다.
 //               paymentMapper.insertPayment(map);
    			resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "orderIdList가 비어있습니다.");
            }
			
			
		} catch (Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); //개발자가 확인할 로그 기록
		}
		
		return resultMap;
	}

	

	

	
	
	
	
}
