create database spotify

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE songs (
    song_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist VARCHAR(255) NOT NULL,
    genre VARCHAR(255),
    release_date DATE
);
CREATE TABLE playlists (
    playlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    playlist_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE playlist_songs (
    playlist_id INT,
    song_id INT,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    PRIMARY KEY (playlist_id, song_id)
);
CREATE TABLE user_listening_history (
    user_id INT,
    song_id INT,
    listen_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, song_id, listen_time)
);
INSERT INTO users (username,email)
VALUES 
('A', 'A@example.com'),
('B', 'B@example.com'),
('C', 'C@example.com');
INSERT INTO songs (title, artist, genre, release_date)
VALUES 
('Song A', 'Artist 1', 'Rock', '2020-01-01'),
('Song B', 'Artist 2', 'Pop', '2020-02-01'),
('Song C', 'Artist 3', 'Jazz', '2020-03-01'),
('Song D', 'Artist 1', 'Rock', '2020-04-01'),
('Song E', 'Artist 2', 'Pop', '2020-05-01');
INSERT INTO playlists (user_id, playlist_name)
VALUES 
(1, 'A\'s Rock Playlist'),
(1, 'A\'s Pop Playlist'),
(2, 'B\'s Jazz Playlist'),
(3, 'C\'s Mixed Playlist');
INSERT INTO playlist_songs (playlist_id, song_id)
VALUES 
(1, 1),
(1, 4),
(2, 2),
(2, 5),
(3, 3),
(4, 1),
(4, 2),
(4, 3);
INSERT INTO user_listening_history (user_id, song_id, listen_time)
VALUES 
(1, 1, '2020-06-01 10:00:00'),
(1, 4, '2020-06-01 10:30:00'),
(1, 2, '2020-06-02 11:00:00'),
(1, 5, '2020-06-02 11:30:00'),
(2, 3, '2020-06-03 12:00:00'),
(3, 1, '2020-06-04 13:00:00'),
(3, 2, '2020-06-04 13:30:00'),
(3, 3, '2020-06-04 14:00:00');


-- Retrieve a user's playlists and the number of songs in each playlist

SELECT u.username, p.playlist_name, COUNT(ps.song_id) AS song_count
FROM users u
JOIN playlists p ON u.user_id = p.user_id
LEFT JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id
GROUP BY u.username, p.playlist_name;

-- b. Most Listened Songs:

-- Find the most listened songs and their play count
SELECT s.title, s.artist, COUNT(uh.song_id) AS play_count
FROM songs s
JOIN user_listening_history uh ON s.song_id = uh.song_id
GROUP BY s.title, s.artist
ORDER BY play_count DESC
LIMIT 10;

-- Identify a user's top genres based on listening history
SELECT u.username, s.genre, COUNT(uh.song_id) AS song_count
FROM users u
JOIN user_listening_history uh ON u.user_id = uh.user_id
JOIN songs s ON uh.song_id = s.song_id
GROUP BY u.username, s.genre
ORDER BY song_count DESC;


-- Identify popular genres across all playlists
SELECT s.genre, COUNT(ps.song_id) AS song_count
FROM playlist_songs ps
JOIN songs s ON ps.song_id = s.song_id
GROUP BY s.genre
ORDER BY song_count DESC;

----by keerthi akshita