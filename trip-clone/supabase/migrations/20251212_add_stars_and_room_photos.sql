-- Add star_rating to hotels table
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS star_rating TEXT;

-- Add image_url to rooms table
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS image_url TEXT;
