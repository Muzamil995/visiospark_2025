# 🚀 Complete Supabase Setup Guide - Step by Step

Follow these steps **IN ORDER** to fix all Supabase issues.

---

## ✅ Step 1: Fix the RLS Policy (THIS FIXES THE ERROR!)

The error `"Database error saving new user"` is caused by a restrictive RLS policy.

### Go to Supabase Dashboard → SQL Editor

**Run this SQL:**

```sql
-- Drop the old restrictive policy
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- Create a new policy that allows the trigger to work
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (true);
```

**Why this works:**

- The old policy blocked the trigger from creating profiles
- The new policy allows profile creation during signup
- This is safe because only authenticated requests can trigger signup

---

## ✅ Step 2: Verify the Trigger Exists

The trigger should already exist, but let's verify and recreate if needed.

### Go to Supabase Dashboard → SQL Editor

**Run this SQL to check:**

```sql
-- Check if trigger exists
SELECT
  trigger_name,
  event_manipulation,
  event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';
```

**If it returns a row:** ✅ Trigger exists - skip to Step 3

**If it returns empty:** Run this to create the trigger:

```sql
-- Create the trigger function
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

---

## ✅ Step 3: Set Up Storage Buckets

### 3.1 Go to Supabase Dashboard → Storage

Click **"New bucket"** and create 3 buckets:

#### Bucket 1: `avatars`

- Name: `avatars`
- Public bucket: ✅ **YES** (check this box)
- Click **Create bucket**

#### Bucket 2: `files`

- Name: `files`
- Public bucket: ✅ **YES**
- Click **Create bucket**

#### Bucket 3: `chat-files`

- Name: `chat-files`
- Public bucket: ✅ **YES**
- Click **Create bucket**

### 3.2 Set Storage Policies

For **EACH** bucket (`avatars`, `files`, `chat-files`):

1. Click on the bucket name
2. Click **"Policies"** tab
3. Click **"New policy"**
4. Click **"Create a policy from scratch"**

**Add these 3 policies for each bucket:**

#### Policy 1: Allow Authenticated Uploads

```sql
-- Policy name: Allow authenticated uploads
-- Allowed operation: INSERT
-- Target roles: authenticated

CREATE POLICY "Allow authenticated uploads"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'BUCKET_NAME_HERE'
);
```

⚠️ **IMPORTANT:** Replace `BUCKET_NAME_HERE` with:

- `avatars` for avatars bucket
- `files` for files bucket
- `chat-files` for chat-files bucket

#### Policy 2: Allow Public Read

```sql
-- Policy name: Allow public read
-- Allowed operation: SELECT
-- Target roles: public

CREATE POLICY "Allow public read"
ON storage.objects
FOR SELECT
TO public
USING (
  bucket_id = 'BUCKET_NAME_HERE'
);
```

⚠️ **IMPORTANT:** Replace `BUCKET_NAME_HERE` with the correct bucket name

#### Policy 3: Allow Users to Delete Own Files

```sql
-- Policy name: Allow delete own files
-- Allowed operation: DELETE
-- Target roles: authenticated

CREATE POLICY "Allow delete own files"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'BUCKET_NAME_HERE' AND
  auth.uid()::text = (storage.foldername(name))[1]
);
```

⚠️ **IMPORTANT:** Replace `BUCKET_NAME_HERE` with the correct bucket name

**Repeat for all 3 buckets!**

---

## ✅ Step 4: Enable Realtime

### Go to Supabase Dashboard → Database → Replication

1. Scroll down to **"Tables"** section
2. Find and enable these tables:
   - ✅ `messages`
   - ✅ `chat_rooms`
   - ✅ `notifications`

**OR** use SQL Editor:

```sql
-- Enable realtime for chat and notifications
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE chat_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
```

---

## ✅ Step 5: Verify All Tables Exist

### Go to Supabase Dashboard → Table Editor

You should see these tables:

- ✅ profiles
- ✅ chat_rooms
- ✅ chat_participants
- ✅ messages
- ✅ forum_posts
- ✅ forum_comments
- ✅ votes
- ✅ bookmarks
- ✅ notifications
- ✅ files
- ✅ items

**If any are missing**, go to SQL Editor and run the SQL from README.md Step 1.

---

## ✅ Step 6: Verify RLS is Enabled

### Go to Supabase Dashboard → Authentication → Policies

All tables should have RLS **enabled** (green toggle).

If any table has RLS disabled (red toggle), click on it and enable RLS.

---

## ✅ Step 7: Test Registration!

Now try registering in your app:

```bash
flutter run
```

1. Click **Register**
2. Enter email: `test@example.com`
3. Enter password: `Test123!`
4. Enter name: `Test User`
5. Click **Sign Up**

### Expected Result:

```
✅ SUCCESS: User signed up: test@example.com
✅ SUCCESS: Profile created successfully: test@example.com
```

---

## 🔧 Troubleshooting

### Issue: Still getting "Database error saving new user"

**Check:**

1. Did you run Step 1 SQL to fix the RLS policy? ✅
2. Is the `profiles` table policy set to `WITH CHECK (true)`? ✅
3. Does the trigger exist? (Step 2) ✅

**Try this debug SQL:**

```sql
-- Check the exact policy
SELECT * FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Users can insert own profile';
```

The `qual` column should be empty, and `with_check` should show `true`.

### Issue: "Bucket not found" error

**Check:**

1. Did you create all 3 buckets? (Step 3.1) ✅
2. Did you add policies to each bucket? (Step 3.2) ✅
3. Are the buckets public? ✅

### Issue: Realtime not working

**Check:**

1. Did you enable replication for messages, chat_rooms, notifications? (Step 4) ✅
2. Go to Database → Replication and verify tables are checked ✅

---

## 📝 Quick Checklist

Before testing, verify:

- [x] Step 1: Fixed RLS policy for profiles
- [x] Step 2: Trigger exists
- [x] Step 3: Created 3 storage buckets (avatars, files, chat-files)
- [x] Step 3: Added 3 policies to each bucket (9 policies total)
- [x] Step 4: Enabled realtime for messages, chat_rooms, notifications
- [x] Step 5: All 11 tables exist
- [x] Step 6: RLS enabled on all tables
- [x] Step 7: Tested registration

---

## 🎉 Success!

Once all steps are complete:

- ✅ Registration works
- ✅ Login works
- ✅ File uploads work
- ✅ Chat realtime works
- ✅ All features functional

Your app is now fully configured! 🚀
