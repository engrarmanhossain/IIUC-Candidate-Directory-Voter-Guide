# IEB Election — IIUC Candidate Directory & Voter Guide

An interactive, responsive directory and candidate management dashboard for the **Institution of Engineers, Bangladesh (IEB)** election candidates representing the **International Islamic University Chittagong (IIUC)** engineering fraternity.

🌐 **Live Website**: [https://engrarmanhossain.github.io/IIUC-Candidate-Directory-Voter-Guide/](https://engrarmanhossain.github.io/IIUC-Candidate-Directory-Voter-Guide/)

---

## 🛡️ Admin & Public Approval Workflow

### 1. Public Submissions (Open to Everyone)
- **Submit New Candidate**: Anyone can submit a candidate profile with image, name, IIUC batch, department, IEB ID, and qualifications.
- **Suggest Candidate Edits**: Anyone can click **Edit** on an existing candidate card to suggest corrections or updates (contact info, designation, photo, educational background, etc.). The live profile remains unchanged until an administrator approves the edit.
- **Moderation Queue**: New entries and edit proposals undergo review and do **not** appear on the live directory without admin verification.
- **Request Candidate Removal**: Public users can click `Request Removal` to submit a removal request along with their reason and contact information.

### 2. Administrator Dashboard
- **Admin Email**: `armanhossain.eee.info@gmail.com`
- **Default Passcode / PIN**: `arman2026`
- **Admin Controls**:
  - **Live Candidates**: View and manage all approved entries.
  - **Pending Submissions**: One-click **Approve & Publish**, **Edit before Approving**, or **Reject**.
  - **Edit Requests**: Review proposed updates in a side-by-side **Diff Comparison Modal**, with one-click **Approve & Apply to Live**, **Edit before Approving**, or **Reject**.
  - **Deletion Requests**: Review removal requests submitted by visitors, with one-click **Confirm Deletion** or **Dismiss**.
  - **Direct Publishing**: Admins can directly add, edit, or delete any candidate without waiting for approval.

---

## 🌟 Core Features

- **Candidate Entry**: Photo upload (file or URL), Name, Ballot No, Post / Position, Department (EEE, CSE, CCE, Civil, etc.), IIUC Batch, IEB Membership ID, Division / Center.
- **Qualifications**: Structured sections for Educational, Professional Experience, and Extra-Curricular / Social Leadership qualifications.
- **Search & Filters**: Real-time multi-filter by department, division, position, and batch with ascending/descending ballot sorting.
- **Dual Views**: Responsive card grid view and compact data table view.
- **Export & Print**:
  - Export live candidates to **CSV (Excel)** or **JSON**.
  - Print-ready voter guide layout for campaign flyers and voter ballots.
- **Realtime Cloud Sync**: Optional one-click Firebase Firestore integration for synchronized multi-device access across all web visitors.

---

## 💻 Local Testing

Run with Node.js:
```bash
node server.js
```
Then visit `http://localhost:3000/` in your browser.
