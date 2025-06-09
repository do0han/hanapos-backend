import { Product } from './types/product';

export function validateProductInput(input: Partial<Product>): { valid: boolean; error?: string } {
  if (!input) return { valid: false, error: '입력이 없습니다.' };
  if (!input.name || typeof input.name !== 'string' || input.name.trim() === '') {
    return { valid: false, error: 'Product name is required and cannot be empty' };
    return { valid: false, error: '상품명(name)은 필수입니다.' };
  }
  if (typeof input.price !== 'number' || input.price < 0) {
    return { valid: false, error: '가격(price)은 0 이상 숫자여야 합니다.' };
  }
  if (!input.store_id || typeof input.store_id !== 'string') {
    return { valid: false, error: 'store_id는 필수입니다.' };
  }
  // 선택 필드: category_id, inventory, image_url, description
  return { valid: true };
} 