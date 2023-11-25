-- Active: 1700718336633@@127.0.0.1@5000@vet_clinic
CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name varchar,
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
    PRIMARY KEY (id)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(100);
