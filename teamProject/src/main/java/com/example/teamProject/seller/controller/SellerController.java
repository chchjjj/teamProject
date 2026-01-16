package com.example.teamProject.seller.controller;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
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

import jakarta.servlet.http.HttpSession;

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

	@RequestMapping("/seller/productinfo.do")
	public String productinfo(Model model) throws Exception {

		return "seller/productinfo";
	}

	@RequestMapping("/seller/productUpdate.do")
	public String productUpdate(@RequestParam(value = "proNo", required = false) Integer proNo, HttpSession session,
			Model model) {

		Map<String, Object> product = new HashMap<>();
		List<Map<String, Object>> options = new ArrayList<>();
		String disabledDatesStr = "";

		if (proNo != null) {
			// 상품 정보 조회
			product = sellerService.getProduct(proNo);

			// 옵션 정보 조회
			options = sellerService.getOptionsByProduct(proNo);

			// 불가 날짜 문자열
			disabledDatesStr = String.join(",", sellerService.getDisabledDates(proNo));
		}

		model.addAttribute("pageTitle", proNo == null ? "제품 등록" : "제품 수정");
		model.addAttribute("proNo", proNo);
		model.addAttribute("sessionId", session.getAttribute("userId"));

		// Map과 List<Map> 그대로 JSON으로 변환
		model.addAttribute("productJson", new Gson().toJson(product));
		model.addAttribute("optionsJson", new Gson().toJson(options));
		model.addAttribute("disabledDatesStr", disabledDatesStr);

		return "/seller/productUpdate";
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

	@RequestMapping("/seller/sellerViewQnA.do")
	public String QnA(Model model) throws Exception {

		return "/seller/sellerViewQnA";
	}

	@RequestMapping("/seller/productAdd.do")
	public String productAdd(@RequestParam("storeId") int storeId, Model model) {
		// storeId (45)를 받아 다음 로직을 처리합니다.
		model.addAttribute("storeId", storeId);

		return "/seller/productAdd";
	}

	@RequestMapping(value = "/seller/productlist.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String productList(HttpSession session, Model model,
			@RequestParam(value = "storeId", required = false) String paramStoreId) throws Exception {
		String finalStoreId = paramStoreId;

		if (finalStoreId == null || finalStoreId.isEmpty()) {
			// 세션에서 가져옵니다.
			finalStoreId = (String) session.getAttribute("storeId");
		}

		// 2. 최종 storeId를 Model에 담습니다.
		model.addAttribute("storeId", finalStoreId);

		return "/seller/sellerProductList";
	}

	@RequestMapping("/seller/storeInfoupdateInfo.do")
	public String storeUpdate(Model model) throws Exception {

		return "/seller/storeUpdateInfo";
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
			// 1. XML의 parameterType="HashMap"에 맞게 맵 생성
			HashMap<String, Object> map = new HashMap<>();
			map.put("orderId", orderId);
			map.put("userId", readerId); // XML에서 #{userId}라고 썼으므로 키값을 "userId"로 맞춰야 함!

			// 2. 서비스 호출 시 맵을 전달
			sellerService.updateMessageReadStatus(map);

			System.out.println("RESPONSE: [ChatController] 메시지 읽음 처리 성공.");
			return new ResponseEntity<>("Messages marked as read.", HttpStatus.OK);

		} catch (Exception e) {
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

	@RequestMapping(value = "/store/update.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateStoreInfo(@RequestParam Map<String, String> params,
			@RequestParam(value = "storeProfileImg", required = false) MultipartFile storeProfileImg,
			@RequestParam(value = "storeBannerImg", required = false) MultipartFile storeBannerImg) {

		Map<String, Object> result = new HashMap<>();

		try {
			// ===============================
			// 1. 파라미터 추출
			// ===============================
			String userId = params.get("userId");
			String storeId = params.get("storeId");
			String storeName = params.get("storeName");
			String storeAddr = params.get("storeAddrMain"); // DB 컬럼: STORE_ADDR
			String storeIntro = params.get("storeIntro");
			String deliveryYn = params.get("deliveryYn");
			String chatYn = params.get("chatYn"); // DB 컬럼: IS_CHAT_ENABLED

			// ===============================
			// 2. 필수 값 검증
			// ===============================
			if (userId == null || userId.isEmpty() || storeId == null || storeId.isEmpty()) {

				result.put("result", "failure");
				result.put("message", "필수 정보(사용자 ID 또는 가게 ID)가 누락되었습니다.");
				return result;
			}

			// ===============================
			// 3. MyBatis 전달용 Map 생성
			// ===============================
			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("storeId", Integer.parseInt(storeId)); // NUMBER
			paramMap.put("userId", userId);
			paramMap.put("storeName", storeName != null ? storeName : "");
			paramMap.put("storeAddr", storeAddr != null ? storeAddr : "");
			paramMap.put("storeIntro", storeIntro != null ? storeIntro : "");
			paramMap.put("deliveryYn", deliveryYn != null ? deliveryYn : "N");
			paramMap.put("isChatEnabled", chatYn != null ? chatYn : "N");

			// ===============================
			// 4. 이미지 저장 처리
			// ===============================
			String uploadDir = "C:/img-product/";
			Files.createDirectories(Paths.get(uploadDir));

			// ▶ 가게 프로필 이미지
			if (storeProfileImg != null && !storeProfileImg.isEmpty()) {

				String orgName = storeProfileImg.getOriginalFilename();
				String saveName = System.currentTimeMillis() + "_" + orgName;

				File file = new File(uploadDir + saveName);
				storeProfileImg.transferTo(file);

				paramMap.put("profileFileName", saveName); // Service 조건용
				paramMap.put("filePath", "/img-product/");
				paramMap.put("fileName", saveName);
				paramMap.put("fileOrgName", orgName);
				paramMap.put("fileEtc", "image");
			}

			// ▶ 가게 배너 이미지
			if (storeBannerImg != null && !storeBannerImg.isEmpty()) {

				String orgName = storeBannerImg.getOriginalFilename();
				String saveName = System.currentTimeMillis() + "_" + orgName;

				File file = new File(uploadDir + saveName);
				storeBannerImg.transferTo(file);

				paramMap.put("bannerFileName", saveName);
				paramMap.put("filePath", "/img-product/");
				paramMap.put("fileName", saveName);
				paramMap.put("fileOrgName", orgName);
				paramMap.put("fileEtc", "image");
			}

			// ===============================
			// 5. 서비스 호출
			// ===============================
			boolean isUpdated = sellerService.updateStoreInfo(paramMap);

			if (isUpdated) {
				result.put("result", "success");
			} else {
				result.put("result", "failure");
				result.put("message", "정보 수정에 실패했습니다. (가게 ID 및 사용자 ID 확인 필요)");
			}

		} catch (NumberFormatException e) {
			e.printStackTrace();
			result.put("result", "failure");
			result.put("message", "STORE_ID는 숫자여야 합니다.");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failure");
			result.put("message", "서버 오류가 발생했습니다. 로그를 확인하세요.");
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

	@RequestMapping(value = "/seller/product/register.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registerProduct(Seller seller, // 상품 정보를 담은 Seller DTO (proName, price, deliveryFee,
																// proType, lettering 등)
			@RequestParam("thumbnailFile") MultipartFile thumbnailFile,
			@RequestParam(value = "thumbnailUse", required = false) String thumbnailUse,
			@RequestParam(value = "detailFiles", required = false) List<MultipartFile> detailFiles,
			@RequestParam(value = "longFile", required = false) MultipartFile longFile,
			@RequestParam("storeId") int receivedStoreId, // 클라이언트가 전송한 Store ID (int로 받음)
			@RequestParam("optionsJson") String optionsJson, @RequestParam("disabledDatesStr") String disabledDatesStr,
			HttpSession session // jakarta.servlet.http.HttpSession 사용
	) {
		Map<String, Object> result = new HashMap<>();

		// 🌟 1. 세션 USER_ID 유효성 검증
		String loggedInUserId = (String) session.getAttribute("sessionId");

		if (loggedInUserId == null || loggedInUserId.trim().isEmpty()) {
			System.out.println(">>> [FATAL] 세션 userId 유효성 최종 검증 실패: " + loggedInUserId);
			result.put("success", false);
			result.put("message", "세션 로그인 정보(userId)를 찾을 수 없습니다. (재로그인 필요)");
			return result;
		}

		// 2. DTO에 userId 설정
		seller.setUserId(loggedInUserId);

		// 💡 3. 핵심 보안 검증: userId와 storeId의 소유권 일치 여부 확인
		try {
			// [필수 가정]: sellerService.checkStoreOwnership(userId, storeId)가 1(소유) 또는 0(미소유)을
			// 반환한다고 가정
			// ORA-01722 오류 방지 및 소유권 검증을 동시에 수행하는 새로운 메소드를 호출합니다.
			int isOwner = sellerService.checkStoreOwnership(loggedInUserId, receivedStoreId);

			if (isOwner != 1) { // 소유권이 없거나, userId와 storeId 쌍이 매핑되지 않으면
				result.put("success", false);
				result.put("message", "전달된 상점 ID(" + receivedStoreId + ")에 대한 접근 권한이 없습니다. (보안 오류)");
				return result;
			}

			// 4. 검증 통과: DTO에 최종 storeId 설정 (DB 타입이 String인 경우를 대비하여 String으로 변환)
			seller.setStoreId(String.valueOf(receivedStoreId));
			seller.setOptionsJson(optionsJson);
			seller.setDisabledDatesStr(disabledDatesStr);
			System.out.println("옵션 JSON: " + optionsJson.substring(0, Math.min(optionsJson.length(), 100)) + "...");
			System.out.println("불가 날짜: " + disabledDatesStr);
			// 5. 상품 데이터 유효성 검사 및 설정
			processProductData(seller);

			if (seller.getProName() == null || seller.getProName().isEmpty()) {
				result.put("success", false);
				result.put("message", "상품 이름은 필수입니다.");
				return result;
			}

			// 6. DB 등록
			sellerService.registerProduct(seller); // 이 메소드는 상품 정보와 함께 proNo를 업데이트합니다.

			// 7. 파일 업로드
			fileService.uploadProductImages(seller.getProNo(), thumbnailFile, thumbnailUse, detailFiles, longFile);

			result.put("success", true);
			result.put("message", "제품 등록 성공");

		} catch (Exception e) {
			e.printStackTrace();

			String errorMessage = "제품 등록 중 서버 오류 발생: " + e.getMessage();
			if (e.getMessage() != null && e.getMessage().contains("checkStoreOwnership")) {
				errorMessage = "판매자 정보(STORE ID) 조회 오류 또는 유효성 검증 실패. 관리자에게 문의하세요.";
			}

			result.put("success", false);
			result.put("message", errorMessage);
		}
		return result;
	}

	@RequestMapping(value = "/seller/product/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String DeleteSellerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String json = map.get("disabledDates").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {
		});
		map.put("dateList", list);

		String json2 = map.get("options").toString();
		ObjectMapper mapper2 = new ObjectMapper();
		List<HashMap<String, Object>> options = mapper2.readValue(json2,
				new TypeReference<List<HashMap<String, Object>>>() {
				});
		map.put("optionList", options);

		System.out.println(map);
		resultMap = sellerService.productUpdate(map);
		return new Gson().toJson(resultMap);

	}

	@PostMapping(value = "/member/update.dox", consumes = "application/json")
	@ResponseBody
	public Map<String, Object> updateMember(@RequestBody Map<String, Object> memberInfoMap) {

		Map<String, Object> response = new HashMap<>();

		try {
			// 1. Service 호출
			int result = sellerService.updateMemberInfo(memberInfoMap);

			if (result > 0) {
				response.put("status", "success");
				response.put("message", "회원 정보가 성공적으로 수정되었습니다.");
			} else {
				response.put("status", "fail");
				response.put("message", "수정 대상 회원을 찾을 수 없거나 수정에 실패했습니다.");
			}
		} catch (Exception e) {
			response.put("status", "error");
			response.put("message", "서버 오류: " + e.getMessage());
			// 실제 환경에서는 로그를 남기고 사용자에게 자세한 오류 메시지는 숨겨야 합니다.
		}

		return response; // JSON 응답
	}

//	@RequestMapping(value = "/seller/product/update.dox", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> updateProduct(
//	    Seller seller, // 상품 정보를 담은 Seller DTO
//	    
//	    @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile,
//	    @RequestParam(value = "thumbnailUse", required = false) String thumbnailUse, 
//	    @RequestParam(value = "detailFiles", required = false) List<MultipartFile> detailFiles,
//	    @RequestParam(value = "longFile", required = false) MultipartFile longFile,

//	    HttpSession session // jakarta.servlet.http.HttpSession 사용
//	) {
//	    Map<String, Object> result = new HashMap<>();
//	    
//	    // 1. 세션에서 로그인된 사용자 ID 확인
//	    String loggedInUserId = (String) session.getAttribute("sessionId");
//	    System.out.println("--- 상품 수정 요청 처리 시작 ---"); // 🚀 시작 로그
//	    System.out.println("1. 세션에서 확인된 로그인 ID: " + loggedInUserId);
//	    System.out.println("   클라이언트로부터 받은 Store ID: " + receivedStoreId);
//	    
//	    if (loggedInUserId == null || loggedInUserId.isEmpty()) {
//	        System.out.println("❌ 처리 실패: 세션 ID 없음. 로그인 필요.");
//	        result.put("success", false);
//	        result.put("message", "처리 실패: 세션에서 판매자 ID를 찾을 수 없습니다. 다시 로그인해 주십시오."); 
//	        return result;
//	    }
//	    
//	    // 2. DTO에 userId 설정
//	    seller.setUserId(loggedInUserId); 
//	    System.out.println("2. Seller DTO에 userId 설정 완료: " + loggedInUserId);
//	    
//	    try {
//	        // 3. 🌟 핵심 보안 검증: userId와 storeId의 소유권 일치 여부 확인
//	        // [필수 가정]: sellerService.checkStoreOwnership(userId, storeId)가 1(소유) 또는 0(미소유)을 반환한다고 가정
//	        
//	        // *******************************************************************
//	        // 가정된 checkStoreOwnership 호출 (실제 값을 가정하여 출력)
//	        int isOwner = 1; // 💡 검증 성공 가정
//	        // int isOwner = sellerService.checkStoreOwnership(loggedInUserId, receivedStoreId); 
//	        // *******************************************************************
//	        
//	        System.out.println("3. Store Ownership 검증 결과 (isOwner): " + isOwner);
//	        
//	        if (isOwner != 1) { // 소유권이 없거나, userId와 storeId 쌍이 매핑되지 않으면
//	            System.out.println("❌ 보안 오류: 로그인 사용자(" + loggedInUserId + ")는 Store ID(" + receivedStoreId + ")의 소유자가 아닙니다.");
//	            result.put("success", false);
//	            result.put("message", "전달된 상점 ID(" + receivedStoreId + ")에 대한 접근 권한이 없습니다. (보안 오류)");
//	            return result;
//	        }
//
//	        // 4. 검증 통과: DTO에 최종 storeId 설정
//	        seller.setStoreId(String.valueOf(receivedStoreId));
//	        System.out.println("4. 소유권 검증 통과. DTO에 storeId 설정: " + receivedStoreId);
//	        
//	        // 5. JSON 데이터 파싱 및 DTO 설정
//	        // 가정된 processProductData 호출 (실제 값을 가정하여 출력)
//	        // processProductData(seller); 
//	        
//	        
//	        System.out.println("5. 상품 데이터 처리 및 DTO 설정 완료. ProNo: " + seller.getProNo());
//
//	        if (seller.getProNo() == 0) {
//	            System.out.println("❌ 처리 실패: 제품 번호(ProNo)가 누락되었습니다.");
//	            result.put("success", false);
//	            result.put("message", "제품 번호가 누락되어 수정할 수 없습니다.");
//	            return result;
//	        }
//	        
//	        // 💡 제품 수정 시: 해당 제품이 정말 이 storeId 소유인지 추가 검증이 필요할 수 있습니다.
//	        // (예: sellerService.checkProductOwnership(seller.getProNo(), receivedStoreId))
//	        // *******************************************************************
//	        // 추가 보안 검증 지점 (필요 시)
//	        // int isProductOwner = sellerService.checkProductOwnership(seller.getProNo(), receivedStoreId);
//	        // if (isProductOwner != 1) { ... 접근 거부 처리 ... }
//	        // *******************************************************************
//
//	        // 6. 상품 DB 정보 수정 
//	        // sellerService.updateProduct(seller);
//	        System.out.println("6. sellerService.updateProduct(" + seller.getProNo() + ") 호출 (DB 수정)");
//	        
//	        // 7. 파일 수정/업로드 처리
//	        // fileService.updateProductImages(...)
//	        System.out.println("7. fileService.updateProductImages 호출 (파일 처리)");
//
//	        result.put("success", true);
//	        result.put("message", "제품 수정 성공");
//	        System.out.println("✅ 최종 성공 응답");
//
//	    } catch (Exception e) {
//	        System.out.println("⚠️ 예외 발생: " + e.getMessage());
//	        e.printStackTrace(); // 예외 스택 트레이스 출력
//	        result.put("success", false);
//	        result.put("message", "제품 수정 중 서버 오류 발생: " + e.getMessage());
//	    }
//	    System.out.println("--- 상품 수정 요청 처리 종료 ---"); // 🛑 종료 로그
//	    return result;
//	}

	@RequestMapping(value = "/seller/productDelete.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteProduct(@RequestParam("proNo") int proNo) {
		// Vue.js의 AJAX 요청에 응답할 JSON 형태의 Map 객체 생성
		Map<String, Object> response = new HashMap<>();

		try {
			// 1. Service 계층을 호출하여 상품 삭제 로직 실행
			// (Service 내에서 이미지, 옵션 등 FK 테이블 데이터를 먼저 삭제하고 메인 상품을 삭제해야 합니다.)
			int result = sellerService.deleteProduct(proNo);

			if (result > 0) {
				// 삭제 성공 (1개 이상의 행이 삭제됨)
				response.put("result", "success");
				response.put("message", proNo + "번 상품 삭제 성공");
			} else {
				// 삭제 실패 (삭제된 행이 0개, 예: 존재하지 않는 proNo 요청)
				response.put("result", "fail");
				response.put("message", proNo + "번 상품 삭제 실패: 상품 번호 불일치");
			}
		} catch (Exception e) {
			// DB 또는 트랜잭션 처리 중 오류 발생
			System.err.println("상품 삭제 서버 오류 (proNo: " + proNo + "): " + e.getMessage());
			response.put("result", "error");
			response.put("message", "서버 오류로 상품 삭제 실패");
		}

		return response;
	}

	@PostMapping("/store/infoUpdate.dox")
	@ResponseBody
	public Map<String, Object> getStoreInfoForUpdate(@RequestParam("storeId") int storeId) {
		Map<String, Object> resultMap = new HashMap<>();

		try {
			// 🟢 서비스 호출 (int 타입 storeId 사용)
			Map<String, Object> storeInfo = sellerService.selectStoreInfoData(storeId);

			if (storeInfo != null) {
				resultMap.put("store", storeInfo);
				resultMap.put("success", true);
				resultMap.put("message", "가게 정보 조회 성공");
			} else {
				resultMap.put("success", false);
				resultMap.put("message", "해당 STORE_ID로 등록된 가게 정보가 없습니다.");
			}
		} catch (Exception e) {
			System.err.println("가게 정보 조회 중 오류 발생: " + e.getMessage());
			resultMap.put("success", false);
			resultMap.put("message", "서버 오류로 인해 정보를 조회할 수 없습니다.");
		}

		return resultMap;
	}

	@RequestMapping(value = "/seller/insertProductAllergy.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String DeleteList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String json = map.get("ingreName").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {
		});
		map.put("list", list);
		System.out.println(map);
		resultMap = sellerService.insertProductAllergy(map);

		return new Gson().toJson(resultMap);

	}

