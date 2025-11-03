package com.example.teamProject.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.main.model.Main;
import com.example.teamProject.product.model.Product;

@Mapper
public interface ProductMapper {
	
	Product proInfo(HashMap<String, Object> map);
	
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
	
	// 찜 여부 확인
    int checkWishlist(HashMap<String, Object> map);

    // 찜 추가
    int addWishlist(HashMap<String, Object> map);

    // 찜 삭제
    int deleteWishlist(HashMap<String, Object> map);
    
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
}
