<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
               
            <meta charset="UTF-8">
               
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>픽업 일정 확인 캘린더</title>
                   
                   
            <script src="https://code.jquery.com/jquery-3.7.1.js"        
                integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="        
                crossorigin="anonymous"></script>
                   
                   
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

                /* 사이드바 너비만큼 마진 설정 */
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

                #calendar {
                    max-width: 1100px;
                    margin: 0 auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                }

                /* ---------------------- 캘린더 이벤트 시각적 개선 ---------------------- */
                .fc .fc-daygrid-event {
                    white-space: normal !important;
                    height: auto !important;
                    padding: 4px 6px !important;
                    box-sizing: border-box;
                }

                .fc .fc-event-main {
                    display: block !important;
                }

                .fc .fc-daygrid-event .fc-event-title {
                    font-weight: 700;
                    font-size: 12px;
                    line-height: 1.1;
                    color: #111;
                }

                .fc .fc-daygrid-event .fc-event-time {
                    display: none;
                    /* allDay 이벤트이므로 시간 숨김 */
                }

                /* 주소별 색상 구분 */
                .event-location-gangnam {
                    background-color: #007bff !important;
                    border-color: #007bff !important;
                }

                .event-location-daejeon {
                    background-color: #28a745 !important;
                    border-color: #28a745 !important;
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
                    // JSTL/EL 변수 사용 시, 세션이 없거나 JSP에서 EL 처리가 안 될 경우를 대비해 처리
                    const sellerId = "${sessionId}" === "" || "${sessionId}" === "null" || "${sessionId}".startsWith("$") ? null : "${sessionId}";

                    const calendar = new FullCalendar.Calendar(calendarEl, {
                        initialView: 'dayGridMonth',
                        locale: 'ko',
                        editable: false,
                        dayMaxEvents: true, // +n 더보기 묶음을 다시 활성화하는 것이 UI/UX에 더 좋습니다.
                        displayEventTime: false,
                        headerToolbar: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'dayGridMonth,timeGridWeek,timeGridDay'
                        },

                        // FullCalendar에서 날짜가 변경될 때마다 호출되어 이벤트를 로드하는 함수
                        events: function (fetchInfo, successCallback, failureCallback) {
                            // fetchInfo.startStr과 fetchInfo.endStr은 ISO 8601 형식 (예: 2025-10-27T00:00:00+09:00)
                            const startStr = fetchInfo.startStr.substring(0, 10);
                            const endStr = fetchInfo.endStr.substring(0, 10); // FullCalendar가 조회 범위 끝 날짜의 다음날을 주기 때문에 별도 조정 불필요

                            if (!sellerId) {
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
                                    // console.log("✅ 서버 응답:", data); // 성공 시 로그는 주석 처리하여 깔끔하게 유지

                                    const events = data.map(item => {
                                        const orderId = item.ORDER_ID || "N/A";
                                        const address = item.PICKUP_ADDRESS || "주소 미지정";

                                        let className = '';
                                        if (address.includes('강남')) {
                                            className = 'event-location-gangnam';
                                        } else if (address.includes('대전')) {
                                            className = 'event-location-daejeon';
                                        }

                                        return {
                                            id: orderId,
                                            // title: address, // title 대신 eventContent에서 상세 표시
                                            start: item.PICKUP_START_DATE,
                                            // FullCalendar에서 'allDay: true' 이벤트의 end는 표시 기간의 다음 날로 설정해야 함
                                            end: item.PICKUP_END_DATE,
                                            allDay: true,
                                            classNames: [className],
                                            extendedProps: {
                                                orderId: orderId,
                                                address: address
                                            }
                                        };
                                    });

                                    successCallback(events);
                                },
                                error: function (xhr, status, error) {
                                    console.error("픽업 일정 로드 실패:", error, "상태:", status, "XHR:", xhr.responseText);
                                    alert("⚠️ 픽업 일정을 불러오는 데 실패했습니다. 서버 로그를 확인하세요. (HTTP " + xhr.status + ")");
                                    failureCallback();
                                }
                            });
                        },

                        /* ✅ 주문번호 + 주소를 확실히 표시하는 DOM 기반 렌더링 */
                        eventContent: function (arg) {
                            const orderId = arg.event.extendedProps.orderId;
                            const address = arg.event.extendedProps.address;

                            // console.log("📦 렌더링 중 이벤트:", orderId, address); // 렌더링 로그는 주석 처리

                            // 부모 div
                            const wrapper = document.createElement('div');
                            wrapper.className = 'fc-custom-event-wrapper';
                            wrapper.style.textAlign = 'center';
                            wrapper.style.fontSize = '12px';
                            wrapper.style.lineHeight = '1.4';
                            wrapper.style.color = '#fff';

                            // 주문번호 (굵게)
                            const idEl = document.createElement('div');
                            idEl.className = 'fc-event-title';
                            idEl.textContent = `주문 #${orderId}`;
                            idEl.style.fontWeight = 'bold';

                            // 주소 (작게)
                            const addrEl = document.createElement('div');
                            addrEl.style.fontSize = '11px';
                            addrEl.style.lineHeight = '1.1';
                            addrEl.style.marginTop = '2px';
                            addrEl.textContent = address;

                            wrapper.appendChild(idEl);
                            wrapper.appendChild(addrEl);

                            return { domNodes: [wrapper] };
                        },

                        // 이벤트를 클릭했을 때 주문 상세 또는 채팅으로 이동
                        eventClick: function (info) {
                            const orderId = info.event.extendedProps.orderId;
                            if (orderId && orderId !== "N/A") {
                                // 예시: 주문 상세 페이지 또는 판매자 채팅 페이지로 이동
                                window.location.href = `/seller/sellerChat.do?orderId=${orderId}`;
                            } else {
                                alert("⚠️ 주문 ID를 찾을 수 없습니다. (ID: " + orderId + ")");
                            }
                        }
                    });

                    calendar.render();
                });
            </script>

        </body>

        </html>