const express = require("express");
const router = express.Router();
const FollowController = require("../controllers/followController");
const protect = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const authorizeRole = roleMiddleware('admin', 'artist', 'listener'); // Allow admins, artists, and listeners

// Check follow status for a specific artist
router.get("/follow/status/:artistId", protect, authorizeRole, FollowController.checkFollowStatus);

// Toggle follow status for a specific artist
router.post("/follow/toggle", protect, authorizeRole, FollowController.toggleFollow);

// Get followers count for a specific artist
router.get("/follow/count/:artistId", protect, authorizeRole, FollowController.getFollowersCount);

module.exports = router;