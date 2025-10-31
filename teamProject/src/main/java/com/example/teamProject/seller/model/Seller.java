package com.example.teamProject.seller.model;

import java.sql.Date;

import lombok.Data;

@Data
public class Seller {

	  private Long storeId;           // STORE_ID
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
	 		private int topOptionId;
	 		private String optionName;
	 		private String isQuantitySelectAble;
	 		
	 		// 하위옵션
	 		private int subOptionId;
	 		private String valueName;
	 		private int priceDiff;
	 		
	 		//장바구니
	 		private int cartId;
	 		private int defPrice;
	 		private String topOpt;
	 		private String subOpt;
	 		private int qptQtt;
	 		private int subOptPrice;

}
