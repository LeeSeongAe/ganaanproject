//
//  GanaanYouthUITests.swift
//  GanaanYouthUITests
//
//  Created by Yujin Robot on 06/01/2020.
//  Copyright © 2020 Yujinrobot. All rights reserved.
//

import XCTest

class GanaanYouthUITests: XCTestCase {

    override func setUp() {
        
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let app = XCUIApplication()
                app.launch()
        
        app.buttons["Join"].tap()
        app.navigationBars["JOIN"].buttons["cancel"].tap()
        
        app.buttons["TEST"].tap()
        app.buttons["Log In"].tap()
        app.navigationBars["GanaanYouth.IntroView"].buttons["Item"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Cell"]/*[[".cells.staticTexts[\"Cell\"]",".staticTexts[\"Cell\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        app.navigationBars["GanaanYouth.CellCollectionView"].buttons["Item"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Photo"]/*[[".cells.staticTexts[\"Photo\"]",".staticTexts[\"Photo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
       	app.navigationBars["GanaanYouth.PhotoView"].buttons["Item"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Introduce"]/*[[".cells.staticTexts[\"Introduce\"]",".staticTexts[\"Introduce\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(1)
        app.navigationBars["GanaanYouth.IntroduceView"].buttons["line.horizontal.3"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Home"]/*[[".cells.staticTexts[\"Home\"]",".staticTexts[\"Home\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(1)
        
        app.buttons["Notify"].tap()
        app.alerts["준비중입니다"].scrollViews.otherElements.buttons["확인"].tap()
        app.navigationBars["GanaanYouth.IntroView"].buttons["Item"].tap()
        
        let app2 = app
        app2.tables/*@START_MENU_TOKEN@*/.staticTexts["Photo"]/*[[".cells.staticTexts[\"Photo\"]",".staticTexts[\"Photo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
