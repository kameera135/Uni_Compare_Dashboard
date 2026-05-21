export default function ProgramCard({ program, onAddToCompare, compareList }) {
  const isAdded = compareList.some(p => p.program_id === program.program_id);

  return (
    <div className="bg-white rounded-xl shadow-md p-5 border border-gray-100 hover:shadow-lg transition-shadow">
      
      {/* University name */}
      <p className="text-sm font-semibold text-orange-500 uppercase tracking-wide mb-1">
        {program.university_name}
      </p>

      {/* Program name */}
      <h3 className="text-lg font-bold text-gray-800 mb-2 leading-snug">
        {program.program_name}
      </h3>

      {/* Tags row */}
      <div className="flex flex-wrap gap-2 mb-4">
        <span className="bg-blue-50 text-blue-700 text-xs px-2 py-1 rounded-full font-medium">
          {program.level}
        </span>
        <span className="bg-green-50 text-green-700 text-xs px-2 py-1 rounded-full font-medium">
          {program.delivery_mode}
        </span>
        {program.field_of_study && (
          <span className="bg-purple-50 text-purple-700 text-xs px-2 py-1 rounded-full font-medium">
            {program.field_of_study}
          </span>
        )}
      </div>

      {/* Stats grid */}
      <div className="grid grid-cols-2 gap-3 mb-4">
        <div>
          <p className="text-xs text-gray-400">Annual Fee</p>
          <p className="text-base font-bold text-gray-800">
            {program.tuition_fee
              ? `A$${Number(program.tuition_fee).toLocaleString()}`
              : 'Contact university'}
          </p>
        </div>
        <div>
          <p className="text-xs text-gray-400">QS Rank</p>
          <p className="text-base font-bold text-gray-800">
            {program.best_rank ? `#${program.best_rank}` : 'N/A'}
          </p>
        </div>
        <div>
          <p className="text-xs text-gray-400">Duration</p>
          <p className="text-sm font-medium text-gray-700">
            {program.duration || 'See university'}
          </p>
        </div>
        <div>
          <p className="text-xs text-gray-400">IELTS Required</p>
          <p className="text-sm font-medium text-gray-700">
            {program.ielts_score ? program.ielts_score : 'N/A'}
          </p>
        </div>
      </div>

      {/* Career outcomes section */}
      {(program.avg_salary_aud || program.avg_employment_pct) && (
        <div className="bg-gray-50 rounded-lg p-3 mb-4">
          <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
            Career Outcomes
          </p>
          <div className="grid grid-cols-2 gap-2">
            {program.avg_salary_aud && (
              <div>
                <p className="text-xs text-gray-400">Avg Salary</p>
                <p className="text-sm font-bold text-green-600">
                  A${Number(program.avg_salary_aud).toLocaleString()}
                </p>
              </div>
            )}
            {program.avg_employment_pct && (
              <div>
                <p className="text-xs text-gray-400">Employment Rate</p>
                <p className="text-sm font-bold text-green-600">
                  {program.avg_employment_pct}%
                </p>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Visa pathway */}
      {program.visa_type && (
        <div className="mb-4">
          <p className="text-xs text-gray-400">Visa Pathway</p>
          <p className="text-xs font-medium text-blue-600">
            {program.visa_type}
          </p>
        </div>
      )}

      {/* Compare button */}
      <button
        onClick={() => onAddToCompare(program)}
        disabled={isAdded || compareList.length >= 4}
        className={`w-full py-2 rounded-lg text-sm font-semibold transition-colors ${
          isAdded
            ? 'bg-green-100 text-green-700 cursor-default'
            : compareList.length >= 4
            ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
            : 'bg-orange-500 hover:bg-orange-600 text-white cursor-pointer'
        }`}
      >
        {isAdded ? '✓ Added to Compare' : '+ Add to Compare'}
      </button>
    </div>
  );
}