-- ============================================================
-- SUPABASE STORAGE BUCKETS SETUP
-- ============================================================
-- This script creates the necessary storage buckets for the app
-- Run this in Supabase Dashboard -> Storage -> Create Bucket
-- Or use the Supabase API/CLI
-- ============================================================

-- IMPORTANT: You need to create these buckets manually in Supabase Dashboard
-- Go to: Storage -> New Bucket

-- ============================================================
-- 1. AVATARS BUCKET
-- ============================================================
-- Bucket Name: avatars
-- Public: YES (so avatar images can be displayed)
-- File Size Limit: 2 MB
-- Allowed MIME types: image/jpeg, image/png, image/gif, image/webp

-- RLS Policy for avatars bucket (run in SQL Editor):
CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'avatars' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Avatars are publicly accessible"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'avatars');

CREATE POLICY "Users can update their own avatar"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'avatars' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can delete their own avatar"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'avatars' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- ============================================================
-- 2. FILES BUCKET
-- ============================================================
-- Bucket Name: files
-- Public: NO (private files)
-- File Size Limit: 10 MB
-- Allowed MIME types: (all)

-- RLS Policy for files bucket (run in SQL Editor):
CREATE POLICY "Users can upload their own files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'files' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can view their own files"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'files' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can update their own files"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'files' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can delete their own files"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'files' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- ============================================================
-- 3. CHAT-FILES BUCKET
-- ============================================================
-- Bucket Name: chat-files
-- Public: NO (only chat participants can access)
-- File Size Limit: 5 MB
-- Allowed MIME types: image/*, video/*, application/pdf

-- RLS Policy for chat-files bucket (run in SQL Editor):
CREATE POLICY "Users can upload chat files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'chat-files');

CREATE POLICY "Users can view chat files they have access to"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'chat-files' AND
  EXISTS (
    SELECT 1 FROM chat_participants
    WHERE user_id = auth.uid()
    AND room_id::text = (storage.foldername(name))[1]
  )
);

CREATE POLICY "Users can delete their own chat files"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'chat-files' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================
-- Run these to verify buckets are set up correctly:

-- Check if buckets exist:
SELECT * FROM storage.buckets;

-- Check bucket policies:
SELECT * FROM storage.objects_policies;

-- ============================================================
-- MANUAL SETUP STEPS (If not using SQL)
-- ============================================================
-- 1. Go to Supabase Dashboard -> Storage
-- 2. Click "New Bucket" for each bucket below:

-- BUCKET 1: avatars
--   - Name: avatars
--   - Public: YES
--   - File size limit: 2 MB
--   - Allowed MIME types: image/jpeg, image/png, image/gif, image/webp

-- BUCKET 2: files
--   - Name: files
--   - Public: NO
--   - File size limit: 10 MB
--   - Allowed MIME types: (all)

-- BUCKET 3: chat-files
--   - Name: chat-files
--   - Public: NO
--   - File size limit: 5 MB
--   - Allowed MIME types: image/*, video/*, application/pdf

-- 3. After creating buckets, run the RLS policies above in SQL Editor
-- 4. Test by uploading an avatar in your app
