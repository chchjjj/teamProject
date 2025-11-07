package com.example.teamProject.seller.controller;

import java.util.Arrays;
import java.util.Collections;
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
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.seller.dao.FileService;

import com.example.teamProject.seller.dao.SellerService;
import com.example.teamProject.seller.model.Seller;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class SellerController {

	@Autowired
	SellerService sellerService;

	@Autowired
	private ObjectMapper objectMapper;

	@Autowired
	FileService fileService; 
	
	
  

	@RequestMapping("/seller/list.do")
	public String area(Model model) throws Exception {

		return "/seller/addComplete";
	}

	@RequestMapping("/seller/storeList.do")
	public String storeListRedirect() throws Exception {
		return "seller/sellerMyPage";
	}

	@RequestMapping("/seller/sales.do")
	public String sales(Model model) throws Exception {

		return "seller/sellerMyPageSales";
	}

	@RequestMapping("/seller/salesHistory.do")
	public String orderList(Model model) throws Exception {

		return "seller/sellerOrderHistory";
	}

	@RequestMapping("/seller/OrderHistoryViewDetail.do")
	public String viewOrderHistory(
			// orderId가 필수(required=true)가 아니며, 기본값(defaultValue)을 설정하여 null 체크를 간소화합니다.
			@RequestParam(value = "orderId", required = false, defaultValue = "") String orderId, Model model) {

		// 만약 orderId가 비어있다면, 목록 페이지로 돌려보내는 것이 안전합니다.
		if (orderId.isEmpty()) {
			System.err.println("[ERROR] Order ID가 누락되어 상세 페이지 로드에 실패했습니다.");
			// 상세 페이지가 아닌, 판매 내역 목록 페이지로 리다이렉트하는 것이 자연스럽습니다.
			return "redirect:/seller/salesHistory.do";
		}

		model.addAttribute("orderId", orderId);
		// orderId가 정상적으로 있다면, OrderHistoryViewDetail.jsp로 이동합니다.
		return "seller/OrderHistoryViewDetail";
	}

	@RequestMapping("/seller/sellerChat.do")
	public String chat(Model model) throws Exception {

		return "/seller/sellerChat";
	}

	@RequestMapping("/seller/sellerReview.do")
	public String review(Model model) throws Exception {

		return "/seller/sellerReview";
	}

	@RequestMapping("/seller/order/addOption.do")
	public String addOption(Model model) throws Exception {

		return "/seller/orderOptionAdd";
	}

	@RequestMapping("/seller/order/calendarView.do")
	public String calendarView(Model model) throws Exception {

		return "/seller/calendarView";
	}

	@RequestMapping("/seller/userUpdateInfo.do")
	public String updateInfo(Model model) throws Exception {

		return "/seller/sellerUpdateInfo";
	}

	@RequestMapping("/seller/storeInfoupdateInfo.do")
	public String storeInfo(Model model) throws Exception {

		return "/seller/storeUpdateInfo";
	}

	@RequestMapping("/seller/sellerViewQnA.do")
	public String QnA(Model model) throws Exception {

		return "/seller/sellerViewQnA";
	}

	@RequestMapping("/seller/productAdd.do")
	public String addSellerProduct(Model model) throws Exception {

		return "/seller/productAdd";
	}
	
	@RequestMapping("/seller/productlist.do")
	public String productList(Model model) throws Exception {

		return "/seller/sellerProductList";
	}
	@RequestMapping("/seller/productUpdate.do")
	public String productUpdate(Model model) throws Exception {

		return "/seller/productUpdate";
	}
	

	
	

	

	@RequestMapping(value = "/seller/orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = sellerService.getOrderList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/store/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> storeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		// 1. 반환 타입이 Map<String, Object>로 변경되었습니다.
		HashMap<String, Object> resultMap = sellerService.getStoreList(map);

		// 3. Map 객체 자체를 반환하여 Spring의 Jackson이 JSON으로 안전하게 변환하도록 합니다.
		return resultMap;
	}
	
	@RequestMapping(value = "/seller/productlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> productList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		// 1. 반환 타입이 Map<String, Object>로 변경되었습니다.
		HashMap<String, Object> resultMap = sellerService.getProductList(map);

		// 3. Map 객체 자체를 반환하여 Spring의 Jackson이 JSON으로 안전하게 변환하도록 합니다.
		return resultMap;
	}

	@RequestMapping(value = "/seller/sales.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellesChart(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = sellerService.getSellesChart(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/seller/orderDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
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

	@PatchMapping("/api/seller/chat/{orderId}/read")
	@ResponseBody
	public ResponseEntity<String> markMessagesAsRead(@PathVariable("orderId") Long orderId,
			@RequestParam("readerId") String readerId) {

		System.out.println(
				"REQUEST: [ChatController] 메시지 읽음 처리 요청 수신. Order ID: " + orderId + ", Reader ID: " + readerId);

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

	@RequestMapping("/seller/optionAdd.dox")
	@ResponseBody
	public Map<String, Object> optionAdd(@RequestParam("orderId") String orderId,
			@RequestParam("addOptionPrice") int addOptionPrice,
			@RequestParam(value = "letteringWord", defaultValue = "문구없음") String letteringWord) {

		Map<String, Object> resultMap = new HashMap<>();
		Map<String, Object> paramMap = new HashMap<>();

		paramMap.put("orderId", orderId);
		paramMap.put("addOptionPrice", addOptionPrice);
		paramMap.put("letteringWord", letteringWord);

		try {
			boolean success = sellerService.addOrderOptions(paramMap);

			if (success) {
				resultMap.put("status", "success");
				resultMap.put("message", "옵션 정보가 성공적으로 업데이트되었습니다.");
			} else {
				resultMap.put("status", "fail");
				resultMap.put("message", "옵션 정보 업데이트에 실패했습니다. (DB 오류 또는 대상 없음)");
			}
		} catch (Exception e) {
			resultMap.put("status", "error");
			resultMap.put("message", "서버 처리 중 예외가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		}

		return resultMap;
	}

	@RequestMapping(value = "/seller/calendar.dox", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> getPickupSchedule(@RequestParam("userId") String userId,
			@RequestParam("start") String start, @RequestParam("end") String end) {

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("userId", userId);
		paramMap.put("start", start);
		paramMap.put("end", end);

		try {
			List<Map<String, Object>> pickupList = sellerService.selectPickupSchedule(paramMap);

			// 🔎 디버깅용 로그 — 데이터 구조 확인
			for (Map<String, Object> map : pickupList) {
				System.out.println(">>> ORDER_ID=" + map.get("ORDER_ID") + " / START=" + map.get("PICKUP_START_DATE")
						+ " / END=" + map.get("PICKUP_END_DATE"));
			}

			System.out.println("픽업 일정 조회 성공 (userId: " + userId + ", 건수: " + pickupList.size() + ")");
			return pickupList;
		} catch (Exception e) {
			System.err.println("픽업 일정 조회 실패 (userId: " + userId + ")");
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

	@RequestMapping(value = "/seller/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSellerInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {

			System.out.println("📥 [INFO] 요청 파라미터: " + map);

			resultMap = sellerService.getSellerInfo(map);

			System.out.println("📤 [INFO] 조회 결과: " + resultMap);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", "판매자 정보 조회 중 오류 발생: " + e.getMessage());
			System.out.println("❌ [ERROR] 판매자 정보 조회 실패: " + e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/store/storeinfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getStoreInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {

			System.out.println("📥 [INFO] 요청 파라미터: " + map);

			resultMap = sellerService.getStoreInfo(map);

			System.out.println("📤 [INFO] 조회 결과: " + resultMap);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", "판매자 정보 조회 중 오류 발생: " + e.getMessage());
			System.out.println("❌ [ERROR] 판매자 정보 조회 실패: " + e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	// ✅ 판매자 정보 수정
	@RequestMapping(value = "/seller/updateInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateSellerInfo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap = sellerService.updateSellerInfo(map);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", "판매자 정보 수정 중 오류 발생: " + e.getMessage());
		}
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/seller/qnaList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnAListByProNo(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			resultMap = sellerService.getQnAListByProNo(map);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
			resultMap.put("message", "QnA 목록 조회 중 오류 발생: " + e.getMessage());
		}

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/seller/qnaSesponse.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateAnswerContent(@RequestParam int questionId, // ⭐ proNo 대신 questionId를 받거나
			@RequestParam String answerContent) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// Service에 questionId를 넘기도록 수정
			resultMap = sellerService.updateAnswerContent(questionId, answerContent);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "error");
		}

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/store/info.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getStoreInfo(@RequestParam("userId") String userId) {
		Map<String, Object> result = new HashMap<>();
		try {
			// userId를 기반으로 가게 정보를 조회합니다.
			Map<String, Object> storeInfo = sellerService.getStoreInfo(userId);
			if (storeInfo != null) {
				result.put("store", storeInfo); // 조회된 가게 정보 전달
			} else {
				result.put("message", "가게 정보를 찾을 수 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("message", "서버 오류가 발생했습니다.");
		}
		return result;
	}

	@RequestMapping(value = "/store/update.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateStoreInfo(@RequestParam Map<String, String> params) {
		Map<String, Object> result = new HashMap<>();
		try {
			// 전달된 파라미터에서 수정할 가게 정보를 받습니다.
			String userId = params.get("userId");
			String storeName = params.get("storeName");
			String storeZipcode = params.get("storeZipcode");
			String storeAddrMain = params.get("storeAddrMain");
			String storeAddrDetail = params.get("storeAddrDetail");
			String storeIntro = params.get("storeIntro");
			String deliveryYn = params.get("deliveryYn");
			String chatYn = params.get("chatYn");

			// 서비스 메서드를 호출하여 DB에서 수정 작업을 수행
			boolean isUpdated = sellerService.updateStoreInfo(userId, storeName, storeZipcode, storeAddrMain,
					storeAddrDetail, storeIntro, deliveryYn, chatYn);
			if (isUpdated) {
				result.put("result", "success");
			} else {
				result.put("result", "failure");
				result.put("message", "정보 수정에 실패했습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failure");
			result.put("message", "서버 오류가 발생했습니다.");
		}
		return result;
	}

	@RequestMapping(value = "/seller/product/register.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registerProduct(
	    Seller seller, // 상품 정보를 담은 Seller DTO
	    @RequestParam("thumbnailFile") MultipartFile thumbnailFile,
	    @RequestParam(value = "detailFiles", required = false) List<MultipartFile> detailFiles,
	    @RequestParam(value = "longFile", required = false) MultipartFile longFile,
	    // 💡 세션 객체를 받아옵니다.
	    jakarta.servlet.http.HttpSession session 
	) {
	    Map<String, Object> result = new HashMap<>();

	    // 🌟 1. 세션 USER_ID 유효성 검증 (강화)
	    String loggedInUserId = (String) session.getAttribute("sessionId");
	    
	    // **수정 시작: null 또는 빈 문자열 체크 및 즉시 반환**
	    if (loggedInUserId == null || loggedInUserId.trim().isEmpty()) {
	        System.out.println(">>> [FATAL] 세션 userId 유효성 최종 검증 실패: " + loggedInUserId);
	        result.put("success", false);
	        result.put("message", "세션 로그인 정보(userId)를 찾을 수 없습니다. (재로그인 필요)");
	        return result; 
	    }
	    // **수정 끝**

	    seller.setUserId(loggedInUserId); 
	    
	    // 🌟 2. USER_ID로 STORE_ID 조회 및 설정
	    try {
	        // 1. Service를 통해 loggedInUserId에 해당하는 STORE_ID를 조회합니다.
	        // *Service 메서드의 반환 타입이 int라고 가정 (조회 실패 시 0 또는 null 처리)*
	        int storeId = sellerService.getStoreIdByUserId(loggedInUserId);
	        
	        // **수정 시작: STORE_ID가 0이거나 유효하지 않으면 예외 발생**
	        // DB에 USER_ID는 있지만 STORE_ID가 0으로 조회되면 잘못된 데이터입니다.
	        if (storeId == 0) {
	            System.out.println(">>> [Controller Log] " + loggedInUserId + "에 대한 STORE_ID가 0으로 조회됨.");
	            // Store ID 0 오류를 Service에서 던지게 하는 대신 Controller에서 처리하거나,
	            // Service에서 명시적 예외를 던지도록 코드를 유지합니다.
	            // 여기서는 Service의 예외가 Controller의 catch 블록으로 잡히도록 그대로 둡니다.
	            // **주의: Service의 getStoreIdByUserId는 유효한 ID를 못 찾으면 예외를 던지거나 0을 반환해야 합니다.**
	        }
	        // **수정 끝**
	        
	        // 2. 조회된 STORE_ID를 Seller DTO에 설정합니다. (int -> String 변환 유지)
	        seller.setStoreId(String.valueOf(storeId));
	        
	        
	        // 3. 상품 데이터 처리
	        processProductData(seller);

	        if (seller.getProName() == null || seller.getProName().isEmpty()) {
	            result.put("success", false);
	            result.put("message", "상품 이름은 필수입니다.");
	            return result;
	        }
	        
	        // seller DTO에는 이제 userId와 storeId가 모두 포함되어 있습니다.
	        sellerService.registerProduct(seller); 
	        
	        // 4. 파일 업로드
	        fileService.uploadProductImages(
	            seller.getProNo(), 
	            thumbnailFile, 
	            detailFiles, 
	            longFile
	        );

	        result.put("success", true);
	        result.put("message", "제품 등록 성공");

	    } catch (Exception e) {
	        // 상세한 오류 로그 출력
	        e.printStackTrace(); 
	        
	        // 🌟 3. 오류 메시지 개선: 사용자에게 친화적인 메시지 제공
	        String errorMessage = e.getMessage();
	        if (errorMessage != null && errorMessage.contains("Store ID 0")) {
	            errorMessage = "판매자 정보(STORE ID)를 찾을 수 없습니다. 관리자에게 문의하세요.";
	        }
	        
	        result.put("success", false);
	        result.put("message", "제품 등록 중 서버 오류 발생: " + errorMessage);
	    }
	    return result;
	}

	@RequestMapping(value = "/seller/product/update.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateProduct(
	    Seller seller, // 상품 정보를 담은 Seller DTO
	    @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile,
	    @RequestParam(value = "detailFiles", required = false) List<MultipartFile> detailFiles,
	    @RequestParam(value = "longFile", required = false) MultipartFile longFile,
	    jakarta.servlet.http.HttpSession session 
	) {
	    Map<String, Object> result = new HashMap<>();
	    
	    // 1. 세션에서 로그인된 사용자 ID 확인
	    String loggedInUserId = (String) session.getAttribute("sessionId");
	    System.out.println("DEBUG: 세션에서 가져온 loggedInUserId: " + loggedInUserId);
	    if (loggedInUserId == null || loggedInUserId.isEmpty()) {
	        result.put("success", false);
	        result.put("message", "처리 실패: 세션에서 판매자 ID를 찾을 수 없습니다. 다시 로그인해 주십시오."); 
	        return result;
	    }
	    
	    // 2. DTO에 userId 설정
	    seller.setUserId(loggedInUserId); 
	    
	    try {
	        // 3. 🌟 핵심: USER_ID로 STORE_ID 조회 및 설정
	        int storeId = sellerService.getStoreIdByUserId(loggedInUserId); 
	        seller.setStoreId(String.valueOf(storeId));
	        
	        // 4. 유효성 검사 (가게 정보가 없으면 수정 권한 없음)
	        if (storeId <= 0) {
	            result.put("success", false);
	            result.put("message", "판매자 정보가 유효하지 않습니다. 수정 권한이 없습니다.");
	            return result;
	        }

	        // 5. JSON 데이터 파싱 및 DTO 설정
	        processProductData(seller);

	        if (seller.getProNo() == 0) {
	            result.put("success", false);
	            result.put("message", "제품 번호가 누락되어 수정할 수 없습니다.");
	            return result;
	        }

	        // 6. 상품 DB 정보 수정 (DTO에는 이제 userId와 storeId가 모두 들어있습니다.)
	        sellerService.updateProduct(seller);
	        
	        // 7. 파일 수정/업로드 처리
	        fileService.updateProductImages(
	            seller.getProNo(), 
	            thumbnailFile, 
	            detailFiles, 
	            longFile
	        );

	        result.put("success", true);
	        result.put("message", "제품 수정 성공");

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("success", false);
	        result.put("message", "제품 수정 중 서버 오류 발생: " + e.getMessage());
	    }
	    return result;
	}

	private void processProductData(Seller seller) throws Exception {
		// 1. 옵션 JSON 파싱
		// ⭐ 이 메서드 호출이 컴파일되려면 Seller DTO에 getOptionsJson()가 있어야 합니다.
		String optionsJson = seller.getOptionsJson(); 
		if (optionsJson != null && !optionsJson.isEmpty()) {
			// NOTE: Seller DTO 내부에 List<Seller> options; 필드를 사용합니다.
			List<Seller> options = objectMapper.readValue(optionsJson, new TypeReference<List<Seller>>() {
			});
			seller.setOptions(options);
		}

		// 2. 불가 날짜 문자열 파싱
		// ⭐ 이 메서드 호출이 컴파일되려면 Seller DTO에 getDisabledDatesStr()가 있어야 합니다.
		String datesStr = seller.getDisabledDatesStr();
		if (datesStr != null && !datesStr.isEmpty()) {
			List<String> disabledDates = Arrays.asList(datesStr.split(","));
			seller.setDisabledDates(disabledDates);
		}
	}

}