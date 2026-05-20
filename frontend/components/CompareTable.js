export default function CompareTable({ programs, onRemove }) {
  if (!programs || programs.length === 0) return null;

  const rows = [
    { label: 'University',      key: 'university_name' },
    { label: 'Field',           key: 'field_of_study' },
    { label: 'Level',           key: 'level' },
    { label: 'Duration',        key: 'duration' },
    { label: 'Annual Fee',      key: 'tuition_fee',        format: v => v ? `A$${Number(v).toLocaleString()}` : 'N/A' },
    { label: 'QS Rank',         key: 'best_rank',          format: v => v ? `#${v}` : 'N/A' },
    { label: 'Delivery',        key: 'delivery_mode' },
    { label: 'IELTS Required',  key: 'ielts_score',        format: v => v ? v : 'N/A' },
    { label: 'Avg Salary',      key: 'avg_salary_aud',     format: v => v ? `A$${Number(v).toLocaleString()}` : 'N/A' },
    { label: 'Employment Rate', key: 'avg_employment_pct', format: v => v ? `${v}%` : 'N/A' },
    { label: 'Visa Pathway',    key: 'visa_type' },
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-x-auto mb-6">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-gray-50">
            <th className="text-left p-4 text-gray-500 font-semibold w-36">Criteria</th>
            {programs.map(p => (
              <th key={p.program_id} className="p-4 text-center">
                <div className="text-orange-500 text-xs font-semibold uppercase mb-1">
                  {p.university_name}
                </div>
                <div className="text-gray-800 font-bold text-sm leading-snug">
                  {p.program_name}
                </div>
                <button
                  onClick={() => onRemove(p.program_id)}
                  className="mt-2 text-xs text-red-400 hover:text-red-600"
                >
                  Remove
                </button>
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row, i) => (
            <tr key={row.key} className={i % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
              <td className="p-4 text-gray-500 font-medium">{row.label}</td>
              {programs.map(p => (
                <td key={p.program_id} className="p-4 text-center text-gray-800 font-medium">
                  {row.format ? row.format(p[row.key]) : (p[row.key] || 'N/A')}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}