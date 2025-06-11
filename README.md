# ArifMusic – Ethiopian Music Streaming Platform

## Project Overview

**ArifMusic** is a cross-platform **Flutter** mobile application built for Ethiopian music enthusiasts, artists, and administrators. The app enables users to stream, upload, and manage Ethiopian music content with a role-based access system. It includes features tailored to listeners, artists, and administrators, each with unique permissions and functionalities.

This project focuses on **two core business features**, each providing **full CRUD (Create, Read, Update, Delete)** capabilities, along with **authentication-based screen access** using Flutter and Firebase/Backend APIs.

---

## Key Features

### 1. Music Management (CRUD)

**Artist Capabilities**
- **Create**: Upload songs/albums with metadata (title, album, genre, cover image)
- **Read**: View uploaded music from dashboard
- **Update**: Edit track information
- **Delete**: Remove their own music

**Admin Capabilities**
- Manage All Content: Approve, reject, or delete songs
- Categorize: Tag genres (Tizita, Gurage, Oromo, etc.)
- Moderate: Maintain platform standards

### 2. User Engagement & Personalization (CRUD)

**Listener Capabilities**
- **Create**: Playlists and watchlists
- **Read**: Access saved playlists/watchlists
- **Update**: Edit playlist name, order, notes
- **Delete**: Remove songs or entire lists

---

## Role-Based Access Control (RBAC)

| Role     | Permissions                                         |
|----------|-----------------------------------------------------|
| Listener | Stream content, manage playlists & watchlists      |
| Artist   | Upload and manage own music, view stats             |
| Admin    | Full access: manage users, approve/delete content   |

---

## Tech Stack

| Layer         | Tools / Frameworks                                 |
|---------------|----------------------------------------------------|
| Frontend      | Flutter, Riverpod, GoRouter                        |
| Backend       | Node.js, Express.js                                |
| Database      | MongoDB                                            |
| Auth          |JWT-based custom auth                               | 
| Architecture  | DDD (Domain-Driven Design)                         |

---

## Project Contributors – ArifMusic

| No. | Name              | ID             |
|-----|-------------------|----------------|
| 1   | Abiy Arage        | UGGR/8104/15   |
| 2   | Bisrat Dereje     | UGR/3229/15    |
| 3   | Girma Enkuchile   | UGR/8130/15    |
| 4   | Kena Ararso       | UGR/9085/15    |
| 5   | Siham Sadik       | UGR/0794/15    |
