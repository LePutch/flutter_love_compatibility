import json
import random

signes = ["Bélier", "Taureau", "Gémeaux", "Cancer", "Lion", "Vierge", "Balance", "Scorpion", "Sagittaire", "Capricorne", "Verseau", "Poissons"]

compatibilities = []

for signe1 in signes:
    for signe2 in signes:
        if signe1 != signe2:
            compatibilite = random.randint(0, 100)
            compatibility_entry = {"signe1": signe1, "signe2": signe2, "compatibilite": compatibilite}
            compatibilities.append(compatibility_entry)

data = {"compatibilities": compatibilities}

with open('compatibilities.json', 'w') as json_file:
    json.dump(data, json_file, indent=2)

print("Fichier JSON généré avec succès.")
