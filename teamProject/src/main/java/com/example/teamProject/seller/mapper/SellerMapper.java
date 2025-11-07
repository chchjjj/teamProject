package com.example.teamProject.seller.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.seller.model.Seller;

@Mapper
public interface SellerMapper {

	

	// 가게 이름 수정
	int updateStoreNameMap(Map<String,Object> storeMap);

	// 가게 소개글 수정
	int updateStoreIntroMap(Map<String,Object> storeMap);


	// 채팅 가능 여부 및 시간 정보 수정
	int updateChatInfoMap(Map<String,Object> storeMap);
	//가게 정보 에서 가게 리스트 가져오는 
	List<Seller> selectStoreList(HashMap<String, Object> map);
	//월별 매월 가져오는 리스트
	List<HashMap<String, Object>> selectMonthlySales(HashMap<String, Object> map);
	
	//판매 내역 가져오는 리스트
	List<HashMap<String, Object>> selectOrderList(HashMap<String, Object> map);
	//주문 번호로 상세 보여주기
	List<HashMap<String, Object>> selectOrderDetail(HashMap<String, Object> map);
	
	
	
	
	//채탕창 이동허용 기능
	List<HashMap<String, Object>> selectChatPass(String orderId);
	
	
	
	
	//메세지 리스트 시간순
	List<Seller> selectChatHistoryByOrderId(Long orderId);
	//새메세지 저장
	void insertChatMessage(Seller message);
	//전송된 메세지 객체
	void updateChatRoomLastMessage(Seller message);
	//특정 채팅방의 모든 메시지를 읽음 처리 ('Y')
	void updateMessageReadStatus(Long orderId, String readerId);
	// 리뷰 리스트
	List<HashMap<String, Object>>  selectReviewList(HashMap<String, Object> param);
	
	// 가게 소개글 수정
	int updateOrderOptions(Map<String,Object> storeMap);
	//캘린더
	List<Map<String, Object>> selectPickupSchedule(Map<String, Object> paramMap);
	// 판매자 정보 조회
	HashMap<String, Object> selectSellerInfo(HashMap<String, Object> map);
	// 판매자 가게정보 조회
	HashMap<String, Object> selectStoreInfoByUserId(HashMap<String, Object> map);

	// 판매자 정보 수정
	int updateSellerInfo(HashMap<String, Object> map);
	
	// Q&A 조회
	List<HashMap<String, Object>> selectQnA(HashMap<String, Object> map);
	//Q&A 답글 업데이트
	void updateAnswerContent(Map<String, Object> params);
	//가게 정보 가져오기
	Map<String, Object> selectStoreInfo(String userId);
	//가게 정보 업데이트
	boolean updateStoreInfo(Map<String, String> params);
	
	
	//  제품 등록
    void registerProduct(Seller seller, MultipartFile thumbnailFile, List<MultipartFile> detailFiles, MultipartFile longFile) throws Exception;

    //  제품 수정
    void updateProduct(Seller seller, MultipartFile thumbnailFile, List<MultipartFile> detailFiles, MultipartFile longFile) throws Exception;
    
    //  제품 수정 데이터 로드 (다음 섹션)
    Map<String, Object> getProductDataForEdit(int proNo);
    
 // SellerMapper.java 파일 내에 추가할 내용

 	// 상품 기본 정보 등록 (proNo는 객체에 자동으로 담김)
 	void insertProduct(Seller seller);

 	// 상품 기본 정보 수정
 	void updateProduct(Seller seller);

 	// 상위 옵션 등록 (topOptionId는 객체에 자동으로 담김)
 	void insertTopOption(Seller topOpt);

 	// 하위 옵션 등록 (subOptionId는 객체에 자동으로 담김)
 	void insertSubOption(Seller subOpt);
 	
 	// 특정 상품의 모든 옵션 삭제
 	void deleteProductOptions(int proNo);

 	// 불가 날짜 등록
 	void insertDisabledDate(int proNo, String date);

 	// 특정 상품의 모든 불가 날짜 삭제
 	void deleteDisabledDates(int proNo);

 	// proNo를 통해 상품 기본 정보 조회 (수정용)
 	Seller selectProductByProNo(int proNo);
 	
 	// proNo를 통해 상품 파일 정보 조회 (수정용)
 	List<Map<String, Object>> selectProductFiles(int proNo);

 	// proNo를 통해 상품 옵션 정보 조회 (수정용)
 	List<Seller> selectProductOptions(int proNo);

 	// proNo를 통해 상품 불가 날짜 조회 (수정용)
 	List<String> selectDisabledDates(int proNo);
 	// 핵심 기능 지원: STORE_ID 조회 
 	Integer getStoreIdByUserId(String userId);
 	
 	//스토어 아이디를 이용해서 스토어 이름 얻기
 	String getStoreNameByStoreId(@Param("storeId") String storeId);
 	
 	// 판매자 상품정보정보 조회
 	
 	List<Seller> selectProductList(HashMap<String, Object> map);
 	//상품삭제
	int deleteProduct(int proNo);
 	
 

	
	
 	
 	
}
