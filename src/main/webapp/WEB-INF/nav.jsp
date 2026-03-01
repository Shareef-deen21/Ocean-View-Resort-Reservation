<%@ page contentType="text/html;charset=UTF-8" %>
<%
  com.oceanview.model.User _u = (com.oceanview.model.User)session.getAttribute("currentUser");
  String _cp = request.getContextPath();
  String _uri = request.getRequestURI();
%>
<aside class="sidebar">
  <div class="sb-brand">
    <span class="wave">🌊</span>
    <h2>Ocean View Resort</h2>
    <p>Galle, Sri Lanka</p>
  </div>
  <nav class="sb-nav">
    <div class="sb-section">Main</div>
    <a href="<%=_cp%>/dashboard" class="sb-link <%=_uri.contains("dashboard")?"active":""%>">
      <span class="ico">🏠</span> Dashboard
    </a>
    <div class="sb-section">Reservations</div>
    <a href="<%=_cp%>/reservations" class="sb-link <%=_uri.contains("reservations")&&!_uri.contains("new")?"active":""%>">
      <span class="ico">📋</span> All Reservations
    </a>
    <a href="<%=_cp%>/reservations?action=new" class="sb-link <%=_uri.contains("newReservation")?"active":""%>" >
      <span class="ico">➕</span> New Reservation
    </a>
    <div class="sb-section">Property</div>
    <a href="<%=_cp%>/rooms" class="sb-link <%=_uri.contains("rooms")?"active":""%>">
      <span class="ico">🛏️</span> Room Status
    </a>
    <div class="sb-section">Support</div>
    <a href="<%=_cp%>/help" class="sb-link <%=_uri.contains("help")?"active":""%>">
      <span class="ico">❓</span> Help & Guide
    </a>
  </nav>
  <div class="sb-footer">
    <%if(_u!=null){%>
    <div class="user-pill">
      <div class="av"><%=_u.getInitials()%></div>
      <div><div class="un"><%=_u.getFullName()%></div><div class="ur"><%=_u.getRole()%></div></div>
    </div>
    <%}%>

    <!-- Sign Out Button — opens modal instead of going directly to /logout -->
    <a href="#" onclick="document.getElementById('logoutModal').style.display='flex'; return false;" class="btn-out">
      🚪 Sign Out
    </a>
  </div>
</aside>

<!-- ===== Logout Confirmation Modal ===== -->
<div id="logoutModal" style="
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    justify-content: center;
    align-items: center;
    z-index: 9999;
">
  <div style="
      background: white;
      padding: 36px 44px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 6px 24px rgba(0,0,0,0.25);
      min-width: 320px;
  ">
    <div style="font-size: 40px; margin-bottom: 12px;">🚪</div>
    <h3 style="margin: 0 0 10px; font-size: 20px; color: #212529;">Sign Out</h3>
    <p style="margin: 0 0 28px; color: #6c757d; font-size: 15px;">
      Are you sure you want to sign out?
    </p>
    <div style="display: flex; gap: 14px; justify-content: center;">

      <!-- YES: invalidate session and redirect to login -->
      <a href="<%=_cp%>/logout" style="
          padding: 10px 32px;
          background-color: #dc3545;
          color: white;
          border-radius: 6px;
          text-decoration: none;
          font-size: 15px;
          font-weight: bold;
      ">Yes</a>

      <!-- NO: close modal, stay on current page -->
      <button onclick="document.getElementById('logoutModal').style.display='none'" style="
          padding: 10px 32px;
          background-color: #6c757d;
          color: white;
          border: none;
          border-radius: 6px;
          font-size: 15px;
          font-weight: bold;
          cursor: pointer;
      ">No</button>

    </div>
  </div>
</div>

<!-- Close modal when clicking the dark overlay behind the box -->
<script>
  document.getElementById('logoutModal').addEventListener('click', function(e) {
    if (e.target === this) {
      this.style.display = 'none';
    }
  });
</script>
