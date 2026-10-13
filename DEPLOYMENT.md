# 🚀 Production Deployment Guide: Vercel + Supabase

This guide walks you through deploying the **IEB Election — IIUC Candidate Directory & Voter Guide** to production with **Supabase (Database, Realtime & Storage)** and **Vercel (Global Hosting & Edge Network)**.

---

## 🗄️ Step 1: Set Up Supabase (Database, Auth & Realtime)

1. **Create Free Project**:
   - Go to [https://supabase.com](https://supabase.com) and log in.
   - Click **"New Project"**, name it `ieb-iiuc-candidates`, choose a database password, and select region (e.g. `Singapore`).

2. **Execute Database Schema & Policies**:
   - In your Supabase Dashboard, click on **SQL Editor** in the left sidebar.
   - Click **"New Query"**, copy the entire contents of [`supabase-schema.sql`](./supabase-schema.sql), paste into the editor, and click **Run**.
   - *This creates:*
     - The `app_users` table (stores email and `role`: `'admin'` or `'user'`).
     - The `candidates` table with Row-Level Security (RLS) linked to `app_users`.
     - The `candidate-photos` public storage bucket for photos.
     - Realtime publication on both tables.

3. **Create Your Admin User in Supabase Auth**:
   - In Supabase, go to **Authentication** → **Users**.
   - Click **"Add user"** → **"Create user"**.
   - Enter your email (e.g. `armanhossain.eee.info@gmail.com`) and choose your secure password.
   - Click **"Auto Confirm User"** (or verify via email).

4. **Verify / Add User Role in `app_users`**:
   - In Supabase, go to **Table Editor** → **`app_users`**.
   - Ensure a row exists for your email with `role` = **`admin`**:
     | email | role | name |
     |---|---|---|
     | `armanhossain.eee.info@gmail.com` | `admin` | `Engr. Arman Hossain` |
   - *(Note: You can add any other email and set `role` to `'admin'` to grant them admin access!)*

5. **Copy API Credentials**:
   - In Supabase, navigate to **Project Settings** (gear icon) → **API**.
   - Copy:
     - **Project URL**: `https://<your-project-id>.supabase.co`
     - **anon / public key**: `eyJhbGciOi...`

---

## ⚡ Step 2: Deploy to Vercel

1. **Import Repository**:
   - Go to [https://vercel.com](https://vercel.com) and log in with your GitHub account.
   - Click **"Add New..."** → **"Project"**.
   - Under *Import Git Repository*, select **`IIUC-Candidate-Directory-Voter-Guide`**.

2. **Add Environment Variables**:
   - In the Vercel project configuration screen, expand **Environment Variables**.
   - Add:
     - `SUPABASE_URL`: `https://<your-project-id>.supabase.co`
     - `SUPABASE_ANON_KEY`: `<your-anon-public-key>`

3. **Deploy**:
   - Click **"Deploy"**.
   - In ~30 seconds, Vercel gives you your live production URL.

---

## 🛡️ Step 3: Admin Sign In & Role Management

- Open your site and click **`Admin`** at the top right.
- Sign in with the email and password you created in Supabase Auth.
- The system automatically checks `app_users` table for your email:
  - If `role === 'admin'`: **Admin Mode** activates immediately!
  - If `role !== 'admin'`: Access is denied.
- Admins can also click **`User Roles`** in the top bar to promote any other user's email to `admin` right from the dashboard.
