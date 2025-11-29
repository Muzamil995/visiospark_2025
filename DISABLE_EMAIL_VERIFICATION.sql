-- ============================================
-- DISABLE EMAIL VERIFICATION IN SUPABASE
-- ============================================

-- This SQL is for reference only
-- The main change must be done in Supabase Dashboard UI

-- You need to:
-- 1. Go to Supabase Dashboard
-- 2. Authentication → Settings (or Providers)
-- 3. Find "Email Auth" section
-- 4. DISABLE "Confirm email"
-- 5. Click Save

-- After that, users can login immediately after signup
-- without email verification!

-- ============================================
-- OPTIONAL: Check auth settings
-- ============================================

-- Check current auth config (read-only)
SELECT * FROM auth.config;

-- ============================================
-- NO SQL CHANGES NEEDED
-- Just update the dashboard settings!
-- ============================================
