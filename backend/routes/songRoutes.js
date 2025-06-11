const express = require('express');
const router = express.Router();
const songController = require('../controllers/songController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const Song = require('../models/Song');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const mongoose = require('mongoose'); // Added for ObjectId validation

// Ensure upload directories exist
const uploadBasePath = path.join(__dirname, '..', 'uploads');
const songsPath = path.join(uploadBasePath, 'songs');
const coversPath = path.join(uploadBasePath, 'covers');

const ensureDirectories = () => {
    if (!fs.existsSync(uploadBasePath)) {
        fs.mkdirSync(uploadBasePath, { recursive: true });
        console.log(`Created directory: ${uploadBasePath}`);
    }
    if (!fs.existsSync(songsPath)) {
        fs.mkdirSync(songsPath, { recursive: true });
        console.log(`Created directory: ${songsPath}`);
    }
    if (!fs.existsSync(coversPath)) {
        fs.mkdirSync(coversPath, { recursive: true });
        console.log(`Created directory: ${coversPath}`);
    }
};

ensureDirectories();

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        if (file.fieldname === 'audio') {
            cb(null, songsPath);
        } else if (file.fieldname === 'coverImage') {
            cb(null, coversPath);
        } else {
            cb(new Error('Invalid file field name'), null);
        }
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    },
});

const upload = multer({
    storage,
    limits: { fileSize: 50 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        const audioTypes = ['audio/mpeg', 'audio/wav', 'audio/flac', 'audio/mp4', 'application/octet-stream'];
        const imageTypes = ['image/jpeg', 'image/png', 'image/webp', 'application/octet-stream'];
        if (file.fieldname === 'audio' && !audioTypes.includes(file.mimetype)) {
            return cb(new Error('Invalid audio file type. Only MP3, WAV, FLAC, MP4 are allowed.'));
        }
        if (file.fieldname === 'coverImage' && !imageTypes.includes(file.mimetype)) {
            return cb(new Error('Invalid image file type. Only JPG, PNG, WEBP are allowed.'));
        }
        cb(null, true);
    },
}).fields([{ name: 'audio', maxCount: 1 }, { name: 'coverImage', maxCount: 1 }]);

const uploadErrorHandler = (req, res, next) => {
    upload(req, res, (err) => {
        if (err instanceof multer.MulterError) {
            return res.status(400).json({ message: `Upload error: ${err.message}` });
        } else if (err) {
            return res.status(500).json({ message: `Server error: ${err.message}` });
        }
        next();
    });
};

// Fetch all songs for admin (admin-only endpoint)
router.get('/admin/songs', authMiddleware, roleMiddleware('admin'), async(req, res) => {
    try {
        const songs = await Song.find().populate('artistId', 'fullName');
        const songsWithDetails = songs.map(song => ({
            _id: song._id,
            title: song.title,
            artistName: song.artistId ? song.artistId.fullName : 'Unknown Artist',
            coverImagePath: song.coverImagePath ? `${req.protocol}://${req.get('host')}${song.coverImagePath}` : null,
            audioPath: song.audioPath ? `${req.protocol}://${req.get('host')}${song.audioPath}` : null,
            genre: song.genre,
            description: song.description,
            duration: song.duration || 'N/A',
            isFeatured: song.isFeatured,
            featuredOrder: song.featuredOrder,
        }));
        res.status(200).json(songsWithDetails);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching songs', error: error.message });
    }
});

