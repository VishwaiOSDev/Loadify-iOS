//
//  VideoDetailsTest.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 12/06/22.
//

import XCTest
@testable import Loadify

class VideoInfoTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPublishedDate() {
        let publishedDateFromYT = "2022-06-10"
        let publishedDateVariationTwo = "1999-04-30"
        let date = "2000-01-01"
        
        let getYearOfPublishedDate = publishedDateFromYT.formatter(.year)
        let getMonthOfPublishedDate = publishedDateFromYT.formatter(.month)
        let getDateOfPublishedDate = publishedDateFromYT.formatter(.date)
        let getPublishedDate = publishedDateFromYT.formatter()
        
        let getYearOfVariationDate = publishedDateVariationTwo.formatter(.year)
        let getMonthOfVariationDate = publishedDateVariationTwo.formatter(.month)
        let getDateOfVariationDate = publishedDateVariationTwo.formatter(.date)
        let getPublishedVariationDate = publishedDateVariationTwo.formatter()
        
        let getPublishedYearForJan = date.formatter(.year)
        let getPublishedMonthForJan = date.formatter(.month)
        let getPublishedDateForJan = date.formatter(.date)
        let getCombinedDateForJan = date.formatter()
        let convertedDate = "\(getCombinedDateForJan) \(getPublishedYearForJan)"
        
        
        XCTAssertEqual(getYearOfPublishedDate, "2022")
        XCTAssertEqual(getMonthOfPublishedDate, "Jun")
        XCTAssertEqual(getDateOfPublishedDate, "10")
        XCTAssertEqual(getPublishedDate, "10 Jun")
        
        XCTAssertEqual(getYearOfVariationDate, "1999")
        XCTAssertEqual(getMonthOfVariationDate, "Apr")
        XCTAssertEqual(getDateOfVariationDate, "30")
        XCTAssertEqual(getPublishedVariationDate, "30 Apr")
        
