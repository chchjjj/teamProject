package com.example.teamProject.seller.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.seller.mapper.ProductImgMapper;
import com.example.teamProject.seller.mapper.SellerMapper;
import com.example.teamProject.seller.model.Seller;
import com.fasterxml.jackson.core.type.TypeReference;

@Service
public class SellerService {
	@Autowired
	private SellerMapper sellerMapper;
	@Autowired
    private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
    private ProductImgMapper productImgMapper; // 이미지 삭제를 위해 필요
	
	public SellerService(SellerMapper sellerMapper) {
        this.sellerMapper = sellerMapper;
    }
	
	
	private static final String ALLERGY_MAPPER_NAMESPACE = "com.example.teamProject.seller.mapper.SellerMapper";
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
	
	// 판매자 가게 리스트 불러오기
	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
	    
	    // ⭐️ [최종 확인 지점] Service로 넘어온 map의 내용을 출력합니다.
	    System.out.println(">>> [PRODUCT_LIST] Service 입력 map: " + map); // 이 로그를 확인해주세요!
	    
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        List<Seller> list = sellerMapper.selectProductList(map);
	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	        
	        // 최종 resultMap 출력 (상품 목록이 비어있는지 확인)
	        System.out.println(">>> [PRODUCT_LIST] Service 최종 응답: " + resultMap); 
	        
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        System.out.println(e.getMessage());
	    }

	    return resultMap;
	}
	
	@Transactional // 트랜잭션 처리 (Spring 환경 가정)
    public int updateMemberInfo(Map<String, Object> memberInfoMap) throws Exception {
        
        // 1. 필요한 경우 비즈니스 로직 추가 (예: 권한 체크, 데이터 검증)
        
        // 2. DAO/Mapper 호출
        int result = sellerMapper.updateMemberInfo(memberInfoMap);
        
        // 3. (옵션) 결과 처리
        if (result == 0) {
            // throw new CustomException("수정 실패");
        }
        
        return result;
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
    return (Map<String, Object>) sellerMapper.selectStoreInfo(userId); // userId를 통해 DB에서 가게 정보를 조회
}

