﻿using BusinessObject.Entities;
using Microsoft.EntityFrameworkCore;

namespace DataAccessObject.Dao;

public class OrderDao : IDao<Order>
{
    private readonly MinhXuanDatabaseContext _context;

    public OrderDao(MinhXuanDatabaseContext context)
    {
        _context = context;
    }
    public async Task<List<Order>> GetAllOrdersAsync()
    {
        return await _context.Orders.ToListAsync();
    }
    // Get Order by ID
    public async Task<Order?> GetByIdAsync(int id)
    {
        return await _context.Orders
            .AsNoTracking()
            .FirstOrDefaultAsync(o => o.OrderId == id);
    }

    // Create a new Order
    public async Task<Order?> CreateAsync(Order entity)
    {
        await _context.Orders.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    // Update an existing Order
    public async Task<Order?> UpdateAsync(Order entity)
    {
        var existingOrder = await _context.Orders.FindAsync(entity.OrderId);
        if (existingOrder == null)
        {
            throw new ArgumentException("Order not found");
        }

        _context.Orders.Update(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    // Delete an Order by ID
    public async Task<bool> DeleteAsync(int id)
    {
        var order = await _context.Orders.FindAsync(id);
        if (order == null)
        {
            return false;
        }

        _context.Orders.Remove(order);
        await _context.SaveChangesAsync();
        return true;
    }

    // Get all Orders
    public async Task<List<Order>?> GetAllAsync()
    {
        return await _context.Orders
            .Include(order => order.Customer)
            .Include(order=>order.OrderDetails)
            .Include(order=>order.Receipts)
            .AsNoTracking()
            .ToListAsync();
    }

    // Get a page of Orders (pagination)
    public async Task<List<Order>?> GetPageAsync(int page, int pageSize)
    {
        return await _context.Orders
            .AsNoTracking()
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }
    public async Task<List<Order>?> GetOrdersByCustomerIdAsync(int customerId, int page, int pageSize)
    {
        return await _context.Orders
            .Where(order => order.CustomerId == customerId)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }
    public async Task<List<Order>?> GetOrdersByPageAsync(int page, int pageSize)
    {
        return await _context.Orders
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }
    public async Task<List<Order>?> SearchAsync(DateTime? startDate, DateTime? endDate, string customerName, int page = 1, int pageSize = 20)
    {
        var query = _context.Orders.AsQueryable();

        if (startDate.HasValue && endDate.HasValue)
        {
            query = query.Where(o => o.OrderDate >= startDate.Value && o.OrderDate <= endDate.Value);
        }

        if (!string.IsNullOrEmpty(customerName))
        {
            query = query.Where(o => o.Customer.FullName.Contains(customerName));
        }
        return await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<int> CountAsync()
    {
        return await _context.Orders.CountAsync();
    }
}
