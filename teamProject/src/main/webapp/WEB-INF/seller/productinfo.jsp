<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>:: 알레르기 등록/수정 ::</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <script src="/js/page-change.js"></script>

    <style>

        /* QnA 제목 스타일 */
        .title {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-top: 30px;
            margin-bottom: 25px;
            padding-bottom: 10px;
            text-align: left;
        }

        /* 새 목록 컨테이너 스타일 */
        .ingredient-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            gap: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 15px;
            margin-top: 20px;
        }

        /* 목록 아이템 스타일 */
        .ingredient-item {
            flex: 1 1 calc(33% - 20px);
            box-sizing: border-box;
            padding: 10px;
            border: 1px solid #eee;
            border-radius: 4px;
            display: flex;
            align-items: flex-start;
            min-height: 45px;
            transition: all 0.2s ease;
        }

        .ingredient-item:hover {
            background-color: #f9f9f9;
            border-color: #aaa;
        }

        /* 체크되었을 때 시각 효과 */
        .item-checkbox:checked + .item-content .ingredient-name {
            font-weight: bold;
            color: #d47fa6;
        }
        
        .item-checkbox {
            margin-right: 10px;
            margin-top: 4px;
        }

        .item-content {
            flex-grow: 1;
            text-align: left;
        }

        .ingredient-name {
            font-weight: 600;
            font-size: 14px;
            color: #333;
        }

        .ingredient-description {
            font-size: 12px;
            color: #666;
            margin-top: 3px;
            line-height: 1.4;
        }

        /* 등록 기능 컨테이너 스타일 */
        .register-area {
            display: flex;
            gap: 10px;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        /* 등록/수정 버튼 (button) 스타일 */
        .register-area button {
            padding: 10px 20px; /* 버튼 크기 키움 */
            background-color: #d47fa6; /* 색상 변경 */
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px; /* 폰트 크기 키움 */
            cursor: pointer;
            transition: background-color 0.3s;
            height: 45px;
            font-weight: bold;
        }

        .register-area button:hover {
            background-color: #b56b8e;
        }

        .info {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
        }

        .message {
            text-align: center;
            color: #333;
            margin-top: 50px;
            font-size: 16px;
            padding: 15px;
            border: 1px solid #d47fa6;
            background-color: #fcefee;
            border-radius: 8px;
            font-weight: 600;
            margin-bottom: 50px;
        }

        body{
            background-color: #f1f1f1;
        }
        .content-container{
            border: 1px solid #a7a7a7;
            border-radius: 10px;
            background-color: #fff;
            padding: 30px; /* 컨텐츠 내부 패딩 추가 */
        }
    </style>
</head>

<body>
    

    <div id="app">
        <div class="container">
            <%-- sellerSideBar.jsp가 여기에 인클루드됩니다. --%>
            <main class="content-container">
                <h1 class="title">✅ 내 알레르기 원재료 등록/수정</h1>
                <hr class="divider">

                <div class="info">※ 알레르기가 있는 **원재료를 체크**한 후 **'내 알레르기 등록/수정'** 버튼을 눌러주세요.</div>
                <div class="info">※ 체크된 원재료는 **회원님의 알레르기 정보**로 저장되어 상품 검색 등에 활용됩니다.</div>


                <div class="ingredient-list">
                    <label class="ingredient-item" v-for="item in ingreList" :key="item.ingredientName">
                        <input type="checkbox" class="item-checkbox" v-model="ingreName"
                            :value="item.ingredientId">
                        <div class="item-content">
                            <div class="ingredient-name">
                                {{item.ingredientName}}
                            </div>
                            <div class="ingredient-description">
                                {{item.ingredientDescription}}
                            </div>
                        </div>
                    </label>
                </div>

                <div class="register-area">
                    <button @click="fnRegisterAllergy">내 알레르기 등록/수정</button>
                </div>

                <div v-if="successMessage" class="message">
                    {{ successMessage }}
                </div>
                
                <div v-if="errorMessage" class="message" style="border-color: #ff4d4d; background-color: #fff0f0; color: #cc0000;">
                    {{ errorMessage }}
                </div>

            </main>
        </div>
    </div>
    
</body>

</html>

<script>
    // JSP 스크립틀릿을 사용하여 proNo 파라미터 값을 가져옵니다.
    // request.getParameter("proNo")를 사용하여 파라미터 값을 문자열로 가져옵니다.
    const PRO_NO = "${param.proNo != null ? param.proNo : ''}";

    // 페이지 이동 함수는 외부 파일에서 불러옴: /js/page-change.js

    const app = Vue.createApp({
        data() {
            return {
                userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                proNo: PRO_NO, // URL에서 가져온 proNo 값
                pageSize: 4, // 원재료 목록 조회 시 필요한 pageSize
                page: 1, // 원재료 목록 조회 시 필요한 page
                ingreList: [], // 전체 원재료 목록
                ingreName: [], // **체크한 원재료 목록 (사용자 알레르기)**
                successMessage: "", // 성공 메시지
                errorMessage: "", // 에러 메시지
                // 기존 상품 관련 변수 (proList, emptyMessage, index 등)는 삭제
            };
        },

        methods: {

            // 원재료 리스트 전체 불러오기 (화면에 체크박스 표시용)
            fnIngreList: function () {
                let self = this;
                let param = {
                    pageSize: 1000, // 등록 기능이므로 전체 목록을 불러오기 위해 큰 값 사용
                    page: 0 // OFFSET 시작
                };
                $.ajax({
                    url: "/main/ingre-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data && data.list) {
                            self.ingreList = data.list; 
                            console.log(self.ingreList);
                        }
                        // 원재료 목록 로드 후, 기존 등록된 알레르기 불러오기
                        self.fnLoadAllergy();
                    },
                    error: function(xhr, status, error) {
                        console.error("원재료 목록 조회 실패:", error);
                    }
                });
            },

            // 현재 사용자가 등록한 알레르기 목록 불러오기 (체크박스에 반영)
            fnLoadAllergy: function() {
                let self = this;
                
                if (!self.userId || self.userId.trim() === "") {
                    // 비로그인 사용자에게는 메시지를 표시하지 않음
                    return; 
                }

                // // 이전 로그에서 404 Not Found 오류가 발생했으므로 주석 처리 해제 시 백엔드 경로 확인 필요
                // $.ajax({
                //     url: "/main/load-allergy.dox", // 알레르기 목록을 불러오는 새로운 URL
                //     dataType: "json",
                //     type: "POST",
                //     data: { userId: self.userId },
                //     success: function(data) {
                //         if (data && data.list) {
                //             // 불러온 알레르기 이름만 추출하여 ingreName(체크박스 모델)에 반영
                //             self.ingreName = data.list.map(item => item.ingredientName);
                //             console.log("기존 등록 알레르기:", self.ingreName);
                //         }
                //     },
                //     error: function(xhr, status, error) {
                //         console.error("알레르기 목록 로드 실패:", error);
                //         self.errorMessage = "기존 알레르기 정보를 불러오는 데 실패했습니다.";
                //     }
                // });
            },


            // '내 알레르기 등록/수정' 클릭 시 실행
            fnRegisterAllergy: function () {
                let self = this;
                self.successMessage = ""; // 메시지 초기화
                self.errorMessage = "";

                if (!self.userId || self.userId.trim() === "") {
                    self.errorMessage = "로그인 후 알레르기 등록/수정을 이용할 수 있습니다.";
                    return;
                }
                let ingreName = JSON.stringify(self.ingreName);
                let param = {
                    proNo: self.proNo,
                    ingreName: ingreName, // 체크된 원재료 배열
                    // proNo는 이 기능에서 필수가 아닐 수 있지만, 필요하다면 추가
                    // proNo: self.proNo 
                };

                $.ajax({
                    url: "/seller/insertProductAllergy.dox", // 새로운 알레르기 등록/수정 URL
                    dataType: "json",
                    type: "POST",
                    traditional: true, // 배열 전송시 HashMap으로 인식시키기
                    data: param,
                    success: function (data) {
                        console.log("알레르기 등록 결과:", data);

                        if (data.result === 'success') {
                            const count = self.ingreName.length;
                            if (count > 0) {
                                self.successMessage = `알레르기 원재료 ${count}개가 성공적으로 등록/수정되었습니다.`;
                            } else {
                                self.successMessage = "알레르기 원재료가 모두 해제되어 등록된 정보가 없습니다.";
                            }
                            // 등록 후 혹시 모를 서버 반영을 위해 다시 불러오기 (선택 사항)
                            self.fnLoadAllergy(); 
                        } else {
                            self.errorMessage = "알레르기 등록/수정에 실패했습니다. (서버 오류)";
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("알레르기 등록 AJAX 오류:", error);
                        self.errorMessage = "알레르기 등록/수정 중 통신 오류가 발생했습니다.";
                    }
                });
            },

            // 기존에 있던 상품 관련 함수들은 모두 삭제했습니다.

        }, // methods

        mounted() {
            let self = this;
            console.log("로그인 아이디 ===> " + self.userId);
            console.log("상품 번호 (proNo) ===> " + self.proNo);

            // 1. 전체 원재료 목록 가져오기 (이후 콜백으로 2. fnLoadAllergy 호출)
            self.fnIngreList();
        }
    });

    app.mount('#app');
</script>