import { useState, useEffect } from 'react';
import axios from 'axios';
import Head from 'next/head';
import ProgramCard from '../components/ProgramCard';
import FilterBar   from '../components/FilterBar';
import FeeChart    from '../components/FeeChart';
import Link        from 'next/link';

const API = process.env.NEXT_PUBLIC_API_URL;

export default function Home() {
  const [programs,    setPrograms]    = useState([]);
  const [fields,      setFields]      = useState([]);
  const [compareList, setCompareList] = useState([]);
  const [loading,     setLoading]     = useState(true);
  const [search,      setSearch]      = useState('');
  const [filters, setFilters] = useState({
    field: '', level: '', delivery: '',
    minFee: '', maxFee: '', ielts: '', sort: 'tuition_fee'
  });

  // Load fields for dropdown
  useEffect(() => {
    axios.get(`${API}/programs/fields/list`)
      .then(r => setFields(r.data.data))
      .catch(() => {});
  }, []);

  // Load programs whenever filters change
  useEffect(() => {
    const fetchPrograms = async () => {
      setLoading(true);
      const params = {};
      if (filters.field)    params.field    = filters.field;
      if (filters.level)    params.level    = filters.level;
      if (filters.delivery) params.delivery = filters.delivery;
      if (filters.minFee)   params.minFee   = filters.minFee;
      if (filters.maxFee)   params.maxFee   = filters.maxFee;
      if (filters.ielts)    params.ielts = filters.ielts;
      if (search)           params.university = search;

      if (filters.sort === 'tuition_fee_desc') {
        params.sort  = 'tuition_fee';
        params.order = 'DESC';
      } else {
        params.sort  = filters.sort;
        params.order = 'ASC';
      }

      try {
        const r = await axios.get(`${API}/programs`, { params });
        setPrograms(r.data.data);
      } catch {
        setPrograms([]);
      } finally {
        setLoading(false);
      }
    };

    fetchPrograms();
  }, [filters, search]);

  const addToCompare = (program) => {
    if (compareList.length >= 4) return;
    if (compareList.some(p => p.program_id === program.program_id)) return;
    setCompareList(prev => [...prev, program]);
  };

  return (
    <>
      <Head>
        <title>UniCompare — Find Your Australian University Program</title>
      </Head>

      <div className="min-h-screen bg-gray-50">

        {/* Header */}
        <header className="bg-white shadow-sm border-b border-gray-100">
          <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-extrabold text-orange-500">UniCompare</h1>
              <p className="text-xs text-gray-400">Australian University Program Comparison</p>
            </div>
            {compareList.length > 0 && (
              <Link href={{ pathname: '/compare', query: { ids: compareList.map(p => p.program_id).join(',') } }}>
                <span className="bg-orange-500 hover:bg-orange-600 text-white text-sm font-semibold px-5 py-2 rounded-full cursor-pointer transition-colors">
                  Compare ({compareList.length}) →
                </span>
              </Link>
            )}
          </div>
        </header>

        <main className="max-w-7xl mx-auto px-6 py-8">

          {/* Hero */}
          <div className="text-center mb-8">
            <h2 className="text-3xl font-extrabold text-gray-800 mb-2">
              Find Your Perfect Program
            </h2>
            <p className="text-gray-500 max-w-xl mx-auto">
              Compare tuition fees, rankings, visa pathways and career outcomes
              across Australian universities — all in one place.
            </p>
          </div>

          {/* Search bar */}
          <div className="mb-4">
            <input
              type="text"
              placeholder="Search by university name..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="w-full border border-gray-200 rounded-xl px-5 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-orange-300 shadow-sm"
            />
          </div>

          {/* Filters */}
          <FilterBar filters={filters} setFilters={setFilters} fields={fields} />

          {/* Fee chart — shows when programs loaded */}
          {!loading && programs.length > 0 && (
            <FeeChart programs={programs.slice(0, 8)} />
          )}

          {/* Results count */}
          <div className="flex items-center justify-between mb-4">
            <p className="text-sm text-gray-500">
              {loading ? 'Loading...' : `${programs.length} programs found`}
            </p>
          </div>

          {/* Program cards grid */}
          {loading ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
              {[...Array(6)].map((_, i) => (
                <div key={i} className="bg-white rounded-xl h-64 animate-pulse border border-gray-100" />
              ))}
            </div>
          ) : programs.length === 0 ? (
            <div className="text-center py-20 text-gray-400">
              <p className="text-4xl mb-3">🎓</p>
              <p className="text-lg font-medium">No programs found</p>
              <p className="text-sm">Try adjusting your filters</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
              {programs.map(program => (
                <ProgramCard
                  key={program.program_id}
                  program={program}
                  onAddToCompare={addToCompare}
                  compareList={compareList}
                />
              ))}
            </div>
          )}

        </main>
      </div>
    </>
  );
}