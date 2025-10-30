package com.example.teamProject.applyStore.Controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
       return "/applyStore/apply_store_info"; 
   }
	@RequestMapping("/applyStore/img.do")
	public String applyImg(Model model) throws Exception{
		return "applyStore/apply_store_img"; 
   }
	
	@PostMapping("/saveStoreInfo")
	@ResponseBody
    public HashMap<String, Object> saveStoreInfo(@RequestBody HashMap<String, Object> storeInfoMap) {
        
     
        
        System.out.println("컨트롤러에 POST /saveStoreInfo 요청 도착!");
        
       
        HashMap<String, Object> result = applyStoreService.insertStoreInfo(storeInfoMap);
        
       
        return result;
    }
	
	@GetMapping("/getStoreIdByUserId.do")
    public Map<String, Object> getStoreIdByUserId(@RequestParam String userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long storeId = applyStoreService.getStoreIdByUserId(userId);
            if (storeId != null) {
                response.put("success", true);
                response.put("storeId", storeId);
            } else {
                response.put("success", false);
                response.put("storeId", null);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("storeId", null);
            response.put("error", e.getMessage());
        }
        return response;
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
	


