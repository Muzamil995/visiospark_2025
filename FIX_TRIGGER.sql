-- ============================================
-- FIX THE TRIGGER FUNCTION
-- The current trigger might be failing silently
-- ============================================

-- STEP 1: Check the current trigger function
SELECT proname, prosrc 
FROM pg_proc 
WHERE proname = 'handle_new_user';

-- STEP 2: Drop and recreate the trigger function with proper error handling
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Try to insert the profile
  INSERT INTO public.profiles (id, email, full_name, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't fail the user creation
    RAISE WARNING 'Error in handle_new_user: % %', SQLERRM, SQLSTATE;
    RETURN NEW;
END;
$$;

-- STEP 3: Recreate the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- STEP 4: Verify it was created
SELECT 
  trigger_name,
  event_manipulation,
  action_timing,
  action_statement
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';

-- ============================================
-- STEP 5: Test by checking if function exists
-- ============================================
SELECT 
  routine_name,
  routine_type,
  security_type
FROM information_schema.routines
WHERE routine_name = 'handle_new_user'
  AND routine_schema = 'public';

-- Should show:
-- routine_name     | routine_type | security_type
-- ---------------- | ------------ | -------------
-- handle_new_user  | FUNCTION     | DEFINER

-- ============================================
-- ALL DONE! Try registering again in your app
-- ============================================
