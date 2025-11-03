package com.example.teamProject.seller.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.teamProject.seller.dao.SellerService;
import com.example.teamProject.seller.model.Seller;
import com.google.gson.Gson;



@Controller
public class SellerController {
	
	 @Autowired
	 SellerService sellerService;
	
	@RequestMapping("/seller/list.do") 
    public String area(Model model) throws Exception{

        return "/seller/addComplete";
    }
	
	@RequestMapping("/seller/storeList.do")
	public String storeListRedirect() throws Exception {
		 return "seller/sellerMyPage";
	}
	
	@RequestMapping("/seller/sales.do") 
    public String sales(Model model) throws Exception{

        return "seller/sellerMyPageSales";
    }
	
	@RequestMapping("/seller/salesHistory.do") 
    public String orderList(Model model) throws Exception{

        return "seller/sellerOrderHistory";
    }
	
	@RequestMapping("/seller/OrderHistoryViewDetails.do")
	public String view(@RequestParam(value="orderId", required=false) String orderId, Model model) {
	    if(orderId != null && !orderId.isEmpty()) {
	        model.addAttribute("orderId", orderId);
	    } else {
	        model.addAttribute("error", "주문 ID가 없습니다.");
	    }
	    return "seller/OrderHistoryViewDetails";
	}
	
	@RequestMapping("/seller/sellerChat.do") 
    public String chat(Model model) throws Exception{

        return "/seller/sellerChat";
    }
	
	
	@RequestMapping("/seller/sellerReview.do") 
    public String review(Model model) throws Exception{

        return "/seller/sellerReview";
    }
	
	
	@RequestMapping(value = "/seller/orderList.dox",  method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = sellerService.getOrderList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	
	

	@RequestMapping(value = "/store/list.dox",  method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> storeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    
	    // 1. 반환 타입이 Map<String, Object>로 변경되었습니다.
	    HashMap<String, Object> resultMap = sellerService.getStoreList(map);
	    
	    // 2. Gson을 사용한 JSON 변환 로직 제거
	    // return new Gson().toJson(resultMap); 
	    
	    // 3. Map 객체 자체를 반환하여 Spring의 Jackson이 JSON으로 안전하게 변환하도록 합니다.
	    return resultMap;
	}
	
	@RequestMapping(value = "/seller/sales.dox",  method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellesChart(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = sellerService.getSellesChart(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/seller/orderDetail.dox",  method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = sellerService.getOrderDetail(map);
		 
		
		return new Gson().toJson(resultMap);
	}
	

	@RequestMapping(value = "/seller/chat.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> Chat(@RequestParam HashMap<String, Object> map) throws Exception {
	    Map<String, Object> result = new HashMap<>();

	    // map에서 orderId 가져오기
	    Object orderIdObj = map.get("orderId");
	    if (orderIdObj == null) {
	        result.put("status", "fail");
	        result.put("message", "주문 ID가 없습니다.");
	        result.put("canChat", false);
	        return result;
	    }

	    String orderId = orderIdObj.toString();

	    // 서비스 호출
	    Map<String, Object> chatData = sellerService.getChat(orderId);

	    if (chatData != null && !chatData.isEmpty()) {
	        result.put("status", "success");
	        result.put("canChat", true); // 채팅 가능
	    } else {
	        result.put("status", "success");
	        result.put("canChat", false); // 채팅 불가
	    }

	    return result;
	}


	@GetMapping("/api/seller/chat/{orderId}/history")
    @ResponseBody
    public ResponseEntity<List<Seller>> getChatHistory(@PathVariable("orderId") Long orderId) {
        System.out.println("REQUEST: [ChatController] 채팅 기록 조회 요청 수신. Order ID: " + orderId);
        
        try {
            // SellerService의 메서드명을 ChatService와 동일하게 가정하고 호출
            List<Seller> history = sellerService.selectChatHistoryByOrderId(orderId); 
            System.out.println("RESPONSE: [ChatController] 채팅 기록 " + history.size() + "건 응답.");
            return new ResponseEntity<>(history, HttpStatus.OK);
            
        } catch (Exception e) {
            System.err.println("ERROR: [ChatController] 채팅 기록 조회 중 API 오류 발생.");
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); 
        }
    }

    /**
     * [새로운 메시지 전송]
     * POST /api/seller/chat/message
     */
    @PostMapping("/api/seller/chat/message")
    @ResponseBody
    public ResponseEntity<String> sendMessage(@RequestBody Seller message) {
        System.out.println("REQUEST: [ChatController] 새 메시지 전송 요청 수신. Order ID: " + message.getOrderId());
        
        if (message.getOrderId() == null) {
            return new ResponseEntity<>("Order ID is required.", HttpStatus.BAD_REQUEST);
        }

        try {
            // SellerService의 메서드명을 ChatService와 동일하게 가정하고 호출
            sellerService.sendMessage(message); 
            System.out.println("RESPONSE: [ChatController] 메시지 전송 및 DB 처리 성공.");
            return new ResponseEntity<>("Message sent successfully.", HttpStatus.CREATED);
            
        } catch (RuntimeException e) {
            System.err.println("ERROR: [ChatController] 메시지 전송 트랜잭션 오류 발생.");
            e.printStackTrace();
            return new ResponseEntity<>("Message transaction failed.", HttpStatus.INTERNAL_SERVER_ERROR);
            
        } catch (Exception e) {
            System.err.println("ERROR: [ChatController] 메시지 전송 처리 중 알 수 없는 오류 발생.");
            e.printStackTrace();
            return new ResponseEntity<>("An unexpected error occurred.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * [채팅 메시지 읽음 처리]
     * PATCH /api/seller/chat/{orderId}/read?readerId={readerId}
     */
    @PatchMapping("/api/seller/chat/{orderId}/read")
    @ResponseBody
    public ResponseEntity<String> markMessagesAsRead(
        @PathVariable("orderId") Long orderId,
        @RequestParam("readerId") String readerId) {
        
        System.out.println("REQUEST: [ChatController] 메시지 읽음 처리 요청 수신. Order ID: " + orderId + ", Reader ID: " + readerId);
        
        try {
            // SellerService의 메서드명을 ChatService와 동일하게 가정하고 호출
            sellerService.updateMessageReadStatus(orderId, readerId); 
            System.out.println("RESPONSE: [ChatController] 메시지 읽음 처리 성공.");
            return new ResponseEntity<>("Messages marked as read.", HttpStatus.OK);
            
        } catch (Exception e) {
            System.err.println("ERROR: [ChatController] 메시지 읽음 처리 중 API 오류 발생.");
            e.printStackTrace();
            return new ResponseEntity<>("Failed to mark messages as read.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
	
        
	
    }
    
    @RequestMapping(value = "/seller/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody 
    public Map<String, Object> reviewList(@RequestParam("userId") String userId) {
        
        Map<String, Object> resultMap = new HashMap<>();
        
        try {
         
            HashMap<String, Object> param = new HashMap<>();
            param.put("userId", userId);

            resultMap = sellerService.selectReviewList(param); 
            
            if (!resultMap.containsKey("result")) {
                 resultMap.put("result", "success");
            }
            
        } catch (Exception e) {
            System.err.println("리뷰 목록 조회 중 에러 발생: " + e.getMessage());
            resultMap.put("result", "error");
            resultMap.put("message", "서버 오류가 발생했습니다.");
            e.printStackTrace();
        }
        
        return resultMap; // Map 객체를 JSON으로 변환하여 Vue.js에 응답합니다.
    }
    
}
