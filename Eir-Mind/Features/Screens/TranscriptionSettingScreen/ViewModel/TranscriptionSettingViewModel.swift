//
//  TranscriptionSettingViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import SwiftUI

final class TranscriptionSettingViewModel: ObservableObject {
    
    // MARK: - Init()
    // MARK: - Body
    // MARK: - Private Variables and Properties
    // MARK: -

    
    // MARK: - Helpers
    func transcriptionSettings() {
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.transcriptionSettingsEndPoint,
                                                method: .post) { (result: Result<GenericResponse<EmptyData>, Error>) in
            
            switch result {
            case.success(let response):
                print(response)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
