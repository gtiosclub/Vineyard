//
//  DatabaseServiceProtocol.swift
//  Vineyard
//
//  Created by Vishnesh Jayanthi Ramanathan on 16/09/24.

protocol DatabaseServiceProtocol {
    
    // Database functions to fetch entries
    func fetchGroupFromDB(groupID: String) async throws -> Group?
    func fetchPeopleFromDB(peopleIDs: [String]) async throws -> [Person]
    func fetchResolutionsFromDB(resolutionIDs: [String]) async throws -> [Resolution]
    
    
    // Database functions to add entries
    func addPersonToDB(person: Person) async throws
    func addResolutionToDB(resolution: Resolution) async throws
    func addGroupToDB(group: Group) async throws
    
    // Database functions to modify entries
    
    // Database functions to delete entries
    
    
}
