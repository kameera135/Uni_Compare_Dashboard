const express = require('express');
const cors    = require('cors');
require('dotenv').config();

const programRoutes    = require('./routes/programs');
const universityRoutes = require('./routes/universities');

const app  = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/programs',      programRoutes);
app.use('/api/universities',  universityRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'UniCompare API is running' });
});

// Start server
app.listen(PORT, () => {
  console.log(`UniCompare API running on http://localhost:${PORT}`);
  console.log(`Test it: http://localhost:${PORT}/api/health`);
});