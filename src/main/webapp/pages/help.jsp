<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.oceanview.model.Room" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Help & Guide — Ocean View Resort</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    /* ── Help page specific styles ────────────────────── */
    .help-hero {
      background: linear-gradient(135deg, var(--teal) 0%, var(--teal-md) 100%);
      border-radius: var(--r);
      padding: 32px 36px;
      margin-bottom: 22px;
      display: flex;
      align-items: center;
      gap: 24px;
    }
    .help-hero-icon { font-size: 3rem; flex-shrink: 0; }
    .help-hero h2 { font-family: 'Cormorant Garamond', serif; font-size: 1.6rem; color: #fff; margin-bottom: 4px; }
    .help-hero p  { color: rgba(255,255,255,.65); font-size: .875rem; }

    /* Accordion */
    .accordion { display: flex; flex-direction: column; gap: 8px; }
    .acc-item { border: 1.5px solid var(--border); border-radius: var(--r-sm); overflow: hidden; }
    .acc-trigger {
      width: 100%; display: flex; align-items: center; justify-content: space-between;
      padding: 15px 18px; background: #fff; border: none; cursor: pointer;
      font-family: 'DM Sans', sans-serif; font-size: .9rem; font-weight: 600;
      color: var(--dark); text-align: left; transition: background .18s;
      gap: 12px;
    }
    .acc-trigger:hover { background: var(--teal-xlt); }
    .acc-trigger.open  { background: var(--teal-lt);  color: var(--teal); border-bottom: 1.5px solid var(--border); }
    .acc-trigger .acc-icon { font-size: 1.1rem; flex-shrink: 0; }
    .acc-trigger .acc-arrow { font-size: .75rem; color: var(--muted); transition: transform .25s; flex-shrink: 0; }
    .acc-trigger.open .acc-arrow { transform: rotate(180deg); }
    .acc-body {
      display: none; padding: 18px 20px; background: #fff;
      font-size: .875rem; color: var(--text); line-height: 1.75;
    }
    .acc-body.open { display: block; }

    /* Step list inside accordion */
    .step-list { display: flex; flex-direction: column; gap: 10px; margin-top: 10px; }
    .step-item {
      display: flex; gap: 12px; align-items: flex-start;
      padding: 10px 14px; border-radius: var(--r-xs);
      background: var(--teal-xlt); border-left: 3px solid var(--teal);
    }
    .step-num {
      width: 24px; height: 24px; border-radius: 50%;
      background: var(--teal); color: #fff;
      font-size: .72rem; font-weight: 700;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0; margin-top: 1px;
    }
    .step-text { font-size: .855rem; color: var(--dark); }
    .step-text strong { color: var(--teal); }

    /* Info grid cards */
    .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; margin-top: 12px; }
    .info-card {
      background: var(--teal-xlt); border-radius: var(--r-sm);
      padding: 14px 16px; border: 1px solid var(--teal-lt);
    }
    .info-card .ic-label { font-size: .7rem; font-weight: 700; color: var(--teal); text-transform: uppercase; letter-spacing: .5px; margin-bottom: 5px; }
    .info-card .ic-val   { font-size: .9rem; font-weight: 600; color: var(--dark); }
    .info-card .ic-sub   { font-size: .75rem; color: var(--muted); margin-top: 2px; }

    /* Status pill demo */
    .status-demo { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }

    /* Credential box */
    .cred-box {
      background: var(--teal-lt); border-radius: var(--r-sm);
      padding: 14px 18px; display: flex; gap: 24px; flex-wrap: wrap;
      margin-top: 10px;
    }
    .cred-row { display: flex; flex-direction: column; gap: 3px; }
    .cred-label { font-size: .7rem; font-weight: 700; color: var(--teal); text-transform: uppercase; letter-spacing: .5px; }
    .cred-val   { font-family: 'Courier New', monospace; font-size: .9rem; color: var(--dark); font-weight: 600; }

    /* Room rate table */
    .rate-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px,1fr)); gap: 10px; margin-top: 10px; }
    .rate-card {
      border: 1.5px solid var(--border); border-radius: var(--r-sm);
      padding: 12px 14px; background: #fff; text-align: center;
    }
    .rate-card .rc-icon { font-size: 1.6rem; margin-bottom: 4px; }
    .rate-card .rc-type { font-size: .72rem; font-weight: 700; color: var(--teal); text-transform: uppercase; letter-spacing: .4px; }
    .rate-card .rc-rate { font-size: 1.1rem; font-weight: 700; color: var(--gold); margin: 3px 0; }
    .rate-card .rc-cap  { font-size: .72rem; color: var(--muted); }

    /* Shortcut table */
    .shortcut-row { display: flex; justify-content: space-between; align-items: center; padding: 9px 0; border-bottom: 1px dashed var(--border); font-size: .855rem; }
    .shortcut-row:last-child { border-bottom: none; }
    .shortcut-key { font-family: 'Courier New', monospace; background: #F1F5F9; padding: 3px 9px; border-radius: 5px; font-size: .78rem; color: var(--teal); border: 1px solid var(--border); }

    /* Pattern badge */
    .pattern-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px,1fr)); gap: 10px; margin-top: 10px; }
    .pattern-card { border-radius: var(--r-sm); padding: 13px 15px; }
    .pattern-card .pc-name { font-size: .78rem; font-weight: 700; margin-bottom: 4px; }
    .pattern-card .pc-desc { font-size: .78rem; line-height: 1.5; }

    /* Contact card */
    .contact-row { display: flex; align-items: center; gap: 10px; padding: 10px 0; border-bottom: 1px solid var(--border); font-size: .875rem; }
    .contact-row:last-child { border-bottom: none; }
    .contact-ico { font-size: 1.2rem; width: 28px; text-align: center; flex-shrink: 0; }
  </style>
