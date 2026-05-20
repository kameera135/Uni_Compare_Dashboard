import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Cell
} from 'recharts';

const COLORS = ['#f97316', '#3b82f6', '#10b981', '#8b5cf6'];

export default function FeeChart({ programs }) {
  if (!programs || programs.length === 0) return null;

  const data = programs
    .filter(p => p.tuition_fee)
    .map(p => ({
      name:  p.university_name?.replace('University of ', 'Uni of ') || p.program_name,
      fee:   Number(p.tuition_fee),
      label: p.program_name,
    }));

  if (data.length === 0) return null;

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-5 mb-6">
      <h2 className="text-base font-bold text-gray-700 mb-4">
        Annual Tuition Fee Comparison (AUD)
      </h2>
      <ResponsiveContainer width="100%" height={260}>
        <BarChart data={data} margin={{ top: 5, right: 20, left: 20, bottom: 60 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
          <XAxis
            dataKey="name"
            tick={{ fontSize: 11, fill: '#6b7280' }}
            angle={-30}
            textAnchor="end"
            interval={0}
          />
          <YAxis
            tickFormatter={v => `$${(v / 1000).toFixed(0)}k`}
            tick={{ fontSize: 11, fill: '#6b7280' }}
          />
          <Tooltip
            formatter={(value) => [`A$${Number(value).toLocaleString()}`, 'Annual Fee']}
            labelFormatter={(label) => `${label}`}
          />
          <Bar dataKey="fee" radius={[6, 6, 0, 0]}>
            {data.map((_, index) => (
              <Cell key={index} fill={COLORS[index % COLORS.length]} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}