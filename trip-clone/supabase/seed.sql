-- Insert Facilities
INSERT INTO facilities (name, icon) VALUES
('Free WiFi', 'wifi'),
('Swimming Pool', 'pool'),
('Fitness Center', 'dumbbell'),
('Spa', 'spa'),
('Kitchen', 'kitchen'),
('Parking', 'parking'),
('Private Beach', 'umbrella'),
('Bar', 'wine-glass');

-- Insert Hotels and capture IDs (using DO block for variable handling in Postgres)
DO $$
DECLARE
  h1_id UUID;
  h2_id UUID;
  h3_id UUID;
  f_wifi UUID;
  f_pool UUID;
  f_gym UUID;
  f_spa UUID;
  f_kitchen UUID;
  f_parking UUID;
  f_beach UUID;
  f_bar UUID;
BEGIN
  -- Get Facility IDs
  SELECT id INTO f_wifi FROM facilities WHERE icon = 'wifi';
  SELECT id INTO f_pool FROM facilities WHERE icon = 'pool';
  SELECT id INTO f_gym FROM facilities WHERE icon = 'dumbbell';
  SELECT id INTO f_spa FROM facilities WHERE icon = 'spa';
  SELECT id INTO f_kitchen FROM facilities WHERE icon = 'kitchen';
  SELECT id INTO f_parking FROM facilities WHERE icon = 'parking';
  SELECT id INTO f_beach FROM facilities WHERE icon = 'umbrella';
  SELECT id INTO f_bar FROM facilities WHERE icon = 'wine-glass';

  -- Hotel 1: Grand Hotel
  INSERT INTO hotels (name, description, rating, image_url)
  VALUES ('Grand Hotel', 'Experience luxury in the heart of the city.', 4.5, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')
  RETURNING id INTO h1_id;

  INSERT INTO addresses (hotel_id, street, city, country, zip_code)
  VALUES (h1_id, '123 Main St', 'City Center', 'USA', '10001');

  INSERT INTO hotel_facilities (hotel_id, facility_id) VALUES
  (h1_id, f_wifi), (h1_id, f_pool), (h1_id, f_gym), (h1_id, f_spa);

  INSERT INTO rooms (hotel_id, name, description, max_guests, base_price, available_count) VALUES
  (h1_id, 'Deluxe King Room', 'Spacious room with a king-size bed.', 2, 120.00, 5),
  (h1_id, 'Executive Suite', 'Luxury suite with separate living area.', 3, 250.00, 2);

  INSERT INTO policies (hotel_id, cancellation_name, cancellation_description, refund_percent, hours_deadline)
  VALUES (h1_id, 'Free Cancellation', 'Cancel up to 24 hours before check-in.', 100, 24);


  -- Hotel 2: Cozy Apartment
  INSERT INTO hotels (name, description, rating, image_url)
  VALUES ('Cozy Apartment', 'A charming apartment in a quiet suburban neighborhood.', 4.2, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')
  RETURNING id INTO h2_id;

  INSERT INTO addresses (hotel_id, street, city, country, zip_code)
  VALUES (h2_id, '456 Oak Ln', 'Suburbs', 'USA', '10002');

  INSERT INTO hotel_facilities (hotel_id, facility_id) VALUES
  (h2_id, f_wifi), (h2_id, f_kitchen), (h2_id, f_parking);

  INSERT INTO rooms (hotel_id, name, description, max_guests, base_price, available_count) VALUES
  (h2_id, 'Entire Apartment', '2 bedrooms, 1 bath, full kitchen.', 4, 80.00, 1);

  INSERT INTO policies (hotel_id, cancellation_name, cancellation_description, refund_percent, hours_deadline)
  VALUES (h2_id, 'Moderate', 'Cancel up to 5 days before check-in.', 100, 120);


  -- Hotel 3: Luxury Resort
  INSERT INTO hotels (name, description, rating, image_url)
  VALUES ('Luxury Resort', 'Escape to paradise at our beachfront resort.', 4.9, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')
  RETURNING id INTO h3_id;

  INSERT INTO addresses (hotel_id, street, city, country, zip_code)
  VALUES (h3_id, '789 Beach Blvd', 'Beachfront', 'USA', '10003');

  INSERT INTO hotel_facilities (hotel_id, facility_id) VALUES
  (h3_id, f_wifi), (h3_id, f_pool), (h3_id, f_spa), (h3_id, f_beach), (h3_id, f_bar);

  INSERT INTO rooms (hotel_id, name, description, max_guests, base_price, available_count) VALUES
  (h3_id, 'Ocean View Villa', 'Private villa with direct beach access.', 2, 350.00, 3),
  (h3_id, 'Garden Suite', 'Peaceful suite surrounded by tropical gardens.', 2, 280.00, 4);

  INSERT INTO policies (hotel_id, cancellation_name, cancellation_description, refund_percent, hours_deadline)
  VALUES (h3_id, 'Non-Refundable', 'No refund upon cancellation.', 0, 0);

END $$;
