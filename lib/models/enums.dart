enum SectorType { agriculture, production, logistics, trade, finance, technology }

enum BuildingType {
  // Katman 1 — Ham Madde
  farm, mine, forest, ranch, quarry,
  // Katman 2 — İşleme
  mill, ironFactory, woodProcessing, dairyFactory, textileFactory,
  // Katman 3 — Üretim
  bakery, steelFactory, furnitureFactory, clothingFactory,
  readyFoodFactory, machineFactory,
  // Katman 4 — Ticaret
  market, supermarket, furnitureStore, clothingStore, industrialStore,
  // Katman 5 — Nakliye & İhracat
  warehouse, truckGarage, port, airCargoTerminal, trainStation,
  // Destek
  headquarters, researchCenter, bank, powerPlant,
}

enum ProductType {
  // Tarım — Ham
  wheat, sugarCane, cotton, corn,
  // Hayvan — Ham
  milk, wool, meat, egg,
  // Maden — Ham
  ironOre, copperOre, sand, coal, stone,
  // Orman — Ham
  timber,
  // Katman 2 — İşlenmiş
  flour, cornFlour, sugar, cheese, yogurt, fabric,
  rawIron, copper, steel, glass, processedWood,
  // Katman 3 — Üretim
  bread, cake, machine, electronic, furniture, premiumFurniture,
  clothing, smartClothing, burger, pizza,
}

enum ProductCategory { rawAgri, rawAnimal, rawMining, rawForest, processed, manufactured }

enum SaleChannel {
  market, supermarket, furnitureStore, clothingStore,
  electronicStore, industrialStore, restaurant, port, airCargoTerminal,
}

enum BuildingStatus { idle, producing, waitingInput, storageFull, noEnergy }

enum ManagerLevel { none, intern, expert, manager, director, ceo }

enum ContractType { cityOrder, b2bOrder, vipOrder, exportContract, urgentOrder }

enum ContractStatus { available, active, completed, expired }

enum ResearchBranch {
  agriculture, production, logistics, trade, finance, technology, inventory
}
