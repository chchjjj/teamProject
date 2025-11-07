<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 상품 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* 기존 CSS는 유지하되, 상품 리스트에 맞게 일부 추가/수정 */
        body {
            margin: 0;
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f4f4f4;
        }

        .main-wrapper {
            display: flex;
            min-height: calc(100vh - 50px);
        }

        /* 우측 콘텐츠 영역 (기존 코드와 동일) */
        .content-area {
            flex-grow: 1;
            padding: 30px;
            background-color: white;
            margin-left: 220px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 300;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* --- 상품 카드 관련 스타일 --- */
        .product-card {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fff;
        }

        .product-info {
            flex-grow: 1;
        }

        .product-info h4 {
            margin: 0 0 5px 0;
            font-size: 16px;
            color: #333;
        }

        .product-details {
            font-size: 14px;
            color: #666;
        }

        .product-details span {
            margin-right: 15px;
        }

        .product-actions button {
            padding: 6px 12px;
            border: 1px solid #ccc;
            background-color: #f0f0f0;
            cursor: pointer;
            margin-left: 5px;
            border-radius: 4px;
        }

        .product-actions .modify-btn {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        
        /* 상단 상품 등록 버튼 */
        .add-product-btn {
            padding: 10px 20px;
            background-color: #28a745; /* 녹색 */
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .add-product-btn:hover {
            background-color: #218838;
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">
                    상품 관리
                    <button class="add-product-btn" onclick="location.href='/seller/productAdd.do'">
                        + 새 상품 등록
                    </button>
                </h1>
                
                <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 20px;">

                <div v-if="productList.length === 0" style="text-align: center; padding: 50px; color: #999;">
                    등록된 상품이 없습니다. '새 상품 등록' 버튼을 이용해 상품을 등록해주세요.
                </div>

                <div v-for="product in productList" :key="product.proNo" class="product-card">
                    <div class="product-info">
                        <h4>{{ product.proName }} (No. {{ product.proNo }})</h4>
                        <div class="product-details">
                            <span>가격: **{{ product.price.toLocaleString() }}**원</span>
                            <span>재고: {{ product.stockQty }}개</span>
                            <span>판매 상태: **{{ product.status === 'Y' ? '판매 중' : '판매 중지' }}**</span>
                            <span>등록일: {{ product.createdAt.substring(0, 10) }}</span>
                        </div>
                    </div>
                    <div class="product-actions">
                        <button class="modify-btn" :onclick="'location.href=\'/seller/productUpdate.do?proNo=' + product.proNo + '\''">
                            수정
                        </button>
                        <button @click="fnDeleteProduct(product.proNo)">
                            삭제
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                productList: [], // 상품 목록 데이터를 저장할 배열
                userId: "${sessionId}", // JSP 세션 변수를 Vue 데이터로 사용
            };
        },
        methods: {
            /** 상품 목록 조회 (AJAX 통신) */
            fnProductList: function () {
                let self = this;
                let param = {
                    userId: self.userId
                };
                
                // TODO: 실제 상품 목록 조회 URL로 변경해야 합니다.
                // 이전에 가정했던 '/store/list.dox' 대신 '/seller/productList.dox' 등으로 가정합니다.
                $.ajax({
                    url: "/seller/productlist.dox", 
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // Mybatis에서 resultType이 Seller Model이므로, 리스트 내부는 객체 형태일 것입니다.
                        self.productList = data.list; 
                        console.log("상품 목록 조회 성공:", data.list);
                    },
                    error: function (xhr, status, error) {
                        console.error("상품 목록 조회 실패:", error);
                        alert("상품 목록 조회에 실패했습니다.");
                    }
                });
            },
            
           fnDeleteProduct: function (proNo) {
                let self = this;
                
                if (confirm(proNo + "번 상품을 정말로 삭제하시겠습니까?")) {
                    
                    let param = { proNo: proNo };

                    $.ajax({
                        // 상품 삭제를 위한 백엔드 URL
                        url: "/seller/productDelete.dox", 
                        dataType: "json",
                        type: "POST", // DELETE 또는 POST 방식 사용
                        data: param,
                        success: function (data) {
                            // 백엔드에서 성공 (1 또는 'success'와 같은 값)을 리턴했다고 가정
                            if (data.result === 'success' || data.result > 0) { 
                                alert("상품이 성공적으로 삭제되었습니다.");
                                // 삭제 후 목록을 새로고침
                                self.fnProductList(); 
                            } else {
                                // DB에서 삭제 실패 (예: 외래 키 제약 조건 등)
                                alert("상품 삭제에 실패했습니다. (DB 오류)");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("상품 삭제 통신 실패:", error);
                            alert("상품 삭제 통신에 실패했습니다. 서버 로그를 확인하세요.");
                        }
                    });
                }
            },
        },
        mounted() {
            // 페이지 로드 시 상품 목록을 바로 조회
            this.fnProductList();
        }
    });

    app.mount('#app');
</script>
</html>