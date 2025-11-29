# VisioSpark 2025 - Hackathon Template

A comprehensive Flutter hackathon template with Supabase backend, designed to help developers quickly build feature-rich applications in 3-4 hours.

## Features

- **Authentication**: Sign up, sign in, forgot password, change password
- **User Profiles**: Profile management with avatar upload
- **Real-time Chat**: 1-to-1 and group messaging
- **Community Forum**: Posts, comments, upvoting/downvoting
- **AI Assistant**: Gemini AI integration for intelligent assistance
- **Dashboard**: Stats cards, charts (bar, line, pie)
- **Theme Support**: Light/Dark mode with persistence
- **File Storage**: Upload images, PDFs, videos to Supabase Storage

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Supabase** - Backend as a Service (Auth, Database, Storage, Realtime)
- **Provider** - State management
- **Google Generative AI** - Gemini AI integration
- **FL Chart** - Beautiful charts
- **Google Fonts** - Typography

## Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK
- A Supabase account

### 1. Clone & Install Dependencies

```bash
git clone <your-repo-url>
cd visiospark_2025
flutter pub get
```

### 2. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to **Settings > API** and copy your **Project URL** and **anon public key**
3. Update `lib/core/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 3. Database Setup

Go to **SQL Editor** in your Supabase dashboard and run the following SQL scripts in order:

#### Step 1: Create All Tables

```sql
-- ============================================
-- STEP 1: CREATE ALL TABLES FIRST
-- ============================================

-- PROFILES TABLE
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  phone TEXT,
  location TEXT,
  website TEXT,
  is_online BOOLEAN DEFAULT false,
  last_seen TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- CHAT ROOMS TABLE
CREATE TABLE chat_rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT,
  is_group BOOLEAN DEFAULT false,
  image_url TEXT,
  last_message TEXT,
  last_message_at TIMESTAMPTZ,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- CHAT PARTICIPANTS TABLE
CREATE TABLE chat_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID REFERENCES chat_rooms(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT DEFAULT 'member',
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(room_id, user_id)
);

