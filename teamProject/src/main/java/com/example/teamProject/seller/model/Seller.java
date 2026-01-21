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
	private String storeName; // STORE_NAME
	private String userId; // USER_ID
	private String businessNo; // BUSINESS_NO
	private String storeIntro; // STORE_INTRO
	private String deliveryYn; // DELIVERY_YN
	private String isChatEnabled; // IS_CHAT_ENABLED
	private Date chatStart; // CHAT_START
	private Date chatEnd; // CHAT_END
	private String storeAddr; // STORE_ADDR
	private Integer storeArea; // STORE_AREA
	private String storePass; // STORE_PASS
	private String rejectReason; // REJECT_REASON
	private String gradeCode; // GRADE_CODE
	private String membership; // MEMBERSHIP
	private Date regDate; // REG_DATE
	private Date udate; // UDATE
	private String orderId;
	private String chatYN;
	
	
	private int sellerImgNum;
	private String fileuse;
	private String filename;
	private String fileorgname;
	private String fileetc;

	private String orderMonth; // YYYY-MM 형식, ORDER_TBL 기준
	private Integer orderCount; // 월별 주문 건수
	private Integer totalSales; // 월별 총 매출
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
	private String isQuantitySelectAble = "N";

	// 하위옵션

	private String valueName;
	private int priceDiff;

	// 장바구니
	private int cartId;
	private int defPrice;
	private String topOpt;
	private String subOpt;
	private int qptQtt;
	private int subOptPrice;

	// 채팅

	private Long msgId;
	private Long chatId;

	private String message; // DB CLOB -> String
	private String messageType;
	private LocalDateTime sentAt;
	private String isRead;
	private String senderId; // 발신자 구분용
	private String filePath; // 이미지 경로

	private Long questionId; // 1. 질문 고유 ID (QUESTION_ID) - PK

	private String questionContent; // 4. 질문내용 (QUESTION_CONTENT)
	private String questionDate; // 5. 작성일 (QUESTION_DATE) - TO_CHAR로 받기 위해 String 사용

	private String answerContent; // 7. 답변내용 (ANSWER_CONTENT)
	private String answerDate; // 8. 답변일 (ANSWER_DATE) - TO_CHAR로 받기 위해 String 사용

	// 1. PRODUCT_TBL (디저트 상품) 매핑

	// (추가) ServiceImpl에서 임시로 사용할 판매자 번호
	private Integer sellerNo;

	// 2. 픽업/배송 불가 날짜 처리 (TBL_DISABLED_DATE 매핑에 사용)
	private String disabledDatesStr; // 클라이언트로부터 받은 콤마로 구분된 문자열
	private List<String> disabledDates; // 파싱 후 사용할 날짜 리스트

	// 3. 옵션 데이터 (JSON 파싱 후 저장)
	// Controller에서 JSON을 파싱하여 이 리스트에 담아 Service로 전달합니다.
	private List<Seller> options;

	// 수량 정할수있는지 여부

	// 클라이언트에서 넘어오는 임시 ID (새 옵션 구분을 위해)
	private String id;
//
	private String optionsJson;
//
	private List<Seller> subOptions;
	private String status = "N";

	private String proType = "케이크";
	
	 private Integer optNo;           // 추가


	 public Integer getOptNo() {
	        return optNo;
	    }
	 
	 public void setOptNo(Integer optNo) {
	        this.optNo = optNo;
	    }
	 
	 public Integer getTopOptionId() {
	        return topOptionId;
	    }
	 public void setTopOptionId(Integer topOptionId) {
	        this.topOptionId = topOptionId;
	    }
	
}
