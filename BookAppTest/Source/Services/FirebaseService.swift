//
//  AnyArticlesRepository.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import FirebaseRemoteConfig

struct VoidAnswer: AnyRequestAnswer {}

protocol AnyFirebaseService {
    func fetchBooks() async -> Result<RootModel, Error>
}

final class FirebaseService: AnyFirebaseService, InjectableViaInit {
    typealias Dependencies = (RemoteConfig)
    
    // MARK: - Private Properties
    
    private let remoteConfig: RemoteConfig
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (remoteConfig) = dependencies
    }
    
    // MARK: - Methods

    func fetchBooks() async -> Result<RootModel, Error> {
        do {
            try remoteConfig.setDefaults(from: ["json_data": "Default JSON or empty string"])

            let status = try await remoteConfig.fetch(withExpirationDuration: 0)
            
            guard status == .success || status == .throttled else {
                return .failure("")
            }
            
            _ = try await remoteConfig.activate()
            
            let data = remoteConfig.configValue(forKey: "json_data").dataValue
            
            let result = try RootModel(data: data)
            
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
