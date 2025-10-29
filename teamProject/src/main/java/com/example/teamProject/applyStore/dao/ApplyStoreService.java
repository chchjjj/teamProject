package com.example.teamProject.applyStore.dao;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;

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
            // ApplyStoreModel 객체를 그대로 파라미터로 전달
            int rowsAffected = applyStoreMapper.insertSellerInfo(map);  // 데이터베이스에 업데이트 쿼리 실행

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
    public HashMap<String, Object> getStoreInfo(int storeId) {
        try {
            return applyStoreMapper.getStoreInfo(storeId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;  
        }
    }

    // 가게 이미지 저장
    @Transactional
    public boolean saveStoreImages(MultipartFile profileImage, MultipartFile bannerImage) {
        try {
            String profileImagePath = "uploads/profile/" + profileImage.getOriginalFilename();
            String bannerImagePath = "uploads/banner/" + bannerImage.getOriginalFilename();

        
            File profileFile = new File(profileImagePath);
            File bannerFile = new File(bannerImagePath);
            Files.createDirectories(Paths.get(profileFile.getParent()));

            // 이미지 파일 업로드
            profileImage.transferTo(profileFile);
            bannerImage.transferTo(bannerFile);

            // 이미지 경로 DB에 저장
            HashMap<String, Object> imageParams = new HashMap<>();
            imageParams.put("profileImagePath", profileImagePath);
            imageParams.put("bannerImagePath", bannerImagePath);

            int rowsAffected = applyStoreMapper.insertStoreImages(imageParams);

            return rowsAffected > 0;  
        } catch (IOException e) {
            e.printStackTrace();
            return false;  
        }
    }
}
