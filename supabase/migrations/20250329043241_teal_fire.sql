/*
  # Create Storage Bucket for Post Images

  1. New Storage Bucket
    - Create 'post-images' bucket for storing user post images
    - Enable public access for image viewing
    - Set up security policies for authenticated users

  2. Security
    - Enable RLS
    - Add policies for authenticated users to upload/delete their own images
*/

-- Enable storage by inserting into storage.buckets
INSERT INTO storage.buckets (id, name, public)
VALUES ('post-images', 'post-images', true)
ON CONFLICT (id) DO NOTHING;

-- Set up security policies
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'post-images');

CREATE POLICY "Authenticated users can update own images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'post-images' AND owner = auth.uid());

CREATE POLICY "Authenticated users can delete own images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'post-images' AND owner = auth.uid());

CREATE POLICY "Anyone can view images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'post-images');