        XCTAssertEqual(getPublishedYearForJan, "2000")
        XCTAssertEqual(getPublishedMonthForJan, "Jan")
        XCTAssertEqual(getPublishedDateForJan, "1")
        XCTAssertEqual(getCombinedDateForJan, "1 Jan")
        XCTAssertEqual(convertedDate, "1 Jan 2000")
    }
    
    func testPublishedDateWithWrongInputs() {
        let invaildSingleRangeDate = "20220610"
        let invaildTwoRange = "2022-06"
        let wrongInput = "applle-marg-wqrq"
        let publishedDateWithTwoCorrectValues = "2022-06-13fh"
        let dateWithInvaildInputs = "20222-12-12"
        let dateWithInvaildMonthRange = "20222-126-12"
        let dateWithInvaildDateRange = "20222-01-64"
        
        let getInvaildRangeDateYear = invaildSingleRangeDate.formatter(.year)
        let getInvaildSingleRaneDateMonth = invaildSingleRangeDate.formatter(.month)
        let getInvaildSingleRangeDateDate = invaildSingleRangeDate.formatter(.date)
        let getInvaildSingleRangeDate = invaildSingleRangeDate.formatter()
        
        let getInvaildTwoRangeDateYear = invaildTwoRange.formatter(.year)
        let getInvaildTwoRangeDateMonth = invaildTwoRange.formatter(.month)
        let getInvaildTwoRangeDateDate = invaildTwoRange.formatter(.date)
        let getInvaildTwoRangeDate = invaildTwoRange.formatter()
        
        let getDateWithInvaildInputs = dateWithInvaildInputs.formatter(.year)
        let getMonthWithInvaildInputs = dateWithInvaildInputs.formatter(.month)
        let getYearWithInvaildInputs = dateWithInvaildInputs.formatter(.date)
        let getFullDateWithInvaildInputs = dateWithInvaildInputs.formatter()
        
        XCTAssertEqual(getInvaildRangeDateYear, "Not Mentioned")
        XCTAssertEqual(getInvaildSingleRaneDateMonth, "Not Mentioned")
        XCTAssertEqual(getInvaildSingleRangeDateDate, "Not Mentioned")
        XCTAssertEqual(getInvaildSingleRangeDate, "Not Mentioned")
        
        XCTAssertEqual(getInvaildTwoRangeDateYear, "Not Mentioned")
        XCTAssertEqual(getInvaildTwoRangeDateMonth, "Not Mentioned")
        XCTAssertEqual(getInvaildTwoRangeDateDate, "Not Mentioned")
        XCTAssertEqual(getInvaildTwoRangeDate, "Not Mentioned")
        
        XCTAssertEqual(wrongInput.formatter(.year), "Not Mentioned")
        XCTAssertEqual(wrongInput.formatter(.month), "Not Mentioned")
        XCTAssertEqual(wrongInput.formatter(.date), "Not Mentioned")
        XCTAssertEqual(wrongInput.formatter(), "Not Mentioned")
        
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formatter(.year), "Not Mentioned")
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formatter(.month), "Not Mentioned")
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formatter(.date), "Not Mentioned")
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formatter(), "Not Mentioned")
        
        XCTAssertEqual(getDateWithInvaildInputs, "Not Mentioned")
        XCTAssertEqual(getMonthWithInvaildInputs, "Not Mentioned")
        XCTAssertEqual(getYearWithInvaildInputs, "Not Mentioned")
        XCTAssertEqual(getFullDateWithInvaildInputs, "Not Mentioned")
        
        XCTAssertEqual(dateWithInvaildMonthRange.formatter(.year), "Not Mentioned")
        XCTAssertEqual(dateWithInvaildMonthRange.formatter(.month), "Not Mentioned")
        XCTAssertEqual(dateWithInvaildMonthRange.formatter(.date), "Not Mentioned")
        XCTAssertEqual(dateWithInvaildMonthRange.formatter(), "Not Mentioned")
        
        XCTAssertEqual(dateWithInvaildDateRange.formatter(.year), "Not Mentioned")
        XCTAssertEqual(dateWithInvaildDateRange.formatter(.month), "Not Mentioned")
        XCTAssertEqual(dateWithInvaildDateRange.formatter(.date), "Not Mentioned")
        XCTAssertEqual(dateWithInvaildDateRange.formatter(), "Not Mentioned")
    }
    
    func testViewsFormatter() {
        let noViews = "0"
        let hundredView = "100"
        let fiveThousandViews = "5240"
        let twentyThousandViews = "29315"
        let fiveLakhViews = "575013"
        let sixMillionViews = "6271013"
        let twentyMillionViews = "26271013"
        let twoBillionViews = "2640271013"
        let despacitoViews = "7867743031"
        let invaildViews = "1351hfh2462462"
        
        let noViewsConverted = noViews.format
        let hundredViewConverted = hundredView.format
        let fiveThousandViewsConverted = fiveThousandViews.format
        let twentyThousandViewsConverted = twentyThousandViews.format
        let fiveLakhViewsConverted = fiveLakhViews.format
        let sixMillionViewsConverted = sixMillionViews.format
        let twentyMillionViewsConverted = twentyMillionViews.format
        let twoBillionViewsConverted = twoBillionViews.format
        let despacitoViewsConverted = despacitoViews.format
        let invaildViewsConverted = invaildViews.format
        
        XCTAssertEqual(noViewsConverted, "0")
        XCTAssertEqual(hundredViewConverted, "100")
        XCTAssertEqual(fiveThousandViewsConverted, "5,240")
        XCTAssertEqual(twentyThousandViewsConverted, "29,315")
        XCTAssertEqual(fiveLakhViewsConverted, "575,013")
        XCTAssertEqual(sixMillionViewsConverted, "6,271,013")
        XCTAssertEqual(twentyMillionViewsConverted, "26,271,013")
        XCTAssertEqual(twoBillionViewsConverted, "2,640,271,013")
        XCTAssertEqual(despacitoViewsConverted, "7,867,743,031")
        XCTAssertEqual(invaildViewsConverted, "Hidden")
    }
    
    func testVideoLikes() {
        let noLikes = 0
        let tenLikes = 10
        let hundredLikes = 100
        let thousandLikes = 1_000
        let thousandTwentyLikes = 1_020
        let thousandTwoHundredLikes = 1_200
        let thousandTwoFiftyLikes = 1_250
        let thousandTwoNinetyNineLike = 1_299
        let fiftyThousandLikes = 50_500
        let ninetyOneThousandLikes = 91_000
        let oneMillionLikes = 1_000_000
        let onePointFiveMillionLikes = 1_500_000
        let tenBillionLikes = 10_000_000_000
        let despacitoLikes = 7_867_743_031
        
        let noLikesString = noLikes.toUnits
        let tenLikesString = tenLikes.toUnits
        let hundredLikesString = hundredLikes.toUnits
        let thousandLikesString = thousandLikes.toUnits
        let thousandTwentyLikesString = thousandTwentyLikes.toUnits
        let thousandTwoHundredLikesString = thousandTwoHundredLikes.toUnits
        let thousandTwoFiftyLikesString = thousandTwoFiftyLikes.toUnits
        let thousandTwoNinetyNineLikeString = thousandTwoNinetyNineLike.toUnits
        let fiftyThousandLikesLikeString = fiftyThousandLikes.toUnits
        let ninetyOneThousandLikesString = ninetyOneThousandLikes.toUnits
        let oneMillionLikesString = oneMillionLikes.toUnits
        let onePointFiveMillionLikesString = onePointFiveMillionLikes.toUnits
        let tenBillionLikesString = tenBillionLikes.toUnits
        let despacitoLikesString = despacitoLikes.toUnits
        
        XCTAssertEqual(noLikesString, "0")
        XCTAssertEqual(tenLikesString, "10")
        XCTAssertEqual(hundredLikesString, "100")
        XCTAssertEqual(thousandLikesString, "1.0K")
        XCTAssertEqual(thousandTwentyLikesString, "1.0K")
        XCTAssertEqual(thousandTwoHundredLikesString, "1.2K")
        XCTAssertEqual(thousandTwoFiftyLikesString, "1.2K")
        XCTAssertEqual(thousandTwoNinetyNineLikeString, "1.2K")
        XCTAssertEqual(fiftyThousandLikesLikeString, "50.5K")
        XCTAssertEqual(ninetyOneThousandLikesString, "91.0K")
        XCTAssertEqual(oneMillionLikesString, "1.0M")
        XCTAssertEqual(onePointFiveMillionLikesString, "1.5M")
        XCTAssertEqual(tenBillionLikesString, "10.0B")
        XCTAssertEqual(despacitoLikesString, "7.8B")
    }
    
    func testVideoDuration() {
        let secondsAboveOneMin: String = "98"
        let secondsBelowOneMin: String = "35"
        let secondsAboveTwoMin: String = "180"
        let secondsAboveFourMin: String = "250"
        let secondsAboveOneHour: String = "5000"
        let secondsAboveTwoHour: String = "8523"
        let secondsAboveEightySevenHour: String = "313551"
        let invaildSeconds: String = "Vishwa"
        let emptySeconds: String = ""
        
        let aboveOneMin = secondsAboveOneMin.getDuration
        let belowOneMin = secondsBelowOneMin.getDuration
        let aboveTwoMin = secondsAboveTwoMin.getDuration
        let aboveFourMin = secondsAboveFourMin.getDuration
        let aboveOneHour = secondsAboveOneHour.getDuration
        let aboveTwoHour = secondsAboveTwoHour.getDuration
        let aboveEightySevenHour = secondsAboveEightySevenHour.getDuration
        let invaildDuration = invaildSeconds.getDuration
        let emptyDuration = emptySeconds.getDuration
        
        XCTAssertEqual(aboveOneMin, "1:38")
        XCTAssertEqual(belowOneMin, "0:35")
        XCTAssertEqual(aboveTwoMin, "3:00")
        XCTAssertEqual(aboveFourMin, "4:10")
        XCTAssertEqual(aboveOneHour, "1:23:20")
        XCTAssertEqual(aboveTwoHour, "2:22:03")
        XCTAssertEqual(aboveEightySevenHour, "87:05:51")
        XCTAssertEqual(invaildDuration, "Duration Unavailable")
        XCTAssertEqual(emptyDuration, "Duration Unavailable")
    }
}
