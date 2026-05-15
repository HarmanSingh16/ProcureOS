-- 1. GEOGRAPHIC DATA (Foundation for India/Europe/APAC operations)
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL, -- India, Europe, APAC
    compliance_protocol TEXT -- Regional regulatory standards
);

-- 2. RESEARCH & DEVELOPMENT PROJECTS
CREATE TABLE research_projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(255),
    start_date DATE,
    budget_allocation DECIMAL(15, 2),
    primary_investigator VARCHAR(100)
);

-- 3. ACTIVE PHARMACEUTICAL INGREDIENTS (APIs)
CREATE TABLE active_ingredients (
    api_id SERIAL PRIMARY KEY,
    chemical_name VARCHAR(255) UNIQUE,
    molecular_formula VARCHAR(100),
    hazard_level INT CHECK (hazard_level BETWEEN 1 AND 5)
);

-- 4. MEDICINE MASTER (The Core Entity)
CREATE TABLE medicines (
    medicine_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(255),
    therapeutic_class VARCHAR(100), -- Oncology, Cardiology, etc.
    development_status VARCHAR(50), -- Research (X), Review (Y), Distributed (Z)
    base_unit_cost DECIMAL(10, 2)
);

-- 5. MEDICINE COMPOSITION (Junction: Medicines <-> APIs)
CREATE TABLE medicine_composition (
    comp_id SERIAL PRIMARY KEY,
    medicine_id INT REFERENCES medicines(medicine_id),
    api_id INT REFERENCES active_ingredients(api_id),
    concentration_percentage DECIMAL(5, 2)
);

-- 6. REGULATORY SUBMISSIONS (Tracking 'Y' Medicines)
CREATE TABLE regulatory_submissions (
    submission_id SERIAL PRIMARY KEY,
    medicine_id INT REFERENCES medicines(medicine_id),
    region_id INT REFERENCES regions(region_id),
    submission_date DATE,
    status VARCHAR(50), -- Pending, Under Review, Rejected, Approved
    review_officer VARCHAR(100)
);

-- 7. CLINICAL TRIALS
CREATE TABLE clinical_trials (
    trial_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES research_projects(project_id),
    medicine_id INT REFERENCES medicines(medicine_id),
    phase VARCHAR(20), -- Phase I, II, III, IV
    participant_count INT,
    success_rate_projected DECIMAL(5, 2)
);

-- 8. MANUFACTURING FACILITIES
CREATE TABLE facilities (
    facility_id SERIAL PRIMARY KEY,
    region_id INT REFERENCES regions(region_id),
    facility_name VARCHAR(255),
    is_export_certified BOOLEAN DEFAULT TRUE,
    operational_status VARCHAR(50)
);

-- 9. PRODUCTION BATCHES
CREATE TABLE batches (
    batch_id SERIAL PRIMARY KEY,
    medicine_id INT REFERENCES medicines(medicine_id),
    facility_id INT REFERENCES facilities(facility_id),
    mfg_date DATE,
    expiry_date DATE,
    batch_purity_index DECIMAL(4, 2)
);

-- 10. GLOBAL LOGISTICS & SHIPMENTS
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    batch_id INT REFERENCES batches(batch_id),
    origin_facility_id INT REFERENCES facilities(facility_id),
    destination_region_id INT REFERENCES regions(region_id),
    shipping_mode VARCHAR(50), -- Air, Sea, Road
    temperature_logged_min DECIMAL(5, 2)
);

-- 11. DISTRIBUTORS
CREATE TABLE distributors (
    distributor_id SERIAL PRIMARY KEY,
    region_id INT REFERENCES regions(region_id),
    distributor_name VARCHAR(255),
    credit_rating VARCHAR(10)
);

-- 12. PHARMACY & CLINIC NETWORK
CREATE TABLE outlets (
    outlet_id SERIAL PRIMARY KEY,
    distributor_id INT REFERENCES distributors(distributor_id),
    outlet_name VARCHAR(255),
    city VARCHAR(100),
    is_hospital_linked BOOLEAN
);

-- 13. PATIENT RECORDS
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    region_id INT REFERENCES regions(region_id),
    age INT,
    genetic_profile_summary JSONB, -- For complex LLM parsing
    blood_group VARCHAR(5)
);

-- 14. MEDICAL CASE HISTORY
CREATE TABLE medical_history (
    history_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    chronic_condition VARCHAR(255),
    severity_rank INT
);

-- 15. PRESCRIPTIONS
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    medicine_id INT REFERENCES medicines(medicine_id),
    outlet_id INT REFERENCES outlets(outlet_id),
    prescribed_date DATE
);

-- 16. SALES TRANSACTIONS (Financial & Stock Tracking)
CREATE TABLE sales_transactions (
    sale_id SERIAL PRIMARY KEY,
    batch_id INT REFERENCES batches(batch_id),
    outlet_id INT REFERENCES outlets(outlet_id),
    quantity_sold INT,
    unit_price_at_sale DECIMAL(10, 2),
    transaction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 17. ADVERSE EVENT REPORTING (Pharmacovigilance)
CREATE TABLE adverse_events (
    event_id SERIAL PRIMARY KEY,
    prescription_id INT REFERENCES prescriptions(prescription_id),
    symptom_observed TEXT,
    onset_delay_hours INT,
    criticality_level VARCHAR(20) -- Low, Moderate, Life-Threatening
);