public boolean updateStoreInfo(Map<String, Object> paramMap) {
    try {
        // 1. 필수 컬럼 검증
        if (paramMap.get("userId") == null || paramMap.get("storeId") == null) {
            return false;
        }

        // 2. storeId 숫자 변환 (NUMBER 컬럼)
        Object storeIdObj = paramMap.get("storeId");
        int storeId;
        if (storeIdObj instanceof String) {
            storeId = Integer.parseInt((String) storeIdObj);
        } else if (storeIdObj instanceof Number) {
            storeId = ((Number) storeIdObj).intValue();
        } else {
            return false;
        }
        paramMap.put("storeId", storeId);

        // 3. null 값 처리 (VARCHAR2/CHAR 컬럼)
        paramMap.put("storeName", paramMap.getOrDefault("storeName", ""));
        paramMap.put("storeAddr", paramMap.getOrDefault("storeAddr", ""));
        paramMap.put("storeIntro", paramMap.getOrDefault("storeIntro", ""));
        paramMap.put("deliveryYn", paramMap.getOrDefault("deliveryYn", "N"));
        paramMap.put("isChatEnabled", paramMap.getOrDefault("isChatEnabled", "N"));

        // 4. Mapper 호출
        int updateCount = sellerMapper.updateStoreInfo(paramMap);
        return updateCount > 0;

    } catch (NumberFormatException nfe) {
        nfe.printStackTrace();
        return false;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
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




@Transactional(rollbackFor = Exception.class) // 🌟 모든 예외 발생 시 롤백 보장
public void updateProduct(Seller seller) { // Exception을 던지지 않고 RuntimeException으로 처리
    
    // 🚨 1. 메서드 시작 및 입력 데이터 확인
    System.out.println("========================================================================");
    System.out.println(">>> [Service] updateProduct 트랜잭션 시작");
    
    int proNo = seller.getProNo();
    
    try {
        // 🚨 2. 핵심 식별자 및 새 데이터 확인
        System.out.println(">>> 수정 대상 PRO_NO: " + proNo);
        System.out.println(">>> 새 PRO_NAME: " + seller.getProName());
        String proInfoPreview = seller.getProInfo() != null ? 
                                seller.getProInfo().substring(0, Math.min(seller.getProInfo().length(), 50)) + "..." : "NULL/EMPTY";
        System.out.println(">>> 새 PRO_INFO (미리보기): " + proInfoPreview);
        
        // 1. 제품 기본 정보 수정
        int updatedRows = sellerMapper.updateProduct(seller); // 🌟 수정된 행 수 확인
        System.out.println(">>> [DB] 제품 기본 정보 (PRODUCT_TBL) 수정 완료. 수정된 행: " + updatedRows);
        
        if (updatedRows == 0) {
            // 🌟 수정된 행이 0개라면 트랜잭션을 롤백하고 오류 발생
            System.out.println("❌ 오류: PRO_NO(" + proNo + ") 또는 STORE_ID가 일치하는 수정 대상이 DB에 없습니다.");
            throw new RuntimeException("DB 수정 대상이 없습니다. (PRO_NO 또는 STORE_ID 확인 필요)");
        }
        
        // 2. 기존 옵션 삭제 후 재등록
        System.out.println(">>> [DB] 기존 옵션 삭제 시작 (PRO_NO: " + proNo + ")");
        sellerMapper.deleteProductOptions(proNo);
        System.out.println(">>> [DB] 기존 옵션 삭제 완료.");
        
        if (seller.getOptions() != null && !seller.getOptions().isEmpty()) {
            System.out.println(">>> 등록할 옵션 개수: " + seller.getOptions().size() + "개");
            // insertOptions 내부에서 Batch Insert를 사용하면 효율적
            insertOptions(proNo, seller.getOptions());
            System.out.println(">>> [DB] 새 옵션 재등록 완료.");
        } else {
            System.out.println(">>> 등록할 옵션 없음.");
        }

        // 3. 기존 불가 날짜 삭제 후 재등록
        System.out.println(">>> [DB] 기존 불가 날짜 삭제 시작 (PRO_NO: " + proNo + ")");
        sellerMapper.deleteDisabledDates(proNo);
        System.out.println(">>> [DB] 기존 불가 날짜 삭제 완료.");
        
        if (seller.getDisabledDates() != null && !seller.getDisabledDates().isEmpty()) {
            System.out.println(">>> 등록할 불가 날짜 개수: " + seller.getDisabledDates().size() + "개");
            // 🌟 for문 대신 Batch Insert 권장 (현재는 로깅을 위해 for문 유지)
            for(String date : seller.getDisabledDates()) {
                sellerMapper.insertDisabledDate(proNo, date);
                System.out.println("    - 불가 날짜 등록: " + date);
            }
            System.out.println(">>> [DB] 새 불가 날짜 재등록 완료.");
        } else {
            System.out.println(">>> 등록할 불가 날짜 없음.");
        }
        
        // 🚨 3. 메서드 종료 확인
        System.out.println(">>> [Service] updateProduct 트랜잭션 커밋 예정 (정상 종료).");
        System.out.println("========================================================================");
        
    } catch (Exception e) {
        // 🌟 예외 발생 시 무조건 스택 트레이스 출력 및 롤백 유도
        System.err.println("❌ FATAL ERROR: 상품 수정 중 예외 발생. 트랜잭션이 롤백됩니다.");
        e.printStackTrace(); 
        // RuntimeException을 던져서 @Transactional이 롤백을 확실히 수행하도록 함
        throw new RuntimeException("상품 수정 서비스 처리 중 오류 발생: " + e.getMessage(), e); 
    }
}



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
  // 🚨 1. 입력 데이터 확인
  System.out.println("==================== insertOptions 시작 ====================");
  System.out.println(">>> PRO_NO: " + proNo);

  if (options == null || options.isEmpty()) {
      System.out.println(">>> 등록할 옵션 리스트가 비어있거나 NULL입니다.");
      return;
  }

  int topOptionIndex = 0;
  for (Seller topOpt : options) {
      topOpt.setProNo(proNo); 
      
      // 🚨 2. 상위 옵션 등록 직전, 핵심 필드 값 확인 (NULL 여부 확인)
      System.out.println("--- [Top Option #" + (++topOptionIndex) + " 등록 시도] ---");
      System.out.println("  OptionName: " + topOpt.getOptionName());
      // ⚠️ ORA-01400의 원인: 이 값이 'null'로 찍힌다면 DTO/JSON 파싱 문제입니다.
     
      
      // 1. 상위 옵션 등록 (topOptionId 생성)
      sellerMapper.insertTopOption(topOpt); 
      int topOptionId = topOpt.getTopOptionId();
      
      System.out.println("  [DB] 상위 옵션 등록 완료. TOP_OPTION_ID: " + topOptionId);
      
      // 2. 하위 옵션 등록
      if (topOpt.getSubOptions() != null) {
          System.out.println("  하위 옵션 개수: " + topOpt.getSubOptions().size() + "개");
          
          int subOptionIndex = 0;
          for (Seller subOpt : topOpt.getSubOptions()) { 
              subOpt.setTopOptionId(topOptionId); 
              
              // 🚨 3. 하위 옵션 등록 직전, 데이터 확인
              System.out.println("  - Sub Option #" + (++subOptionIndex) + " ValueName: " + subOpt.getValueName());
              
              sellerMapper.insertSubOption(subOpt);
          }
      } else {
          System.out.println("  하위 옵션 없음.");
      }
  }
  System.out.println("==================== insertOptions 완료 ====================");
}

@Transactional // 💡 두 개의 Mapper 호출을 하나의 트랜잭션으로 묶어줍니다.
public int deleteProduct(int proNo) {
    
    // 1. **하위 데이터 삭제: 상품 이미지 정보 삭제**
    //    -> 메인 상품(PRODUCT_TBL) 삭제 전, 외래 키로 묶인 이미지 테이블(PRODUCT_IMG_TBL)의 데이터를 먼저 삭제해야 합니다.
    //    -> 성공/실패 여부를 여기서 체크하지 않고, 메인 상품 삭제가 실패할 경우 전체 롤백되도록 처리합니다.
    try {
        int imgDeletedCount = productImgMapper.deleteImagesByProNo(proNo);
        System.out.println("LOG: " + proNo + "번 상품의 이미지 " + imgDeletedCount + "개 삭제 완료.");
    } catch (Exception e) {
        // 이미지 삭제 실패 시, 트랜잭션을 롤백시키기 위해 RuntimeException을 던집니다.
        throw new RuntimeException("상품 이미지 삭제 중 오류 발생: " + e.getMessage());
    }

    // 2. **상위 데이터 삭제: 메인 상품 정보 삭제**
    int productDeletedCount = sellerMapper.deleteProduct(proNo);
    
    if (productDeletedCount == 0) {
         // 메인 상품이 삭제되지 않았다면 (proNo 불일치), 여기서 롤백을 유도할 수 있습니다.
         // 다만, 보통 delete는 0이 반환되어도 정상 흐름으로 간주하고 최종 productDeletedCount를 Controller에 반환합니다.
    }
    
    return productDeletedCount;
}

public int checkStoreOwnership(String userId, int storeId) {
    return sellerMapper.checkStoreOwnership(userId, storeId);
}

public Map<String, Object> selectStoreInfoData(int storeId) { // 🟢 storeId 타입을 int로 변경

    // storeId가 유효한지 확인
    if (storeId <= 0) {
        return null;
    }

    return sellerMapper.selectStoreInfoData(storeId);
}
// 상품 조회
public Map<String, Object> getProduct(int proNo) {
    return sellerMapper.selectProductProNo(proNo); // XML id와 일치
}

// 옵션 조회
public List<Map<String, Object>> getOptionsByProduct(int proNo) {
    return sellerMapper.selectOptionsByProNo(proNo); // XML id와 일치
}

// 불가 날짜 조회
public List<String> getDisabledDates(int proNo) {
    return sellerMapper.selectDisabledDate(proNo); // XML id와 일치
}

public HashMap<String, Object> insertProductAllergy(HashMap<String, Object> map) throws Exception {
	// TODO Auto-generated method stub
	
	HashMap<String, Object> resultMap = new HashMap<String, Object>();
	List<Object> list = (List<Object>) map.get("list");
	for(int i=0; i<list.size(); i++) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("proNo", map.get("proNo"));
		param.put("ingreId", (Integer) list.get(i));
		sellerMapper.insertProductAllergy(param);
	}
	resultMap.put("result","success");
	return resultMap;
}


