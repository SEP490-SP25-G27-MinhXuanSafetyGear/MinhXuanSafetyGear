﻿using DataAccessObject.Repository.Interface;
using BusinessObject.Entities;
using DataAccessObject.Dao;

namespace DataAccessObject.Repository
{
    public class InvoiceRepo : IInvoiceRepo
    {
        private readonly InvoiceDao _invoiceDao;

        public InvoiceRepo(MinhXuanDatabaseContext context)
        {
            _invoiceDao = new InvoiceDao(context);
        }

        public async Task<Invoice?> GetInvoiceByIdAsync(int id)
        {
            return await _invoiceDao.GetByIdAsync(id);
        }

        public async Task<Invoice?> CreateInvoiceAsync(Invoice receipt)
        {
            return await _invoiceDao.CreateAsync(receipt);
        }

        public async Task<Invoice?> UpdateInvoiceAsync(Invoice receipt)
        {
            return await _invoiceDao.UpdateAsync(receipt);
        }

        public async Task<bool> DeleteInvoiceAsync(int id)
        {
            return await _invoiceDao.DeleteAsync(id);
        }

        public async Task<List<Invoice>?> GetAllInvoicesAsync()
        {
            return await _invoiceDao.GetAllAsync();
        }

        public async Task<List<Invoice>?> GetInvoicesPageAsync(int page, int pageSize)
        {
            return await _invoiceDao.GetPageAsync(page, pageSize);
        }
    }
}
