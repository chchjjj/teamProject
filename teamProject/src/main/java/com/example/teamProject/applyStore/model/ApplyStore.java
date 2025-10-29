package com.example.teamProject.applyStore.model;

import java.sql.Date;

import lombok.Data;

@Data
public class ApplyStore {

	// 가게 정보
    private int storeId;                // 가게 번호 (STORE_ID)
    private String storeName;           // 가게 이름 (STORE_NAME)
    private String userId;              // 소유자 유저 아이디 (USER_ID)
    private String businessNo;          // 사업자 번호 (BUSINESS_NO)
    private String storeIntro;          // 가게 소개 (STORE_INTRO)
    private String deliveryYn;          // 배송 가능 여부 (DELIVERY_YN)
    private String isChatEnabled;       // 채팅 가능 여부 (IS_CHAT_ENABLED)
    private Date chatStart;             // 채팅 시작 시간 (CHAT_START)
    private Date chatEnd;               // 채팅 종료 시간 (CHAT_END)
    private String storeAddr;           // 가게 주소 (STORE_ADDR)
    private int storeArea;              // 가게 지역 (STORE_AREA)
    private String storePass;           // 입점 승인 현황 (STORE_PASS)
    private String rejectReason;        // 입점 승인 거절 사유 (REJECT_REASON)
    private String gradeCode;           // 수수료 등급 코드 (GRADE_CODE)
    private String membership;          // 멤버십 가입 여부 (MEMBERSHIP)
    private Date regDate;               // 등록일자 (REG_DATE)
    private Date uDate;                 // 수정일자 (UDATE)

    // 이미지 정보 (SELLER_IMG_TBL)
    private String profileImagePath;    // 프로필 이미지 경로 (FILEPATH)
    private String profileImageName;    // 프로필 이미지 파일명 (FILENAME)
    private String profileImageOrgName; // 프로필 이미지 원본명 (FILEORGNAME)
    private String profileImageExt;     // 프로필 이미지 확장자 (FILEETC)

    private String bannerImagePath;     // 배너 이미지 경로 (FILEPATH)
    private String bannerImageName;     // 배너 이미지 파일명 (FILENAME)
    private String bannerImageOrgName; // 배너 이미지 원본명 (FILEORGNAME)
    private String bannerImageExt;      // 배너 이미지 확장자 (FILEETC)

}
