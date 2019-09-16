-- INDEXES FOR links TABLE
CREATE UNIQUE INDEX idx_shortcode ON links (shortcode);
CREATE INDEX idx_links_url ON links (url);
CREATE INDEX idx_links_deleted_at ON links (deleted_at);
