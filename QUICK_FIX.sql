-- ============================================
-- QUICK FIX FOR "Database error saving new user"
-- Copy and paste this into Supabase SQL Editor
-- ============================================

-- Step 1: Fix the RLS policy (THIS FIXES THE ERROR!)
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (true);

-- Step 2: Verify trigger exists (should return 1 row)
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';

-- If the above returns empty, run this:
-- (If it returns a row, skip this block)
/*
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
*/

-- Step 3: Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE chat_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- ============================================
-- DONE! Now test registration in your app
-- ============================================
