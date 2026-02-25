<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oceanview.model.Reservation,com.oceanview.model.User" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Dashboard — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">
    <div class="topbar">
      <span class="topbar-title">Dashboard</span>
      <div class="topbar-right">
        <span style="font-size:.78rem;color:var(--muted)" id="dt"></span>
        <%Boolean dbOk=(Boolean)request.getAttribute("dbOk");%>
        <span class="db-pill <%=(dbOk!=null&&dbOk)?"ok":"err"%>">
          <span class="dot"></span>
          DB <%=(dbOk!=null&&dbOk)?"Connected":"Disconnected"%>
        </span>
      </div>
    </div>


    <div class="page">
      <%User cu=(User)session.getAttribute("currentUser");
        int hr=java.time.LocalTime.now().getHour();
        String greet=hr<12?"Morning":hr<18?"Afternoon":"Evening";
        String fn=cu!=null?cu.getFullName().split(" ")[0]:"";%>
      <div class="ph">
        <h1>Good <%=greet%>, <%=fn%> 👋</h1>
        <p>Here's what's happening at Ocean View Resort today</p>
      </div>
      <%if(request.getAttribute("dbError")!=null){%>
      <div class="alert aw"><span class="alert-icon">⚠️</span>
        Database issue: <%=request.getAttribute("dbError")%>.
        Open <strong>DBConnection.java</strong> and update USERNAME/PASSWORD to match your MySQL setup.
      </div>
      <%}%>

      <!-- Stats -->
      <div class="stats">
        <div class="sc"><div class="si t">📋</div><div><div class="sv"><%=request.getAttribute("totalRes")!=null?request.getAttribute("totalRes"):0%></div><div class="sl">Total Reservations</div></div></div>
        <div class="sc"><div class="si g">✅</div><div><div class="sv"><%=request.getAttribute("confirmedCount")!=null?request.getAttribute("confirmedCount"):0%></div><div class="sl">Confirmed</div></div></div>
        <div class="sc"><div class="si o">🔑</div><div><div class="sv"><%=request.getAttribute("checkedInCount")!=null?request.getAttribute("checkedInCount"):0%></div><div class="sl">Checked In</div></div></div>
        <div class="sc"><div class="si p">🛏️</div><div><div class="sv"><%=request.getAttribute("availableRooms")!=null?request.getAttribute("availableRooms"):0%></div><div class="sl">Available Rooms</div></div></div>
        <div class="sc"><div class="si o">💰</div><div>
          <div class="sv" style="font-size:1.2rem">$<%=request.getAttribute("totalRevenue")!=null?String.format("%.0f",(Double)request.getAttribute("totalRevenue")):"0"%></div>
          <div class="sl">Total Revenue</div>
        </div></div>
      </div>

      <div style="display:grid;grid-template-columns:220px 1fr;gap:18px;align-items:start">
        <!-- Quick Actions -->
        <div class="card">
          <div class="ch"><span class="ct">⚡ Quick Actions</span></div>
          <div class="cb" style="display:flex;flex-direction:column;gap:8px">
            <a href="<%=request.getContextPath()%>/reservations?action=new" class="btn btn-primary w-full">➕ New Reservation</a>
            <a href="<%=request.getContextPath()%>/reservations" class="btn btn-outline w-full">📋 All Reservations</a>
            <a href="<%=request.getContextPath()%>/rooms" class="btn btn-outline w-full">🛏️ Room Status</a>
          </div>
        </div>

        <!-- Recent Reservations -->
        <div class="card">
          <div class="ch">
            <span class="ct">📋 Recent Reservations</span>
            <a href="<%=request.getContextPath()%>/reservations" class="btn btn-sm btn-outline">View All</a>
          </div>
          <%List<Reservation> recs=(List<Reservation>)request.getAttribute("recentRes");
            if(recs!=null&&!recs.isEmpty()){int cnt=0;%>
          <div class="tw">
          <table class="dt">
            <thead><tr><th>Res #</th><th>Guest</th><th>Room</th><th>Check-In</th><th>Nights</th><th>Amount</th><th>Status</th><th></th></tr></thead>
            <tbody>
            <%for(Reservation r:recs){if(cnt++>=7)break;%>
            <tr>
              <td><strong style="color:var(--teal)"><%=r.getReservationNumber()%></strong></td>
              <td><%=r.getGuest().getFullName()%></td>
              <td>Rm <%=r.getRoom().getRoomNumber()%></td>
              <td><%=r.getCheckInDate()%></td>
              <td style="text-align:center"><%=r.getNumberOfNights()%></td>
              <td><strong>$<%=String.format("%.2f",r.getTotalAmount())%></strong></td>
              <td><span class="badge <%=r.getStatusBadgeClass()%>"><%=r.getStatusLabel()%></span></td>
              <td><a href="<%=request.getContextPath()%>/reservations?action=view&id=<%=r.getId()%>" class="btn btn-xs btn-outline">View</a></td>
            </tr>
            <%}%>
            </tbody>
          </table>
          </div>
          <%}else{%>
          <div class="empty"><div class="empty-ico">📋</div><p>No reservations yet.<br>Create your first one!</p></div>
          <%}%>
        </div>
      </div>

      <!-- Audit log -->
      <%List<String> log=(List<String>)request.getAttribute("auditLog");
        if(log!=null&&!log.isEmpty()){%>
      <div class="card" style="margin-top:18px">
        <div class="ch"><span class="ct">📜 Command Audit Log</span><span style="font-size:.73rem;color:var(--muted)">Queue (FIFO) — last 100 operations</span></div>
        <div class="cb">
          <div class="audit-log">
            <%for(int i=log.size()-1;i>=0;i--){%><p><%=log.get(i)%></p><%}%>
          </div>
        </div>
      </div>
      <%}%>
    </div>
  </div>
</div>
<script>
  const d=new Date();
  document.getElementById('dt').textContent=d.toLocaleDateString('en-US',{weekday:'long',year:'numeric',month:'long',day:'numeric'});
</script>
</body></html>
