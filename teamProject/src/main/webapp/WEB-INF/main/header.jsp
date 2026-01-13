<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String sessionId=(String) session.getAttribute("sessionId"); request.setAttribute("sessionId", sessionId); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>헤더</title>
            <link rel="stylesheet" href="/css/main-style.css">

            <!-- mitt 불러오기 (먼저!) -->
            <script src="https://unpkg.com/mitt/dist/mitt.umd.js"></script>

            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=search" />

            <!--페이지 이동-->
            <script src="/js/page-change.js"></script>
            <style>
            </style>
        </head>

        <body>
            <div id="header">

                <header class="top-header">
                    <div class="header-inner">
                        <div class="logo">
                            <div class="logo">
                                <a href="javascript:;" onclick="location.href='/main.do'">
                                    <!--로고 클릭시 홈페이지 새로고침 -->
                                    <img src="/img/로고.png" alt="쇼핑몰 로고">
                                </a>
                            </div>
                        </div>
                        <div class="search-and-user-area">
                            <div class="search-box">
                                <input v-model="keyword" @keyup.enter="fnSearch" type="text"
                                    placeholder="검색 키워드를 입력해주세요.">
                                <button @click="fnSearch">
                                    <span class="material-symbols-outlined">
                                        search
                                    </span>
                                </button>
                            </div>
                            <div class="user-menu">
                                <img src="/img/찜.png" alt="찜 목록" @click="fnWishList"> <!--하트 그림-->
                                <div style="position: relative; display: inline-block;">
                                    <img src="/img/메세지.png" alt="메시지 목록" @click="fnChatList">
                                    <span v-if="totalUnread > 0" class="unread-badge">{{totalUnread}}</span>
                                </div>
                                <img :src="userIcon" :alt="userAlt" @click="fnUserToggle"> <!--로그인/로그아웃-->
                            </div>


                        </div>
                        <!--관리자 로그인시 헤더에 문구 표시-->
                        <div v-if="userId === 'admin'" class="admin-notice">관리자 로그인 중</div>
                </header>

                <nav class="main-nav-container">
                    <div class="nav-inner">
                        <ul class="main-menu">
                            <li class="menu-item dropdown">
                                <a href="#">카테고리</a>
                                <ul class="submenu">
                                    <li><a href="#" @click="fnCategory('케이크')">케이크</a></li>
                                    <li><a href="#" @click="fnCategory('쿠키')">쿠키</a></li>
                                    <li><a href="#" @click="fnCategory('초콜릿')">초콜릿/사탕</a></li>
                                </ul>
                            </li>
                            <!-- <li class="menu-item dropdown">
                            <a href="#">베스트</a>
                            <ul class="submenu">
                                <li><a href="#" @click="fnBestItem(1)">인기 상품 1위</a></li>
                                <li><a href="#" @click="fnBestItem(2)">인기 상품 2위</a></li>
                                <li><a href="#" @click="fnBestItem(3)">인기 상품 3위</a></li>
                            </ul>
                        </li> -->
                            <li class="menu-item"><a href="#" @click="fnAllergyFree">알레르기 프리</a></li>
                            <li class="menu-item"><a href="#" @click="fnApplyStore">입점하기</a></li>
                            <li class="menu-item"><a href="#" @click="fnMypage">마이페이지</a></li>
                            <li class="menu-item"><a href="#" @click="fnQnA">QnA</a></li>
                        </ul>
                    </div>
                </nav>
            </div>
        </body>

        </html>

        <script>
            // ★ mitt 전역 공유 선언 
            window.emitter = window.emitter || mitt();

            const header = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)                    
                        keyword: "", // 검색어
                        userId: "${sessionId}", // 로그인 했을 시 전달 받은 아이디
                        userIcon: "", // 로그인 상태에 따라 이미지 변경
                        userAlt: "",  // 로그인 상태 이미지 대체 텍스트
                        totalUnread: 0,//추가 안읽은 메세지 수
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())


                    //  검색(돋보기) 클릭시 
                    fnSearch: function () {
                        let self = this;
                        if (!self.keyword || self.keyword.trim() === '') {
                            alert("검색어를 입력해주세요.");
                            return;
                        }

                        // 현재 페이지 경로 확인
                        const currentPath = window.location.pathname;

                        if (currentPath === "/main/main.do") {
                            // main 페이지면 emit만 (검색어 전달)
                            // keyword가 유효할 때만 main.jsp (상위 컴포넌트)에 이벤트 전송
                            emitter.emit('keyword', self.keyword); // 보내는 이름도 keyword (main.jsp에서 구현해야함)
                        } else {
                            // main 페이지가 아니면 main.do로 이동
                            location.href = "/main.do?keyword=" + encodeURIComponent(self.keyword);
                        }

                    },

                    // 위시리스트(하트) 클릭 시 (오른쪽 상단)
                    fnWishList: function () {
                        let self = this;
                        if (self.userId == "" || self.userId == null) {
                            alert("로그인 후 이용해주세요!");
                            location.href = "/user/login.do"; // 로그인 페이지 이동
                        } else {
                            pageChange("/product/wishlist.do", { userId: self.userId });
                        }
                    },

                    // 사람모양 & 전원모양 클릭 시 (로그인 / 로그아웃 토글)
                    fnUserToggle: function () {
                        let self = this;

                        // 세션 정보가 없을 경우 → 로그인 페이지로 이동
                        if (self.userId == "" || self.userId == null) {
                            location.href = "/user/login.do";
                        }

                        // 세션 정보가 있을 경우 → 로그아웃 실행
                        else if (confirm("로그아웃 하시겠습니까?")) {
                            self.fnLogout();
                        }
                    },

                    // 로그아웃 기능
                    fnLogout: function () {
                        let self = this;
                        let param = {
                        };
                        $.ajax({
                            url: "/user/logout.dox", // 로그아웃 url 주소
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert(data.msg);
                                self.setUserIcon(); // 아이콘도 로그인용으로 변경
                                location.href = "/main.do";
                            }
                        });
                    },

                    // 로그인 상태에 따른 아이콘 이미지 설정
                    setUserIcon: function () {
                        let self = this;
                        if (self.userId == "" || self.userId == null) {
                            self.userIcon = "/img/마이페이지.png"; // 로그인 전 아이콘
                            self.userAlt = "로그인 아이콘";
                        } else {
                            self.userIcon = "/img/로그아웃.png"; // 로그인 상태 아이콘
                            self.userAlt = "로그아웃 아이콘";
                        }
                    },

                    // '마이페이지' 메뉴 클릭 시 
                    fnMypage: function () {
                        let self = this;

                        if (self.userId == "" || self.userId == null) {
                            alert("로그인 후 이용해주세요!");
                            location.href = "/user/login.do";
                            return;
                        }

                        // userId 정보 있을 때 
                        $.ajax({
                            type: "POST",
                            url: "/main/userInfo.dox",
                            data: { userId: self.userId },
                            dataType: "json",
                            success: function (data) {
                                if (data.info.role === "C") {
                                    pageChange("/user/userMyPage.do", { userId: self.userId });
                                } else if (data.info.role === "S") {
                                    pageChange("/seller/sales.do", { userId: self.userId });
                                } else if (data.info.role === "A") {
                                    pageChange("/admin/userlist.do", { userId: self.userId });
                                    // 관리자 마이페이지는 우선 userList로 연결
                                } else {
                                    alert("알 수 없는 권한입니다. 관리자에게 문의해주세요.");
                                }
                            },
                            error: function () {
                                alert("권한 정보를 불러오지 못했습니다.");
                            }
                        });
                    },

                    // '카테고리' 메뉴에서 각 하위 메뉴 클릭 시
                    fnCategory: function (categoryName) {

                        // 현재 페이지 경로 확인
                        const currentPath = window.location.pathname;

                        // 선택한 카테고리를 main으로 전달
                        //window.emitter.emit('categoryClick', categoryName);

                        if (currentPath === "/main/main.do") {
                            // main 페이지면 emit만 
                            emitter.emit('categoryClick', categoryName);
                        } else {
                            // main 페이지가 아니면 main.do로 이동
                            location.href = "/main.do?category=" + encodeURIComponent(categoryName);
                        }

                    },

                    // '베스트' 메뉴에서 하위 1, 2, 3위 각 클릭 시
                    fnBestItem: function (rank) {
                        window.emitter.emit('bestClick', rank); // rank = 1, 2, 3
                    },

                    // '알레르기 프리' 메뉴 (userId 보내야할까? 거기서 구매로 이어진다면?)
                    fnAllergyFree: function () {
                        let self = this;
                        location.href = "/main/allergyFree.do";
                    },

                    // '입점하기' 메뉴 
                    fnApplyStore: function () {
                        let self = this;
                        if (self.userId == "" || self.userId == null) {
                            alert("로그인 후 이용해주세요!");
                            location.href = "/user/login.do"; // 로그인 페이지 이동
                        } else {
                            pageChange("/applyStore.do", { userId: self.userId });
                        }
                    },

                    // QnA 메뉴 (비로그인자도 접속은 가능) - 구매자 전체 QnA 목록 보여줌
                    fnQnA: function () {
                        let self = this;
                        pageChange("/main/qna.do", { userId: self.userId });
                        // userId 없으면 undefined
                    },



                    //로그인아이디의 권한에 따라 변동
                    fnChatList: function () {
                        let self = this;

                        // 1. 로그인 체크
                        if (self.userId == "" || self.userId == null || self.userId == "null") {
                            alert("로그인 후 이용해주세요!");
                            location.href = "/user/login.do";
                            return;
                        }

                        // 2. 권한 확인 후 페이지 이동
                        $.ajax({
                            type: "POST",
                            url: "/main/userInfo.dox", // 기존 fnMypage에서 사용하던 권한 체크 경로
                            data: { userId: self.userId },
                            dataType: "json",
                            success: function (data) {
                                // data.info.role 값에 따라 분기
                                if (data.info.role === "C") {
                                    // 구매자(Customer)일 경우
                                    location.href = "/user/chatList.do";
                                } else if (data.info.role === "S") {
                                    // 판매자(Seller)일 경우
                                    location.href = "/seller/salesHistory.do";
                                } else if (data.info.role === "A") {
                                    // 관리자(Admin)일 경우 (필요시 추가)
                                    location.href = "/admin/userlist.do";
                                } else {
                                    alert("권한 정보를 확인할 수 없습니다.");
                                }
                            },
                            error: function () {
                                alert("연결 오류가 발생했습니다.");
                            }
                        });
                    },

                    // 안 읽은 메시지 수 가져오기 (하나로 합침)
                    fnGetUnreadCount: function () {
                        let self = this;
                        // 비로그인이거나 null 문자열일 경우 차단
                        if (!self.userId || self.userId === "" || self.userId === "null") return;

                        $.ajax({
                            url: "/seller/unreadCount.dox",
                            type: "POST",
                            data: { userId: self.userId },
                            success: function (data) {
                                // 서버에서 넘어온 count 값을 totalUnread에 저장
                                self.totalUnread = data.count || 0;
                            },
                            error: function () {
                                console.log("알림 개수를 가져오는데 실패했습니다.");
                            }
                        });
                    },

                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    // console.log(self.userId); // 로그인 아이디 있나 콘솔 찍어보기
                    self.setUserIcon(); // 로그인/로그아웃 아이콘 반영
                    // 30초마다 한 번씩 새 메시지 있는지 확인 (폴링)
                    if (self.userId) {
                        self.fnGetUnreadCount(); // 페이지 로드 시 즉시 실행

                        setInterval(() => {
                            self.fnGetUnreadCount();
                        }, 30000);
                    }
                }
            });

            header.mount('#header');
        </script>