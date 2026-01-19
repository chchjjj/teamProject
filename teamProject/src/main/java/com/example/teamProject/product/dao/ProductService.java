package com.example.teamProject.product.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.main.model.Main;
import com.example.teamProject.product.mapper.ProductMapper;
import com.example.teamProject.product.model.Product;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ProductService {

	@Autowired
	ProductMapper ProductMapper;
	// 유저 상세정보
	public HashMap<String, Object> getUserInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Product info = ProductMapper.userInfo(map);
		resultMap.put("info", info);
		return resultMap;
	}
	// 멤버십 업데이트
	public HashMap<String, Object> insertMembership(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = ProductMapper.insertMembership(map);
		ProductMapper.updateMembership(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	//멤버십 해지
	public HashMap<String, Object> deleteMembership(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = ProductMapper.cancelMembership(map);
		System.out.println("멤버십해지");
		System.out.println(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	
	
	// 상품 상세정보
	public HashMap<String, Object> getProInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Product info = ProductMapper.proInfo(map);
		int cnt = ProductMapper.updateCnt(map);

		resultMap.put("info", info);
		return resultMap;
	}
	// 상품 상세사진
	public HashMap<String, Object> getProImg(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Product info = ProductMapper.proIMG(map);
		resultMap.put("info", info);
		return resultMap;
	}
	// 가게 정보
		public HashMap<String, Object> getStoreInfo(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			try {
				Product info = ProductMapper.sellerInfo(map);			
	
				resultMap.put("info", info); 
				resultMap.put("result", "success");
			} catch (Exception e) {
				// TODO: handle exception
				resultMap.put("result", "fail");
				System.out.println(e.getMessage());
			}				
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
	// 배송 불가날짜 가져오기
	public HashMap<String, Object> DateInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.disableDateinfo(map);			
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
			System.out.println(list);;
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
	// 장바구니 수량업뎃
	public HashMap<String, Object> updateCart(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt2 = ProductMapper.updateCartQ(map);
//		int cnt3 = ProductMapper.updateCartCnt(map);
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
	
	//내가 찜한 위시리스트
	public HashMap<String, Object> Wishlist(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Product> wishList = ProductMapper.Wishlist(map);
		resultMap.put("wishList", wishList);
		resultMap.put("result", "success");
		return resultMap;
	}
	// 상품과 알레르기 재료 연결
	public HashMap<String, Object> proingred(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Product> list = ProductMapper.proingred(map);
		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}
	// 큐앤에이 등록
	public HashMap<String, Object> qnaInsert(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = ProductMapper.insertQnA(map);
		
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
			System.out.println(map);
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
		
		//productDetail.jsp의 구매하기(바로 구매)
		
		@Transactional
	      public HashMap<String, Object> insertOrder(HashMap<String, Object> map) {
	            // TODO Auto-generated method stub
	            HashMap<String, Object> resultMap = new HashMap<String, Object>();
	            
	            // 선택한 옵션의 내용을 담은 list
	            List<HashMap<String, Object>> list = (List<HashMap<String, Object>>) map.get("list");
	            
	            
	            int cnt1 = ProductMapper.insertOrder(map); // 주문서 테이블에 인서트 
	            
//	            //배송, 픽업 테이블 insert (orderId 포함해서)
//	            String deliveryType = (String) map.get("deliveryType");
//	             if ("D".equals(deliveryType)) {
//	                 ProductMapper.insertDeliv(map);
//	                 
//	             } else if ("P".equals(deliveryType)) {
//	                 ProductMapper.insertPickUp(map);
//	                 
//	             }
	            
	            //1.19 수정 : 주문 현황이 제대로 뜨게 하기 위해서  xml에 원래 하드코딩을 파라미터로 변해서 배속/픽업 부분만 수정하겠습니다.
	            // 배송 타입에 따라 DELIVERY_TBL 또는 PICKUP_TBL에 INSERT
	            String deliveryType = (String) map.get("deliveryType");
	            
	            if ("D".equals(deliveryType)) {
	                // 배송 상태 기본값 설정 (없으면 'Z')
	                if (map.get("deliveryStatus") == null) {
	                    map.put("deliveryStatus", "Z");
	                }
	                ProductMapper.insertDeliv(map);
	                
	            } else if ("P".equals(deliveryType)) {
	                // 픽업 상태 기본값 설정 (없으면 'A')
	                if (map.get("pickupStatus") == null) {
	                    map.put("pickupStatus", "A");
	                }
	                ProductMapper.insertPickUp(map);
	            }
	            
	             String isChatRequested = (String) map.get("isChatRequested");
	             if ("Y".equals(isChatRequested)) {
	                 ProductMapper.insertChat(map);
	                 
	             }
	             
	            int cnt2 = ProductMapper.insertOrderDt(map); // 주문서 디테일 테이블에 인서트
	            
	            
	            
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
		
	//주문서 (구매하기)
	
		@Transactional
		public HashMap<String, Object> insertCartToOrder(HashMap<String, Object> map) {
		    HashMap<String, Object> resultMap = new HashMap<>();

		    // 장바구니에서 넘어온 상품 리스트 가져오기
		    List<HashMap<String, Object>> cartList = 
		        (List<HashMap<String, Object>>) map.get("cartList");
		    
		    System.out.println("맵=>" + map);
		    System.out.println("카트리스트=>" + cartList);
		    
		    // 주문할 상품이 없으면 실패 반환
		    if (cartList == null || cartList.isEmpty()) {
		        resultMap.put("result", "fail");
		        resultMap.put("message", "주문할 상품이 없습니다."); 
		        return resultMap;
		    }

		    // 생성된 주문 ID를 담을 리스트
		    List<Object> orderIdList = new ArrayList<>();
		   
		    // cartList는 이제 store별로 그룹화된 데이터
		    // 각 가게별로 주문서 생성
		    for (int i = 0; i < cartList.size(); i++) {
		        HashMap<String, Object> storeOrder = cartList.get(i);
		        
		        // 공통 데이터 추출 (store 레벨)
		        String userId = (String) storeOrder.get("userId");           // 구매자 ID
		        String storeId = (String) storeOrder.get("storeId");         // 가게 ID
		        String storeName = (String) storeOrder.get("storeName");     // 가게 이름
		        String letteringWord = (String) storeOrder.get("letteringWord"); // 레터링 문구
		        int deliveryFee = ((Number) storeOrder.get("deliveryFee")).intValue(); // 배송비
		        int orderTotalPrice = ((Number) storeOrder.get("orderTotalPrice")).intValue(); // 총 결제금액
		        int orderSubtotal = ((Number) storeOrder.get("orderSubtotal")).intValue(); // 상품 합계
		        String deliveryType = (String) storeOrder.get("deliveryType"); // 배송 방식 (D=배송, P=픽업)
		        
		        // ✅ 배송/픽업 상태 가져오기 (프론트에서 전달받음)
		        String deliveryStatus = (String) storeOrder.get("deliveryStatus");
		        
		        String chatYn = (String) storeOrder.get("chatYn");           // 채팅 신청 여부
		        String userName = (String) storeOrder.get("userName");       // 수령인 이름
		        String phone = (String) storeOrder.get("phone");             // 수령인 연락처
		        String fullAddress = (String) storeOrder.get("fullAddress"); // 배송 주소
		        String storeAddr = (String) storeOrder.get("storeAddr");     // 가게 주소 (픽업용)

		        // ORDER_TBL 인서트용 데이터 준비
		        HashMap<String, Object> orderMap = new HashMap<>();
		        orderMap.put("userId", userId);
		        orderMap.put("storeName", storeName);
		        orderMap.put("letteringWord", letteringWord);
		        orderMap.put("deliveryFee", deliveryFee);
		        orderMap.put("totalPrice", orderTotalPrice);  // 배송비 포함된 최종 금액
		        orderMap.put("deliveryType", deliveryType);
		        orderMap.put("chatYn", chatYn);
		        orderMap.put("userName", userName);
		        orderMap.put("phone", phone);
		        orderMap.put("useraddress", fullAddress);
		        orderMap.put("storeAddr", storeAddr);
		        
		        // ORDER_TBL 인서트 (주문서 생성)
		        ProductMapper.insertCartToOrder(orderMap);
		        
		        // 생성된 주문 ID 가져오기
		        Object orderId = orderMap.get("orderId");
		        orderIdList.add(orderId);

		        // 상품 목록 처리 (items 배열)
		        List<HashMap<String, Object>> items = 
		            (List<HashMap<String, Object>>) storeOrder.get("items");
		        
		        if (items != null && !items.isEmpty()) {
		            // 각 상품별로 처리
		            for (HashMap<String, Object> item : items) {
		                // ORDER_DETAIL_TBL 인서트 (주문 상세 정보)
		                HashMap<String, Object> detailMap = new HashMap<>();
		                detailMap.put("orderId", orderId);
		                detailMap.put("proNo", item.get("proNo"));           // 상품 번호
		                detailMap.put("storeId", item.get("storeId"));       // 가게 번호
		                detailMap.put("proName", item.get("proName"));       // 상품명
		                detailMap.put("itemQty", item.get("quantity"));      // 수량
		                detailMap.put("defPrice", item.get("price"));        // 상품 기본 가격
		                detailMap.put("subtotal", item.get("subtotal"));     // 소계
		                detailMap.put("letteringWord", item.get("letteringWord")); // 레터링 문구
		                
		                System.out.println("detailMap ==> " + detailMap);
		                ProductMapper.insertCartToOrderDt(detailMap);
		                
		                // 생성된 주문 상세 ID 가져오기
		                Object orderDetailId = detailMap.get("orderDetailId");

		                // ORDER_OPTION_TBL 인서트 (선택한 옵션들)
		                List<HashMap<String, Object>> options = 
		                    (List<HashMap<String, Object>>) item.get("options");
		                
		                if (options != null && !options.isEmpty()) {
		                    // 각 옵션별로 처리
		                    for (HashMap<String, Object> opt : options) {
		                        HashMap<String, Object> optMap = new HashMap<>();
		                        optMap.put("orderDetailId", orderDetailId);
		                        optMap.put("topOptionId", opt.get("topOptionId"));   // 상위 옵션 ID
		                        optMap.put("subOptionId", opt.get("subOptionId"));   // 하위 옵션 ID
		                        optMap.put("priceDiff", opt.get("priceDiff"));       // 옵션 추가 금액
		                        optMap.put("addQuantity", opt.get("addQuantity"));   // 옵션 수량
		                        
		                        ProductMapper.insertCartToOrderOpt(optMap);
		                    }
		                }
		            }
		        }
		        
		        // ✅ 배송/픽업 정보 인서트
		        HashMap<String, Object> deliveryMap = new HashMap<>();
		        deliveryMap.put("orderId", orderId);
		        deliveryMap.put("userId", userId);
		        deliveryMap.put("storeId", storeId);
		        deliveryMap.put("deliveryFee", deliveryFee);
		        deliveryMap.put("userName", userName);
		        deliveryMap.put("phone", phone);
		        deliveryMap.put("userAddr", fullAddress);
		        deliveryMap.put("storeAddr", storeAddr);

		        // 배송 타입에 따라 DELIVERY_TBL 또는 PICKUP_TBL에 인서트
		        if ("D".equals(deliveryType)) {
		            // ✅ 배송 주문: DELIVERY_TBL에 배송 상태 추가
		            // deliveryStatus가 없으면 기본값 'Z'(주문신청) 사용
		            deliveryMap.put("deliveryStatus", deliveryStatus != null ? deliveryStatus : "Z");
		            ProductMapper.insertDelivCart(deliveryMap);
		            
		        } else if ("P".equals(deliveryType)) {
		            // ✅ 픽업 주문: PICKUP_TBL에 픽업 상태 추가
		            // pickupStatus가 없으면 기본값 'A'(준비중) 사용
		            deliveryMap.put("pickupStatus", deliveryStatus != null ? deliveryStatus : "A");
		            ProductMapper.insertPickUpCart(deliveryMap);
		        }

		        // 채팅 선택 시 CHAT_TBL에 인서트
		        if ("Y".equals(chatYn)) {
		            ProductMapper.insertChat(deliveryMap);
		        }
		    }
		    
		    // 생성된 모든 주문 ID 리스트 반환
		    resultMap.put("orderIdList", orderIdList);
		    resultMap.put("result", "success");
		    
		    return resultMap;
		}
		
		
		
}
