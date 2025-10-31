package com.example.teamProject.admin.model;

public class Admin {
	
	//user
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
	
	

	//seller
    private int storeId;
    private String storeName;
    private String businessNo;
    private String storeAddr;
    private String storePass;
    private String rejectReason;
    private String membership;
    private String regDate;
    
	
	
	//order
	//order_tbl
	private int orderId;
	private String fullAddress;
	private int addOptionPrice; 
	private String letteringWord;
	private double deliveryFee;
	private String orderDate;
	private double totalPrice;
	private String deliveryType;
	private String status;


	//order_detail_tbl
	private int orderDetailId;
	private int proNo;
	private String proName;
	private int quantity;
	private double price;
	private int subtotal;

	//order_option_tbl
	private int orderOptionId;
	private int topOptionId;
	private int subOptionId;
	private double priceDiff;
	private int addQuantity;
	
	
	
	//membership
	private int membershipId;
	private String membershipLevel;
	private String joinDate;
	private String membershipStatus;
	private int monthlyFee;
	private String expirationDate;
	private int count;
	
	
	//product
	// 상품 정보
	private String proInfo;	
	private int cnt;
	private int sellCount;
	private String createdAt; // 상품등록일 
	private String lettering;
	private String proType;
	
	// 판매자 채팅 가능여부 (Y/N)
	private String isChatEnabled;
	
	// 상위옵션
	private String optionName;
	private String isQuantitySelectAble;
	
	// 하위옵션
	private String valueName;
	
	
	
	// 판매자 정보 (QnA 관련)	
		
	private int questionId;
    private String questionContent;
    private String questionDate;
    private String answerContent;
    private String answerDate;

	
	
}
