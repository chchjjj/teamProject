<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>:: 게시글 관리 ::</title>
        <link rel="stylesheet" href="/css/admin-style.css">
        <link rel="stylesheet" href="/css/productDetail-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            .leftAlign {
                text-align: left;
                margin-bottom: 15px;
            }

            .searchBar.leftAlign {
                display: flex;
                justify-content: flex-start;
                align-items: center;
                gap: 10px;
                margin-bottom: 15px;
            }

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

            .userList input[type="radio"] {
                display: none;
            }

            .userList label {
                position: relative;
                padding-left: 25px;
                cursor: pointer;
                font-weight: 500;
                color: #3E2723;
                user-select: none;
                transition: color 0.2s ease;
            }

            .userList label::before {
                content: '';
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 16px;
                height: 16px;
                border: 2px solid #3E2723;
                border-radius: 50%;
                background-color: #fff;
                transition: all 0.2s ease;
            }

            .userList input[type="radio"]:checked+label::before {
                background-color: #FFEDAC;
                border-color: #3E2723;
            }

            .userList input[type="radio"]:checked+label {
                font-weight: bold;
                color: #3E2723;
            }

            .userList label:hover {
                color: #5D4037;
            }

            .paging {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 5px;
                margin: 25px 0;
            }

            .paging a,
            .paging button {
                display: inline-block;
                margin: 0 3px;
                padding: 5px 10px;
                text-decoration: none;
                color: #3E2723;
                border: 1px solid #3E2723;
                border-radius: 4px;
                transition: all 0.2s ease;
            }

            .paging a.active,
            .paging button:hover {
                background-color: #3E2723;
                color: #FFEDAC;
                border-color: #3E2723;
            }

            .boardSelect {
                margin-bottom: 15px;
                display: flex;
                gap: 20px;
                align-items: center;
            }

            .paging {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 5px;
                margin: 25px 0;
            }

            .paging a,
            .paging button {
                display: inline-block;
                margin: 0 3px;
                padding: 5px 10px;
                text-decoration: none;
                color: #3E2723;
                background-color: #fff;
                border: 1px solid #3E2723;
                border-radius: 4px;
                transition: all 0.2s ease;
            }

            .paging a.active,
            .paging button:hover {
                background-color: #3E2723;
                color: #FFEDAC;
                border-color: #3E2723;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <div class="mainPageContainer">
                <!-- 네비게이션 바 -->
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

                <!-- ========== 1. QnA 리스트 ========== -->
                <div class="userList" v-if="selectedTable==='qnA'">
                    <div class="boardSelect">
                        <input type="radio" id="tab-qna" name="boardManage" value="qnA" v-model="selectedTable">
                        <label for="tab-qna">QnA</label>
                        <input type="radio" id="tab-review" name="boardManage" value="review" v-model="selectedTable">
                        <label for="tab-review">리뷰</label>
                    </div>

                    <div class="searchBar leftAlign">
                        <select v-model="pageSize" @change="fnQnAList">
                            <option value="10">:: 10개씩 ::</option>
                            <option value="15">:: 15개씩 ::</option>
                            <option value="20">:: 20개씩 ::</option>
                        </select>
                        <select v-model="option">
                            <option value="all">:: 전체 ::</option>
                            <option value="userId">질문자</option>
                            <option value="storeId">답변자</option>
                            <option value="questionContent">질문 내용</option>
                            <option value="answerContent">답변 내용</option>
                        </select>
                        <input type="text" v-model="keyWord" @keyup.enter="fnQnAList">
                        <button @click="fnQnAList">검색</button>
                    </div>

                    <table>
                        <tr>
                            <th><input type="checkbox" @click="fnSelectAll"></th>
                            <th>번호</th>
                            <th>질문자</th>
                            <th>질문 내용</th>
                            <th>답변자</th>
                            <th>답변 내용</th>
                            <th>질문 시간</th>
                            <th>답변 시간</th>
                            <th>답변 상태</th>
                        </tr>
                        <tr v-for="qnA in qnAList" :key="qnA.questionId">
                            <td><input type="checkbox" :value="qnA.questionId" v-model="selectItem"></td>
                            <td>{{qnA.questionId}}</td>
                            <td>{{qnA.userId}}</td>
                            <td>{{qnA.questionContent}}</td>
                            <td>{{qnA.storeId}}</td>
                            <td><span v-if="!qnA.answerContent">-</span><span v-else>{{qnA.answerContent}}</span></td>
                            <td>{{qnA.questionDate}}</td>
                            <td>{{qnA.answerDate}}</td>
                            <td><span v-if="qnA.answerContent">완료</span><span v-else>대기</span></td>
                        </tr>
                    </table>

                    <div class="paging">
                        <button v-if="page > 1" @click="fnPre()">◀</button>
                        <a href="javascript:;" v-for="num in pageRangeList" :key="num" @click="fnChange(num)"
                            :class="{active: page === num}">{{ num }}</a>
                        <button v-if="page < pageNum" @click="fnNext()">▶</button>
                    </div>

                    <div style="margin-top: 25px;">
                        <button @click="fnRemoveAll">선택 삭제</button>
                    </div>
                </div>

                <!-- ========== 2. Review 리스트 ========== -->
                <div class="userList" v-if="selectedTable==='review'">
                    <div class="boardSelect">
                        <input type="radio" id="tab-qna2" name="boardManage" value="qnA" v-model="selectedTable">
                        <label for="tab-qna2">QnA</label>
                        <input type="radio" id="tab-review2" name="boardManage" value="review" v-model="selectedTable">
                        <label for="tab-review2">리뷰</label>
                    </div>

                    <div class="searchBar leftAlign">
                        <select v-model="pageSize" @change="fnReviewList">
                            <option value="10">:: 10개씩 ::</option>
                            <option value="15">:: 15개씩 ::</option>
                            <option value="20">:: 20개씩 ::</option>
                        </select>
                        <select v-model="option">
                            <option value="all">:: 전체 ::</option>
                            <option value="userId">구매자</option>
                            <option value="storeId">판매자</option>
                        </select>
                        <input type="text" v-model="keyWord" @keyup.enter="fnReviewList">
                        <button @click="fnReviewList">검색</button>
                    </div>

                    <table>
                        <tr>
                            <th><input type="checkbox" @click="fnSelectAll"></th>
                            <th>리뷰번호</th>
                            <th>주문번호</th>
                            <th>상품</th>
                            <th>작성자</th>
                            <th>판매자</th>
                            <th>평점</th>
                            <th>내용</th>
                            <th>작성시간</th>
                            <th>수정시간</th>
                        </tr>
                        <tr v-for="review in reviewList" :key="review.reviewId">
                            <td><input type="checkbox" :value="review.reviewId" v-model="selectItem"></td>
                            <td>{{review.reviewId}}</td>
                            <td>{{review.orderId}}</td>
                            <td>{{review.proNo}}</td>
                            <td>{{review.userId}}</td>
                            <td>{{review.storeId}}</td>
                            <td>{{review.rating}}</td>
                            <td>{{review.reviewContent}}</td>
                            <td>{{review.cDateTime}}</td>
                            <td>{{review.uDateTime}}</td>
                        </tr>
                    </table>

                    <div class="paging">
                        <button v-if="page > 1" @click="fnPre()">◀</button>
                        <a href="javascript:;" v-for="num in pageRangeList" :key="num" @click="fnChange(num)"
                            :class="{active: page === num}">{{ num }}</a>
                        <button v-if="page < pageNum" @click="fnNext()">▶</button>
                    </div>

                    <div style="margin-top: 25px;">
                        <button @click="fnRemoveAll">선택 삭제</button>
                    </div>
                </div>

            </div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            watch: {
                selectedTable(value) {
                    this.selectItem = [];
                    this.flgAllChecked = false;
                    this.page = 1;
                    if (value === "qnA") {
                        this.fnQnAList();
                    } else if (value === "review") {
                        this.fnReviewList();
                    }
                }
            },
            data() {
                return {
                    currentMenu: "qna",
                    sessionId: "${sessionId}",
                    qnAList: [],
                    reviewList: [],
                    selectedTable: "qnA",
                    selectItem: [],
                    flgAllChecked: false,
                    keyWord: "",
                    option: "all",
                    totalRows: 0,
                    pageRangeList: [],
                    pageSize: 10,
                    page: 1,
                    pageRange: 5,
                    pageNum: 0
                };
            },
            methods: {
                fnQnAList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/adboard/qnalist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.qnAList = data.qnAList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();
                        }
                    });
                },
                fnReviewList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/adboard/reviewlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.reviewList = data.reviewList;
                            self.totalRows = data.totalRows;
                            self.pageNum = Math.ceil(self.totalRows / self.pageSize);
                            self.fnpageRange();
                        }
                    });
                },
                fnSelectAll: function () {
                    let self = this;
                    self.flgAllChecked = !self.flgAllChecked;
                    self.selectItem = [];

                    if (self.flgAllChecked) {
                        if (self.selectedTable === "qnA") {
                            for (let i = 0; i < self.qnAList.length; i++) {
                                self.selectItem.push(self.qnAList[i].questionId);
                            }
                        } else if (self.selectedTable === "review") {
                            for (let i = 0; i < self.reviewList.length; i++) {
                                self.selectItem.push(self.reviewList[i].reviewId);
                            }
                        }
                    }
                },

                fnRemoveAll: function () {
                    let self = this;

                    if (self.selectItem.length === 0) {
                        alert("삭제할 항목을 선택해주세요");
                        return;
                    }

                    if (!confirm("선택한 항목을 삭제하시겠습니까?")) {
                        return;
                    }

                    // URL 결정
                    let url = self.selectedTable === 'qnA'
                        ? "/adboard/qnadeleteall.dox"
                        : "/adboard/reviewdeleteall.dox";

                    // selectItem을 JSON 문자열로 변환
                    let fList = JSON.stringify(self.selectItem);
                    let param = { selectItem: fList };

                    $.ajax({
                        url: url,
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("삭제되었습니다");
                                self.selectItem = [];
                                self.flgAllChecked = false;

                                // 삭제 후 목록 새로고침
                                if (self.selectedTable === 'qnA') {
                                    self.fnQnAList();
                                } else if (self.selectedTable === 'review') {
                                    self.fnReviewList();
                                }
                            } else {
                                alert("오류가 발생하였습니다.")
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("삭제 오류:", error);
                            alert("삭제 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnpageRange: function () {
                    let self = this;
                    self.pageRangeList = [];
                    let startPage = Math.floor((self.page - 1) / self.pageRange) * self.pageRange + 1;
                    let endPage = Math.min(startPage + self.pageRange - 1, self.pageNum);
                    for (let i = startPage; i <= endPage; i++) {
                        self.pageRangeList.push(i);
                    }
                },
                fnChange: function (num) {
                    let self = this;
                    self.page = num;
                    if (self.selectedTable === 'qnA') self.fnQnAList();
                    else if (self.selectedTable === 'review') self.fnReviewList();
                },
                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                        if (self.selectedTable === 'qnA') self.fnQnAList();
                        else if (self.selectedTable === 'review') self.fnReviewList();
                    }
                },
                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                        if (self.selectedTable === 'qnA') self.fnQnAList();
                        else if (self.selectedTable === 'review') self.fnReviewList();
                    }
                },
                fnBuyerManage: function () { location.href = "/admin/userlist.do"; },
                fnSellerManage: function () { location.href = "/admin/sellerlist.do"; },
                fnSalesManage: function () { location.href = "/admin/chart.do"; },
                fnAdRequest: function () { location.href = "/admin/ad.do"; },
                fnMembership: function () { location.href = "/admin/membership.do"; },
                fnMonthlyFee: function () { location.href = "/admin/monthlyfee.do"; },
                fnQandA: function () { location.href = "/admin/boardManage.do"; },
                fnLogout: function () {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        $.ajax({
                            url: "/user/logout.dox",
                            dataType: "json",
                            type: "POST",
                            success: function (data) {
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
                this.fnQnAList();
            }
        });

        app.mount('#app');
    </script>