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
import org.springframework.web.bind.annotation.RequestMethod;
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
	@RequestMapping(value = "/applyStore/img.do", method = RequestMethod.POST) // ⭐ POST Method로 받도록 명시
	public String applyImg(
	    @RequestParam(value = "storeName", required = false) String storeName, // POST Body의 Form Data를 받음
	    Model model) throws Exception{      
	    
	    System.out.println(">>> POST Controller에서 받은 storeName: " + storeName); // 로그 확인
	    
	    model.addAttribute("storeName", storeName);
	    
	    return "applyStore/apply_store_img"; 
	}
	
	@PostMapping("/saveStoreInfo")
	@ResponseBody
    public HashMap<String, Object> saveStoreInfo(@RequestBody HashMap<String, Object> storeInfoMap) {
        
     
        
        System.out.println("컨트롤러에 POST /saveStoreInfo 요청 도착!");
        
       
        HashMap<String, Object> result = applyStoreService.insertStoreInfo(storeInfoMap);
        
       
        return result;
    }
	
	@GetMapping("/getStoreIdByUserId.dox") // Vue.js의 fetchStoreId 메서드에서 호출하는 URL
    @ResponseBody
    public Map<String, Object> getStoreId(
        @RequestParam String userId, 
        @RequestParam String storeName) {
        
        Map<String, Object> response = new HashMap<>();
        
        // ⭐⭐⭐ 디버깅을 위한 로그 추가 ⭐⭐⭐
        System.out.println(">>> getStoreId.dox 호출 - 받은 userId: " + userId);
        System.out.println(">>> getStoreId.dox 호출 - 받은 storeName: " + storeName);
        
        // Service 메서드 호출
        // applyStoreService가 이전에 작성한 getStoreIdByStoreNameAndUserId 메서드를 가지고 있다고 가정
        Integer storeId = applyStoreService.getStoreIdByStoreNameAndUserId(storeName, userId);
        
        if (storeId != null) {
            response.put("success", true);
            response.put("storeId", storeId);
        } else {
            response.put("success", false);
            response.put("message", "조회된 가게 번호가 없습니다.");
        }
        return response;
    }
	
	
	
	
	
}
	

