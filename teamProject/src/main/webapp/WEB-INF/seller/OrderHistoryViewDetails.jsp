<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>픽업 일정 확인 캘린더</title>

            <script src="https://code.jquery.com/jquery-3.7.1.js"
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

            <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.css' />
            <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>

            <style>
                body {
                    margin: 0;
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: #f4f4f4;
                }

                .main-wrapper {
                    display: flex;
                    min-height: 100vh;
                }

                /* 사이드바 너비만큼 마진 설정 (사이드바가 왼쪽 220px을 차지한다고 가정) */
                .content-area {
                    flex-grow: 1;
                    padding: 30px;
                    background-color: white;
                    margin-left: 220px;
                    box-sizing: border-box;
                }

                .page-title {
                    font-size: 24px;
                    font-weight: 300;
                    margin-bottom: 20px;
                    color: #333;
                }

                /* 캘린더 컨테이너 스타일 */
                #calendar {
                    max-width: 1100px;
                    margin: 0 auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                }

                /* 캘린더 이벤트 스타일 */
                .fc-event-title {
                    white-space: normal;
                    /* 여러 줄 표시 허용 */
                    font-size: 13px;
                    font-weight: bold;
                    /* 주문번호 강조 */
                }

                /* 주소별 색상 구분 */
                .event-location-gangnam {
                    background-color: #007bff;
                    border-color: #007bff;
                }

                .event-location-daejeon {
                    background-color: #28a745;
                    border-color: #28a745;
                }
            </style>
        </head>

        <body>

            <div class="main-wrapper">
                <div class="content-area">
                    <h1 class="page-title">📅 픽업 일정 확인 캘린더</h1>

                    <div id="calendar"></div>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {

                    const calendarEl = document.getElementById('calendar');

                    if (typeof FullCalendar === 'undefined') {
                        console.error("FullCalendar 라이브러리가 로드되지 않았습니다. `<script>` 태그를 확인하세요.");
                        return;
                    }

                    const sellerId = "${sessionId}";

                    const calendar = new FullCalendar.Calendar(calendarEl, {
                        initialView: 'dayGridMonth',
                        locale: 'ko',
                        editable: false,
                        dayMaxEvents: true,
                        headerToolbar: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'dayGridMonth,timeGridWeek,timeGridDay'
                        },

                        events: function (fetchInfo, successCallback, failureCallback) {

                            const startStr = fetchInfo.startStr.substring(0, 10);
                            const endStr = fetchInfo.endStr.substring(0, 10);

                            if (!sellerId || sellerId.startsWith('$')) {
                                console.warn("sellerId(세션 ID)가 유효하지 않습니다. 데이터 로드를 건너뜁니다.");
                                successCallback([]);
                                return;
                            }

                            $.ajax({
                                url: "/seller/calendar.dox",
                                method: "POST",
                                dataType: "json",
                                data: {
                                    userId: sellerId,
                                    start: startStr,
                                    end: endStr
                                },
                                success: function (data) {

                                    console.log(`✅ AJAX 성공: 픽업 일정 ${data.length}개 로드됨.`);

                                    const events = data.map(item => {
                                        let className = '';
                                        const address = item.PICKUP_ADDRESS || '';
                                        if (address.includes('강남')) {
                                            className = 'event-location-gangnam';
                                        } else if (address.includes('대전')) {
                                            className = 'event-location-daejeon';
                                        }

                                        // 캘린더 셀에 주문 번호를 명확하게 표시
                                        let shortAddress = address.length > 5 ? address.substring(0, 5) + '...' : address;

                                        return {
                                            id: item.ORDER_ID, // 주문 ID
                                            title: `[${item.ORDER_ID}] 픽업 - ${shortAddress}`,
                                            start: item.PICKUP_START_DATE,
                                            end: item.PICKUP_END_DATE,
                                            allDay: true,
                                            classNames: [className]
                                        };
                                    });
                                    successCallback(events);
                                },
                                error: function (xhr, status, error) {
                                    console.error("픽업 일정 로드 실패:", error, "상태:", status, "XHR:", xhr.responseText);
                                    alert("⚠️ 픽업 일정을 불러오는 데 실패했습니다. (HTTP " + xhr.status + ") 서버 로그를 확인해주세요.");
                                    failureCallback();
                                }
                            });
                        },

                        // 💡 이 부분이 핵심 수정 사항입니다.
                        eventClick: function (info) {
                            const orderId = info.event.id;

                            if (orderId) {
                                // 주문 상세 페이지로 해당 주문 ID를 파라미터로 넘겨 이동
                                // 서버에서는 이 orderId로 상세 정보를 조회합니다.
                                window.location.href = `/seller/orderDetail.do?orderId=${orderId}`;
                            } else {
                                alert("⚠️ 주문 ID를 찾을 수 없습니다.");
                            }
                        }
                    });

                    // 캘린더 렌더링 시작
                    calendar.render();
                });
            </script>
        </body>

        </html>