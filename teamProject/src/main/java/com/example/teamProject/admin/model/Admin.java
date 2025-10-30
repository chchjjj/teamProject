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
	
	
	
}