</head>
<body>
<div class="layout">
  <%@ include file="/WEB-INF/nav.jsp" %>
  <div class="main">

    <!-- Topbar -->
    <div class="topbar">
      <span class="topbar-title">Help & User Guide</span>
      <div class="topbar-right">
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-sm btn-outline">← Dashboard</a>
      </div>
    </div>

    <div class="page">

      <!-- Hero Banner -->
      <div class="help-hero">
        <div class="help-hero-icon">📖</div>
        <div>
          <h2>Ocean View Resort — Help & User Guide</h2>
          <p>Step-by-step instructions for all system features. Click any section below to expand it.</p>
        </div>
      </div>

      <!-- Quick Stats Bar -->
      <div class="stats" style="margin-bottom:22px;">
        <div class="sc"><div class="si t">📋</div>
          <div><div class="sv"><%= request.getAttribute("totalRes") != null ? request.getAttribute("totalRes") : "—" %></div><div class="sl">Total Reservations</div></div>
        </div>
        <div class="sc"><div class="si p">🛏️</div>
          <div><div class="sv"><%= request.getAttribute("availableRooms") != null ? request.getAttribute("availableRooms") : "—" %></div><div class="sl">Available Rooms</div></div>
        </div>
        <div class="sc"><div class="si g">✅</div>
          <div><div class="sv">5</div><div class="sl">Room Types</div></div>
        </div>
      </div>

      <!-- ════════════════════════════════════════════ -->
      <!-- ACCORDION SECTIONS -->
      <!-- ════════════════════════════════════════════ -->
      <div class="accordion">

        <!-- 1. Getting Started -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">🔐</span> 1. Getting Started — Login & Logout</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>Sign in with your staff credentials to access the system. Sessions expire automatically after 30 minutes of inactivity.</p>
            <div class="step-list">
              <div class="step-item"><div class="step-num">1</div><div class="step-text">Open your browser and go to <strong>http://localhost:8080/ocean-view-resort/login</strong></div></div>
              <div class="step-item"><div class="step-num">2</div><div class="step-text">Enter your <strong>Username</strong> and <strong>Password</strong> then click <strong>Sign In</strong></div></div>
              <div class="step-item"><div class="step-num">3</div><div class="step-text">You will be redirected to the <strong>Dashboard</strong> automatically</div></div>
              <div class="step-item"><div class="step-num">4</div><div class="step-text">To sign out, click <strong>🚪 Sign Out</strong> at the bottom of the left sidebar</div></div>
            </div>
            <div class="cred-box" style="margin-top:16px;">
              <div class="cred-row"><div class="cred-label">Admin Account</div><div class="cred-val">admin / admin123</div></div>
              <div class="cred-row"><div class="cred-label">Staff Account</div><div class="cred-val">staff / staff123</div></div>
            </div>
          </div>
        </div>

        <!-- 2. Dashboard -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">🏠</span> 2. Dashboard — Overview</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>The dashboard is your control centre. It gives you a live overview of everything happening at the resort.</p>
            <div class="info-grid" style="margin-top:14px;">
              <div class="info-card"><div class="ic-label">Stat Cards</div><div class="ic-val">Live counts</div><div class="ic-sub">Total reservations, confirmed, checked-in, available rooms, revenue</div></div>
              <div class="info-card"><div class="ic-label">Recent Reservations</div><div class="ic-val">Last 7 bookings</div><div class="ic-sub">Quick View and Bill links for each row</div></div>
              <div class="info-card"><div class="ic-label">Quick Actions</div><div class="ic-val">3 shortcuts</div><div class="ic-sub">New Reservation, All Reservations, Room Status</div></div>
              <div class="info-card"><div class="ic-label">Audit Log</div><div class="ic-val">Live feed</div><div class="ic-sub">Every database operation recorded in real time (Command Pattern + Queue)</div></div>
            </div>
          </div>
        </div>

        <!-- 3. New Reservation -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">➕</span> 3. Creating a New Reservation</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>Click <strong>➕ New Reservation</strong> in the sidebar. The form has 3 steps:</p>
            <div class="step-list" style="margin-top:12px;">
              <div class="step-item">
                <div class="step-num">1</div>
                <div class="step-text">
                  <strong>Select Dates</strong> — Enter Check-In and Check-Out dates and number of guests.
                  The room list automatically filters to show only rooms available for those dates.
                </div>
              </div>
              <div class="step-item">
                <div class="step-num">2</div>
                <div class="step-text">
                  <strong>Select a Room</strong> — Click any room card to select it. Each card shows the
                  room number, type, floor, rate per night, capacity and description.
                </div>
              </div>
              <div class="step-item">
                <div class="step-num">3</div>
                <div class="step-text">
                  <strong>Enter Guest Details</strong> — Full Name and Phone are required.
                  Email, Address, Nationality, ID Type, ID Number and Special Requests are optional.
                  Click <strong>✅ Confirm Reservation</strong> to save.
                </div>
              </div>
            </div>
            <div class="alert ai" style="margin-top:14px;margin-bottom:0;">
              <span class="alert-icon">💡</span>
              <span>The system automatically prevents double-booking. A room already reserved for the selected dates will not appear in the room list.</span>
            </div>
          </div>
        </div>

        <!-- 4. View / Search Reservations -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">🔍</span> 4. Viewing & Searching Reservations</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>Click <strong>📋 All Reservations</strong> in the sidebar to see every booking in the system.</p>
            <div class="step-list" style="margin-top:12px;">
              <div class="step-item"><div class="step-num">1</div><div class="step-text"><strong>Search</strong> — use the search bar to filter by guest name, reservation number, or phone number</div></div>
              <div class="step-item"><div class="step-num">2</div><div class="step-text"><strong>View button</strong> — opens the full reservation detail page with guest info, room info and status actions</div></div>
              <div class="step-item"><div class="step-num">3</div><div class="step-text"><strong>Bill button</strong> — opens the printable invoice directly from the list</div></div>
              <div class="step-item"><div class="step-num">4</div><div class="step-text"><strong>Clear button</strong> — click ✕ next to the search bar to clear the filter and see all reservations again</div></div>
            </div>
          </div>
        </div>

        <!-- 5. Status Management -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">⚙️</span> 5. Managing Reservation Status</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>Open any reservation and use the <strong>Update Status</strong> panel at the bottom to change its state. Status changes also update the room availability in real time.</p>
            <div class="status-demo">
              <span class="badge badge-confirmed">Confirmed</span>
              <span style="color:var(--muted);font-size:1.1rem;">→</span>
              <span class="badge badge-checkedin">Checked In</span>
              <span style="color:var(--muted);font-size:1.1rem;">→</span>
              <span class="badge badge-checkedout">Checked Out</span>
            </div>
            <table class="dt" style="margin-top:14px;">
              <thead><tr><th>Status</th><th>Button</th><th>Room Effect</th></tr></thead>
              <tbody>
                <tr><td><span class="badge badge-confirmed">Confirmed</span></td><td>— (default on create)</td><td>Room stays <span class="badge badge-available">Available</span></td></tr>
                <tr><td><span class="badge badge-checkedin">Checked In</span></td><td>🔑 Check In</td><td>Room becomes <span class="badge badge-occupied">Occupied</span></td></tr>
                <tr><td><span class="badge badge-checkedout">Checked Out</span></td><td>🚪 Check Out</td><td>Room returns to <span class="badge badge-available">Available</span></td></tr>
                <tr><td><span class="badge badge-cancelled">Cancelled</span></td><td>✕ Cancel</td><td>Room returns to <span class="badge badge-available">Available</span></td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 6. Bill / Invoice -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">🧾</span> 6. Generating & Printing a Bill</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>A professional invoice can be generated for any reservation at any time.</p>
            <div class="step-list" style="margin-top:12px;">
              <div class="step-item"><div class="step-num">1</div><div class="step-text">Open a reservation → click <strong>🧾 Generate Bill</strong>, OR from All Reservations click the <strong>Bill</strong> button on any row</div></div>
              <div class="step-item"><div class="step-num">2</div><div class="step-text">The invoice shows guest details, room info, dates, nights, rate and the calculated total</div></div>
              <div class="step-item"><div class="step-num">3</div><div class="step-text">Click <strong>🖨️ Print</strong> to print — or in the print dialog choose <strong>Save as PDF</strong> to get a digital copy</div></div>
            </div>
            <div class="info-card" style="margin-top:14px;display:inline-block;min-width:280px;">
              <div class="ic-label">Bill Calculation Formula</div>
              <div class="ic-val" style="font-family:'Courier New',monospace;font-size:.85rem;margin-top:4px;">Total = Number of Nights × Rate per Night</div>
            </div>
          </div>
        </div>

        <!-- 7. Room Status -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">🛏️</span> 7. Room Types & Rates</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <p>The resort has 12 rooms across 5 types. Click <strong>🛏️ Room Status</strong> in the sidebar to see live availability.</p>
            <div class="rate-grid">
              <div class="rate-card"><div class="rc-icon">🛏️</div><div class="rc-type">Standard</div><div class="rc-rate">$80<span style="font-size:.7rem;font-weight:400;color:var(--muted)">/night</span></div><div class="rc-cap">Up to 2 guests · Rooms 101–103</div></div>
              <div class="rate-card"><div class="rc-icon">✨</div><div class="rc-type">Deluxe</div><div class="rc-rate">$130<span style="font-size:.7rem;font-weight:400;color:var(--muted)">/night</span></div><div class="rc-cap">Up to 3 guests · Rooms 201–203</div></div>
              <div class="rate-card"><div class="rc-icon">🌊</div><div class="rc-type">Ocean View</div><div class="rc-rate">$160<span style="font-size:.7rem;font-weight:400;color:var(--muted)">/night</span></div><div class="rc-cap">Up to 2 guests · Rooms 301–302</div></div>
              <div class="rate-card"><div class="rc-icon">👨‍👩‍👧‍👦</div><div class="rc-type">Family</div><div class="rc-rate">$180<span style="font-size:.7rem;font-weight:400;color:var(--muted)">/night</span></div><div class="rc-cap">Up to 5 guests · Rooms 401–402</div></div>
              <div class="rate-card"><div class="rc-icon">👑</div><div class="rc-type">Suite</div><div class="rc-rate">$200<span style="font-size:.7rem;font-weight:400;color:var(--muted)">/night</span></div><div class="rc-cap">Up to 2 guests · Rooms 501–502</div></div>
            </div>
          </div>
        </div>

        <!-- 8. Keyboard Shortcuts -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">⌨️</span> 8. Keyboard Shortcuts & Tips</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <div class="shortcut-row"><span>Print / Save bill as PDF</span><span class="shortcut-key">Ctrl + P</span></div>
            <div class="shortcut-row"><span>Reload / refresh current page</span><span class="shortcut-key">F5</span></div>
            <div class="shortcut-row"><span>Go back to previous page</span><span class="shortcut-key">Alt + ←</span></div>
            <div class="shortcut-row"><span>Focus the search bar on reservations page</span><span class="shortcut-key">Click search box</span></div>
            <div class="shortcut-row"><span>Submit a form</span><span class="shortcut-key">Enter</span></div>
            <div class="shortcut-row"><span>Open new reservation form quickly</span><span>Click ➕ in the sidebar</span></div>
            <div style="margin-top:14px;">
              <div class="alert aw" style="margin-bottom:0;">
                <span class="alert-icon">💡</span>
                <span><strong>Pro tip:</strong> After printing a bill, use your browser's <strong>Save as PDF</strong> option in the print dialog to keep a digital copy without needing a printer.</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 9. Contact / Resort Info -->
        <div class="acc-item">
          <button class="acc-trigger" onclick="toggle(this)">
            <span style="display:flex;align-items:center;gap:10px;"><span class="acc-icon">📞</span> 9. Resort Contact Information</span>
            <span class="acc-arrow">▼</span>
          </button>
          <div class="acc-body">
            <div class="contact-row"><div class="contact-ico">🏨</div><div><strong>Ocean View Resort</strong><br>Galle, Southern Province, Sri Lanka</div></div>
            <div class="contact-row"><div class="contact-ico">📞</div><div>+94 91 2234567</div></div>
            <div class="contact-row"><div class="contact-ico">📧</div><div>reservations@oceanviewgalle.lk</div></div>
            <div class="contact-row"><div class="contact-ico">🌐</div><div>www.oceanviewresort.lk</div></div>
            <div class="contact-row"><div class="contact-ico">⏰</div><div>Front Desk: 24 hours · Check-in: 2:00 PM · Check-out: 11:00 AM</div></div>
          </div>
        </div>

      </div><!-- end accordion -->

      <!-- Bottom quick-action bar -->
      <div class="card" style="margin-top:22px;">
        <div class="ch"><span class="ct">⚡ Quick Navigation</span></div>
        <div class="cb" style="display:flex;gap:10px;flex-wrap:wrap;">
          <a href="<%= request.getContextPath() %>/reservations?action=new" class="btn btn-primary">➕ New Reservation</a>
          <a href="<%= request.getContextPath() %>/reservations" class="btn btn-outline">📋 All Reservations</a>
          <a href="<%= request.getContextPath() %>/rooms" class="btn btn-outline">🛏️ Room Status</a>
          <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline">🏠 Dashboard</a>
        </div>
      </div>

    </div><!-- end page -->
  </div><!-- end main -->
</div><!-- end layout -->

<script>
  function toggle(btn) {
    const body = btn.nextElementSibling;
    const isOpen = body.classList.contains('open');
    // Close all
    document.querySelectorAll('.acc-body').forEach(b => b.classList.remove('open'));
    document.querySelectorAll('.acc-trigger').forEach(t => t.classList.remove('open'));
    // Open clicked (if it was closed)
    if (!isOpen) {
      body.classList.add('open');
      btn.classList.add('open');
      body.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }
</script>
</body>
</html>