//	@ResponseBody
//    @RequestMapping(value = "/seller/insertProductAllergy.dox", method = RequestMethod.POST)
//    public Map<String, Object> insertProductAllergy(
//        @RequestParam("proNo") int proNo, 
//        // 클라이언트에서 ingreId 배열을 보냈으므로 List<Integer>로 받고, 파라미터 이름에 '[]'를 명시합니다.
//        @RequestParam(value = "ingreId[]") List<Integer> ingreId
//    ) {
//        Map<String, Object> resultMap = new HashMap<>();
//
//        // 1. 유효성 검사 (상품 번호)
//        if (proNo <= 0) {
//            resultMap.put("result", "fail");
//            resultMap.put("message", "유효하지 않은 상품 번호입니다. (proNo: " + proNo + ")");
//            return resultMap;
//        }
//
//        // 2. 서비스로 데이터 전달 및 처리
//        try {
//            // 전달할 파라미터 Map 생성
//            Map<String, Object> param = new HashMap<>();
//            param.put("proNo", proNo);
//            param.put("ingreIdList", ingreId); // List<Integer> 형태로 전달
//
//            // 서비스 메서드 호출 (실제 DB 처리 로직은 서비스 계층에 구현되어야 합니다.)
//            // 이 메서드는 등록/갱신된 행의 개수를 반환한다고 가정합니다.
//            int result = sellerService.insertProductAllergy(param); 
//
//            if (result > 0) {
//                resultMap.put("result", "success");
//                resultMap.put("message", "상품 번호 " + proNo + "에 총 " + result + "개의 알레르기 정보가 성공적으로 등록되었습니다.");
//            } else {
//                resultMap.put("result", "fail");
//                resultMap.put("message", "등록된 알레르기 정보가 없거나 등록 처리 중 문제가 발생했습니다.");
//            }
//
//        } catch (Exception e) {
//            System.err.println("상품 알레르기 정보 등록 오류: " + e.getMessage());
//            resultMap.put("result", "fail");
//            resultMap.put("message", "서버 처리 중 예상치 못한 오류가 발생했습니다: " + e.getMessage());
//        }
//
//        return resultMap;
//    }
	// 메인페이지 알림 카운트 (메시지 + 새 주문)
	@RequestMapping("/seller/unreadCount.dox")
	@ResponseBody
	public HashMap<String, Object> getUnreadCount(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		// 안 읽은 전체 메시지 개수 가져오기
		int unreadCount = sellerService.getTotalUnreadCount(map);

		// 새 주문(오늘자 결제완료) 개수 가져오기
		int newOrderCount = sellerService.getNewOrderCount(map);

		resultMap.put("count", unreadCount); // 채팅 아이콘 옆 숫자

		resultMap.put("hasNewOrder", newOrderCount > 0);

		return resultMap;
	}

	@RequestMapping(value = "/seller/updateOrderStatus.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> updateOrderStatus(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			resultMap = sellerService.updateOrderStatus(map);
			System.out.println("LOG: [Controller] 주문 상태 변경 요청 처리 완료 - " + map);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("status", "error");
			resultMap.put("message", "상태 변경 중 서버 오류: " + e.getMessage());
		}

		// Map을 직접 반환 (Spring이 자동으로 JSON 변환)
		return resultMap;
	}
}