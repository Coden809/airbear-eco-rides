-- Create user profiles table (Supabase auth handles the actual authentication)
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  date_of_birth DATE,
  phone TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on user_profiles
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Create policies for user_profiles
CREATE POLICY "Users can view own profile" ON public.user_profiles
  FOR SELECT USING (auth.uid() = id);
  
CREATE POLICY "Users can update own profile" ON public.user_profiles
  FOR UPDATE USING (auth.uid() = id);
  
CREATE POLICY "Users can insert own profile" ON public.user_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create GPS spots table for ride locations
CREATE TABLE IF NOT EXISTS public.gps_spots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  spot_type TEXT DEFAULT 'pickup',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on gps_spots
ALTER TABLE public.gps_spots ENABLE ROW LEVEL SECURITY;

-- Create policy for gps_spots (public read access)
CREATE POLICY "Anyone can read active GPS spots" ON public.gps_spots
  FOR SELECT USING (is_active = true);

-- Create rides table
CREATE TABLE IF NOT EXISTS public.rides (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  driver_id UUID REFERENCES auth.users(id),
  start_location_id UUID REFERENCES public.gps_spots(id),
  end_location_id UUID REFERENCES public.gps_spots(id),
  start_location TEXT NOT NULL,
  end_location TEXT NOT NULL,
  status TEXT DEFAULT 'requested' CHECK (status IN ('requested', 'assigned', 'in_progress', 'completed', 'cancelled')),
  fare_amount DECIMAL(10, 2),
  estimated_duration INTEGER,
  scheduled_time TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on rides
ALTER TABLE public.rides ENABLE ROW LEVEL SECURITY;

-- Create policies for rides
CREATE POLICY "Users can view own rides" ON public.rides
  FOR SELECT USING (auth.uid() = user_id OR auth.uid() = driver_id);
  
CREATE POLICY "Users can create rides" ON public.rides
  FOR INSERT WITH CHECK (auth.uid() = user_id);
  
CREATE POLICY "Users can update own rides" ON public.rides
  FOR UPDATE USING (auth.uid() = user_id OR auth.uid() = driver_id);

-- Create inventory table for bodega items
CREATE TABLE IF NOT EXISTS public.inventory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'snacks' CHECK (category IN ('snacks', 'drinks', 'misc')),
  price DECIMAL(10, 2) NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  description TEXT,
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on inventory
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;

-- Create policy for inventory (public read access)
CREATE POLICY "Anyone can read available inventory" ON public.inventory
  FOR SELECT USING (is_available = true);

-- Create tshirt_purchases table for Stripe purchases
CREATE TABLE IF NOT EXISTS public.tshirt_purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  stripe_payment_intent_id TEXT,
  amount DECIMAL(10, 2) NOT NULL DEFAULT 100.00,
  purchase_date TIMESTAMPTZ DEFAULT NOW(),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on tshirt_purchases
ALTER TABLE public.tshirt_purchases ENABLE ROW LEVEL SECURITY;

-- Create policies for tshirt_purchases
CREATE POLICY "Users can view own purchases" ON public.tshirt_purchases
  FOR SELECT USING (auth.uid() = user_id);
  
CREATE POLICY "Users can create purchases" ON public.tshirt_purchases
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Create cart table for bodega shopping
CREATE TABLE IF NOT EXISTS public.cart_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  inventory_id UUID NOT NULL REFERENCES public.inventory(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, inventory_id)
);

-- Enable RLS on cart_items
ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;

-- Create policies for cart_items
CREATE POLICY "Users can manage own cart" ON public.cart_items
  FOR ALL USING (auth.uid() = user_id);

-- Insert sample GPS spots (16 locations)
INSERT INTO public.gps_spots (name, address, latitude, longitude, spot_type) VALUES
('Downtown Plaza', '123 Main St, Downtown', 40.7128, -74.0060, 'pickup'),
('University Campus', '456 College Ave, University District', 40.7589, -73.9851, 'pickup'),
('Shopping District', '789 Commerce Blvd, Shopping Center', 40.7505, -73.9934, 'pickup'),
('Riverside Park', '321 River Rd, Riverside', 40.7829, -73.9654, 'pickup'),
('Business Center', '654 Corporate Dr, Business District', 40.7614, -73.9776, 'pickup'),
('Airport Terminal', '987 Airport Way, Terminal Area', 40.6413, -73.7781, 'pickup'),
('Train Station', '147 Station Plaza, Transit Hub', 40.7527, -73.9772, 'pickup'),
('Beach Boardwalk', '258 Ocean Ave, Beachfront', 40.5795, -73.9707, 'pickup'),
('Medical Center', '369 Health St, Medical District', 40.7831, -73.9712, 'pickup'),
('Arts District', '741 Gallery Row, Cultural Quarter', 40.7282, -74.0776, 'pickup'),
('Sports Complex', '852 Athletic Blvd, Recreation Area', 40.8176, -73.9442, 'pickup'),
('Tech Hub', '963 Innovation Dr, Tech Corridor', 40.7443, -74.0038, 'pickup'),
('Historic Quarter', '159 Heritage St, Old Town', 40.7074, -74.0113, 'pickup'),
('Marina District', '357 Harbor View, Waterfront', 40.7410, -74.0123, 'pickup'),
('Residential West', '468 Sunset Blvd, West Side', 40.7690, -73.9840, 'pickup'),
('Residential East', '579 Sunrise Ave, East Side', 40.7504, -73.9688, 'pickup');

-- Insert sample inventory items
INSERT INTO public.inventory (item_name, category, price, stock, description) VALUES
('Oreos Original', 'snacks', 1.50, 50, 'Classic chocolate sandwich cookies'),
('Lay''s Classic Chips', 'snacks', 1.25, 40, 'Original potato chips'),
('Snickers Bar', 'snacks', 1.75, 30, 'Chocolate bar with peanuts and caramel'),
('Granola Bar', 'snacks', 2.00, 25, 'Healthy oats and honey bar'),
('Trail Mix', 'snacks', 2.50, 20, 'Mixed nuts and dried fruits'),
('Coca Cola', 'drinks', 1.50, 60, 'Classic cola soft drink'),
('Water Bottle', 'drinks', 1.00, 80, 'Pure spring water 16.9oz'),
('Orange Juice', 'drinks', 2.25, 30, 'Fresh squeezed orange juice'),
('Energy Drink', 'drinks', 2.75, 25, 'Caffeine boost energy drink'),
('Iced Tea', 'drinks', 1.75, 35, 'Refreshing iced tea'),
('Phone Charger', 'misc', 15.00, 10, 'Universal USB phone charger'),
('Tissues', 'misc', 1.50, 20, 'Soft facial tissues'),
('Hand Sanitizer', 'misc', 2.00, 25, 'Antibacterial hand gel'),
('Gum Pack', 'misc', 1.25, 30, 'Mint flavored chewing gum'),
('Earbuds', 'misc', 8.00, 15, 'Basic wired earbuds');

-- Enable realtime for tables
ALTER TABLE public.rides REPLICA IDENTITY FULL;
ALTER TABLE public.inventory REPLICA IDENTITY FULL;
ALTER TABLE public.cart_items REPLICA IDENTITY FULL;
ALTER TABLE public.tshirt_purchases REPLICA IDENTITY FULL;

-- Add tables to realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.rides;
ALTER PUBLICATION supabase_realtime ADD TABLE public.inventory;
ALTER PUBLICATION supabase_realtime ADD TABLE public.cart_items;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tshirt_purchases;

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, full_name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    NEW.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create user profile
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();