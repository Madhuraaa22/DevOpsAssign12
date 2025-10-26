-- Initialize the database
-- Create the login table
CREATE TABLE IF NOT EXISTS login (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL
);

-- Insert some sample data (optional)
-- INSERT INTO login (username, password) VALUES ('ITA773', '2022PE0000');
