import { useState, useEffect } from 'react';
import axios from 'axios';
import Head from 'next/head';
import Link from 'next/link';
import { useRouter } from 'next/router';
import CompareTable from '../components/CompareTable';
import FeeChart     from '../components/FeeChart';

const API = process.env.NEXT_PUBLIC_API_URL;

export default function Compare() {
  const router   = useRouter();
  const { ids }  = router.query;
  const [programs, setPrograms] = useState([]);
  const [loading,  setLoading]  = useState(true);

  useEffect(() => {
    if (!ids) return;
    
    const fetchPrograms = async () => {
      setLoading(true);
      try {
        const r = await axios.get(`${API}/programs/compare/list?ids=${ids}`);
        setPrograms(r.data.data);
      } catch {
        setPrograms([]);
      } finally {
        setLoading(false);
      }
    };

    fetchPrograms();
  }, [ids]);

  const remove = (id) => {
    const updated = programs.filter(p => p.program_id !== id);
    setPrograms(updated);
    const newIds = updated.map(p => p.program_id).join(',');
    router.replace({ pathname: '/compare', query: { ids: newIds } }, undefined, { shallow: true });
  };

  return (
    <>
      <Head>
        <title>Compare Programs — UniCompare</title>
      </Head>

      <div className="min-h-screen bg-gray-50">

        {/* Header */}
        <header className="bg-white shadow-sm border-b border-gray-100">
          <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
            <Link href="/">
              <span className="text-2xl font-extrabold text-orange-500 cursor-pointer">UniCompare</span>
            </Link>
            <Link href="/">
              <span className="text-sm text-gray-500 hover:text-orange-500 cursor-pointer">← Back to Search</span>
            </Link>
          </div>
        </header>

        <main className="max-w-7xl mx-auto px-6 py-8">
          <h2 className="text-2xl font-extrabold text-gray-800 mb-6">
            Program Comparison
          </h2>

          {loading ? (
            <div className="bg-white rounded-xl h-64 animate-pulse border border-gray-100" />
          ) : programs.length === 0 ? (
            <div className="text-center py-20 text-gray-400">
              <p className="text-4xl mb-3">📊</p>
              <p className="text-lg font-medium">No programs to compare</p>
              <Link href="/"><span className="text-orange-500 hover:underline cursor-pointer">Go back and add programs</span></Link>
            </div>
          ) : (
            <>
              <FeeChart programs={programs} />
              <CompareTable programs={programs} onRemove={remove} />
            </>
          )}
        </main>
      </div>
    </>
  );
}