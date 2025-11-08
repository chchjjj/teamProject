package com.example.teamProject.applyStore.Controller;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;


import jakarta.servlet.http.HttpServletRequest; // request 사용
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.nio.file.Path;
import java.nio.file.Paths;
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

import jakarta.servlet.http.HttpServletRequest;

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
	
	
    
	@RequestMapping(value = "/saveStoreImages.do")
	@ResponseBody 
	public Map<String, Object> saveStoreImages(
	    @RequestParam("profileImage") MultipartFile profileImage,
	    @RequestParam("bannerImage") MultipartFile bannerImage,
	    @RequestParam("userId") String userId, 
	    @RequestParam("storeId") int storeId,   
	    HttpServletRequest request) { 

	    Map<String, Object> resultMap = new HashMap<>();
	    
	    // ⭐ 최종 파일 저장 경로 설정 (webapp/img-seller) ⭐
	    String realPath = request.getServletContext().getRealPath("/");
	    String savePath = realPath + "img-seller"; 
	    
	    // 🟢 [로그] 최종 경로 확인
	    System.out.println(">>> [Controller] 최종 파일 저장 경로: " + savePath);

	    Map<String, String> savedFileDetails = new HashMap<>();

	    try {
	        // 1. 프로필 이미지 처리
	        if (!profileImage.isEmpty()) {
	            // 파일을 디스크에 저장하고, 저장된 파일 정보를 savedFileDetails 맵에 추가
	            processFile(profileImage, "profileImage", storeId, savePath, savedFileDetails); 
	        }

	        // 2. 배너 이미지 처리
	        if (!bannerImage.isEmpty()) {
	            processFile(bannerImage, "bannerImage", storeId, savePath, savedFileDetails);
	        }

	        // 3. Service 호출 (DB 업데이트만 위임)
	        // applyStoreService는 @Autowired로 주입받았다고 가정합니다.
	        HashMap<String, Object> serviceResult = applyStoreService.updateStoreImageInfo(
	                                                      storeId, userId, savedFileDetails); 

	        // Service 결과를 기반으로 최종 응답 맵 구성
	        resultMap.put("success", serviceResult.get("success"));
	        resultMap.put("message", serviceResult.get("message"));
	        resultMap.put("details", savedFileDetails);

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("success", false);
	        resultMap.put("message", "파일 업로드 중 오류가 발생했습니다: " + e.getMessage());
	    }
	    return resultMap;
	}
	
   
	
    
 // 파일 저장 및 정보 수집 메서드
	private void processFile(MultipartFile multi, String fileKey, int storeId, String savePath, Map<String, String> savedFileDetails) throws Exception {
	    String originFilename = multi.getOriginalFilename();
	    if (originFilename == null || originFilename.isEmpty()) {
	        throw new IOException("파일 이름이 유효하지 않습니다.");
	    }
	    
	    // 파일 확장자 추출 및 저장 파일명 생성
	    String extName = originFilename.substring(originFilename.lastIndexOf("."));
	    String saveFileName = genSaveFileName(extName);
	    
	    // Path 객체를 사용하여 절대 경로 생성
	    Path targetPath = Paths.get(savePath, saveFileName);
	    
	    // 경로가 없을 경우 생성 (폴더가 없으면 새로 만듭니다.)
	    File saveDir = targetPath.getParent().toFile();
	    if (!saveDir.exists()) {
	        saveDir.mkdirs();
	        System.out.println(">>> [Controller: processFile] 디렉토리 생성 완료: " + saveDir.getAbsolutePath());
	    }

	    // ⭐ 파일 저장 (임시 파일 소멸 전에 저장합니다.) ⭐
	    multi.transferTo(targetPath); 

	    // DB 저장을 위해 정보 저장
	    savedFileDetails.put(fileKey + "OriginalName", originFilename);
	    savedFileDetails.put(fileKey + "SaveName", saveFileName);
	    // savedFileDetails.put(fileKey + "Path", savePath + File.separator + saveFileName); // DB에 저장할 필요는 없음
	    savedFileDetails.put(fileKey + "Size", String.valueOf(multi.getSize()));
	    savedFileDetails.put(fileKey + "Ext", extName); // 확장자도 저장

	    System.out.println(">>> [Controller: processFile] " + fileKey + " 저장 완료: " + targetPath.toAbsolutePath());
	}

    // 파일명 생성 메서드 (년월일시분초밀리초 + 확장자)
	private String genSaveFileName(String extName) {
	    String fileName = "";
	    
	    Calendar calendar = Calendar.getInstance();
	    fileName += calendar.get(Calendar.YEAR);
	    fileName += calendar.get(Calendar.MONTH) + 1; 
	    fileName += calendar.get(Calendar.DATE);
	    fileName += calendar.get(Calendar.HOUR_OF_DAY); 
	    fileName += calendar.get(Calendar.MINUTE);
	    fileName += calendar.get(Calendar.SECOND);
	    fileName += calendar.get(Calendar.MILLISECOND);
	    fileName += extName;
	    
	    return fileName;
	}
}
	

