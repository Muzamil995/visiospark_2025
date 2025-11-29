-- ============================================
-- FINAL FIX FOR RLS POLICY
-- Copy and paste into Supabase SQL Editor
-- ============================================

-- STEP 1: Check current INSERT policies
-- (Just to see what's there - copy the output)
SELECT 
  policyname, 
  cmd,
  with_check::text as "Check Clause"
FROM pg_policies 
WHERE tablename = 'profiles' 
  AND cmd = 'INSERT';

-- If you see "auth.uid() = id" or "(auth.uid() = id)" in the Check Clause column,
-- that's the problem! Continue below:

-- ============================================
-- STEP 2: DROP ALL INSERT POLICIES
-- ============================================

-- Drop any INSERT policies (run all of these)
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON profiles;

-- ============================================
-- STEP 3: CREATE THE CORRECT POLICY
-- ============================================

CREATE POLICY "allow_profile_insert"
ON public.profiles
FOR INSERT
WITH CHECK (true);

-- ============================================
-- STEP 4: VERIFY IT WORKED
-- ============================================

-- Run this - should show "allow_profile_insert" with "true"
SELECT 
  policyname, 
  with_check::text as "Check Clause"
FROM pg_policies 
WHERE tablename = 'profiles' 
  AND cmd = 'INSERT';

-- Expected output:
-- policyname           | Check Clause
-- -------------------- | ------------
-- allow_profile_insert | true

-- ============================================
-- IF THE OUTPUT SHOWS "true" - YOU'RE DONE!
-- Go test registration in your app!
-- ============================================
