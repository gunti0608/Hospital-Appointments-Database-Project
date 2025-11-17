--TABLE CREATION 

CREATE TABLE "patients" (
	"patient_id"	INTEGER,
	"name"	TEXT NOT NULL,
	"gender"	TEXT,
	"dob"	TEXT,
	"age"	INTEGER,
	"satisfaction"	TEXT,
	"address"	TEXT,
	"height_cm"	INTEGER,
	"weight_kg"	INTEGER,
	PRIMARY KEY("patient_id")
);

CREATE TABLE "doctors" (
	"doctor_id"	INTEGER,
	"name"	TEXT NOT NULL,
	"gender"	TEXT,
	"specialty"	TEXT,
	"years_experience"	INTEGER,
	"rating"	TEXT,
	PRIMARY KEY("doctor_id")
);

CREATE TABLE "appointments" (
	"appointment_id"	INTEGER,
	"patient_id"	INTEGER NOT NULL,
	"doctor_id"	INTEGER NOT NULL,
	"scheduled_time"	TEXT,
	"status"	TEXT,
	"urgency_level"	TEXT,
	"pain_score"	INTEGER,
	"bill_amount"	REAL,
	PRIMARY KEY("appointment_id"),
	FOREIGN KEY("doctor_id") REFERENCES "doctors"("doctor_id"),
	FOREIGN KEY("patient_id") REFERENCES "patients"("patient_id")
);

CREATE TABLE "prescriptions" (
	"prescription_id"	INTEGER,
	"appointment_id"	INTEGER NOT NULL,
	"medication_name"	TEXT,
	"dosage_mg"	INTEGER,
	"instructions"	TEXT,
	PRIMARY KEY("prescription_id"),
	FOREIGN KEY("appointment_id") REFERENCES "appointments"("appointment_id")
);
--1. Data Viewing: Preview First Few Rows

SELECT * FROM Patients LIMIT 5;
SELECT * FROM Doctors LIMIT 5;
SELECT * FROM Appointments LIMIT 5;
SELECT * FROM Prescriptions LIMIT 5;

--2. Missing Value Count Per Column
--Patients Table:

SELECT
  SUM(patient_id IS NULL) AS miss_patient_id,
  SUM(name IS NULL) AS miss_name,
  SUM(gender IS NULL) AS miss_gender,
  SUM(dob IS NULL) AS miss_dob,
  SUM(age IS NULL) AS miss_age,
  SUM(satisfaction IS NULL) AS miss_satisfaction,
  SUM(address IS NULL) AS miss_address,
  SUM(height_cm IS NULL) AS miss_height_cm,
  SUM(weight_kg IS NULL) AS miss_weight_kg
FROM Patients;


--Doctors Table:
SELECT
  SUM(doctor_id IS NULL) AS miss_doctor_id,
  SUM(name IS NULL) AS miss_name,
  SUM(gender IS NULL) AS miss_gender,
  SUM(specialty IS NULL) AS miss_specialty,
  SUM(years_experience IS NULL) AS miss_years_experience,
  SUM(rating IS NULL) AS miss_rating
FROM Doctors;

--Appointments Table:
SELECT
  SUM(appointment_id IS NULL) AS miss_appointment_id,
  SUM(patient_id IS NULL) AS miss_patient_id,
  SUM(doctor_id IS NULL) AS miss_doctor_id,
  SUM(scheduled_time IS NULL) AS miss_scheduled_time,
  SUM(status IS NULL) AS miss_status,
  SUM(urgency_level IS NULL) AS miss_urgency_level,
  SUM(pain_score IS NULL) AS miss_pain_score,
  SUM(bill_amount IS NULL) AS miss_bill_amount
FROM Appointments;

--Prescriptions Table:
SELECT
  SUM(prescription_id IS NULL) AS miss_prescription_id,
  SUM(appointment_id IS NULL) AS miss_appointment_id,
  SUM(medication_name IS NULL) AS miss_medication_name,
  SUM(dosage_mg IS NULL) AS miss_dosage_mg,
  SUM(instructions IS NULL) AS miss_instructions
FROM Prescriptions;

--3. Preprocessing: Replace NULL Values
--Patients Table:
--Replace TEXT NULLs with "unknown"; Numeric NULLs with 0.

UPDATE Patients
SET
  gender = COALESCE(gender, 'unknown'),
  satisfaction = COALESCE(satisfaction, 'unknown'),
  address = COALESCE(address, 'unknown'),
  dob = COALESCE(dob, 'unknown'),
  age = COALESCE(age, 0),
  height_cm = COALESCE(height_cm, 0),
  weight_kg = COALESCE(weight_kg, 0);
  
  
--Doctors Table:
UPDATE Doctors
SET
  gender = COALESCE(gender, 'unknown'),
  specialty = COALESCE(specialty, 'unknown'),
  rating = COALESCE(rating, 'unknown'),
  years_experience = COALESCE(years_experience, 0);
  
--Appointments Table:
UPDATE Appointments
SET
  status = COALESCE(status, 'unknown'),
  urgency_level = COALESCE(urgency_level, 'unknown'),
  scheduled_time = COALESCE(scheduled_time, 'unknown'),
  pain_score = COALESCE(pain_score, 0),
  bill_amount = COALESCE(bill_amount, 0);

--Prescriptions Table:
UPDATE Prescriptions
SET
  medication_name = COALESCE(medication_name, 'unknown'),
  dosage_mg = COALESCE(dosage_mg, 0),
  instructions = COALESCE(instructions, 'unknown');

--4. Check That NULLs Are Replaced
--Appointments Table:

SELECT * FROM Appointments
WHERE status IS NULL OR urgency_level IS NULL OR scheduled_time IS NULL OR pain_score IS NULL OR bill_amount IS NULL;

--Prescriptions Table:

SELECT * FROM Prescriptions
WHERE medication_name IS NULL OR dosage_mg IS NULL OR instructions IS NULL;

--Patients table 
SELECT * FROM Patients WHERE patient_id IS NULL OR name IS NULL OR gender IS NULL OR dob IS NULL OR age IS NULL OR satisfaction IS NULL OR address IS NULL OR height_cm IS NULL OR weight_kg IS NULL;

--doctors table 
SELECT * FROM Doctors WHERE doctor_id IS NULL OR name IS NULL OR gender IS NULL OR specialty IS NULL OR years_experience IS NULL OR rating IS NULL;


--5. Data Understanding & Aggregates (example queries)
--a. Average Bill Amount Per Doctor

SELECT Doctors.name, AVG(Appointments.bill_amount) AS avg_bill, COUNT(Appointments.appointment_id) AS total_appointments
FROM Appointments
JOIN Doctors ON Appointments.doctor_id = Doctors.doctor_id
GROUP BY Doctors.doctor_id
ORDER BY avg_bill DESC
LIMIT 5;

--b. Pain Score Distribution
SELECT pain_score, COUNT(*) AS frequency
FROM Appointments
GROUP BY pain_score
ORDER BY pain_score;

--c. Common Specialties Among Doctors
SELECT specialty, COUNT(*) AS num_doctors
FROM Doctors
GROUP BY specialty
ORDER BY num_doctors DESC;

--d. Urgency Level in Appointments
SELECT urgency_level, COUNT(*) AS count
FROM Appointments
GROUP BY urgency_level
ORDER BY count DESC;

--e. Patients With Most Appointments
SELECT Patients.name, COUNT(Appointments.patient_id) AS num_appointments
FROM Appointments
JOIN Patients ON Appointments.patient_id = Patients.patient_id
GROUP BY Patients.patient_id
ORDER BY num_appointments DESC
LIMIT 10;