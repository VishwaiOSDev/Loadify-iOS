//
//  VideoDetailsTest.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 12/06/22.
//

import XCTest
@testable import Loadify

class VideoInfoTest: XCTestCase {
    
    func testFormattedDate() {
        let publishedDateFromYT = "2022-12-12T07:05:08-08:00"
        let publishedDateVariationTwo = "2023-11-25T14:30:00-05:00"
        let date = "2021-08-18T10:45:20-03:00"
        let randomDate = "2024-04-30T08:15:55+02:00"
        
        // Test cases for the new format (YYYY-MM-DDTHH:MM:SS-TZ)
        XCTAssertEqual(publishedDateFromYT.formattedDate(.year), "2022")
        XCTAssertEqual(publishedDateFromYT.formattedDate(.month), "December")
        XCTAssertEqual(publishedDateFromYT.formattedDate(.date), "12")
        XCTAssertEqual(publishedDateFromYT.formattedDate(), "12 Dec")
        
        XCTAssertEqual(publishedDateVariationTwo.formattedDate(.year), "2023")
        XCTAssertEqual(publishedDateVariationTwo.formattedDate(.month), "November")
        XCTAssertEqual(publishedDateVariationTwo.formattedDate(.date), "25")
        XCTAssertEqual(publishedDateVariationTwo.formattedDate(), "25 Nov")
        
        XCTAssertEqual(date.formattedDate(.year), "2021")
        XCTAssertEqual(date.formattedDate(.month), "August")
        XCTAssertEqual(date.formattedDate(.date), "18")
        XCTAssertEqual(date.formattedDate(), "18 Aug")
        
        XCTAssertEqual(randomDate.formattedDate(.year), "2024")
        XCTAssertEqual(randomDate.formattedDate(.month), "April")
        XCTAssertEqual(randomDate.formattedDate(.date), "30")
        XCTAssertEqual(randomDate.formattedDate(), "30 Apr")
    }
    
    
    func testFormattedDateWithWrongInputs() {
        let invalidSingleRangeDate = "20220610"
        let invalidTwoRange = "2022-06"
        let wrongInput = "applle-marg-wqrq"
        let publishedDateWithTwoCorrectValues = "2022-06-13fh"
        let dateWithInvalidInputs = "20222-12-12"
        let dateWithInvalidMonthRange = "20222-126-12"
        let dateWithInvalidDateRange = "20222-01-64"
        
        // Invalid single-range date
        XCTAssertEqual(invalidSingleRangeDate.formattedDate(.year), "N/A")
        XCTAssertEqual(invalidSingleRangeDate.formattedDate(.month), "N/A")
        XCTAssertEqual(invalidSingleRangeDate.formattedDate(.date), "N/A")
        XCTAssertEqual(invalidSingleRangeDate.formattedDate(), "N/A")
        
        // Invalid two-range date
        XCTAssertEqual(invalidTwoRange.formattedDate(.year), "N/A")
        XCTAssertEqual(invalidTwoRange.formattedDate(.month), "N/A")
        XCTAssertEqual(invalidTwoRange.formattedDate(.date), "N/A")
        XCTAssertEqual(invalidTwoRange.formattedDate(), "N/A")
        
        // Invalid input
        XCTAssertEqual(wrongInput.formattedDate(.year), "N/A")
        XCTAssertEqual(wrongInput.formattedDate(.month), "N/A")
        XCTAssertEqual(wrongInput.formattedDate(.date), "N/A")
        XCTAssertEqual(wrongInput.formattedDate(), "N/A")
        
        // Date with mixed valid and invalid characters
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formattedDate(.year), "N/A")
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formattedDate(.month), "N/A")
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formattedDate(.date), "N/A")
        XCTAssertEqual(publishedDateWithTwoCorrectValues.formattedDate(), "N/A")
        
        // Date with invalid year format
        XCTAssertEqual(dateWithInvalidInputs.formattedDate(.year), "N/A")
        XCTAssertEqual(dateWithInvalidInputs.formattedDate(.month), "N/A")
        XCTAssertEqual(dateWithInvalidInputs.formattedDate(.date), "N/A")
        XCTAssertEqual(dateWithInvalidInputs.formattedDate(), "N/A")
        
        // Date with invalid month range
        XCTAssertEqual(dateWithInvalidMonthRange.formattedDate(.year), "N/A")
        XCTAssertEqual(dateWithInvalidMonthRange.formattedDate(.month), "N/A")
        XCTAssertEqual(dateWithInvalidMonthRange.formattedDate(.date), "N/A")
        XCTAssertEqual(dateWithInvalidMonthRange.formattedDate(), "N/A")
        
        // Date with invalid date range
        XCTAssertEqual(dateWithInvalidDateRange.formattedDate(.year), "N/A")
        XCTAssertEqual(dateWithInvalidDateRange.formattedDate(.month), "N/A")
        XCTAssertEqual(dateWithInvalidDateRange.formattedDate(.date), "N/A")
        XCTAssertEqual(dateWithInvalidDateRange.formattedDate(), "N/A")
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
        let noLikes: Int? = 0
        let tenLikes: Int? = 10
        let hundredLikes: Int? = 100
        let thousandLikes: Int? = 1_000
        let thousandTwentyLikes: Int? = 1_020
        let thousandTwoHundredLikes: Int? = 1_200
        let thousandTwoFiftyLikes: Int? = 1_250
        let thousandTwoNinetyNineLike: Int? = 1_299
        let fiftyThousandLikes: Int? = 50_500
        let ninetyOneThousandLikes: Int? = 91_000
        let oneMillionLikes: Int? = 1_000_000
        let onePointFiveMillionLikes: Int? = 1_500_000
        let tenBillionLikes: Int? = 10_000_000_000
        let despacitoLikes: Int? = 7_867_743_031
        
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
