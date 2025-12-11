-- Enable RLS on all tables (just to be consistent)
ALTER TABLE hotels ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotel_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE policies ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any to avoid conflicts
DROP POLICY IF EXISTS "Public Access Hotels" ON hotels;
DROP POLICY IF EXISTS "Public Access Addresses" ON addresses;
DROP POLICY IF EXISTS "Public Access Hotel Facilities" ON hotel_facilities;
DROP POLICY IF EXISTS "Public Access Facilities" ON facilities;
DROP POLICY IF EXISTS "Public Access Rooms" ON rooms;
DROP POLICY IF EXISTS "Public Access Policies" ON policies;

-- Create permissive policies for development (Allow ALL operations for everyone)
CREATE POLICY "Public Access Hotels" ON hotels FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public Access Addresses" ON addresses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public Access Hotel Facilities" ON hotel_facilities FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public Access Facilities" ON facilities FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public Access Rooms" ON rooms FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public Access Policies" ON policies FOR ALL USING (true) WITH CHECK (true);
