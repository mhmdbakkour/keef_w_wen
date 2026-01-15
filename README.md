# Keef W Wen

A cross-platform mobile application designed to simplify event discovery, creation, and management. The application enables users to browse, locate, and share events; manage participation, and stay informed through a centralized, mobile-first experience.

---

## Table of Contents
* [Project Overview](#project-overview)
* [Features](#features)
* [Architecture](#architecture)
* [Screenshots](#screenshots)
* [Getting Started](#getting-started)
  * [Frontend Prerequisites](#frontend-prerequisites)
  * [Backend Prerequisites](#backend-prerequisites)
* [Backend Setup](#backend-setup)
* [Frontend Setup](#frontend-setup)
* [API Endpoints](#api-endpoints)
* [Database Schema](#database-schema)
* [Design Decisions](#design-decisions)
* [Future Improvements](#future-improvements)
* [License](#license)
* [About](#about)

---

## Project Overview
The ***Keef W Wen*** App allows users to:

Create, engage with, and join user-created events.
Update event start, close, and end dates.
Create a countdown for event initialization
Manage event interaction and participants
Like, save, and delete events.
Create new users, log in, and follow other users.
Geo-locate events based on their locations and follow them
Assign hosts to events for easier event handling
Authenticate users by using special QR codes in event tickets

The app is designed for the sole purpose of connecting users through social events. Users have full control over the events they create/manage and can allow any other users to participate.

## Features
- Event creation, editing, and deletion
- Event listing and discovery
- Event details and scheduling
- Participant management
- Cross-platform support (Android, iOS)

## Architecture
- **Frontend:** Flutter (Dart)
- **Backend:** Django (Python)
- **Database:** PostgreSQL
- **State Management:** Riverpod

## Screenshots
<table>
  <tr>
    <td align="center" colspan="2">
      <img width="216" height="480" alt="Landing Page" src="https://github.com/user-attachments/assets/74c57943-fb6c-4feb-be18-c66dd4c3858c" />
      <br />
      <em>Landing page — the first screen shown when launching the application.</em>  
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Log In Page" src="https://github.com/user-attachments/assets/fa8faa80-2565-4f5f-a13b-858efb105374" />
      <br />
      <em>Login Page - the screen where the user logs in if they have an account.</em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="Register Page" src="https://github.com/user-attachments/assets/9184a63e-d472-4d53-816c-fb70a60dfb61" />
      <br />
      <em>Register Page - the screen where the user registers a new account.</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Home Page" src="https://github.com/user-attachments/assets/83563f29-28de-438d-9d59-489450dae00b" />
      <br />
      <em>Home Page - the main page of the application that contains major ongoing events.</em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="Events Page" src="https://github.com/user-attachments/assets/ba3db732-fe4b-4ecb-91bf-8613804c6263" />
      <br />
      <em>Event Page - the page where the user can browse all events and filter by tags.</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Map Page" src="https://github.com/user-attachments/assets/6e4bc66b-5274-455f-ba84-f60f910a91f2" />
      <br />
      <em>Map Page - the page where the user can navigate a map and see exactly where certain events are located.</em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="People Page" src="https://github.com/user-attachments/assets/c28c1a1d-c77e-49e1-a7a3-578f1a9d67b5" />
      <br />
      <em>People Page - the page where the user can follow people from recent events or search for users who might have something in common.</em>
    </td>
  </tr>
  <tr>
    <td align="center" colspan="2">
      <img width="216" height="480" alt="Profile Page" src="https://github.com/user-attachments/assets/13ad774c-63fe-4fbf-a005-24a572ef8b11" />
      <br />
      <em>Profile Page - the page where the user's profile can be seen/edited.</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Event Details Page" src="https://github.com/user-attachments/assets/4dfe48af-669a-43dd-bc74-ce36a1d5758b" />
      <br />
      <em>Event Details Page - the page where a user can view all the details of an event. </em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="Join Event Page" src="https://github.com/user-attachments/assets/8dad5cca-559f-4e37-8210-be7cf99edf29" />
      <br />
      <em>Join Event Page - the page where the user can join an event, including the ability to see relevant details. </em>
    </td>
  </tr>
  <tr>
    <td align="center">
     <img width="216" height="480" alt="Event Participants Page" src="https://github.com/user-attachments/assets/06dd9244-e480-4eaa-aec6-02c0222463d9" />
      <br />
      <em>Event Participants Page - the page where a user can view all the participants of an event. </em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="View Profile Page" src="https://github.com/user-attachments/assets/13c92aaf-9208-4587-8f51-128e8c7e0491" />
      <br />
      <em>View Profile Page - the page where the user can view the profiles of other participants/users. </em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Event Lobby" src="https://github.com/user-attachments/assets/0d8204ca-c5ee-43f4-b637-382e3350ebe0" />
      <br />
      <em>Event Lobby Page - the page where the user can interact with other participants who joined the event and see the event timer.</em>
    </td>
    <td align="center">
       <img width="216" height="480" alt="Event Lobby Page Chat" src="https://github.com/user-attachments/assets/6694c495-febd-4ed2-a44e-16f183dc6a0f" />
      <br />
      <em>Event Lobby Page Chat - a toggleable chat inside the event lobby page where participants can chat.  </em>
    </td>
  </tr>
  <tr>
    <td align="center">
     <img width="216" height="480" alt="Event Details Page Scanner" src="https://github.com/user-attachments/assets/53c497f0-d647-477e-911e-463b835b955c" />
      <br />
      <em>Event Details Page Scanner - a toggleable part of the event details that shows the event ticket scanner that is used for authentication. </em>
    </td>
    <td align="center">
     <img width="216" height="480" alt="Event Lobby Page Ticket" src="https://github.com/user-attachments/assets/7cab38b8-7f5a-4847-a460-ebf7d982c15e" />
      <br />
      <em>Event Lobby Page Ticket - a toggleable part of the event lobby that shows the event ticket scanned on entrance to an event using the above scanner. </em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Create Event Page" src="https://github.com/user-attachments/assets/03b093c9-2e4b-453c-9369-175788591df7" />
      <br />
      <em>Create Event Page - the page where users create their own events with the ability to set all relevant information (e.g. date, location, name, description, etc...). </em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="Edit Event Page" src="https://github.com/user-attachments/assets/43bb72c8-e6b6-4df6-a4c8-dce0de1d4f56" />
      <br />
      <em>Edit Event Page - the page where users edit their own events with the ability to change all relevant information (e.g. date, location, name, description, etc...). </em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="216" height="480" alt="Edit Profile Page" src="https://github.com/user-attachments/assets/0af7561e-a1fa-43a4-ac37-456ac88331f8" />
      <br />
      <em>Edit Profile Page - the page where users edit their own profile with the ability to change all relevant information (e.g. profile picture, name, bio, etc...). </em>
    </td>
    <td align="center">
      <img width="216" height="480" alt="Settings Page" src="https://github.com/user-attachments/assets/ee342d45-9108-4367-b8f5-18bff9844753" />
      <br />
      <em>Settings Page - the page where the user can change app-wide settings (e.g, dark mode/light mode, hide username, etc...) or view app information (e.g. about, contact us, etc...). </em>
    </td>
  </tr>
</table>

## Getting Started

### Frontend Prerequisites
- Flutter SDK
- Dart SDK

### Backend Prerequisites
- Python with Django
- PostgreSQL (pgAdmin4 preferrably)

## Backend Setup
1. Configure and deploy the backend service.
2. Set up the database and apply required migrations.
3. Update backend environment variables and API URLs.

## Frontend Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/mhmdbakkour/keef_w_wen.git
   ```
2. Navigate to the project directory:
   ```bash
   cd keef_w_wen
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```
## API Endpoints

### Events

```
GET      /events                         Retrieve all events
POST     /events                         Create a new event

GET      /events/{id}                    Retrieve event details
GET      /events/{id}/check-interaction  Check event interaction
POST     /events/{id}/interact (like)    Like an event
POST     /events/{id}/interact (save)    Save an event
PATCH    /events/{id}/toggle-status      Toggle event status (open/closed) 
PATCH    /events/{id}                    Update an event
DELETE   /events/{id}                    Delete an event

GET      /event-interactions             Retrieve all event interactions
DELETE   /event-interactions/{id}        Delete event interaction

GET      /locations                      Retrieve all location data
```

### Users

```
GET      /users                         Retrieve all users
GET      /users/bulk-fetch              Retrieve users specified in request
GET      /users/{username}/followers    Retrieve users' followers
GET      /users/{username}/following    Retrieve users' following
PATCH    /users/{username}              Update user data
DELETE   /users/{username}              Delete user

GET      /me                            Retrieve current user

GET      /check-user                    Retrieve user availability

POST     /register                      Create a new user

POST     /follow                        Follow a user
```

## Database Schema

### Event

| Field             | Type         | Description                 |
| ----------------- | ------------ | --------------------------- |
| id                | UUID         | Primary key                 |
| title             | String       | Event title                 |
| thumbnail         | Image        | Thumbnail image of event    |
| images            | Array        | Array of foreign keys       |
| description       | String       | Event details               |
| rating            | Float        | Event rating                |
| host_owner        | String       | Username of event owner     |
| location          | String       | Foreign key of location     |
| is_private        | Boolean      | Event visibility            |
| needs_id          | Boolean      | User identificated needed?  |
| seats             | Integer      | Event seats available       |
| price             | Float        | Event price                 |
| open_status       | Boolean      | Event joinability           |
| tags              | Array        | Array of string tags        |
| date_created      | DateTime     | Date event was created      |
| date_start        | DateTime     | Date event starts           |
| date_closed       | DateTime     | Date event closes           |
| date_ended        | DateTime     | Date event ended            |

### User

| Field             | Type         | Description                 |
| ----------------- | ------------ | --------------------------- |
| username          | String       | Primary key                 |
| fullname          | String       | User's full name            |
| email             | String       | User's email address        |
| bio               | String       | User's autobiography        |
| mobile_number     | String       | User's mobile number        |
| profile_picture   | Image        | User's profile picture      |
| location          | String       | Foreign key of location     |
| sharing_location  | Boolean      | User's location visibility  |
| associated_color  | String       | User's associated color     |
| is_active         | Boolean      | User's account status       |
| is_staff          | Boolean      | User's staff priviledges    |
| date_joined       | DateTime     | Date user joined            |
| last_login        | DateTime     | Date of user's last login   |


### Location

| Field             | Type         | Description                 |
| ----------------- | ------------ | --------------------------- |
| id                | UUID         | Primary key                 |
| name              | String       | Location name               |
| latitude          | Float        | Latitude of location        |
| longitude         | Float        | Longitude of location       |
| accuracy          | Float        | Accuracy of gps reading     |
| source            | String       | Source of gps reading       |
| timestamp         | DateTime     | Time location was recorded  |

### Event Interaction

| Field             | Type         | Description                 |
| ----------------- | ------------ | --------------------------- |
| id                | UUID         | Primary key                 |
| user              | String       | Username of user            |
| event             | UUID         | Forein key of event         |
| liked             | Boolean      | Event liked?                |
| saved             | Boolean      | Event saved?                |
| date_interacted   | DateTime     | Date event interacted with  |

### Event Image

| Field             | Type         | Description                 |
| ----------------- | ------------ | --------------------------- |
| id                | UUID         | Primary key                 |
| event             | UUID         | Forein key of event         |
| image             | Image        | Event image                 |
| date_uploaded     | DateTime     | Date event image uploaded   |

### Participant

| Field             | Type         | Description                 |
| ----------------- | ------------ | --------------------------- |
| id                | UUID         | Primary key                 |
| user              | String       | Username of user            |
| event             | UUID         | Forein key of event         |
| is_host           | Boolean      | User host of event?         |
| is_owner          | Boolean      | User owner of event?        |
| date_participated | DateTime     | Date event participated in  |

### User Follow

| Field             | Type         | Description                      |
| ----------------- | ------------ | -------------------------------- |
| id                | UUID         | Primary key                      |
| follower          | String       | Username of follower             |
| following         | String       | Username of following            |
| date_followed     | DateTime     | Date follower followed following  |


## Design Decisions
The ***Keef W Wen*** application adopts a modular, client-server architecture designed to ensure scalability, security, and maintainability. The system is composed of three primary layers: the presentation layer, the application logic layer, and the data layer.
- Front-end (Client Side):
    - Developed using Flutter, the mobile interface is responsible for all user interactions, including event creation, browsing, map visualization, and profile management. It communicates with the backend through secured RESTful APIs.
- Back-end (Server Side):
    - Implemented with Django, the server handles authentication, business logic, data validation, and user access control. It processes client requests and responds with serialized data in JSON format.
- Database Layer:
    - PostgreSQL serves as the relational database, storing structured data including users, events, participation records, event interactions, user interactions, event images, and location data.
- Security and Access Control:
    - Authentication is mandatory for accessing any application feature. Role-based access ensures that only authorized users can perform sensitive operations (e.g., modifying events)
- Integration and APIs:
    - The system integrates with mapping services to provide geolocation and geocoding features. API endpoints are organized by functional modules and follow REST conventions to support future expansion.

## Future Improvements

### Proposed Enhancements
- Real-Time Location Sharing
   - Introduce live updates for participants and event locations to enhance tracking and coordination
- Notification System
   - Add in-app and push notifications to inform users of approvals, requests, and event changes in real time.
- Offline Access
   - Implement local caching mechanisms to provide limited functionality without an internet connection
- Advanced Participant Management
   - Include tools for filtering participants, sending event-wide messages, and tracking attendance.
- Provide more useful tools for hosts
   - Include tools for monitoring event interactions, adding event stops, and configuring event lobby aesthetics.

### Technical Improvements
- Automated Testing
  - Develop unit and integration tests to ensure functionality and maintain code stability during future updates.
- Scalability Optimization
  - Refactor and optimize backend services to handle increased user traffic and concurrent usage efficiently.
 
## License
This software is proprietary. No permission is granted to use, copy, modify, or distribute this code, in whole or in part. Independent reimplementation without reference to this code is permitted.

## About
This is a personal project initially made as a proof of concept, then was expanded upon with time until its current state. The idea came from the lack of event-forward focused applications that help groups of people create engaging and easily addressable events. 
