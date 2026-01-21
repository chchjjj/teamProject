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

	    public void updateMessageReadStatus(HashMap<String, Object> map) {
	        try {
	            System.out.println("DEBUG: [ChatService] 메시지 읽음 처리 시도. 데이터: " + map);
	            
	            // 이미 컨트롤러에서 map에 "orderId"와 "userId"를 잘 담아 보냈으므로 
	            // 서비스에서는 가공 없이 바로 매퍼로 전달만 하면 됩니다.
	            sellerMapper.updateMessageReadStatus(map);
	            
	            System.out.println("DEBUG: [ChatService] 메시지 읽음 처리 성공.");
	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 메시지 읽음 처리 중 오류 발생");
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




//판매자 정보 수정 (기본 정보 + 프로필/배너 이미지)
@Transactional
public HashMap<String, Object> updateSellerInfo(HashMap<String, Object> map) {

 HashMap<String, Object> resultMap = new HashMap<>();

 try {
     // ===============================
     // 1. 기본 판매자 정보 업데이트
     // ===============================
     int updateCnt = sellerMapper.updateSellerInfo(map);

     if (updateCnt <= 0) {
         resultMap.put("result", "fail");
         resultMap.put("message", "수정할 판매자 정보가 없습니다.");
         return resultMap;
     }

     // ===============================
     // 2. 프로필 이미지 처리
     // ===============================
     if (map.get("profileFileName") != null) {

         map.put("fileUse", "프로필");

         int profileCnt = sellerMapper.selectSellerImgCount(map);

         if (profileCnt > 0) {
             sellerMapper.updateSellerImg(map);
         } else {
             sellerMapper.insertSellerImg(map);
         }
     }

     // ===============================
     // 3. 배너 이미지 처리
     // ===============================
     if (map.get("bannerFileName") != null) {

         map.put("fileUse", "배너");

         int bannerCnt = sellerMapper.selectSellerImgCount(map);

         if (bannerCnt > 0) {
             sellerMapper.updateSellerImg(map);
         } else {
             sellerMapper.insertSellerImg(map);
         }
     }

     // ===============================
     // 4. 정상 종료
     // ===============================
     resultMap.put("result", "success");

 } catch (Exception e) {
     // ❗ 예외 발생 시 전체 롤백
     e.printStackTrace();
     throw e; // @Transactional 때문에 반드시 throw
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
            for(String date : seller.getDisabledDates()) {
                HashMap<String, Object> dateMap = new HashMap<>();
                dateMap.put("proNo", proNo);
                dateMap.put("disabledDate", date);  // 또는 "date"
                sellerMapper.insertDisabledDate(dateMap);  // HashMap 버전 호출
            }
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
	        HashMap<String, Object> dateMap = new HashMap<>();
	        dateMap.put("proNo", proNo);
	        dateMap.put("disabledDate", date);
	        sellerMapper.insertDisabledDate(dateMap);
	    }
	}
}

//옵션 등록을 위한 내부 유틸리티 메서드
private void insertOptions(int proNo, List<Seller> options) {
    System.out.println(">>> PRO_NO: " + proNo);

    if (options == null || options.isEmpty()) {
        System.out.println(">>> 등록할 옵션 리스트가 비어있거나 NULL입니다.");
        return;
    }

    int topOptionIndex = 0;
    for (Seller topOpt : options) {
        topOpt.setProNo(proNo); 
        
        System.out.println("--- [Top Option #" + (++topOptionIndex) + " 등록 시도] ---");
        System.out.println("  OptionName: " + topOpt.getOptionName());
        
        // 1. 상위 옵션 등록 (optNo가 Seller 객체에 자동으로 설정됨)
        sellerMapper.insertTopOption(topOpt); 
        int topOptionId = topOpt.getOptNo();  // ⭐ optNo를 가져옴 (topOptionId로 사용)
        
        System.out.println("  [DB] 상위 옵션 등록 완료. TOP_OPTION_ID: " + topOptionId);
        
        // 2. 하위 옵션 등록
        if (topOpt.getSubOptions() != null) {
            System.out.println("  하위 옵션 개수: " + topOpt.getSubOptions().size() + "개");
            
            int subOptionIndex = 0;
            for (Seller subOpt : topOpt.getSubOptions()) { 
                subOpt.setTopOptionId(topOptionId);  // ⭐ topOptionId 설정
                
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


//메인페이지 카운트
public int getTotalUnreadCount(HashMap<String, Object> map) {
    return sellerMapper.getTotalUnreadCount(map);
}

// 오늘 들어온 새 주문 카운트
public int getNewOrderCount(HashMap<String, Object> map) {
 return sellerMapper.getNewOrderCount(map);
}


@Transactional(rollbackFor = Exception.class) // 에러 발생 시 롤백 보장
public HashMap<String, Object> productUpdate(HashMap<String, Object> map) throws Exception {
    
    HashMap<String, Object> resultMap = new HashMap<String, Object>();
    
    try {
        System.out.println("🔧 [SERVICE] productUpdate 시작");
        
        // ===============================
        // 0. proNo 타입 안전하게 변환 (가장 먼저 수행)
        // ===============================
        if (map.get("proNo") == null) throw new RuntimeException("상품 번호(proNo)가 없습니다.");
        int proNo = Integer.parseInt(String.valueOf(map.get("proNo")));
        map.put("proNo", proNo); // 변환된 int 값을 다시 맵에 저장

        // ===============================
        // 1. 기본 상품 정보 업데이트
        // ===============================
        sellerMapper.updateProduct(map); // 인터페이스 명칭 확인 (updateProductInfo)
        System.out.println("✅ [SERVICE] 상품 기본 정보 업데이트 완료");
        
        // ===============================
        // 2. 썸네일 이미지 처리
        // ===============================
        if (map.get("thumbnailPath") != null && !map.get("thumbnailPath").toString().isEmpty()) {
            // 기존 썸네일 삭제
            HashMap<String, Object> deleteParam = new HashMap<>();
            deleteParam.put("proNo", proNo);
            deleteParam.put("fileuse", "T");
            sellerMapper.deleteProductImgByType(deleteParam);
            
            // 새 썸네일 삽입
            String fullPath = map.get("thumbnailPath").toString();
            String fileName = fullPath.substring(fullPath.lastIndexOf("/") + 1);
            
            HashMap<String, Object> imgMap = new HashMap<>();
            imgMap.put("proNo", proNo);
            imgMap.put("filepath", "/img-product/");
            imgMap.put("filename", fileName);
            imgMap.put("fileorgname", fileName);
            imgMap.put("fileuse", "T");
            imgMap.put("fileetc", "PNG");
            
            sellerMapper.insertProductImg(imgMap);
            System.out.println("✅ [SERVICE] 썸네일 업데이트 완료");
        }

        // ===============================
        // 3. 상세 이미지 처리
        // ===============================
        if (map.get("detailImagePaths") != null) {
            @SuppressWarnings("unchecked")
            List<String> detailPaths = (List<String>) map.get("detailImagePaths");
            
            HashMap<String, Object> deleteParam = new HashMap<>();
            deleteParam.put("proNo", proNo);
            deleteParam.put("fileuse", "I");
            sellerMapper.deleteProductImgByType(deleteParam);
            
            for (String fullPath : detailPaths) {
                if(fullPath == null || fullPath.isEmpty()) continue;
                String fileName = fullPath.substring(fullPath.lastIndexOf("/") + 1);
                
                HashMap<String, Object> imgMap = new HashMap<>();
                imgMap.put("proNo", proNo);
                imgMap.put("filepath", "/img-product/");
                imgMap.put("filename", fileName);
                imgMap.put("fileorgname", fileName);
                imgMap.put("fileuse", "I");
                imgMap.put("fileetc", "PNG");
                sellerMapper.insertProductImg(imgMap);
            }
        }

        // ===============================
        // 5. 불가 날짜 처리 (인터페이스 insertDisabledDate 기준)
        // ===============================
        if (map.get("dateList") != null) {
            @SuppressWarnings("unchecked")
            List<String> dateList = (List<String>) map.get("dateList");
            
            // 기존 날짜 삭제 (전체 맵 전달)
            sellerMapper.deleteDisabledDates(map); 
            
            for (String dateStr : dateList) {
                if(dateStr == null || dateStr.isEmpty()) continue;
                HashMap<String, Object> dateMap = new HashMap<>();
                dateMap.put("proNo", proNo);
                dateMap.put("disabledDate", dateStr);
                sellerMapper.insertDisabledDate(dateMap); // 인터페이스 명칭 확인
            }
            System.out.println("✅ [SERVICE] 불가 날짜 업데이트 완료");
        }
        
        // ===============================
        // 6. 옵션 처리
        // ===============================
        if (map.get("optionList") != null) {
            // 기존 옵션 삭제
            sellerMapper.deleteProductSubOptions(map);
            sellerMapper.deleteProductTopOptions(map);
            
            @SuppressWarnings("unchecked")
            List<HashMap<String, Object>> optionList = (List<HashMap<String, Object>>) map.get("optionList");
            
            for (HashMap<String, Object> topOption : optionList) {
                HashMap<String, Object> topMap = new HashMap<>();
                topMap.put("proNo", proNo);
                topMap.put("optionName", topOption.get("optionName"));
                topMap.put("isQuantitySelectAble", topOption.get("isQuantitySelectAble"));
                
                // 상위 옵션 등록 (selectKey를 통해 topMap에 optNo가 담김)
                sellerMapper.insertTopOption(topMap);
                
                // ⭐ 오라클/MyBatis에서 반환된 PK 값을 안전하게 가져오는 방법
                if (topMap.get("optNo") == null) throw new RuntimeException("상위 옵션 ID 생성 실패");
                int topOptionId = Integer.parseInt(String.valueOf(topMap.get("optNo")));
                
                @SuppressWarnings("unchecked")
                List<HashMap<String, Object>> subOptions = (List<HashMap<String, Object>>) topOption.get("subOptions");
                
                if (subOptions != null) {
                    for (HashMap<String, Object> subOption : subOptions) {
                        HashMap<String, Object> subMap = new HashMap<>();
                        subMap.put("topOptionId", topOptionId);
                        subMap.put("valueName", subOption.get("valueName"));
                        subMap.put("priceDiff", subOption.get("priceDiff"));
                        sellerMapper.insertSubOption(subMap);
                    }
                }
            }
            System.out.println("✅ [SERVICE] 옵션 업데이트 완료");
        }
        
        resultMap.put("result", "success");
        
    } catch (Exception e) {
        System.err.println("❌ [SERVICE] 에러 발생: " + e.getMessage());
        e.printStackTrace();
        resultMap.put("result", "error");
        resultMap.put("message", e.getMessage());
        throw e; // 트랜잭션 롤백을 위해 던짐
    }
    
    return resultMap;
}


public HashMap<String, Object> updateOrderStatus(HashMap<String, Object> map) {
    HashMap<String, Object> resultMap = new HashMap<>();
    
    try {
        System.out.println("=== updateOrderStatus 시작 ===");
        System.out.println("받은 파라미터: " + map);
        
        String status = (String) map.get("status");
        Object orderIdObj = map.get("orderId");
        
        // orderId를 Integer로 변환
        Integer orderId = null;
        if (orderIdObj != null) {
            if (orderIdObj instanceof Integer) {
                orderId = (Integer) orderIdObj;
            } else if (orderIdObj instanceof String) {
                try {
                    orderId = Integer.parseInt((String) orderIdObj);
                } catch (NumberFormatException e) {
                    resultMap.put("status", "fail");
                    resultMap.put("message", "주문번호 형식이 잘못되었습니다.");
                    return resultMap;
                }
            }
        }
        
        System.out.println("orderId (Integer): " + orderId);
        System.out.println("status: " + status);
        
        if (orderId == null) {
            resultMap.put("status", "fail");
            resultMap.put("message", "주문번호가 없습니다.");
            return resultMap;
        }
        
        // map에 Integer로 다시 넣기
        map.put("orderId", orderId);
        
        // 1. 주문 상태 업데이트
        int orderUpdated = sellerMapper.updateOrderStatus(map);
        System.out.println("주문 업데이트 결과: " + orderUpdated);
        
        if (orderUpdated > 0) {
            // 2. 주문 상세 정보 조회
            HashMap<String, Object> orderParam = new HashMap<>();
            orderParam.put("orderId", orderId);
            List<HashMap<String, Object>> orderDetail = sellerMapper.selectOrderDetail(orderParam);
            
            System.out.println("주문 상세 조회 결과: " + orderDetail);
            
            if (orderDetail != null && !orderDetail.isEmpty()) {
                // DELIVERY_YN 대신 DELIVERY_TYPE 사용
                String deliveryType = (String) orderDetail.get(0).get("DELIVERY_TYPE");
                System.out.println("배송 타입: " + deliveryType);
                
                // 3. 배송 주문인 경우 (D = 배송)
                if ("D".equals(deliveryType)) {
                    String deliveryStatus = mapOrderStatusToDeliveryStatus(status);
                    if (deliveryStatus != null) {
                        HashMap<String, Object> deliveryMap = new HashMap<>();
                        deliveryMap.put("orderId", orderId);
                        deliveryMap.put("deliveryStatus", deliveryStatus);
                        int deliveryUpdated = sellerMapper.updateDeliveryStatus(deliveryMap);
                        System.out.println("배송 상태 업데이트 결과: " + deliveryUpdated);
                    }
                }
                // 4. 픽업 주문인 경우 (P = 픽업)
                else if ("P".equals(deliveryType)) {
                    String pickupStatus = mapOrderStatusToPickupStatus(status);
                    if (pickupStatus != null) {
                        HashMap<String, Object> pickupMap = new HashMap<>();
                        pickupMap.put("orderId", orderId);
                        pickupMap.put("pickupStatus", pickupStatus);
                        int pickupUpdated = sellerMapper.updatePickupStatus(pickupMap);
                        System.out.println("픽업 상태 업데이트 결과: " + pickupUpdated);
                    }
                }
            }
            
            resultMap.put("status", "success");
            resultMap.put("message", "주문 상태가 성공적으로 변경되었습니다.");
        } else {
            resultMap.put("status", "fail");
            resultMap.put("message", "주문을 찾을 수 없습니다. ORDER_ID: " + orderId);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        resultMap.put("status", "error");
        resultMap.put("message", "상태 변경 중 오류 발생: " + e.getMessage());
    }
    
    System.out.println("=== updateOrderStatus 종료 ===");
    System.out.println("결과: " + resultMap);
    
    return resultMap;
}

// 주문 상태 → 배송 상태 매핑
private String mapOrderStatusToDeliveryStatus(String orderStatus) {
    switch (orderStatus) {
        case "C": return "A";  // 결제수락 → 주문수락완료
        case "D": return "D";  // 배송시작 → 배송중
        case "F": return "F";  // 완료 → 배송완료
        default: return null;
    }
}

// 주문 상태 → 픽업 상태 매핑
private String mapOrderStatusToPickupStatus(String orderStatus) {
    switch (orderStatus) {
        case "C": return "A";  // 결제수락 → 준비중
        case "R": return "B";  // 픽업대기 → 준비완료
        case "F": return "C";  // 완료 → 픽업완료
        default: return null;
    }
}

//이미지 가져오기 
public List<Map<String, Object>> getProductImages(int proNo) {
    List<Map<String, Object>> images = sellerMapper.selectProductImg(proNo);
    
    System.out.println("🔍 [SERVICE] getProductImages 호출 - proNo: " + proNo);
    System.out.println("🔍 [SERVICE] 조회된 이미지 개수: " + (images != null ? images.size() : 0));
    
    if (images != null) {
        for (Map<String, Object> img : images) {
            System.out.println("🔍 [SERVICE] 이미지 데이터: " + img);
        }
    }
    
    return images;
}

}
