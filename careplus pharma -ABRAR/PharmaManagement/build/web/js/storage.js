// MediStore - Storage Utilities (LocalStorage & SessionStorage)

const StorageKeys = {
  MEDICINES: 'medistore_medicines_v2',
  SALES: 'medistore_sales_v2',
  SUPPLIERS: 'medistore_suppliers_v2',
  CATEGORIES: 'medistore_categories_v2',
  USER_SESSION: 'medistore_user_session'
};

// Initial Medicine Data
const INITIAL_MEDICINES = [
  { id: '1', name: 'Amoxicillin 500mg', genericName: 'Amoxicillin', category: 'Antibiotics', price: 12.50, stock: 500, expiryDate: '2026-01-01', manufacturer: 'GlaxoSmithKline', unit: 'Tablet', batchNumber: 'GSK-101', shelfLocation: 'A1', requiresPrescription: true },
  { id: '2', name: 'Azithromycin 250mg', genericName: 'Azithromycin', category: 'Antibiotics', price: 25.00, stock: 300, expiryDate: '2026-02-15', manufacturer: 'Pfizer Inc.', unit: 'Tablet', batchNumber: 'PFZ-202', shelfLocation: 'A2', requiresPrescription: true },
  { id: '3', name: 'Ciprofloxacin 500mg', genericName: 'Ciprofloxacin', category: 'Antibiotics', price: 18.75, stock: 250, expiryDate: '2025-11-20', manufacturer: 'Novartis', unit: 'Tablet', batchNumber: 'NVT-303', shelfLocation: 'A3', requiresPrescription: true },
  { id: '4', name: 'Doxycycline 100mg', genericName: 'Doxycycline', category: 'Antibiotics', price: 15.00, stock: 400, expiryDate: '2025-08-10', manufacturer: 'Pfizer Inc.', unit: 'Tablet', batchNumber: 'PFZ-404', shelfLocation: 'A4', requiresPrescription: true },
  { id: '5', name: 'Paracetamol 500mg', genericName: 'Acetaminophen', category: 'Painkillers', price: 5.00, stock: 1000, expiryDate: '2027-05-30', manufacturer: 'Johnson & Johnson', unit: 'Strip', batchNumber: 'JJ-505', shelfLocation: 'B1', requiresPrescription: false },
  { id: '6', name: 'Ibuprofen 400mg', genericName: 'Ibuprofen', category: 'Painkillers', price: 8.50, stock: 800, expiryDate: '2026-12-01', manufacturer: 'Abbott Laboratories', unit: 'Strip', batchNumber: 'AB-606', shelfLocation: 'B2', requiresPrescription: false },
  { id: '7', name: 'Aspirin 300mg', genericName: 'Aspirin', category: 'Painkillers', price: 6.00, stock: 600, expiryDate: '2026-04-12', manufacturer: 'Sanofi', unit: 'Tablet', batchNumber: 'SN-707', shelfLocation: 'B3', requiresPrescription: false },
  { id: '8', name: 'Naproxen 250mg', genericName: 'Naproxen', category: 'Painkillers', price: 12.00, stock: 350, expiryDate: '2025-09-05', manufacturer: 'Roche', unit: 'Tablet', batchNumber: 'RC-808', shelfLocation: 'B4', requiresPrescription: true },
  { id: '9', name: 'Vitamin C 1000mg', genericName: 'Ascorbic Acid', category: 'Vitamins', price: 10.00, stock: 750, expiryDate: '2026-10-20', manufacturer: 'Abbott Laboratories', unit: 'Bottle', batchNumber: 'AB-909', shelfLocation: 'V1', requiresPrescription: false },
  { id: '10', name: 'Vitamin D3 2000 IU', genericName: 'Cholecalciferol', category: 'Vitamins', price: 15.50, stock: 600, expiryDate: '2027-01-15', manufacturer: 'Pfizer Inc.', unit: 'Strip', batchNumber: 'PFZ-1010', shelfLocation: 'V2', requiresPrescription: false },
  { id: '11', name: 'Multivitamin Plus', genericName: 'Multivitamin', category: 'Vitamins', price: 20.00, stock: 500, expiryDate: '2026-03-25', manufacturer: 'GlaxoSmithKline', unit: 'Bottle', batchNumber: 'GSK-111', shelfLocation: 'V3', requiresPrescription: false }
];

const INITIAL_CATEGORIES = [
  { id: '1', name: 'Antibiotics', description: 'Bacterial infections' },
  { id: '2', name: 'Painkillers', description: 'Pain relief' },
  { id: '3', name: 'Vitamins', description: 'Supplements' }
];

const CATEGORIES_LIST = ['Antibiotics', 'Painkillers', 'Vitamins', 'Antiseptics', 'Others'];

// Medicine Operations
function getMedicines() {
  const stored = localStorage.getItem(StorageKeys.MEDICINES);
  if (stored) {
    return JSON.parse(stored);
  }
  // Initialize with default data
  setMedicines(INITIAL_MEDICINES);
  return INITIAL_MEDICINES;
}

function setMedicines(medicines) {
  localStorage.setItem(StorageKeys.MEDICINES, JSON.stringify(medicines));
}

