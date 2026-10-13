// Vercel Serverless Function: Exposes Supabase public configuration
export default function handler(req, res) {
  res.setHeader('Cache-Control', 's-maxage=3600, stale-while-revalidate');
  res.setHeader('Content-Type', 'application/json');

  const supabaseUrl = process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL || '';
  const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

  res.status(200).json({
    supabaseUrl,
    supabaseAnonKey,
    adminEmail: 'armanhossain.eee.info@gmail.com'
  });
}
