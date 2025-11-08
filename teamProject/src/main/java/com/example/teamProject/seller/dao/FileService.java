package com.example.teamProject.seller.dao;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import jakarta.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.seller.mapper.ProductImgMapper;
import com.example.teamProject.seller.model.ProductImgDTO;

@Service
public class FileService {

	// application.properties에서 파일 저장 경로를 주입받음
	@Value("${file.upload-dir}")
	private String uploadDir;

	// DB 작업을 위한 Mapper 주입
	@Autowired
	private ProductImgMapper imgMapper;

	// ==========================================================
	// ⭐ 서버 시작 시 디렉토리 자동 생성
	// ==========================================================
	@PostConstruct
	public void init() {
		try {
			Path uploadPath = Paths.get(uploadDir);

			if (Files.notExists(uploadPath)) {
				Files.createDirectories(uploadPath);
				System.out.println("INFO: 파일 업로드 디렉토리가 생성되었습니다: " + uploadPath.toAbsolutePath());
			} else {
				System.out.println("INFO: 파일 업로드 디렉토리가 이미 존재합니다: " + uploadPath.toAbsolutePath());
			}
		} catch (IOException e) {
			System.err.println("FATAL ERROR: 파일 업로드 디렉토리 생성 실패!");
			throw new RuntimeException("파일 업로드 디렉토리 초기화 실패", e);
		}
	}

	// ==========================================================
	// 1. 제품 등록 시 이미지 업로드 및 DB 저장
	// ==========================================================
	// 🌟 [수정 완료] thumbnailUse 파라미터 추가
	public void uploadProductImages(int proNo, MultipartFile thumbnailFile, String thumbnailUse,
			List<MultipartFile> detailFiles, MultipartFile longFile) {

		List<ProductImgDTO> imgList = new ArrayList<>();

		try {
			// 1. 파일 데이터 DTO 리스트 생성
			if (thumbnailFile != null && !thumbnailFile.isEmpty()) {
				// 🌟 [수정 완료] 하드코딩된 "M" 대신, 전달받은 thumbnailUse를 사용합니다.
				String thumbUse = (thumbnailUse != null && !thumbnailUse.isEmpty()) ? thumbnailUse : "T";
				imgList.add(saveFileAndCreateDto(proNo, thumbnailFile, thumbUse));
			}
			
			// detailFiles는 "I" (하위 이미지)로 고정
			if (detailFiles != null) {
				for (MultipartFile file : detailFiles) {
					if (!file.isEmpty()) {
						imgList.add(saveFileAndCreateDto(proNo, file, "I"));
					}
				}
			}
			
			// longFile은 "B" (본문 이미지)로 고정
			if (longFile != null && !longFile.isEmpty()) {
				imgList.add(saveFileAndCreateDto(proNo, longFile, "B"));
			}

			// 2. DB에 이미지 정보 일괄 저장
			if (!imgList.isEmpty()) {
				for (ProductImgDTO img : imgList) {
					imgMapper.insertProductImages(img); 
				}
			}

		} catch (Exception e) {
			System.err.println("파일 업로드 중 오류 발생: " + e.getMessage());
			throw new RuntimeException("파일 처리 실패", e);
		}
	}

	// ==========================================================
	// 2. 제품 수정 시 이미지 업데이트 (기존 파일 삭제 후 새 파일 등록)
	// ==========================================================
	// 🌟 [수정 완료] thumbnailUse 파라미터 추가
	public void updateProductImages(int proNo, MultipartFile thumbnailFile, String thumbnailUse,
			List<MultipartFile> detailFiles, MultipartFile longFile) {
		
		try {
			// 🌟 STEP 1: 기존 이미지 삭제 처리 (DB 및 물리 파일)
			List<ProductImgDTO> existingFiles = imgMapper.selectImagesByProNo(proNo);
			imgMapper.deleteImagesByProNo(proNo); // DB 레코드 삭제

			if (existingFiles != null) {
				for (ProductImgDTO img : existingFiles) {
					Path filePath = Paths.get(uploadDir + File.separator + img.getImgFilename());
					try {
						Files.deleteIfExists(filePath); // 물리 파일 삭제
					} catch (IOException e) {
						System.err.println("물리 파일 삭제 실패 (로그 기록): " + img.getImgFilename());
					}
				}
			}

			// 🌟 STEP 2: 새로운 이미지 파일 등록 (uploadProductImages 호출)
			// 🌟 [수정 완료] 전달받은 thumbnailUse 값을 그대로 전달합니다.
			uploadProductImages(proNo, thumbnailFile, thumbnailUse, detailFiles, longFile); 

		} catch (Exception e) {
			System.err.println("파일 수정/업로드 중 오류 발생: " + e.getMessage());
			throw new RuntimeException("제품 이미지 수정 실패: " + e.getMessage(), e);
		}
	}

	// ==========================================================
	// 3. 파일 저장 및 DTO 생성 유틸리티 (파일명 변경 로직 적용됨)
	// ==========================================================
	
	private ProductImgDTO saveFileAndCreateDto(int proNo, MultipartFile file, String imgType) throws Exception {

	    String originalFilename = file.getOriginalFilename();
	    String fileExtension = "";
	    
	    // 1. 확장자 분리
	    int dotIndex = originalFilename.lastIndexOf(".");
	    if (dotIndex != -1 && dotIndex < originalFilename.length() - 1) {
	        fileExtension = originalFilename.substring(dotIndex);
	    }
	    
	    // 2. ⭐ [수정] 파일명 변경 로직을 제거하고 원본 파일명 그대로 사용 ⭐
	    // 경고: 파일명이 같으면 덮어쓰기 위험이 있습니다.
	    String savedFilename = originalFilename; 


	    // 3. 실제 파일 저장 실행 (uploadDir 경로에 저장)
	    // targetLocation은 application.properties에서 지정된 실제 OS 경로를 사용합니다.
	    Path targetLocation = Paths.get(uploadDir + File.separator + savedFilename);

	    // 파일 저장 실행
	    // 동일 파일명이 이미 있다면 덮어씁니다.
	    Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

	    // 4. DB 저장을 위한 DTO 생성
	    ProductImgDTO imgDto = new ProductImgDTO();
	    imgDto.setProNo(proNo);
	    
	    // DB에는 웹 접근 경로(/img-product/)를 저장합니다.
	    imgDto.setImgPath("/img-product/"); 
	    
	    imgDto.setImgFilename(savedFilename); // ⭐ 원본 파일명 그대로 저장
	    imgDto.setImgOrgFilename(originalFilename);
	    imgDto.setImgFormat(fileExtension.toUpperCase().replace(".", ""));
	    imgDto.setImgType(imgType); // T, I, B 등 파일 용도 저장

	    return imgDto;
	}
}