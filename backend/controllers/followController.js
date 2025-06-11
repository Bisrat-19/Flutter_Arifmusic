const Follow = require("../models/Follow");
const User = require("../models/User");
const mongoose = require("mongoose"); // Add mongoose import

class FollowController {
    static async checkFollowStatus(req, res) {
        try {
            const { artistId } = req.params;
            const userId = req.user.id;

            // Validate artistId
            if (!mongoose.Types.ObjectId.isValid(artistId)) {
                return res.status(400).json({ message: "Invalid artist ID" });
            }

            const follow = await Follow.findOne({ follower: userId, following: artistId });
            res.status(200).json({ isFollowing: !!follow });
        } catch (error) {
            console.error('Error checking follow status:', error.message);
            res.status(500).json({ message: "Error checking follow status", error: error.message });
        }
    }

    static async toggleFollow(req, res) {
        try {
            const { artistId } = req.body;
            const userId = req.user.id;

            // Validate artistId
            if (!mongoose.Types.ObjectId.isValid(artistId)) {
                return res.status(400).json({ message: "Invalid artist ID" });
            }

            if (userId === artistId) {
                return res.status(400).json({ message: "Users cannot follow themselves" });
            }

            const existingFollow = await Follow.findOne({ follower: userId, following: artistId });
            if (existingFollow) {
                await Follow.deleteOne({ _id: existingFollow._id });
                await User.findByIdAndUpdate(artistId, { $inc: { followersCount: -1 } }, { new: true, runValidators: true });
                await User.findByIdAndUpdate(userId, { $inc: { followingCount: -1 } }, { new: true, runValidators: true });
                return res.status(200).json({ message: "Unfollowed", isFollowing: false });
            } else {
                const follow = new Follow({ follower: userId, following: artistId });
                await follow.save();
                await User.findByIdAndUpdate(artistId, { $inc: { followersCount: 1 } }, { new: true, runValidators: true });
                await User.findByIdAndUpdate(userId, { $inc: { followingCount: 1 } }, { new: true, runValidators: true });
                return res.status(200).json({ message: "Followed", isFollowing: true });
            }
        } catch (error) {
            console.error('Error toggling follow:', error.message);
            res.status(500).json({ message: "Error toggling follow", error: error.message });
        }
    }

    static async getFollowersCount(req, res) {
        try {
            const { artistId } = req.params;

            // Validate artistId
            if (!mongoose.Types.ObjectId.isValid(artistId)) {
                return res.status(400).json({ message: "Invalid artist ID" });
            }

            const user = await User.findById(artistId).select('followersCount');
            if (!user) {
                return res.status(404).json({ message: "Artist not found", count: 0 });
            }
            res.status(200).json({ count: user.followersCount || 0 });
        } catch (error) {
            console.error('Error fetching followers count:', error.message);
            res.status(500).json({ message: "Error fetching followers count", error: error.message });
        }
    }
}

module.exports = FollowController;