const Song = require('../models/Song');

exports.uploadSong = async(req, res) => {
    try {
        console.log('Received upload request:', req.body);
        console.log('Files:', req.files);

        const { title, genre, description, artistId } = req.body;
        const audioFile = req.files['audio'] ? req.files['audio'][0] : null;
        const coverImage = req.files['coverImage'] ? req.files['coverImage'][0] : null;

        // Validate required fields
        if (!title || !genre || !artistId || !audioFile) {
            return res.status(400).json({ message: 'Title, genre, artistId, and audio file are required' });
        }

        // Create new song document with URL paths
        const song = new Song({
            title,
            genre,
            description: description || '',
            artistId,
            audioPath: `/uploads/songs/${audioFile.filename}`, // Use URL-friendly path
            coverImagePath: coverImage ? `/uploads/covers/${coverImage.filename}` : null,
        });

        await song.save();

        res.status(201).json({
            message: 'Track uploaded successfully',
            song: {
                id: song._id,
                title: song.title,
                genre: song.genre,
                description: song.description,
                audioPath: song.audioPath,
                coverImagePath: song.coverImagePath,
                artistId: song.artistId,
            },
        });
    } catch (error) {
        console.error('Upload song error:', error);
        res.status(500).json({ message: 'Error uploading track', error: error.message });
    }
    router.put('/:songId/increment-play-count', auth, async(req, res) => {
        try {
            const song = await Song.findById(req.params.songId);
            if (!song) {
                return res.status(404).json({ message: 'Song not found' });
            }
            song.playCount += 1;
            await song.save();
            res.status(200).json({ success: true, playCount: song.playCount });
        } catch (error) {
            res.status(500).json({ message: 'Error incrementing play count', error: error.message });
        }
    });
    router.get('/my-songs', auth, async(req, res) => {
        try {
            const songs = await Song.find({ artistId: req.user.id }).select('title genre description artistId audioPath coverImagePath duration playCount');
            res.status(200).json(songs);
        } catch (error) {
            res.status(500).json({ message: 'Error fetching songs', error: error.message });
        }
    });
};