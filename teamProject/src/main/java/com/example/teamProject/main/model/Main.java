package com.example.teamProject.main.model;

import lombok.Data;

@Data
public class Main {
	// Main 모델
	
	// 사용자 정보
	private String userId;
	private String userName;
	private String userAddr;
	private String role;
	
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
	
	// 판매자 정보 (QnA, '내 주변 디저트' 관련)	
	private int storeId;
	private int questionId;
    private String questionContent;
    private String questionDate;
    private String answerContent;
    private String answerDate;
    private String storeAddr;
    private String businessNo; // 사업자번호임..
    private String membership;
    
    // 광고 관련
    private int adId;
    private int clickUnitCost;
    private String perMonth;
    
    // 알레르기 프리 관련
    private String ingredientName;
    private String  ingredientDescription;
    
    // 메인페이지 멤버쉽 판매자 상품 이미지 홍보사진
    private String filePath;
    private String fileName;
    
    private int ingredientId;
    
    // 멤버십 관련
    private int membershipId;
    private String membershipLevel;
    private String joinDate;
    private int monthlyFee;
    private String expirationDate;
    private int count;
    private String membershipStatus;
	
}
