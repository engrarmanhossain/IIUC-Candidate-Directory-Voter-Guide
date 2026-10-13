# IEB Election — IIUC Candidate Directory & Voter Guide

An interactive, responsive directory and management dashboard for **Institution of Engineers, Bangladesh (IEB)** election candidates representing the **International Islamic University Chittagong (IIUC)** engineering alumni.

🌐 **Live Demo**: [https://engrarmanhossain.github.io/IIUC-Candidate-Directory-Voter-Guide/](https://engrarmanhossain.github.io/IIUC-Candidate-Directory-Voter-Guide/)

---

## 🌟 Key Features

- **Manual Candidate Entry**:
  - Add candidates via intuitive modal dialog.
  - Local photo file upload with auto-compression & preview, or image URL.
  - Auto-formatted title (`Engr. <Name>`), prominent Ballot Number badge.
  - IIUC Batch, Department (EEE, CSE, CCE, Civil, etc.), IEB Membership ID, Division/Center.
  - Detailed Educational, Professional, and Extra-Curricular / Social Leadership qualifications.
  - Campaign Manifesto / Vision, contact phone, email, and LinkedIn profile.

- **Candidate Edit & Management**:
  - In-place editing of all fields with real-time UI updates.
  - Delete with confirmation safeguard.

- **Interactive Search & Filtering**:
  - Instant live search across names, ballot numbers, membership IDs, batches, and keywords.
  - Filter by candidate post / position, engineering department, and division / center.
  - Sort by ballot number, name (A-Z), batch, or recently added.
  - Switch between **Card Grid View** and **Table View**.

- **Export & Print**:
  - **Export to CSV**: Download an Excel-ready candidate directory spreadsheet.
  - **Export to JSON**: Backup candidate records.
  - **Print Voter Guide**: One-click print / PDF export styled as an official voting handout.

- **Offline Persistence**:
  - Uses browser `localStorage` — works without a backend database.
  - Pre-seeded with sample candidates for immediate testing.

---

## 💻 Local Development

Run with Node.js:
```bash
node server.js
```
Then open `http://localhost:3000/` in your browser.

Or simply open `index.html` directly in any web browser.
