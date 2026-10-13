# 🚀 Production Deployment Guide: Vercel + Supabase

This guide walks you through deploying the **IEB Election — IIUC Candidate Directory & Voter Guide** to production with **Supabase (Database, Realtime & Storage)** and **Vercel (Global Hosting & Edge Network)**.

---

## 🗄️ Step 1: Set Up Supabase (Database & Realtime)

1. **Create Free Project**:
   - Go to [https://supabase.com](https://supabase.com) and log in.
   - Click **"New Project"**, name it `ieb-iiuc-candidates`, choose a database password, and select region (e.g. `Singapore` or closest to Bangladesh).

2. **Execute Database Schema & Policies**:
   - In your Supabase Dashboard, click on **SQL Editor** in the left sidebar.
   - Click **"New Query"**, open and copy the entire contents of [`supabase-schema.sql`](./supabase-schema.sql).
   - Paste into the query editor and click **Run** (Ctrl + Enter).
   - *This creates the `candidates` table, enables Row-Level Security (RLS), adds permissions for public submissions + admin approval, creates the `candidate-photos` public storage bucket, and seeds realistic IIUC candidates.*

3. **Copy API Credentials**:
   - In Supabase, navigate to **Project Settings** (gear icon) → **API**.
   - Note down:
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
   - Add the following two variables:
     - `SUPABASE_URL`: `https://<your-project-id>.supabase.co`
     - `SUPABASE_ANON_KEY`: `<your-anon-public-key>`

3. **Deploy**:
   - Framework Preset: **Other** (or leave default).
   - Root Directory: `./` (leave default).
   - Click **"Deploy"**.
   - In less than 30 seconds, Vercel will build and give you a live production URL:
     `https://iiuc-candidate-directory-voter-guide.vercel.app`

---

## 🛡️ Step 3: Admin Dashboard Access

- Navigate to your deployed Vercel site.
- Click **`Admin`** at the top right.
- **Admin Email**: `armanhossain.eee.info@gmail.com`
- **Default Passcode / PIN**: `arman2026`
- Once logged in, you can approve public submissions, review removal requests, and directly manage all candidates with real-time sync across all connected users!
