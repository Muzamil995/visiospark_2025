-- ============================================
-- STEP 1: CHECK CURRENT RLS POLICIES
-- ============================================
-- Run this first to see what policies exist
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;

-- ============================================
-- STEP 2: CHECK IF TRIGGER EXISTS
-- ============================================
SELECT 
  trigger_name, 
  event_manipulation, 
  action_statement,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'users'
  AND event_object_schema = 'auth'
ORDER BY trigger_name;

-- ============================================
-- STEP 3: CHECK TRIGGER FUNCTION
-- ============================================
SELECT 
  routine_name,
  routine_definition
FROM information_schema.routines
WHERE routine_name = 'handle_new_user'
  AND routine_schema = 'public';

-- ============================================
-- AFTER RUNNING ABOVE, COPY THE RESULTS AND:
-- ============================================

-- If policies show 'auth.uid() = id', then run this fix:
-- DROP ALL OLD POLICIES
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON profiles;
DROP POLICY IF EXISTS "Allow profile creation" ON profiles;

-- CREATE NEW PERMISSIVE POLICY
CREATE POLICY "Allow all inserts to profiles" 
ON profiles
FOR INSERT 
WITH CHECK (true);

-- Verify it was created
SELECT policyname, with_check FROM pg_policies WHERE tablename = 'profiles' AND cmd = 'INSERT';
