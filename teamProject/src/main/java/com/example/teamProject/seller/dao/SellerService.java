package com.example.teamProject.seller.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.seller.mapper.SellerMapper;
import com.example.teamProject.seller.model.Seller;

@Service
public class SellerService {
	@Autowired
	SellerMapper sellerMapper;

	// 판매자 가게 리스트 불러오기
	public HashMap<String, Object> getStoreList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Seller> list = sellerMapper.selectStoreList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			System.out.println(resultMap);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}

		return resultMap;
	}

	// 월별 판매 리스트 불러오기
	public HashMap<String, Object> getSellesChart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 입력값 콘솔 출력
			System.out.println("입력 map: " + map);

			// Mapper XML 호출
			List<HashMap<String, Object>> list = sellerMapper.selectMonthlySales(map);

			// 조회 결과 콘솔 출력
			System.out.println("조회 결과 list: " + list);

			resultMap.put("list", list);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("error", "월별 매출 조회 중 오류 발생");
		}
		return resultMap;
	}

	// 판매 내역
	public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> orders = new ArrayList<>();

		try {
			// 1. DB에서 주문 리스트 조회 (Mapper 호출)
			orders = sellerMapper.selectOrderList(map);
			
			// 2. null 체크
			if (orders == null) {
				orders = new ArrayList<>();
			}

			result.put("list", orders);

		} catch (Exception e) {
			// 에러 발생 시 로그 출력
			e.printStackTrace();

			// 빈 리스트 반환 + 에러 메시지 포함 가능
			result.put("list", new ArrayList<>());
			result.put("error", "판매 내역 조회 중 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}

	public HashMap<String, Object> getOrderDetail(HashMap<String, Object> map) {

		HashMap<String, Object> result = new HashMap<>();

		HashMap<String, Object> orderDetail = null;

		try {

			List<HashMap<String, Object>> orders = sellerMapper.selectOrderDetail(map);

			if (orders != null && !orders.isEmpty()) {
				orderDetail = orders.get(0);

				result.put("orderDetail", orderDetail);

				result.put("status", "success");

			} else {

				result.put("status", "not_found");
				result.put("message", "해당 주문 ID에 대한 상세 정보를 찾을 수 없습니다.");
			}

		} catch (Exception e) {

			e.printStackTrace();

			result.clear();
			result.put("status", "error");
			result.put("message", "주문 상세 정보 조회 중 시스템 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}

	// 판매자 가게 리스트 불러오기
		public HashMap<String, Object> getChat(String orderId) {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List<HashMap<String, Object>> list = sellerMapper.selectChatPass(orderId);
				resultMap.put("list", list);
				resultMap.put("result", "success");
				System.out.println(resultMap);
			} catch (Exception e) {
				// TODO: handle exception
				resultMap.put("result", "fail");
				System.out.println(e.getMessage());
			}

			return resultMap;
		}
		
		
	  

	    public List<Seller> selectChatHistoryByOrderId(Long orderId) {
	        try {
	            System.out.println("DEBUG: [ChatService] 채팅 기록 조회 시도. Order ID: " + orderId);
	            List<Seller> history = sellerMapper.selectChatHistoryByOrderId(orderId);
	            System.out.println("DEBUG: [ChatService] 채팅 기록 조회 성공. 결과 개수: " + history.size());
	            return history;
	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 채팅 기록 조회 중 오류 발생 - Order ID: " + orderId);
	            e.printStackTrace();
	            return List.of(); 
	        }
	    }

	    @Transactional
	    public void sendMessage(Seller message) {
	        try {
	            System.out.println("DEBUG: [ChatService] 메시지 전송 트랜잭션 시작. Order ID: " + message.getOrderId());
	            
	            sellerMapper.insertChatMessage(message);
	            System.out.println("DEBUG: [ChatService] 1. 새 메시지 DB 저장 성공.");

	            sellerMapper.updateChatRoomLastMessage(message); 
	            System.out.println("DEBUG: [ChatService] 2. 채팅방 정보 업데이트 성공.");

	            System.out.println("DEBUG: [ChatService] 메시지 전송 트랜잭션 성공적으로 완료.");

	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 메시지 전송 및 채팅방 업데이트 트랜잭션 실패 - Order ID: " + message.getOrderId());
	            e.printStackTrace();
	            
	            // 🚨 중요: @Transactional이 Exception 발생 시 롤백하려면 RuntimeException을 다시 던져야 합니다.
	            throw new RuntimeException("메시지 전송 처리 실패", e);
	        }
	    }

	    public void updateMessageReadStatus(Long orderId, String readerId) {
	        try {
	            System.out.println("DEBUG: [ChatService] 메시지 읽음 처리 시도. Order ID: " + orderId + ", Reader ID: " + readerId);
	            sellerMapper.updateMessageReadStatus(orderId, readerId);
	            System.out.println("DEBUG: [ChatService] 메시지 읽음 처리 성공.");
	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 메시지 읽음 처리 중 오류 발생 - Order ID: " + orderId);
	            e.printStackTrace();
	        }
	    }
public HashMap<String, Object> selectReviewList(HashMap<String, Object> param) {
	        
	        HashMap<String, Object> resultMap = new HashMap<>();
	        
	        try {
               
                System.out.println("SERVICE 요청 파라미터 (selectReviewList): " + param);
              
	            List<HashMap<String, Object>> reviewList = sellerMapper.selectReviewList(param);
                
	            resultMap.put("list", reviewList);
                
          
                if (reviewList != null) {
                    System.out.println("SERVICE 리뷰 목록 조회 성공. 건수: " + reviewList.size());
                } else {
                    System.out.println("SERVICE 리뷰 목록 조회 결과: NULL");
                }
	            
	        } catch (Exception e) {
	      
	            System.err.println("SERVICE 리뷰 목록 조회 중 에러 발생: " + e.getMessage());
	            e.printStackTrace(); // 상세 스택 트레이스 출력
	            
	            resultMap.put("list", null); 
	            resultMap.put("result", "error");
	        }
	        
	        return resultMap;
	    }
@Transactional
public boolean addOrderOptions(Map<String, Object> paramMap) {
    try {
        int result = sellerMapper.updateOrderOptions(paramMap);
        
        if (result > 0) {
            return true;
        } else {
            System.err.println("옵션 업데이트 실패: 주문 ID를 찾을 수 없습니다. (ORDER_ID: " + paramMap.get("orderId") + ")");
            return false;
        }
    } catch (Exception e) {
        System.err.println("옵션 업데이트 중 데이터베이스 오류 발생: " + e.getMessage());
        e.printStackTrace();
        
        return false;
    }
}
	 


public List<Map<String, Object>> selectPickupSchedule(Map<String, Object> paramMap) {
    List<Map<String, Object>> pickupList = Collections.emptyList();
    
    try {
        pickupList = sellerMapper.selectPickupSchedule(paramMap);
        
    } catch (Exception e) {
    	System.err.println("옵션 업데이트 중 데이터베이스 오류 발생: " + e.getMessage());
        e.printStackTrace();
      
    }
    
    return pickupList;
}

public HashMap<String, Object> getSellerInfo(HashMap<String, Object> map) {
    HashMap<String, Object> resultMap = new HashMap<>();
    try {
        System.out.println("📥 getSellerInfo() 호출됨 - 전달된 map: " + map);
        HashMap<String, Object> info = sellerMapper.selectSellerInfo(map);
        System.out.println("📤 selectSellerInfo 결과: " + info);

        if (info != null) {
            resultMap.put("info", info);
            resultMap.put("result", "success");
            System.out.println("✅ 판매자 정보 조회 성공");
        } else {
            resultMap.put("result", "not_found");
            System.out.println("⚠️ 판매자 정보 없음");
        }
    } catch (Exception e) {
        e.printStackTrace();
        resultMap.put("result", "error");
        resultMap.put("message", "판매자 정보 조회 중 오류 발생: " + e.getMessage());
        System.out.println("❌ 판매자 정보 조회 중 오류: " + e.getMessage());
    }
    return resultMap;
}

public HashMap<String, Object> getStoreInfo(HashMap<String, Object> map) {
    HashMap<String, Object> resultMap = new HashMap<>();
    try {
        System.out.println("📥 getSellerInfo() 호출됨 - 전달된 map: " + map);
        HashMap<String, Object> info = sellerMapper.selectStoreInfoByUserId(map);
        System.out.println("📤 selectSellerInfo 결과: " + info);

        if (info != null) {
            resultMap.put("info", info);
            resultMap.put("result", "success");
            System.out.println("✅ 판매자 정보 조회 성공");
        } else {
            resultMap.put("result", "not_found");
            System.out.println("⚠️ 판매자 정보 없음");
        }
    } catch (Exception e) {
        e.printStackTrace();
        resultMap.put("result", "error");
        resultMap.put("message", "판매자 정보 조회 중 오류 발생: " + e.getMessage());
        System.out.println("❌ 판매자 정보 조회 중 오류: " + e.getMessage());
    }
    return resultMap;
}


//판매자 정보 수정
@Transactional
public HashMap<String, Object> updateSellerInfo(HashMap<String, Object> map) {
 HashMap<String, Object> resultMap = new HashMap<>();
 try {
     int result = sellerMapper.updateSellerInfo(map);

     if (result > 0) {
         resultMap.put("result", "success");
     } else {
         resultMap.put("result", "fail");
         resultMap.put("message", "수정할 데이터가 없습니다.");
     }
 } catch (Exception e) {
     e.printStackTrace();
     resultMap.put("result", "error");
     resultMap.put("message", "판매자 정보 수정 중 오류 발생: " + e.getMessage());
 }
 return resultMap;
}

public HashMap<String, Object> getQnAListByProNo(HashMap<String, Object> map) {
    HashMap<String, Object> resultMap = new HashMap<String, Object>();
    try {
      
        List<HashMap<String, Object>> list = sellerMapper.selectQnA(map); 

  
        if (list != null) {
            resultMap.put("list", list);
            resultMap.put("result", "success");
            System.out.println("✅ QnA 목록 조회 성공. 건수: " + list.size());
        } else {
            resultMap.put("list", new ArrayList<>());
            resultMap.put("result", "success"); // 결과가 없더라도 성공으로 처리
            System.out.println("⚠️ QnA 목록 조회 결과 없음");
        }
    } catch (Exception e) {
   
        resultMap.put("result", "fail");
        resultMap.put("message", "QnA 목록 조회 중 오류 발생: " + e.getMessage());
        System.err.println("❌ QnA 목록 조회 중 오류: " + e.getMessage());
        e.printStackTrace();
    }

    return resultMap;
}

}
