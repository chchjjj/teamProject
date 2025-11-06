package com.example.teamProject.payment.model;

import lombok.Data;

@Data
public class Payment {

	// 유저아이디
	private String userId;
	private String storeId;
	private String phone;

	// 상품 정보
	private int proNo;
	private String proName;
	private String storeName;
	private String proInfo;
	private int price;
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

	// order
	// order_tbl
	private int orderId;
	private String fullAddress;
	private int addOptionPrice;
	private String letteringWord;
	private int deliveryFee;
	private String orderDate;
	private double totalPrice;
	private String deliveryType;
	private String status;

	// order_detail_tbl
	private int orderDetailId;
	private int quantity;
	private int subtotal;

	// order_option_tbl
	private int orderOptionId;
	private int addQuantity;

	// 장바구니
	private int cartId;
	private int defPrice;
	private String topOpt;
	private String subOpt;
	private int qptQtt;
	private int subOptPrice;
	private int cartQuantity;

	// 장바구니 옵션
	private int cartOptQuantity;
	
	//USER_ADDRESS (배송지 테이블)
	private int addressId;
	private String cdateTimeAt;
	private String udateTimeAt;
}
