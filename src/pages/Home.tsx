import React from 'react';
import { Link } from 'react-router-dom';
import { MoonIcon as PokemonIcon } from 'lucide-react';

export default function Home() {
  return (
    <div className="min-h-[calc(100vh-64px)] flex flex-col bg-gradient-to-br from-red-500 to-red-700 p-8">
      <div className="text-center text-white mb-12">
        <h1 className="text-6xl font-extrabold mb-6 tracking-tight">
          Pokédex Art Community
        </h1>
        <p className="text-2xl font-bold mb-12">
          Connect with trainers, explore regions, and share your Pokémon journey!
        </p>
      </div>

      <div className="flex flex-col items-center space-y-8 max-w-3xl mx-auto w-full">
        <Link to="/pokedex?region=kanto" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Kanto Region</h2>
          <p className="text-white/80">Discover the original 151 Pokémon</p>
        </Link>

        <Link to="/pokedex?region=johto" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Johto Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=hoenn" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Hoenn Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=sinnoh" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Sinnoh Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=unova" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Unova Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=kalos" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Kalos Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=alola" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Alola Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=galar" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Galar Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/pokedex?region=paldea" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore Paldea Region</h2>
          <p className="text-white/80">Coming Soon</p>
        </Link>

        <Link to="/feed" className="w-full bg-white/10 backdrop-blur-sm p-6 rounded-lg hover:bg-white/20 transition-all text-center">
          <h2 className="text-2xl font-bold text-white mb-2">Explore People's Posts</h2>
          <p className="text-white/80">Connect with the community</p>
        </Link>
      </div>
    </div>
  );
}