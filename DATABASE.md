# 🛠️ Zad App Backend Infrastructure (Supabase)

This document outlines the database schema and integration plan for the Zad application.

## 📊 Database Schema (SQL)

Run the following SQL in your Supabase SQL Editor to initialize the backend:

```sql
-- 1. Profiles (User Identity)
create table profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  personality_score int default 50,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Transactions (Say Coach Data)
create table transactions (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  amount decimal not null,
  category text not null,
  description text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Split Groups (Say Split Data)
create table split_groups (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  created_by uuid references auth.users not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Financial Goals (Say Goals Data)
create table goals (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  title text not null,
  target_amount decimal not null,
  current_amount decimal default 0,
  deadline timestamp with time zone,
  icon_emoji text
);

-- RLS Policies
alter table profiles enable row level security;
create policy "Users can view their own profile" on profiles for select using (auth.uid() = id);

alter table transactions enable row level security;
create policy "Users can manage their own transactions" on transactions for all using (auth.uid() = user_id);
```

## 🔗 Frontend Linking Strategy

The application uses the **Repository Pattern** to decouple the UI from the data source:

1.  **AIService:** Directly links to **Gemini 1.5 Flash** for real-time behavioral analysis.
2.  **SupabaseService:** A dedicated service layer using `supabase_flutter` to handle CRUD operations.
3.  **Riverpod Providers:** Reactive state management that listens to Supabase streams for real-time UI updates.

## 🚀 Next Step: Environment Variables
Inject your Supabase keys into `.env`:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
