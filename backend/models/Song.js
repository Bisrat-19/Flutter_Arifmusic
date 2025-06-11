const mongoose = require('mongoose');

const songSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
    },
    genre: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        default: '',
    },
    artistId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    audioPath: {
        type: String,
        required: true,
    },
    coverImagePath: {
        type: String,
        default: null,
    },
    playCount: {
        type: Number,
        default: 0,
    },
    isFeatured: {
        type: Boolean,
        default: false, // Flag to indicate if the song is featured
    },
    featuredOrder: {
        type: Number,
        default: 0, // Order for sorting featured songs
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Song', songSchema);