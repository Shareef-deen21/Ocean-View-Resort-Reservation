<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oceanview.model.Reservation" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Reservations — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">
    <div class="topbar">
      <span class="topbar-title">Reservations</span>
      <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/reservations?action=new" class="btn btn-sm btn-primary">➕ New Reservation</a>
      </div>
    </div>
    <div class="page">
      <%if(request.getParameter("msg")!=null){%>
      <div class="alert as"><span class="alert-icon">✅</span><%=request.getParameter("msg")%></div>
      <%}%>
      <div class="card">
        <div class="ch">
          <span class="ct">📋 All Reservations</span>
          <form method="GET" action="<%=request.getContextPath()%>/reservations" class="sbar">
            <input type="text" name="q" placeholder="Search name, number, phone..." value="<%=request.getAttribute("keyword")!=null?request.getAttribute("keyword"):""%>">
            <button type="submit" class="btn btn-sm btn-outline">🔍</button>
            <a href="<%=request.getContextPath()%>/reservations" class="btn btn-sm btn-outline">✕</a>
          </form>
        </div>
        <%List<Reservation> list=(List<Reservation>)request.getAttribute("reservations");
          if(list!=null&&!list.isEmpty()){%>
        <div class="tw">
        <table class="dt">
          <thead><tr><th>Res #</th><th>Guest</th><th>Phone</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Nights</th><th>Total</th><th>Status</th><th>Actions</th></tr></thead>
          <tbody>
          <%for(Reservation r:list){%>
          <tr>
            <td><strong style="color:var(--teal)"><%=r.getReservationNumber()%></strong></td>
            <td><%=r.getGuest().getFullName()%></td>
            <td style="color:var(--muted)"><%=r.getGuest().getPhone()%></td>
            <td>Rm <strong><%=r.getRoom().getRoomNumber()%></strong> <span style="color:var(--muted);font-size:.75rem">(<%=r.getRoom().getRoomType()%>)</span></td>
            <td><%=r.getCheckInDate()%></td>
            <td><%=r.getCheckOutDate()%></td>
            <td style="text-align:center"><%=r.getNumberOfNights()%></td>
            <td><strong>$<%=String.format("%.2f",r.getTotalAmount())%></strong></td>
            <td><span class="badge <%=r.getStatusBadgeClass()%>"><%=r.getStatusLabel()%></span></td>
            <td>
              <div style="display:flex;gap:4px">
                <a href="<%=request.getContextPath()%>/reservations?action=view&id=<%=r.getId()%>" class="btn btn-xs btn-outline">View</a>
                <a href="<%=request.getContextPath()%>/reservations?action=bill&id=<%=r.getId()%>" class="btn btn-xs btn-gold" style="color:#fff">Bill</a>
              </div>
            </td>
          </tr>
          <%}%>
          </tbody>
        </table>
        </div>
        <%}else{%>
        <div class="empty">
          <div class="empty-ico">📋</div>
          <p><%=request.getAttribute("keyword")!=null?"No reservations match your search.":"No reservations yet. Create your first one!"%></p>
          <a href="<%=request.getContextPath()%>/reservations?action=new" class="btn btn-primary" style="margin-top:14px">➕ New Reservation</a>
        </div>
        <%}%>
      </div>
    </div>
  </div>
</div>
</body></html>
