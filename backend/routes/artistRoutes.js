const express = require('express');
const router = express.Router();
const User = require('../models/User');

// GET /api/artists?query=searchText → Search or list all artists
router.get('/', async(req, res) => {
    try {
        const query = req.query.query || '';
        const artists = await User.find(
            query ? { role: 'artist', fullName: { $regex: query, $options: 'i' } } : { role: 'artist' }
        ).select('fullName profileImagePath');

        const artistsWithDetails = artists.map(artist => ({
            _id: artist._id,
            fullName: artist.fullName,
            avatarPath: artist.profileImagePath ?
                `${req.protocol}://${req.get('host')}${artist.profileImagePath}` : null,
        }));

        res.status(200).json(artistsWithDetails);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching artists', error: error.message });
    }
});


router.get('/:id', async(req, res) => {
    try {
        const { id } = req.params;
        const artist = await User.findById(id).select('fullName profileImagePath followersCount role');

        if (!artist || artist.role !== 'artist') {
            return res.status(404).json({
                message: 'Artist not found',
                data: { _id: id, fullName: 'Unknown Artist', avatarPath: null, followerCount: 0 },
            });
        }

        res.status(200).json({
            _id: artist._id,
            fullName: artist.fullName,
            avatarPath: artist.profileImagePath ?
                `${req.protocol}://${req.get('host')}${artist.profileImagePath}` : null,
            followerCount: artist.followersCount || 0,
        });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching artist', error: error.message });
    }
});
module.exports = router;