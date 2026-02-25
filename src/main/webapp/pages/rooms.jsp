<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oceanview.model.Room" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Rooms — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">
    <div class="topbar">
      <span class="topbar-title">Room Status</span>
      <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/reservations?action=new" class="btn btn-sm btn-primary">➕ New Reservation</a>
      </div>
    </div>
    <div class="page">
      <div class="ph"><h1>🛏️ Room Status</h1><p>Live availability of all 12 rooms</p></div>
      <div class="card">
        <div class="ch"><span class="ct">All Rooms</span></div>
        <%List<Room> rooms=(List<Room>)request.getAttribute("rooms");
          if(rooms!=null&&!rooms.isEmpty()){%>
        <div class="tw">
        <table class="dt">
          <thead><tr><th>Room #</th><th>Type</th><th>Floor</th><th>Rate / Night</th><th>Capacity</th><th>Description</th><th>Status</th></tr></thead>
          <tbody>
          <%for(Room rm:rooms){%>
          <tr>
            <td><strong style="color:var(--teal)"><%=rm.getTypeIcon()%> <%=rm.getRoomNumber()%></strong></td>
            <td><%=rm.getRoomType()%></td>
            <td>Floor <%=rm.getFloorNumber()%></td>
            <td><strong>$<%=String.format("%.2f",rm.getRatePerNight())%></strong></td>
            <td><%=rm.getCapacity()%> guests</td>
            <td style="color:var(--muted);font-size:.82rem;max-width:220px"><%=rm.getDescription()!=null?rm.getDescription():""%></td>
            <td><span class="badge <%="AVAILABLE".equals(rm.getStatus())?"badge-available":"badge-occupied"%>">
              <%="AVAILABLE".equals(rm.getStatus())?"✓ Available":"● Occupied"%>
            </span></td>
          </tr>
          <%}%>
          </tbody>
        </table>
        </div>
        <%}else{%>
        <div class="empty"><div class="empty-ico">🛏️</div><p>No rooms found in database.</p></div>
        <%}%>
      </div>
    </div>
  </div>
</div>
</body></html>
