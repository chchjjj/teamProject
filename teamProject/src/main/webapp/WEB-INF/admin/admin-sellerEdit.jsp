<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>판매자정보수정</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/admin-style.css">
    
    <style>
        .registration-image {
            width: 300px;
            height: 200px;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f5f5f5;
        }
        
        .registration-image img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="mainPageContainer">

            <!-- === 왼쪽 네비게이션 바 === -->
            <div class="navBar">
                <div class="logo">
                    <a href="javascript:;" onclick="location.href='/main.do'">
                        <img src="/img/로고.png" alt="쇼핑몰 로고">
                    </a>
                </div>

                <div class="navButton">
                    <div><button @click="fnBuyerManage()" :class="{active: currentMenu==='buyer'}">전체 유저 관리</button></div>
                    <div><button @click="fnSellerManage()" :class="{active: currentMenu==='seller'}">판매자관리</button></div>
                    <div><button @click="fnSalesManage()" :class="{active: currentMenu==='money'}">매출관리</button></div>
                    <div><button @click="fnAdRequest()" :class="{active: currentMenu==='ad'}">광고관리</button></div>
                    <div><button @click="fnMembership()" :class="{active: currentMenu==='membership'}">맴버쉽관리</button></div>
                    <div><button @click="fnMonthlyFee()" :class="{active: currentMenu==='month'}">판매자 월 정산결과 조회</button></div>
                    <div><button @click="fnQandA()" :class="{active: currentMenu==='qna'}">게시글 관리</button></div>
                </div>

                <div class="logOut">
                    <div><button @click="fnLogout()">Logout</button></div>
                </div>
            </div>

            <!-- === 메인 컨텐츠 === -->
            <div class="userEdit">
                <div class="title">판매자 정보 수정</div>

                <table>
                    <tr>
                        <th>사업자 등록증 이미지</th>
                        <td>
                            <div class="registration-image" v-if="seller.imgPath">
                                <img :src="seller.imgPath" alt="사업자 등록증">
                            </div>
                            <div class="registration-image" v-else>
                                이미지 없음
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>사업자 번호</th>
                        <td>{{seller.businessNo}}</td>
                    </tr>
                    <tr>
                        <th>가게 번호</th>
                        <td>{{seller.storeId}}</td>
                    </tr>
                    <tr>
                        <th>가게 이름</th>
                        <td><input type="text" v-model="seller.storeName"></td>
                    </tr>
                    <tr>
                        <th>소유자 유저 아이디</th>
                        <td>{{seller.userId}}</td>
                    </tr>
                    <tr>
                        <th>가게 주소</th>
                        <td><input type="text" v-model="seller.storeAddr"></td>
                    </tr>
                    <tr>
                        <th>입점 승인여부</th>
                        <td>
                            <select v-model="seller.storePass">
                                <option value="P">승인</option>
                                <option value="R">거절</option>
                                <option value="G">심사 진행 중</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>가입일자</th>
                        <td>{{seller.joinCdate}}</td>
                    </tr>
                    <tr v-if="seller.storePass==='R'">
                        <th>입점거절 사유</th>
                        <td><input type="text" v-model="seller.rejectReason"></td>
                    </tr>
                    <tr>
                        <th>맴버십 가입 여부</th>
                        <td v-if="seller.membership==='N'">미가입</td>
                        <td v-if="seller.membership==='Y'">가입</td>
                    </tr>
                    <tr v-if="seller.storePass==='P'">
                        <th>가게승인 일자</th>
                        <td>{{seller.passDate || '-'}}</td>
                    </tr>
                </table>

                <div style="text-align: right; margin-top: 20px;">
                    <button @click="fnEdit()">수정</button>
                    <button @click="fnBack()" style="background-color: #888;">뒤로가기</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
                storeId: "${storeId}",
                userId: "${userId}",
                currentMenu: "seller",  // ⭐ 添加：导航栏高亮
                seller: {
                    storeId: "",
                    storeName: "",
                    userId: "",
                    businessNo: "",
                    storeAddr: "",
                    storePass: "",
                    joinCdate: "",
                    rejectReason: "",
                    membership: "",
                    passDate: "",
                    imgPath: ""  // ⭐ 添加：营业执照图片路径
                }
            };
        },
        methods: {
            fnSeller() {
                let self = this;
                $.ajax({
                    url: "/adseller/view.dox",
                    dataType: "json",
                    type: "POST",
                    data: { storeId: self.storeId },
                    success(data) {
                        if (data.result === "success") {
                            // ⭐ 修改：直接赋值整个对象
                            self.seller = data.seller;
                        }
                    }
                });
            },
            
            fnEdit() {
                let self = this;
                
                // ⭐ 添加：表单验证
                if (!self.seller.storeName) {
                    alert("가게 이름을 입력해주세요.");
                    return;
                }
                
                if (!self.seller.storeAddr) {
                    alert("가게 주소를 입력해주세요.");
                    return;
                }
                
                if (self.seller.storePass === 'R' && !self.seller.rejectReason) {
                    alert("거절 사유를 입력해주세요.");
                    return;
                }
                
                if (!confirm("수정하시겠습니까?")) {
                    return;
                }
                
                $.ajax({
                    url: "/adseller/update.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeId: self.seller.storeId,
                        userId: self.seller.userId,
                        storeName: self.seller.storeName,
                        storeAddr: self.seller.storeAddr,
                        storePass: self.seller.storePass,
                        rejectReason: self.seller.rejectReason || null
                    },
                    success(data) {
                        if (data.result === "success") {
                            alert("수정되었습니다.");
                            self.fnBack();
                        } else {
                            alert("수정 중 오류가 발생했습니다.");
                        }
                    }
                });
            },
            
            fnBack() {
                location.href = "/admin/sellerlist.do";
            },
            
            fnBuyerManage() { location.href = "/admin/userlist.do"; },
            fnSellerManage() { location.href = "/admin/sellerlist.do"; },
            fnSalesManage() { location.href = "/admin/chart.do"; },
            fnAdRequest() { location.href = "/admin/ad.do"; },
            fnMembership() { location.href = "/admin/membership.do"; },
            fnMonthlyFee() { location.href = "/admin/monthlyfee.do"; },
            fnQandA() { location.href = "/admin/boardManage.do"; },
            
            fnLogout() {
                if (confirm("로그아웃 하시겠습니까?")) {
                    $.ajax({
                        url: "/user/logout.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success(data) {
                            if (data.result == "success") {
                                alert(data.msg + "! 홈페이지로 이동하겠습니다.");
                                location.href = "/main.do";
                            } else {
                                alert("로그아웃하는 도중에 오류가 발생하였습니다.");
                            }
                        }
                    });
                }
            }
        },
        mounted() {
            this.fnSeller();
        }
    });
    app.mount('#app');
</script>

</html>