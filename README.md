# Ocean View Resort Reservation System


## Project Overview

The Ocean View Resort Reservation Management System is a Java EE-based web application developed to automate and streamline the hotel's room reservation operations. The system provides secure user authentication, guest registration, reservation management, billing calculation, a help module for staff guidance, and a safe sign-out feature. Each guest is assigned a unique reservation number, and all booking data including personal details, room type, and stay duration is stored in a relational database for reliable retrieval and data integrity management.



## Technologies Used

| Category | Technology |
|---|---|
| Backend | Java (Jakarta EE), Java Servlets |
| Frontend | JSP (JavaServer Pages), HTML, CSS |
| Database | MySQL |
| Server | Apache Tomcat |
| IDE | IntelliJ IDEA |
| Build Tool | Maven |
| Version Control | Git and GitHub |
| Testing | JUnit 5 |
| Architecture | Layered Architecture (N-Tier Architecture) |



## System Features

- Secure staff login and session management
- New guest registration and reservation creation
- Unique reservation number generation for every booking
- View, update, and cancel existing reservations
- Guest check-in and check-out management
- Bill calculation and bill printing
- Room availability and status tracking
- Help and guide section for staff
- Sign-out confirmation modal
- Database connection status indicator on dashboard



## OOP Concepts Applied

- **Encapsulation** - All model fields are private with controlled access through getters and setters
- **Abstraction** - AbstractReservation defines abstract methods implemented by subclasses
- **Inheritance** - Reservation extends AbstractReservation and inherits all shared fields and methods
- **Polymorphism** - calculateTotal(), getStatusLabel(), and getStatusBadgeClass() behave differently based on the object type at runtime



## SOLID Principles Applied

- **S** - Single Responsibility: each class has one specific job
- **O** - Open/Closed: new commands added without modifying existing code
- **L** - Liskov Substitution: any ReservationCommand implementation works in invoke()
- **I** - Interface Segregation: ReservationCommand interface contains only two focused methods
- **D** - Dependency Inversion: service depends on interfaces not concrete implementations


## Design Patterns Used

- **Singleton Pattern** - DBConnection.java ensures one database connection instance throughout the application
- **Command Pattern** - Every database operation is encapsulated as a command object with execute() and getDescription() methods



## Architecture

The system is built using Layered Architecture (N-Tier Architecture) with five layers:

| Layer | Technology | Responsibility |
|---|---|---|
| Presentation | JSP, HTML, CSS | Display data to the user |
| Controller | Java Servlets | Handle HTTP requests and responses |
| Service | Java Classes | Business logic and validation |
| Data Access | DAO Classes, JDBC | All SQL queries and database operations |
| Database | MySQL | Store and persist all data |


## Project Structure

```
src/
├── main/
│   ├── java/com/oceanview/
│   │   ├── command/          - ReservationCommand interface
│   │   ├── model/            - User, Room, Guest, Reservation, AbstractReservation
│   │   ├── repository/       - ReservationRepository, RoomRepository, GuestRepository, UserRepository
│   │   ├── service/          - ReservationService
│   │   ├── servlet/          - BaseServlet, LoginServlet, LogoutServlet, DashboardServlet, ReservationServlet, RoomServlet
│   │   └── singleton/        - DBConnection
│   └── webapp/
│       ├── WEB-INF/
│       ├── pages/            - JSP pages
│       └── css/              - Stylesheets
└── test/
    └── java/com/oceanview/test/
        ├── ReservationModelTest.java
        ├── RegressionTest.java
        └── TDDReservationTest.java
```

---

## Database Setup

**Step 1** - Open MySQL and create the database:
```sql
CREATE DATABASE ocean_view_resort;
```

**Step 2** - Run the provided SQL script:
```
database_setup.sql
```

**Step 3** - Update your database credentials in `DBConnection.java`:
```java
private static final String USERNAME = "your_username";
private static final String PASSWORD = "your_password";
```

---

## How to Run

**Step 1** - Clone the repository:
```bash
git clone 
```

**Step 2** - Open the project in IntelliJ IDEA

**Step 3** - Set up the database using the steps above

**Step 4** - Build the project:
```bash
mvn clean install
```

**Step 5** - Deploy the generated WAR file to Apache Tomcat

**Step 6** - Open your browser and navigate to:
```
http://localhost:8080/Ocean-View-Resort-Reservation/
```

**Step 7** - Login with your staff credentials:
```
Username: 
Password: 
```



## Running the Tests

Run all tests:
```bash
mvn test
```

Run only unit tests:
```bash
mvn test -Dtest=ReservationModelTest
```

Run only regression tests:
```bash
mvn test -Dtest=RegressionTest
```


## Branch Structure

| Branch          | Purpose |
|-----------------|---|
| development     | Active development work |
| qa-test         | QA testing and unit test verification |
| regression-uat  | Regression testing |
| production-live | Production ready code |



## Version

**v1.0.0** - Ocean View Resort Reservation System - Production Release



## Developer

**Name:** Shareefdeen  
**Email:** ahamedshariffdeen@gmail.com 
