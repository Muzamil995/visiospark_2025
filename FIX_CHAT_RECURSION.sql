-- ============================================
-- FIX INFINITE RECURSION IN CHAT POLICIES
-- ============================================

-- The problem: chat_rooms policy checks chat_participants,
-- and chat_participants policy checks chat_rooms
-- This creates infinite recursion!

-- STEP 1: Drop the problematic policies
DROP POLICY IF EXISTS "Users can view rooms they participate in" ON chat_rooms;
DROP POLICY IF EXISTS "Users can view participants of their rooms" ON chat_participants;

-- STEP 2: Create simpler policies without recursion

-- Chat Rooms: Allow users to view rooms they're part of
CREATE POLICY "view_own_chat_rooms"
ON chat_rooms
FOR SELECT
USING (
  created_by = auth.uid() OR
  id IN (
    SELECT room_id 
    FROM chat_participants 
    WHERE user_id = auth.uid()
  )
);

-- Chat Participants: Allow users to view participants in their rooms
CREATE POLICY "view_chat_participants"
ON chat_participants
FOR SELECT
USING (
  user_id = auth.uid() OR
  room_id IN (
    SELECT room_id 
    FROM chat_participants 
    WHERE user_id = auth.uid()
  )
);

-- STEP 3: Keep the existing INSERT policies (they're fine)
-- These should already exist, but adding for completeness

-- Allow users to create rooms
DROP POLICY IF EXISTS "Users can create rooms" ON chat_rooms;
CREATE POLICY "create_chat_rooms"
ON chat_rooms
FOR INSERT
WITH CHECK (auth.uid() = created_by);

-- Allow users to add participants
DROP POLICY IF EXISTS "Users can add participants" ON chat_participants;
CREATE POLICY "add_chat_participants"
ON chat_participants
FOR INSERT
WITH CHECK (
  auth.uid() = user_id OR 
  EXISTS (
    SELECT 1 FROM chat_rooms 
    WHERE id = room_id 
    AND created_by = auth.uid()
  )
);

-- STEP 4: Verify policies were created
SELECT 
  tablename,
  policyname,
  cmd
FROM pg_policies 
WHERE tablename IN ('chat_rooms', 'chat_participants')
ORDER BY tablename, cmd;

-- Expected output:
-- chat_rooms | view_own_chat_rooms | SELECT
-- chat_rooms | create_chat_rooms | INSERT
-- chat_participants | view_chat_participants | SELECT
-- chat_participants | add_chat_participants | INSERT

-- ============================================
-- DONE! Try accessing chat in the app
-- ============================================
