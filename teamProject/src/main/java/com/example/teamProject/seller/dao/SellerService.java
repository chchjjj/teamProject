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

public HashMap<String, Object> updateAnswerContent(int questionId, String answerContent) {
    HashMap<String, Object> resultMap = new HashMap<>();
    try {
        Map<String, Object> params = new HashMap<>();
        params.put("questionId", questionId);       // ⭐ 질문 번호 사용
        params.put("answerContent", answerContent);  // 답변 내용

        sellerMapper.updateAnswerContent(params);
        resultMap.put("result", "success");
        resultMap.put("message", "답변 내용이 성공적으로 업데이트되었습니다.");
        System.out.println("답글 성공");
    } catch (Exception e) {
        resultMap.put("result", "fail");
        resultMap.put("message", "답변 업데이트 중 오류가 발생했습니다: " + e.getMessage());
        System.out.println("답글 실패");
        
    }
    return resultMap;
}

public Map<String, Object> getStoreInfo(String userId) {
    return sellerMapper.selectStoreInfo(userId); // userId를 통해 DB에서 가게 정보를 조회
}

// 가게 정보 수정
public boolean updateStoreInfo(String userId, String storeName, String storeZipcode, 
        String storeAddrMain, String storeAddrDetail, String storeIntro, String deliveryYn, String chatYn) {
    // 서비스 로직 수행 (DB에 업데이트)
    Map<String, String> params = new HashMap<>();
    params.put("userId", userId);
    params.put("storeName", storeName);
    params.put("storeZipcode", storeZipcode);
    params.put("storeAddrMain", storeAddrMain);
    params.put("storeAddrDetail", storeAddrDetail);
    params.put("storeIntro", storeIntro);
    params.put("deliveryYn", deliveryYn);
    params.put("chatYn", chatYn);

    return sellerMapper.updateStoreInfo(params);
}









public Map<String, Object> getProductDataForEdit(int proNo) {
    
    Seller product = sellerMapper.selectProductByProNo(proNo); 
    if (product == null) return null;

    List<Map<String, Object>> files = sellerMapper.selectProductFiles(proNo);

    List<Seller> options = sellerMapper.selectProductOptions(proNo); 
    
    List<String> disabledDates = sellerMapper.selectDisabledDates(proNo);

    Map<String, Object> result = new HashMap<>();
    result.put("product", product);
    result.put("files", files);
    result.put("options", options);
    result.put("disabledDates", disabledDates);
    
    return result;
}

public int getStoreIdByUserId(String userId) {
    // 💡 조회 실패 시 0을 반환하도록 되어 있다면, 이 부분이 문제의 원인입니다.
    // 쿼리 결과가 NULL일 때 0을 반환하도록 XML이나 Service에서 설정했을 가능성이 높습니다.
    
    // (MyBatis Mapper 호출)
    Integer storeId = sellerMapper.getStoreIdByUserId(userId);
    System.out.println(">>> [Service Log] " + userId + "로 조회한 STORE_ID: " + storeId);
    
    // 이 코드가 0을 반환하고 있을 수 있습니다.
    return (storeId != null) ? storeId : 0; 
}

@Transactional
public void updateProduct(Seller seller) throws Exception {
    // Controller에서 storeId와 userId가 이미 설정되어 넘어왔습니다.
    
    int proNo = seller.getProNo();
    
    // 1. 제품 기본 정보 수정
    sellerMapper.updateProduct(seller);
    
    // 2. 기존 옵션 삭제 후 재등록
    sellerMapper.deleteProductOptions(proNo);
    insertOptions(proNo, seller.getOptions());

    // 3. 기존 불가 날짜 삭제 후 재등록
    sellerMapper.deleteDisabledDates(proNo);
    if (seller.getDisabledDates() != null && !seller.getDisabledDates().isEmpty()) {
        for(String date : seller.getDisabledDates()) {
            sellerMapper.insertDisabledDate(proNo, date);
        }
    }
}

//SellerService.java

@Transactional
public void registerProduct(Seller seller) throws Exception {
 
 // Controller에서 storeId가 설정되어 넘어왔다고 가정
	String storeId = seller.getStoreId();
 
 // --- ⭐ STORE_NAME 조회 및 설정 (추가) ⭐ ---
 
 // sellerMapper를 사용하여 storeId를 기반으로 STORE_NAME을 조회합니다.
 String storeName = sellerMapper.getStoreNameByStoreId(storeId);
 
 if (storeName == null || storeName.isEmpty()) {
     // 유효성 검사: 가게 이름이 없다면 예외 발생
     throw new Exception("Store ID " + storeId + "에 해당하는 가게 이름(STORE_NAME)을 찾을 수 없습니다.");
 }
 
 // 조회된 이름을 DTO에 설정하여 MyBatis가 사용할 수 있도록 합니다.
 seller.setStoreName(storeName); 
 
 // --- (선택) 다른 NOT NULL 필드 검토 ---
 // PRO_TYPE과 STATUS의 NULL 방지 (DTO에 기본값을 설정하지 않았다면 필요)
 if (seller.getProType() == null || seller.getProType().isEmpty()) {
     seller.setProType("NONE"); 
 }
 // STATUS도 필수값일 경우 처리
 if (seller.getStatus() == null || seller.getStatus().isEmpty()) {
     seller.setStatus("Y"); 
 }
 
 // 1. 제품 등록 (Mybatis에서 proNo 생성 및 모든 필수 필드 삽입)
 sellerMapper.insertProduct(seller); 
 int proNo = seller.getProNo(); 

 // 2. 옵션 등록
 insertOptions(proNo, seller.getOptions());
 
 // 3. 불가 날짜 등록
 if (seller.getDisabledDates() != null && !seller.getDisabledDates().isEmpty()) {
     for(String date : seller.getDisabledDates()) {
         sellerMapper.insertDisabledDate(proNo, date);
     }
 }
}

//옵션 등록을 위한 내부 유틸리티 메서드
private void insertOptions(int proNo, List<Seller> options) {
    if (options == null || options.isEmpty()) return;

    for (Seller topOpt : options) {
        topOpt.setProNo(proNo); 
        // 1. 상위 옵션 등록 (topOptionId 생성)
        sellerMapper.insertTopOption(topOpt); 
        int topOptionId = topOpt.getTopOptionId();
        
        // 2. 하위 옵션 등록
        if (topOpt.getSubOptions() != null) {
            for (Seller subOpt : topOpt.getSubOptions()) { 
                subOpt.setTopOptionId(topOptionId); 
                sellerMapper.insertSubOption(subOpt);
            }
        }
    }
}

}
