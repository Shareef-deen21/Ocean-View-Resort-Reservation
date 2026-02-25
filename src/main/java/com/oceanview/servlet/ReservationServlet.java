package com.oceanview.servlet;

import com.oceanview.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/reservations")
public class ReservationServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        if (!requireLogin(q, r)) return;
        String action = p(q, "action");
        try {
            switch (action) {
                case "new"    -> showNew(q, r);
                case "view"   -> showView(q, r);
                case "bill"   -> showBill(q, r);
                case "status" -> doStatus(q, r);
                default       -> showList(q, r);
            }
        } catch (Exception e) {
            q.setAttribute("error", e.getMessage());
            fwd(q, r, "/pages/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        if (!requireLogin(q, r)) return;
        try {
            Reservation res = service.createReservation(
                p(q,"guestName"), p(q,"guestEmail"), p(q,"guestPhone"),
                p(q,"guestAddress"), p(q,"nationality"), p(q,"idType"), p(q,"idNumber"),
                pi(q,"roomId",-1), p(q,"checkIn"), p(q,"checkOut"),
                pi(q,"numGuests",1), p(q,"specialRequests")
            );
            r.sendRedirect(q.getContextPath()
                + "/reservations?action=view&id=" + res.getId() + "&success=1");
        } catch (Exception e) {
            q.setAttribute("error", e.getMessage());
            try {
                q.setAttribute("rooms", service.getAvailableRooms(p(q,"checkIn"), p(q,"checkOut")));
                q.setAttribute("checkIn",  p(q,"checkIn"));
                q.setAttribute("checkOut", p(q,"checkOut"));
            } catch (Exception ignored) {}
            fwd(q, r, "/pages/newReservation.jsp");
        }
    }

    private void showList(HttpServletRequest q, HttpServletResponse r) throws Exception, ServletException, IOException {
        String kw = p(q,"q");
        if (!kw.isEmpty()) {
            q.setAttribute("reservations", service.search(kw));
            q.setAttribute("keyword", kw);
        } else {
            q.setAttribute("reservations", service.getAll());
        }
        fwd(q, r, "/pages/reservations.jsp");
    }

    private void showNew(HttpServletRequest q, HttpServletResponse r) throws Exception, ServletException, IOException {
        String ci = p(q,"checkIn"), co = p(q,"checkOut");
        q.setAttribute("rooms",    service.getAvailableRooms(ci, co));
        q.setAttribute("checkIn",  ci);
        q.setAttribute("checkOut", co);
        fwd(q, r, "/pages/newReservation.jsp");
    }

    private void showView(HttpServletRequest q, HttpServletResponse r) throws Exception, ServletException, IOException {
        int id = pi(q,"id",-1);
        Reservation res = id > 0 ? service.getById(id) : service.getByNumber(p(q,"num"));
        if (res == null) { q.setAttribute("error","Reservation not found."); fwd(q,r,"/pages/error.jsp"); return; }
        q.setAttribute("reservation", res);
        q.setAttribute("success", q.getParameter("success") != null ? "Reservation created successfully!" : null);
        fwd(q, r, "/pages/viewReservation.jsp");
    }

    private void showBill(HttpServletRequest q, HttpServletResponse r) throws Exception, ServletException, IOException {
        Reservation res = service.getById(pi(q,"id",-1));
        if (res == null) { q.setAttribute("error","Reservation not found."); fwd(q,r,"/pages/error.jsp"); return; }
        q.setAttribute("reservation", res);
        fwd(q, r, "/pages/bill.jsp");
    }

    private void doStatus(HttpServletRequest q, HttpServletResponse r) throws Exception, IOException {
        service.updateStatus(pi(q,"id",-1), p(q,"status"));
        r.sendRedirect(q.getContextPath()+"/reservations?action=view&id="+p(q,"id")+"&msg=Status+updated");
    }
}
