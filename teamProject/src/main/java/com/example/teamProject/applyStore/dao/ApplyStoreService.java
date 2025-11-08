package com.example.teamProject.applyStore.dao;

import java.io.File;
import java.io.IOException; // ⭐ 누락된 import 추가
import java.util.Calendar; // ⭐ 누락된 import 추가
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.applyStore.mapper.ApplyStoreMapper;

@Service
public class ApplyStoreService {
    
    @Autowired
    private ApplyStoreMapper applyStoreMapper;

    // 가게 정보 입력
    public HashMap<String, Object> insertStoreInfo(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            
            int rowsAffected = applyStoreMapper.insertSellerInfo(map);  

            if (rowsAffected > 0) {
                resultMap.put("success", true);
                resultMap.put("message", "입점 신청이 성공적으로 완료되었습니다.");
            } else {
                resultMap.put("success", false);
                resultMap.put("message", "입점 신청이 실패했습니다.");
            }
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }

        return resultMap;
    }

    // 가게 정보 조회
public Integer getStoreIdByStoreNameAndUserId(String storeName, String userId) {
        
        System.out.println("Service: getStoreIdByStoreNameAndUserId 호출 - Store Name: " + storeName + ", User ID: " + userId);

        // ⭐ Mapper 호출: DB에서 storeName과 userId가 일치하는 storeId를 조회
        // 이 메서드는 정리된 Mapper의 selectStoreIdByStoreNameAndUserId를 호출합니다.
        try {
            Integer storeId = applyStoreMapper.selectStoreIdByStoreNameAndUserId(storeName, userId);
            
            if (storeId == null) {
                System.out.println("Service: 조회된 가게 번호 없음.");
            } else {
                System.out.println("Service: 조회된 가게 번호: " + storeId);
            }
            return storeId;
            
        } catch (Exception e) {
            System.err.println("Service: 가게 번호 조회 중 DB 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null; // 오류 발생 시 null 반환
        }
    }
  







@Transactional 
public HashMap<String, Object> updateStoreImageInfo(int storeId, String userId, Map<String, String> savedFileDetails) {
    
    HashMap<String, Object> resultMap = new HashMap<>();
    int totalRowsAffected = 0; // 삽입된 행의 총 개수
    
    try {
        // 1. 프로필 이미지 정보 준비 및 삽입
        HashMap<String, Object> profileMap = new HashMap<>();
        profileMap.put("storeId", storeId);
        profileMap.put("fileUse", "프로필"); 
        profileMap.put("filePath", "img-seller/");
        profileMap.put("fileName", savedFileDetails.get("profileImageSaveName"));
        profileMap.put("fileOrgName", savedFileDetails.get("profileImageOriginalName"));
        profileMap.put("fileEtc", savedFileDetails.get("profileImageExt")); 

        // 🟢 Mapper 호출 1: insertStoreImage 사용!
        totalRowsAffected += applyStoreMapper.insertStoreImage(profileMap); 
        System.out.println(">>> [Service] 프로필 이미지 DB 저장 완료.");


        // 2. 배너 이미지 정보 준비 및 삽입
        HashMap<String, Object> bannerMap = new HashMap<>();
        bannerMap.put("storeId", storeId);
        bannerMap.put("fileUse", "배너"); 
        bannerMap.put("filePath", "img-seller/");
        bannerMap.put("fileName", savedFileDetails.get("bannerImageSaveName"));
        bannerMap.put("fileOrgName", savedFileDetails.get("bannerImageOriginalName"));
        bannerMap.put("fileEtc", savedFileDetails.get("bannerImageExt")); 

        // 🟢 Mapper 호출 2: insertStoreImage 사용!
        totalRowsAffected += applyStoreMapper.insertStoreImage(bannerMap); 
        System.out.println(">>> [Service] 배너 이미지 DB 저장 완료.");


        // 3. 결과 처리
        if (totalRowsAffected == 2) {
            resultMap.put("success", true);
            resultMap.put("message", "파일 정보가 DB에 성공적으로 저장되었습니다. (2건)");
        } else {
            resultMap.put("success", false);
            resultMap.put("message", "DB 업데이트 실패: 2건 중 " + totalRowsAffected + "건만 저장되었습니다.");
        }
        
    } catch (Exception e) {
        System.err.println("DB 삽입 중 오류 발생: " + e.getMessage());
        e.printStackTrace();
        // Transactional이 붙어 있으므로, 오류 시 디스크에 저장된 파일 정보도 DB에 저장되지 않습니다.
        resultMap.put("success", false);
        resultMap.put("message", "DB 업데이트 중 서버 오류가 발생했습니다: " + e.getMessage());
    }
    
    return resultMap;
}
    
}
