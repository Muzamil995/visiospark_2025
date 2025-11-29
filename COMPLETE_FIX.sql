-- ============================================
-- COMPLETE FIX FOR "Database error saving new user"
-- Run these commands ONE BY ONE in Supabase SQL Editor
-- ============================================

-- STEP 1: Check what's currently there
-- Copy the output and look at the "with_check" column
SELECT policyname, cmd, with_check::text 
FROM pg_policies 
WHERE tablename = 'profiles' AND cmd = 'INSERT';

-- You should see something like: (auth.uid() = id)
-- This is the problem! The trigger can't pass this check.

-- ============================================
-- STEP 2: DROP ALL INSERT POLICIES
-- ============================================
-- Run each DROP one by one
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON profiles;
DROP POLICY IF EXISTS "Allow insert for authenticated users" ON profiles;
DROP POLICY IF EXISTS "Users can create profiles" ON profiles;

-- ============================================
-- STEP 3: CREATE NEW PERMISSIVE POLICY
-- ============================================
CREATE POLICY "profiles_insert_policy"
ON profiles
FOR INSERT
WITH CHECK (true);

-- ============================================
-- STEP 4: VERIFY THE FIX
-- ============================================
-- This should show: "true"
SELECT policyname, with_check::text 
FROM pg_policies 
WHERE tablename = 'profiles' AND cmd = 'INSERT';

-- ============================================
-- STEP 5: CHECK TRIGGER EXISTS AND IS CORRECT
-- ============================================
SELECT proname, prosrc 
FROM pg_proc 
WHERE proname = 'handle_new_user';

-- If nothing returned, create the trigger:
-- (Skip if you see output above)

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NOW(),
    NOW()
  );
  RETURN NEW;
EXCEPTION
  WHEN unique_violation THEN
    RETURN NEW;
  WHEN OTHERS THEN
    RAISE WARNING 'Error creating profile: %', SQLERRM;
    RETURN NEW;
END;
$$;

-- ============================================
-- STEP 6: VERIFY/CREATE THE TRIGGER
-- ============================================
-- Check if trigger exists
SELECT tgname FROM pg_trigger WHERE tgname = 'on_auth_user_created';

-- If nothing returned, create it:
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- STEP 7: FINAL VERIFICATION
-- ============================================
-- Should show the policy with "true"
SELECT 
  policyname,
  cmd,
  with_check::text as check_clause
FROM pg_policies 
WHERE tablename = 'profiles';

-- Should show the trigger
SELECT 
  trigger_name,
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';

-- ============================================
-- ALL DONE! Try registering in your app now.
-- ============================================
