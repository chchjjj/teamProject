
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
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
                        <button>대시보드</button>
                    </div>
                    <div>
                        <button @click="fnBuyerManage()">구매자관리</button>
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
                <!--구매자list-->
                <div>
                    <!--구역이름-->
                    <div>
                        구매자관리
                    </div>
                    <!--아이콘-->
                    <div></div>
                    <!--태이블-->
                    <table>
                        <tr>
                            <th>아이디</th>
                            <th>닉네임</th>
                            <th>연락처</th>
                            <th>이메일</th>
                            <th>주소</th>
                            <th>활동탈퇴여부</th>
                            <th>가입일자</th>
                            <th>권한</th>
                            <th>선택</th>                            
                        </tr>
                        <tr v-for="user in userList">
                            <td>{{user.userId}}</td>
                            <td>{{user.userName}}</td>
                            <td>{{user.phone}}</td>
                            <td>{{user.email}}</td>
                            <td>{{user.userAddr}}</td>
                            <td>{{user.userStatus}}</td>
                            <td>{{user.joinCdate}}</td>
                            <td>{{user.role}}</td>
                            <td><input type="checkbox" :value="user.userId" v-model="selectItem" @click="fnSelect"></td>
                        </tr>
                    </table>
                </div>

                 <div>
                    <span v-if="page>1">
                        <button @click="fnPre()">◀</button>
                    </span>
                    <a href="javascript:;" v-for="num in pageRangeList" @click="fnChange(num)" :class="{active:page == num}">{{num}}</a>
                    <span v-if="page!=pageNum"><button @click="fnNext()">▶</button></span>
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
                userList:[],

                //선택
                selectItem:[],
               

                //paging에 관한 모든 것
                pageRangeList:[],//화면 페이징을 하는 숫자들이 이루어진 리스트
                pageSize:5,
                page:1,
                pageRange:5,//한 화면에 5페지 씩 나오게 한다
                pageNum:0

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnUserList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/aduser/userList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.userList=data.userList;

                    }
                });
            },

            //선택
            fnEdit:function(){
                let self = this;

                let fList = JSON.stringify(self.selectItem);//把selectItem变成json形式
                let param = {selectItem : fList};

                $.ajax({
                    url: "/user/edit.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
						if(data.result=="success"){
                            alert("수정되었습니다");

                        }else{
                            alert("오류가 발생하였습니다.")
                        }
                        
						
                    }
                });
            },


            //페이징 메소드:모든 수량의 페이징을 처리
            //이게 걱정할 필요가 없습니다. 원래 실습대로 다하면 자동적으로 계산됩니다.
            fnpageRange:function(){
                let self=this;
                self.pageRangeList = [];  
                // 만약에 한화면의 페이지수가 10이라면 0~9 범위에서 나온 값이 floor해서 하나의 숫자가 나오고, 1~10 범위를 만들고 싶다면 0~9에서 나온 값에 +1만 해주면 됩니다.
                // 화면에 떠있는 시작 페이지
                let startPage = Math.floor((self.page - 1) / self.pageRange) * self.pageRange + 1;
                // 화면에 떠있는 마지막 페이지
                let endPage = Math.min(startPage + self.pageRange - 1, self.pageNum);
   
                for(let i = startPage; i <= endPage; i++){
                self.pageRangeList.push(i);
                }
            },


        }, // methods
        
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnUserList();
            self.fnSellerList();
        }
    });

    app.mount('#app');
</script>


