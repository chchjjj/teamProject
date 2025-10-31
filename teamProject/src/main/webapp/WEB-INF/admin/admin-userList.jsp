<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>사용자관리</title>
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

            <!--관리자 마이 페이지의 컨데너 입니다-->
            <div class="mainPageContainer">

                <!--외쪽측 네이버바-->
                <div class="navBar">
                    <!---->
                    <div class="navButton">
                        <div>
                            <button @click="fnAdinMain()">대시보드</button>
                        </div>
                        <div>
                            <button @click="fnBuyerManage()">구매자 관리</button>
                        </div>
                        <div>
                            <button @click="fnSellerManage()">판매자관리</button>
                        </div>
                        <div>
                            <button @click="fnSalesManage()">매출관리</button>
                        </div>
                        <div>
                            <button @click="fnAdRequest()">광고관리</button>
                        </div>
                        <div>
                            <button @click="fnMembership()">맴버쉽관리</button>
                        </div>
                        <div>
                            <button @click="fnQandA()">Q&A</button>
                        </div>
                    </div>

                    <!--logout button-->
                    <div class="logOut">
                        <div>
                            <button @click="fnLogout()">Logout</button>
                        </div>
                    </div>

                </div>

                <!--메인 페이지 바디 내용-->
                <div class="userList">
                    <!--사용자list-->
                    <div>
                        <!--구역이름-->
                        <div>
                            사용자관리
                        </div>
                        <!--아이콘-->
                        <div></div>
                        <!--선택사항-->
                        <div>
                            <select v-model="pageSize" @change="fnUserList">
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                            </select>
                            <select v-model="option">
                                <option value="all">::전체::</option>
                                <option value="userId">사용자 아이디</option>
                                <option value="userName">닉네임</option>
                            </select>
                            <input type="text" v-model="keyWord">
                            <button @click="fnUserList">검색</button>
                        </div>
                        <!--태이블-->
                        <table>
                            <tr>
                                <th>선택<input type="checkbox" @click="fnSelectAll"></th>
                                <th>아이디</th>
                                <th>닉네임</th>
                                <th>연락처</th>
                                <th>이메일</th>
                                <th>주소</th>
                                <th>활동탈퇴여부</th>
                                <th>가입일자</th>
                                <th>권한</th>
                                <th>수정</th>  
                            </tr>
                            <tr v-for="user in userList">
                                <td><input type="checkbox" :value="user.userId" v-model="selectItem"></td>
                                <td>{{user.userId}}</td>
                                <td><a href="javascript:;" @click="fnUserInfo(user.userId)">{{user.userName}}</a></td>
                                <td>{{user.phone}}</td>
                                <td>{{user.email}}</td>
                                <td>{{user.userAddr}}</td>
                                <td>{{user.userStatus}}</td>
                                <td>{{user.joinCdate}}</td>
                                <td>{{user.role}}</td> 
                                <td><button @click="fnEdit(user.userId)">수정</button></td> 
                            </tr>
                        </table>
                    </div>

                    <div>
                        <span v-if="page>1">
                            <button @click="fnPre()">◀</button>
                        </span>
                        <a href="javascript:;" v-for="num in pageRangeList" @click="fnChange(num)"
                            :class="{active:page == num}">{{num}}</a>
                        <span v-if="page!=pageNum"><button @click="fnNext()">▶</button></span>
                    </div>


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
            data() {
                return {
                    // 변수 - (key : value)
                    userList: [],
                    sessionId: "${sessionId}",

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
                fnUserList: function () {
                    let self = this;
                    let param = {
                        option: self.option,
                        keyWord: self.keyWord,
                        offset: (self.page - 1) * self.pageSize,
                        fetchRows: self.pageSize,
                    };
                    $.ajax({
                        url: "/aduser/userlist.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.userList = data.userList;
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
                        for (let i = 0; i < self.userList.length; i++) {
                            self.selectItem.push(self.userList[i].userId);
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
                        url: "/aduser/deleteall.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("삭제되었습니다");
                                self.page = 1;
                                self.fnUserList();

                            } else {
                                alert("오류가 발생하였습니다.")
                            }


                        }
                    });
                },

                //수정 페이지로 이동
                fnEdit: function (userId) {
                    pageChange("/admin/useredit.do",{userId:userId});
                },

                fnUserInfo:function(userId){
                    pageChange("/admin/userinfo.do",{userId:userId});
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
                    self.fnUserList();
                },

                fnPre: function () {
                    let self = this;
                    if (self.page > 1) {
                        self.page--;
                    }
                    self.fnUserList();
                },

                fnNext: function () {
                    let self = this;
                    if (self.page < self.pageNum) {
                        self.page++;
                    }
                    self.fnUserList();

                },

                fnAdminMain:function(){
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

                fnLogout: function () {
                    if (confirm("로그아웃 하시겠습니까?")) {
                        location.href = '#';
                    }
                }




            }, // methods

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnUserList();

            }
        });

        app.mount('#app');
    </script>