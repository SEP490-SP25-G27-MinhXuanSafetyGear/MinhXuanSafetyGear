﻿using System.Collections.Generic;
using System.Threading.Tasks;
using BusinessLogicLayer.Mappings.RequestDTO;
using BusinessLogicLayer.Mappings.ResponseDTO;
using BusinessLogicLayer.Models;

namespace BusinessLogicLayer.Services.Interface;

public interface IProductService
{
     Task<CategoryResponse?> CreateNewCategory(NewCategory category);
     Task<List<CategoryResponse>?> GetAllCategory();
     
     Task<Page<ProductResponse>?> GetProductByPage(int category = 0, int page = 1, int pageSize = 20);
     Task<CategoryResponse?> UpdateCategoryAsync(UpdateCategory category);
     Task<ProductResponse> CreateNewProductAsync(NewProduct newProduct);
     Task<int> CountProductByCategory(int category);
     Task<ProductResponse?> UpdateProductAsync(UpdateProduct updateProduct);
     Task<bool?> UpdateProductImageAsync(UpdateProductImage updateProductImage);
     Task<bool?> DeleteImageAsync(int id);
     Task<bool?> CreateNewProductImageAsync(NewProductImage productImage);
     Task<ProductResponse?> CreateNewProductVariantAsync(NewProductVariant newProductVariant);
     Task<ProductResponse?> UpdateProductVariantAsync(UpdateProductVariant updateProductVariant);
}