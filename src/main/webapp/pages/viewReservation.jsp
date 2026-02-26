<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.Reservation" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>View Reservation — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">
    <%Reservation r=(Reservation)request.getAttribute("reservation");%>
    <div class="topbar">
      <span class="topbar-title">Reservation Details</span>
      <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/reservations" class="btn btn-sm btn-outline">← Back</a>
        <%if(r!=null){%>
        <a href="<%=request.getContextPath()%>/reservations?action=bill&id=<%=r.getId()%>" class="btn btn-sm btn-gold" style="color:#fff">🧾 Print Bill</a>
        <%}%>
      </div>
    </div>
    <div class="page">
      <%if(request.getAttribute("success")!=null){%>
      <div class="alert as"><span class="alert-icon">✅</span><%=request.getAttribute("success")%></div>
      <%}%>
      <%if(request.getParameter("msg")!=null){%>
      <div class="alert as"><span class="alert-icon">✅</span><%=request.getParameter("msg")%></div>
      <%}%>

      <%if(r!=null){%>
      <div class="ph">
        <h1>Reservation <%=r.getReservationNumber()%></h1>
        <p>Created on <%=r.getCheckInDate()%> · <span class="badge <%=r.getStatusBadgeClass()%>"><%=r.getStatusLabel()%></span></p>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
        <!-- Guest Info -->
        <div class="card">
          <div class="ch"><span class="ct">👤 Guest Information</span></div>
          <table class="ddt">
            <tr><th>Full Name</th><td><strong><%=r.getGuest().getFullName()%></strong></td></tr>
            <tr><th>Email</th><td><%=r.getGuest().getEmail()!=null?r.getGuest().getEmail():"-"%></td></tr>
            <tr><th>Phone</th><td><%=r.getGuest().getPhone()%></td></tr>
            <tr><th>Address</th><td><%=r.getGuest().getAddress()!=null?r.getGuest().getAddress():"-"%></td></tr>
            <tr><th>Nationality</th><td><%=r.getGuest().getNationality()!=null?r.getGuest().getNationality():"-"%></td></tr>
            <tr><th>ID</th><td><%=r.getGuest().getIdType()!=null?r.getGuest().getIdType():""%> <%=r.getGuest().getIdNumber()!=null?r.getGuest().getIdNumber():""%></td></tr>
          </table>
        </div>

        <!-- Booking Info -->
        <div class="card">
          <div class="ch"><span class="ct">🏨 Booking Details</span></div>
          <table class="ddt">
            <tr><th>Room</th><td><strong>Room <%=r.getRoom().getRoomNumber()%></strong> — <%=r.getRoom().getTypeIcon()%> <%=r.getRoom().getRoomType()%></td></tr>
            <tr><th>Floor</th><td>Floor <%=r.getRoom().getFloorNumber()%></td></tr>
            <tr><th>Check-In</th><td><%=r.getCheckInDate()%></td></tr>
            <tr><th>Check-Out</th><td><%=r.getCheckOutDate()%></td></tr>
            <tr><th>Nights</th><td><strong><%=r.getNumberOfNights()%></strong> night(s)</td></tr>
            <tr><th>Guests</th><td><%=r.getNumGuests()%> guest(s)</td></tr>
            <tr><th>Rate / Night</th><td>USD $<%=String.format("%.2f",r.getRoom().getRatePerNight())%></td></tr>
            <tr><th>Total Amount</th><td><strong style="color:var(--gold);font-size:1.1rem">USD $<%=String.format("%.2f",r.calculateTotal())%></strong></td></tr>
          </table>
        </div>
      </div>

      <%if(r.getSpecialRequests()!=null&&!r.getSpecialRequests().isEmpty()){%>
      <div class="card" style="margin-top:14px">
        <div class="ch"><span class="ct">📝 Special Requests</span></div>
        <div class="cb" style="font-size:.875rem"><%=r.getSpecialRequests()%></div>
      </div>
      <%}%>

      <!-- Status Actions -->
      <div class="card" style="margin-top:14px">
        <div class="ch"><span class="ct">⚙️ Update Status</span></div>
        <div class="cb">
          <div class="sa">
            <% if(!"CHECKED_IN".equals(r.getStatus())&&!"CHECKED_OUT".equals(r.getStatus())&&!"CANCELLED".equals(r.getStatus())){%>
            <a href="<%=request.getContextPath()%>/reservations?action=status&id=<%=r.getId()%>&status=CHECKED_IN" class="btn btn-success">🔑 Check In</a>
            <%}%>
            <%if("CHECKED_IN".equals(r.getStatus())){%>
            <a href="<%=request.getContextPath()%>/reservations?action=status&id=<%=r.getId()%>&status=CHECKED_OUT" class="btn btn-outline">🚪 Check Out</a>
            <%}%>
            <%if(!"CANCELLED".equals(r.getStatus())&&!"CHECKED_OUT".equals(r.getStatus())){%>
            <a href="<%=request.getContextPath()%>/reservations?action=status&id=<%=r.getId()%>&status=CANCELLED" class="btn btn-danger" onclick="return confirm('Cancel this reservation?')">✕ Cancel</a>
            <%}%>
            <a href="<%=request.getContextPath()%>/reservations?action=bill&id=<%=r.getId()%>" class="btn btn-gold" style="color:#fff">🧾 Generate Bill</a>
          </div>
        </div>
      </div>
      <%}%>
    </div>
  </div>
</div>
</body></html>
