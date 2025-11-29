# ✅ Supabase Setup Checklist

## Before You Start

- [ ] Open your Supabase project dashboard at https://supabase.com
- [ ] Have the SQL Editor ready (left sidebar → SQL Editor)

---

## Step 1: Fix Database Error (MOST IMPORTANT!)

### In Supabase SQL Editor, run:

```sql
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (true);
```

- [x] SQL executed successfully
- [x] No errors shown

---

## Step 2: Storage Buckets

### Go to: Storage (left sidebar)

### Create 3 buckets (click "New bucket" for each):

#### Bucket 1: avatars

- [x] Name: `avatars`
- [x] Public bucket: ✅ CHECKED
- [x] Click "Create bucket"

#### Bucket 2: files

- [x] Name: `files`
- [x] Public bucket: ✅ CHECKED
- [x] Click "Create bucket"

#### Bucket 3: chat-files

- [x] Name: `chat-files`
- [x] Public bucket: ✅ CHECKED
- [x] Click "Create bucket"

### Add policies to buckets

For **EACH** of the 3 buckets:

1. Click bucket name → Policies tab → "New policy" → "Create from scratch"

2. Add these 3 policies:

**Policy 1: Allow authenticated uploads**

- [ ] Name: `Allow authenticated uploads`
- [ ] Operation: INSERT
- [ ] Target: authenticated

```sql
CREATE POLICY "Allow authenticated uploads" ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'BUCKET_NAME');
```

Replace `BUCKET_NAME` with: avatars, files, or chat-files

**Policy 2: Allow public read**

- [ ] Name: `Allow public read`
- [ ] Operation: SELECT
- [ ] Target: public

```sql
CREATE POLICY "Allow public read" ON storage.objects
FOR SELECT TO public
USING (bucket_id = 'BUCKET_NAME');
```

Replace `BUCKET_NAME` with: avatars, files, or chat-files

**Policy 3: Allow delete own files**

- [ ] Name: `Allow delete own files`
- [ ] Operation: DELETE
- [ ] Target: authenticated

```sql
CREATE POLICY "Allow delete own files" ON storage.objects
FOR DELETE TO authenticated
USING (bucket_id = 'BUCKET_NAME' AND auth.uid()::text = (storage.foldername(name))[1]);
```

Replace `BUCKET_NAME` with: avatars, files, or chat-files

### Repeat for all 3 buckets!

- [ ] avatars bucket: 3 policies added
- [ ] files bucket: 3 policies added
- [ ] chat-files bucket: 3 policies added

---

## Step 3: Enable Realtime

### Go to: Database → Replication (left sidebar)

- [ ] Scroll to "Tables" section
- [ ] Find and enable: `messages` ✅
- [ ] Find and enable: `chat_rooms` ✅
- [ ] Find and enable: `notifications` ✅

**OR** run in SQL Editor:

```sql
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE chat_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
```

- [ ] SQL executed successfully

---

## Step 4: Verify Setup

### Table Editor (left sidebar)

- [ ] All 11 tables exist (profiles, chat_rooms, messages, etc.)

### Authentication → Policies (left sidebar)

- [ ] All tables have RLS enabled (green toggle)

---

## Step 5: Test in App!

### Run your app:

```bash
flutter run
```

### Try Registration:

1. Click "Register"
2. Enter any email and password
3. Click "Sign Up"

### Expected logs:

```
✅ SUCCESS: User signed up: your@email.com
✅ SUCCESS: Profile created successfully
```

- [ ] Registration works without errors
- [ ] User appears in Authentication → Users
- [ ] Profile appears in Table Editor → profiles

---

## ✅ ALL DONE!

If all checkboxes are marked, your Supabase is fully configured! 🎉

## 🆘 Still Have Issues?

See `SUPABASE_SETUP.md` for detailed troubleshooting.