// Fetch all released songs or search by query (public endpoint for Home/Search Screen)
router.get('/', async(req, res) => {
    try {
        const query = req.query.query || ''; // Default to empty string if no query
        const songs = await Song.find(
            query ? {
                $or: [
                    { title: { $regex: query, $options: 'i' } },
                    { 'artistId.fullName': { $regex: query, $options: 'i' } },
                ],
            } : {}
        ).populate('artistId', 'fullName');
        const songsWithArtistName = songs.map(song => ({
            _id: song._id,
            title: song.title,
            artistName: song.artistId ? song.artistId.fullName : 'Unknown Artist',
            coverImagePath: song.coverImagePath ? `${req.protocol}://${req.get('host')}${song.coverImagePath}` : null,
            audioPath: song.audioPath,
            duration: song.duration || 'N/A', // Add duration if available in your schema
        }));
        res.status(200).json(songsWithArtistName);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching songs', error: error.message });
    }
});

router.get('/featured', async(req, res) => {
    try {
        const songs = await Song.find({ isFeatured: true })
            .sort({ featuredOrder: 1 })
            .populate('artistId', 'fullName');
        const songsWithArtistName = songs.map(song => ({
            _id: song._id,
            title: song.title,
            artistName: song.artistId ? song.artistId.fullName : 'Unknown Artist',
            coverImagePath: song.coverImagePath ? `${req.protocol}://${req.get('host')}${song.coverImagePath}` : null,
            audioPath: song.audioPath ? `${req.protocol}://${req.get('host')}${song.audioPath}` : null,
            duration: song.duration || 'N/A',
            isFeatured: song.isFeatured,
            featuredOrder: song.featuredOrder,
        }));
        res.status(200).json(songsWithArtistName);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching featured songs', error: error.message });
    }
});

// Pin a song as featured (admin only)
router.put('/pin-featured/:id', authMiddleware, roleMiddleware('admin'), async(req, res) => {
    try {
        const { id } = req.params;
        const { featuredOrder } = req.body;

        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ message: 'Invalid song ID' });
        }

        const song = await Song.findById(id);
        if (!song) {
            return res.status(404).json({ message: 'Song not found' });
        }

        if (!song.coverImagePath) {
            return res.status(400).json({ message: 'Song must have a cover image to be featured' });
        }

        song.isFeatured = true;
        song.featuredOrder = parseInt(featuredOrder) || 0;
        await song.save();

        res.status(200).json({ message: 'Song pinned as featured', song });
    } catch (error) {
        res.status(500).json({ message: 'Error pinning song', error: error.message });
    }
});

// Unpin a song from featured (admin only)
router.put('/unpin-featured/:id', authMiddleware, roleMiddleware('admin'), async(req, res) => {
    try {
        const { id } = req.params;

        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ message: 'Invalid song ID' });
        }

        const song = await Song.findById(id);
        if (!song) {
            return res.status(404).json({ message: 'Song not found' });
        }

        song.isFeatured = false;
        song.featuredOrder = 0;
        await song.save();

        res.status(200).json({ message: 'Song unpinned from featured', song });
    } catch (error) {
        res.status(500).json({ message: 'Error unpinning song', error: error.message });
    }
});

// Upload song route
router.post(
    '/upload',
    authMiddleware,
    roleMiddleware('artist'),
    uploadErrorHandler,
    songController.uploadSong
);

// Get songs by artist (public endpoint for when user taps an artist)
router.get('/artist/:artistId', async(req, res) => {
    try {
        const artistId = req.params.artistId;

        // Validate artistId
        if (!mongoose.Types.ObjectId.isValid(artistId)) {
            return res.status(400).json({ message: 'Invalid artist ID' });
        }

        // Fetch songs associated with the artist
        const songs = await Song.find({ artistId }).populate('artistId', 'fullName');
        if (!songs || songs.length === 0) {
            return res.status(404).json({ message: 'No songs found for this artist' });
        }

        // Format the response
        const songsWithArtistName = songs.map(song => ({
            _id: song._id,
            title: song.title,
            artistName: song.artistId ? song.artistId.fullName : 'Unknown Artist',
            coverImagePath: song.coverImagePath ? `${req.protocol}://${req.get('host')}${song.coverImagePath}` : null,
            audioPath: song.audioPath ? `${req.protocol}://${req.get('host')}${song.audioPath}` : null,
            duration: song.duration || 'N/A',
        }));

        res.status(200).json(songsWithArtistName);
    } catch (error) {
        console.error('Error fetching songs by artist:', error.message);
        res.status(500).json({ message: 'Error fetching songs by artist', error: error.message });
    }
});

