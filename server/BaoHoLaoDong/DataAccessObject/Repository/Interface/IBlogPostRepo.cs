﻿using BusinessObject.Entities;

namespace DataAccessObject.Repository.Interface
{
    public interface IBlogPostRepo
    {
        Task<BlogPost?> GetBlogPostByIdAsync(int id);
        Task<BlogPost?> CreateBlogPostAsync(BlogPost blogPost);
        Task<BlogPost?> UpdateBlogPostAsync(BlogPost blogPost);
        Task<bool> DeleteBlogPostAsync(int id);
        Task<List<BlogPost>?> GetAllBlogPostsAsync();
        Task<List<BlogPost>?> GetBlogPostsPageAsync(int page, int pageSize);
    }
}
