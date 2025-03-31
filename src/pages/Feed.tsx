import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { format } from 'date-fns';
import { Heart, MessageCircle, Share2 } from 'lucide-react';

interface Post {
  id: string;
  content: string;
  image_url: string | null;
  created_at: string;
  user_id: string;
  profiles: {
    first_name: string;
    last_name: string;
    avatar_url: string | null;
  };
  likes: { user_id: string }[];
  comments: {
    id: string;
    content: string;
    user_id: string;
    created_at: string;
    profiles: {
      first_name: string;
      last_name: string;
      avatar_url: string | null;
    };
  }[];
}

export default function Feed() {
  const { user } = useAuth();
  const [posts, setPosts] = useState<Post[]>([]);
  const [newPost, setNewPost] = useState('');
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchPosts();
  }, []);

  async function fetchPosts() {
    try {
      const { data, error } = await supabase
        .from('posts')
        .select(`
          *,
          profiles (first_name, last_name, avatar_url),
          likes (user_id),
          comments (
            id,
            content,
            user_id,
            created_at,
            profiles (first_name, last_name, avatar_url)
          )
        `)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setPosts(data || []);
    } catch (error) {
      console.error('Error fetching posts:', error);
    } finally {
      setLoading(false);
    }
  }

  async function handleImageUpload(file: File) {
    const fileExt = file.name.split('.').pop();
    const fileName = `${Math.random()}.${fileExt}`;
    const filePath = `${fileName}`;

    const { error: uploadError, data } = await supabase.storage
      .from('post-images')
      .upload(filePath, file);

    if (uploadError) {
      throw uploadError;
    }

    const { data: { publicUrl } } = supabase.storage
      .from('post-images')
      .getPublicUrl(filePath);

    return publicUrl;
  }

  async function handleSubmitPost(e: React.FormEvent) {
    e.preventDefault();
    if (!user) return;

    try {
      let imageUrl = null;
      if (selectedImage) {
        imageUrl = await handleImageUpload(selectedImage);
      }

      const { error } = await supabase
        .from('posts')
        .insert([
          {
            user_id: user.id,
            content: newPost,
            image_url: imageUrl,
          },
        ]);

      if (error) throw error;
      setNewPost('');
      setSelectedImage(null);
      fetchPosts();
    } catch (error) {
      console.error('Error creating post:', error);
    }
  }

  async function handleLike(postId: string) {
    if (!user) return;

    try {
      const { error } = await supabase
        .from('likes')
        .insert([{ post_id: postId, user_id: user.id }]);

      if (error) throw error;
      fetchPosts();
    } catch (error) {
      console.error('Error liking post:', error);
    }
  }

  async function handleUnlike(postId: string) {
    if (!user) return;

    try {
      const { error } = await supabase
        .from('likes')
        .delete()
        .match({ post_id: postId, user_id: user.id });

      if (error) throw error;
      fetchPosts();
    } catch (error) {
      console.error('Error unliking post:', error);
    }
  }

  function handleShare(postId: string) {
    // Implement share functionality
    console.log('Share post:', postId);
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-100 p-8">
        <div className="max-w-2xl mx-auto">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-red-600 mx-auto"></div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <div className="max-w-2xl mx-auto">
        {user && (
          <form onSubmit={handleSubmitPost} className="bg-white rounded-lg shadow mb-8 p-6">
            <textarea
              value={newPost}
              onChange={(e) => setNewPost(e.target.value)}
              placeholder="What's on your mind?"
              className="w-full p-4 border rounded-lg mb-4"
              rows={3}
            />
            <input
              type="file"
              accept="image/jpeg,image/png"
              onChange={(e) => setSelectedImage(e.target.files?.[0] || null)}
              className="w-full p-4 border rounded-lg mb-4"
            />
            <button
              type="submit"
              className="bg-red-600 text-white px-6 py-2 rounded-lg hover:bg-red-700 transition-colors"
              disabled={!newPost.trim()}
            >
              Post
            </button>
          </form>
        )}

        <div className="space-y-6">
          {posts.map((post) => (
            <div key={post.id} className="bg-white rounded-lg shadow">
              <div className="p-6">
                <div className="flex items-center mb-4">
                  <img
                    src={post.profiles.avatar_url || 'https://via.placeholder.com/40'}
                    alt="Profile"
                    className="w-10 h-10 rounded-full mr-4"
                  />
                  <div>
                    <h3 className="font-semibold">
                      {post.profiles.first_name} {post.profiles.last_name}
                    </h3>
                    <p className="text-sm text-gray-500">
                      {format(new Date(post.created_at), 'MMM d, yyyy')}
                    </p>
                  </div>
                </div>
                <p className="mb-4">{post.content}</p>
                {post.image_url && (
                  <img
                    src={post.image_url}
                    alt="Post"
                    className="w-full rounded-lg mb-4"
                  />
                )}
                <div className="flex items-center gap-6">
                  {user && (
                    post.likes.some(like => like.user_id === user.id) ? (
                      <button
                        onClick={() => handleUnlike(post.id)}
                        className="flex items-center gap-2 text-red-600"
                      >
                        <Heart className="w-5 h-5 fill-current" />
                        <span>{post.likes.length}</span>
                      </button>
                    ) : (
                      <button
                        onClick={() => handleLike(post.id)}
                        className="flex items-center gap-2 text-gray-600 hover:text-red-600"
                      >
                        <Heart className="w-5 h-5" />
                        <span>{post.likes.length}</span>
                      </button>
                    )
                  )}
                  <button className="flex items-center gap-2 text-gray-600 hover:text-blue-600">
                    <MessageCircle className="w-5 h-5" />
                    <span>{post.comments.length}</span>
                  </button>
                  <button 
                    onClick={() => handleShare(post.id)}
                    className="flex items-center gap-2 text-gray-600 hover:text-green-600"
                  >
                    <Share2 className="w-5 h-5" />
                    <span>Share</span>
                  </button>
                </div>
              </div>
              {post.comments.length > 0 && (
                <div className="border-t p-6">
                  <h4 className="font-semibold mb-4">Comments</h4>
                  <div className="space-y-4">
                    {post.comments.map((comment) => (
                      <div key={comment.id} className="flex items-start gap-4">
                        <img
                          src={comment.profiles.avatar_url || 'https://via.placeholder.com/32'}
                          alt="Profile"
                          className="w-8 h-8 rounded-full"
                        />
                        <div>
                          <p className="font-semibold">
                            {comment.profiles.first_name} {comment.profiles.last_name}
                          </p>
                          <p className="text-sm text-gray-600">{comment.content}</p>
                          <p className="text-xs text-gray-500">
                            {format(new Date(comment.created_at), 'MMM d, yyyy')}
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}