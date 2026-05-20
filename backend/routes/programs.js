const express = require('express');
const router  = express.Router();
const pool    = require('../db');

// -------------------------------------------------------
// GET /api/programs
// Search and filter programs
// Query params: field, level, delivery, maxFee, minFee, ielts, university, sort
//
// Example: /api/programs?field=IT&level=Masters&maxFee=50000
// -------------------------------------------------------
router.get('/', async (req, res) => {
  try {
    const {
      field,
      level,
      delivery,
      maxFee,
      minFee,
      ielts,
      university,
      sort = 'tuition_fee',
      order = 'ASC',
    } = req.query;

    let query  = `SELECT * FROM vw_program_filter WHERE 1=1`;
    const params = [];

    if (field) {
      query += ` AND field_of_study LIKE ?`;
      params.push(`%${field}%`);
    }
    if (level) {
      query += ` AND level = ?`;
      params.push(level);
    }
    if (delivery) {
      query += ` AND delivery_mode = ?`;
      params.push(delivery);
    }
    if (maxFee) {
      query += ` AND tuition_fee <= ?`;
      params.push(Number(maxFee));
    }
    if (minFee) {
      query += ` AND tuition_fee >= ?`;
      params.push(Number(minFee));
    }
    if (ielts) {
      query += ` AND ielts_score <= ?`;
      params.push(Number(ielts));
    }
    if (university) {
      query += ` AND university_name LIKE ?`;
      params.push(`%${university}%`);
    }

    // Only allow safe sort columns
    const allowedSort = ['tuition_fee', 'best_rank', 'program_name', 'university_name'];
    const safeSort    = allowedSort.includes(sort) ? sort : 'tuition_fee';
    const safeOrder   = order.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    query += ` ORDER BY ${safeSort} ${safeOrder}`;

    const [rows] = await pool.query(query, params);

    res.json({
      success: true,
      count:   rows.length,
      data:    rows,
    });

  } catch (error) {
    console.error('Error fetching programs:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


// -------------------------------------------------------
// GET /api/programs/:id
// Get full detail of one program
// -------------------------------------------------------
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * FROM vw_program_detail WHERE program_id = ?`,
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Program not found' });
    }

    res.json({ success: true, data: rows[0] });

  } catch (error) {
    console.error('Error fetching program:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


// -------------------------------------------------------
// GET /api/programs/compare?ids=1,2,3,4
// Side by side comparison of up to 4 programs
// -------------------------------------------------------
router.get('/compare/list', async (req, res) => {
  try {
    const { ids } = req.query;

    if (!ids) {
      return res.status(400).json({ success: false, message: 'Provide ids param e.g. ?ids=1,2,3' });
    }

    // Sanitise: only allow numbers
    const idList = ids.split(',')
      .map(id => parseInt(id.trim()))
      .filter(id => !isNaN(id))
      .slice(0, 4); // max 4 programs

    if (idList.length === 0) {
      return res.status(400).json({ success: false, message: 'No valid IDs provided' });
    }

    const placeholders = idList.map(() => '?').join(',');
    const [rows] = await pool.query(
      `SELECT * FROM vw_program_detail WHERE program_id IN (${placeholders})`,
      idList
    );

    res.json({
      success: true,
      count:   rows.length,
      data:    rows,
    });

  } catch (error) {
    console.error('Error comparing programs:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


// -------------------------------------------------------
// GET /api/programs/fields/list
// Get all unique fields of study (for filter dropdowns)
// -------------------------------------------------------
router.get('/fields/list', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT DISTINCT field_of_study FROM PROGRAM ORDER BY field_of_study`
    );
    res.json({ success: true, data: rows.map(r => r.field_of_study) });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


module.exports = router;