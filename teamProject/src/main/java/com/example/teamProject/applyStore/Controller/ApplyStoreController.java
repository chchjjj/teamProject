package com.example.teamProject.applyStore.Controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.applyStore.dao.ApplyStoreService;

@Controller
public class ApplyStoreController {
	 @Autowired
	  ApplyStoreService applyStoreService;
	
	@RequestMapping("/applyStore.do")
	public String apply(Model model) throws Exception{
       return "/applyStore"; 
   }
	
	  @GetMapping("/storePage.do")
	    public String getStorePage(Model model, @RequestParam("storeId") int storeId) {
	        // 서비스에서 가게 정보를 가져옴
	        HashMap<String, Object> storeInfo = applyStoreService.getStoreInfo(storeId);

	        // 가게 정보가 존재하면 모델에 추가
	        if (storeInfo != null) {
	            model.addAttribute("storeId", storeInfo.get("storeId"));
	            model.addAttribute("storeName", storeInfo.get("storeName"));
	            model.addAttribute("userId", storeInfo.get("userId"));
	        } else {
	            model.addAttribute("errorMessage", "가게 정보를 찾을 수 없습니다.");
	        }

	        return "apply_store_img";  // 이미지 업로드 페이지로 이동
	    }
	
	  @PostMapping("/saveStoreImages.do")
	    @ResponseBody
	    public HashMap<String, Object> saveStoreImages(@RequestParam("profileImage") MultipartFile profileImage,
	                                                   @RequestParam("bannerImage") MultipartFile bannerImage) {
	        HashMap<String, Object> result = new HashMap<>();
	        // 이미지 저장 서비스 호출
	        boolean success = applyStoreService.saveStoreImages(profileImage, bannerImage);

	        // 저장 결과 반환
	        if (success) {
	            result.put("success", true);
	            result.put("message", "이미지 업로드가 성공적으로 완료되었습니다.");
	        } else {
	            result.put("success", false);
	            result.put("message", "이미지 업로드 실패");
	        }
	        return result;
	    }
	
	
	
}
	