// Get songs by artist (artist's own songs, authenticated)
router.get('/my-songs', authMiddleware, roleMiddleware('artist'), async(req, res) => {
    try {
        const artistId = req.user.id;
        const songs = await Song.find({ artistId }).select('-__v');
        res.status(200).json(songs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching songs', error: error.message });
    }
});

router.get('/songs/:id', async(req, res) => {
    try {
        const { id } = req.params;

        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ message: 'Invalid song ID' });
        }

        const song = await Song.findById(id).populate('artistId', 'fullName');
        if (!song) {
            return res.status(404).json({ message: 'Song not found' });
        }

        const response = {
            _id: song._id,
            title: song.title,
            artistName: song.artistId ? song.artistId.fullName : 'Unknown Artist',
            coverImagePath: song.coverImagePath ? `${req.protocol}://${req.get('host')}${song.coverImagePath}` : null,
            audioUrl: song.audioPath ? `${req.protocol}://${req.get('host')}${song.audioPath}` : null,
            duration: song.duration || 'N/A',
        };
        res.status(200).json(response);
    } catch (error) {
        console.error('Error fetching song:', error.message);
        res.status(500).json({ message: 'Error fetching song', error: error.message });
    }
});
router.put('/songs/:id', authMiddleware, roleMiddleware('artist'), async(req, res) => {
    try {
        const { id } = req.params;
        const { title } = req.body;

        if (!title) {
            return res.status(400).json({ message: 'Title is required' });
        }

        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ message: 'Invalid song ID' });
        }

        const song = await Song.findOneAndUpdate({ _id: id, artistId: req.user.id }, { title }, { new: true, runValidators: true });

        if (!song) {
            console.log(`PUT /songs/${id} failed: User ID ${req.user.id} does not own song or song not found`);
            return res.status(404).json({
                message: `Song not found or not owned by you. Verify song ID: ${id}`
            });
        }

        res.status(200).json({ message: 'Song title updated successfully', song });
    } catch (error) {
        console.error(`Error updating song ${req.params.id}: ${error.message}`, error.stack);
        res.status(500).json({ message: 'Error updating song', error: error.message });
    }
});

router.delete('/songs/:id', authMiddleware, roleMiddleware('artist'), async(req, res) => {
    try {
        const { id } = req.params;

        if (!mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({ message: 'Invalid song ID' });
        }

        console.log(`Attempting to delete song ${id} by artist ${req.user.id}`);
        const song = await Song.findOne({ _id: id, artistId: req.user.id });
        if (!song) {
            console.log(`DELETE /songs/${id} failed: User ID ${req.user.id} does not own song or song not found`);
            return res.status(404).json({
                message: `Song not found or not owned by you. Verify song ID: ${id}`
            });
        }

        if (song.audioPath) {
            const audioFilePath = path.join(__dirname, '..', song.audioPath.replace('/uploads/', 'uploads/'));
            if (fs.existsSync(audioFilePath)) {
                fs.unlinkSync(audioFilePath);
            }
        }
        if (song.coverImagePath) {
            const coverFilePath = path.join(__dirname, '..', song.coverImagePath.replace('/uploads/', 'uploads/'));
            if (fs.existsSync(coverFilePath)) {
                fs.unlinkSync(coverFilePath);
            }
        }

        await Song.deleteOne({ _id: id });
        res.status(200).json({ message: 'Song deleted successfully' });
    } catch (error) {
        console.error(`Error deleting song ${req.params.id}: ${error.message}`, error.stack);
        res.status(500).json({ message: 'Error deleting song', error: error.message });
    }
});

module.exports = router;