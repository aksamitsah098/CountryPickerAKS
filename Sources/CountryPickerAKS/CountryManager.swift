//
//  CountryManager.swift
//
//
//  Created by Amit Shah on 04/02/2025.
//

import Foundation

public class CountryManager {
    
    public static let shared: CountryManager = CountryManager()
    private var countries: [CountryList] = []
    
    // Lookup dictionaries for O(1) performance
    private var countryByCode: [String: CountryList] = [:]
    private var countryByName: [String: CountryList] = [:]
    private var countryByDialCode: [String: CountryList] = [:]
    private var countryByEmoji: [String: CountryList] = [:]
    
    private init() {
         countries = CountryModelList().countryList()
         buildLookupDictionaries()
    }
    
    private func buildLookupDictionaries() {
        for country in countries {
            countryByCode[country.code.lowercased()] = country
            countryByName[country.name.lowercased()] = country
            countryByDialCode[country.dial_code] = country
            countryByEmoji[country.emoji] = country
        }
    }
    
    public func country(withCode code: String) -> CountryList? {
        return countryByCode[code.lowercased()]
    }
    
    public func country(withName name: String) -> CountryList? {
        return countryByName[name.lowercased()]
    }
    
    public func country(withDialCode dialCode: String) -> CountryList? {
        let formattedDialCode = dialCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalDialCode = formattedDialCode.hasPrefix("+") ? formattedDialCode : "+" + formattedDialCode
        return countryByDialCode[finalDialCode]
    }
    
    public func country(withEmoji emoji: String) -> CountryList? {
        return countryByEmoji[emoji]
    }
    
    // Provide access to all countries for efficient operations
    public func allCountries() -> [CountryList] {
        return countries
    }
}