-- MESSAGES TABLE
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID REFERENCES chat_rooms(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  content TEXT,
  type TEXT DEFAULT 'text',
  file_url TEXT,
  file_name TEXT,
  file_size BIGINT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- FORUM POSTS TABLE
CREATE TABLE forum_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT DEFAULT 'general',
  tags TEXT[],
  image_url TEXT,
  upvotes INTEGER DEFAULT 0,
  downvotes INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  is_pinned BOOLEAN DEFAULT false,
  is_closed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- FORUM COMMENTS TABLE
CREATE TABLE forum_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID REFERENCES forum_posts(id) ON DELETE CASCADE,
  author_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  parent_id UUID REFERENCES forum_comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  upvotes INTEGER DEFAULT 0,
  downvotes INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- VOTES TABLE
CREATE TABLE votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  post_id UUID REFERENCES forum_posts(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES forum_comments(id) ON DELETE CASCADE,
  vote_type TEXT NOT NULL CHECK (vote_type IN ('up', 'down')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, post_id),
  UNIQUE(user_id, comment_id)
);

-- BOOKMARKS TABLE
CREATE TABLE bookmarks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  post_id UUID REFERENCES forum_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

-- NOTIFICATIONS TABLE
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT,
  type TEXT DEFAULT 'general',
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- FILES TABLE
CREATE TABLE files (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  path TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT,
  size BIGINT,
  bucket TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- GENERIC ITEMS TABLE (for any CRUD needs)
CREATE TABLE items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  title TEXT,
  description TEXT,
  category TEXT,
  status TEXT DEFAULT 'active',
  data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Step 2: Enable RLS on All Tables

```sql
-- ============================================
-- STEP 2: ENABLE ROW LEVEL SECURITY
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE files ENABLE ROW LEVEL SECURITY;
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
```

#### Step 3: Create All Policies

```sql
-- ============================================
-- STEP 3: CREATE ALL POLICIES
-- ============================================

-- PROFILES POLICIES
CREATE POLICY "Public profiles are viewable by everyone" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (true);

-- CHAT ROOMS POLICIES
CREATE POLICY "Users can view rooms they participate in" ON chat_rooms
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chat_participants
      WHERE chat_participants.room_id = chat_rooms.id
      AND chat_participants.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create rooms" ON chat_rooms
  FOR INSERT WITH CHECK (auth.uid() = created_by);

-- CHAT PARTICIPANTS POLICIES
CREATE POLICY "Users can view participants of their rooms" ON chat_participants
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chat_participants cp
      WHERE cp.room_id = chat_participants.room_id
      AND cp.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can add participants" ON chat_participants
  FOR INSERT WITH CHECK (auth.uid() = user_id OR 
    EXISTS (
      SELECT 1 FROM chat_participants cp
      WHERE cp.room_id = chat_participants.room_id
      AND cp.user_id = auth.uid()
      AND cp.role = 'admin'
    )
  );

-- MESSAGES POLICIES
CREATE POLICY "Users can view messages in their rooms" ON messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chat_participants
      WHERE chat_participants.room_id = messages.room_id
      AND chat_participants.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can send messages to their rooms" ON messages
  FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
      SELECT 1 FROM chat_participants
      WHERE chat_participants.room_id = messages.room_id
      AND chat_participants.user_id = auth.uid()
    )
  );

-- FORUM POSTS POLICIES
CREATE POLICY "Posts are viewable by everyone" ON forum_posts
  FOR SELECT USING (true);

CREATE POLICY "Users can create posts" ON forum_posts
  FOR INSERT WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update own posts" ON forum_posts
  FOR UPDATE USING (auth.uid() = author_id);

CREATE POLICY "Users can delete own posts" ON forum_posts
  FOR DELETE USING (auth.uid() = author_id);

-- FORUM COMMENTS POLICIES
CREATE POLICY "Comments are viewable by everyone" ON forum_comments
  FOR SELECT USING (true);

CREATE POLICY "Users can create comments" ON forum_comments
  FOR INSERT WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update own comments" ON forum_comments
  FOR UPDATE USING (auth.uid() = author_id);

CREATE POLICY "Users can delete own comments" ON forum_comments
  FOR DELETE USING (auth.uid() = author_id);

-- VOTES POLICIES
CREATE POLICY "Users can view all votes" ON votes
  FOR SELECT USING (true);

CREATE POLICY "Users can vote" ON votes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own votes" ON votes
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own votes" ON votes
  FOR DELETE USING (auth.uid() = user_id);

-- BOOKMARKS POLICIES
CREATE POLICY "Users can view own bookmarks" ON bookmarks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create bookmarks" ON bookmarks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks" ON bookmarks
  FOR DELETE USING (auth.uid() = user_id);

-- NOTIFICATIONS POLICIES
CREATE POLICY "Users can view own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- FILES POLICIES
CREATE POLICY "Users can view own files" ON files
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can upload files" ON files
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own files" ON files
  FOR DELETE USING (auth.uid() = user_id);

-- ITEMS POLICIES
CREATE POLICY "Users can view own items" ON items
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create items" ON items
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own items" ON items
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own items" ON items
  FOR DELETE USING (auth.uid() = user_id);
```

#### Step 4: Create Functions and Triggers

```sql
-- ============================================
-- STEP 4: CREATE FUNCTIONS AND TRIGGERS
-- ============================================

-- Trigger to create profile on signup
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
```

#### Step 5: Enable Realtime

```sql
-- ============================================
-- STEP 5: ENABLE REALTIME
-- ============================================

ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE chat_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
```

### 4. Storage Buckets Setup

Go to **Storage** in your Supabase dashboard and create these buckets:

1. **avatars** - For user profile pictures
2. **files** - For general file uploads  
3. **chat-files** - For chat attachments

For each bucket, go to **Policies** and add these policies:

```sql
-- Allow authenticated users to upload
CREATE POLICY "Allow authenticated uploads" ON storage.objects
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Allow public read access
CREATE POLICY "Allow public read" ON storage.objects
  FOR SELECT USING (true);

-- Allow users to delete their own files
CREATE POLICY "Allow delete own files" ON storage.objects
  FOR DELETE USING (auth.uid()::text = (storage.foldername(name))[1]);
```

### 5. Gemini AI Setup (Optional)

1. Get an API key from [Google AI Studio](https://aistudio.google.com/)
2. Update `lib/core/config/gemini_config.dart`:

```dart
static const String apiKey = 'YOUR_GEMINI_API_KEY';
```

### 6. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
  core/
    config/         # Supabase, Gemini, App configs
    constants/      # Route names, storage keys
    network/        # Connectivity service
    utils/          # Logger, validators, helpers
  models/           # Data models
  providers/        # State management (Provider)
  routes/           # Navigation routes
  screens/          # UI screens
    ai/             # AI chat screen
    auth/           # Login, register, forgot password
    chat/           # Chat list, room, new chat
    dashboard/      # Dashboard with stats & charts
    forum/          # Forum posts, comments
    home/           # Main navigation container
    profile/        # Profile management
    settings/       # App settings
    splash/         # Animated splash screen
    static/         # About, privacy, terms, support
  services/         # Business logic & API calls
  theme/            # Colors & theme configuration
  widgets/          # Reusable UI components
    cards/          # Stat cards, user cards
    charts/         # Bar, line, pie charts
    common/         # Buttons, text fields, dialogs
  main.dart         # App entry point
```

## Customization Tips

### Change App Name
1. Update `pubspec.yaml`: `name: your_app_name`
2. Update app title in `lib/main.dart`
3. Update `android/app/src/main/AndroidManifest.xml`
4. Update `ios/Runner/Info.plist`

### Change Theme Colors
Edit `lib/theme/app_colors.dart`:

```dart
static const Color primary = Color(0xFFYOUR_COLOR);
static const Color secondary = Color(0xFFYOUR_COLOR);
```

### Add New Features
1. Create model in `lib/models/`
2. Create service in `lib/services/`
3. Create provider in `lib/providers/`
4. Create screen in `lib/screens/`
5. Add route in `lib/routes/app_routes.dart`

## License

MIT License - Feel free to use this template for your hackathon projects!

## Support

For issues and questions, please open an issue on GitHub.

---

Built with Flutter & Supabase for hackathons
