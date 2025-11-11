package com.example.teamProject.product.controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.product.dao.ProductService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ProductController {

	@Autowired
	ProductService ProductService;
	
	@RequestMapping("/productDetail.do") 
    public String productDetail(@RequestParam("proNo") int proNo, Model model) throws Exception{
		model.addAttribute("proNo", proNo);
        return "/product/productDetail";
    }
	
	@RequestMapping("/product/cart.do") 
    public String cart(Model model) throws Exception{

        return "/product/cart";
    }
	
	@RequestMapping("/product/wishlist.do") 
    public String wish(Model model) throws Exception{

        return "/product/wishList";
    }
	@RequestMapping("/product/sellerStore.do") 
    public String sellerStore(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("storeId", map.get("storeId"));
        return "/product/sellerStorePage";
    }
	
	@RequestMapping(value = "/product/userInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String userInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getUserInfo(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String info(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getProInfo(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/Imginfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String Imginfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getProImg(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/sellerInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sellerInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getStoreInfo(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/TopOptlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String TopOptlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getTopOptList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/AllOptlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String AllOptlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getAllOptList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/cart.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cart(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.getCartList(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/wishList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String wishList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.Wishlist(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/cartDelete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartDelete(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("selectItem").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("list", list);
		
		System.out.println(map);
		
		resultMap = ProductService.deleteCart(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/cartInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartInsert(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		String json = map.get("subOptionList").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
		map.put("list", list);
		resultMap = ProductService.insertCart(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/cartItemQuantityUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartUpdate(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.updateCart(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/checkWishlist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkWishlist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.checkWishlist(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/WishlistAdd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String WishlistAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.WishlistInsert(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/WishlistDel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String WishlistDel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.WishlistDelete(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/qnaInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaInsert(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.qnaInsert(map);
	    return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/reviewList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = ProductService.getReviewList(map);
	    return new Gson().toJson(resultMap);
	}
	
	// 헤더 QnA 버튼으로 페이지 이동 후 QnA 리스트
	@RequestMapping(value = "/product/qna.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("Controller userId => " + map.get("userId"));
		resultMap = ProductService.getQnaList(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/ingred.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ingred(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.proingred(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/disableDateInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String disableDateInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ProductService.DateInfo(map);
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/product/orderInsert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String orderInsert(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String json = map.get("subOptionList").toString(); //제이슨형태로 바꾸기 
		ObjectMapper mapper = new ObjectMapper();
		List<HashMap<String, Object>> list = mapper.readValue(json, new TypeReference<List<HashMap<String, Object>>>(){});
		map.put("list", list); //리스트에 옵션에 대한 정보가 담김
		
		System.out.println("deliveryDate 원본값 => " + map.get("deliveryDate"));
		
		resultMap = ProductService.insertOrder(map);  
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/product/cartToOrder.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartToOrder(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    ObjectMapper mapper = new ObjectMapper();

	    String userId = (String) map.get("userId");
	    
	    // JSON 문자열을 자바 객체로 변환
	    String json = (String) map.get("cartItems");
	    List<HashMap<String, Object>> cartList = mapper.readValue(
	        json, new TypeReference<List<HashMap<String, Object>>>() {}
	    );
	 
	    // cartList를 서비스에 전달하기 위해 map에 담기
	    map.put("cartList", cartList);
	    map.put("userId", userId);
	    System.out.println("1맵"+map);
	
	    resultMap = ProductService.insertCartToOrder(map);

	    return new ObjectMapper().writeValueAsString(resultMap);
	}
	
	// 파일 업로드 관련
	@RequestMapping("/fileUpload.dox")
	public String result(@RequestParam("file1") MultipartFile multi, @RequestParam("idx") int idx, HttpServletRequest request,HttpServletResponse response, Model model)
	{
		String url = null;
		String path="c:\\img";
		try {

			//String uploadpath = request.getServletContext().getRealPath(path);
			String uploadpath = path;
			String originFilename = multi.getOriginalFilename();
			String extName = originFilename.substring(originFilename.lastIndexOf("."),originFilename.length());
			long size = multi.getSize();
			String saveFileName = genSaveFileName(extName);
			
			System.out.println("uploadpath : " + uploadpath);
			System.out.println("originFilename : " + originFilename);
			System.out.println("extensionName : " + extName);
			System.out.println("size : " + size);
			System.out.println("saveFileName : " + saveFileName);
			String path2 = System.getProperty("user.dir");
			System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");
			if(!multi.isEmpty())
			{
				File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
				multi.transferTo(file);
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("filename", saveFileName);
				map.put("path", "../img/" + saveFileName);
				map.put("idx", idx);
				
				// insert 쿼리 실행
			   // testService.addBoardImg(map);
				
				model.addAttribute("filename", multi.getOriginalFilename());
				model.addAttribute("uploadPath", file.getAbsolutePath());
				
				return "redirect:list.do";
			}
		}catch(Exception e) {
			System.out.println(e);
		}
		return "redirect:list.do";
	}
	    
	// 현재 시간을 기준으로 파일 이름 생성
	private String genSaveFileName(String extName) {
		String fileName = "";
		
		Calendar calendar = Calendar.getInstance();
		fileName += calendar.get(Calendar.YEAR);
		fileName += calendar.get(Calendar.MONTH);
		fileName += calendar.get(Calendar.DATE);
		fileName += calendar.get(Calendar.HOUR);
		fileName += calendar.get(Calendar.MINUTE);
		fileName += calendar.get(Calendar.SECOND);
		fileName += calendar.get(Calendar.MILLISECOND);
		fileName += extName;
		
		return fileName;
	}
}
