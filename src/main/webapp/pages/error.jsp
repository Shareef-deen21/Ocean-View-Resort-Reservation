<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html><html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Error — Ocean View Resort</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="layout">
  <%if(session.getAttribute("currentUser")!=null){%><%@ include file="/WEB-INF/nav.jsp" %><%}%>
  <div class="main">
    <div class="page" style="display:flex;align-items:center;justify-content:center;min-height:80vh">
      <div style="text-align:center;max-width:420px">
        <div style="font-size:4rem;margin-bottom:12px">🌊</div>
        <h1 style="font-size:2.5rem;color:var(--teal);margin-bottom:8px">Oops!</h1>
        <p style="color:var(--muted);margin-bottom:8px"><%=request.getAttribute("error")!=null?request.getAttribute("error"):"Something went wrong."%></p>
        <p style="color:var(--muted);font-size:.82rem;margin-bottom:24px">If this keeps happening, check your database connection in DBConnection.java</p>
        <div style="display:flex;gap:10px;justify-content:center">
          <a href="<%=request.getContextPath()%>/dashboard" class="btn btn-primary">🏠 Dashboard</a>
          <a href="javascript:history.back()" class="btn btn-outline">← Go Back</a>
        </div>
      </div>
    </div>
  </div>
</div>
</body></html>
