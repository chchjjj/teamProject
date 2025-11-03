package com.example.teamProject.product.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.main.model.Main;
import com.example.teamProject.product.mapper.ProductMapper;
import com.example.teamProject.product.model.Product;

@Service
public class ProductService {

	@Autowired
	ProductMapper ProductMapper;
	
	// 상품 상세정보
	public HashMap<String, Object> getProInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Product info = ProductMapper.proInfo(map);
		resultMap.put("info", info);
		return resultMap;
	}
	// 상품 상위옵션
	public HashMap<String, Object> getTopOptList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.topOptList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 상품 상위+하위 옵션
	public HashMap<String, Object> getAllOptList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.allOptList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 장바구니 리스트
	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.cart(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 장바구니 삭제
	@Transactional
	public HashMap<String, Object> deleteCart(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt1 = ProductMapper.deleteCartOpt(map);
		int cnt2 = ProductMapper.deleteCart(map);
		resultMap.put("result", "success");
		return resultMap;
		
	}
	
	//장바구니 추가
	@Transactional
	public HashMap<String, Object> insertCart(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		// 선택한 옵션의 내용을 담은 list
		List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) map.get("list");
		
		System.out.println(map);
		
		int cnt1 = ProductMapper.insertCart(map); // 장바구니 테이블 
		
		//장바구니 옵션 테이블 반복
		for(int i=0; i<list.size(); i++) {
			
			HashMap<String, Object> inputMap = list.get(i);
			inputMap.put("cartId", map.get("cartId"));
			System.out.println(i+1 + "번째 맵 ==> " + inputMap);
			ProductMapper.insertCartOpt(inputMap);
		}
		
		return resultMap;
		
	}
	//	위시리스트(찜)
	public HashMap<String, Object> checkWishlist(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    int count = ProductMapper.checkWishlist(map); // 해당 상품이 위시리스트에 있는지 확인
	    if (count > 0) {
	        resultMap.put("isWished", true);
	    } else {
	        resultMap.put("isWished", false);
	    }
	    resultMap.put("result", "success");
	    return resultMap;
	}
	// 위시리스트 (인서트)
	public HashMap<String, Object> WishlistInsert(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = ProductMapper.addWishlist(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	// 위시리스트 (딜리트)
	public HashMap<String, Object> WishlistDelete(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = ProductMapper.deleteWishlist(map);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	// 리뷰목록
	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.selectReviewList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 헤더 QnA 클릭 시 QnA 전체목록 불러오기 & 게시글 개수세기(페이징)
		public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();		
			try {
				List<Main> list = ProductMapper.selectQnaList(map); // QnA 전체목록
				int cnt = ProductMapper.selectQnaCnt(map); // QnA 게시글 개수
				resultMap.put("list", list); 
				resultMap.put("cnt", cnt);
				resultMap.put("result", "success");
			} catch (Exception e) {
				// TODO: handle exception
				resultMap.put("result", "fail");
				System.out.println(e.getMessage());
			}				
			return resultMap;
		}
		
	//주문서 (구매하기)
	
		@Transactional
		public HashMap<String, Object> insertOrder(HashMap<String, Object> map) {
				// TODO Auto-generated method stub
				HashMap<String, Object> resultMap = new HashMap<String, Object>();
				
				// 선택한 옵션의 내용을 담은 list
				List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) map.get("list");
				
				
				int cnt1 = ProductMapper.insertOrder(map); // 주문서 테이블에 인서트 
				int cnt2 = ProductMapper.insertOrderDt(map); // 주문서 디테일 테이블에 인서트
				System.out.println(map);   
				
				//주문서 옵션 테이블 반복
				for(int i=0; i<list.size(); i++) {
					
					HashMap<String, Object> inputMap = list.get(i);
					inputMap.put("orderDetailId", map.get("orderDetailId"));
					System.out.println(i+1 + "번째 맵 ==> " + inputMap);
					ProductMapper.insertOrderOpt(inputMap);
				}
				
				resultMap.put("result", "success");
				resultMap.put("orderId", map.get("orderId"));   // 여기 추가
			   
				return resultMap;
				
			}
}
