//
//  FlickSearchTests.swift
//  FlickSearchTests
//
//  Created by Eslam Shaker on 26/10/2021.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import FlickSearch

class FlickSearchTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var getPhotosSuccessData: Data!
    var viewModel: SearchViewModel!
    var networkManager: NetworkManager!
    let timeOut: Double = 10
    let searchString = "kitten"
   
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        viewModel = SearchViewModel()
    }

    override func tearDown() {
        viewModel = nil 
        networkManager = nil
        getPhotosSuccessData = nil
    }
    
    func testViewModelInitialState() {
        XCTAssertTrue(viewModel.outputs.dataSubject.value.isEmpty)
        XCTAssertEqual(viewModel.outputs.screenTitle, "Flickr Search")
    }

    func testSearchSuccess() {
        // Given
        getPhotosSuccessData = Utils.MockResponseType.successFlickerData.sampleDataFor(self)
        let session = getMockSessionFor(getPhotosSuccessData)
        networkManager = NetworkManager(manager: session, unitTestSession: session, requiresValidation: false)
        viewModel = SearchViewModel(networkManager: networkManager)
        
        // When
        let photoObserver = scheduler.createObserver([PhotoItemViewModel].self)
        viewModel.outputs
            .dataSubject.bind(to: photoObserver)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, searchString)])
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        scheduler.start()
        
        // Then
        let kittenElement = photoObserver.events.last?.value.element
        XCTAssertEqual(kittenElement?.count, 100)
    }


}
