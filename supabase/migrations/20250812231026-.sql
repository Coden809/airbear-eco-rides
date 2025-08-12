BEGIN;

-- Remove public access to driver profiles
DROP POLICY IF EXISTS "Public can read basic driver info" ON public.profiles;

-- Ensure RLS is enabled (should already be enabled)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Allow authenticated riders to read profiles of drivers assigned to their active rides
CREATE POLICY "Riders can read assigned driver profiles"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public.rides
    WHERE rides.user_id = auth.uid()
      AND rides.driver_id = profiles.id
      AND rides.status = ANY (ARRAY['assigned'::ride_status, 'in_progress'::ride_status])
  )
);

COMMIT;