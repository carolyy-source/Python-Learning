-- Create tables
CREATE TABLE IF NOT EXISTS hotels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  rating NUMERIC(3, 1),
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
  street TEXT,
  city TEXT,
  country TEXT,
  zip_code TEXT
);

CREATE TABLE IF NOT EXISTS facilities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  icon TEXT
);

CREATE TABLE IF NOT EXISTS hotel_facilities (
  hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
  facility_id UUID REFERENCES facilities(id) ON DELETE CASCADE,
  PRIMARY KEY (hotel_id, facility_id)
);

CREATE TABLE IF NOT EXISTS rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  max_guests INTEGER,
  base_price NUMERIC(10, 2),
  available_count INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS policies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
  cancellation_name TEXT,
  cancellation_description TEXT,
  refund_percent INTEGER,
  hours_deadline INTEGER
);

-- Enable Row Level Security (RLS)
ALTER TABLE hotels ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotel_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE policies ENABLE ROW LEVEL SECURITY;

-- Create policies to allow public read access
CREATE POLICY "Public hotels are viewable by everyone" ON hotels FOR SELECT USING (true);
CREATE POLICY "Public addresses are viewable by everyone" ON addresses FOR SELECT USING (true);
CREATE POLICY "Public facilities are viewable by everyone" ON facilities FOR SELECT USING (true);
CREATE POLICY "Public hotel_facilities are viewable by everyone" ON hotel_facilities FOR SELECT USING (true);
CREATE POLICY "Public rooms are viewable by everyone" ON rooms FOR SELECT USING (true);
CREATE POLICY "Public policies are viewable by everyone" ON policies FOR SELECT USING (true);
