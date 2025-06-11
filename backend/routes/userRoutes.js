const express = require('express');
const router = express.Router();
const protect = require('../middleware/authMiddleware');
const multer = require('multer');
const path = require('path');
const User = require('../models/user'); // Assuming User model represents artists

// Configure Multer for image uploads to the 'profile' subdirectory
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadPath = path.join(__dirname, '../uploads/profile');
        if (!require('fs').existsSync(uploadPath)) {
            require('fs').mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    },
});
const upload = multer({ storage });

// Get user profile
router.get('/me', protect, async(req, res) => {
    try {
        const user = await User.findById(req.user.id).select('fullName email role profileImagePath');
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json({
            _id: user._id,
            fullName: user.fullName,
            email: user.email,
            role: user.role,
            profileImage: user.profileImagePath ? `${req.protocol}://${req.get('host')}${user.profileImagePath}` : null,
        });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching user', error: error.message });
    }
});

// Update user profile image
router.put('/:id/profile-image', protect, upload.single('profileImage'), async(req, res) => {
    try {
        const userId = req.params.id;
        const profileImagePath = req.file ? `/uploads/profile/${req.file.filename}` : null;

        if (!profileImagePath) {
            return res.status(400).json({ message: 'No image uploaded' });
        }

        if (userId !== req.user.id.toString()) {
            return res.status(403).json({ message: 'Unauthorized to update this profile' });
        }

        const updatedUser = await User.findByIdAndUpdate(
            userId, { profileImagePath }, { new: true, select: 'fullName role profileImagePath' }
        );
        if (!updatedUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.status(200).json({
            _id: updatedUser._id,
            fullName: updatedUser.fullName,
            role: updatedUser.role,
            profileImage: updatedUser.profileImagePath ? `${req.protocol}://${req.get('host')}${updatedUser.profileImagePath}` : null,
        });
    } catch (error) {
        res.status(500).json({ message: 'Error updating profile image', error: error.message });
    }
});

module.exports = router;