//@Transactional(rollbackFor = Exception.class) 
//public int insertProductAllergy(Map<String, Object> param) throws Exception {
//    
//    // Map에서 proNo와 List를 추출합니다.
//    int proNo = (int) param.get("proNo");
//    @SuppressWarnings("unchecked")
//    List<Integer> ingreIdList = (List<Integer>) param.get("ingreIdList");
//    
//    System.out.println("LOG: [AllergyService] 상품 번호: " + proNo + ", 등록할 재료 개수: " + (ingreIdList != null ? ingreIdList.size() : 0));
//
//    // 1. 기존 알레르기 정보 삭제 (DELETE)
//    // SellerMapper.xml의 deleteProductAllergy ID를 호출
//    sqlSessionTemplate.delete(ALLERGY_MAPPER_NAMESPACE + ".deleteProductAllergy", proNo); 
//    System.out.println("LOG: [AllergyService] 기존 알레르기 정보 삭제 완료 (proNo: " + proNo + ")");
//
//
//    int insertCount = 0;
//    
//    // 2. 새 알레르기 정보 등록 (INSERT)
//    if (ingreIdList != null && !ingreIdList.isEmpty()) {
//        // SellerMapper.xml의 insertProductAllergy ID를 호출
//        insertCount = sqlSessionTemplate.insert(ALLERGY_MAPPER_NAMESPACE + ".insertProductAllergy", param);
//        System.out.println("LOG: [AllergyService] 새 알레르기 정보 " + insertCount + "개 등록 완료.");
//    } else {
//         System.out.println("LOG: [AllergyService] 등록할 알레르기 재료 없음.");
//    }
//    
//    // 최종적으로 등록된 행 개수를 반환합니다.
//    return insertCount;
//}

public HashMap<String, Object> productUpdate(HashMap<String, Object> map) throws Exception {
	// TODO Auto-generated method stub
	
	HashMap<String, Object> resultMap = new HashMap<String, Object>();
	sellerMapper.updateProduct(map);
	List<Object> dateList = (List<Object>) map.get("dateList");
	sellerMapper.deleteProductDate(map);
	for(int i=0; i<dateList.size(); i++) {
		HashMap<String, Object> param = map;
		System.out.println((String) dateList.get(i));
		param.put("date", (String) dateList.get(i));
		sellerMapper.insertProductDate(map);
	}
	resultMap.put("result","success");
	return resultMap;
}
}
