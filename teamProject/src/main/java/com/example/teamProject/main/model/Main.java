package com.example.teamProject.main.model;

public class Main {
	// Main 모델
	
	// 사용자 정보
	private String userId;
	private String userName;
	private String userAddr;
	
	// 상품 정보
	private int proNo;
	private String proName;
	private String storeName;
	private int price;
	private int deliveryFee;
	private int cnt;
	private int sellCount;
	private String createdAt; // 상품등록일 
	
	// 판매자 채팅 가능여부 (Y/N)
	private String isChatEnabled;
	
	// 판매자 정보 (QnA 관련)	
	private int storeId;
	private int questionId;
    private String questionContent;
    private String questionDate;
    private String answerContent;
    private String answerDate;
    private String storeAddr;
	
}
