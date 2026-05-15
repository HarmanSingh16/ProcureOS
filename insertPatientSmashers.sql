-- 1. Regions (Higher density for stress testing)
INSERT INTO regions (region_name, compliance_protocol)
SELECT 
    'Region-' || i,
    'Protocol-' || (random() * 100)::int
FROM generate_series(1, 2000) AS i;

-- 2. Research Projects
INSERT INTO research_projects (project_name, start_date, budget_allocation, primary_investigator)
SELECT 
    'Project ' || chr((65 + (random() * 25)::int)) || i,
    CURRENT_DATE - (random() * 3650)::int,
    (random() * 5000000 + 100000)::decimal(15,2),
    'Investigator ' || i
FROM generate_series(1, 2000) AS i;

-- 3. Active Ingredients (APIs)
INSERT INTO active_ingredients (chemical_name, molecular_formula, hazard_level)
SELECT 
    'Compound-' || md5(i::text),
    'C' || (random()*20)::int || 'H' || (random()*40)::int || 'N' || (random()*5)::int,
    (random() * 4 + 1)::int
FROM generate_series(1, 2000) AS i;

-- 4. Medicines (The X, Y, Z logic)
INSERT INTO medicines (brand_name, therapeutic_class, development_status, base_unit_cost)
SELECT 
    'Med-' || i,
    (ARRAY['Oncology', 'Cardiology', 'Neurology', 'Immunology'])[floor(random() * 4 + 1)],
    (ARRAY['Research', 'Review', 'Distributed'])[floor(random() * 3 + 1)],
    (random() * 450 + 50)::decimal(10,2)
FROM generate_series(1, 2000) AS i;

-- 5. Medicine Composition (Linking Meds to APIs)
INSERT INTO medicine_composition (medicine_id, api_id, concentration_percentage)
SELECT 
    i, -- Ensures every medicine has at least one API
    floor(random() * 1999 + 1)::int,
    (random() * 99 + 1)::decimal(5,2)
FROM generate_series(1, 2000) AS i;

-- 6. Regulatory Submissions
INSERT INTO regulatory_submissions (medicine_id, region_id, submission_date, status, review_officer)
SELECT 
    i,
    floor(random() * 1999 + 1)::int,
    CURRENT_DATE - (random() * 1000)::int,
    (ARRAY['Pending', 'Under Review', 'Rejected', 'Approved'])[floor(random() * 4 + 1)],
    'Officer-' || (random() * 500)::int
FROM generate_series(1, 2000) AS i;

-- 7. Clinical Trials
INSERT INTO clinical_trials (project_id, medicine_id, phase, participant_count, success_rate_projected)
SELECT 
    i,
    i,
    (ARRAY['Phase I', 'Phase II', 'Phase III', 'Phase IV'])[floor(random() * 4 + 1)],
    (random() * 5000 + 100)::int,
    (random() * 100)::decimal(5,2)
FROM generate_series(1, 2000) AS i;

-- 8. Facilities
INSERT INTO facilities (region_id, facility_name, is_export_certified, operational_status)
SELECT 
    floor(random() * 1999 + 1)::int,
    'Facility-' || i,
    random() > 0.2,
    (ARRAY['Operational', 'Maintenance', 'Closed'])[floor(random() * 3 + 1)]
FROM generate_series(1, 2000) AS i;

INSERT INTO batches (medicine_id, facility_id, mfg_date, expiry_date, batch_purity_index)
SELECT 
    (SELECT medicine_id FROM medicines ORDER BY random() LIMIT 1),
    (SELECT facility_id FROM facilities ORDER BY random() LIMIT 1),
    CURRENT_DATE - (random() * 500)::int,
    CURRENT_DATE + (random() * 1000)::int,
    (80.00 + (random() * 19.99))::decimal(5,2)
FROM generate_series(1, 2000);


INSERT INTO shipments (batch_id, origin_facility_id, destination_region_id, shipping_mode, temperature_logged_min)
SELECT 
    b.batch_id,
    (SELECT facility_id FROM facilities ORDER BY random() LIMIT 1),
    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
    (ARRAY['Air', 'Sea', 'Road'])[floor(random() * 3 + 1)],
    (random() * 25 - 10)::decimal(5,2)
FROM batches b LIMIT 2000;


INSERT INTO distributors (region_id, distributor_name, credit_rating)
SELECT 
    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
    'Distributor-' || i,
    (ARRAY['AAA', 'AA', 'A', 'B'])[floor(random() * 4 + 1)]
FROM generate_series(1, 2000) AS i;


INSERT INTO outlets (distributor_id, outlet_name, city, is_hospital_linked)
SELECT 
    (SELECT distributor_id FROM distributors ORDER BY random() LIMIT 1),
    'Outlet-' || i,
    'City-' || (random() * 500)::int,
    random() > 0.5
FROM generate_series(1, 2000) AS i;


INSERT INTO patients (region_id, age, genetic_profile_summary, blood_group)
SELECT 
    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
    (random() * 80 + 1)::int,
    jsonb_build_object('marker', 'HLA-' || i, 'risk_factor', round(random()::numeric, 4)),
    (ARRAY['A+', 'A-', 'B+', 'O+', 'O-', 'AB+'])[floor(random() * 6 + 1)]
FROM generate_series(1, 2000) AS i;


INSERT INTO medical_history (patient_id, chronic_condition, severity_rank)
SELECT 
    (SELECT patient_id FROM patients ORDER BY random() LIMIT 1),
    (ARRAY['Diabetes', 'Hypertension', 'Asthma', 'Glaucoma'])[floor(random() * 4 + 1)],
    (random() * 9 + 1)::int
FROM generate_series(1, 2000) AS i;


INSERT INTO prescriptions (patient_id, medicine_id, outlet_id, prescribed_date)
SELECT 
    (SELECT patient_id FROM patients ORDER BY random() LIMIT 1),
    (SELECT medicine_id FROM medicines ORDER BY random() LIMIT 1),
    (SELECT outlet_id FROM outlets ORDER BY random() LIMIT 1),
    CURRENT_DATE - (random() * 365)::int
FROM generate_series(1, 2000) AS i;


INSERT INTO sales_transactions (batch_id, outlet_id, quantity_sold, unit_price_at_sale)
SELECT 
    (SELECT batch_id FROM batches ORDER BY random() LIMIT 1),
    (SELECT outlet_id FROM outlets ORDER BY random() LIMIT 1),
    (random() * 100 + 1)::int,
    (random() * 500 + 50)::decimal(10,2)
FROM generate_series(1, 2000) AS i;


INSERT INTO adverse_events (prescription_id, symptom_observed, onset_delay_hours, criticality_level)
SELECT 
    (SELECT prescription_id FROM prescriptions ORDER BY random() LIMIT 1),
    'Symptom observed: ' || md5(random()::text),
    (random() * 72)::int,
    (ARRAY['Low', 'Moderate', 'Life-Threatening'])[floor(random() * 3 + 1)]
FROM generate_series(1, 2000) AS i;