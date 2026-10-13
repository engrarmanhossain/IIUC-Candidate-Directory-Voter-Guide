-- =========================================================================
-- IEB ELECTION: IIUC CANDIDATE DIRECTORY & VOTER GUIDE
-- Supabase Database Schema, Row-Level Security (RLS) & Storage Setup
-- =========================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create Candidates Table
CREATE TABLE IF NOT EXISTS public.candidates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    ballot_no TEXT NOT NULL,
    candidate_for TEXT NOT NULL,
    division TEXT NOT NULL,
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
CREATE INDEX IF NOT EXISTS idx_candidates_department ON public.candidates(department);
CREATE INDEX IF NOT EXISTS idx_candidates_division ON public.candidates(division);

-- 3. Row-Level Security (RLS)
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

-- Policy 4: Admin Full Access - Authenticated admin (armanhossain.eee.info@gmail.com)
CREATE POLICY "Admin full access for armanhossain"
ON public.candidates
FOR ALL
TO authenticated
USING (
    (auth.jwt() ->> 'email') = 'armanhossain.eee.info@gmail.com'
    OR (auth.jwt() ->> 'role') = 'service_role'
)
WITH CHECK (
    (auth.jwt() ->> 'email') = 'armanhossain.eee.info@gmail.com'
    OR (auth.jwt() ->> 'role') = 'service_role'
);

-- 4. Enable Supabase Realtime on Candidates Table
ALTER PUBLICATION supabase_realtime ADD TABLE public.candidates;

-- 5. Storage Bucket for Candidate Photos
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

-- 6. Initial Seed Candidates
INSERT INTO public.candidates (
    name, ballot_no, candidate_for, division, department, batch, membership_id,
    image_url, education, professional, extra_curricular, manifesto, phone, email, social, status
) VALUES 
(
    'Engr. Arman Hossain', '07', 'Center Vice-Chairman (Academic & HRD)', 'Chattogram Center', 'EEE', '18th Batch (Autumn 2008)', 'M-28491',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in Electrical and Electronic Engineering (EEE), IIUC\n• M.Sc. in Renewable Energy & Power Systems\n• HSC (Science), Chittagong College',
    '• Lead Electrical & Automation Systems Engineer\n• 10+ years professional industrial & engineering research experience\n• Certified in High Voltage Power Grid and Industrial IoT',
    '• Former President, IIUC EEE Club & RoboTech Society\n• Senior Member, IEEE Bangladesh Section & IEB Chittagong Center\n• Lead Organizer of All-Bangladesh Engineering Career Expo',
    'Dedicated to empowering fresh IIUC engineering graduates, introducing state-of-the-art IEB technical workshops, and defending engineer rights.',
    '+880 1819-234567', 'armanhossain.eee.info@gmail.com', 'https://linkedin.com/in/armanhossain', 'approved'
),
(
    'Engr. Tanvir Ahmed Chowdhury', '03', 'Honorary Center Secretary', 'Chattogram Center', 'CSE', '14th Batch (Spring 2006)', 'F-14280',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in Computer Science & Engineering (CSE), IIUC\n• Executive MBA in Project Management, IBA\n• CISSP Certified',
    '• Chief Technology Officer (CTO) at Premier Software Solutions\n• 15+ years experience in large-scale government digitization projects',
    '• Founding General Secretary, IIUC Computer Club\n• Member, Bangladesh Computer Society (BCS) & IEB Computer Division',
    'Transforming IEB Chittagong Center into a fully automated smart center, providing subsidized cloud certifications for young engineers.',
    '+880 1711-987654', 'engr.tanvir.cse@example.com', 'https://linkedin.com/in/tanvir-ahmed', 'approved'
),
(
    'Engr. Kazi Mahfuzur Rahman', '12', 'Central Council Member (General)', 'Central Council', 'CE', '10th Batch (Spring 2004)', 'F-09852',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in Civil Engineering, IIUC\n• M.Sc. in Structural Engineering, BUET\n• Professional Engineer (P.Eng.)',
    '• Superintending Engineer, Roads & Highways Department (RHD)\n• Supervised multiple flyover and bridge megaprojects in Chittagong division',
    '• Former General Secretary, IIUC Alumni Association (Central)\n• Patron of Engineers Disaster Relief Team during 2024 floods',
    'Strengthening the national engineering cadre, eliminating non-engineer appointments to technical leadership posts.',
    '+880 1817-554433', 'engr.mahfuz.ce@example.com', 'https://linkedin.com/in/mahfuz-rahman-pe', 'approved'
),
(
    'Engr. Nargis Sultana', '08', 'Division Vice-Chairman (Electrical)', 'Electrical Engineering Division', 'EEE', '21st Batch (Autumn 2010)', 'M-31204',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
    '• B.Sc. in EEE, IIUC (Summa Cum Laude)\n• M.S. in Smart Grid Technologies, Kingston University UK',
    '• Deputy Director (Planning), Power Development Board (BPDB)\n• 9+ years in high-voltage power transmission network expansion',
    '• Chairperson, Women in Engineering (WIE) Chittagong Chapter\n• IIUC Debating Club National Champion',
    'Promoting gender equity in engineering leadership, continuous career training, and industrial internships for young engineering graduates.',
    '+880 1912-334455', 'engr.nargis.eee@example.com', 'https://linkedin.com/in/nargis-sultana-eee', 'approved'
);
