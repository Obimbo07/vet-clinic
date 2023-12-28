SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3 LIMIT 100 OFFSET 0;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;   // const user = userData ? JSON.parse(userData) : null



BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;


BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;


BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;


BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT before_weight_update;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO before_weight_update;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;


SELECT COUNT(*) AS total_animals
FROM animals;
SELECT COUNT(*) AS non_escaping_animals
FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS average_weight
FROM animals;

SELECT neutered, COUNT(*) AS escape_count
FROM animals
WHERE escape_attempts > 0
GROUP BY neutered;

SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;


-- What animals belong to Melody Pond?
SELECT a.*
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';


-- List of all animals that are Pokemon (their type is Pokemon).
SELECT a.*
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';


-- List all owners and their animals, remembering to include those that don't own any animal
SELECT o.full_name, a.*
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT s.name AS species, COUNT(*) AS animal_count
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;

-- #List all Digimon owned by Jennifer Orwell.
SELECT a.*
FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- #List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.*
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

#Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- #Who was the last animal seen by William Tatcher?
SELECT a.*
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
WHERE vet.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- #How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS animal_count
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
WHERE vet.name = 'Stephanie Mendez';

-- #List all vets and their specialties, including vets with no specialties.
SELECT vet.name, COALESCE(sp.name, 'No Specialty') AS specialty
FROM vets vet
LEFT JOIN specializations s ON vet.id = s.vet_id
LEFT JOIN species sp ON s.species_id = sp.id;

-- #List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.*
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
WHERE vet.name = 'Stephanie Mendez' AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- #What animal has the most visits to vets?
SELECT a.id, a.name, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
GROUP BY a.id, a.name
ORDER BY visit_count DESC
LIMIT 1;

-- #Who was Maisy Smith's first visit?
SELECT a.*
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
WHERE vet.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;

-- #Details for the most recent visit: animal information, vet information, and date of visit.
SELECT a.*, vet.name AS vet_name, v.visit_date
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
ORDER BY v.visit_date DESC
LIMIT 1;

-- #How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS mismatched_visits
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
LEFT JOIN specializations s ON vet.id = s.vet_id AND a.species_id = s.species_id
WHERE s.vet_id IS NULL;

-- #What specialty should Maisy Smith consider getting? 
SELECT sp.name AS recommended_specialty, COUNT(*) AS visits_count
FROM visits v
JOIN vets vet ON v.vet_id = vet.id
JOIN animals a ON v.animal_id = a.id
JOIN species sp ON a.species_id = sp.id
WHERE vet.name = 'Maisy Smith'
GROUP BY sp.name
ORDER BY visits_count DESC
LIMIT 1;