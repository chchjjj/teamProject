<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도로명주소 검색</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 15px; background-color: #f4f4f4; }
        .container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        input[type="text"] { padding: 8px; margin-right: 5px; border: 1px solid #ccc; border-radius: 4px; width: 60%; }
        button { padding: 8px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .result-item { border-bottom: 1px solid #eee; padding: 10px 0; }
        .result-item:last-child { border-bottom: none; }
        .select-btn { float: right; background-color: #28a745; }
        .select-btn:hover { background-color: #1e7e34; }
    </style>
</head>
<body>

<div class="container">
    <h2>도로명주소 검색</h2>
    <div>
        <input type="text" id="searchKeyword" placeholder="예) 세종로 17, 세종대로 209">
        <button onclick="searchAddress(1)">검색</button>
    </div>

    <div id="searchResults" style="margin-top: 15px; max-height: 400px; overflow-y: auto;">
        <p>도로명주소, 건물명, 지번 등으로 검색해주세요.</p>
    </div>
    
    <div id="pagination" style="text-align: center; margin-top: 15px;">
        </div>
</div>

<script>
    // 이전에 만든 Spring Boot 컨트롤러의 엔드포인트
    const API_ENDPOINT = '/seller/api/juso/search'; 
    const COUNT_PER_PAGE = 10;
    
    /**
     * 주소 검색 API를 호출하고 결과를 화면에 표시합니다.
     */
   function searchAddress(currentPage) {
        const keyword = document.getElementById('searchKeyword').value;
        const resultsDiv = document.getElementById('searchResults');
        const paginationDiv = document.getElementById('pagination');
        
        if (!keyword) {
            resultsDiv.innerHTML = "<p style='color:red;'>검색어를 입력해주세요.</p>";
            paginationDiv.innerHTML = "";
            return;
        }

        resultsDiv.innerHTML = "<p>검색 중...</p>";
        paginationDiv.innerHTML = "";
        
        // ⭐ 개선 1: 검색어(keyword)를 URL 인코딩하여 특수문자나 공백으로 인한 오류 방지
        const encodedKeyword = encodeURIComponent(keyword);

        // 백엔드 컨트롤러로 AJAX 요청 (keyword, 페이지 정보 전달)
        fetch(`${API_ENDPOINT}?keyword=${encodedKeyword}&currentPage=${currentPage}&countPerPage=${COUNT_PER_PAGE}`)
            .then(response => {
                // ⭐ 개선 2: HTTP 상태 코드가 200번대가 아니면 오류를 throw (404, 500 오류 포착)
                if (!response.ok) {
                    // 서버 오류 시, .catch 블록으로 이동하여 명확한 오류 메시지 출력
                    throw new Error(`HTTP Error! Status: ${response.status} (${response.statusText})`);
                }
                return response.json();
            })
            .then(data => {
                // 행안부 API의 JSON 응답 구조를 기반으로 데이터 처리
                const common = data.results.common;
                const addressList = data.results.juso || [];
                
                if (common.errorCode === '0') {
                    displayResults(addressList);
                    displayPagination(common, keyword);
                } else {
                    // API 응답 자체의 오류 (예: 승인되지 않은 키)
                    resultsDiv.innerHTML = `<p style='color:red;'>[API 오류 ${common.errorCode}] ${common.errorMessage}</p>`;
                }
            })
            .catch(error => {
                // 통신 실패, 서버 4xx/5xx 오류, JSON 파싱 오류 등이 여기에서 처리됨
                resultsDiv.innerHTML = `<p style='color:red;'>통신 오류 발생: 서버 연결 및 로그를 확인하세요.</p>`;
                // ⭐ 콘솔에 구체적인 오류 정보 출력 (예: Fetch Error: HTTP Error! Status: 404 (Not Found))
                console.error('Fetch Error:', error);
            });
    }
    /**
     * 검색 결과를 목록으로 화면에 출력합니다.
     */
    function displayResults(list) {
        const resultsDiv = document.getElementById('searchResults');
        let html = '';

        if (list.length > 0) {
            list.forEach(item => {
                // item 객체는 백엔드에서 받은 API의 주소 정보(zipNo, roadAddr 등)를 포함
                // 이 정보를 selectJuso 함수로 전달합니다.
                html += `
                    <div class="result-item">
                        <strong>[${item.zipNo}]</strong> ${item.roadAddr}
                        <button class="select-btn" 
                            onclick="selectJuso('${item.zipNo}', '${item.roadAddr}', '${item.jibunAddr}')">선택</button><br>
                        <span style="font-size: smaller; color: gray;">(지번: ${item.jibunAddr})</span>
                    </div>
                `;
            });
            resultsDiv.innerHTML = html;
        } else {
            resultsDiv.innerHTML = "<p>검색 결과가 없습니다.</p>";
        }
    }
    
    /**
     * 페이지네이션 버튼을 화면에 출력합니다.
     */
    function displayPagination(common, keyword) {
        const paginationDiv = document.getElementById('pagination');
        const totalCount = parseInt(common.totalCount);
        const currentPage = parseInt(common.currentPage);
        const totalPages = Math.ceil(totalCount / COUNT_PER_PAGE);
        let html = '';

        if (totalCount === 0) return;

        // 페이지 버튼 생성 (간단하게 5개씩 보여주는 예시)
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, startPage + 4);

        if (currentPage > 1) {
            html += `<button onclick="searchAddress(${currentPage - 1})">이전</button>`;
        }

        for (let i = startPage; i <= endPage; i++) {
            const activeClass = i === currentPage ? ' style="background-color: #6c757d;"' : '';
            html += `<button${activeClass} onclick="searchAddress(${i})">${i}</button>`;
        }

        if (currentPage < totalPages) {
            html += `<button onclick="searchAddress(${currentPage + 1})">다음</button>`;
        }
        
        paginationDiv.innerHTML = html;
    }


    /**
     * 주소를 선택하고 부모 창으로 정보를 전달합니다.
     */
    function selectJuso(zipcode, roadAddr, jibunAddr) {
        if (window.opener && window.opener.setAddress) {
            // 부모 창의 setAddress 함수를 호출하여 값 전달
            window.opener.setAddress({
                zipcode: zipcode,
                roadAddress: roadAddr,
                jibunAddress: jibunAddr
                // 추가로 필요한 정보(예: 건물명 등)도 전달 가능
            });
            window.close(); // 팝업 창 닫기
        } else {
            alert('주소 정보를 전달할 부모 창을 찾을 수 없습니다.');
        }
    }
</script>

</body>
</html>