package com.example.teamProject.product.model;

import lombok.Data;

@Data
public class Product {

		// 유저아이디
		private String userId;
		private String storeId;
		private String userName;
		private String userAddr;
		private String phone;
		
		// 스토어 정보
		private String storeIntro;
		private String chatStart;
		private String chatEnd;
		private String storeArea;
		
		// 상품 정보
		private int proNo;
		private String proName;
		private String storeName;
		private String proInfo;
		private int price; 
		private int deliveryFee;	
		private int cnt;
		private int sellCount;
		private String createdAt; // 상품등록일 
		private String lettering;
		private String deliveryYn;
		private String storeAddr;
		
		// 판매자 채팅 가능여부 (Y/N)
		private String isChatEnabled;
		
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
		private int cartQuantity;
		private int totalPrice;
		private String letteringText;
		
		private String wishAt;
		
		
		//장바구니 옵션
		private int cartOptQuantity;
		
		// 판매자 정보 (QnA 관련)	
		private int questionId;
	    private String questionContent;
	    private String questionDate;
	    private String answerContent;
	    private String answerDate;
	    
	    // 리뷰 관련
	    private int reviewId;
	    private int rating;
	    private String reviewContent;
	    private String cdatetime;
	    private String qnaContents;
	    
	    private int imgId;
	    private String imgPath;
	    // 주문서 관련
	    
	    private int orderDetailId; // 시퀀스 자동 생성
	    private int orderId;       // 주문 번호 (FK)
	    private String fullAddress; // 주소
	    private int addOptionPrice;
	    private String orderDate;
	    private int quantity;     // 주문 수량
	    private String deliveryType;
	    private String status;
	    private int subtotal;      // 상품 소계
	    private String letteringWord; // 레터링 문구
	    private String chatYn;
	    private int totalQuantity;
	    private int orderOptionId; // 시퀀스 자동 생성
	 
	    

	    private int addQuantity;  // 추가 옵션 수량
	    
	    
	 //  주문 관련 집계 필드
	    private int orderSubtotal;      // 상품들의 subtotal 합계
	    private int orderTotalPrice;    // 최종 주문 금액 (orderSubtotal + deliveryFee)
	    private int itemQty;            // 상품 개별 수량 (quantity와 동일하지만 명확성을 위해)
	    
	    //  옵션 관련
	    private int optionTotal;        // 단일 옵션의 총 가격 (priceDiff * addQuantity)
	    
	    //파일
	    private String filePath;   // 파일 경로
	    private String fileName;   // 파일 이름 
	    private String fileUse;    // 대표 여부 (T/F)
	    
	    private String disabledDate; // 배송 불가 날짜
	    
	    // 재료
	    private String ingredientName;
	    private String ingredientDescription;

}