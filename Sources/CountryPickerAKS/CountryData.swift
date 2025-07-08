//
//  CountryModelList.swift
//
//
//  Created by Amit Shah on 14/11/23.
//

import Foundation

class CountryModelList {
    
    init() { }
    
    func getLocalCountryOnTop(data countryList: [CountryList]) -> [CountryList]{
        
        guard let localRegionCode = Locale.current.regionCode else {
            return countryList
        }
        
        // Find local country index more efficiently
        if let localIndex = countryList.firstIndex(where: { $0.code == localRegionCode }) {
            var result = countryList
            let localCountry = result.remove(at: localIndex)
            result.insert(localCountry, at: 0)
            return result
        }
        
        return countryList
    }
    
    func getCountryList(customize config: CustomizeCountryList) -> [CountryList]? {
        
        guard var countryList = dataList() else { return [] }
        
        if !config.addNew.isEmpty{
            countryList.append(contentsOf: config.addNew)
            countryList.sort { $0.name < $1.name }
        }
        
        var onTop = [CountryList]()
        var onBottom = [CountryList]()
        var onTopAfterLocal = [CountryList]()
        var displayOnly = Set<String>()
        var removeOnly = Set<String>()

        // Process all alterExisting rules and collect codes
        for item in config.alterExisting{
            switch item {
            case .onTop(let list):
                let (found, notFound) = extractCountries(from: &countryList, codes: list)
                onTop.append(contentsOf: found)
                logNotFound(notFound, operation: ".onTop")
                
            case .onTopAfterLocal(let list):
                let (found, notFound) = extractCountries(from: &countryList, codes: list)
                onTopAfterLocal.append(contentsOf: found)
                logNotFound(notFound, operation: ".onTopAfterLocal")
            
            case .onBottom(let list):
                let (found, notFound) = extractCountries(from: &countryList, codes: list)
                onBottom.append(contentsOf: found)
                logNotFound(notFound, operation: ".onBottom")
                
            case .displayOnly(let list):
                displayOnly.formUnion(list)
            
            case .removeOnly(let list):
                removeOnly.formUnion(list)
            }
        }
        
        // Apply filters
        if !removeOnly.isEmpty {
            countryList = countryList.filter { !removeOnly.contains($0.code) }
        }
        
        if !displayOnly.isEmpty {
            countryList = countryList.filter { displayOnly.contains($0.code) }
        }
        
        // Add countries to bottom
        if !onBottom.isEmpty {
            countryList.append(contentsOf: onBottom)
        }
        
        // Add local country on top if enabled
        countryList = config.showLocalOnTop ? getLocalCountryOnTop(data: countryList) : countryList
        
        // Add countries after local
        if !onTopAfterLocal.isEmpty {
            countryList.insert(contentsOf: onTopAfterLocal, at: 0)
        }
        
        // Add countries on top
        if !onTop.isEmpty {
            countryList.insert(contentsOf: onTop, at: 0)
        }

        return countryList
    }
    
    // Helper function to extract countries more efficiently
    private func extractCountries(from countryList: inout [CountryList], codes: [String]) -> ([CountryList], [String]) {
        var found = [CountryList]()
        var notFound = [String]()
        
        // Build lookup for remaining countries
        var remaining = [String: CountryList]()
        for country in countryList {
            remaining[country.code] = country
        }
        
        // Extract requested countries
        for code in codes {
            if let country = remaining[code] {
                found.append(country)
                remaining.removeValue(forKey: code)
            } else {
                notFound.append(code)
            }
        }
        
        // Update country list with remaining countries
        countryList = Array(remaining.values)
        
        return (found, notFound)
    }
    
    private func logNotFound(_ codes: [String], operation: String) {
        for code in codes {
            debugPrint("Not Found: \(operation) Country with code '\(code)' not found in the List")
        }
    }

    func countryList() -> [CountryList] {
        return dataList() ?? []
    }
        
    private func dataList() -> [CountryList]? {
        
        guard let url = Bundle._module.url(forResource: "countries", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            debugPrint("Error: Could not load countries.json file")
            return nil
        }
        
        do {
            return try JSONDecoder().decode([CountryList].self, from: jsonData)
        } catch {
            debugPrint("Error decoding JSON: \(error)")
            return nil
        }
    }
    
}
