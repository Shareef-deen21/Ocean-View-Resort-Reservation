<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.Reservation" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Bill — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">
    <%Reservation r=(Reservation)request.getAttribute("reservation");%>
    <div class="topbar">
      <span class="topbar-title">Guest Bill</span>
      <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/reservations?action=view&id=<%=r!=null?r.getId():0%>" class="btn btn-sm btn-outline">← Back</a>
        <button onclick="window.print()" class="btn btn-sm btn-primary">🖨️ Print</button>
      </div>
    </div>
    <div class="page">
      <%if(r!=null){%>
      <div class="bill-wrap">
        <div class="bill-top">
          <h2>🌊 Ocean View Resort</h2>
          <p>Galle, Southern Province, Sri Lanka</p>
          <p>reservations@oceanviewgalle.lk &nbsp;|&nbsp; +94 91 2234567</p>
          <div class="res-num">TAX INVOICE &nbsp;#&nbsp; <%=r.getReservationNumber()%></div>
        </div>
        <div class="bill-body">
          <div class="bill-row"><span class="l">Guest Name</span>     <span class="v"><%=r.getGuest().getFullName()%></span></div>
          <div class="bill-row"><span class="l">Contact</span>        <span class="v"><%=r.getGuest().getPhone()%></span></div>
          <div class="bill-row"><span class="l">Address</span>        <span class="v"><%=r.getGuest().getAddress()!=null?r.getGuest().getAddress():"-"%></span></div>
          <div class="bill-row"><span class="l">Room</span>           <span class="v">Room <%=r.getRoom().getRoomNumber()%> — <%=r.getRoom().getRoomType()%></span></div>
          <div class="bill-row"><span class="l">Check-In</span>       <span class="v"><%=r.getCheckInDate()%></span></div>
          <div class="bill-row"><span class="l">Check-Out</span>      <span class="v"><%=r.getCheckOutDate()%></span></div>
          <div class="bill-row"><span class="l">Number of Nights</span><span class="v"><%=r.getNumberOfNights()%> night(s)</span></div>
          <div class="bill-row"><span class="l">Rate per Night</span> <span class="v">USD $<%=String.format("%.2f",r.getRoom().getRatePerNight())%></span></div>
          <hr class="bill-divider" style="border:none;border-top:1px dashed var(--border);margin:8px 0">
          <div class="bill-total">
            <span class="tl">💰 TOTAL AMOUNT DUE</span>
            <span class="tv">USD $<%=String.format("%.2f",r.calculateTotal())%></span>
          </div>
          <p style="margin-top:12px;font-size:.75rem;color:var(--muted);text-align:center">
            Payment is due at check-out. Thank you for choosing Ocean View Resort.
          </p>
        </div>
        <div class="bill-foot">
          🌊 Ocean View Resort &nbsp;·&nbsp; Galle, Sri Lanka &nbsp;·&nbsp; www.oceanviewresort.lk
        </div>
      </div>
      <%}%>
    </div>
  </div>
</div>
</body></html>
