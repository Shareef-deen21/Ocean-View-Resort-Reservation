<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Sign In - Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
  <style>
    .field-error{display:flex;align-items:center;gap:5px;font-size:.78rem;color:var(--red);margin-top:5px;font-weight:500;}
    .field-ok{display:flex;align-items:center;gap:5px;font-size:.78rem;color:var(--green);margin-top:5px;font-weight:500;}
    input.input-error{border-color:var(--red)!important;background:#FFF8F8;}
    input.input-error:focus{border-color:var(--red)!important;box-shadow:0 0 0 3px rgba(197,48,48,.12)!important;}
    input.input-ok{border-color:var(--green)!important;}
    @keyframes shake{0%,100%{transform:translateX(0);}20%{transform:translateX(-6px);}40%{transform:translateX(6px);}60%{transform:translateX(-4px);}80%{transform:translateX(4px);}}
    .shake{animation:shake .4s ease;}
    .attempt-warn{background:var(--amber-lt);border:1px solid #FBD38D;border-radius:var(--r-xs);padding:8px 12px;font-size:.78rem;color:var(--amber);font-weight:500;margin-bottom:12px;display:flex;align-items:center;gap:6px;}
    .toggle-pw{font-size:.75rem;color:var(--teal);cursor:pointer;font-weight:500;user-select:none;}
    .pw-label{display:flex;justify-content:space-between;align-items:center;}
  </style>
</head>
<body>
<%
  String errorType     = (String) request.getAttribute("errorType");
  String usernameError = (String) request.getAttribute("usernameError");
  String passwordError = (String) request.getAttribute("passwordError");
  String dbError       = (String) request.getAttribute("dbError");
  String enteredUser   = (String) request.getAttribute("enteredUsername");
  if (enteredUser == null) enteredUser = "";

  Integer attempts = (Integer) session.getAttribute("loginAttempts");
  if (attempts == null) attempts = 0;
  if (errorType != null && !"db".equals(errorType)) {
    attempts++;
    session.setAttribute("loginAttempts", attempts);
  }
  if (errorType == null) {
    session.removeAttribute("loginAttempts");
    attempts = 0;
  }

  boolean hasUsernameErr = "username".equals(errorType) || "both".equals(errorType);
  boolean hasPasswordErr = "password".equals(errorType) || "both".equals(errorType);
  boolean hasDbErr       = "db".equals(errorType);
  boolean usernameOk     = !enteredUser.isEmpty() && !hasUsernameErr && !hasPasswordErr && errorType != null;
%>
<div class="lp">

  <!-- Left hero panel -->
  <div class="lp-hero">
    <div class="hi">&#127754;</div>
    <h1>Ocean View Resort</h1>
    <p class="sub">Escape to Ocean View Resort, where modern beachfront luxury, stunning ocean horizons, and unforgettable moments await you.</p>
    <div class="lp-perks">
      <div class="perk"><span>&#128716;</span> 12 Premium Rooms</div>
      <div class="perk"><span>&#127958;</span> Private Balcony with Sea View</div>
      <div class="perk"><span>&#128705;</span> Premium Ensuite Bathrooms</div>
      <div class="perk"><span>&#9749;</span> Beachside Café & Lounge</div>
      <div class="perk"><span>&#127946;</span> Infinity Swimming Pool</div>
    </div>
  </div>

  <!-- Right form panel -->
  <div class="lp-form">
    <div class="lp-box">
      <h2>Welcome back</h2>
      <p class="sub2">Sign in to your staff account to continue</p>

      <!-- DB error alert -->
      <% if (hasDbErr) { %>
      <div class="alert ae" style="margin-bottom:16px;">
        <span class="alert-icon">&#128268;</span>
        <div>
          <strong>Database Connection Failed</strong><br>
          <span style="font-size:.82rem;"><%=dbError%></span>
        </div>
      </div>
      <% } %>

      <!-- Multiple attempts warning -->
      <% if (attempts >= 3) { %>
      <div class="attempt-warn">
        &#9888; <%=attempts%> failed attempt<% if(attempts>1){out.print("s");} %>. Please check your credentials carefully.
      </div>
      <% } %>

      <!-- Login form -->
      <form method="POST" action="<%=request.getContextPath()%>/login" id="loginForm" novalidate>

        <!-- Username -->
        <div class="fgi" style="margin-bottom:14px;">
          <label for="username">Username <span class="req">*</span></label>
          <input
            type="text"
            id="username"
            name="username"
            placeholder="Enter your username"
            value="<%=enteredUser%>"
            class="<%=hasUsernameErr?"input-error":usernameOk?"input-ok":""%>"
            autocomplete="username"
            autofocus>
          <% if (hasUsernameErr && usernameError != null) { %>
          <div class="field-error shake">
            <span>&#10060;</span> <%=usernameError%>
          </div>
          <% } else if (usernameOk) { %>
          <div class="field-ok">
            <span>&#9989;</span> Username recognised
          </div>
          <% } %>
        </div>

        <!-- Password -->
        <div class="fgi" style="margin-bottom:20px;">
          <label class="pw-label">
            <span>Password <span class="req">*</span></span>
            <span class="toggle-pw" id="togglePwd" onclick="togglePwd()">&#128065; Show</span>
          </label>
          <input
            type="password"
            id="password"
            name="password"
            placeholder="Enter your password"
            class="<%=hasPasswordErr?"input-error":""%>"
            autocomplete="current-password">
          <% if (hasPasswordErr && passwordError != null) { %>
          <div class="field-error shake">
            <span>&#10060;</span> <%=passwordError%>
          </div>
          <% } %>
        </div>

        <button type="submit" id="submitBtn" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;font-size:.9rem;">
          Sign In &#8594;
        </button>
      </form>
    </div>
  </div>
</div>

<script>
  /* Client-side empty field check before submit */
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    clearClientErrors();
    var un = document.getElementById('username').value.trim();
    var pw = document.getElementById('password').value.trim();
    var valid = true;

    if (un === '' && pw === '') {
      e.preventDefault();
      showError('username', 'Username is required.');
      showError('password', 'Password is required.');
      valid = false;
    } else if (un === '') {
      e.preventDefault();
      showError('username', 'Username is required.');
      valid = false;
    } else if (pw === '') {
      e.preventDefault();
      showError('password', 'Password is required.');
      valid = false;
    }

    if (!valid) {
      document.getElementById('submitBtn').classList.add('shake');
      setTimeout(function(){ document.getElementById('submitBtn').classList.remove('shake'); }, 500);
    }
  });

  function clearClientErrors() {
    document.querySelectorAll('.client-err').forEach(function(el){ el.remove(); });
    document.querySelectorAll('input').forEach(function(el){ el.classList.remove('input-error'); });
  }

  function showError(fieldId, msg) {
    var field = document.getElementById(fieldId);
    field.classList.add('input-error');
    var d = document.createElement('div');
    d.className = 'field-error shake client-err';
    d.innerHTML = '<span>&#10060;</span> ' + msg;
    field.parentNode.appendChild(d);
  }

  /* Show/hide password */
  function togglePwd() {
    var pw  = document.getElementById('password');
    var btn = document.getElementById('togglePwd');
    if (pw.type === 'password') {
      pw.type = 'text';
      btn.innerHTML = '&#128065; Hide';
    } else {
      pw.type = 'password';
      btn.innerHTML = '&#128065; Show';
    }
  }

  /* Auto-focus first error field on page load */
  window.addEventListener('load', function() {
    var errField = document.querySelector('input.input-error');
    if (errField) errField.focus();
  });
</script>
</body>
</html>
