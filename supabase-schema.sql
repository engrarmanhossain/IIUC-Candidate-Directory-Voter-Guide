-- =========================================================================
-- IEB ELECTION: IIUC CANDIDATE DIRECTORY & VOTER GUIDE
-- Supabase Database Schema, User Roles (app_users), RLS & Storage Setup
-- =========================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create Users & Roles Table (app_users)
-- Any user has an email and a 'role' column. If role = 'admin', they get admin privileges!
CREATE TABLE IF NOT EXISTS public.app_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'moderator', 'user')),
    name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexing for user roles
CREATE INDEX IF NOT EXISTS idx_app_users_email ON public.app_users(email);
CREATE INDEX IF NOT EXISTS idx_app_users_role ON public.app_users(role);

-- Enable RLS on app_users
ALTER TABLE public.app_users ENABLE ROW LEVEL SECURITY;

-- Allow anyone to check user roles by email
CREATE POLICY "Allow public read app_users by email"
ON public.app_users
FOR SELECT
USING (true);

-- Allow admins to manage app_users
CREATE POLICY "Admins can manage app_users"
ON public.app_users
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.app_users 
        WHERE LOWER(app_users.email) = LOWER(auth.jwt() ->> 'email') 
        AND app_users.role = 'admin'
    )
    OR (auth.jwt() ->> 'role') = 'service_role'
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.app_users 
        WHERE LOWER(app_users.email) = LOWER(auth.jwt() ->> 'email') 
        AND app_users.role = 'admin'
    )
    OR (auth.jwt() ->> 'role') = 'service_role'
);

-- Seed initial admin user
INSERT INTO public.app_users (email, role, name)
VALUES 
('armanhossain.eee.info@gmail.com', 'admin', 'Engr. Arman Hossain')
ON CONFLICT (email) DO UPDATE SET role = 'admin';

-- 3. Create Candidates Table
CREATE TABLE IF NOT EXISTS public.candidates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    ballot_no TEXT NOT NULL,
    election_session TEXT DEFAULT '2025-2026',
    candidate_for TEXT NOT NULL,
    center TEXT DEFAULT '',
    division TEXT DEFAULT '',
    department TEXT NOT NULL,
    batch TEXT NOT NULL,
    membership_id TEXT NOT NULL,
    image_url TEXT DEFAULT '',
    education TEXT DEFAULT '',
    professional TEXT DEFAULT '',
    extra_curricular TEXT DEFAULT '',
    manifesto TEXT DEFAULT '',
    phone TEXT DEFAULT '',
    email TEXT DEFAULT '',
    social TEXT DEFAULT '',
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('approved', 'pending', 'rejected')),
    submitter_name TEXT DEFAULT 'Public Submitter',
    submitter_email TEXT DEFAULT '',
    deletion_requested BOOLEAN DEFAULT FALSE,
    deletion_reason TEXT,
    deletion_details TEXT,
    deletion_requester TEXT,
    deletion_requested_at TIMESTAMPTZ,
    approved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexing for fast search and filtering
CREATE INDEX IF NOT EXISTS idx_candidates_status ON public.candidates(status);
CREATE INDEX IF NOT EXISTS idx_candidates_ballot_no ON public.candidates(ballot_no);
CREATE INDEX IF NOT EXISTS idx_candidates_session ON public.candidates(election_session);
CREATE INDEX IF NOT EXISTS idx_candidates_department ON public.candidates(department);
CREATE INDEX IF NOT EXISTS idx_candidates_center ON public.candidates(center);
CREATE INDEX IF NOT EXISTS idx_candidates_division ON public.candidates(division);

-- Migration query for existing databases:
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS election_session TEXT DEFAULT '2025-2026';
ALTER TABLE public.candidates ADD COLUMN IF NOT EXISTS center TEXT DEFAULT '';

-- 4. Row-Level Security (RLS) on Candidates
ALTER TABLE public.candidates ENABLE ROW LEVEL SECURITY;

-- Policy 1: Public Read - Anyone can view APPROVED candidates
CREATE POLICY "Public can view approved candidates"
ON public.candidates
FOR SELECT
USING (status = 'approved');

-- Policy 2: Public Insert - Anyone can submit candidates (forced to pending status)
CREATE POLICY "Public can submit pending candidates"
ON public.candidates
FOR INSERT
WITH CHECK (status = 'pending');

-- Policy 3: Public Update - Anyone can submit a deletion request on an approved candidate
CREATE POLICY "Public can request deletion on approved candidates"
ON public.candidates
FOR UPDATE
USING (status = 'approved')
WITH CHECK (deletion_requested = TRUE);

-- Policy 4: Admin Full Access - Any user whose email in app_users has role = 'admin'
CREATE POLICY "Admin full access based on app_users role"
ON public.candidates
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.app_users 
        WHERE LOWER(app_users.email) = LOWER(auth.jwt() ->> 'email')
        AND app_users.role = 'admin'
    )
    OR (auth.jwt() ->> 'role') = 'service_role'
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.app_users 
        WHERE LOWER(app_users.email) = LOWER(auth.jwt() ->> 'email')
        AND app_users.role = 'admin'
    )
    OR (auth.jwt() ->> 'role') = 'service_role'
);

