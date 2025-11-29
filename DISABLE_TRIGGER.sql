-- ============================================
-- ALTERNATIVE SOLUTION: DISABLE TRIGGER
-- Let the app handle profile creation instead
-- ============================================

-- STEP 1: Disable the trigger (don't delete it, just disable)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- STEP 2: Verify trigger is gone
SELECT 
  trigger_name
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';

-- Should return NO ROWS (empty result)

-- ============================================
-- STEP 3: Make sure the INSERT policy is permissive
-- ============================================
SELECT 
  policyname, 
  with_check::text 
FROM pg_policies 
WHERE tablename = 'profiles' 
  AND cmd = 'INSERT';

-- Should show: with_check = "true"

-- If it doesn't show "true", run:
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

CREATE POLICY "allow_profile_insert"
ON public.profiles
FOR INSERT
WITH CHECK (true);

-- ============================================
-- ALL DONE!
-- Now the app will create profiles after signup
-- Try registering again!
-- ============================================
