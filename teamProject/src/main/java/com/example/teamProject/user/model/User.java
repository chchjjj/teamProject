package com.example.teamProject.user.model;

import lombok.Data;

@Data
public class User {

	private String userId;
	private String userPass;
	private String userName;
	private String email;
	private String userAddr;
	private String phone;
	private String role;
	private String userStatus;
	private String joinCdate;
	private String udate;
	
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
		
		
		//장바구니 옵션
		private int cartOptQuantity;
		
		// 판매자 정보 (QnA 관련)	
		private int questionId;
		private String storeId;
	    private String questionContent;
	    private String questionDate;
	    private String answerContent;
	    private String answerDate;
	    
	    // 리뷰 관련
	    private int reviewId;
	    private int imgId;
	    private int rating;
	    private String reviewContent;
	    private String imgPath;
	    private String cdatetime;
	    private String updatetime;
	    
	    // 주문서 관련
	    
	    private int orderDetailId; // 시퀀스 자동 생성
	    private int orderId;       // 주문 번호 (FK)
	    private String fullAddress; // 주소
	    private int addOptionPrice;
	    private String orderDate;
	    private int quantity;     // 주문 수량
	    private String deliveryType;
	    private String status;
	    private String letteringWord; // 레터링 문구
	    private String chatYn;
	    private int totalQuantity;
	    private int orderOptionId; // 시퀀스 자동 생성
	    private int subtotal;
	 
	    

	    private int addQuantity;  // 추가 옵션 수량
	    
	    private int optionTotal; //옵션 1종의 추가 금액
	    
	    
	    //채팅방에 바로가기
	    private int chatId;
	    
	    //배송
	    private String wishDeli;
	    private String deliveryStatus;
	    
	    //픽업
	    private String pickTime;
	    private String storeAddr;
	    
	    //review
//		    private String cDateTime;
	    
	    //chat
	    private String lastMsgAt;
	    private int unreadCount;
		    
}