-- 5. Enable Supabase Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.candidates;
ALTER PUBLICATION supabase_realtime ADD TABLE public.app_users;

-- 6. Storage Bucket for Candidate Photos
INSERT INTO storage.buckets (id, name, public) 
VALUES ('candidate-photos', 'candidate-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage Policies for candidate-photos bucket
CREATE POLICY "Public can view candidate photos"
ON storage.objects FOR SELECT
USING (bucket_id = 'candidate-photos');

CREATE POLICY "Anyone can upload candidate photos"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'candidate-photos');

-- 7. Initial Seed Candidates
INSERT INTO public.candidates (
    name, ballot_no, candidate_for, center, division, department, batch, membership_id,
    image_url, education, professional, extra_curricular, manifesto, phone, email, social, status
) VALUES 
(
    'Engr. Arman Hossain', '07', 'Center Vice-Chairman (Academic & HRD)', 'Chattogram Center', 'Electrical Engineering Division', 'EEE', '18th Batch (Autumn 2008)', 'M-28491',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in Electrical and Electronic Engineering (EEE), IIUC\n• M.Sc. in Renewable Energy & Power Systems\n• HSC (Science), Chittagong College',
    '• Lead Electrical & Automation Systems Engineer\n• 10+ years professional industrial & engineering research experience\n• Certified in High Voltage Power Grid and Industrial IoT',
    '• Former President, IIUC EEE Club & RoboTech Society\n• Senior Member, IEEE Bangladesh Section & IEB Chittagong Center\n• Lead Organizer of All-Bangladesh Engineering Career Expo',
    'Dedicated to empowering fresh IIUC engineering graduates, introducing state-of-the-art IEB technical workshops, and defending engineer rights.',
    '+880 1819-234567', 'armanhossain.eee.info@gmail.com', 'https://linkedin.com/in/armanhossain', 'approved'
),
(
    'Engr. Tanvir Ahmed Chowdhury', '03', 'Honorary Center Secretary', 'Chattogram Center', 'Computer Engineering Division', 'CSE', '14th Batch (Spring 2006)', 'F-14280',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in Computer Science & Engineering (CSE), IIUC\n• Executive MBA in Project Management, IBA\n• CISSP Certified',
    '• Chief Technology Officer (CTO) at Premier Software Solutions\n• 15+ years experience in large-scale government digitization projects',
    '• Founding General Secretary, IIUC Computer Club\n• Member, Bangladesh Computer Society (BCS) & IEB Computer Division',
    'Transforming IEB Chittagong Center into a fully automated smart center, providing subsidized cloud certifications for young engineers.',
    '+880 1711-987654', 'engr.tanvir.cse@example.com', 'https://linkedin.com/in/tanvir-ahmed', 'approved'
),
(
    'Engr. Kazi Mahfuzur Rahman', '12', 'Central Council Member (General)', 'Central Council / HQ', 'Civil Engineering Division', 'CE', '10th Batch (Spring 2004)', 'F-09852',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in Civil Engineering, IIUC\n• M.Sc. in Structural Engineering, BUET\n• Professional Engineer (P.Eng.)',
    '• Superintending Engineer, Roads & Highways Department (RHD)\n• Supervised multiple flyover and bridge megaprojects in Chittagong division',
    '• Former General Secretary, IIUC Alumni Association (Central)\n• Patron of Engineers Disaster Relief Team during 2024 floods',
    'Strengthening the national engineering cadre, eliminating non-engineer appointments to technical leadership posts.',
    '+880 1817-554433', 'engr.mahfuz.ce@example.com', 'https://linkedin.com/in/mahfuz-rahman-pe', 'approved'
),
(
    'Engr. Nargis Sultana', '08', 'Division Vice-Chairman (Electrical)', 'Dhaka Center', 'Electrical Engineering Division', 'EEE', '21st Batch (Autumn 2010)', 'M-31204',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in EEE, IIUC (Summa Cum Laude)\n• M.S. in Smart Grid Technologies, Kingston University UK',
    '• Deputy Director (Planning), Power Development Board (BPDB)\n• 9+ years in high-voltage power transmission network expansion',
    '• Chairperson, Women in Engineering (WIE) Chittagong Chapter\n• IIUC Debating Club National Champion',
    'Promoting gender equity in engineering leadership, continuous career training, and industrial internships for young engineering graduates.',
    '+880 1912-334455', 'engr.nargis.eee@example.com', 'https://linkedin.com/in/nargis-sultana-eee', 'approved'
);

-- =========================================================================
-- 8. AUTO-CONFIRM USERS (FIXES "EMAIL NOT CONFIRMED" ERROR)
-- =========================================================================
-- Run this one-time command to immediately confirm all existing unconfirmed users:
UPDATE auth.users 
SET email_confirmed_at = now() 
WHERE email_confirmed_at IS NULL;

-- Automatically confirm email for all future registered users:
CREATE OR REPLACE FUNCTION public.auto_confirm_new_users()
RETURNS TRIGGER AS $$
BEGIN
    NEW.email_confirmed_at = COALESCE(NEW.email_confirmed_at, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_auto_confirm_users ON auth.users;
CREATE TRIGGER trigger_auto_confirm_users
BEFORE INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.auto_confirm_new_users();

