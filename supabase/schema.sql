
-- =========================================
-- READIFY DATABASE
-- Main Table: reading_items
-- =========================================

-- 1. Create reading_items table
CREATE TABLE IF NOT EXISTS public.reading_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    open_library_key TEXT NOT NULL,
    title TEXT NOT NULL,
    author TEXT,
    cover_url TEXT,
    publish_year INTEGER,

    status TEXT NOT NULL DEFAULT 'want_to_read'
        CHECK (
            status IN (
                'want_to_read',
                'reading',
                'finished'
            )
        ),

    rating NUMERIC(2,1)
        CHECK (
            rating IS NULL OR
            (rating >= 0 AND rating <= 5)
        ),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT unique_user_book
        UNIQUE (user_id, open_library_key)
);


-- 2. Create indexes
CREATE INDEX IF NOT EXISTS idx_reading_items_user_id
ON public.reading_items(user_id);

CREATE INDEX IF NOT EXISTS idx_reading_items_status
ON public.reading_items(user_id, status);


-- 3. Create updated_at function
CREATE OR REPLACE FUNCTION public.set_reading_items_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


-- 4. Create update trigger
DROP TRIGGER IF EXISTS reading_items_updated_at
ON public.reading_items;

CREATE TRIGGER reading_items_updated_at
BEFORE UPDATE ON public.reading_items
FOR EACH ROW
EXECUTE FUNCTION public.set_reading_items_updated_at();


-- 5. Enable Row Level Security
ALTER TABLE public.reading_items
ENABLE ROW LEVEL SECURITY;


-- 6. Set table permissions
REVOKE ALL ON TABLE public.reading_items
FROM anon, authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE public.reading_items
TO authenticated;


-- 7. Remove old policies if present
DROP POLICY IF EXISTS "Users can view their own books"
ON public.reading_items;

DROP POLICY IF EXISTS "Users can insert their own books"
ON public.reading_items;

DROP POLICY IF EXISTS "Users can update their own books"
ON public.reading_items;

DROP POLICY IF EXISTS "Users can delete their own books"
ON public.reading_items;


-- 8. SELECT policy
CREATE POLICY "Users can view their own books"
ON public.reading_items
FOR SELECT
TO authenticated
USING (
    (SELECT auth.uid()) = user_id
);


-- 9. INSERT policy
CREATE POLICY "Users can insert their own books"
ON public.reading_items
FOR INSERT
TO authenticated
WITH CHECK (
    (SELECT auth.uid()) = user_id
);


-- 10. UPDATE policy
CREATE POLICY "Users can update their own books"
ON public.reading_items
FOR UPDATE
TO authenticated
USING (
    (SELECT auth.uid()) = user_id
)
WITH CHECK (
    (SELECT auth.uid()) = user_id
);


-- 11. DELETE policy
CREATE POLICY "Users can delete their own books"
ON public.reading_items
FOR DELETE
TO authenticated
USING (
    (SELECT auth.uid()) = user_id
);
