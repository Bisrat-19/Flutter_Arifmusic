const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const path = require('path');

dotenv.config();
connectDB();

const app = express();

const corsOptions = {
    origin: '*', // Allow all for testing; restrict in production
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
};
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/songs', require('./routes/songRoutes'));
app.use('/api/admin', require('./routes/adminRoutes'));
app.use('/api/artists', require('./routes/artistRoutes'));
app.use('/api/playlists', require('./routes/playlistRoutes'));
app.use('/api/watchlist', require('./routes/watchlistRoutes'));
app.use('/api/follow', require('./routes/followRoutes'));
app.get('/', (req, res) => {
    res.send('API is running...');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`✅ Server running at http://0.0.0.0:${PORT}`);
});