package com.example.teamProject.product.model;

import lombok.Data;

@Data
public class Product {

		// 유저아이디
		private String userId;
		private String storeId;
		
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

		
}
