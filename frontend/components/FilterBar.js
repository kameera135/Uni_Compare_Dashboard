export default function FilterBar({ filters, setFilters, fields }) {
  const levels    = ['Bachelor', 'Masters', 'Doctoral', 'Diploma', 'Graduate Certificate', 'Graduate Diploma'];
  const modes     = ['on-campus', 'online', 'blended'];
  const sortOpts  = [
    { value: 'tuition_fee',     label: 'Fee: Low to High' },
    { value: 'tuition_fee_desc',label: 'Fee: High to Low' },
    { value: 'best_rank',       label: 'Best Rank' },
    { value: 'program_name',    label: 'Name A–Z' },
  ];

  const handle = (key, value) => setFilters(prev => ({ ...prev, [key]: value }));

  const reset = () => setFilters({
    field: '', level: '', delivery: '',
    minFee: '', maxFee: '', sort: 'tuition_fee'
  });

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-5 mb-6">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-base font-bold text-gray-700">Filter Programs</h2>
        <button onClick={reset} className="text-xs text-orange-500 hover:underline">
          Reset all
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">

        {/* Field of study */}
        <select
          value={filters.field}
          onChange={e => handle('field', e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-orange-300"
        >
          <option value="">All Fields</option>
          {fields.map(f => <option key={f} value={f}>{f}</option>)}
        </select>

        {/* Level */}
        <select
          value={filters.level}
          onChange={e => handle('level', e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-orange-300"
        >
          <option value="">All Levels</option>
          {levels.map(l => <option key={l} value={l}>{l}</option>)}
        </select>

        {/* Delivery mode */}
        <select
          value={filters.delivery}
          onChange={e => handle('delivery', e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-orange-300"
        >
          <option value="">All Modes</option>
          {modes.map(m => <option key={m} value={m}>{m}</option>)}
        </select>

        {/* Min fee */}
        <input
          type="number"
          placeholder="Min Fee (AUD)"
          value={filters.minFee}
          onChange={e => handle('minFee', e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-orange-300"
        />

        {/* Max fee */}
        <input
          type="number"
          placeholder="Max Fee (AUD)"
          value={filters.maxFee}
          onChange={e => handle('maxFee', e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-orange-300"
        />

        {/* Sort */}
        <select
          value={filters.sort}
          onChange={e => handle('sort', e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-orange-300"
        >
          {sortOpts.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
        </select>

      </div>
    </div>
  );
}