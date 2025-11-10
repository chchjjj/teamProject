<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 판매자 관리 ::</title>
        <link rel="stylesheet" href="/css/admin-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>

            .section-title {
                font-weight: bold;
                font-size: 18px;
                padding: 10px 0;
                border-bottom: 2px solid #3E2723; /* 진한 검은색 라인 */
                margin-bottom: 15px; /* 아래 테이블과 여백 */
            }

            /* ===== 관리자 테이블 공통 스타일 ===== */
            table {
                width: 100%;
                border-collapse: collapse;
                font-family: 'Arial', sans-serif;
                margin-top: 10px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            th,
            td {
                padding: 10px 15px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #3E2723;
                color: #FFEDAC;
                font-weight: bold;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #F4C9D6;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            td {
                color: #333;
            }

            select,
            input[type="text"] {
                padding: 5px 8px;
                margin: 5px 0;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            button {
                padding: 6px 12px;
                background-color: #3E2723;
                color: #FFEDAC;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            button:hover {
                background-color: #5D4037;
            }

            /* ===== 페이지네이션 전용 스타일 ===== */
            .paging {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin-top: 28px;
                flex-wrap: wrap;
            }

            .paging button {
                background: #fff;
                color: #3E2723;
                border: 1px solid #ddd;
                border-radius: 6px;
                padding: 7px 12px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.2s;
            }

            .paging button:hover {
                background: #3E2723;
                color: #FFEDAC;
            }

            .paging button.active {
                background: #3E2723;
                color: #FFEDAC;
                border-color: #3E2723;
            }

            @media (max-width: 480px) {
                .paging {
                    gap: 5px;
                    margin-top: 18px;
                }

                .paging button {
                    padding: 6px 9px;
                    border-radius: 5px;
                    font-size: 13px;
                }
            }

            
            th, td {
                font-size: 12px;
                padding: 8px 10px;
            }

            a{
                text-decoration: none;
                color : brown;
            }

        </style>
    </head>

    <body>
        <div id="app">
            <div class="mainPageContainer">
                <div class="navBar">
                    <div class="logo">
                        <a href="javascript:;" onclick="location.href='/main.do'">
                            <img src="/img/로고.png" alt="쇼핑몰 로고">
                        </a>
                    </div>
                    <div class="navButton">
                        <div><button @click="fnBuyerManage()" :class="{active: currentMenu==='buyer'}">전체 유저 관리</button>
                        </div>
                        <div><button @click="fnSellerManage()" :class="{active: currentMenu==='seller'}">판매자관리</button>
                        </div>
                        <div><button @click="fnSalesManage()" :class="{active: currentMenu==='money'}">매출관리</button>
                        </div>
                        <div><button @click="fnAdRequest()" :class="{active: currentMenu==='ad'}">광고관리</button></div>
                        <div><button @click="fnMembership()"
                                :class="{active: currentMenu==='membership'}">맴버쉽관리</button></div>
                        <div><button @click="fnMonthlyFee()" :class="{active: currentMenu==='month'}">판매자 월 정산결과
                                조회</button></div>
                        <div><button @click="fnQandA()" :class="{active: currentMenu==='qna'}">게시글 관리</button></div>
                    </div>
                    <div class="logOut">
                        <div><button @click="fnLogout()">Logout</button></div>
                    </div>
                </div>

                <div class="sellerList">
                    <div>
                        <div class="section-title">판매자관리</div>
                        <div></div>
                        <div>
                            <select v-model="pageSize" @change="fnSellerList">
                                <option value="5">:: 5개씩 ::</option>
                                <option value="15">:: 10개씩 ::</option>
                                <option value="20">:: 20개씩 ::</option>
                            </select>
                            <select v-model="option">
                                <option value="all">::전체::</option>
                                <option value="storeId">가게번호</option>
                                <option value="storeName">가게이름</option>
                            </select>
                            <input type="text" v-model="keyWord" @keyup.enter="fnSellerList">
                            <button @click="fnSellerList">검색</button>
                        </div>
                        <div style="font-size:15px"><input type="checkbox" @click="fnApp">입점신청서 관리</div>

                        <table>
                            <tr>
                                <th><input type="checkbox" @click="fnSelectAll"></th>
                                <th>가게 번호</th>
                                <th>가게 이름</th>
                                <th>소유자 사용자 아이디</th>
                                <th>사업자 번호</th>
                                <th>가게 주소</th>
                                <th>입점 승인여부</th>
                                <th>가입일자</th>
                                <th>입점거절 사유</th>
                                <th>맴버십 가입 여부 </th>
                                <th>등록 일자</th>
                                <th v-if="flgApp===false">가게승인 일자</th>
                                <th>수정</th>
                            </tr>
                            <tr v-for="seller in sellerList">
                                <td><input type="checkbox" :value="seller.storeId" v-model="selectItem"></td>
                                <td>{{seller.storeId}}</td>
                                <td><a href="javascript:;"
                                        @click="fnSellerInfo(seller.storeName)">{{seller.storeName}}</a></td>
                                <td>{{seller.userId}}</td>
                                <td>{{seller.businessNo}}</td>
                                <td>{{seller.storeAddr}}</td>
                                <td>
                                    <span v-if="seller.storePass==='P'">승인</span>
                                    <span v-if="seller.storePass==='G'">승인대기</span>
                                    <span v-if="seller.storePass==='R'">거절</span>
                                </td>
                                <td>{{seller.joinCdate}}</td>
                                <td><span v-if="seller.rejectReason===null">-</span><span
                                        v-else>{{seller.rejectReason}}</span></td>
                                <td>
                                    <span v-if="seller.membership==='Y'">가입</span>
                                    <span v-if="seller.membership==='N'">미가입</span>
                                </td>
                                <td>{{seller.regDate}}</td>
                                <td v-if="flgApp===false"><span v-if="seller.passDate">{{seller.passDate}}</span><span
                                        v-else>-</span></td>
                                <td><button @click="fnEdit(seller.storeId,seller.userId)"><span v-if="flgApp===true">신청내역
                                            보기</span><span v-if="flgApp===false">수정</span></button></td>
                            </tr>
                        </table>
                        <div>
                            <button @click="fnRemoveAll">선택 삭제</button>
                        </div>
                    </div>

                    <!-- 페이지네이션 (逻辑不动，只改样式) -->
                    <div class="paging">
                        <button @click="fnPre" :disabled="page <= 1">◀</button>

                        <button v-for="num in pageRangeList" :key="num" @click="fnChange(num)"
                            :class="{ active: page === num }">{{ num }}</button>

                        <button @click="fnNext" :disabled="page >= pageNum">▶</button>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>


    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    sellerList: [],
                    sessionId: "${sessionId}",

                    currentMenu: "seller",

                    //선택
                    selectItem: [],
                    flgAllChecked: false,

                    //검색

                    keyWord: "",
                    option: "all",

                    //paging에 관한 모든 것
                    totalRows: 0,//전체 목록의 총 행수
                    pageRangeList: [],//화면 페이징을 하는 숫자들이 이루어진 리스트
                    pageSize: 5,//뿌렸을 때 한 페이지에 몇 행
                    page: 1,//지금 페이지
                    pageRange: 5,//한 화면에 몇개 페이지 수 나오게 한다
                    pageNum: 0,//목록 전체를 가져오려면 합하여 몇 페지

                    //신청서 관리
                    flgApp: false

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnSellerList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        flgApp: self.flgApp,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/adseller/sellerlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.sellerList = data.sellerList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();
                        }
                    });
                },

                //선택
                fnSelectAll: function () {
                    let self = this;
                    self.flgAllChecked = !self.flgAllChecked;
                    if (self.flgAllChecked) {
                        self.selectItem = [];
                        for (let i = 0; i < self.sellerList.length; i++) {
                            self.selectItem.push(self.sellerList[i].storeId);
                        }
                    } else {
                        self.selectItem = [];
                    }


                },

                //전체 삭제
                fnRemoveAll: function () {
                    let self = this;

                    if (self.selectItem.length === 0) {
                        alert("삭제할 항목을 선택해주세요");
                        return;
                    }

                    if (!confirm("선택한 항목을 삭제하시겠습니까?")) {
                        return;
                    }

                    let fList = JSON.stringify(self.selectItem);//把selectItem变成json形式
                    let param = { selectItem: fList };

                    $.ajax({
                        url: "/adseller/deleteall.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("삭제되었습니다");
                                self.page = 1;
                                self.fnSellerList();

                            } else {
                                alert("오류가 발생하였습니다.")
                            }


                        }
                    });
                },

                //수정 페이지로 이동
                fnEdit: function (storeId,userId) {
                    pageChange("/admin/selleredit.do", { storeId: storeId,userId:userId});
                },

                fnSellerInfo: function (storeName) {
                    pageChange("/admin/sellerchart.do", { storeName: storeName });
                },


                //페이징 메소드:모든 수량의 페이징을 처리
                //이게 걱정할 필요가 없습니다. 원래 실습대로 다하면 자동적으로 계산됩니다.
                fnpageRange: function () {
                    let self = this;
                    self.pageRangeList = [];
                    // 만약에 한화면의 페이지수가 10이라면 0~9 범위에서 나온 값이 floor해서 하나의 숫자가 나오고, 1~10 범위를 만들고 싶다면 0~9에서 나온 값에 +1만 해주면 됩니다.
                    // 화면에 떠있는 시작 페이지
                    let startPage = Math.floor((self.page - 1) / self.pageRange) * self.pageRange + 1;
                    // 화면에 떠있는 마지막 페이지
                    let endPage = Math.min(startPage + self.pageRange - 1, self.pageNum);

                    for (let i = startPage; i <= endPage; i++) {
                        self.pageRangeList.push(i);
                    }
                },

                fnChange: function (num) {
                    let self = this;
                    self.page = num;
                    self.fnSellerList();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                    }
                    self.fnSellerList();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                    }
                    self.fnSellerList();

                },

                // '입점신청서 보기' 눌렀을 때
                fnApp: function () {
                    let self = this;
                    self.flgApp = !self.flgApp;
                    self.fnSellerList();

                },

                fnAdminMain: function () {
                    location.href = "/admin/main.do";
                },


                fnBuyerManage: function () {
                    location.href = "/admin/userlist.do";
                },

                fnSellerManage: function () {
                    location.href = "/admin/sellerlist.do";
                },


                fnSalesManage: function () {
                    location.href = "/admin/chart.do";
                },

                fnAdRequest: function () {
                    location.href = "/admin/ad.do";
                },

                fnMembership: function () {
                    location.href = "/admin/membership.do";
                },

                fnQandA: function () {
                    location.href = "/admin/boardManage.do";
                },

                fnMonthlyFee: function () {
                    location.href = "/admin/monthlyfee.do";
                },

                fnLogout: function () {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        let param = {};
                        $.ajax({
                            url: "/user/logout.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if(data.result=="success"){
                                    alert(data.msg+"! 홈페이지로 이동하겠습니다.");
                                    location.href = "/main.do";
                                }else{
                                    alert("로그아웃하는 도중에 오류가 발생하였습니다.");
                                }
                                    
                            }
                            
                        });
                    }
                },

               




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnSellerList();

            }
        });

        app.mount('#app');
    </script>