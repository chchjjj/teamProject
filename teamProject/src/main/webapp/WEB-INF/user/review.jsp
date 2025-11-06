<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>qna관리</title>
        <!-- 관리자 스타일시트 -->
        <link rel="stylesheet" href="/css/admin-style.css">
        <link rel="stylesheet" href="/css/productDetail-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->

            <div class="navBar">
                <!---->
                <div class="navButton">
                    <div>
                        <button @click="fnOrderHistory()">주문 내역</button>
                    </div>
                    <div>
                        <button @click="fnWishList()">찜한 상품</button>
                    </div>
                    <div>
                        <button @click="fnChatList()">채팅이력</button>
                    </div>
                    <div>
                        <button @click="fnReview()">내가 쓴 리뷰</button>
                    </div>
                    <div>
                        <button @click="fnQnA()">QnA</button>
                    </div>
                    <div>
                        <button @click="fnUserEdit()">정보수정</button>
                    </div>
                </div>




            <!--2. reviewlist-->
            <div class="userList" v-if="selectedTable==='review'">

                <div>
                    <!--구역이름-->
                    <div>
                        리뷰관리
                    </div>
                    <!--아이콘-->
                    <div></div>
                    <!--선택사항-->
                    <div>

                        <select v-model="pageSize" @change="fnReviewList">
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                        </select>
                        <select v-model="option">
                            <option value="all">::전체::</option>
                            <option value="userId">구매자</option>
                            <option value="storeId">판매자</option>
                        </select>
                        <input type="text" v-model="keyWord">
                        <button @click="fnReviewList">검색</button>
                    </div>

                    <!--태이블-->
                    <table>
                        <tr>
                            <th>선택<input type="checkbox" @click="fnSelectAll"></th>
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
                        <tr v-for="review in reviewList">
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
                </div>


                <!--페이징 구역-->
                <div>
                    <span v-if="page>1">
                        <button @click="fnPre()">◀</button>
                    </span>
                    <a href="javascript:;" v-for="num in pageRangeList" @click="fnChange(num)"
                        :class="{active:page == num}">{{num}}</a>
                    <span v-if="page!=pageNum"><button @click="fnNext()">▶</button></span>
                </div>

                <div>
                    <button @click="fnRemoveAll">
                        선택 삭제
                    </button>
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
                    if (value === "qnA") {
                        this.fnQnAList();
                    } else if (value === "review") {
                        this.fnReviewList();
                    } else if (value === "board") {
                        this.fnBoardList();
                    }

                    // this.selectQnA = [];
                    // this.selectReview = [];
                    // this.selectBoard = [];
                },

            },
            data() {
                return {
                    // 변수 - (key : value)
                    reviewList: [],
                    userId: "${sessionId}",



                    //선택
                    selectItem: [],
                    flgAllChecked: false,

                    //검색

                    keyWord: "",
                    option: "all",

                    //paging에 관한 모든 것
                    totalRows: 0,//전체 목록의 총 행수
                    pageRangeList: [],//화면 페이징을 하는 숫자들이 이루어진 리스트
                    pageSize: 10,//뿌렸을 때 한 페이지에 몇 행
                    page: 1,//지금 페이지
                    pageRange: 5,//한 화면에 몇개 페이지 수 나오게 한다
                    pageNum: 0//목록 전체를 가져오려면 합하여 몇 페지

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                
                fnReviewList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/user/reviewlist.dox",
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
                
                //선택
                fnSelectAll: function () {
                    let self = this;
                    self.flgAllChecked = !self.flgAllChecked;
                    if (self.flgAllChecked) {
                        self.selectItem = [];
                        for (let i = 0; i < self.reviewList.length; i++) {
                            self.selectItem.push(self.reviewList[i].reviewId);
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
                        url: "/user/reviewdeleteall.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("삭제되었습니다");
                                self.page = 1;
                                self.fnReviewList();

                            } else {
                                alert("오류가 발생하였습니다.")
                            }


                        }
                    });
                },

                //수정으로로 이동
                fnEdit: function (userId) {
                    pageChange("/admin/useredit.do", { userId: userId });
                },

                fnUserInfo: function (userId) {
                    pageChange("/admin/userinfo.do", { userId: userId });
                },


                //페이징 메소드:화면에 나오는 페이지를 자동적으로 합산 모든 수량의 페이징을 처리
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
                    if (self.selectedTable === 'qnA') self.fnQnAList();
                    else if (self.selectedTable === 'review') self.fnReviewList();
                    else if (self.selectedTable === 'board') self.fnBoardList();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) self.page--;
                    if (self.selectedTable === 'qnA') self.fnQnAList();
                    else if (self.selectedTable === 'review') self.fnReviewList();
                    else if (self.selectedTable === 'board') self.fnBoardList();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) self.page++;
                    if (self.selectedTable === 'qnA') self.fnQnAList();
                    else if (self.selectedTable === 'review') self.fnReviewList();
                    else if (self.selectedTable === 'board') self.fnBoardList();
                },

                  formatNumber: function (num) {
                    if (!num) return '0';
                    return Number(num).toLocaleString('ko-KR');
                },



                // fnBack:function(){
                //     location.href="/user/userMyPage.do";
                // },

                fnOrderHistory: function () {
                    location.href = "/user/orderHistory.do";
                },


                fnWishList: function () {
                    location.href = "/product/wishlist.do";
                },

                fnChatList: function () {
                    location.href = "/user/chatList.do";
                },


                fnReview: function () {
                    location.href = "/user/review.do";
                },

                fnQnA: function () {
                    location.href = "/user/qnA.do";
                },

                fnUserEdit: function () {
                    location.href = "/user/userEdit.do";
                },

                fnLogout: function () {

                },

                fnChat:function(orderId,chatId){
                    pageChange("/chat/chatBuyer.do",{orderId:orderId,chatId:chatId});
                },

                fnOrderStatus:function(orderId){
                    pageChange("/user/orderStatus.do",{orderId:orderId});
                }


            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnQnAList();

            }
        });

        app.mount('#app');
    </script>