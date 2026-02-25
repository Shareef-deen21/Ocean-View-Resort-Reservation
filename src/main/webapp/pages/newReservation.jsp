<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oceanview.model.Room" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>New Reservation — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">
    <div class="topbar">
      <span class="topbar-title">New Reservation</span>
      <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/reservations" class="btn btn-sm btn-outline">← Back</a>
      </div>
    </div>
    <div class="page">
      <div class="ph"><h1>➕ New Reservation</h1><p>Complete all sections to register a new guest</p></div>
      <%if(request.getAttribute("error")!=null){%>
      <div class="alert ae"><span class="alert-icon">⚠️</span><%=request.getAttribute("error")%></div>
      <%}%>

      <form method="POST" action="<%=request.getContextPath()%>/reservations">

        <!-- Step 1: Dates -->
        <div class="card" style="margin-bottom:16px">
          <div class="ch"><span class="ct">📅 Step 1 — Select Dates</span></div>
          <div class="cb">
            <div class="fg">
              <div class="fgi">
                <label>Check-In Date <span class="req">*</span></label>
                <input type="date" name="checkIn" id="ci" value="<%=request.getAttribute("checkIn")!=null?request.getAttribute("checkIn"):""%>" required>
              </div>
              <div class="fgi">
                <label>Check-Out Date <span class="req">*</span></label>
                <input type="date" name="checkOut" id="co" value="<%=request.getAttribute("checkOut")!=null?request.getAttribute("checkOut"):""%>" required>
              </div>
              <div class="fgi">
                <label>Number of Guests <span class="req">*</span></label>
                <select name="numGuests"><option value="1">1 Guest</option><option value="2" selected>2 Guests</option><option value="3">3 Guests</option><option value="4">4 Guests</option><option value="5">5 Guests</option></select>
              </div>
            </div>
          </div>
        </div>

        <!-- Step 2: Room Selection -->
        <div class="card" style="margin-bottom:16px">
          <div class="ch"><span class="ct">🛏️ Step 2 — Select Room</span>
            <span style="font-size:.78rem;color:var(--muted)">Showing rooms available for selected dates</span>
          </div>
          <div class="cb">
            <%List<Room> rooms=(List<Room>)request.getAttribute("rooms");
              if(rooms!=null&&!rooms.isEmpty()){%>
            <div class="room-grid">
              <%for(Room rm:rooms){%>
              <label class="room-card" id="rc_<%=rm.getId()%>">
                <input type="radio" name="roomId" value="<%=rm.getId()%>" required onchange="selRoom(<%=rm.getId()%>)">
                <div class="rn"><%=rm.getTypeIcon()%> Room <%=rm.getRoomNumber()%></div>
                <div class="rt"><%=rm.getRoomType()%> · Floor <%=rm.getFloorNumber()%></div>
                <div class="rr">$<%=String.format("%.2f",rm.getRatePerNight())%> <span>/night</span></div>
                <div class="rc">👥 Up to <%=rm.getCapacity()%> guests</div>
                <div class="rd"><%=rm.getDescription()!=null?rm.getDescription():""%></div>
              </label>
              <%}%>
            </div>
            <%}else{%>
            <div class="empty"><div class="empty-ico">🛏️</div><p>No rooms available for the selected dates.<br>Try different dates.</p></div>
            <%}%>
          </div>
        </div>

        <!-- Step 3: Guest Details -->
        <div class="card" style="margin-bottom:16px">
          <div class="ch"><span class="ct">👤 Step 3 — Guest Details</span></div>
          <div class="cb">
            <div class="fg">
              <div class="fgi s2">
                <label>Full Name <span class="req">*</span></label>
                <input type="text" name="guestName" placeholder="e.g. Amara Perera" required>
              </div>
              <div class="fgi">
                <label>Email Address</label>
                <input type="email" name="guestEmail" placeholder="guest@example.com">
              </div>
              <div class="fgi">
                <label>Phone Number <span class="req">*</span></label>
                <input type="tel" name="guestPhone" placeholder="e.g. 0771234567" required>
              </div>
              <div class="fgi sall">
                <label>Address</label>
                <input type="text" name="guestAddress" placeholder="Street, City, Country">
              </div>
              <div class="section-label">Identification</div>
              <div class="fgi">
                <label>Nationality</label>
                <input type="text" name="nationality" placeholder="e.g. Sri Lankan">
              </div>
              <div class="fgi">
                <label>ID Type</label>
                <select name="idType">
                  <option value="">-- Select --</option>
                  <option value="NIC">NIC</option>
                  <option value="PASSPORT">Passport</option>
                  <option value="DRIVING LICENSE">Driving Licence</option>
                </select>
              </div>
              <div class="fgi">
                <label>ID Number</label>
                <input type="text" name="idNumber" placeholder="ID / Passport Number">
              </div>
              <div class="fgi sall">
                <label>Special Requests</label>
                <textarea name="specialRequests" placeholder="e.g. Early check-in, extra pillows, sea-facing room..."></textarea>
              </div>
            </div>
          </div>
        </div>

        <div style="display:flex;gap:10px;flex-wrap:wrap">
          <button type="submit" class="btn btn-primary">✅ Confirm Reservation</button>
          <a href="<%=request.getContextPath()%>/reservations" class="btn btn-outline">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  const ci=document.getElementById('ci'), co=document.getElementById('co');
  ci.min=new Date().toISOString().split('T')[0];
  ci.addEventListener('change',()=>{co.min=ci.value;if(co.value&&co.value<=ci.value)co.value='';});
  function selRoom(id){
    document.querySelectorAll('.room-card').forEach(c=>c.classList.remove('sel'));
    document.getElementById('rc_'+id).classList.add('sel');
  }
</script>
</body></html>
