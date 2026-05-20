const express = require('express');
const router  = express.Router();
const pool    = require('../db');

// GET /api/universities
// List all universities
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT u.university_id, u.name, u.location, u.website_url,
              COUNT(p.program_id) AS program_count
       FROM UNIVERSITY u
       LEFT JOIN PROGRAM p ON u.university_id = p.university_id
       GROUP BY u.university_id
       ORDER BY u.name`
    );
    res.json({ success: true, count: rows.length, data: rows });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


// GET /api/universities/:id/programs
// Get all programs for one university
router.get('/:id/programs', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * FROM vw_program_filter WHERE university_name =
        (SELECT name FROM UNIVERSITY WHERE university_id = ?)`,
      [req.params.id]
    );
    res.json({ success: true, count: rows.length, data: rows });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


module.exports = router;