function addMedicine(medicine) {
  const medicines = getMedicines();
  const newMedicine = {
    ...medicine,
    id: Date.now().toString(36) + Math.random().toString(36).substr(2)
  };
  medicines.push(newMedicine);
  setMedicines(medicines);
  return newMedicine;
}

function updateMedicine(id, updates) {
  const medicines = getMedicines();
  const index = medicines.findIndex(m => m.id === id);
  if (index !== -1) {
    medicines[index] = { ...medicines[index], ...updates };
    setMedicines(medicines);
    return medicines[index];
  }
  return null;
}

function deleteMedicine(id) {
  const medicines = getMedicines();
  const filtered = medicines.filter(m => m.id !== id);
  setMedicines(filtered);
  return true;
}

// Sales Operations
function getSales() {
  const stored = localStorage.getItem(StorageKeys.SALES);
  return stored ? JSON.parse(stored) : [];
}

function setSales(sales) {
  localStorage.setItem(StorageKeys.SALES, JSON.stringify(sales));
}

function addSale(sale) {
  const sales = getSales();
  const newSale = {
    ...sale,
    id: `INV-${Date.now().toString().substr(-6)}`,
    date: new Date().toISOString()
  };
  sales.unshift(newSale);
  setSales(sales);
  
  // Update medicine stock
  const medicines = getMedicines();
  sale.items.forEach(item => {
    const medIndex = medicines.findIndex(m => m.id === item.medicineId);
    if (medIndex !== -1) {
      medicines[medIndex].stock = Math.max(0, medicines[medIndex].stock - item.quantity);
    }
  });
  setMedicines(medicines);
  
  return newSale;
}

// Supplier Operations
function getSuppliers() {
  const stored = localStorage.getItem(StorageKeys.SUPPLIERS);
  return stored ? JSON.parse(stored) : [];
}

function setSuppliers(suppliers) {
  localStorage.setItem(StorageKeys.SUPPLIERS, JSON.stringify(suppliers));
}

function addSupplier(supplier) {
  const suppliers = getSuppliers();
  const newSupplier = {
    ...supplier,
    id: Date.now().toString(36) + Math.random().toString(36).substr(2)
  };
  suppliers.push(newSupplier);
  setSuppliers(suppliers);
  return newSupplier;
}

function updateSupplier(id, updates) {
  const suppliers = getSuppliers();
  const index = suppliers.findIndex(s => s.id === id);
  if (index !== -1) {
    suppliers[index] = { ...suppliers[index], ...updates };
    setSuppliers(suppliers);
    return suppliers[index];
  }
  return null;
}

function deleteSupplier(id) {
  const suppliers = getSuppliers();
  const filtered = suppliers.filter(s => s.id !== id);
  setSuppliers(filtered);
  return true;
}

// Category Operations
function getCategories() {
  const stored = localStorage.getItem(StorageKeys.CATEGORIES);
  if (stored) {
    return JSON.parse(stored);
  }
  // Initialize with default categories
  setCategories(INITIAL_CATEGORIES);
  return INITIAL_CATEGORIES;
}

function setCategories(categories) {
  localStorage.setItem(StorageKeys.CATEGORIES, JSON.stringify(categories));
}

function addCategory(category) {
  const categories = getCategories();
  const newCategory = {
    ...category,
    id: Date.now().toString(36) + Math.random().toString(36).substr(2)
  };
  categories.push(newCategory);
  setCategories(categories);
  return newCategory;
}

function updateCategory(id, updates) {
  const categories = getCategories();
  const index = categories.findIndex(c => c.id === id);
  if (index !== -1) {
    categories[index] = { ...categories[index], ...updates };
    setCategories(categories);
    return categories[index];
  }
  return null;
}

function deleteCategory(id) {
  const categories = getCategories();
  const filtered = categories.filter(c => c.id !== id);
  setCategories(filtered);
  return true;
}

// Authentication Operations
function getCurrentUser() {
  const stored = sessionStorage.getItem(StorageKeys.USER_SESSION);
  return stored ? JSON.parse(stored) : null;
}

function setCurrentUser(user) {
  if (user) {
    sessionStorage.setItem(StorageKeys.USER_SESSION, JSON.stringify(user));
  } else {
    sessionStorage.removeItem(StorageKeys.USER_SESSION);
  }
}

function login(username, password) {
  // Simple authentication - in production this would call an API
  if (username === 'admin' && password === 'password') {
    const user = {
      id: '1',
      username: 'admin',
      fullName: 'Administrator',
      role: 'admin',
      lastLogin: new Date().toISOString()
    };
    setCurrentUser(user);
    return user;
  }
  return null;
}

function logout() {
  setCurrentUser(null);
  window.location.href = 'login.jsp';
}

// Replace the old requireAuth with this one in storage.js
function requireAuth() {
  const user = getCurrentUser();
  
  // LOG FOR DEBUGGING - Press F12 in browser to see this
  console.log("Checking Auth. User found:", user);

  // If we are on login.jsp, don't redirect
  if (window.location.pathname.endsWith('login.jsp')) {
    return true;
  }

  // FORCE BYPASS for Internship UI Design
  // If no user is found, we create a temporary one so the UI doesn't break
  if (!user) {
    console.warn("No user session found. Creating temporary session for UI design.");
    const tempUser = { username: 'admin', role: 'admin' };
    setCurrentUser(tempUser);
    return true; 
  }
  
  return true;
}