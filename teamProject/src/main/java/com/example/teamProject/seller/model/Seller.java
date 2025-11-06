package com.example.teamProject.seller.model;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class Seller {
		private int subOptionId;
		private int topOptionId;
		
		private String storeId;
	    private String storeName;       // STORE_NAME
	    private String userId;          // USER_ID
	    private String businessNo;      // BUSINESS_NO
	    private String storeIntro;      // STORE_INTRO
	    private String deliveryYn;      // DELIVERY_YN
	    private String isChatEnabled;   // IS_CHAT_ENABLED
	    private Date chatStart;         // CHAT_START
	    private Date chatEnd;           // CHAT_END
	    private String storeAddr;       // STORE_ADDR
	    private Integer storeArea;      // STORE_AREA
	    private String storePass;       // STORE_PASS
	    private String rejectReason;    // REJECT_REASON
	    private String gradeCode;       // GRADE_CODE
	    private String membership;      // MEMBERSHIP
	    private Date regDate;           // REG_DATE
	    private Date udate;             // UDATE
	    private String orderId;
	    private String chatYN;
	    
	    private String orderMonth;    // YYYY-MM 형식, ORDER_TBL 기준
	    private Integer orderCount;   // 월별 주문 건수
	    private Integer totalSales;   // 월별 총 매출
	 // 상품 정보
	 		private int proNo;
	 		private String proName;
	 		
	 		private String proInfo;
	 		private int price; 
	 		private int deliveryFee;	
	 		private int cnt;
	 		private int sellCount;
	 		private String createdAt; // 상품등록일 
	 		private String lettering;
	 		
	 	
	 		
	 		// 상위옵션
	 		
	 		private String optionName;
	 		private String isQuantitySelectable = "N";
	 		
	 		// 하위옵션
	 		
	 		private String valueName;
	 		private int priceDiff;
	 		
	 		//장바구니
	 		private int cartId;
	 		private int defPrice;
	 		private String topOpt;
	 		private String subOpt;
	 		private int qptQtt;
	 		private int subOptPrice;
	 		
	 		//채팅
	 

	 	    
	 	   private Long msgId;
	 	    private Long chatId;
	 	 
	 	    private String message;      // DB CLOB -> String
	 	    private String messageType;
	 	    private LocalDateTime sentAt;
	 	    private String isRead;
	 	    private String senderId;     // 발신자 구분용
	 	    private String filePath;     // 이미지 경로
	 	    
	 	   private Long questionId;        // 1. 질문 고유 ID (QUESTION_ID) - PK
	 	  
	 	   
	 	  private String questionContent; // 4. 질문내용 (QUESTION_CONTENT)
	 	  private String questionDate;    // 5. 작성일 (QUESTION_DATE) - TO_CHAR로 받기 위해 String 사용
	 	 
	 	  private String answerContent;   // 7. 답변내용 (ANSWER_CONTENT)
	 	  private String answerDate;      // 8. 답변일 (ANSWER_DATE) - TO_CHAR로 받기 위해 String 사용
	 	  
	 	  
	 	// 1. PRODUCT_TBL (디저트 상품) 매핑
	 	  
	 	   
	 	   
	 	    // (추가) ServiceImpl에서 임시로 사용할 판매자 번호
	 	    private Integer sellerNo;
	 	    
	 	    // 2. 픽업/배송 불가 날짜 처리 (TBL_DISABLED_DATE 매핑에 사용)
	 	    private String disabledDatesStr;     // 클라이언트로부터 받은 콤마로 구분된 문자열
	 	    private List<String> disabledDates;  // 파싱 후 사용할 날짜 리스트

	 	    // 3. 옵션 데이터 (JSON 파싱 후 저장)
	 	    // Controller에서 JSON을 파싱하여 이 리스트에 담아 Service로 전달합니다.
	 	    private List<Seller> options;
	 	    
	 	  
	 	    
	 	   
	 	     // 수량 정할수있는지 여부
	 	    
	 	    // 클라이언트에서 넘어오는 임시 ID (새 옵션 구분을 위해)
	 	    private String id; 

	 
	 	    
	 	// ⭐⭐⭐ 이 필드가 누락되어 Controller에서 getOptionsJson() 오류가 발생했습니다. ⭐⭐⭐
	 		private String optionsJson; // 클라이언트에서 옵션 정보를 JSON 문자열로 받기 위한 필드
	 		
	 		// 2. 픽업/배송 불가 날짜 처리 (TBL_DISABLED_DATE 매핑에 사용)
	 		
	
	 	
	 		
	 		
	 	 	
	 	 	// PRODUCT_SUB_OPTION_TBL (하위 옵션 목록)
	 		private List<Seller> subOptions;
			private String status = "N";
	 		
	 		public String getStoreId() {
	 	        return storeId;
	 	    }

	 	    public void setStoreId(String storeId) { // ⭐ 이 메서드를 추가해야 오류가 해결됩니다.
	 	        this.storeId = storeId;
	 	    }
	 	   public String getStatus() {
	 		    return status;
	 		}

	 		public void setStatus(String status) {
	 		    this.status = status;
	 		}
	 	
	 		private String proType = "케이크"; 

	 	    // ... (deliveryFee, proInfo, status 등 다른 필드 선언 및 초기화)
	 	    
	 	    // ... (Getter와 Setter 메서드)
	 	    public String getProType() {
	 	        return proType;
	 	    }

	 	    public void setProType(String proType) {
	 	        this.proType = proType;
	 	    }
	 	// 옵션 수량 선택 가능 여부 필드 추가
	 	    private String isQuantitySelectAble; 

	 	    // 필드에 대한 Getter 추가
	 	    public String getIsQuantitySelectAble() {
	 	        return isQuantitySelectAble;
	 	    }

	 	    // 필드에 대한 Setter 추가 (필요한 경우)
	 	    public void setIsQuantitySelectAble(String isQuantitySelectAble) {
	 	        this.isQuantitySelectAble = isQuantitySelectAble;
	 	    }
	 	    
	 	    
	 	  
	 	  
	
	 	 
	 	    // Getter/Setter 및 생성자 등
	 	    public String getIsQuantitySelectable() { // Getter가 반드시 존재해야 합니다.
	 	        return isQuantitySelectable;
	 	    }
	 	    
	 	
	 	// 이 메서드를 클래스 내부에 명시적으로 추가합니다.
	 	    public void setSubOptionId(int subOptionId) {
	 	        this.subOptionId = subOptionId;
	 	    }

	 	    // (Getter도 필요하다면 추가)
	 	    public int getSubOptionId() {
	 	        return subOptionId;
	 	    }
	 	    
	 	
	 
	 	    
	 	
	 	    
	 	  
	 	   
}


