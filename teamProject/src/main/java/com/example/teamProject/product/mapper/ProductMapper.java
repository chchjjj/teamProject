package com.example.teamProject.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.main.model.Main;
import com.example.teamProject.product.model.Product;

@Mapper
public interface ProductMapper {
	
	// 제품 상세정보
	Product proInfo(HashMap<String, Object> map);
	// 제품 상세정보 사진
	Product proIMG(HashMap<String, Object> map);
	// 유저 정보
	Product userInfo(HashMap<String, Object> map);
	
	// 조회수 증가
	int updateCnt(HashMap<String, Object> map);
	
	// 불가 날짜 가져오기
	List<Product> disableDateinfo(HashMap<String, Object> map);
	
	// 상위옵션
	List<Product> topOptList(HashMap<String, Object> map); 
	
	// 상위옵션+하위옵션
	List<Product> allOptList(HashMap<String, Object> map); 
	
	// 장바구니
	List<Product> cart(HashMap<String, Object> map);
	
	// 장바구니 삭제(1)
	int deleteCart(HashMap<String, Object> map);
	
	// 장바구니 삭제(2)
	int deleteCartOpt(HashMap<String, Object> map);
	
	// 장바구니 추가(장바구니 테이블)
	int insertCart(HashMap<String, Object> map);
	
	// 장바구니 추가(장바구니 옵션 테이블)
	int insertCartOpt(HashMap<String, Object> inputMap);
	
	// 장바구니 수량 업데이트
	int updateCartQ(HashMap<String, Object> inputMap);
	int updateCartCnt(HashMap<String, Object> inputMap);
	// 장바구니에서 구매
	// 장바구니에서 주문서로
	int insertCartToOrder(HashMap<String, Object> map);
	
	// 장바구니에서 주문서 디테일로
	int insertCartToOrderDt(HashMap<String, Object> map);
	
	// 장바구니에서 주문서 옵션으로
	int insertCartToOrderOpt(HashMap<String, Object> map);
	
	// 장바구니에서 배달테이블 인서트
	int insertDelivCart(HashMap<String, Object> map);

	// 장바구니에서 픽업테이블 인서트
	int insertPickUpCart(HashMap<String, Object> map);
	
	// 찜 여부 확인
    int checkWishlist(HashMap<String, Object> map);

    // 찜 추가
    int addWishlist(HashMap<String, Object> map);

    // 찜 삭제
    int deleteWishlist(HashMap<String, Object> map);
    
    // 내가 찜한 리스트
    List<Product> Wishlist(HashMap<String, Object> map);
    
    // 헤더 메뉴 중 QnA 접속 및 리스트
 	List<Main> selectQnaList(HashMap<String, Object> map);
 	
 	// QnA 게시글 전체 개수 구하기 (페이징 위해)
 	int selectQnaCnt(HashMap<String, Object> map);
 	
 	// 리뷰
 	List<Product> selectReviewList(HashMap<String, Object> map); 
 	
 	// 주문서
 	// 주문서 추가(주문서 테이블)
 	int insertOrder(HashMap<String, Object> map);
 	
 	// 주문서 추가(주문서 디테일 테이블)
 	int insertOrderDt(HashMap<String, Object> inputMap);
 	
 	// 주문서 추가(주문서 옵션 테이블)
 	int insertOrderOpt(HashMap<String, Object> inputMap);
 	
 	// 배달정보 추가
 	int insertDeliv(HashMap<String, Object> map);
 	
 	// 배달정보 추가
 	int insertPickUp(HashMap<String, Object> map);
 	
 	// 가게 정보 조회
 	Product sellerInfo(HashMap<String, Object> map);
 	
 	// 채팅방 개설
 	int insertChat(HashMap<String, Object> map);
 	
 	// 큐앤에이 등록
 	int insertQnA(HashMap<String, Object> map);
 	
 	// 재료와 상품 연결
 	List<Product> proingred(HashMap<String, Object> map);
 	
 	// 멤버십 업데이트
 	int insertMembership(HashMap<String, Object> map);
 	int updateMembership(HashMap<String, Object> map);
 	
 	// 멤버십 해지
 	int cancelMembership(HashMap<String, Object> map);
}
