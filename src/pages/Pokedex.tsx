import React, { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { Heart, Search, Menu } from 'lucide-react';

interface Pokemon {
  id: number;
  name: string;
  types: string[];
  description: string;
}

export default function Pokedex() {
  const [searchParams] = useSearchParams();
  const region = searchParams.get('region') || 'kanto';
  const [pokemon, setPokemon] = useState<Pokemon[]>([]);
  const [filteredPokemon, setFilteredPokemon] = useState<Pokemon[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [showMenu, setShowMenu] = useState(false);
  const [favorites, setFavorites] = useState<number[]>([]);

  useEffect(() => {
    async function fetchPokemon() {
      try {
        const { data, error } = await supabase
          .from('pokemon')
          .select('*')
          .order('id');

        if (error) throw error;
        setPokemon(data || []);
        setFilteredPokemon(data || []);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch Pokémon');
      } finally {
        setLoading(false);
      }
    }

    fetchPokemon();
  }, []);

  useEffect(() => {
    const filtered = pokemon.filter(p => 
      p.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      p.types.some(type => type.toLowerCase().includes(searchTerm.toLowerCase())) ||
      p.id.toString().includes(searchTerm)
    );
    setFilteredPokemon(filtered);
  }, [searchTerm, pokemon]);

  const toggleFavorite = (id: number) => {
    setFavorites(prev => 
      prev.includes(id) 
        ? prev.filter(pokemonId => pokemonId !== id)
        : [...prev, id]
    );
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-100 p-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-red-600 mx-auto"></div>
            <p className="mt-4 text-gray-600">Loading Pokédex...</p>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-100 p-8">
        <div className="max-w-7xl mx-auto">
          <div className="bg-red-50 p-4 rounded-lg">
            <p className="text-red-600">{error}</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <h1 className="text-4xl font-bold text-center mb-8 capitalize">{region} Region Pokédex</h1>
        <div className="bg-white rounded-lg shadow-lg overflow-hidden">
          <div className="divide-y divide-gray-200">
            {filteredPokemon.map((p) => (
              <div key={p.id} className="p-6 hover:bg-gray-50 transition-colors">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <span className="text-lg font-semibold text-gray-500">
                      #{p.id.toString().padStart(3, '0')}
                    </span>
                    <h2 className="text-xl font-bold">{p.name}</h2>
                    <div className="flex gap-2">
                      {p.types.map((type) => (
                        <span
                          key={type}
                          className="px-3 py-1 rounded-full text-sm font-medium capitalize"
                          style={{
                            backgroundColor: getTypeColor(type),
                            color: 'white'
                          }}
                        >
                          {type}
                        </span>
                      ))}
                    </div>
                  </div>
                  <button
                    onClick={() => toggleFavorite(p.id)}
                    className="focus:outline-none"
                  >
                    <Heart
                      size={24}
                      className={`transition-colors ${
                        favorites.includes(p.id)
                          ? 'fill-red-500 text-red-500'
                          : 'text-gray-400 hover:text-red-500'
                      }`}
                    />
                  </button>
                </div>
                <p className="mt-2 text-gray-600">{p.description}</p>
              </div>
            ))}
          </div>
        </div>
      </div>

      <button
        onClick={() => setShowMenu(!showMenu)}
        className="fixed bottom-8 right-8 bg-red-600 text-white p-4 rounded-full shadow-lg hover:bg-red-700 transition-colors z-20"
      >
        <Menu size={24} />
      </button>

      {showMenu && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-30" onClick={() => setShowMenu(false)}>
          <div 
            className="fixed bottom-24 right-8 w-80 bg-white rounded-lg shadow-xl"
            onClick={e => e.stopPropagation()}
          >
            <div className="p-6">
              <h2 className="text-xl font-bold mb-4">Search & Filters</h2>
              <div className="space-y-4">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                  <input
                    type="text"
                    placeholder="Search Pokémon..."
                    className="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                  />
                </div>
                <div>
                  <h3 className="font-semibold mb-2">Filter by Type</h3>
                  {/* Add type filters here */}
                </div>
                <div>
                  <h3 className="font-semibold mb-2">Sort By</h3>
                  {/* Add sorting options here */}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function getTypeColor(type: string): string {
  const colors: { [key: string]: string } = {
    normal: '#A8A878',
    fire: '#F08030',
    water: '#6890F0',
    electric: '#F8D030',
    grass: '#78C850',
    ice: '#98D8D8',
    fighting: '#C03028',
    poison: '#A040A0',
    ground: '#E0C068',
    flying: '#A890F0',
    psychic: '#F85888',
    bug: '#A8B820',
    rock: '#B8A038',
    ghost: '#705898',
    dragon: '#7038F8',
    dark: '#705848',
    steel: '#B8B8D0',
    fairy: '#EE99AC'
  };

  return colors[type.toLowerCase()] || '#777777';
}